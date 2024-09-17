------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

            魔法铲子

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_magic_spatula.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_magic_spatula_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_magic_spatula.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_magic_spatula.xml" ),
    -- Asset("ANIM", "anim/swap_cane.zip"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_magic_spatula_swap", "swap_object")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_magic_spatula")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_magic_spatula")
    inst.AnimState:PlayAnimation("idle")


    --weapon (from weapon component) added to pristine state for optimization
    -- inst:AddTag("weapon")

    -- local swap_data = {sym_build = "swap_cane"}
    -- MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1, swap_data)
    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_magic_spatula"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_magic_spatula.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:PlayAnimation("water")
            else                                
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    ----- 烹饪锅相关事件监听/移除监听
        local player_event_fn = function(player,cookpot)
            local cookpot_prefabs = {
                ["portablecookpot"] = true,
                ["cookpot"] = true,
                ["fwd_in_pdt_building_special_cookpot"] = true,
            }
            if type(cookpot) ~= "table" or cookpot.prefab == nil or not cookpot_prefabs[cookpot.prefab] then
                return
            end
            if player.components.sanity then
                local delta_num = 30
                if player.components.sanity.current >= delta_num then
                    player.components.sanity:DoDelta(-1*delta_num)
                    cookpot:PushEvent("fwd_in_pdt_event.stewer.force_finish")
                end
            end
        end
        inst:ListenForEvent("equipped",function(_,_table)
            if not (_table and _table.owner) then
                return
            end
            _table.owner:ListenForEvent("fwd_in_pdt_event.stewer.cooking_started",player_event_fn)
        end)
        inst:ListenForEvent("unequipped",function(_,_table)
            if not (_table and _table.owner) then
                return
            end
            _table.owner:RemoveEventCallback("fwd_in_pdt_event.stewer.cooking_started",player_event_fn)
        end)
    -------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_magic_spatula", fn, assets)
