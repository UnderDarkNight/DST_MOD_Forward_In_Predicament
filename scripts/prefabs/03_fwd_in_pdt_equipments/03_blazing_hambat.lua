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
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat_drumstick.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat_drumstick_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_drumstick.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_drumstick.xml" ),
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat_fork.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_hambat_fork_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_fork.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_fork.xml" ),
}
-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_blazing_hambat_drumstick"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_blazing_hambat_drumstick",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_blazing_hambat_drumstick",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_drumstick.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_blazing_hambat_drumstick",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_blazing_hambat_drumstick_swap"
        },
        ["fwd_in_pdt_equipment_blazing_hambat_fork"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_blazing_hambat_fork",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_blazing_hambat_fork",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat_fork.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_blazing_hambat_fork",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_blazing_hambat_fork_swap"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_blazing_hambat")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------


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
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    UpdateDamage(inst)

    owner.AnimState:OverrideSymbol("swap_object", bank or "fwd_in_pdt_equipment_blazing_hambat_swap", "swap_object")    

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
end

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
    -------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_blazing_hambat","fwd_in_pdt_equipment_blazing_hambat")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin","item_tile_fx","mouserover_colourful")
            ---------------------------------------------------------------------------------------------
            ---- 自定义扫把切皮肤特效
                inst.components.fwd_in_pdt_func:SkinAPI__SetReSkinToolFn(function()
                    Attack_Fx(inst)
                end)
            ---------------------------------------------------------------------------------------------
            --- 文字颜色的代码
                -- inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx","mouserover_colourful")
                local r,g,b,a = 255/255 , 50/255 ,0/255 , 180/255
                inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                    text = {
                        color = {r,g,b,a},
                    }
                })
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)
            ---------------------------------------------------------------------------------------------

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_blazing_hambat","images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat.xml")
        end
    -------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    -- inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("hambat")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_hambat"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_hambat.xml"



    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED*1.5)
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
    -------------------------------------------------------------------------------------------
    ----- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(20)
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
            if target:HasTag("shadow") and not target:HasTag("epic") and math.random(1000) < ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 7000 or 300) then
                if target.components.lootdropper then
                    target:RemoveComponent("lootdropper")
                end
                -- target.components.health:DoDelta(target.components.health.maxhealth*2)
                if target.components.combat then
                    target.components.combat:GetAttacked(attacker,target.components.health.maxhealth*2)
                end
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