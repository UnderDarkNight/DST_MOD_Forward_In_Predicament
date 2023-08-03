--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本组件用来给物品栏的图标添加动画特效（像是老麦的魔法高礼帽的那个）
---- 有replica
---- 界面组件读取replica 的参数
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_itemtile_anim = Class(function(self, inst)
    self.inst = inst
    self.anim_data_table = {}
    self.anim_data_table_json_str = nil

    self.__net_string = net_string(self.inst.GUID, "fwd_in_pdt_net_sting", "fwd_in_pdt_com_itemtile_anim")
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("fwd_in_pdt_com_itemtile_anim",function()
            local json_str = self.__net_string:value()
            self:Set_Json_Str(json_str)
        end)

    end

    self.inst:AddTag("fwd_in_pdt_com_itemtile_anim")
end,
nil,
{

})

function fwd_in_pdt_com_itemtile_anim:Set_Json_Str(str)
    if str ~= "nil" then
            local crash_flag , ret_table = pcall(json.decode,str)
            if crash_flag then
                self.anim_data_table = ret_table
                if TheWorld.ismastersim then
                    self.__net_string:set(str)
                end
            end
    else
        self.anim_data_table = {}
        if TheWorld.ismastersim then
            self.__net_string:set("nil") 
        end
    end
end



return fwd_in_pdt_com_itemtile_anim