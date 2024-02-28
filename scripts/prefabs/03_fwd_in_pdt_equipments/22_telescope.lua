local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_telescope.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_telescope_swap.zip"),
}

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_telescope_swap", "swap_object")


    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
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

    inst.AnimState:SetBank("fwd_in_pdt_equipment_telescope")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_telescope")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("allow_action_on_impassable")

    MakeInventoryFloatable(inst)



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("fwd_in_pdt_com_telescope")
    inst.components.fwd_in_pdt_com_telescope:SetSpellFn(function(inst,doer,pt)
        inst.components.finiteuses:Use()
        doer.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_event.ToggleMap")

        local x,y,z = pt.x,pt.y,pt.z
        doer:ForceFacePoint(x,y,z)
        local numerodeitens = 300

        local dist = 1
        local range_fix = 0
        repeat
            local angle = doer:GetRotation()
            dist = dist + 1
            local offset = Vector3(dist * math.cos(angle*DEGREES), 0, -dist*math.sin(angle*DEGREES))
            local pt = Vector3(x,y,z)
            local chestpos = pt + offset
            local x, y, z = chestpos:Get()
            -------------------coloca os itens------------------------
                TheWorld.minimap.MiniMap:ShowArea(x, y, z, 30+range_fix)
                if doer.player_classified then
                    doer.player_classified.MapExplorer:RevealArea(x, 0, z)
                end
                numerodeitens = numerodeitens - 1
                range_fix = range_fix + 0.03
            -----------------------------------------------------------
        until
            numerodeitens <= 0



    end)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_telescope"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_telescope.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)
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
    return inst
end

return Prefab("fwd_in_pdt_equipment_telescope", fn, assets)
