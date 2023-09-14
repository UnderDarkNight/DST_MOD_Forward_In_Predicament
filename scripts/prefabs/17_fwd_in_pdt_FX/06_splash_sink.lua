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
    inst:AddTag("NOBLOCK")

    -- FX:ListenForEvent("animqueueover",FX.Remove)
    -- FX:ListenForEvent("animoever",FX.Remove)

    inst.AnimState:SetBank("splash_water_drop")
    inst.AnimState:SetBuild("splash_water_drop")
    inst.AnimState:PlayAnimation("idle_sink")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)
    -- inst.AnimState:Pause()
    -- inst.AnimState:SetScale(1.3,1.3,1.3)

    inst:ListenForEvent("animover", inst.Remove)
    -- inst.SoundEmitter:PlaySound(self.inst.talk_sound,"talk2",1.5)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("colouradder")
    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)

    -- if not TheWorld.ismastersim then
    --     return inst
    -- end


    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     scale = Vector3(0,0,0)
        --     t_scale = nil  ----- transform 缩放
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end

        if _table.color and _table.color.x then
            inst:AddComponent("colouradder")
            inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
        end

        if _table.scale and _table.t_scale ~= true then
            inst.AnimState:SetScale(_table.scale.x,_table.scale.y,_table.scale.z)
        end

        if _table.scale and _table.t_scale == true then
            local temp = inst.Transform:GetScale()
            inst.Transform:SetScale(_table.scale.x * temp,_table.scale.y*temp,_table.scale.z*temp)
        end



    end)
    return inst
end

return Prefab("fwd_in_pdt_fx_splash_sink",fx,assets)