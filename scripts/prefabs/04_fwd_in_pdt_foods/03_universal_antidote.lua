--------------------------------------------------------------------------
--- 食物
--- 万能解毒剂
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_universal_antidote.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_universal_antidote.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_universal_antidote.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_universal_antidote") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_universal_antidote") -- 材质包，就是anim里的zip包
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
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_universal_antidote"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_universal_antidote.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") then
            -- 清除各种毒，和 中毒值
            if eater.components.fwd_in_pdt_wellness then
                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_snake_poison")
                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_frog_poison")
                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_spider_poison")
                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_bee_poison")
                eater.components.fwd_in_pdt_wellness:SetCurrent_Poison(0)
            end
        end
    end)

    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.healthvalue = 0

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_food_universal_antidote", fn, assets)