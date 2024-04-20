--------------------------------------------------------------------------
--- 食物
--- 芒果
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_mango.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_mango.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_mango.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_mango_green.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_mango_green.xml" ),
}

local function common_fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_mango") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_mango") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("yellow") -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_food_universal_antidote"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_universal_antidote.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    -- inst.components.edible.foodtype = FOODTYPE.BERRY
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible:SetOnEatenFn(function(inst,eater)
    end)
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.healthvalue = 0

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    -------------------------------------------------------------------
    
    return inst
end

local function yellow()
    local inst = common_fn()
    inst.AnimState:PlayAnimation("yellow") -- 默认播放哪个动画

    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 20
    inst.components.edible.healthvalue = 10

    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_mango"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_mango.xml"

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*2)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    return inst
end
local function green()
    local inst = common_fn()
    inst.AnimState:PlayAnimation("green") -- 默认播放哪个动画
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.hungervalue = 5
    inst.components.edible.sanityvalue = 5
    inst.components.edible.healthvalue = 5

    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_mango_green"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_mango_green.xml"

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*3)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    return inst
end

--- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_food_mango"}, { 
    fruit = 1,
})
--- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_food_mango_green"}, { 
    fruit = 1,
})

return Prefab("fwd_in_pdt_food_mango", yellow, assets),Prefab("fwd_in_pdt_food_mango_green", green, assets)