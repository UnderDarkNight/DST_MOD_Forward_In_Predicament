--[[


    半夏


]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_pinellia_ternata.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_pinellia_ternata.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_pinellia_ternata.tex" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1,0.6)
    inst.AnimState:SetScale(.5,.5,.5)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:SetBank("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_pinellia_ternata"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_pinellia_ternata.xml"    

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
    MakeHauntableLaunch(inst)

    return inst
end

-- --- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_material_pinellia_ternata"}, { 
    veggie = 1
})

return Prefab("fwd_in_pdt_material_pinellia_ternata", fn, assets)