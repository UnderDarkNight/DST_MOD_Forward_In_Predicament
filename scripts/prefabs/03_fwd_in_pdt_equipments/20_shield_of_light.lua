------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    光之护盾

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_shield_of_light.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml" ),
}

local function onequip(inst, owner)

    -- owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_magic_spatula_swap", "swap_object")

    -- owner.AnimState:Show("ARM_carry")
    -- owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)

    -- owner.AnimState:Hide("ARM_carry")
    -- owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.AnimState:SetBank("fwd_in_pdt_equipment_shield_of_light")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_shield_of_light")
    inst.AnimState:PlayAnimation("idle")


    inst:AddTag("fwd_in_pdt_equipment_shield_of_light")
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_shield_of_light"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_shield_of_light.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(function()
        inst:PushEvent("remove_combat_fn_from_player")
        inst:Remove()
    end)

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
    ----- 核心格挡函数
        inst.___player_combat_fn = function(combat_com,attacker, damage, ...)
            if damage > 0 then
                damage = 0
                inst.components.finiteuses:Use(1)
                -- dontstarve/impacts/impact_forcefield_armour_dull
                combat_com.inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_forcefield_armour_dull")
            end
            return attacker,damage,...
        end
        inst:ListenForEvent("add_combat_fn_2_player",function(_,player)
                    --------------------------------------------------------------------------------
                    if not (player and player:HasTag("player") and player.components.fwd_in_pdt_func and player.components.playercontroller) then
                        return
                    end
                    --------------------------------------------------------------------------------
                    --- 挂载函数
                        player.components.fwd_in_pdt_func:PreGetAttacked_Add_Fn(inst.___player_combat_fn)
                    --------------------------------------------------------------------------------
                    --- 
                        inst.__link_player = player
                    --------------------------------------------------------------------------------
        end)
        inst:ListenForEvent("remove_combat_fn_from_player",function(_,player)
                    --------------------------------------------------------------------------------
                    --- 
                        if player == nil and inst.__link_player then
                            player = inst.__link_player
                        end
                    --------------------------------------------------------------------------------
                    --- 挂载函数
                    if (player and player:HasTag("player") and player.components.fwd_in_pdt_func and player.components.playercontroller) then
                        player.components.fwd_in_pdt_func:PreGetAttacked_Remove_Fn(inst.___player_combat_fn)
                    end
                    --------------------------------------------------------------------------------
                    --- 
                        inst.__link_player = nil
                    --------------------------------------------------------------------------------
        end)
    -------------------------------------------------------------------
    ----- 穿脱函数
        inst:ListenForEvent("equipped",function(_,_table)
            if not (_table and _table.owner ) then
                return
            end
            --------------------------------------------------------------------------------
            --- 特效
                if inst.___fx then
                    inst.___fx:Remove()
                end
                local fx = _table.owner:SpawnChild("fwd_in_pdt_equipment_shield_of_light_cycle")
                inst.___fx = fx
                fx.Transform:SetPosition(0,1,0)
            --------------------------------------------------------------------------------
            inst:PushEvent("add_combat_fn_2_player",_table.owner)
        end)
        inst:ListenForEvent("unequipped",function(_,_table)
            --------------------------------------------------------------------------------
            -- 特效
                if inst.___fx then
                    inst.___fx:Remove()
                    inst.___fx = nil
                end
            --------------------------------------------------------------------------------
            if not (_table and _table.owner ) then
                return
            end
            inst:PushEvent("remove_combat_fn_from_player",_table.owner)
        end)
    -------------------------------------------------------------------
    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
---- 圆环    
    local function cycle_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("fwd_in_pdt_equipment_shield_of_light")
        inst.AnimState:SetBuild("fwd_in_pdt_equipment_shield_of_light")
        local scale_num = 1.5
        inst.AnimState:SetScale(scale_num, scale_num, scale_num)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetSortOrder(0)
        inst.AnimState:PlayAnimation("cycle",true)
        
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")      --- 不可点击
        inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
        -- inst.Transform:SetRotation(math.random(350))

        if not TheWorld.ismastersim then
            return inst
        end


        inst:DoTaskInTime(0,function()
            local y = 0
            local fx_1 = SpawnPrefab("fwd_in_pdt_equipment_shield_of_light_fx")
            fx_1.entity:SetParent(inst.entity)
            fx_1.entity:AddFollower()
            fx_1.Follower:FollowSymbol(inst.GUID, "pt_1", 0, y, 0)

            local fx_2 = SpawnPrefab("fwd_in_pdt_equipment_shield_of_light_fx")
            fx_2.entity:SetParent(inst.entity)
            fx_2.entity:AddFollower()
            fx_2.Follower:FollowSymbol(inst.GUID, "pt_2", 0, y, 0)

            local fx_3 = SpawnPrefab("fwd_in_pdt_equipment_shield_of_light_fx")
            fx_3.entity:SetParent(inst.entity)
            fx_3.entity:AddFollower()
            fx_3.Follower:FollowSymbol(inst.GUID, "pt_3", 0, y, 0)

            local fx_4 = SpawnPrefab("fwd_in_pdt_equipment_shield_of_light_fx")
            fx_4.entity:SetParent(inst.entity)
            fx_4.entity:AddFollower()
            fx_4.Follower:FollowSymbol(inst.GUID, "pt_4", 0, y, 0)

        end)
        -- local fx = SpawnPrefab(fx_prefab)
        -- fx.entity:SetParent(owner.entity)
        -- fx.entity:AddFollower()
        -- fx.Follower:FollowSymbol(owner.GUID, "swap_object", fx.fx_offset_x or 0, fx.fx_offset, 0)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--- 盾牌特效
    local function fx()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("fwd_in_pdt_equipment_shield_of_light")
        inst.AnimState:SetBuild("fwd_in_pdt_equipment_shield_of_light")
        inst.AnimState:PlayAnimation("shield",true)
        -- local scale_num = 1.5
        -- inst.AnimState:SetScale(scale_num, scale_num, scale_num)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")      --- 不可点击
        inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

        if not TheWorld.ismastersim then
            return inst
        end

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_equipment_shield_of_light", fn, assets),
            Prefab("fwd_in_pdt_equipment_shield_of_light_cycle", cycle_fn, assets),
                Prefab("fwd_in_pdt_equipment_shield_of_light_fx", fx, assets)
