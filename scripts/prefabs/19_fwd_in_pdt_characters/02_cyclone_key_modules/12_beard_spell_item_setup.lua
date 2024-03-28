--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    先预留这个框框的位置

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    local function setup_item(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BEARD)
        if item == nil or not item:IsValid() then
            inst.components.inventory:Equip(SpawnPrefab("fwd_in_pdt_spell_item_for_cyclone"))
        end
    end


    inst:DoTaskInTime(0,setup_item)
    inst:ListenForEvent("beard_spell_inst_removed",function(inst)
        inst:DoTaskInTime(0.1,setup_item)
    end)
    inst:ListenForEvent("ms_respawnedfromghost",function(inst)
        inst:DoTaskInTime(1,setup_item)
    end)


end