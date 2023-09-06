

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_jade_coin_green"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_resource_glacier.zip"),
}


local function fn_huge()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 4)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_minimap_glacier.tex")

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_resource_glacier")
    inst.AnimState:SetBuild("fwd_in_pdt_resource_glacier")
    inst.AnimState:PlayAnimation("idle",true)
    -- inst.AnimState:SetTime(math.random(8000)/1000)
    -- inst.AnimState:SetScale(1.5, 1.5, 1.5)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(100)
    inst.components.workable:SetOnWorkCallback(function(_,worker)
        inst.components.workable.workleft = 100  --- 永远挖不完
        if worker and worker:HasTag("player") and math.random(1000) < 200 then
            local x,y,z = inst.Transform:GetWorldPosition()
            TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                pt = Vector3(x,0,z),
                num = 1,
                player = worker,
                prefab = "ice",
            })
        end
    end)



    return inst
end
local function fn_small()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_minimap_glacier.tex")

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fwd_in_pdt_resource_glacier")
    inst.AnimState:SetBuild("fwd_in_pdt_resource_glacier")
    inst.AnimState:PlayAnimation("idle",true)
    -- inst.AnimState:SetTime(math.random(8000)/1000)
    inst.AnimState:SetScale(0.5,0.5,0.5)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")


    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(100)
    inst.components.workable:SetOnWorkCallback(function(_,worker)
        inst.components.workable.workleft = 100  --- 永远挖不完
        if worker and worker:HasTag("player") and math.random(1000) < 100 then
            local x,y,z = inst.Transform:GetWorldPosition()
            TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                pt = Vector3(x,0,z),
                num = 1,
                player = worker,
                prefab = "ice",
            })
        end
    end)



    return inst
end
return Prefab("fwd_in_pdt_resource_glacier_huge", fn_huge, assets),
Prefab("fwd_in_pdt_resource_glacier_small", fn_small, assets)