------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本模块为资源生长使用（通常为植物，也可以是其他）
---- 【注意】不建议在农作物上使用本组件。
---- 会同时加载 longupdate ，使用其中的 OnEntityWake
---- 函数会在 OnEntityWake 才执行days 参数进入切换
---- 函数格式  fn(inst,days,awake_flag,refresh_flag) ,在 OnEntityWake 才会执行。
---- awake_flag: 是否在加载范围内            refresh_flag:通过其他手段强制更新天数的时候(例如魔法书)
---- stage 的逻辑有点类似于烹饪系统：遍历 test 函数 并执行对应的 fn 函数

--- 如果想得到当前的生长天数，可以使用 fwd_in_pdt_func:Growable_Add_Days(0) 得到return 的值，也可以使用  fwd_in_pdt_func:Growable_Get_Current_Days()

---- 【推荐】模式2：
    ---- fwd_in_pdt_func:Growable_Add_Stage_Fns(cmd_table)
    -- cmd_table = {
    --     [1] = {      
    --         
    --         test = function(days)
    --             return true
    --         end,
    --         fn = function(inst,days,awake_flag,refresh_flag)            
    --         end
    --     },
    --     [2] = {      
    --         
    --         test = function(days)
    --             return true
    --         end,
    --         fn = function(inst,days,awake_flag,refresh_flag)            
    --         end
    --     },
    -- }
    ------------ awake_flag 为OnEntityWake 调用的时候为 true ，为加载范围内激活检查。
    ------------ refresh_flag 为已经在加载范围内，外部道具触发检查使用（例如魔法书强制阶段生长）的时候，为true。

----【提示】 inst:GetTimeAlive() 和 GetTime()  可以配合模式2实现单向生长。

--- 可以使用自制组件 fwd_in_pdt_com_acceptable 进行物品接收
-------------------------------------------------------------------------------------------------------------
--- Growable_Get_Last_Days_Num()  --- 获取上次天数变更的时候的日期参数
--- Growable_Is_Days_Num_Forward() --- 用来判断生长天数是向前还是向后。
-------------------------------------------------------------------------------------------------------------
--- 生长天数相关的 天数参数修正方式1：
--- 生长加速组件的最终参数，为所有参数之间的最终乘积。
--- 生长加速组件 和 肥料系统 暂时没有关联。使用event 交互，和自身 inst 为参数进入 加速组件可解决，这里不做API封装。
--- Growable_AddModifier(inst ,num)  ----- 天数的乘积参数
--- 进行生长加速的时候，会触发事件 modifier_inst:PushEvent("fwd_in_pdt_event.Growable.GetModifiersNum",self.inst)    

--- 修正方式2：
--- fwd_in_pdt_func:Growable_Set_Day_Cycles_Fix_Fn    fn(days_num) return num end --- 用来修正生长天数的函数，方便某些外部影响的时候操作。
--- 这里会屏蔽上面的 Modifiers 。可以用于外部生物进行干预，例如天数要增加的时候扫描附近所有实体。

--- 以上修正方式都只在 WatchWorldState("cycles" 的时候执行。
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local SourceModifierList = require("util/sourcemodifierlist")
local function main_com(fwd_in_pdt_func)
    if not TheWorld.ismastersim then
        return
    end
    -- if fwd_in_pdt_func.inst.components.fwd_in_pdt_data == nil then
    --     fwd_in_pdt_func.inst:AddComponent("fwd_in_pdt_data")
    -- end
    --------------------------------------------------------------------------------------
    --- 同时加载 04_LongUpdate
    if fwd_in_pdt_func.OnEntityWake == nil then
        fwd_in_pdt_func:Init("long_update")
    end
    --------------------------------------------------------------------------------------
    --- 初始化一些table
    fwd_in_pdt_func.tempData.____growable_fns = {}
    fwd_in_pdt_func.tempData.____growable_cycle_watch_event_flag = false
    --------------------------------------------------------------------------------------    
    --- 生长加速组件，所有参数之间的乘积。
        fwd_in_pdt_func.tempData.____growable_modifiers = SourceModifierList(fwd_in_pdt_func.inst)
        fwd_in_pdt_func.tempData.____growable_modifier_insts = {}     ---- 储存增益用的 inst，触发事件的时候集体PushEvent
        function fwd_in_pdt_func:Growable_AddModifier(inst,num)               --- 添加加速器
            if type(inst) == "table" and type(num) == "number" then
                self.tempData.____growable_modifiers:SetModifier(inst,num)
                table.insert(self.tempData.____growable_modifier_insts,inst)
            end
        end
        function fwd_in_pdt_func:Growable_RemoveModifier(inst)                --- 移除加速器
            self.tempData.____growable_modifiers:RemoveModifier(inst)        
            local new_table = {}
            for k, v in pairs(self.tempData.____growable_modifier_insts) do
                if v and v ~= inst and v:IsValid() then
                    table.insert(new_table,v)
                end
            end
            self.tempData.____growable_modifier_insts = {}
        end
        function fwd_in_pdt_func:Growable_GetModifiersNum()                      --- 获取加速参数
            for k, temp_inst in pairs(self.tempData.____growable_modifier_insts) do
                if temp_inst then
                    if temp_inst:IsValid() then
                        temp_inst:PushEvent("fwd_in_pdt_event.Growable.GetModifiersNum",self.inst)        --- 发送事件
                    else
                        self:Growable_RemoveModifier(temp_inst)
                    end
                end
            end
            return self.tempData.____growable_modifiers:Get()
        end
    --------------------------------------------------------------------------------------   
    ---- 按天数生长的系统 【基础系统】
        function fwd_in_pdt_func:Growable_Add_Grow_Days_Fn(fn)                ---- 添加【新的一天执行函数】
            if fn == nil or type(fn) ~= "function" then
                return
            end
            table.insert(self.tempData.____growable_fns,fn)

            if self.tempData.____growable_cycle_watch_event_flag ~= true then
                self.tempData.____growable_cycle_watch_event_flag = true
                
                local inst = self.inst
                inst:WatchWorldState("cycles",function(inst)
                    local modifiers_num = inst.components.fwd_in_pdt_func:Growable_GetModifiersNum() or 1
                    local num = 1 * modifiers_num
                    if self.tempData.__Growable_Set_Day_Cycles_Fix_Fn then        ---- 参数修正
                        num = self.tempData.__Growable_Set_Day_Cycles_Fix_Fn(num) or num
                    end
                    inst.components.fwd_in_pdt_func:Growable_Add_Days(num)
                    if not inst:IsAsleep() then
                        inst.components.fwd_in_pdt_func:Growable_OnEntityWake()
                    end
                end)
            end

        end

        function fwd_in_pdt_func:Growable_Remove_Grow_Days_Fn(fn)             ---- 移除指定的【新的一天执行函数】
            if fn == nil or type(fn) ~= "function" then
                return
            end
            local new_table = {}
            for k, temp_fn in pairs(self.tempData.____growable_fns) do
                if temp_fn ~= fn then
                    table.insert(new_table,temp_fn)
                end
            end
            self.tempData.____growable_fns = new_table
        end

        function fwd_in_pdt_func:Growable_Add_Days(num)                       ---- 添加生长天数
            if type(num) ~= "number" then
                num = 1
            end
            if num ~= 0 then
                local last_days_num = self:Add("_____fwd_in_pdt_func_growable_days__",0)
                self:Set("_____fwd_in_pdt_func_growable_days__last_num",last_days_num)
            end

            local ret_num = self:Add("_____fwd_in_pdt_func_growable_days__",num)
            self:Replica_Set_Simple_Data("CurrentDays",ret_num)
            return ret_num
        end
        function fwd_in_pdt_func:Growable_Set_Days(num)                       ---- 强制设置生长天数为num
            if type(num) ~= "number" then
                return
            end
            local last_days_num = self:Add("_____fwd_in_pdt_func_growable_days__",0)
            self:Set("_____fwd_in_pdt_func_growable_days__last_num",last_days_num)

            self:Replica_Set_Simple_Data("CurrentDays",num)
            self:Set("_____fwd_in_pdt_func_growable_days__",num)
        end

        function fwd_in_pdt_func:Growable_Get_Current_Days()
            return self:Growable_Add_Days(0)
        end

        function fwd_in_pdt_func:Growable_Get_Last_Days_Num()
            return self:Add("_____fwd_in_pdt_func_growable_days__last_num",0)
        end

        function fwd_in_pdt_func:Growable_Is_Days_Num_Forward()
            return self:Growable_Get_Current_Days() > self:Growable_Get_Last_Days_Num()
        end

        function fwd_in_pdt_func:Growable_Add_Days_And_Refresh(num)   --- 增加天数和刷新，用来进行魔法升级等操作
            self:Growable_Add_Days(num)
            self:Growable_OnEntityWake(true)
        end
        function fwd_in_pdt_func:Growable_Set_Days_And_Refresh(num)   --- 设置天数并刷新
            self:Growable_Set_Days(num)
            self:Growable_OnEntityWake(true)
        end

        function fwd_in_pdt_func:Growable_Set_Day_Cycles_Fix_Fn(fn)     ---- Growable_Add_Days 参数修正，外部影响等。
            if type(fn) == "function" then
                self.tempData.__Growable_Set_Day_Cycles_Fix_Fn = fn
            end
        end

        function fwd_in_pdt_func:Growable_OnEntityWake(refresh_flag)              ----- 执行生长的函数，只在玩家加载范围内执行，减少游戏卡顿。
            local days = self:Growable_Get_Current_Days()
            for k, temp_fn in pairs(self.tempData.____growable_fns) do
                if temp_fn and type(temp_fn) == "function" then
                    temp_fn( self.inst , days , not self.inst:IsAsleep() ,refresh_flag)
                end
            end
        end

        fwd_in_pdt_func:Add_OnEntityWake_Fn(function()
            fwd_in_pdt_func.inst:DoTaskInTime(0.5,function()    --- 延迟那么一丢丢，避免可能的nil问题。
                fwd_in_pdt_func:Growable_OnEntityWake()
            end)
        end)
    --------------------------------------------------------------------------------------
    -- 模式2：
        ----- 天数和生长阶段相互关联的fn
        ----- 使用控制表批量添加
        fwd_in_pdt_func.tempData.____growable_stage_cmd_table = {}
        -- cmd_table = {
            --     [1] = {
            --         test = function(days)
            --             return true
            --         end,
            --         fn = function(inst,days,awake_flag,refresh_flag)                    
            --         end
            --     },
            --     [2] = {
            --         test = function(days)
            --             return true
            --         end,
            --         fn = function(inst,days,awake_flag,refresh_flag)                    
            --         end
            --     },
            -- }
        function fwd_in_pdt_func:Growable_Add_Stage_Fns(cmd_table)
            if type(cmd_table) ~= "table" then
                return
            end
            for i, stage_table in ipairs(cmd_table) do
                if type(stage_table) ~= "table" or type(stage_table.test) ~= "function" or type(stage_table.fn) ~= "function" then
                    print("Error : stage_table in Growable_Add_Stage_Fns",self.inst)
                    return
                end            
            end

            self.tempData.____growable_stage_cmd_table = cmd_table
            local function stage_temp_fn(inst,days,awake_flag,refresh_flag)
                        local fwd_in_pdt_func = inst.components.fwd_in_pdt_func
                        for i, stage_table in ipairs(cmd_table) do
                            if stage_table.test(days) == true then
                                if fwd_in_pdt_func.tempData.____growable_stage ~= i then
                                    fwd_in_pdt_func.tempData.____growable_stage = i
                                    stage_table.fn(inst,days,awake_flag,refresh_flag)
                                end
                                return
                            end
                        end
            end

            self:Growable_Add_Grow_Days_Fn(stage_temp_fn)

        end

        
        function fwd_in_pdt_func:Growable_Goto_Next_Stage()           --------- 生长到下一个阶段
            local max_stage = #self.tempData.____growable_stage_cmd_table
            local current_stage = self.tempData.____growable_stage or 1
            if current_stage >= max_stage then
                return
            end

            local current_days = self:Growable_Add_Days(0)

            local next_stage_table = self.tempData.____growable_stage_cmd_table[current_stage + 1]
            if next_stage_table == nil or next_stage_table.test == nil or next_stage_table.fn == nil then
                return
            end

            local search_times = 1000 --- 最大只搜索1000天
            local target_days = current_days
            while search_times > 0 do
                search_times = search_times - 1
                target_days = target_days + 1
                if next_stage_table.test(target_days) then
                    break
                end
            end

            if target_days > current_days then
                self:Growable_Set_Days_And_Refresh(target_days)            
            end
        end

        function fwd_in_pdt_func:Growable_Goto_Last_Stage()           --------- 返回到上一个生长阶段
            local current_stage = self.tempData.____growable_stage
            local cmd_table = self.tempData.____growable_stage_cmd_table or {}
            -- local max_stage = #cmd_table
            local current_days = self:Growable_Get_Current_Days()

            if #cmd_table == 0 then
                return
            end

            --------- 第1、2 阶段的直接清零 days
            if current_stage == nil or current_stage == 1 or current_stage == 2 then
                self:Growable_Set_Days_And_Refresh(0)
                return
            end

            --------- 从第3阶段开始
            local last_stage = current_stage - 1    --- 往前1个阶段
            local last_last_stage = last_stage - 1  --- 往前2个阶段

            local last_stage_cmd_table = cmd_table[last_stage]  --- 
            local last_last_stage_cmd_table = cmd_table[last_last_stage]
            if type(last_stage_cmd_table) ~= "table" or type(last_last_stage_cmd_table) ~= "table" or last_stage_cmd_table.test == nil or last_last_stage_cmd_table.test == nil then
                return
            end

            local target_days = current_days
            while target_days > 0 do
                target_days = target_days - 1
                if last_stage_cmd_table.test(target_days) == true and last_last_stage_cmd_table.test(target_days) ~= true then
                    break
                end
            end

            ---- 得到上一阶段的起始天数 target_days
            self:Growable_Set_Days_And_Refresh(target_days)

        end

        function fwd_in_pdt_func:Growable_Goto_Stage_By_Days(days)       ------ 指定天数并切换生长阶段
            if type(days) == "number" then
                self:Growable_Set_Days_And_Refresh(days)
            end
        end

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(fwd_in_pdt_func)
    ---- 客户端获取天数用的
    function fwd_in_pdt_func:Growable_Get_Current_Days()
        if self.inst.components.fwd_in_pdt_func and self.inst.components.fwd_in_pdt_func.Growable_Get_Current_Days then
            return self.inst.components.fwd_in_pdt_func:Growable_Get_Current_Days()
        else
            return self:Replica_Get_Simple_Data("CurrentDays") or 0
        end
    end   
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    fwd_in_pdt_func.inst:AddTag("fwd_in_pdt_tag.fwd_in_pdt_func.Growable")    --- 添加tag 方便外部扫描到拥有该模块的inst。

    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)                    
    else 
        replica(fwd_in_pdt_func)
    end
    --------------------------------------------------------------------------------------



    --------------------------------------------------------------------------------------
end