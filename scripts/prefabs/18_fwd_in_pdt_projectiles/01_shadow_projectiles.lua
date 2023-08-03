
local function OnHit(inst, owner, target)
    if inst.__attack_task then
        inst.__attack_task:Cancel()
    end


    if inst.__target_fn then
        inst.__target_fn(inst,owner,target)
        inst.__target_fn = nil
    end
    inst:Remove()

end

local function shadow_common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.AnimState:SetBank("shadow_rook")
    inst.AnimState:SetBuild("shadow_rook")
    inst.AnimState:PlayAnimation("idle_loop",true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetScale(0.7,0.7,0.7)


    inst.Transform:SetFourFaced()

    inst:AddTag("projectile")
    inst:AddTag("FX")
    inst:AddTag("INLIMBO")

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)


    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(10)     -- wilson 6
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(2)
    inst.components.projectile:SetOnHitFn(OnHit)
    -- inst.components.projectile:SetOnMissFn(inst.Remove)
    -- inst.components.projectile:SetOnThrownFn(OnThrown)
    inst:DoTaskInTime(0,function()
        if inst.__target == nil or inst.__owner == nil then
            inst:Remove()
        end
    end)


    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = pt,
        --     target = target,
        --     owner = player or weapon,
        --     target_fn = func (self_inst,owner,target),
        --     range = 2
        ---------------------------------------------------------------
        --     color = Vector3(),
        --     a = 1,
        --     MultColour_Flag = nil,
        ---------------------------------------------------------------
        -- }
        if _table == nil then
            return
        end
        if _table.pt == nil or _table.target == nil or _table.owner == nil then
            return
        end
        inst.__target = _table.target
        inst.__owner = _table.owner
        inst.__target_fn = _table.target_fn
        inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)  
        if _table.speed then
            inst.components.projectile:SetSpeed(_table.speed)
        end
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 0.5)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 0.5)
            end
        end

        if _table.range then
            inst.components.projectile:SetHitDist(_table.range)
        end
        
    end)

    inst.__attack_task = inst:DoPeriodicTask(0.3,function()
        local flg,err = pcall(function()
            if inst.__target and inst.__target:IsValid() then
                inst:FacePoint(inst.__target.Transform:GetWorldPosition())
                inst.components.projectile:Throw(inst.__owner,inst.__target)

            else
                ---------------------------------------------------------------------------------------------------
                --- 目标被其他人截杀的时候
                if inst.__attack_task then
                    inst.__attack_task:Cancel()
                end

                if inst.__target_fn then
                    inst.__target_fn(inst,inst.__owner,inst.__target)
                end

                inst:Remove()
                ---------------------------------------------------------------------------------------------------
            end
        end)
        if flg == false then
            print("error",err)
            inst:Remove()
        end
    end)

    inst:DoTaskInTime(15,inst.Remove)   ----------- 避免目标被杀导致飞太远

    return inst
end
local function shadow_rook()
    local inst = shadow_common()
    inst.AnimState:SetScale(0.25,0.25,0.25)
    inst.AnimState:PlayAnimation("idle_loop",true)


    local level = 2
    if level > 1 then
        local suffix = tostring(level - 1)
        inst.AnimState:OverrideSymbol("base",           "shadow_rook_upg_build", "base"..suffix)
        inst.AnimState:OverrideSymbol("big_horn",       "shadow_rook_upg_build", "big_horn"..suffix)
        inst.AnimState:OverrideSymbol("bottom_head",    "shadow_rook_upg_build", "bottom_head"..suffix)
        inst.AnimState:OverrideSymbol("small_horn_lft", "shadow_rook_upg_build", "small_horn_lft"..suffix)
        inst.AnimState:OverrideSymbol("small_horn_rgt", "shadow_rook_upg_build", "small_horn_rgt"..suffix)
        inst.AnimState:OverrideSymbol("top_head",       "shadow_rook_upg_build", "top_head"..suffix)
    else
        inst.AnimState:ClearAllOverrideSymbols()
    end

    return inst
end

local function shadow_knight()
    local inst = shadow_common()
    inst.AnimState:SetBank("shadow_knight")
    inst.AnimState:SetBuild("shadow_knight")
    inst.AnimState:SetScale(0.7,0.7,0.7)
    inst.AnimState:PlayAnimation("walk_loop",true)

    local level = 2
    if level > 1 then
        local suffix = tostring(level - 1)
        inst.AnimState:OverrideSymbol("arm",       "shadow_knight_upg_build", "arm"..suffix)
        inst.AnimState:OverrideSymbol("ear",       "shadow_knight_upg_build", "ear"..suffix)
        inst.AnimState:OverrideSymbol("face",      "shadow_knight_upg_build", "face"..suffix)
        inst.AnimState:OverrideSymbol("head",      "shadow_knight_upg_build", "head"..suffix)
        inst.AnimState:OverrideSymbol("leg_low",   "shadow_knight_upg_build", "leg_low"..suffix)
        inst.AnimState:OverrideSymbol("neck",      "shadow_knight_upg_build", "neck"..suffix)
        inst.AnimState:OverrideSymbol("spring",    "shadow_knight_upg_build", "spring"..suffix)
    else
        inst.AnimState:ClearAllOverrideSymbols()
    end

    return inst
end

local function shadow_bishop()
    local inst = shadow_common()
    inst.AnimState:SetBank("shadow_bishop")
    inst.AnimState:SetBuild("shadow_bishop")
    inst.Transform:SetSixFaced()
    inst.AnimState:SetScale(0.7,0.7,0.7)
    inst.AnimState:PlayAnimation("idle_loop",true)

    local level = 2
    if level > 1 then
        local suffix = tostring(level - 1)
        inst.AnimState:OverrideSymbol("body_mid",           "shadow_bishop_upg_build", "body_mid"..suffix)
        inst.AnimState:OverrideSymbol("body_upper",         "shadow_bishop_upg_build", "body_upper"..suffix)
        inst.AnimState:OverrideSymbol("head",               "shadow_bishop_upg_build", "head"..suffix)
        inst.AnimState:OverrideSymbol("sharp_feather_a",    "shadow_bishop_upg_build", "sharp_feather_a"..suffix)
        inst.AnimState:OverrideSymbol("sharp_feather_b",    "shadow_bishop_upg_build", "sharp_feather_b"..suffix)
        inst.AnimState:OverrideSymbol("wing",               "shadow_bishop_upg_build", "wing"..suffix)
    else
        inst.AnimState:ClearAllOverrideSymbols()
    end

    return inst
end

return Prefab("npc_projectile_shadow_rook", shadow_rook),
        Prefab("npc_projectile_shadow_knight", shadow_knight),
        Prefab("npc_projectile_shadow_bishop", shadow_bishop)