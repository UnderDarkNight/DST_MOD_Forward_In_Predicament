--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_com_acceptable"
--     return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
-- end


local FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION = Action({priority = 50,distance = 3})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION.id = "FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION"
FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    return "DEFAULT"
end

FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if target and doer and item.components.fwd_in_pdt_special_packer and item.components.fwd_in_pdt_special_packer:Test(target) then
        return item.components.fwd_in_pdt_special_packer:Pack(target)
    end
    return false
end
AddAction(FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION)

--[[
        以下这些只在客户端执行，30FPS

        AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
        AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
        AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
        AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
        AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。
            
]]--


AddComponentAction("USEITEM", "fwd_in_pdt_special_packer", function(item, doer, target, actions, right_click) -- -- 一个物品对另外一个目标用的技能，  客户端执行，30FPS
    if doer and item and target and item:HasTag("fwd_in_pdt_special_packer") then
        table.insert(actions, ACTIONS.FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION)
    end
end)


AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION,function(player)
    return "dolongaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION, function(player)
    return "dolongaction"
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_PACKER_ACTION = {
    DEFAULT = "Pack"
}


