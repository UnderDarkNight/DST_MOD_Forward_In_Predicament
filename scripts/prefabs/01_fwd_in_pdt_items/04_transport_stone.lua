-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_transport_stone"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_item_transport_stone.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_transport_stone.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_transport_stone.xml" ),

}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- 施法动作相关 参数
    local function Add_SG_castspell_fns(inst)
        inst.spellsound = "dontstarve/pig/mini_game/cointoss"

        inst.castspell_onenter_fn = function(inst,player)
            local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon then
                player.AnimState:HideSymbol("swap_object")
                inst._______temp_cast_spell_weapon_in_hand_flag = true
            end

            local light_prefab_name = player.components.rider:IsRiding() and "staffcastfx_mount" or "staffcastfx"
            local light_inst = player:SpawnChild(light_prefab_name)           --- 创建 施法 光效
            local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
            light_inst.AnimState:SetMultColour(r,g,b,a)

            local fx = SpawnPrefab("fwd_in_pdt_item_transport_stone_fx")    --- 往施法光效 中心点 挂载 个 fx_inst
            fx.entity:SetParent(light_inst.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(light_inst.GUID, "FX", 0, 0, 1)


            light_inst:ListenForEvent("animover",function()                 --- 光效完了一起删除
                fx:Remove()
                light_inst:Remove()
            end)

        end

        local function player_show_in_hand_weapon(player)
            if player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                player.AnimState:ShowSymbol("swap_object")
            end
            player:DoTaskInTime(0.5,function()
                if player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                    player.AnimState:ShowSymbol("swap_object")
                end
            end)
        end
        inst.castspell_onexit_fn = function(inst,player)
            player_show_in_hand_weapon(player)
        end

        inst.castspell_animover_fn = function(inst,player)
            player_show_in_hand_weapon(player)
        end


    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_item_transport_stone")
    inst.AnimState:SetBuild("fwd_in_pdt_item_transport_stone")
    inst.AnimState:PlayAnimation("idle",true)


	inst:AddTag("fwd_in_pdt_item_transport_stone")
    -- inst:AddTag("waterproofer")

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------
    ---- 法术施放
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用                
            end)
            replica_com:SetSGAction("fwd_in_pdt_castspell")
            replica_com:SetText("fwd_in_pdt_item_transport_stone",STRINGS.ACTIONS.USEITEM)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                local mini_portal_door = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_mini_portal_door")
                if mini_portal_door then
                    mini_portal_door:PushEvent("active",doer)
                    inst.components.stackable:Get():Remove()
                    return true
                end
                return false
            end)
        end
    -----------------------------------------------------------------------------------
    --- sg fwd_in_pdt_castspell 里的特效和声音
        -- inst.fx_prefab = "fwd_in_pdt_item_transport_stone_fx"
        -- inst.spellsound = "dontstarve/pig/mini_game/cointoss"
        Add_SG_castspell_fns(inst)
    -----------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_transport_stone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_transport_stone.xml"
    inst.components.inventoryitem:EnableMoisture(false)

    inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx","mouserover_colourful")
    -- local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
    local r,g,b,a = 209/255 , 127/255 ,170/255 , 200/255
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_item_transport_stone",
        build = "fwd_in_pdt_item_transport_stone",
        anim = "icon",
        hide_image = true,
        text = {
            -- color = {r,g,b,1},
            pt = Vector3(-14,16,0),
            -- size = 35,
        }
    })
    inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)

    MakeHauntableLaunch(inst)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM


    local function shadow_init(inst)
        if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
            inst.AnimState:Hide("shadow")
        else                                
            inst.AnimState:Show("shadow")
        end
    end
    inst:ListenForEvent("on_landed",shadow_init)
    shadow_init(inst)

    return inst
end



local function fx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_item_transport_stone")
    inst.AnimState:SetBuild("fwd_in_pdt_item_transport_stone")
    inst.AnimState:PlayAnimation("fx",true)
    inst.AnimState:SetScale(0.6,0.6,0.6)
    inst.AnimState:SetDeltaTimeMultiplier(2)
	inst:AddTag("FX")
    inst.entity:SetPristine()
    return inst
end

return Prefab("fwd_in_pdt_item_transport_stone", fn, assets),Prefab("fwd_in_pdt_item_transport_stone_fx", fx, assets)