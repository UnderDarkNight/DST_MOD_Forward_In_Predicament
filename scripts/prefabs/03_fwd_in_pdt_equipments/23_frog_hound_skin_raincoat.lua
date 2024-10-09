-- 蛤皮雨衣



local assets =
{
    Asset( "ANIM", "anim/fwd_in_pdt_frog_hound_skin_raincoat.zip" ),
    Asset( "ANIM", "anim/fwd_in_pdt_frog_hound_skin_raincoat_swap.zip" ),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_frog_hound_skin_raincoat.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_frog_hound_skin_raincoat.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "fwd_in_pdt_frog_hound_skin_raincoat_swap", "swap_body")
    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
end

local function onequiptomodel(inst)
    inst.components.fueled:StopConsuming()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_frog_hound_skin_raincoat")
    inst.AnimState:SetBuild("fwd_in_pdt_frog_hound_skin_raincoat")
    inst.AnimState:PlayAnimation("idle")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "small", 0.1, 0.78)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BELLY  or EQUIPSLOTS.BODY -- BELLY是奶酪那个六格装备  为了兼容写的对应的插槽  理论上还是放BODY上吧！
    inst.components.equippable.insulated = true
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE*5)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.RAINCOAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeHauntableLaunch(inst)

  --本来是保暖的写法
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED*4)   -- 480
    inst.components.insulator:SetSummer()---有这一行 就变为隔热480了


    return inst
end

return Prefab( "fwd_in_pdt_frog_hound_skin_raincoat", fn, assets)
