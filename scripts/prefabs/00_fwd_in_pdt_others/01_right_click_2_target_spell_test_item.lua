local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}
---------------------------------------------------------------------------------------------------------------
local function item_use_2_com_install(inst)
    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_item_use_to",function(inst,replica_com)

        replica_com:SetTestFn(function(inst,target,doer,right_click)
            if right_click and target ~= doer then
                return true
            end
            return false
        end)
        replica_com:SetSGAction("play_strum")
        replica_com:SetDistance(10)
        replica_com:SetText("test","施法")
    end)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("fwd_in_pdt_com_item_use_to")
    inst.components.fwd_in_pdt_com_item_use_to:SetActiveFn(function(inst,target,doer)
        target.AnimState:SetScale(2,2,2)
        return true
    end)
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fwd_in_pdt_tag.cursor_sight")

    inst.entity:SetPristine()

    item_use_2_com_install(inst)

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("alterguardianhatshard")



    MakeHauntableLaunch(inst)

    return inst
end
---------------------------------------------------------------------------------------------------------------
local function item_use_2_com_install2(inst)
    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_item_use_to",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,target,doer,right_click)
            if right_click and target ~= doer then
                return true
            end
            return false
        end)
        replica_com:SetSGAction("play_strum")
        replica_com:SetDistance(3)
        replica_com:SetText("test","施法")
    end)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("fwd_in_pdt_com_item_use_to")
    inst.components.fwd_in_pdt_com_item_use_to:SetActiveFn(function(inst,target,doer)
        target.AnimState:SetScale(1,1,1)
        return true
    end)
end
local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fwd_in_pdt_tag.cursor_sight")

    inst.entity:SetPristine()

    item_use_2_com_install2(inst)

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("wagstaff_tool_4")



    MakeHauntableLaunch(inst)

    return inst
end
---------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_debug_right_click_2_target_spell_test_item", fn, assets),
    Prefab("fwd_in_pdt_debug_right_click_2_target_spell_test_item2", fn2, assets)
