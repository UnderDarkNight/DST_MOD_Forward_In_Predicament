--------------------------------------------------------------------------
--- 食物
--- 蛇皮冻
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_food_snake_skin_jelly.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_food_snake_skin_jelly.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_food_snake_skin_jelly.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_food_snake_skin_jelly") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_food_snake_skin_jelly") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画

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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_food_snake_skin_jelly"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_food_snake_skin_jelly.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("player") then
            -- 解除蛇毒，屏蔽蛇毒1天(100个周期)
            if eater.components.fwd_in_pdt_wellness and eater.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_snake_poison") then

                eater.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_snake_poison")
                eater.components.fwd_in_pdt_wellness:DoDelta_Poison(-25)
                eater.components.fwd_in_pdt_wellness:Set("snake_poison_blocker_update_times",100)
                if eater.components.sanity then
                    eater.components.sanity:DoDelta(-10)
                end
                if eater.components.health and eater.components.health.currenthealth > 10 then
                    eater.components.health:DoDelta(-10,nil,inst.prefab)
                end

            end
        end
    end)

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY*5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 62.5
    inst.components.edible.sanityvalue = 0
    inst.components.edible.healthvalue = -5

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
        bank = "fwd_in_pdt_food_snake_skin_jelly",
        build = "fwd_in_pdt_food_snake_skin_jelly",
        anim = "icon",
        hide_image = true,
        text = {
            -- color = {r,g,b,1},
            pt = Vector3(-14,16,0),
            -- size = 35,
        }
    })
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_food_snake_skin_jelly", fn, assets)