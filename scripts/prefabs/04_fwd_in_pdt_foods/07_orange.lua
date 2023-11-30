--------------------------------------------------------------------------
--- 食物
--- 橙子
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_orange.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_orange.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_orange.xml" ),

}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_orange") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_orange") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_orange"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_orange.xml"

    --------------------------------------------------------------------------
    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*10)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物
    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") then
            -- Vc增加10
            if eater.components.fwd_in_pdt_wellness then
                eater.components.fwd_in_pdt_wellness:DoDelta_Vitamin_C(10)
                eater.components.fwd_in_pdt_wellness:ForceRefresh()
            end
        end
    end)
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 10
    inst.components.edible.healthvalue = 10

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    -------------------------------------------------------------------
    
    return inst
end

--- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_food_orange"}, { 
    fruit = 1,
})

return Prefab("fwd_in_pdt_food_orange", fn, assets)