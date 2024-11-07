--------------------------------------------------------------------------
--- 装备 ，武器
--- 昆虫法杖
--------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_insect_staff.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_insect_staff_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.xml" ),

}

local function onequip(inst, owner)

	owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_insect_staff_swap", "swap_object")    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")


    owner.isbeeking = true  -- 靠近杀人蜂巢穴不会出杀人蜂

	owner:AddTag("insect")  -- 昆虫标签 不知道有什么用

    -- owner.components.skilltreeupdater:IsActivated("wormwood_bugs")  -- 植物人相关

    -- owner.components.fwd_in_pdt_remove_tag_blocker:Add("insect")

end

local function onunequip(inst, owner)
    
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")

    owner.isbeeking = nil  -- 结束hook

    -- owner.components.fwd_in_pdt_remove_tag_blocker:Remove("insect")

    owner:RemoveTag("insect")   -- 昆虫标签 不知道有什么用

    

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_insect_staff")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_insect_staff")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    -- 通用的远程施法组件
    inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_point_and_target_spell_caster",function(_,replica_com)

        replica_com:SetTestFn(function(inst,doer,target,pt,right_click)

            if target and target.prefab == "beebox" then

                return true

            end
                replica_com:SetDistance(20)

                replica_com:SetSGAction("quickcastspell")

                replica_com:SetText("fwd_in_pdt_equipment_insect_staff","采收")
        end)
    end)
    if TheWorld.ismastersim then
        
        inst:AddComponent("fwd_in_pdt_com_point_and_target_spell_caster")

        inst:AddComponent("harvestable")
        inst.components.fwd_in_pdt_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                if target and target.prefab == "beebox" then
------------------------------------------------------------------------------------------------------------------------------------
                    -- 前置检查 是不是正在燃烧呢？  蜂箱是否能采集呢？
                    if target:HasTag("burnt") then
                        return
                    end
                    if not target.components.harvestable:CanBeHarvested() then
                        return
                    end
------------------------------------------------------------------------------------------------------------------------------------
                    -- -- 储存玩家隐身标记位 杀人蜂走的逻辑是这个 不需要hook了  可以学习这种方法  但是不知道为什么隐藏了标记 有时候还是会出 干脆hook生成器
                    -- local invincible_switch_flag = false
                    -- local old_invincible = nil
                    -- if doer and doer.components.health then
                    --     invincible_switch_flag = true
                    --     old_invincible = doer.components.health.invincible
                    -- end
                    -- print("1234")
                    local child_com_hooked_flag = false
                    local old_ReleaseAllChildren_fn = nil
                    if target.components.childspawner then
                        child_com_hooked_flag = true
                        old_ReleaseAllChildren_fn = target.components.childspawner.ReleaseAllChildren
                        target.components.childspawner.ReleaseAllChildren = function()
                            return nil
                        end
                            
                        end
------------------------------------------------------------------------------------------------------------------------------------
                    -- 执行采集
                    target.components.harvestable:Harvest(doer)
------------------------------------------------------------------------------------------------------------------------------------
                    -- -- 恢复玩家隐身标记位
                    -- if invincible_switch_flag then
                    --     doer.components.health.invincible = old_invincible
                    -- end
                    if child_com_hooked_flag then
                        target.components.childspawner.ReleaseAllChildren = old_ReleaseAllChildren_fn
                    end
------------------------------------------------------------------------------------------------------------------------------------
                    -- 返回成功
                    return true
------------------------------------------------------------------------------------------------------------------------------------
                end
        end)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_insect_staff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_insect_staff.xml"


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE) -- 步行手杖的攻击力
    -------
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT -- 步行手杖的加速


    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_equipment_insect_staff", fn, assets)