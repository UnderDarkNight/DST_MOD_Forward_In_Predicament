--------------------------------------------------------------------------
--- 食物
--- 蛋黄月饼
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_egg_mooncake.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_egg_mooncake.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_egg_mooncake.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_egg_mooncake") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_egg_mooncake") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_egg_mooncake"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_egg_mooncake.xml"
    inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES                          --零食
    inst.components.edible:SetOnEatenFn(function(inst,eater)

        if eater.components.health ~= nil then
            -- 因为buff相关组件不支持相同buff叠加时的数据传输，所以这里自己定义了一个传输方式
            -- 血库buff
            eater.buff_healthstorage_times = 50
            eater:AddDebuff("fwd_in_pdt_buff_healthstorage", "fwd_in_pdt_buff_healthstorage")
        end
    end)

    -- 我这里删除了腐烂组件，不知道会不会有问题
    -- inst:AddComponent("perishable") -- 可腐烂的组件
    -- inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY*10000)
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
    -------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
    -- local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
    -- local r,g,b,a = 209/255 , 127/255 ,170/255 , 200/255
    -- inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
    --     bank = "fwd_in_pdt_food_coffee",
    --     build = "fwd_in_pdt_food_coffee",
    --     anim = "icon",
    --     hide_image = true,
    --     text = {
    --     --     -- color = {r,g,b,1},
    --         pt = Vector3(-14,16,0),
    --     --     -- size = 35,
    --     }
    -- })
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_food_egg_mooncake", fn, assets)