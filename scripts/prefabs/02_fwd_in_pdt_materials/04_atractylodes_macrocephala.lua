--[[


    苍术


]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_atractylodes_macrocephala.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_atractylodes_macrocephala.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_atractylodes_macrocephala.tex" ),
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

    inst.AnimState:SetBuild("fwd_in_pdt_plant_atractylodes_macrocephala")
    inst.AnimState:SetBank("fwd_in_pdt_plant_atractylodes_macrocephala")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_atractylodes_macrocephala"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_atractylodes_macrocephala.xml"    

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

    MakeHauntableLaunch(inst)

    return inst
end

-- --- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_material_atractylodes_macrocephala"}, { 
    veggie = 1
})

return Prefab("fwd_in_pdt_material_atractylodes_macrocephala", fn, assets)