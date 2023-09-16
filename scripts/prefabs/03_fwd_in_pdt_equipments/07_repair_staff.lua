--------------------------------------------------------------------------
--- 装备 ，武器
--- 修复法杖
--- 绿法杖分解代码在【Key_Modules_Of_FWD_IN_PDT\09_Recipes\03_element_core_weapon_recipes_for_green_staff.lua】

--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_repair_staff.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_repair_staff_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_repair_staff.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_repair_staff.xml" ),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_repair_staff_swap", "swap_object")    
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_repair_staff")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_repair_staff")
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
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_repair_staff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_repair_staff.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
    ---------------------------------------------------------------------------------------------
    ---- 图标和颜色
        inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx","mouserover_colourful")
        -- local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
        local r,g,b,a = 0/255 , 255/255 ,0/255 , 200/255
        inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
            bank = "fwd_in_pdt_equipment_repair_staff",
            build = "fwd_in_pdt_equipment_repair_staff",
            anim = "icon",
            hide_image = true,
            text = {
                color = {r,g,b,1},
                -- pt = Vector3(-14,16,0),
                -- size = 35,
            }
        })
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)
    ---------------------------------------------------------------------------------------------
    --- 添加攻击特殊效果代码
        inst.components.weapon:SetOnAttack(function(inst,attacker,target)
            inst.components.finiteuses:Use(100)
        end)
    ---------------------------------------------------------------------------------------------
    --- 法杖动作
        inst.fxcolour = {51/255,153/255,51/255}
        inst:AddComponent("spellcaster")
        inst.components.spellcaster.canuseontargets = true
        inst.components.spellcaster:SetCanCastFn(function(doer,target,pos)
            if target and target.components.finiteuses and target.components.finiteuses:GetPercent() < 1 and target.prefab ~= inst.prefab then
                return true
            end
            return false
        end)
        inst.components.spellcaster:SetSpellFn(function(inst,target,pos,doer)
            inst.components.finiteuses:Use()
            target.components.finiteuses:SetPercent(1)
            SpawnPrefab("fwd_in_pdt_fx_knowledge_flash"):PushEvent("Set",{
                pt = Vector3(target.Transform:GetWorldPosition()),
                color = Vector3(51/255,255/255,51/255)
            })
        end)
    ---------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_repair_staff", fn, assets)