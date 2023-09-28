------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    · 唤月/唤星 法杖


]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Calling_Stars_Staff = "yellowstaff"
local Calling_Moon_Staff = "opalstaff"
local function staff_upgrade(inst)
        inst:AddComponent("fwd_in_pdt_data")

        --------------- 
            local function GiveItem2Player(inst,player)
                local reward_prefab_name = nil
                if inst.prefab == Calling_Stars_Staff then
                    reward_prefab_name = "fwd_in_pdt_item_flame_core"
                elseif inst.prefab == Calling_Moon_Staff then
                    reward_prefab_name = "fwd_in_pdt_item_ice_core"
                end
                if reward_prefab_name then
                    player.components.inventory:GiveItem(SpawnPrefab(reward_prefab_name))
                end
            end
        --------------- 法杖施法的时候
            local old_fn = inst.components.spellcaster.spell
            inst.components.spellcaster.spell = function(inst,target,pos,doer)
                old_fn(inst,target,pos,doer)

                if doer  and doer:HasTag("player") and doer.components.playercontroller then
                    local Probability =  TUNING["Forward_In_Predicament.Config"].Element_Core_Probability  or 0.1
                    if math.random(1000)/1000 <= Probability or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                                -- local reward_prefab_name = "fwd_in_pdt_item_ice_core"
                                -- local reward_prefab_name = "fwd_in_pdt_item_flame_core"
                                GiveItem2Player(inst,doer)
                                inst.components.fwd_in_pdt_data:Set("rewarded_flag",true) --- 保底标记位
                    end
                end

            end
        --------------- 保底奖励，耐久度用完，武器要被删的时候检查
            if inst.components.finiteuses then

                                local old_finish_fn = inst.components.finiteuses.onfinished or nil
                                inst.components.finiteuses.onfinished = function(inst)
                                    
                                    if not inst.components.fwd_in_pdt_data:Get("rewarded_flag") then
                                        local owner = inst.components.inventoryitem:GetGrandOwner()
                                        if owner then
                                                GiveItem2Player(inst,owner)
                                        end
                                    end

                                    ---- 运行原有的旧函数
                                    if type(old_finish_fn) == "function" then
                                        old_finish_fn(inst)
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