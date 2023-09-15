----------------------------------------------------------------------------------------------------------------------------------
-- 体质值 模块
--[[
    · 所有体质值有关的数据储存在本模块里面，使用 Get(str) ,Set(str,num) 的形式。虽然有点多此一举，但是数据不易乱。

    · 子项目使用 inst 实体挂载为玩家的child，这些 inst 里不储存任何离线数据，只有执行函数、临时参数、临时函数。
    · 子节点只有一层，不会有多层子节点。
    · 数据使用 json_str 通过net_string 下发给 replica 。net_string 在replica 注册

    · 常驻子项目有 【体质值】【VC值】【血糖值】【中毒值】
    · update 周期为 5s
    ·【体质值】字段： wellness
    ·【VC值】 字段 ：  vitamin_c
    ·【血糖值】字段：  glucose
    ·【中毒值】字段：  poison


    常驻API  ：
    · 体质值：
                self:DoDelta_Wellness(num)              --- 数据加减  
                self:External_DoDelta_Wellness(num)     --- 外部数据加减，方便在debuff_inst 挂载上限检查函数。函数内部在判断完成后内部需要 DoDelta_Wellness
                self:GetCurrent_Wellness()              --- 返回3个值 :  当前值 、 百分比 、 MAX
                self:SetCurrent_Wellness(num)           --- 设置当前值
    · VC值：
                self:DoDelta_Vitamin_C(num)              --- 数据加减  
                self:External_DoDelta_Vitamin_C(num)     --- 外部数据加减，方便在debuff_inst 挂载上限检查函数。函数内部在判断完成后内部需要 DoDelta_Vitamin_C
                self:GetCurrent_Vitamin_C()              --- 返回3个值 :  当前值 、 百分比 、 MAX
                self:SetCurrent_Vitamin_C(num)           --- 设置当前值
    · 血糖值：
                self:DoDelta_Glucose(num)              --- 数据加减  
                self:External_DoDelta_Glucose(num)     --- 外部数据加减，方便在debuff_inst 挂载上限检查函数。函数内部在判断完成后内部需要 DoDelta_Glucose
                self:GetCurrent_Glucose()              --- 返回3个值 :  当前值 、 百分比 、 MAX
                self:SetCurrent_Glucose(num)           --- 设置当前值
    · 中毒值：
                self:DoDelta_Poison(num)              --- 数据加减  
                self:External_DoDelta_Poison(num)     --- 外部数据加减，方便在debuff_inst 挂载上限检查函数。函数内部在判断完成后内部需要 DoDelta_Poison
                self:GetCurrent_Poison()              --- 返回3个值 :  当前值 、 百分比 、 MAX
                self:SetCurrent_Poison(num)           --- 设置当前值
    
    常用API：
        ·  self:ForceRefresh()                  -- 【重要】 强制刷新数据。尤其是用于 道具使用的瞬间。5s周期太久，用这个强制刷新。

    不常用预留API：
        ·  self:All_Datas_Reset()               -- 清空所有缓存数据。注意，如果不停掉任务就清空，有可能遭遇nil问题。
        .  self:update()                        -- 给周期性执行的计算函数
        ·  self:start_update_task(time)         -- 定时循环任务，time 单位为秒
        ·  self:stop_update_task()              -- 停掉定时循环任务。
        ·  self:ReStartAllCom()                 -- 清空整个模块的数据和重启任务。通常用于换角色的时候执行。
        ·  self:ReStartUpdateTaskByTime(num)    -- 更改 update() 执行 周期的 函数。方便今后进行相关buff的操作
        ·  self.BeingPaused                     -- 标记 update() 是否正在循环。给子项目debuff_inst 内部监控模组是否暂停用的

    单个debuff 的增删操作：
        · self:Add_Debuff(prefab_name)          -- debuff_inst 的prefab 名字，无法重复添加debuff，重复添加的时候会执行  debuff_inst:RepeatedlyAttached()
        · self:Remove_Debuff(prefab_name)       -- 删除已有debuff，顺便执行 debuff_inst:OnDetached()
        ` self:Get_Debuff(prefab_name)          -- 获取已有debuff_inst ,或者 得到 nil
        · self:GetInfos(prefab_name)            -- 获取该debuff_inst 的 文本表， 为 debuff_inst:GetStringsTable() 得到的。方便外部调取 相关文本信息。

    需要注意的 API：
        · self:Get_Datas_Table_For_Replica()    -- 封装4个常驻值成table 给 下发使用的
                                                -- 【注意】 数据没有任何变动的时候，net_string 是不会下发任何数据和触发event的。如果非要执行，得加个随机数。
        · self:Refresh()                        -- 尝试同步数据给 replica 。

    【重要提醒】
    【重要提醒】
    【重要提醒】
    【重要提醒】
    【重要提醒】 该 套系统的 debuff_inst 里的 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

    模板示例 在 【scripts\prefabs\23_fwd_in_pdt_wellness\_excample.lua】 里。可以参考常驻debuff 的内容 进行自行新增更多debuff

]]--
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_wellness = Class(function(self, inst)
    self.inst = inst

    ------ 预留个标记位，给打印测试。
    -- self.DEBUGGING_MODE = nil    
    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        self.DEBUGGING_MODE = true
    end

    self.DataTable = {}     -- 储存数据，带进存档
    self.TempData = {}      -- 临时数据

    self.debuffs = {}       -- 储存 debuff_inst , index 为 prefab
    self.BeingPaused = true  -- 标记 Update() 是否暂停了。

    self.Show_Hud_Others = false     ---- HUD 显示其他条的标记位。

    ---- 最大值
        self.max = {
            ["wellness"] = 300,         -- 体质值  上限
            ["vitamin_c"] = 100,        -- 维C值   上限
            ["glucose"] = 100,          -- 血糖值  上限
            ["poison"] = 100,           -- 中毒值  上限
        }

    ---- 默认值
        self.defualts = {
            ["wellness"] = 140,         -- 体质值  初始
            ["vitamin_c"] = 100,        -- 维C值   初始
            ["glucose"] = 59,           -- 血糖值  初始
            ["poison"] = 0,             -- 中毒值  初始
        }

    ---- inst 的prefab 名字 , 相关值的函数挂载在 这个inst 内，这个inst 不储存任何数据
        self.base_prefabs = {                   
            ["wellness"] = "fwd_in_pdt_wellness",                   -- 体质值  
            ["vitamin_c"] = "fwd_in_pdt_wellness_vitamin_c",        -- 维C值
            ["glucose"] = "fwd_in_pdt_wellness_glucose",            -- 血糖值  
            ["poison"] = "fwd_in_pdt_wellness_poison",              -- 中毒值  
        }
        ----- 转置一下 table ，方便后续判断
        self.base_prefabs_index = {                   
            ["fwd_in_pdt_wellness"] = "wellness",                   -- 体质值  
            ["fwd_in_pdt_wellness_vitamin_c"] = "vitamin_c",        -- 维C值
            ["fwd_in_pdt_wellness_glucose"] = "glucose",            -- 血糖值  
            ["fwd_in_pdt_wellness_poison"] = "poison",              -- 中毒值  
        }
        ---- 计算优先级，数字越小，越优先。 第一个 则永远在最后，给每次 update 的最后根据体质值 处理相关任务
        self.base_prefabs_orders = {        
            [1] = "wellness",
            [2] = "vitamin_c",
            [3] = "glucose",
            [4] = "poison",
        }


    inst:DoTaskInTime(0,function()  --- 0的时候再激活吧，不着急激活模块
        if inst.userid == nil then
            return
        end

        if not self:Get("player_datas_inited") then ----- 初始化
            self:ReStartAllCom()
            self:Set("player_datas_inited", true)
        else
            self:load_debuffs_for_new_spawn()
            self:start_update_task()
        end

        self:Refresh()

    end)
    ----- 给外部重置整个模块用的
    inst:ListenForEvent("fwd_in_pdt_wellness.ReStart",function()
        self:ReStartAllCom()
        self:Set("player_datas_inited", true)
    end)

    ---- 死亡和复活
    inst:ListenForEvent("death",function()      -- 被杀了
        self:stop_update_task()
    end)
    inst:ListenForEvent("respawnfromghost",function()   -- 复活了        
        self:start_update_task()
    end)

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
-- 储存读取数据使用的
    function fwd_in_pdt_wellness:SaveData(DataName_Str,theData)
        if DataName_Str then
            self.DataTable[DataName_Str] = theData
        end
    end

    function fwd_in_pdt_wellness:ReadData(DataName_Str)
        if DataName_Str then
            if self.DataTable[DataName_Str] then
                return self.DataTable[DataName_Str]
            else
                return nil
            end
        end
    end
    function fwd_in_pdt_wellness:Get(DataName_Str)
        return self:ReadData(DataName_Str)
    end
    function fwd_in_pdt_wellness:Set(DataName_Str,theData)
        self:SaveData(DataName_Str, theData)
    end

    function fwd_in_pdt_wellness:Add(DataName_Str,num)
        if self:Get(DataName_Str) == nil then
            self:Set(DataName_Str, 0)
        end
        if type(num) ~= "number" or type(self:Get(DataName_Str))~="number" then
            return
        end
        self:Set(DataName_Str, self:Get(DataName_Str) + num)
        return self:Get(DataName_Str)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 四个基础值的数据获取
    ---------------------------------------------------
    -- 基础API封装
            function fwd_in_pdt_wellness:DoDelta(index,num)
                if type(num) == "number" and type(index) == "string" then
                    local crash_flag ,ret = pcall(function()
                        local ret_num = math.clamp( self:Get(index) + num ,  0 , self.max[index] )
                        self:Set(index,ret_num)
                    end)
                    if not crash_flag then
                        print("error in fwd_in_pdt_wellness DoDelta ")
                        print(ret)
                    end
                end
            end
            function fwd_in_pdt_wellness:GetCurrent(index)          --- 当前值，和百分比 一起返回
                if type(index) == "string" then
                    local crash_flag,current,percent,max = pcall(function()
                        local curr_num = self:Add(index,0)
                        local max_num = self.max[index]
                        return curr_num,curr_num/max_num,max_num
                    end)
                    if crash_flag then -- 没发生崩溃
                        return current,percent,max
                    else
                        print("error in fwd_in_pdt_wellness GetCurrent")
                        print(current)
                    end
                end
                return 0,0,0
            end
            function fwd_in_pdt_wellness:SetCurrent(index,num)
                if type(num) == "number" and type(index) == "string" then
                    local crash_flag,ret = pcall(function()
                        print("fwd_in_pdt_wellness.SetCurrent",index,num)
                        self:Set(index,  math.clamp(num,0,self.max[index])   )                        
                    end)
                    if not crash_flag then
                        print("fwd_in_pdt_wellness SetCurrent  error ")
                        print(ret)
                    end
                end
            end

            function fwd_in_pdt_wellness:External_DoDelta(index,num)        --- 靠外部调用执行增减的时候，运行做限位
                local prefab_name = self.base_prefabs[index]
                if prefab_name and self.debuffs[prefab_name] and self.debuffs[prefab_name].External_DoDelta then
                    self.debuffs[prefab_name]:External_DoDelta(num)
                end
            end
    -------------------------------
    --- 封装4个值的
        ---- 体质值
            function fwd_in_pdt_wellness:DoDelta_Wellness(num)
                self:DoDelta("wellness",num)
            end            
            function fwd_in_pdt_wellness:External_DoDelta_Wellness(num)
                self:External_DoDelta("wellness",num)
            end
            function fwd_in_pdt_wellness:GetCurrent_Wellness()
                return self:GetCurrent("wellness")
            end
            function fwd_in_pdt_wellness:SetCurrent_Wellness(num)
                self:SetCurrent("wellness",num)
            end

        ---- VC值
            function fwd_in_pdt_wellness:DoDelta_Vitamin_C(num)
                self:DoDelta("vitamin_c",num)
            end
            function fwd_in_pdt_wellness:External_DoDelta_Vitamin_C(num)
                self:External_DoDelta("vitamin_c",num)
            end
            function fwd_in_pdt_wellness:GetCurrent_Vitamin_C()
                return self:GetCurrent("vitamin_c")
            end
            function fwd_in_pdt_wellness:SetCurrent_Vitamin_C(num)
                self:SetCurrent("vitamin_c",num)
            end
        ---- 血糖值
            function fwd_in_pdt_wellness:DoDelta_Glucose(num)
                self:DoDelta("glucose",num)
            end
            function fwd_in_pdt_wellness:External_DoDelta_Glucose(num)
                self:External_DoDelta("glucose",num)
            end
            function fwd_in_pdt_wellness:GetCurrent_Glucose()
                return self:GetCurrent("glucose")
            end
            function fwd_in_pdt_wellness:SetCurrent_Glucose(num)
                self:SetCurrent("glucose",num)
            end
        ---- 中毒值
            function fwd_in_pdt_wellness:DoDelta_Poison(num)
                self:DoDelta("poison",num)
            end
            function fwd_in_pdt_wellness:External_DoDelta_Poison(num)
                self:External_DoDelta("poison",num)
            end
            function fwd_in_pdt_wellness:GetCurrent_Poison()
                return self:GetCurrent("poison")
            end
            function fwd_in_pdt_wellness:SetCurrent_Poison(num)
                self:SetCurrent("poison",num)
            end



------------------------------------------------------------------------------------------------------------------------------
--- 四个基础值的初始化，以及所有数据统一重置的API。以及周期性任务起始的API
    function fwd_in_pdt_wellness:All_Datas_Reset()
        for prefab_name, defubff_inst in ipairs(self.debuffs) do
            if prefab_name and defubff_inst then
                -- defubff_inst:Remove()
                self:Remove_Debuff(prefab_name)
            end
        end

        self.debuffs = {}
        self.TempData = {}
        self.DataTable = {}

        
        for index, num in pairs(self.defualts) do
            print(index,num)
            self:SetCurrent(index,num)
        end
    end

    function fwd_in_pdt_wellness:update()       --- 每个周期都会执行的函数
        if self.inst:HasTag("playerghost") then
            return
        end

        --- step 1 运行除了常驻的那些以外的所有 update 函数
            for prefab_name, debuff_inst in pairs(self.debuffs) do
                if prefab_name and debuff_inst and self.base_prefabs_index[prefab_name] == nil and debuff_inst.OnUpdate then
                    debuff_inst:OnUpdate()
                end
            end
        --- setp 2 运行常驻的那些，最后运行 orders 第一位的
            local first_order_debuff_prefab = nil
            for i, index in pairs(self.base_prefabs_orders) do
                    if i ~= 1 and index then
                        local temp_debuff_prefab_name = self.base_prefabs[index]
                        if temp_debuff_prefab_name and self.debuffs[temp_debuff_prefab_name] and self.debuffs[temp_debuff_prefab_name].OnUpdate then
                            self.debuffs[temp_debuff_prefab_name]:OnUpdate()
                        end
                    elseif i == 1 and index then
                        first_order_debuff_prefab = self.base_prefabs[index]
                    end
            end

            if first_order_debuff_prefab and self.debuffs[first_order_debuff_prefab] and self.debuffs[first_order_debuff_prefab].OnUpdate then
                self.debuffs[first_order_debuff_prefab]:OnUpdate()
            end        

    end

    function fwd_in_pdt_wellness:start_update_task(update_time)
        if self._______update_task == nil then
            self._______update_task = self.inst:DoPeriodicTask(update_time or 5,function()
                self:update()
                self:Refresh()
            end)
        end
        self.BeingPaused = false
    end
    function fwd_in_pdt_wellness:stop_update_task()
        if self._______update_task then
            self._______update_task:Cancel()
            self._______update_task = nil
        end
        self.BeingPaused = true
    end

    function fwd_in_pdt_wellness:load_debuffs_for_new_spawn()   --- 玩家inst实体刷新的时候才执行
        ---- step 1 先加载基础常驻的
            for k, prefab_name in pairs(self.base_prefabs) do
                if prefab_name then
                    self:Add_Debuff(prefab_name)
                end
            end
        ---- step 2 加载记录在案的其他
            local added_debuffs = self:Get("attached_debuffs") or {}
            for prefab_name, flag in pairs(added_debuffs) do
                if prefab_name and flag then
                    self:Add_Debuff(prefab_name)
                end
            end

    end

    function fwd_in_pdt_wellness:ReStartAllCom()
        self:stop_update_task()
        self:All_Datas_Reset()
        self:load_debuffs_for_new_spawn()
        self:start_update_task()
    end

    function fwd_in_pdt_wellness:ReStartUpdateTaskByTime(num)   ---  更换update刷新执行时间
        if type(num) == "number" then
            self:stop_update_task()
            self:start_update_task(num)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
---- 单个debuff 的添加删除 等操作
    function fwd_in_pdt_wellness:Add_Debuff(str)    --- 添加debuff
        if type(str) == "string" and PrefabExists(str) then
                if self.debuffs[str] == nil then    --- 没有这个debuff
                    local child = self.inst:SpawnChild(str)
                    if child then

                        local attach_succeed_flag = true    --- 预添加检测
                        if child.PreAttach then             --- 重复不检测
                            child.com = self
                            child.player = self.inst
                            attach_succeed_flag = child:PreAttach(self) or false
                        end

                        if attach_succeed_flag then
                                self.debuffs[str] = child
                                child:OnAttached(self)
                                child.com = self
                                child.player = self.inst

                                ---- 储存添加过的debuff名字，给读档的时候调用
                                local added_debuffs = self:Get("attached_debuffs") or {}
                                added_debuffs[str] = true
                                self:Set("attached_debuffs",added_debuffs)
                        else
                                child:Remove()
                        end
                        
                    end
                else
                    -------- 重复添加了这个debuff
                    if self.debuffs[str] and self.debuffs[str].RepeatedlyAttached then
                        self.debuffs[str]:RepeatedlyAttached()
                    end
                end
        end
    end

    function fwd_in_pdt_wellness:Remove_Debuff(str)     --- 移除debuff
        if str and self.debuffs[str] then
            if self.debuffs[str].OnDetached then
                self.debuffs[str]:OnDetached()
            end
            self.debuffs[str]:Remove()
            self.debuffs[str] = nil

            ---- 储存添加过的debuff名字，给读档的时候调用
            local added_debuffs = self:Get("attached_debuffs") or {}
            added_debuffs[str] = false
            self:Set("attached_debuffs",added_debuffs)
        end
    end

    function fwd_in_pdt_wellness:GetInfos(str)  --- 获取文本信息
        if str and self.debuffs[str] and self.debuffs[str].GetStringsTable then
            return self.debuffs[str]:GetStringsTable()
        end
        return {}
    end


    function fwd_in_pdt_wellness:Get_Debuff(str)
        if str and self.debuffs[str] then
            return self.debuffs[str]
        end
        return nil
    end
------------------------------------------------------------------------------------------------------------------------------
-- 数据同步用的 func
    function fwd_in_pdt_wellness:Get_Datas_Table_For_Replica()
        --- 需要发送的数据只有4个：【体质值】【VC值】【血糖值】【中毒值】
        local current,percent,max = 0,0,0

        ------ wellness
            current,percent,max = self:GetCurrent_Wellness()
            local wellness = {  current = current , percent = percent , max = max}
        ------ vitamin_c
            current,percent,max = self:GetCurrent_Vitamin_C()
            local vitamin_c = {  current = current , percent = percent , max = max}
        ------ glucose
            current,percent,max = self:GetCurrent_Glucose()
            local glucose = {  current = current , percent = percent , max = max}
        ------ poison
            current,percent,max = self:GetCurrent_Poison()
            local poison = {  current = current , percent = percent , max = max}        

        local cmd_table = {
            wellness = wellness,
            vitamin_c = vitamin_c,
            glucose = glucose,
            poison = poison,
        }
        return cmd_table
        -- self.inst.replica.fwd_in_pdt_wellness:Send_Datas(cmd_table)
    end

    function fwd_in_pdt_wellness:Refresh()
        local datas_table = self:Get_Datas_Table_For_Replica() or {}

        datas_table["Show_Hud_Others"] = self.Show_Hud_Others or false
        datas_table["Temp_Force_Flag"] = math.random(10000)
        self.inst.replica.fwd_in_pdt_wellness:Send_Datas(datas_table)
    end

    function fwd_in_pdt_wellness:ForceRefresh()
        if self.inst:HasTag("playerghost") then
            return
        end
        --- step 1 运行除了常驻的那些以外的所有 update 函数
        for prefab_name, debuff_inst in pairs(self.debuffs) do
            if prefab_name and debuff_inst and self.base_prefabs_index[prefab_name] == nil and debuff_inst.ForceRefresh then
                debuff_inst:ForceRefresh()
            end
        end
        --- setp 2 运行常驻的那些，最后运行 orders 第一位的
            local first_order_debuff_prefab = nil
            for i, index in pairs(self.base_prefabs_orders) do
                    if i ~= 1 and index then
                        local temp_debuff_prefab_name = self.base_prefabs[index]
                        if temp_debuff_prefab_name and self.debuffs[temp_debuff_prefab_name] and self.debuffs[temp_debuff_prefab_name].ForceRefresh then
                            self.debuffs[temp_debuff_prefab_name]:ForceRefresh()
                        end
                    elseif i == 1 and index then
                        first_order_debuff_prefab = self.base_prefabs[index]
                    end
            end

            if first_order_debuff_prefab and self.debuffs[first_order_debuff_prefab] and self.debuffs[first_order_debuff_prefab].ForceRefresh then
                self.debuffs[first_order_debuff_prefab]:ForceRefresh()
            end  

        --- 获取数据下发更新
            -- local datas_table = self:Get_Datas_Table_For_Replica()
            -- datas_table["Temp_Force_Flag"] = math.random(10000)
            -- self.inst.replica.fwd_in_pdt_wellness:Send_Datas(datas_table)
            self:Refresh()
    end
------------------------------------------------------------------------------------------------------------------------------
-- UI操作显示隐藏用的
    function fwd_in_pdt_wellness:HudShowOhters(flag)
        self.Show_Hud_Others = flag
        self:ForceRefresh()
    end
------------------------------------------------------------------------------------------------------------------------------



















function fwd_in_pdt_wellness:OnSave()
    local data =
    {
        DataTable = self.DataTable
    }

    return next(data) ~= nil and data or nil
end

function fwd_in_pdt_wellness:OnLoad(data)
    if data.DataTable then
        self.DataTable = data.DataTable
    end
end

return fwd_in_pdt_wellness






