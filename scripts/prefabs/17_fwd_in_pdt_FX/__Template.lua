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

    inst.AnimState:SetBank("spawn_fx")
    inst.AnimState:SetBuild("puff_spawning")
    inst.AnimState:PlayAnimation("medium")
    inst.AnimState:SetFinalOffset(1)

    -- inst.AnimState:Pause()
    -- inst.AnimState:SetScale(1.3,1.3,1.3)

    inst.sound = "dontstarve/common/spawn/spawnportal_spawnplayer"
    inst.SoundEmitter:PlaySound(inst.sound)

    inst:ListenForEvent("animover", inst.Remove)

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),
        --     a = 0.1
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

    end)

    return inst
end

return Prefab("npc_fx_spawn",fx,assets)