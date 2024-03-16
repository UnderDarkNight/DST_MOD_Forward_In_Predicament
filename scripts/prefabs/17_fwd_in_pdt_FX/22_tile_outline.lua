local function tile_outline_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("gridplacer")
    inst.AnimState:SetBuild("gridplacer")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetLightOverride(1)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(0,0,0),
        -- }
        if _table.pt then
            inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
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

return Prefab("fwd_in_pdt_fx_tile_outline", tile_outline_fn)