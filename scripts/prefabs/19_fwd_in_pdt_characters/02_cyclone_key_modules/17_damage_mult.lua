--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    穿戴 带 暗影标签的装备  伤害 1.5倍。如果是洞里 则3倍
                            减伤50% ，如果是洞里，则减伤90%
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local DAMAGE_MULT = 1.5
    local DAMAGE_TAKEN_MULT = 0.5
    if TheWorld:HasTag("cave") then
        DAMAGE_MULT = 3
        DAMAGE_TAKEN_MULT = 0.1
    end

    local mult_inst = CreateEntity()
    mult_inst:ListenForEvent("onremove",function()
        mult_inst:Remove()
    end,inst)

    local function equip_unequip_check(inst)
        if inst.components.inventory:EquipHasTag("shadow") 
            or inst.components.inventory:EquipHasTag("shadow_item")
            or inst.components.inventory:EquipHasTag("shadowlevel")
             then
            inst.components.combat.externaldamagemultipliers:SetModifier(mult_inst,DAMAGE_MULT)
            inst.components.combat.externaldamagetakenmultipliers:SetModifier(mult_inst,DAMAGE_TAKEN_MULT)
        else
            inst.components.combat.externaldamagemultipliers:SetModifier(mult_inst,1)
            inst.components.combat.externaldamagetakenmultipliers:SetModifier(mult_inst,1)
        end
    end

    inst:DoTaskInTime(0, equip_unequip_check)
    inst:ListenForEvent("equip", equip_unequip_check)
    inst:ListenForEvent("unequip", equip_unequip_check)

end