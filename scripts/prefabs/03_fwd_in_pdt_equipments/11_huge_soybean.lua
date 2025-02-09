--------------------------------------------------------------------------
--[[

    重要笔记：
        图层文件夹 swap_body
        player_encumbered.scml
        swap_body-0   			 【注意】【用不上】往右走的时候，和 10 同时显示，注意透明
        swap_body-1	  			 【注意】【用不上】刚搬起来的瞬间。可以透明
        swap_body-2   					【用不上】
        swap_body-3	  		【重要】往上走的时候（包括骑牛往上）
        swap_body-4	  					【用不上】
        swap_body-5   					【用不上】
        swap_body-6   			 【注意】【用不上】牛背上的时候，向下走+左右，和 9 同时显示，注意透明
        swap_body-7   					【用不上】
        swap_body-8   					【用不上】
        swap_body-9			【向下走】【重要】
        swap_body-10		【向右走】【重要】
        swap_body-11						【用不上】【向上走】
]]--

--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_huge_soybean.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_huge_soybean.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_huge_soybean.xml" ),
}

local function onequip(inst, owner)
    
    owner.AnimState:OverrideSymbol("swap_body", "fwd_in_pdt_equipment_huge_soybean", "swap_body")
    -- owner.AnimState:Show("ARM_carry")
    -- owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    -- owner.AnimState:Hide("ARM_carry")
    -- owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_body")
end
local PHYSICS_RADIUS = 0.45

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
    inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_huge_soybean")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_huge_soybean")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavy")

    inst.entity:SetPristine()
    -- ---------------------------------------------------------------------------------------------
    -- -- 物品贸易
    --     
    -- ---------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    ---------------------------------------------------------------------------------------------
    ---- 物品组件
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("spear")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_huge_soybean"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_huge_soybean.xml"
        inst.components.inventoryitem:SetSinks(true)
        inst.components.inventoryitem.cangoincontainer = false

    ---------------------------------------------------------------------------------------------
    --- 超重组件
        inst:AddComponent("heavyobstaclephysics")
        inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)
    ---------------------------------------------------------------------------------------------
    --- 损毁掉落
        inst:AddComponent("lootdropper")
    ---------------------------------------------------------------------------------------------
    --- 穿戴
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
    ---------------------------------------------------------------------------------------------
    --- 拆毁
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(function()

            local loots = {}
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")
            table.insert(loots,"fwd_in_pdt_food_soybeans")

            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
            table.insert(loots,"fwd_in_pdt_plant_bean_seed")

            
            inst.components.lootdropper:SetLoot(loots)
            inst.components.lootdropper:DropLoot()
            inst:Remove()
        end)
    ---------------------------------------------------------------------------------------------
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    ---------------------------------------------------------------------------------------------
        -- inst:AddComponent("submersible")
    ---------------------------------------------------------------------------------------------
    --- 放到大力士健身房的动画替换
        inst:AddComponent("symbolswapdata")
        inst.components.symbolswapdata:SetData("fwd_in_pdt_equipment_huge_soybean", "swap_body")
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_huge_soybean", fn, assets)