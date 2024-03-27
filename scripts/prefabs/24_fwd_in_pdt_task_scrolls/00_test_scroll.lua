----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 示例 任务卷轴
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_task_scroll__test"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_task_scroll.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_task_scroll.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_task_scroll.xml" ),

}

-----------------------------------------------------////-----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("fwd_in_pdt_task_scroll")
    inst.AnimState:SetBuild("fwd_in_pdt_task_scroll")
    inst.AnimState:PlayAnimation("idle",true)



	inst:AddTag("fwd_in_pdt_task_scroll")

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
                replica_com:SetSGAction("dolongaction")
                replica_com:SetText("fwd_in_pdt_task_scrolls",STRINGS.ACTIONS.READ)

            end)
            if TheWorld.ismastersim then
                inst:AddComponent("fwd_in_pdt_com_workable")
                inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                    inst.components.fwd_in_pdt_com_task_scroll:Open(doer)
                    return true
                end)
            end
    -----------------------------------------------------------------------------------
    ---- 任务信息交互组件
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_task_scroll")
            inst.components.fwd_in_pdt_com_task_scroll:Init({
                atlas = "images/ui_images/fwd_in_pdt_task_scrolls.xml",
                image = "fwd_in_pdt_task_scroll__beefalohat.tex",
                x = -50,
                y = 0
            })
            inst.components.fwd_in_pdt_com_task_scroll:Add_Submit_Fn(function(inst,doer)
                print("error fwd_in_pdt_com_task_scroll submit task",inst,doer)
            end)

        end
    -----------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("scandata")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_task_scroll"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_task_scroll.xml"


    MakeHauntableLaunch(inst)
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
    ---- 燃烧 和 可燃
        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)    --- 可点燃
        MakeSmallPropagator(inst)   -- 可被其他物品引燃
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    ------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
                -- inst.AnimState:PlayAnimation("idle_water")
            else                                
                inst.AnimState:Show("SHADOW")
                -- inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_task_scroll__test", fn, assets)