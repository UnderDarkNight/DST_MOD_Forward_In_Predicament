----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MOD 广告单
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_advertising_leaflet"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_item_advertising_leaflet.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_advertising_leaflet.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_advertising_leaflet.xml" ),

}

-----------------------------------------------------////-----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("fwd_in_pdt_item_advertising_leaflet")
    inst.AnimState:SetBuild("fwd_in_pdt_item_advertising_leaflet")
    inst.AnimState:PlayAnimation("idle")



	inst:AddTag("fwd_in_pdt_item_advertising_leaflet")
    -- inst:AddTag("waterproofer")
    MakeInventoryFloatable(inst, nil, 0.1)

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    -----------------------------------------------------------------------------------
    ---- 法术施放
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用                
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("fwd_in_pdt_item_advertising_leaflet",STRINGS.ACTIONS.READ)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                if doer then
                    doer.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.display_ad",30)
                end
                inst:PushEvent("read")
                return true
            end)
        end
    -----------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("named")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("scandata")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_advertising_leaflet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_advertising_leaflet.xml"

    inst:AddComponent("fwd_in_pdt_data")


    MakeHauntableLaunch(inst)
    ------------------------------------------------------------------------------------------------------
    --- 擦除
        inst:AddComponent("erasablepaper")
    ------------------------------------------------------------------------------------------------------
    ---- 燃烧 和 可燃
        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)    --- 可点燃
        MakeSmallPropagator(inst)   -- 可被其他物品引燃

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    --- 读过后能烧出币
        inst:ListenForEvent("read",function()
            inst.components.fwd_in_pdt_data:Set("read",true)
            inst.components.named:SetName(GetStringsTable()["name"] .. GetStringsTable()["name2"])
            inst:AddTag("read")
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("read") then
                inst:PushEvent("read")
            end
        end)

        inst:ListenForEvent("temp_burnt",function(_,pt)
            if inst:HasTag("read") then
                TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                    target = pt,
                    name = "fwd_in_pdt_item_jade_coin_green",
                    num = 2,
                })
            end
        end)
        inst:ListenForEvent("fueltaken",function(_,_table)  --- 被当做燃料
            if _table and _table.taker then
                inst:PushEvent("temp_burnt",Vector3(_table.taker.Transform:GetWorldPosition()))
                -- print("fake error fueltaken")
            end
        end)
        inst:ListenForEvent("onburnt",function() -- 被点火
            inst:PushEvent("temp_burnt",Vector3(inst.Transform:GetWorldPosition()))            
        end)
    -------------------------------------------------------------------

    return inst
end





return Prefab("fwd_in_pdt_item_advertising_leaflet", fn, assets)