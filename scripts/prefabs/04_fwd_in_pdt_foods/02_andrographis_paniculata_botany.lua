--------------------------------------------------------------------------
--- 食物
--- 雄黄饮剂
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_andrographis_paniculata_botany.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_andrographis_paniculata_botany.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_andrographis_paniculata_botany.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_andrographis_paniculata_botany") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_andrographis_paniculata_botany") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    -- MakeInventoryFloatable(inst)
    inst:AddTag("preparedfood")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_andrographis_paniculata_botany"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_andrographis_paniculata_botany.xml"
    inst.components.inventoryitem:SetSinks(true)

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") and eater.components.fwd_in_pdt_wellness then
            if eater.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_snake_poison") then
                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_snake_poison")
                eater.components.fwd_in_pdt_wellness:DoDelta_Poison(-25)
                if eater.components.sanity then
                    eater.components.sanity:DoDelta(-10)
                end
                if eater.components.health and eater.components.health.currenthealth > 10 then
                    eater.components.health:DoDelta(-10,nil,inst.prefab)
                end
            end

        end
    end)


    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.healthvalue = 0

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)
    
    return inst
end

return Prefab("fwd_in_pdt_food_andrographis_paniculata_botany", fn, assets)