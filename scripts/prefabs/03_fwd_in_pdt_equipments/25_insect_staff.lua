--------------------------------------------------------------------------
--- 装备 ，武器
--- 昆虫法杖
--------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_insect_staff.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_insect_staff_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.xml" ),

}

local function onequip(inst, owner)

	owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_repair_staff_swap", "swap_object")    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")


    owner.isbeeking = true  -- 靠近杀人蜂巢穴不会出杀人蜂

	owner:AddTag("insect")  -- 昆虫标签，防止被蜜蜂主动叮咬  貌似是采摘蜂蜜不会出蜜蜂

    -- owner.components.fwd_in_pdt_remove_tag_blocker:Add("insect")

end

local function onunequip(inst, owner)
    
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")

    owner.isbeeking = nil  -- 结束hook

    -- owner.components.fwd_in_pdt_remove_tag_blocker:Remove("insect")

    owner:RemoveTag("insect")--昆虫标签，防止被蜜蜂主动叮咬  貌似是采摘蜂蜜不会出蜜蜂

    

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_insect_staff")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_insect_staff")
    inst.AnimState:PlayAnimation("idle")

    
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("spear")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_insect_staff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    -------
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_equipment_insect_staff", fn, assets)