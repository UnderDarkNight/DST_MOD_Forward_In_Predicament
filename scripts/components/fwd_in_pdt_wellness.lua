----------------------------------------------------------------------------------------------------------------------------------
-- 体质值 模块
--[[
    · 所有体质值有关的数据储存在本模块里面，使用 Get(str) ,Set(str,num) 的形式。虽然有点多此一举，但是数据不易乱。

    · 子项目使用 inst 实体挂载为玩家的child，这些 inst 里不储存任何数据，只有执行函数。
    · 子节点只有一层，不会有多层子节点。
    · 数据使用 json_str 通过net_string 下发给 replica 。net_string 在replica 注册

    · 常驻子项目有 【VC值】【血糖值】【中毒值】
    · update 周期为 5s
    ·【体质值】字段： wellness
    ·【VC值】 字段 ：  vitamin_c
    ·【血糖值】字段：  glucose
    ·【中毒值】字段：  poisoning
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_wellness = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}     -- 储存数据，带进存档
    self.debuffs = {}       -- 储存 debuff_inst , index 为 prefab

    self.wellness_max = 300     -- 体质值的最大值
    self.vitamin_c_max = 100    
    self.glucose_max = 100
    self.poisoning_max = 100

    --- 不在这初始化，只做一个占位。这的数据也不会保存。
    self.wellness = 0       -- 体质值
    self.vitamin_c = 0      -- VC值
    self.glucose = 0        -- 血糖值
    self.poisoning = 0      -- 中毒值

    inst:DoTaskInTime(0,function()  --- 0的时候再激活吧，不着急激活模块
        self:SysInit()  --- 激活本模块        
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
---- 单个debuff 的添加删除 等操作
    function fwd_in_pdt_wellness:Add_Debuff(str)    --- 添加debuff
        if type(str) == "string" and PrefabExists(str) and self.debuffs[str] == nil then
            local child = self.inst:SpawnChild(str)
            if child then
                self.debuffs[str] = child
                child:_OnAttached(self)
                child:_OnLoad()

                ---- 储存添加过的debuff名字，给读档的时候调用
                local added_debuffs = self:Get("attached_debuffs") or {}
                added_debuffs[str] = true
                self:Set("attached_debuffs",added_debuffs)
            end
        end
    end

    function fwd_in_pdt_wellness:Remove_Debuff(str)     --- 移除debuff
        if str and self.debuffs[str] then
            self.debuffs[str]:_OnDetached()
            self.debuffs[str]:Remove()
            self.debuffs[str] = nil

            ---- 储存添加过的debuff名字，给读档的时候调用
            local added_debuffs = self:Get("attached_debuffs") or {}
            added_debuffs[str] = false
            self:Set("attached_debuffs",added_debuffs)
        end
    end

    function fwd_in_pdt_wellness:GetInfos(str)  --- 获取文本信息
        if str and self.debuffs[str] then
            return self.debuffs[str]:_GetStringsTable()
        end
    end

    function fwd_in_pdt_wellness:Get_Debuff(str)
        if str and self.debuffs[str] then
            return self.debuffs[str]
        end
        return nil
    end

------------------------------------------------------------------------------------------------------------------------------
-- 体质值的增减，还有限位统一检查。还有相关参数获取。
    function fwd_in_pdt_wellness:DoDelta(num)
        if type(num) == "number" then            
            self:Add("wellness",num)
        end
    end
    function fwd_in_pdt_wellness:__clamp_check()
        self.wellness =  math.clamp(  self:Add("wellness",0) , 0 , self.wellness_max )       -- 体质值
        self.vitamin_c = math.clamp(  self:Add("vitamin_c",0) , 0 , self.vitamin_c_max )      -- VC值
        self.glucose =  math.clamp(  self:Add("glucose",0) , 0 , self.glucose_max )        -- 血糖值
        self.poisoning = math.clamp(  self:Add("poisoning",0) , 0 , self.poisoning_max )      -- 中毒值


        self:Set("wellness", self.wellness)
        self:Set("vitamin_c", self.vitamin_c)
        self:Set("glucose", self.glucose)
        self:Set("poisoning", self.poisoning)

    end

    
------------------------------------------------------------------------------------------------------------------------------
-- 数据同步用的 func
    function fwd_in_pdt_wellness:Send_Data_2_Replica()
        --- 需要发送的数据只有4个：【体质值】【VC值】【血糖值】【中毒值】
        local cmd_table = {
            wellness = self:Add("wellness", 0),
            vitamin_c = self:Add("vitamin_c", 0),
            glucose = self:Add("glucose", 0),
            poisoning = self:Add("poisoning", 0),
        }
        self.inst.replica.fwd_in_pdt_wellness:Send_Datas(cmd_table)
    end

    function fwd_in_pdt_wellness:Refresh()
        self:__clamp_check()
        self:Send_Data_2_Replica()
    end
------------------------------------------------------------------------------------------------------------------------------
--- 初始化执行，负责加载 常驻函数，以及检测 之前存档时候记录的debuff
function fwd_in_pdt_wellness:SysInit()
    ----------- 初始化参数

    if self:Get("player_spawn_init_flag") ~= true then
        self:Set("player_spawn_init_flag",true)

        self:Set("wellness", 140)   --- 体质值默认 140

    end

    ----------- 添加常驻的3个：【VC】【血糖】【中毒】
        local Resident_Debuffs = {
            ["fwd_in_pdt_welness_vc"]   = true,
        }
        for k, v in pairs(Resident_Debuffs) do
            self:Add_Debuff(k)
        end
    --- 根据存档之前的记录，加载剩下debuff
        local attached_debuffs = self:Get("attached_debuffs") or {} 
        for debuff_name, flag in pairs(attached_debuffs) do
            if debuff_name and flag then
                self:Add_Debuff(debuff_name)
            end
        end
    --- 开始周期性循环，3个常驻的在最后再执行
    local function all_debuff_update()
                ----- 非常驻的优先遍历
                for debuff_name, debuff_inst in pairs(self.debuffs) do
                    if debuff_name and debuff_inst and Resident_Debuffs[debuff_name] ~= true then
                        local num = debuff_inst:_OnUpdate() or 0
                        self:DoDelta(num)
                    end
                end
                ---- 环常驻的
                for debuff_name, v in pairs(Resident_Debuffs) do
                    local temp_debuff_inst = self:Get_Debuff(debuff_name)
                    if temp_debuff_inst then
                        local num = temp_debuff_inst:_OnUpdate() or 0
                        self:DoDelta(num)
                    end
                end
                ---------------- max or min 限位检查
                self:__clamp_check()
                ---------------- 更新下发参数给 replica
                self:Send_Data_2_Replica()
    end
    all_debuff_update()
    self.inst:DoPeriodicTask(5,all_debuff_update)
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






