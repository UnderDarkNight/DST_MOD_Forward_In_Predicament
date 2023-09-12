--------------------------------------------------------------------------
--- 装备 ，武器
--- 炽热影刀
--------------------------------------------------------------------------



local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_blazing_nightmaresword_swap", "swap_object")    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_blazing_nightmaresword")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_blazing_nightmaresword")
    inst.AnimState:PlayAnimation("idle")
    --inst.AnimState:SetMultColour(1, 1, 1, .6)

    inst:AddTag("shadow_item")
    inst:AddTag("shadow")
    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    -- local swap_data = {sym_build = "swap_nightmaresword", bank = "nightmaresword"}
    -- MakeInventoryFloatable(inst, "med", 0.05, {1.0, 0.4, 1.0}, true, -17.5, swap_data)

    MakeInventoryFloatable(inst, "med", 0.05, {1, 0.4, 1.0}, true, -17.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end



    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("nightsword")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_nightmaresword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.xml"

    

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(90)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(500)
    inst.components.finiteuses:SetUses(500)
    inst.components.finiteuses:SetOnFinished(function()         ---- 耐久用完的时候
        local owner = inst.components.inventoryitem.owner
        if owner and owner:HasTag("player") and owner.components.inventory then
            local give_back_core = SpawnPrefab("fwd_in_pdt_item_flame_core")
            give_back_core.components.stackable:SetStackSize(2)
            owner.components.inventory:GiveItem(give_back_core)
        end
        inst:Remove()
    end)



    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    inst.components.equippable.is_magic_dapperness = true

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.NIGHTSWORD_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    ---------------------------------------------------------------------------------------------
    --- 文字颜色的代码
        inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx","mouserover_colourful")
        local r,g,b,a = 255/255 , 50/255 ,0/255 , 180/255
        inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
            text = {
                color = {243/255,201/255,0/255,1},
            }
        })
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)

    ---------------------------------------------------------------------------------------------
    --- 添加剑的特殊效果代码
        -- local function Add_FX(player)
        --     if player.__npng_weapon_blazing_nightmaresword_mark_fx == nil then
        --         local fx = SpawnPrefab("thurible_smoke")
        --         fx.entity:SetParent(player.entity)
        --         fx.entity:AddFollower()
        --         fx.Follower:FollowSymbol(player.GUID, "swap_object",50,-170,0)
        --         player.__npng_weapon_blazing_nightmaresword_mark_fx = fx
        --     end
        -- end
        -- local function Remove_FX(player)
        --     if player and player.__npng_weapon_blazing_nightmaresword_mark_fx then
        --         player.__npng_weapon_blazing_nightmaresword_mark_fx:Remove()
        --         player.__npng_weapon_blazing_nightmaresword_mark_fx = nil
        --     end
        -- end

        -- inst:ListenForEvent("equipped",function(_,_table)   --- 装备武器的时候，添加烟雾特效
        --     if _table and _table.owner and _table.owner:HasTag("player") then
        --         Add_FX(_table.owner)
        --     end
        -- end)
        -- inst:ListenForEvent("unequipped",function(_,_table) ---- 脱下装备的时候，移除烟雾特效
        --     if _table and _table.owner and _table.owner:HasTag("player") then
        --         Remove_FX(_table.owner)
        --     end
        -- end)
    -------------------------------------------------------------------------------------------
    ----- 攻击的时候执行的代码
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
     
    end)
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_blazing_nightmaresword", fn, assets)
