--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------
    local function GetStringsTable(prefab_name)
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name or "fwd_in_pdt_cyclone")
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------
    local HUNGER_COST_NUM = 100
    if TheWorld:HasTag("cave") then
        HUNGER_COST_NUM = 10
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ test 函数   
    local replica_test_fn = function(inst,replica_com,target,right_click,temp_action)

            if right_click and target and 
                target:HasOneOfTags({"CHOP_workable","MINE_workable","HAMMER_workable","_combat"}) and 
                not target:HasOneOfTags({"companion","player", "brightmare", "playerghost", "INLIMBO", "DECOR", "FX"}) then
                if inst.replica.hunger:GetCurrent() < HUNGER_COST_NUM then
                    return false
                end
                local weapon = inst.replica.combat and inst.replica.combat:GetWeapon()
                temp_action.priority = weapon and -2 or 0
                temp_action.distance = 15
                return true
            end
        
        return false
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ spell 函数
    local cast_spell_fn = function(inst,target)
        if inst.replica.hunger:GetCurrent() < HUNGER_COST_NUM then
            return false
        end
        inst.components.hunger:DoDelta(-HUNGER_COST_NUM)
        inst:PushEvent("create_red_tornado_for_target",target)
        return true
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    

    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_inspectable_spell_caster",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,target,right_click,temp_action)
            return replica_test_fn(inst,replica_com,target,right_click,temp_action)
        end)
        replica_com:SetText("cyclone_workable_spell",GetStringsTable()["spell_only_right_click"])
    end)
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_inspectable_spell_caster")
        inst.components.fwd_in_pdt_com_inspectable_spell_caster:SetSpellFn(cast_spell_fn)
    end

end