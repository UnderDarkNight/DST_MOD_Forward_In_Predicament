


local LOS_GOLDEN_WHIP = Action({mount_valid = true,distance = 6})
LOS_GOLDEN_WHIP.id = "LOS_GOLDEN_WHIP"
LOS_GOLDEN_WHIP.strfn = function(act)
    if act.target and ( act.target.replica.follower or ( act.target:HasTag("player") and act.target:HasTag("playerghost") ) ) then
        return "DEFAULT"
    end
    return "NONE"
end

LOS_GOLDEN_WHIP.fn = function(act)
    if act.invobject and act.invobject.components.los_com_golden_whip and act.target then
		act.invobject.components.los_com_golden_whip:CastSpell(act.doer,act.target)
		return true
    end
end
AddAction(LOS_GOLDEN_WHIP)

AddComponentAction("EQUIPPED", "los_com_golden_whip" , function(inst, doer, target, actions, right)
    if right and target and target ~= doer and target.replica.health then
        table.insert(actions, ACTIONS.LOS_GOLDEN_WHIP)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(LOS_GOLDEN_WHIP,function(inst)
    return "dojostleaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(LOS_GOLDEN_WHIP, function(inst)
    return "dojostleaction"
end))

STRINGS.ACTIONS.LOS_GOLDEN_WHIP = {
    DEFAULT = "抽",
    NONE = ""
}