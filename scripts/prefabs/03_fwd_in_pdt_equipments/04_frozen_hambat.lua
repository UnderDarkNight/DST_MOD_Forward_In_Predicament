--------------------------------------------------------------------------
--- 装备 ，武器
--- 极寒长矛
--- 
--------------------------------------------------------------------------




local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_frozen_hambat.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_frozen_hambat_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_frozen_hambat.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_frozen_hambat.xml" ),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_frozen_hambat_swap", "swap_object")
    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_frozen_hambat")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_frozen_hambat")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("hambat")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_frozen_hambat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_frozen_hambat.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0) --- 伤害由于雨天变化，在这设置0，靠下面hook 函数
    -------

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(150)
    -- inst.components.finiteuses:SetUses(150)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    ---------------------------------------------------------------------------------------------
    --- 添加长矛特殊效果代码
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        
    end)    
    ---------------------------------------------------------------------------------------------
    --- 下雨天 2倍伤害 
    --- hook weapon 的 GetDamage 函数
    inst.components.weapon.GetDamage__npng_old = inst.components.weapon.GetDamage
    inst.components.weapon.GetDamage = function(self,...)
        if TheWorld.state.israining then
            return TUNING.HAMBAT_DAMAGE * 2
        else
            return TUNING.HAMBAT_DAMAGE
        end
    end
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_frozen_hambat", fn, assets)