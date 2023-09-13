--------------------------------------------------------------------------
--- 食物
--- 疙瘩汤
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_mixed_potato_soup.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_mixed_potato_soup.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_mixed_potato_soup.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_mixed_potato_soup") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_mixed_potato_soup") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_mixed_potato_soup"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_mixed_potato_soup.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        -- if eater and eater:HasTag("player") then
        --     ---- 给计时器添加 时间，超过1天的算一天。
        --     if eater.components.npng_database:Add("npng_debuff_vitamin_c_retention_buff",480) > 480 then
        --         eater.components.npng_database:Set("npng_debuff_vitamin_c_retention_buff",480) --- 
        --     end
        --     ---- 上倒计时debuff
        --     if not eater:HasDebuff("npng_debuff_vitamin_c_retention_buff") then
        --         eater:AddDebuff("npng_debuff_vitamin_c_retention_buff","npng_debuff_vitamin_c_retention_buff")
        --     end
        -- end
    end)

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 150
    inst.components.edible.sanityvalue = 30
    inst.components.edible.healthvalue = 20

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

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
    
    return inst
end

return Prefab("fwd_in_pdt_food_mixed_potato_soup", fn, assets)