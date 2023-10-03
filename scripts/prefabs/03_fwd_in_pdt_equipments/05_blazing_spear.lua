--------------------------------------------------------------------------
--- 装备 ，武器
--- 炽热长矛
--- 绿法杖分解代码在【Key_Modules_Of_FWD_IN_PDT\09_Recipes\03_element_core_weapon_recipes_for_green_staff.lua】
--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_spear.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_spear_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_blazing_spear_swap", "swap_object")    
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_blazing_spear")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_blazing_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("spear")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_spear"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetRange(2.5,2.5)
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(150)
    inst.components.finiteuses:SetUses(150)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    ---------------------------------------------------------------------------------------------
    ---- 攻击特效
        local function Attack_Fx(target)
            local x,y,z = target.Transform:GetWorldPosition()
            local fx = SpawnPrefab("fwd_in_pdt_fx_flame_up")
            fx:PushEvent("Set",{
                pt = Vector3(x,y,z),
                scale = Vector3(2,2,2),
                sound = "dontstarve/common/fireAddFuel"            
            })
        end
    ---------------------------------------------------------------------------------------------
    --- 添加长矛特殊效果代码
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        if not ( target and attacker ) then
            return
        end
        ------- 概率额外消耗耐久
            if math.random(1000) < 200 then
                inst.components.finiteuses:Use()
            end
        -------- 一定概率斩杀影怪
            if target:HasTag("shadow") and not target:HasTag("epic") and math.random(1000) < 300 then
                if target.components.lootdropper then
                    target:RemoveComponent("lootdropper")
                end
                target.components.health:DoDelta(target.components.health.maxhealth*2)
                return
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
                    target.components.health:DoDelta(-25)
                end
                if attacker.components.sanity then
                    attacker.components.sanity:DoDelta(-5,true)
                end
                target.fwd_in_pdt_mark[inst.prefab].num = 0
                Attack_Fx(target)
            end
        -------- 超时
            target.fwd_in_pdt_mark[inst.prefab].timeout_task = target:DoTaskInTime(5,function()
                target.fwd_in_pdt_mark[inst.prefab] = nil
            end)
    end)
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_blazing_spear", fn, assets)