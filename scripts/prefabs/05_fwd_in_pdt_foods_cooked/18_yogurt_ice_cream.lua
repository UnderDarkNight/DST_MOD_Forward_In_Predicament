--------------------------------------------------------------------------
--- 食物
--- 酸奶冰淇淋
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_yogurt_ice_cream.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_yogurt_ice_cream.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_yogurt_ice_cream.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_yogurt_ice_cream") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_yogurt_ice_cream") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
    -- MakeInventoryFloatable(inst)

    inst:AddTag("frozen")   --- 给腐烂组件用的
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_yogurt_ice_cream"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_yogurt_ice_cream.xml"
    inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater:HasTag("player") and not eater:HasTag("playerghost") then

            if eater.components.freezable then
                eater.components.freezable:AddColdness(5)  --- 增加5层冰冻层数，似乎刚好冻结
            end
        end
            --- 体温低 10 体温
            if eater.components.temperature then
                eater.components.temperature:DoDelta(-10)
            end
    end)

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 30
    inst.components.edible.healthvalue = 20

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
                -- local x,y,z = inst.Transform:GetWorldPosition()
                -- SpawnPrefab("fwd_in_pdt_fx_splash_sink"):PushEvent("Set",{
                --     pt = Vector3(x,0,z),
                --     -- scale = Vector3(0.3,0.3,0.3),
                -- })
                -- inst:Remove()
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
        bank = "fwd_in_pdt_food_yogurt_ice_cream",
        build = "fwd_in_pdt_food_yogurt_ice_cream",
        anim = "icon",
        hide_image = true,
        text = {
        --     -- color = {r,g,b,1},
            pt = Vector3(-14,16,0),
        --     -- size = 35,
        }
    })
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_food_yogurt_ice_cream", fn, assets)