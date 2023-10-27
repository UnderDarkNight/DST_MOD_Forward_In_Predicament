require("componentactions")


-----------------------------------------------------------------------------------------------------
--- NEXT skin
    local FWD_IN_PDT_RESKIN_ACTION_NEXT = Action({mount_valid = true,distance = 6,priority = 10,show_primary_input_left = true})
    FWD_IN_PDT_RESKIN_ACTION_NEXT.id = "FWD_IN_PDT_RESKIN_ACTION_NEXT"
    FWD_IN_PDT_RESKIN_ACTION_NEXT.strfn = function(act)
        if act.target and act.doer and act.invobject then
            return "NEXT"
        end
        return "NONE"
    end

    FWD_IN_PDT_RESKIN_ACTION_NEXT.fn = function(act)
        if act.invobject and act.doer and act.target and act.invobject.components.fwd_in_pdt_com_skins_tool  then
            act.invobject.components.fwd_in_pdt_com_skins_tool:NextSkin(act.target,act.doer)
            -- print("next ++++++++++")
            return true
        end
    end
    AddAction(FWD_IN_PDT_RESKIN_ACTION_NEXT)

-----------------------------------------------------------------------------------------------------
--- LAST skin
    local FWD_IN_PDT_RESKIN_ACTION_LAST = Action({mount_valid = true,distance = 6,priority = 10,show_secondary_input_right = true})
    FWD_IN_PDT_RESKIN_ACTION_LAST.id = "FWD_IN_PDT_RESKIN_ACTION_LAST"
    FWD_IN_PDT_RESKIN_ACTION_LAST.strfn = function(act)
        if act.target and act.doer and act.invobject then
            return "LAST"
        end
        return "NONE"
    end

    FWD_IN_PDT_RESKIN_ACTION_LAST.fn = function(act)
        if act.invobject and act.doer and act.target and act.invobject.components.fwd_in_pdt_com_skins_tool then
            -- print("last ++++++")
            act.invobject.components.fwd_in_pdt_com_skins_tool:LastSkin(act.target,act.doer)
            return true
        end
    end
    AddAction(FWD_IN_PDT_RESKIN_ACTION_LAST)
-----------------------------------------------------------------------------------------------------

AddComponentAction("EQUIPPED", "fwd_in_pdt_com_skins_tool" , function(inst, doer, target, actions, right)   ---- 这个会在 client 上执行
    if target and target:HasTag("fwd_in_pdt_com_skins")  and inst and doer then        
        if not right then
            table.insert(actions, ACTIONS.FWD_IN_PDT_RESKIN_ACTION_NEXT)   
        else
            table.insert(actions, ACTIONS.FWD_IN_PDT_RESKIN_ACTION_LAST)
        end
    end
end,modname)


AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_RESKIN_ACTION_NEXT,function(inst)
    return "quickcastspell"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_RESKIN_ACTION_NEXT, function(inst)
    return "quickcastspell"
end))
AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_RESKIN_ACTION_LAST,function(inst)
    return "quickcastspell"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_RESKIN_ACTION_LAST, function(inst)
    return "quickcastspell"
end))

STRINGS.ACTIONS.FWD_IN_PDT_RESKIN_ACTION_NEXT = {
    ["NONE"] = "",
    ["NEXT"] = "Next",
    ["LAST"] = "Last"
}
STRINGS.ACTIONS.FWD_IN_PDT_RESKIN_ACTION_LAST = {
    ["NONE"] = "",
    ["NEXT"] = "Next",
    ["LAST"] = "Last"
}

---- 挂载动作
local action_strings = TUNING["Forward_In_Predicament.fn"].GetStringsTable("fwd_in_pdt_com_skins_tool")
for action_name, str in pairs(action_strings) do
    STRINGS.ACTIONS.FWD_IN_PDT_RESKIN_ACTION_NEXT[string.upper(action_name)] = str
    STRINGS.ACTIONS.FWD_IN_PDT_RESKIN_ACTION_LAST[string.upper(action_name)] = str
end
