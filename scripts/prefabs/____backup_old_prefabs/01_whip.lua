local assets =
{
    Asset("ANIM", "anim/whip.zip"),
    Asset("ANIM", "anim/swap_whip.zip"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_whip", inst.GUID, "swap_whip")
        owner.AnimState:OverrideItemSkinSymbol("whipline", skin_build, "whipline", inst.GUID, "swap_whip")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_whip", "swap_whip")
        owner.AnimState:OverrideSymbol("whipline", "swap_whip", "whipline")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end
---------------------------------------------------------------------------------------------------
local function player_add_follower(player,target)
    if player and player:HasTag("player") and player.components.leader and target and target.components.follower then
        player:PushEvent("makefriend")
        player.components.leader:AddFollower(target)
        local time = 60
        target.components.follower:AddLoyaltyTime(time)
        target.components.follower.maxfollowtime = time
    end
end

local function target_is_player_fn(target)
    ------- 添加食物buff
    target:AddDebuff("buff_workeffectiveness","buff_workeffectiveness")
    print("info  : golden whip to player",target,target:HasDebuff("buff_workeffectiveness"))
    if target.sg then
        target.sg:GoToState("hit")
    end
end


local function onattack(inst, attacker, target)
    print("los_golden_whip onattack fn",target)
    if target ~= nil and target:IsValid() then

        if target:HasTag("player") and not target:HasTag("playerghost") then
            target_is_player_fn(target)
            
        elseif target.components.follower then
            if target.components.combat then
                target.components.combat:DropTarget()
            end
            player_add_follower(attacker,target)
        end

    end
end
---------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whip")
    inst.AnimState:SetBuild("whip")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("whip")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(6)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("los_com_golden_whip")    ----- 自制动作组件
    inst.components.los_com_golden_whip.spell = onattack




    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("los_golden_whip", fn, assets)
