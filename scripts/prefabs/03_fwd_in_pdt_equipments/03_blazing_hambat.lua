--------------------------------------------------------------------------
--- 装备 ，武器
--- 炽热火腿棒
--------------------------------------------------------------------------




local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat.xml" ),
}

local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER*TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function OnLoad(inst, data)
    UpdateDamage(inst)
end

local function onequip(inst, owner)
    UpdateDamage(inst)

    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_blazing_hambat_swap", "swap_object")    

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_blazing_hambat")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_blazing_hambat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("fwd_in_pdt_equipment_blazing_hambat")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("hambat")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_hambat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat.xml"



    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED*0.8)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable.onreplacedfn = function(inst,item)   --- 返还 核心
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner then
            local give_back_cores = SpawnPrefab("fwd_in_pdt_item_flame_core")
            give_back_cores.components.stackable:SetStackSize(2)
            if owner.components.inventory then
                owner.components.inventory:GiveItem(give_back_cores)
            elseif owner.components.container then
                owner.components.container:GiveItem(give_back_cores)
            else
                give_back_cores:Remove()
            end
        end
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMBAT_DAMAGE)
    -- inst.components.weapon:SetOnAttack(UpdateDamage) --- 原来的 新鲜度和 伤害的相关 函数 不在这注册了

    inst:AddComponent("forcecompostable")
    inst.components.forcecompostable.green = true

    inst.OnLoad = OnLoad


    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

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
        -------- 一定概率扣新鲜度
            if math.random(1000) < 200 then
                inst.components.perishable:ReducePercent(0.05)
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
                    attacker.components.sanity:DoDelta(-3,true)
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
    ---- 青枳绿叶   --- 棱镜已经做了第三方兼容，直接利用其API
    inst.foliageath_data = {
        atlas = "images/inventoryimages/foliageath_hambat.xml",
        image = "foliageath_hambat",
        bank = "foliageath",
        build = "foliageath",
        anim = "hambat",
    }
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab( "fwd_in_pdt_equipment_blazing_hambat", fn, assets)