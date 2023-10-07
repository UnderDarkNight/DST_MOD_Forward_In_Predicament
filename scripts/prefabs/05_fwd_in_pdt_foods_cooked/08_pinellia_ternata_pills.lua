--------------------------------------------------------------------------
--- 食物
--- 半夏药丸
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_pinellia_ternata_pills.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_pinellia_ternata_pills.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_pinellia_ternata_pills.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_pinellia_ternata_pills") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_pinellia_ternata_pills") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_pinellia_ternata_pills"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_pinellia_ternata_pills.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") then
            --- 恢复体温到 12
            if eater.components.temperature and eater.components.temperature.current > 12 then
                eater.components.temperature:SetTemperature(12)
            end
            --- 沙尘暴屏蔽视野
            if eater.components.playervision then
                eater.components.playervision:ForceGoggleVision(true)
                --- 取消旧的计时器
                if eater.__temp_fwd_in_pdt_food_pinellia_ternata_pills_task then
                    eater.__temp_fwd_in_pdt_food_pinellia_ternata_pills_task:Cancel()
                    eater.__temp_fwd_in_pdt_food_pinellia_ternata_pills_task = nil
                end
                --- 5分钟后关闭视野
                eater.__temp_fwd_in_pdt_food_pinellia_ternata_pills_task = eater:DoTaskInTime(300,function()
                    eater.components.playervision:ForceGoggleVision(false)    
                    eater.__temp_fwd_in_pdt_food_pinellia_ternata_pills_task = nil                
                end)

            end
        end
    end)

    -- inst:AddComponent("perishable") -- 可腐烂的组件
    -- inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    -- inst.components.perishable:StartPerishing()
    -- inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.healthvalue = 0

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

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

return Prefab("fwd_in_pdt_food_pinellia_ternata_pills", fn, assets)