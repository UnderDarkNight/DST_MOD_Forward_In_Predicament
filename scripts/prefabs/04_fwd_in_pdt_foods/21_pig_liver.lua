--------------------------------------------------------------------------
--- 食物
--- 猪肝
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_pig_liver.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_pig_liver.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_pig_liver.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_pig_liver") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_pig_liver") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_pig_liver"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_pig_liver.xml"

    --------------------------------------------------------------------------
    inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失

    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.MEAT
    --恢复20Vc
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") then
            -- Vc增加20
            if eater.components.fwd_in_pdt_wellness then
                eater.components.fwd_in_pdt_wellness:DoDelta_Vitamin_C(20)
                eater.components.fwd_in_pdt_wellness:ForceRefresh()
            end
        end
    end)

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*10)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = -20
    inst.components.edible.healthvalue = -5

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

--- 设置可以放烹饪锅里
AddIngredientValues({"fwd_in_pdt_food_pig_liver"}, { 
    meat = 0.5
})

return Prefab("fwd_in_pdt_food_pig_liver", fn, assets)