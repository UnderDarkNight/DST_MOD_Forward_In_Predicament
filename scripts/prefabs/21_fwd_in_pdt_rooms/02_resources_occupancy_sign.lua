
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
        -- cmd_table = {
        --     tag = "",            -- 上 tag 好今后更新替换
        --     pt = Vector3(...),   --- 放置位置
        --     hide = true,         --- 隐藏牌子
        -- }
        if type(_table) ~= "table" then
            return
        end

        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
        end

        if type(_table.tag) == "string" then
            inst.Ready = true
            inst:AddTag(_table.tag)
        end

        if _table.hide then
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x,50,z)
            inst:Hide()
        end

        inst.components.fwd_in_pdt_data:Set("cmd",_table) 
    end)

    inst:DoTaskInTime(0,function()
        if inst.components.fwd_in_pdt_data:Get("cmd") then
            inst:PushEvent("Set",inst.components.fwd_in_pdt_data:Get("cmd"))
        end
        if not inst.Ready then
            inst:Remove()
        end
    end)

    MakeSnowCovered(inst)
    return inst
end

return Prefab("fwd_in_pdt__resources_occupancy_sign", fn, assets)