--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


     
     
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddComponentPostInit("inspectable", function(self)

    if self.inst.components.fwd_in_pdt_com_inspectable_spell_caster_for_target == nil then
        self.inst:AddComponent("fwd_in_pdt_com_inspectable_spell_caster_for_target")
    end
end)


local FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER = Action({priority = 0})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER.id = "FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER"
FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local target = act.target
    local doer = act.doer
    if doer then
        local replica_com = doer.replica.fwd_in_pdt_com_inspectable_spell_caster or doer.replica._.fwd_in_pdt_com_inspectable_spell_caster
        if replica_com then
            return replica_com:GetTextIndex()
        end
    end
    return "DEFAULT"
end

FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER.fn = function(act)    --- 只在服务端执行~
    local target = act.target
    local doer = act.doer

    if doer and doer.components.fwd_in_pdt_com_inspectable_spell_caster then
        local replica_com = doer.replica.fwd_in_pdt_com_inspectable_spell_caster or doer.replica._.fwd_in_pdt_com_inspectable_spell_caster
        if replica_com and replica_com:Test(target,true,{}) then
            return doer.components.fwd_in_pdt_com_inspectable_spell_caster:CastSpell(target)
        end
    end
    return false
end
AddAction(FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER)

---------------------------------------------------------
---- 为了避免多个inst用同一个动作造成冲突，调用前清除一些额外插入的参数。（没法用deepcopy 只能这样）
local base_index = {
    ["ghost_valid"] = true,
    ["id"] = true,
    ["instant"] = true,
    ["code"] = true,
    ["ghost_exclusive"] = true,
    ["mod_name"] = true,
    ["paused_valid"] = true,
    ["strfn"] = true,
    ["fn"] = true,
    ["encumbered_valid"] = true,
    ["mount_valid"] = true,
    ["distance"] = 0,
    ["priority"] = 0,
}
local function GetAction()
    local temp_action = ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER
    for index, v in pairs(base_index) do
        if temp_action[index] then

        else
            temp_action[index] = nil
        end
    end
    return temp_action
end
---------------------------------------------------------




AddComponentAction("SCENE", "fwd_in_pdt_com_inspectable_spell_caster_for_target" , function(target, doer, actions, right_click)-------    建筑一类的特殊交互使用，在地上的才算数
    if doer then
        local replica_com = doer.replica.fwd_in_pdt_com_inspectable_spell_caster or doer.replica._.fwd_in_pdt_com_inspectable_spell_caster
        if replica_com then
            local temp_action = GetAction()
            if replica_com:Test(target,right_click,temp_action) then
                table.insert(actions, temp_action)
            end
        end
    end
end)


local handler_fn = function(player)
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local item = player.bufferedaction.invobject
        local pos = player.bufferedaction.pos or {}

        local replica_com = player.replica.fwd_in_pdt_com_inspectable_spell_caster or player.replica._.fwd_in_pdt_com_inspectable_spell_caster
        if replica_com  then
            replica_com:DoPreAction(target)
            return replica_com:GetSGAction(target)
        end
        return "give"
    end)
    if creash_flag == true then
        return ret
    else
        print("error in FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER ActionHandler")
        print(ret)
    end
    return "give"
end

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER, function(player)
    return handler_fn(player)
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER = STRINGS.ACTIONS.FWD_IN_PDT_COM_INSPECTABLE_SPELL_CASTER or {
    DEFAULT = STRINGS.ACTIONS.CASTSPELL.GENERIC
}