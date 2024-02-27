--[[


    二蛤皮


]]--


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_material_frog_hound_skin.zip"),
    Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_material_frog_hound_skin.xml"),
    Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_material_frog_hound_skin.tex" ),
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

    inst.AnimState:SetBuild("fwd_in_pdt_material_frog_hound_skin")
    inst.AnimState:SetBank("fwd_in_pdt_material_frog_hound_skin")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_material_frog_hound_skin"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_material_frog_hound_skin.xml"    

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    MakeHauntableLaunch(inst)

    return inst
end

--- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_material_frog_hound_skin"}, { 
    inedible = 1 -- inedible：不可食用的
})

return Prefab("fwd_in_pdt_material_frog_hound_skin", fn, assets)