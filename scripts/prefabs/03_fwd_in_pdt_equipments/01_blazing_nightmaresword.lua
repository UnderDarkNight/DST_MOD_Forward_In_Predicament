--------------------------------------------------------------------------
--- 装备 ，武器
--- 炽热影刀
--------------------------------------------------------------------------
if not TUNING["Forward_In_Predicament.Config"].POWERFUL_WEAPON_MOD then
    return
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.xml" ),
    ---- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_sharp.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_sharp_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_sharp.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_sharp.xml" ),
    ---- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_king.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_nightmaresword_king_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_king.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_king.xml" ),
}


-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_blazing_nightmaresword_sharp"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_blazing_nightmaresword_sharp",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_blazing_nightmaresword_sharp",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_sharp.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_blazing_nightmaresword_sharp",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_blazing_nightmaresword_sharp_swap"
        },
        ["fwd_in_pdt_equipment_blazing_nightmaresword_king"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_blazing_nightmaresword_king",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_blazing_nightmaresword_king",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword_king.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_blazing_nightmaresword_king",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_blazing_nightmaresword_king_swap"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_blazing_nightmaresword")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------


local function onequip(inst, owner)
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    owner.AnimState:OverrideSymbol("swap_object", bank or "fwd_in_pdt_equipment_blazing_nightmaresword_swap", "swap_object")    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
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
    -------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_blazing_nightmaresword","fwd_in_pdt_equipment_blazing_nightmaresword")
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
                        color = {243/255,201/255,0/255,1},
                    }
                })
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)

            -------------------------------------------------------------------------------------------
            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_blazing_nightmaresword","images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.xml")
        end
    -------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end



    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    -- inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("nightsword")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_nightmaresword"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_nightmaresword.xml"

    

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(118)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5000)
    inst.components.finiteuses:SetUses(5000)
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


    -------------------------------------------------------------------------------------------
    ----- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(20)
    -------------------------------------------------------------------------------------------
    ----- 攻击的时候执行的代码
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        if not ( target and attacker ) then
            return
        end
        -------- 额外概率掉耐久
            if math.random(1000) < 50 then
                inst.components.finiteuses:Use()
            end
        -------- 一定概率斩杀影怪
            if target:HasTag("shadow") and not target:HasTag("epic") and  math.random(1000) < ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 7000 or 300)  then
                -- if target.components.lootdropper then
                --     target:RemoveComponent("lootdropper")
                -- end
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
                    target.components.health:DoDelta(-30)
                end
                if attacker.components.sanity then
                    attacker.components.sanity:DoDelta(-5,true)
                end
                if attacker.components.temperature then
                    attacker.components.temperature:DoDelta(10)
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

return Prefab("fwd_in_pdt_equipment_blazing_nightmaresword", fn, assets)
