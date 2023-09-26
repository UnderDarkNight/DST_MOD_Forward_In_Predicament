--[[


    紫苑


]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_aster_tataricus_l_f.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_aster_tataricus_l_f.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_aster_tataricus_l_f.tex" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1,0.6)
    inst.AnimState:SetScale(.7,.7,.7)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("fwd_in_pdt_plant_aster_tataricus_l_f")
    inst.AnimState:SetBank("fwd_in_pdt_plant_aster_tataricus_l_f")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_aster_tataricus_l_f"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_aster_tataricus_l_f.xml"    

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
    MakeHauntableLaunch(inst)

    return inst
end

-- --- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_material_aster_tataricus_l_f"}, { 
    veggie = 1
})

return Prefab("fwd_in_pdt_material_aster_tataricus_l_f", fn, assets)