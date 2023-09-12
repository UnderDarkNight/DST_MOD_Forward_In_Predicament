------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    · 暗影剑


]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Calling_Stars_Staff = "yellowstaff"
local Calling_Moon_Staff = "opalstaff"
local function staff_upgrade(inst)
        local old_fn = inst.components.spellcaster.spell
        inst.components.spellcaster.spell = function(inst,target,pos,doer)
            old_fn(inst,target,pos,doer)

            if doer  and doer:HasTag("player") and doer.components.playercontroller then
                local Probability =  TUNING["Forward_In_Predicament.Config"].Element_Core_Probability  or 0.1
                if math.random(1000)/1000 <= Probability or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            -- local reward_prefab_name = "fwd_in_pdt_item_ice_core"
                            -- local reward_prefab_name = "fwd_in_pdt_item_flame_core"
                            local reward_prefab_name = nil
                            if inst.prefab == Calling_Stars_Staff then
                                reward_prefab_name = "fwd_in_pdt_item_flame_core"
                            elseif inst.prefab == Calling_Moon_Staff then
                                reward_prefab_name = "fwd_in_pdt_item_ice_core"
                            end
                            if reward_prefab_name then
                                doer.components.inventory:GiveItem(SpawnPrefab(reward_prefab_name))
                            end

                end
            end

        end


end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    Calling_Moon_Staff,        --- 唤月法杖
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        staff_upgrade(inst)
    end
)
AddPrefabPostInit(
    Calling_Stars_Staff,        --- 唤星法杖
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        staff_upgrade(inst)
    end
)