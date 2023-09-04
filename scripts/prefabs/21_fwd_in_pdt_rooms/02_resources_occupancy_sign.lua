
local assets =
{
    Asset("ANIM", "anim/sign_home.zip"),
    Asset("ANIM", "anim/ui_board_5x3.zip"),
    Asset("MINIMAP_IMAGE", "sign"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .2)

    inst.MiniMapEntity:SetIcon("sign.png")

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_home")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("fwd_in_pdt_data")

    inst:ListenForEvent("Set",function(inst,_table)
        if type(_table) ~= "table" then
            return
        end

        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
        end

        if type(_table.tag) == "string" then
            inst.Ready = true
            inst:AddTag(_table.tag)
            inst.components.fwd_in_pdt_data:Set("tag",_table.tag)
        end

    end)

    inst:DoTaskInTime(0,function()
        if inst.components.fwd_in_pdt_data:Get("tag") then
            inst:PushEvent("Set",inst.components.fwd_in_pdt_data:Get("tag"))
        end
        if not inst.Ready then
            inst:Remove()
        end
    end)

    MakeSnowCovered(inst)
    return inst
end

return Prefab("fwd_in_pdt__resources_occupancy_sign", fn, assets)