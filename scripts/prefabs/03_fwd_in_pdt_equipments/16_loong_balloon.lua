------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    气球

    四面体：
        running_down  --- 玩家向下走的时候
        running_side  --- 玩家向右走的时候
        running_up    --- 玩家向上走的时候
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_loong_balloon.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.xml" ),

}
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
local function onequip(inst, owner)


    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    -----------------------------------------------------------------------------
    --- 气球特效
        local fx = SpawnPrefab("fwd_in_pdt_equipment_balloon_fx")
        inst.fx = fx
        fx.AnimState:SetBank("fwd_in_pdt_equipment_loong_balloon")
        fx.AnimState:SetBuild("fwd_in_pdt_equipment_loong_balloon")
        fx.AnimState:PlayAnimation("idle",true)

        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object",6.5, 0, -1)
    -----------------------------------------------------------------------------
    --- 非玩家跳过后面内容
        if not (owner and owner:HasTag("player") ) then
            return
        end
    -----------------------------------------------------------------------------
    ---- 切换动作
        inst.player_sg_state_fn = inst.player_sg_state_fn or function()
            -- moving
            if owner.sg and owner.sg:HasStateTag("moving") then
                if not fx.AnimState:IsCurrentAnimation("running") then
                    fx.AnimState:PlayAnimation("running",true)
                    fx.AnimState:PushAnimation("running",true)
                else
                    -- fx.AnimState:PlayAnimation("running",true)
                    fx.AnimState:PushAnimation("running",true)
                end
                return
            end

            if not fx.AnimState:IsCurrentAnimation("idle") then                
                fx.AnimState:PlayAnimation("idle",true)
                fx.AnimState:PushAnimation("idle",true)
            else
                fx.AnimState:PushAnimation("idle",true)
            end
        end
        owner:ListenForEvent("newstate",inst.player_sg_state_fn)
    -----------------------------------------------------------------------------    
end

local function onunequip(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    -----------------------------------------------------------------------------
    --- 删除特效（气球）
        if inst.fx then
            inst.fx:Remove()
            inst.fx = nil
        end
    -----------------------------------------------------------------------------
    --- 移除sg监听
        if inst.player_sg_state_fn then
            owner:RemoveEventCallback("newstate",inst.player_sg_state_fn)
        end
    -----------------------------------------------------------------------------

end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.AnimState:SetBank("fwd_in_pdt_equipment_loong_balloon")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_loong_balloon")
    inst.AnimState:PlayAnimation("item_idle", true)

    inst.DynamicShadow:SetSize(1, .5)

    inst:AddTag("nopunch")
    inst:AddTag("cattoyairborne")
    inst:AddTag("balloon")
    inst:AddTag("noepicmusic")

    inst:AddTag("show_spoilage")


    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("hambat")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_loong_balloon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.xml"

    -- inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    -- inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.2


    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED*1.5)
    inst.components.perishable:StartPerishing()

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_equipment_loong_balloon", fn, assets)
