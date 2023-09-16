--------------------------------------------------------------------------
--- 装备 ，武器
--- 炽热影刀
--------------------------------------------------------------------------



local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_frozen_nightmaresword.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_frozen_nightmaresword_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_frozen_nightmaresword.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_frozen_nightmaresword.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_frozen_nightmaresword_swap", "swap_object")    
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_frozen_nightmaresword")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_frozen_nightmaresword")
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_frozen_nightmaresword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_frozen_nightmaresword.xml"

    

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(90)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(500)
    inst.components.finiteuses:SetUses(500)
    inst.components.finiteuses:SetOnFinished(function()         ---- 耐久用完的时候
        local owner = inst.components.inventoryitem.owner
        if owner and owner:HasTag("player") and owner.components.inventory then
            local give_back_core = SpawnPrefab("fwd_in_pdt_item_ice_core")
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
        local r,g,b,a = 35/255 , 255/255 ,255/255 , 200/255
        inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
            text = {
                color = {r,g,b,a},
            }
        })
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)

    ---------------------------------------------------------------------------------------------
    ---- 攻击特效
        local function Attack_Fx(target)
            local x,y,z = target.Transform:GetWorldPosition()
            local fx = SpawnPrefab("fwd_in_pdt_fx_ice_broke_up")
            fx:PushEvent("Set",{
                pt = Vector3(x,y,z),
                scale = Vector3(2,2,2),                    
            })
            SpawnPrefab("icespike_fx_1").Transform:SetPosition(x, y, z)
        end
    -------------------------------------------------------------------------------------------
    ----- 攻击的时候执行的代码
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        if not ( target and attacker ) then
            return
        end
        -------- 额外概率掉耐久
            if math.random(1000) < 300 then
                inst.components.finiteuses:Use()
            end
        -------- 数据初始化
            target.fwd_in_pdt_mark = target.fwd_in_pdt_mark or {}
            target.fwd_in_pdt_mark[inst.prefab] = target.fwd_in_pdt_mark[inst.prefab] or {}
            target.fwd_in_pdt_mark[inst.prefab].num = target.fwd_in_pdt_mark[inst.prefab].num or 0
            ---- 取消超时任务
            if target.fwd_in_pdt_mark[inst.prefab].timeout_task then
                target.fwd_in_pdt_mark[inst.prefab].timeout_task:Cancel()
            end

        -------- 计数
            target.fwd_in_pdt_mark[inst.prefab].num = target.fwd_in_pdt_mark[inst.prefab].num + 1
            if target.fwd_in_pdt_mark[inst.prefab].num >= 5 then
                if target.components.health then
                    target.components.health:DoDelta(-30)
                end
                if attacker.components.sanity then
                    attacker.components.sanity:DoDelta(-2,true)
                end
                if attacker.components.temperature then
                    attacker.components.temperature:DoDelta(-3)
                end
                Attack_Fx(target)


                target.fwd_in_pdt_mark[inst.prefab].num = 0
            end
        -------- 超时
            target.fwd_in_pdt_mark[inst.prefab].timeout_task = target:DoTaskInTime(5,function()
                target.fwd_in_pdt_mark[inst.prefab] = nil
            end)

    end)
    ---------------------------------------------------------------------------------------------
    --- 下雨天 2倍伤害 
        --- hook weapon 的 GetDamage 函数
        inst.components.weapon.GetDamage__fwd_in_pdt_old = inst.components.weapon.GetDamage
        inst.components.weapon.GetDamage = function(self,...)
            if TheWorld.state.israining then
                return 180
            else
                return 90
            end
        end
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_frozen_nightmaresword", fn, assets)
