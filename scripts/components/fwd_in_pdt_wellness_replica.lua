----------------------------------------------------------------------------------------------------------------------------------
-- 体质值 模块
--[[
    · replica 模块
    · 不需要做私密化处理，直接下发就行了。
    ·【体质值】字段： wellness
    ·【VC值】 字段 ：  VC
    ·【血糖值】字段：  glucose
    ·【中毒值】字段：  poisoning
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_wellness = Class(function(self, inst)
    self.inst = inst

    self._values_json_net_string = net_string(inst.GUID,"fwd_in_pdt_wellness","fwd_in_pdt_wellness.values_json_str")
    self.inst:ListenForEvent("fwd_in_pdt_wellness.values_json_str",function()
        local str = self._values_json_net_string:value()
        local crash_flag,ret_table = pcall(json.decode,str)
        if crash_flag then
            self:Get_The_Datas_From_Server(ret_table)
        end
    end)

    self.datas = {}

end,
nil,
{

})

function fwd_in_pdt_wellness:Send_Datas(cmd_table)
    if type(cmd_table) == "table" then
        local str = json.encode(cmd_table)
        self._values_json_net_string:set(str)
    end
end

function fwd_in_pdt_wellness:Get_The_Datas_From_Server(cmd_table)
    -- self.datas = cmd_table
    for k, v in pairs(cmd_table) do
        self.datas[k] = v
    end
    ---- 数值同步了，更新HUD
    self:UpdateHUD()
end

function fwd_in_pdt_wellness:UpdateHUD()
    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        -- local wellness = self:Get_Wellness()
        -- local vc = self:Get_Vitamin_C()
        -- local glu = self:Get_Glucose()
        -- local poison = self:Get_Poison()
        -- print("----------------------------------------")
        -- print("当前【体质值】",wellness)
        -- print("当前【VC值】",vc)
        -- print("当前【血糖值】",glu)
        -- print("当前【中毒值】",poison)
        -- print("----------------------------------------")
        if self.inst.HUD and self.inst.HUD.fwd_in_pdt_wellness then
            self.inst.HUD.fwd_in_pdt_wellness:SetCurrent_Wellness(self:Get_Wellness())
            self.inst.HUD.fwd_in_pdt_wellness:SetCurrent_Vitamin_C(self:Get_Vitamin_C())
            self.inst.HUD.fwd_in_pdt_wellness:SetCurrent_Glucose(self:Get_Glucose())
            self.inst.HUD.fwd_in_pdt_wellness:SetCurrent_Poison(self:Get_Poison())

            if self:Get("Show_Hud_Others") then
                self.inst.HUD.fwd_in_pdt_wellness:ShowOhters()
            else
                self.inst.HUD.fwd_in_pdt_wellness:HideOhters()                
            end
            if self:Get("Show_Hud") then
                self.inst.HUD.fwd_in_pdt_wellness:Show()
            else
                self.inst.HUD.fwd_in_pdt_wellness:Hide()
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------
-- 给HUD那边读取数值 和百分比
    function fwd_in_pdt_wellness:Get_By_Index(str)
        local crash_flag,current,percent,max = pcall(function()
            if self.datas[str].current and self.datas[str].percent and self.datas[str].max then
                return self.datas[str].current , self.datas[str].percent , self.datas[str].max
            end
        end)
        if crash_flag then
            return current,percent,max
        else
            return 0,0,0
        end
    end
    function fwd_in_pdt_wellness:Get_Wellness()
        return self:Get_By_Index("wellness")
    end
    function fwd_in_pdt_wellness:Get_Vitamin_C()
        return self:Get_By_Index("vitamin_c")

    end
    function fwd_in_pdt_wellness:Get_Glucose()
        return self:Get_By_Index("glucose")

    end
    function fwd_in_pdt_wellness:Get_Poison()
        return self:Get_By_Index("poison")

    end
-----------------------------------------------------------------------------------------------------
    function fwd_in_pdt_wellness:Get(str)
        if type(str) == "string" then
            return self.datas[str]
        end
    end
-----------------------------------------------------------------------------------------------------

return fwd_in_pdt_wellness






