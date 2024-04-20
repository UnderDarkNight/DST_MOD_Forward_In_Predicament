--[[

    防亮茄涂层
    
]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_material_avoidable_lunarthrall_plant.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_avoidable_lunarthrall_plant.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_avoidable_lunarthrall_plant.tex" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1,0.6)
    inst.AnimState:SetScale(2,2,2)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("fwd_in_pdt_material_avoidable_lunarthrall_plant")
    inst.AnimState:SetBank("fwd_in_pdt_material_avoidable_lunarthrall_plant")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_avoidable_lunarthrall_plant"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_avoidable_lunarthrall_plant.xml"    

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_material_avoidable_lunarthrall_plant", fn, assets)