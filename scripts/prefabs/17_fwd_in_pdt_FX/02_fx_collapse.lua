local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}


local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")

    -- FX:ListenForEvent("animqueueover",FX.Remove)
    -- FX:ListenForEvent("animoever",FX.Remove)

    inst.AnimState:SetBank("collapse")
    inst.AnimState:SetBuild("structure_collapse_fx")
    -- inst.AnimState:PlayAnimation("medium")
    inst.AnimState:SetFinalOffset(1)

    -- inst.AnimState:Pause()
    -- inst.AnimState:SetScale(1.3,1.3,1.3)

    -- inst.sound = "dontstarve/common/spawn/spawnportal_spawnplayer"
    -- inst.SoundEmitter:PlaySound(inst.sound)

    inst:ListenForEvent("animover", inst.Remove)

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     target = inst,
        --     pt = Vector3(0,0,0),
        --     scale = Vector3(0,0,0)
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     sound_off = nil
        --     type = "small"
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        if _table.target then
            inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
        end

        if _table.scale and _table.scale.x then
            inst.AnimState:SetScale(_table.scale.x, _table.scale.y, _table.scale.z)
        end

        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end

        if _table.sound_off ~= true then
            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
        end

        if _table.type == "small" then
            inst.AnimState:PlayAnimation("collapse_small")
        else
            inst.AnimState:PlayAnimation("collapse_large")
        end

    end)

    return inst
end

return Prefab("fwd_in_pdt_fx_collapse",fx,assets)