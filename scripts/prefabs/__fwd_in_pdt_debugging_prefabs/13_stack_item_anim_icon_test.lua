
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_test_item_icon.zip"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueprint")
    inst.AnimState:SetBuild("blueprint")
    inst.AnimState:PlayAnimation("idle")

    --Sneak these into pristine state for optimization

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")
    inst:AddComponent("stackable")

    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_test_item_icon", 
        build = "fwd_in_pdt_test_item_icon" ,
        anim = "idle",
     })

    MakeHauntableLaunch(inst)


    return inst
end

return Prefab("fwd_in_pdt_test_item_stackable_anim", fn,assets)