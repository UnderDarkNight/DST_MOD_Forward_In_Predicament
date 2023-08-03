--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本组件用来给物品栏的图标添加动画特效（像是老麦的魔法高礼帽的那个）
---- 有replica
---- 界面组件读取replica 的参数
---- SetAnim 的参数 { bank = "",build = "",anim = ""}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function anim_data_table_json_str(self,str)
    self.inst.replica.fwd_in_pdt_com_itemtile_anim:Set_Json_Str(tostring(str))
end

local fwd_in_pdt_com_itemtile_anim = Class(function(self, inst)
    self.inst = inst
    self.anim_data_table = {}
    self.anim_data_table_json_str = nil

    self.inst:AddTag("fwd_in_pdt_com_itemtile_anim")
end,
nil,
{
    anim_data_table_json_str = anim_data_table_json_str
})

function fwd_in_pdt_com_itemtile_anim:SetAnim(cmd_table)
    if type(cmd_table) == "table" and type(cmd_table.bank) =="string" and type(cmd_table.build) == "string" and type(cmd_table.anim) == "string" then
        self.anim_data_table = cmd_table
        self.anim_data_table_json_str = json.encode(self.anim_data_table)
    end
end

function fwd_in_pdt_com_itemtile_anim:Clear()
    self.anim_data_table_json_str = nil
end



return fwd_in_pdt_com_itemtile_anim