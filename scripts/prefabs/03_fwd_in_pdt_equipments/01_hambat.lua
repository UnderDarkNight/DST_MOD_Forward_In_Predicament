-------------------------------------------------------------------------------------------------------------
---- 测试 背部抽刀用的 武器
-------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_hambat_weapon.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_hambat_weapon_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_weapon_hambat.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_weapon_hambat.xml" ),
}


local function onequip_show(inst,owner)
    owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_hambat_weapon_swap", "swap_object")  
    owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function onequip_hide(inst,owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:OverrideSymbol("swap_body_tall", "fwd_in_pdt_hambat_weapon_swap", "swap_object")
end

local function onequip(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_hambat_weapon_swap", "swap_object")    
    owner.AnimState:OverrideSymbol("swap_body_tall", "fwd_in_pdt_hambat_weapon_swap", "swap_object")    
    -- owner.AnimState:Show("ARM_carry")
    -- owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    owner.AnimState:ClearOverrideSymbol("swap_object")
end

local function onattack(inst, attacker, target)
    inst.___sg_listen_fn(attacker)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_hambat_weapon")
    inst.AnimState:SetBuild("fwd_in_pdt_hambat_weapon")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    local floater_swap_data = {sym_build = "swap_glasscutter"}
    MakeInventoryFloatable(inst, "med", 0.05, {1.21, 0.4, 1.21}, true, -22, floater_swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.GLASSCUTTER.USES)
    inst.components.finiteuses:SetUses(TUNING.GLASSCUTTER.USES)
    inst.components.finiteuses:SetOnFinished(function()
        local owner = inst.components.inventoryitem.owner
        if owner then
            inst:PushEvent("unequipped",{owner = owner})
            onunequip(inst,owner)
        end
        inst:Remove()
    end)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_weapon_hambat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_weapon_hambat.xml"


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)


    ------------------------------------------------------------------------
    inst.___sg_listen_fn = function(owner)
        onequip_show(inst,owner)
        if owner._____fwd_in_pdt_weapon_hambat__hide_task then
            owner._____fwd_in_pdt_weapon_hambat__hide_task:Cancel()
            owner._____fwd_in_pdt_weapon_hambat__hide_task = nil
        end
        if owner._____fwd_in_pdt_weapon_hambat__hide_task == nil then
            owner._____fwd_in_pdt_weapon_hambat__hide_task = owner:DoTaskInTime(5,function()
                onequip_hide(inst,owner)
            end)
        end
    end

    inst.__owner_newstate_event_fn = function(owner,_table)
        if _table and _table.statename == "attack" then
            inst.___sg_listen_fn(owner)
        end
    end
    inst:ListenForEvent("equipped",function(_,_table)
        if _table and _table.owner then
            local owner = _table.owner
            -- if owner.components.fwd_in_pdt_func and owner.components.fwd_in_pdt_func.Add_SG_State_Listener then
            --     owner.components.fwd_in_pdt_func:Add_SG_State_Listener("attack",inst.___sg_listen_fn)
            -- end            
            owner:ListenForEvent("newstate",inst.__owner_newstate_event_fn)
        end
    end)


    inst:ListenForEvent("unequipped",function(_,_table)
        if _table and _table.owner then
            local owner = _table.owner
            -- if owner.components.fwd_in_pdt_func and owner.components.fwd_in_pdt_func.Add_SG_State_Listener then
            --     owner.components.fwd_in_pdt_func:Remove_SG_State_Listener("attack",inst.___sg_listen_fn)
            -- end
            owner:RemoveEventCallback("newstate", inst.__owner_newstate_event_fn)
            if owner._____fwd_in_pdt_weapon_hambat__hide_task then
                owner._____fwd_in_pdt_weapon_hambat__hide_task:Cancel()
                owner._____fwd_in_pdt_weapon_hambat__hide_task = nil
            end
        end
    end)

    ------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_weapon_hambat", fn, assets)