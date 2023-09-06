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
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用            
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            local mini_portal_door = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_mini_portal_door")
            if mini_portal_door then
                mini_portal_door:PushEvent("active",doer)
                inst:Remove()
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_castspell")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_transport_stone",STRINGS.ACTIONS.USEITEM)
    -----------------------------------------------------------------------------------
    --- sg fwd_in_pdt_castspell 里的特效和声音
        inst.fx_prefab = "fwd_in_pdt_item_transport_stone_fx"
        inst.sound = "dontstarve/pig/mini_game/cointoss"
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
    local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
    inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
        bank = "fwd_in_pdt_item_transport_stone",
        build = "fwd_in_pdt_item_transport_stone",
        anim = "icon",
        hide_image = true,
        text = {
            color = {r,g,b,a},
            -- pt = Vector3(4,1,0),
            -- size = 36,
        }
    })
    inst.components.fwd_in_pdt_func:Mouseover_SetColour(r,g,b,a)

    MakeHauntableLaunch(inst)

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