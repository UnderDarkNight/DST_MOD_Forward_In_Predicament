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

    self.wellness = 0       -- 体质值
    self.vitamin_c = 0      -- VC值
    self.glucose = 0        -- 血糖值
    self.poisoning = 0      -- 中毒值

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
    self.wellness = cmd_table.wellness or 0
    self.vitamin_c = cmd_table.vitamin_c or 0
    self.glucose = cmd_table.glucose or 0
    self.poisoning = cmd_table.poisoning or 0
    ---- 数值同步了，更新HUD
    self:UpdateHUD()
    print("++++++++++++++++++++")
    for k, v in pairs(cmd_table) do
        print(k,v)
    end
    print("++++++++++++++++++++")

end

function fwd_in_pdt_wellness:UpdateHUD()
    
end
-----------------------------------------------------------------------------------------------------
-- 给HUD那边读取数值 和百分比
    function fwd_in_pdt_wellness:Get_Wellness()
        return self.wellness , self.wellness/300
    end
    function fwd_in_pdt_wellness:Get_Vitamin_C()
        return self.vitamin_c , self.vitamin_c/100
    end
    function fwd_in_pdt_wellness:Get_Glucose()
        return self.glucose , self.glucose / 100
    end
    function fwd_in_pdt_wellness:Get_Poisoning()
        return self.poisoning , self.poisoning / 100
    end
-----------------------------------------------------------------------------------------------------

return fwd_in_pdt_wellness






