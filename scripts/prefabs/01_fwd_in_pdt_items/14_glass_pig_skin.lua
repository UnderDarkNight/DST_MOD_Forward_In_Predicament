--------------------------------------------------------------------------
-- 道具
-- 玻璃猪皮
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_pig_skin"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_glass_pig_skin.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_glass_pig_skin.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_glass_pig_skin.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_glass_pig_skin") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_glass_pig_skin") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("fwd_in_pdt_item_glass_pig_skin")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_glass_pig_skin"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_glass_pig_skin.xml"
    
    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    -------------------------------------------------------------------
    -- inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    -- inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
    --     bank = "inventory_fx_shadow",
    --     build = "inventory_fx_shadow",
    --     anim = "idle",

    -- })
    -------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_item_glass_pig_skin", fn, assets)