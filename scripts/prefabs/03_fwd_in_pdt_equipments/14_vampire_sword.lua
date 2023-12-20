--------------------------------------------------------------------------
--- 装备 ，武器
--- 吸血鬼之剑
--- 绿法杖分解代码在【Key_Modules_Of_FWD_IN_PDT\09_Recipes\03_element_core_weapon_recipes_for_green_staff.lua】
--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_vampire_sword.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_vampire_sword_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword.xml" ),
    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_equipment_vampire_sword_laser.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_vampire_sword_laser_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword_laser.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword_laser.xml" ),
}

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_vampire_sword_laser"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_vampire_sword_laser",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_vampire_sword_laser",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_vampire_sword_laser.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_vampire_sword_laser",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = "laser",                                                                         --- 【制作栏】皮肤的名字
            name_color = {255/255,0/255,0/255,255/255},
            onequip_bank = "fwd_in_pdt_equipment_vampire_sword_laser_swap"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_vampire_sword")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------


local function onequip(inst, owner)
    local skinname = tostring(inst.skinname)
    local bank = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank

    owner.AnimState:OverrideSymbol("swap_object", bank or "fwd_in_pdt_equipment_vampire_sword_swap", "swap_object")    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
end
---------------------------------------------------------------------------------------------
--- 攻击特效
    local function Attack_Fx(target)
        -- local x,y,z = target.Transform:GetWorldPosition()
        -- local fx = SpawnPrefab("fwd_in_pdt_fx_ice_broke_up")
        -- fx:PushEvent("Set",{
        --     pt = Vector3(x,y,z),
        --     scale = Vector3(2,2,2),                    
        -- })
        -- SpawnPrefab("icespike_fx_1").Transform:SetPosition(x, y, z)
    end
---------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_vampire_sword")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_vampire_sword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()
    -------------------------------------------------------
    ---- Skin API Register
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_vampire_sword","fwd_in_pdt_equipment_vampire_sword")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin","item_tile_fx","mouserover_colourful")
            ---------------------------------------------------------------------------------------------
            ---- 自定义扫把切皮肤特效
                inst.components.fwd_in_pdt_func:SkinAPI__SetReSkinToolFn(function()
                    -- Attack_Fx(inst)
                    -- print("fake error SkinAPI__SetReSkinToolFn")
                    SpawnPrefab("fwd_in_pdt_fx_red_bats"):PushEvent("Set",{
                        target = inst,
                        scale = 0.7,
                        -- color = Vector3(1,1,1),
                        speed = 3,
                        sound = "dontstarve/creatures/bat/bat_explode",
                    })
                end)
            ---------------------------------------------------------------------------------------------
            --- 文字颜色的代码
                -- inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx","mouserover_colourful")
                local r,g,b,a = 255/255 , 0/255 ,0/255 , 200/255
                inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                    text = {
                        color = {r,g,b,a},
                    }
                })
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)
            ---------------------------------------------------------------------------------------------

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_vampire_sword","images/inventoryimages/fwd_in_pdt_equipment_vampire_sword.xml")
        end
    -------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")


    -- inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("spear")
    -- inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_frozen_spear"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_frozen_spear.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(85)
    inst.components.weapon:SetRange(1.5)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(900)
    inst.components.finiteuses:SetUses(900)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.retrictedtag = "fwd_in_pdt_carl" --- 有这个tag 才能穿这个装备

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------------------------------
    ----- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(20)
    ---------------------------------------------------------------------------------------------
    --- 
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        ---- 找目标附近一圈的怪
        if target and attacker then
            local x,y,z = target.Transform:GetWorldPosition()
            local canthavetags = { "fwd_in_pdt_animal_frog_hound","companion","isdead","player","INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" ,"chester","hutch","wall","structure"}
            local musthavetags = nil
            local musthaveoneoftags = {"pig","rabbit","animal","smallcreature","epic","monster","insect"}
            local ents = TheSim:FindEntities(x, 0, z, 3, musthavetags, canthavetags, musthaveoneoftags)
            local ret_targets = {}  
            for k, temp_monster in pairs(ents) do
                if temp_monster and temp_monster:IsValid() and temp_monster ~= target and target.components.combat then
                   table.insert(ret_targets,temp_monster)                    
                end
            end

            if #ret_targets > 0 then
                for k, temp_target in pairs(ret_targets) do
                    temp_target.components.combat:GetAttacked(attacker,68)                    
                end
                SpawnPrefab("fwd_in_pdt_fx_red_bats"):PushEvent("Set",{
                    target = target,
                    -- color = Vector3(1,1,1),
                    -- a = 0.5,
                    speed = 4,
                    sound = math.random(100)< 50 and "dontstarve/creatures/bat/bat_explode" or nil,
                })
            end

            -- attacker.components.health:DoDelta(10,true,inst.prefab)
            attacker:PushEvent("fwd_in_pdt_event.vampire_sword_hit_target",target)
        end
    end)
    ---------------------------------------------------------------------------------------------
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
    ---------------------------------------------------------------------------------------------
    return inst
end
return Prefab("fwd_in_pdt_equipment_vampire_sword", fn, assets)