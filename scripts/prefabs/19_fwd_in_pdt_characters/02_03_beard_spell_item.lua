local assets =
{
    -- Asset("ANIM", "anim/backpack.zip"),
    -- Asset("ANIM", "anim/swap_krampus_sack.zip"),
    -- Asset("ANIM", "anim/chemist_other_beard_container.zip"),
    -- Asset( "IMAGE", "images/widget/chemist_other_beard_container_widget_bg.tex" ), 
    -- Asset( "ATLAS", "images/widget/chemist_other_beard_container_widget_bg.xml" ),
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn3()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_krampus_sack")
    inst.AnimState:PlayAnimation("anim")
    

    inst.entity:SetPristine()
    -----------------------------------------------------------------------
    ----
        -- inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_point_and_target_spell_caster",function(inst,replica_com)
        --     replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
        --         print("tttt+++6666666")
        --         return true
        --     end)
        --     replica_com:SetDistance(10)
        --     replica_com:SetText("AAAA","ASDEEEEEEEEE")
        -- end)
        -- if TheWorld.ismastersim then
        --     inst:AddComponent("fwd_in_pdt_com_point_and_target_spell_caster")
        --     inst.components.fwd_in_pdt_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
        --         return true
        --     end)
        -- end
    -----------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("lootdropper")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.keepondeath = true --- 死亡不掉落

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BEARD
    inst.components.equippable:SetPreventUnequipping(true)  --- 死亡不掉落

    inst.components.equippable:SetOnEquip(function(_,owner)

    end)
    inst.components.equippable:SetOnUnequip(function(_,owner)

    end)
    inst.components.equippable.retrictedtag = "fwd_in_pdt_cyclone"

    -----------------------------------------------------------------------
    ----
        -- inst:AddComponent("fwd_in_pdt_com_point_and_target_spell_caster")
    -----------------------------------------------------------------------
    ----
        inst:ListenForEvent("remove_the_inst",function(inst)
            if inst.owner then
                inst.owner:PushEvent("beard_spell_inst_removed")
            end
            inst:Remove()
        end)
    -----------------------------------------------------------------------
    ---- 被其他MOD打掉落的时候处理
        inst:ListenForEvent("unequipped",function(_,_table)
            -- inst:Remove()
            inst:PushEvent("remove_the_inst")
        end)
    -----------------------------------------------------------------------
    ---- 换角色的时候移除
        inst:ListenForEvent("equipped",function(_,_table)
            inst.owner = _table and _table.owner
            inst:ListenForEvent("death",function()
                inst:PushEvent("remove_the_inst")
            end,inst.owner)
            inst:ListenForEvent("ms_playerreroll",function()
                inst:PushEvent("remove_the_inst")
            end,inst.owner)
        end)
    -----------------------------------------------------------------------
    ----
        inst:ListenForEvent("on_landed",function(inst)
            inst:PushEvent("remove_the_inst")
        end)
        inst:ListenForEvent("ondropped",function(inst)
            inst:PushEvent("remove_the_inst")            
        end)
    -----------------------------------------------------------------------
    ----
        inst:DoTaskInTime(1,function()
            if inst.owner == nil then
                inst:Remove()
            end
        end)
    -----------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_spell_item_for_cyclone", fn3, assets)
