


local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_element_cores.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_ice_core.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_ice_core.xml" ),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_element_cores")
    inst.AnimState:SetBuild("fwd_in_pdt_element_cores")
    inst.AnimState:PlayAnimation("idle_blue",true)
    inst.AnimState:SetScale(1.5, 1.5, 1.5)
    inst.DynamicShadow:SetSize(0.7, 0.7)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")



	inst:AddTag("fwd_in_pdt_item_ice_core")

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("bluegem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_ice_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_ice_core.xml"

    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_element_cores",
        build = "fwd_in_pdt_element_cores",
        anim = "icon_blue",
        hide_image = true,
        text = {
            color = {100/255,255/255,255/255},
            pt = Vector3(-14,16,0),
            size = 35,
        }
    })

    inst:AddComponent("stackable")  -- 可叠堆

    MakeHauntableLaunch(inst)



    return inst
end

return Prefab("fwd_in_pdt_item_ice_core", fn, assets)
