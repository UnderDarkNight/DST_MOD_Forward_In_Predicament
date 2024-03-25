local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	Asset("ANIM", "anim/fwd_in_pdt_fx_miss.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("fwd_in_pdt_fx_miss")
    inst.AnimState:SetBuild("fwd_in_pdt_fx_miss")
    inst.AnimState:PlayAnimation("idle", false)
    inst.AnimState:SetFinalOffset(1)


    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst:ListenForEvent("animover",inst.Remove)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),        -- color / colour 都行
        --     a = 0.1,
        --     sound = ""
        --     speed = 1,
        --     scale = 1,
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        if _table.target and _table.target.Transform then
            inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        _table.color = _table.color or _table.colour
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        if _table.sound then
            inst.SoundEmitter:PlaySound(_table.sound)
        end

        if _table.scale then
            inst.AnimState:SetScale(_table.scale,_table.scale,_table.scale)
        end

        if _table.speed then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
        end

        inst.AnimState:SetDeltaTimeMultiplier(_table.speed or 1)
        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("fwd_in_pdt_fx_miss",fx,assets)