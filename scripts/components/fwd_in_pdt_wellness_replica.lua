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

    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        print("++++++++++++++++++++")
        for index, _t_table in pairs(cmd_table) do
            print(index)
            pcall(function()
                for k, v in pairs(_t_table) do
                    print("   ",k,v)
                end
                print("----------")
            end)

        end
        print("++++++++++++++++++++")
    end

end

function fwd_in_pdt_wellness:UpdateHUD()
    
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

return fwd_in_pdt_wellness






