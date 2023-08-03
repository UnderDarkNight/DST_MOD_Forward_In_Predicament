
local function OnHit(inst, owner, target)
    if inst.__attack_task then
        inst.__attack_task:Cancel()
    end


    if inst.__target_fn then
        inst.__target_fn(inst,owner,target)
    end
    -- inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBuild("butterfly_basic")
    inst.AnimState:SetBank("butterfly")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

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

    return inst
end

return Prefab("npc_projectile_butterfly", fn)