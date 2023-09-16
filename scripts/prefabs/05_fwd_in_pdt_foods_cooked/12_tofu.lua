--------------------------------------------------------------------------
--- 食物
--- 豆腐
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_tofu.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_tofu.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_tofu.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_tofu") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_tofu") -- 材质包，就是anim里的zip包
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_tofu"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_tofu.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
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
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 25
    inst.components.edible.sanityvalue = 20
    inst.components.edible.healthvalue = 1

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
    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    -- local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
    -- local r,g,b,a = 209/255 , 127/255 ,170/255 , 200/255
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_food_tofu",
        build = "fwd_in_pdt_food_tofu",
        anim = "icon",
        hide_image = true,
        -- text = {
        --     -- color = {r,g,b,1},
        --     pt = Vector3(-14,16,0),
        --     -- size = 35,
        -- }
    })
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_food_tofu", fn, assets)