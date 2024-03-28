--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function spell_a_setup_fn_for_player(inst)
        ------------------------------------------------------------------------------------------
            local function spell_a_setup(spell_item)
                local replica_com = spell_item.replica.fwd_in_pdt_com_point_and_target_spell_caster or spell_item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
                print("replica_com spell_a_setup ",replica_com)
                if replica_com then
                    replica_com:SetDistance(30)
                    replica_com:SetPriority(90)
                    replica_com:SetTestFn(function(spell_item,doer,target,pt,right_click)
                        print("test ++++ a")
                        return true
                    end)
                    replica_com:SetText("cyclone_spell_a","技能A")
                    replica_com:SetSGAction("castspell")
                end

                local com = spell_item.components.fwd_in_pdt_com_point_and_target_spell_caster
                print("com spell_a_setup ",com)
                if com then
                    com:SetSpellFn(function(spell_item,doer,target,pt)
                        print("spell a  pt ",pt)
                        return true
                    end)
                end
            end
        ------------------------------------------------------------------------------------------
            inst:ListenForEvent("fwd_in_pdt_spell_key_a_press",function(inst)
                print("info  spell switch to A")                
                local spell_item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
                if spell_item then                
                    spell_a_setup(spell_item)
                    inst.replica.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_spell_key_a_press_server")
                end
            end)
            if TheWorld.ismastersim then
                inst:ListenForEvent("fwd_in_pdt_spell_key_a_press_server",function(inst)
                    local spell_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
                    if spell_item then
                        spell_a_setup(spell_item)
                    end
                end)
            end
        ------------------------------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function spell_b_setup_fn_for_player(inst)
        ------------------------------------------------------------------------------------------
            local function spell_b_setup(spell_item)
                local replica_com = spell_item.replica.fwd_in_pdt_com_point_and_target_spell_caster or spell_item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
                print("replica_com spell_b_setup ",replica_com)                
                if replica_com then
                    replica_com:SetDistance(30)
                    replica_com:SetPriority(90)
                    replica_com:SetTestFn(function(spell_item,doer,target,pt,right_click)
                        print("test+++++ b")
                        return true
                    end)
                    replica_com:SetText("cyclone_spell_b","技能B")
                    replica_com:SetSGAction("give")
                end

                local com = spell_item.components.fwd_in_pdt_com_point_and_target_spell_caster
                print("com spell_b_setup ",com)
                if com then
                    com:SetSpellFn(function(spell_item,doer,target,pt)
                        print("spell b  pt ",pt)
                        return true
                    end)
                end

            end
        ------------------------------------------------------------------------------------------
            inst:ListenForEvent("fwd_in_pdt_spell_key_b_press",function(inst)
                print("info  spell switch to B")
                local spell_item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
                if spell_item then                
                    spell_b_setup(spell_item)
                    inst.replica.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_spell_key_b_press_server")
                end
            end)
            if TheWorld.ismastersim then
                inst:ListenForEvent("fwd_in_pdt_spell_key_b_press_server",function(inst)
                    local spell_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
                    if spell_item then
                        spell_b_setup(spell_item)
                    end
                end)
            end
        ------------------------------------------------------------------------------------------
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    -- spell_a_setup_fn_for_player(inst)
    -- spell_b_setup_fn_for_player(inst)
end