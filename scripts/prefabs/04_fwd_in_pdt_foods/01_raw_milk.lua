--------------------------------------------------------------------------
--- 食物
--- 生牛奶
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_raw_milk.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_raw_milk.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_raw_milk.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_raw_milk") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_raw_milk") -- 材质包，就是anim里的zip包
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_raw_milk"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_raw_milk.xml"

    --------------------------------------------------------------------------
    -- -- 烤制的函数在后面
    -- inst:AddComponent("cookable")
    -- inst.components.cookable.product = "fwd_in_pdt_food_raw_milk_cooked"
    --------------------------------------------------------------------------

    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(function(inst,eater)

    end)

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*10)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物
    ----------------------------------------------------------------------------------------------------
    -- -- 靠新鲜度 切换图标
    -- inst:ListenForEvent("perishchange", function(inst)
    --     if inst:HasTag("spoiled") then
    --         inst.components.inventoryitem.imagename = "fwd_in_pdt_food_raw_milk"
    --         inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_raw_milk_rot.xml"
    --         inst.components.acute_sia_com_data:Set("spoiled",true)
    --         inst.AnimState:PlayAnimation("rot")
    --         inst:PushEvent("imagechange")
    --     else
    --         inst.components.inventoryitem.imagename = "fwd_in_pdt_food_raw_milk"
    --         inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_raw_milk.xml"
    --         inst.components.acute_sia_com_data:Set("spoiled",false)
    --         inst.AnimState:PlayAnimation("idle")
    --         inst:PushEvent("imagechange")
    --     end
    -- end)
    -- --- 载入时候需要的
    -- inst.components.acute_sia_com_data:AddOnLoadFn(function()
    --     if inst.components.acute_sia_com_data:Get("spoiled") then
    --         inst.components.inventoryitem.imagename = "fwd_in_pdt_food_raw_milk_rot"
    --         inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_raw_milk_rot.xml"
    --         inst.AnimState:PlayAnimation("rot")
    --         inst:PushEvent("imagechange")
    --     else
    --         inst.components.inventoryitem.imagename = "fwd_in_pdt_food_raw_milk"
    --         inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_raw_milk.xml"
    --         inst.AnimState:PlayAnimation("idle")
    --         inst:PushEvent("imagechange")
    --     end
    -- end)
    ----------------------------------------------------------------------------------------------------
    --- 吃东西恢复的三维
    inst.components.edible.hungervalue = 15
    inst.components.edible.sanityvalue = -10
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
    local r,g,b,a = 209/255 , 127/255 ,170/255 , 200/255
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_food_raw_milk",
        build = "fwd_in_pdt_food_raw_milk",
        anim = "icon",
        hide_image = true,
        text = {
            -- color = {r,g,b,1},
            pt = Vector3(-14,16,0),
        --     -- size = 35,
        }
    })
    -------------------------------------------------------------------
    
    return inst
end
-- --- 烤制部分
-- local function common_cooked_fn()

--     local inst = CreateEntity()
--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddNetwork()

--     MakeInventoryPhysics(inst)

--     inst.AnimState:SetBank("fwd_in_pdt_food_cooked_milk")
--     inst.AnimState:SetBuild("fwd_in_pdt_food_cooked_milk")
--     inst.AnimState:PlayAnimation("cooked") -- 动画名字 照着做
--     MakeInventoryFloatable(inst)

--     inst:AddTag("green_raisins")

--     inst.entity:SetPristine()
    
--     if not TheWorld.ismastersim then
--         return inst
--     end
--     --------------------------------------------------------------------------
--     ------ 物品名 和检查文本
--     inst:AddComponent("inspectable")

--     inst:AddComponent("inventoryitem")
--     -- -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
--     inst.components.inventoryitem.imagename = "fwd_in_pdt_food_cooked_milk"
--     inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_cooked_milk.xml"

    --------------------------------------------------------------------------


--     inst:AddComponent("edible") -- 可食物组件
--     inst.components.edible.foodtype = FOODTYPE.GOODIES
--     -- inst.components.edible.secondaryfoodtype = FOODTYPE.BERRY
--     inst.components.edible:SetOnEatenFn(function(inst,eater)
--     end)
--     inst.components.edible.hungervalue = 12.5
--     inst.components.edible.sanityvalue = 0
--     inst.components.edible.healthvalue = 5

--     inst:AddComponent("stackable") -- 可堆叠
--     inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
--     inst:AddComponent("tradable")

--     MakeHauntableLaunch(inst)
--     -------------------------------------------------------------------
--     -- 
--         -- inst:AddComponent("acute_sia_com_data")
--     -------------------------------------------------------------------
--     --- 
--         inst:AddComponent("perishable") -- 可腐烂的组件
--         inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
--         inst.components.perishable:StartPerishing()
--         inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物
--     -------------------------------------------------------------------

--     -------------------------------------------------------------------
    
--     return inst
-- end

--- 设置可以放烹饪锅里(names tags cancook candry)
AddIngredientValues({"fwd_in_pdt_food_raw_milk"}, {
    dairy = 1,
})
-- AddIngredientValues({"fwd_in_pdt_food_raw_milk_cooked"}, {dairy = 1,})

return Prefab("fwd_in_pdt_food_raw_milk", fn, assets)
    -- Prefab("fwd_in_pdt_food_raw_milk_cooked", common_cooked_fn, assets)