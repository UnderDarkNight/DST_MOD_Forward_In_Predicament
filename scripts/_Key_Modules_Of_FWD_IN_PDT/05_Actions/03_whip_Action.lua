


local FWD_IN_PDT_WHIP_ACTION = Action({mount_valid = true,distance = 6})
FWD_IN_PDT_WHIP_ACTION.id = "FWD_IN_PDT_WHIP_ACTION"
FWD_IN_PDT_WHIP_ACTION.strfn = function(act)
    if act.target and act.doer and act.invobject then
        local flag,action = act.invobject.components.fwd_in_pdt_com_whip:CanCastSpell(act.doer,act.target)
        if flag then
            return action or "DEFAULT"
        end
    end
    return "NONE"
end

FWD_IN_PDT_WHIP_ACTION.fn = function(act)
    if act.invobject and act.invobject.components.fwd_in_pdt_com_whip and act.target then
		act.invobject.components.fwd_in_pdt_com_whip:CastSpell(act.doer,act.target)
		return true
    end
end
AddAction(FWD_IN_PDT_WHIP_ACTION)

AddComponentAction("EQUIPPED", "fwd_in_pdt_com_whip" , function(inst, doer, target, actions, right)   ---- 这个会在 client 上执行
    if right and target and target ~= doer and inst.components.fwd_in_pdt_com_whip:CanCastSpell(doer,target) then
        table.insert(actions, ACTIONS.FWD_IN_PDT_WHIP_ACTION)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_WHIP_ACTION,function(inst)
    return "dojostleaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_WHIP_ACTION, function(inst)
    return "dojostleaction"
end))

STRINGS.ACTIONS.FWD_IN_PDT_WHIP_ACTION = {
    ["NONE"] = "",
}
---- 挂载动作
local action_strings = TUNING["Forward_In_Predicament.fn"].GetStringsTable("fwd_in_pdt_com_whip_action")
for action_name, str in pairs(action_strings) do
    STRINGS.ACTIONS.FWD_IN_PDT_WHIP_ACTION[string.upper(action_name)] = str
end