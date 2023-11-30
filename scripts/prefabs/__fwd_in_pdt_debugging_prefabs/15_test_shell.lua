------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    贴图 0 ： 空的
    贴图 1 ： 侧面
    贴图 2 ： 正面
    贴图 3 ： 贴图背面
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/eye_shield.zip"),
    Asset("ANIM", "anim/swap_eye_shield.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_test_shell.zip"),
}

local function onequip(inst, owner)

    --     owner.AnimState:OverrideSymbol("lantern_overlay", "swap_eye_shield", "swap_shield")
        owner.AnimState:OverrideSymbol("lantern_overlay", "fwd_in_pdt_equipment_test_shell", "fps_1")




    owner.AnimState:HideSymbol("swap_object")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:Show("LANTERN_OVERLAY")

    owner:ListenForEvent("onattackother", inst._weaponused_callback)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")


    owner:RemoveEventCallback("onattackother", inst._weaponused_callback)

    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
    owner.AnimState:ShowSymbol("swap_object")
end


-- local function fx()
--     local inst = CreateEntity()
--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddNetwork()
--     inst.entity:AddSoundEmitter()

--     inst:AddTag("INLIMBO")
--     inst:AddTag("FX")

--     -- FX:ListenForEvent("animqueueover",FX.Remove)
--     -- FX:ListenForEvent("animoever",FX.Remove)

--     inst.AnimState:SetBank("fwd_in_pdt_equipment_test_shell")
--     inst.AnimState:SetBuild("fwd_in_pdt_equipment_test_shell")
--     inst.AnimState:PlayAnimation("fx",true)
--     inst.AnimState:SetFinalOffset(1)

--     -- inst.AnimState:Pause()
--     -- inst.AnimState:SetScale(1.3,1.3,1.3)
--     inst.Transform:SetFourFaced()

--     return inst
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("eye_shield")
    inst.AnimState:SetBuild("eye_shield")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("handfed")
    inst:AddTag("fedbyall")
    inst:AddTag("toolpunch")

    -- for eater
    inst:AddTag("eatsrawmeat")
    inst:AddTag("strongstomach")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    MakeInventoryFloatable(inst, nil, 0.2, {1.1, 0.6, 1.1})

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._weaponused_callback = function(_, data)
        if data.weapon ~= nil and data.weapon == inst then
            inst.components.armor:TakeDamage(TUNING.SHIELDOFTERROR_USEDAMAGE)
        end
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SHIELDOFTERROR_DAMAGE)

    -------

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.SHIELDOFTERROR_ARMOR, TUNING.SHIELDOFTERROR_ABSORPTION)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.SHIELDOFTERROR_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_equipment_test_shell", fn, assets)