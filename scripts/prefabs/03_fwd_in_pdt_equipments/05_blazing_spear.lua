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
    --- 皮肤 
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_spear_sharp.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_blazing_spear_sharp_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear_sharp.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear_sharp.xml" ),
}
-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_blazing_spear_sharp"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_blazing_spear_sharp",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_blazing_spear_sharp",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear_sharp.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_blazing_spear_sharp",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            -- name = "尖锐",                                                                         --- 【制作栏】皮肤的名字
            onequip_bank = "fwd_in_pdt_equipment_blazing_spear_sharp_swap"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_blazing_spear")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------

local function onequip(inst, owner)
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    owner.AnimState:OverrideSymbol("swap_object",bank or "fwd_in_pdt_equipment_blazing_spear_swap", "swap_object")    
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_blazing_spear")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_blazing_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()
    -------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_blazing_spear","fwd_in_pdt_equipment_blazing_spear")
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
            ---------------------------------------------------------------------------------------------

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_blazing_spear","images/inventoryimages/fwd_in_pdt_equipment_blazing_spear.xml")
        end
    -------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    -- inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("spear")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_blazing_spear"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_blazing_spear.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(59.5)
    inst.components.weapon:SetRange(2.5,2.5)
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

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
        ------- 概率额外消耗耐久
            if math.random(1000) < 50 then
                inst.components.finiteuses:Use()
            end
        -------- 一定概率斩杀影怪
            if target:HasTag("shadow") and not target:HasTag("epic") and math.random(1000) < ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 7000 or 300) then
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