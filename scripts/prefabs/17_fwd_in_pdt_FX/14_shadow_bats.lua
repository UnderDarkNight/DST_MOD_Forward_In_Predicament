local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("shadow_bishop")
    inst.AnimState:SetBuild("shadow_bishop")
    inst.AnimState:PlayAnimation("atk_side_loop_pre")
    inst.AnimState:PushAnimation("atk_side_loop")
    inst.AnimState:PushAnimation("atk_side_loop_pst")


    inst.AnimState:SetFinalOffset(1)


    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    -- inst:ListenForEvent("animqueueover",inst.Remove)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover",function()
        inst._temp_anim_num = (inst._temp_anim_num or 1) + 1
        if inst._temp_anim_num >= 3 then
            inst:Remove()
        end
    end)

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     target = inst,
        --     color = Vector3(255,255,255),        -- color / colour 都行
        --     MultColour_Flag = false ,        
        --     a = 0.1,
        --     speed = 1,
        --     sound = ""
        --     scale = 1
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
        ------------------------------------------------------------------------------------------------------------------------------------
        _table.color = _table.color or _table.colour
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 0.5)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 0.5)
            end
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        if _table.sound then
            inst.SoundEmitter:PlaySound(_table.sound)
        end

        if type(_table.speed) == "number" then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
        end

        if type(_table.scale) == "number" then
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

return Prefab("fwd_in_pdt_fx_shadow_bats",fx,assets)