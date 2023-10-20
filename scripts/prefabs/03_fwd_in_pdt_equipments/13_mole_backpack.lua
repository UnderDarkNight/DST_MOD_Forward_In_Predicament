local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_mole_backpack.zip"),

}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("backpack", "fwd_in_pdt_equipment_mole_backpack", "swap_body")
    owner.AnimState:OverrideSymbol("swap_body", "fwd_in_pdt_equipment_mole_backpack", "swap_body")    
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    inst.components.container:Close(owner)
end

local function onequiptomodel(inst, owner)
    inst.components.container:Close(owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("fwd_in_pdt_equipment_mole_backpack")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_mole_backpack")
    inst.AnimState:PlayAnimation("idle")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    local swap_data = {bank = "fwd_in_pdt_equipment_mole_backpack", anim = "idle"}
    MakeInventoryFloatable(inst, "med", 0.1, 0.65, nil, nil, swap_data)

    inst.entity:SetPristine()

    
    --------------------------------------------------------------------
    --- 容器安装
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("backpack")
        else
            inst.OnEntityReplicated = function()
                local container = inst.replica.container or inst.replica._.container
                if container then
                    container:WidgetSetup("backpack")
                end
            end
        end
    --------------------------------------------------------------------
    if not TheWorld.ismastersim then

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    MakeHauntableLaunchAndDropFirstItem(inst)
    ------------------------------------------------------------------------------------------------------------
    --- 背包机制
        local light_items_prefab_list = {
            ["wormlight"] = true,          --- 发光浆果
            ["wormlight_lesser"] = true,   --- 小发光浆果
            ["lightbulb"] = true,          --- 荧光果
        }
        inst:ListenForEvent("itemget",function(inst,_table)

            if _table and _table.item and light_items_prefab_list[_table.item.prefab] then
                local tempItem = _table.item                
                if tempItem.components.perishable then
                    tempItem.components.perishable:StopPerishing()
                    tempItem.components.perishable:SetPercent(1)
                end

                if inst.__light == nil then
                    inst.__light = inst:SpawnChild("minerhatlight")                    
                end

            end
        end)

        inst:ListenForEvent("itemlose",function(inst,_table)
            if _table and _table.prev_item then
                local tempItem = _table.prev_item
                if tempItem.components.perishable then
                    tempItem.components.perishable:StartPerishing()
                end
            end
            local light_on_flag = false
            inst.components.container:ForEachItem(function(item)
                if item and item.prefab and light_items_prefab_list[item.prefab] then
                    light_on_flag = true
                end
            end)
            if light_on_flag == false and inst.__light then
                inst.__light:Remove()
                inst.__light = nil
            end
        end)
    ------------------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_mole_backpack", fn, assets)
