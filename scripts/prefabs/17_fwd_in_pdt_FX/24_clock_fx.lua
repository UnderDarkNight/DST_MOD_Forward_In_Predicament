
local assets = {

}

local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOBLOCK")


    inst.AnimState:SetBank("pocketwatch_warp_marker")
    inst.AnimState:SetBuild("pocketwatch_warp_marker")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:PlayAnimation("idle_pre")
    inst.AnimState:PushAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1.0, 1.0, 1.0, 0.6)
    -- inst.AnimState:SetMultColour(0, 0, 0, 1)

    -- inst:ListenForEvent("animover", inst.Remove)
    if not TheWorld.ismastersim then
        return inst
    end
    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),
        --     a = 0.1 ,
        --     MultColour_Flag = nil
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end

        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end

        if type(_table.scale) == type(Vector3(0,0,0)) and _table.scale.x then
            inst.AnimState:SetScale(_table.scale.x,_table.scale.y,_table.scale.z)
        elseif type(_table.scale) == "number" then
            inst.AnimState:SetScale(_table.scale,_table.scale,_table.scale)
        end

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("fwd_in_pdt_fx_clock", fx, assets)
