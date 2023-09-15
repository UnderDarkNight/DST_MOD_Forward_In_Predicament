--[[


    雄黄矿


]]--

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_material_realgar.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("fwd_in_pdt_material_realgar")
    inst.AnimState:SetBuild("fwd_in_pdt_material_realgar")
    inst.AnimState:PlayAnimation("idle")

    inst.pickupsound = "rock"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("edible")
    -- inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    -- inst.components.edible.hungervalue = 1
    -- inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)

    -- inst:AddComponent("repairer")
    -- inst.components.repairer.repairmaterial = MATERIALS.MOONROCK
    -- inst.components.repairer.healthrepairvalue = TUNING.REPAIR_MOONROCK_NUGGET_HEALTH
    -- inst.components.repairer.workrepairvalue = TUNING.REPAIR_MOONROCK_NUGGET_WORK

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("fwd_in_pdt_material_realgar", fn, assets)