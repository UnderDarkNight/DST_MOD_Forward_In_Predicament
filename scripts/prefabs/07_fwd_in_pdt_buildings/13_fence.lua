--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    围栏
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_building_doll_clamping_machine"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end

    local assets =
    {
        Asset("ANIM", "anim/fwd_in_pdt_building_doll_clamping_machine.zip"),
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
require "prefabutil"
-------------------------------------------------------------------------------

    local FINDDOOR_MUST_TAGS = {"door"}
    local FINDWALL_MUST_TAGS = {"wall"}
    local FINDWALL_CANT_TAGS = {"alignwall"}

    local ROT_SIDES = 8
    local function CalcRotationEnum(rot)
        return math.floor((math.floor(rot + 0.5) / 45) % ROT_SIDES)
    end


    local function IsNarrow(inst)
        return CalcRotationEnum(inst.Transform:GetRotation()) % 2 == 0
    end

    local function IsEnumNarrow(enum)
        return enum % 2 == 0
    end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Fence/Gate Alignment


        local function SetOrientation(inst, rotation, rotation_enum)
            --rotation = CalcFacingAngle(rotation)

            inst.Transform:SetRotation(rotation)

            if inst.anims.narrow then
                local is_narrow = false
                if rotation_enum ~= nil then
                    is_narrow = IsEnumNarrow(rotation_enum)
                else
                    is_narrow = IsNarrow(inst)
                end

                if is_narrow then
                    if not inst.bank_narrow_set then
                        inst.bank_narrow_set = true
                        inst.bank_wide_set = nil
                        inst.AnimState:SetBank(inst.anims.narrow)
                    end
                else
                    if not inst.bank_wide_set then
                        inst.bank_wide_set = true
                        inst.bank_narrow_set = nil
                        inst.AnimState:SetBank(inst.anims.wide)
                    end
                end

            end
        end


        local function FixUpFenceOrientation(inst, deployedrotation)
            local x, y, z = inst.Transform:GetWorldPosition()
            local neighbors = TheSim:FindEntities(x,0,z, 1.5, FINDWALL_MUST_TAGS)

            local rot = inst.Transform:GetRotation()
            local neighbor_index = 1
            local neighbor = neighbors[neighbor_index]
            if deployedrotation ~= nil then --has a value for spawned items
                neighbor_index = 2
                neighbor = neighbors[neighbor_index]
                rot = deployedrotation
            end


            --Only look for parallel fence/gate neighbours when matching rotation and doing swing-side changes
            local this_e = CalcRotationEnum(rot)
            local neighbor_e = nil
            while neighbor ~= nil do
                neighbor_e = CalcRotationEnum(neighbor.Transform:GetRotation())

                if (neighbor.isdoor or neighbor.prefab == "fwd_in_pdt_building_flower_fence" or neighbor.prefab == "fence") and (this_e % (ROT_SIDES/2) == neighbor_e % (ROT_SIDES/2)) then
                    --found a parallel fence/gate neighbour!
                    break
                end
                neighbor_index = neighbor_index + 1
                neighbor = neighbors[neighbor_index]
            end

            if neighbor == nil then
                --no fence/gates, try the first item again it should be a wall
                rot = inst.Transform:GetRotation()
                neighbor = neighbors[1]
                if deployedrotation ~= nil then --has a value for spawned items
                    neighbor = neighbors[2]
                    rot = deployedrotation
                end
            end

            if neighbor ~= nil then
                --align with fence/gate neighbor if we're placing from behind. This exists so that you can fix a hole in a wall from the back of wall. Needed for the case where the camera is obstructed from placing from the front of the wall
                if (neighbor.isdoor or neighbor.prefab == "fwd_in_pdt_building_flower_fence" or neighbor.prefab == "fence") and (this_e + ROT_SIDES/2) % ROT_SIDES == neighbor_e then
                    rot = rot + 180
                    this_e = CalcRotationEnum(rot)
                end

            end

            SetOrientation(inst, rot)

            inst.AnimState:PlayAnimation("idle")
        end

-------------------------------------------------------------------------------
----------- 
    local function OnIsPathFindingDirty(inst)
        if inst._ispathfinding:value() then
            if inst._pfpos == nil and inst:GetCurrentPlatform() == nil then
                inst._pfpos = inst:GetPosition()
                TheWorld.Pathfinder:AddWall(inst._pfpos:Get())
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(inst._pfpos:Get())
            inst._pfpos = nil
        end
    end

    local function InitializePathFinding(inst)
        inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
        OnIsPathFindingDirty(inst)
    end

    local function makeobstacle(inst)
        inst.Physics:SetActive(true)
        inst._ispathfinding:set(true)
    end
    -- local function clearobstacle(inst)
    --     inst.Physics:SetActive(false)
    --     inst._ispathfinding:set(false)
    -- end
    local function onremove(inst)
        inst._ispathfinding:set_local(false)
        OnIsPathFindingDirty(inst)
    end

    local function keeptargetfn()
        return false
    end

    local function onhammered(inst)
        inst.components.lootdropper:DropLoot()

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("wood")

        inst:Remove()
    end

    local function onworked(inst)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end

    local function onhit(inst, attacker, damage)
        inst.components.workable:WorkedBy(attacker)
    end

-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
------ 围栏
    local function onsave(inst, data)
        -- If we're on a boat, save boat rotation value in its own value separate from the standard rotation data
        local boat = inst:GetCurrentPlatform()
        if boat and boat:HasTag("boat") then
            data.boatrotation = inst.Transform:GetRotation()
        else
            local rot = CalcRotationEnum(inst.Transform:GetRotation())
            data.rot = rot > 0 and rot or nil
        end
    end

    local function onload(inst, data)
        if data ~= nil then
            local rotation = 0
            inst.loaded_rotation_enum = 0
            if data.rotation ~= nil then
                -- very old style of save data. updates save data to v2 format, safe to remove this when we go out of the beta branch
                rotation = data.rotation - 90
                inst.loaded_rotation_enum = CalcRotationEnum(rotation)
            elseif data.rot ~= nil then
                rotation = data.rot*45
                inst.loaded_rotation_enum = data.rot
            end
            SetOrientation(inst, rotation)
        end
    end

    local function onloadpostpass(inst, newents, data)
        if data == nil then
            --Don't crash on mods placing fences in worldgen
            return
        end

        inst:DoTaskInTime(0, function(inst)
            -- If fences are placed on rotated boats, we need to account for the boat's rotation
            if data.boatrotation ~= nil then
                -- New method for loading rotation on boats; set the orientation directly
                local rot_enum = CalcRotationEnum(inst.Transform:GetRotation())
                SetOrientation(inst, data.boatrotation, rot_enum)
            else
                -- Old method for loading rotation on boats
                local boat = inst:GetCurrentPlatform()
                if boat and boat:HasTag("boat") then
                    local fence_rotation = inst.Transform:GetRotation()
                    local boat_rotation = boat.Transform:GetRotation()

                    if fence_rotation < 0 then
                        fence_rotation = 360 + fence_rotation
                    end

                    local fence_rotation_enum = inst.loaded_rotation_enum
                    local boat_rot_enum = CalcRotationEnum(boat_rotation)

                    local base_rotation_enum = fence_rotation_enum - boat_rot_enum
                    SetOrientation(inst, base_rotation_enum * 45 + boat_rotation)

                    inst.loaded_rotation_enum = nil
                end
            end
        end)
    end

    local function fence_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState() --V2C: need this even if we are door, for mouseover sorting
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetEightFaced()

        MakeObstaclePhysics(inst, .5)
        inst.Physics:SetDontRemoveOnSleep(true)

        inst:AddTag("wall")
        inst:AddTag("fence")
        inst:AddTag("alignwall")
        inst:AddTag("noauradamage")
		inst:AddTag("rotatableobject")


        inst.AnimState:SetBank("fence")
        inst.AnimState:SetBuild("fence")
        inst.AnimState:PlayAnimation("idle")

        MakeSnowCoveredPristine(inst)
        

        inst._pfpos = nil
        inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
        makeobstacle(inst)
        --Delay this because makeobstacle sets pathfinding on by default
        --but we don't to handle it until after our position is set
        inst:DoTaskInTime(0, InitializePathFinding)

        inst.OnRemoveEntity = onremove

        -----------------------------------------------------------------------
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst.anims = {wide="fence", narrow="fence_thin"}

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({ "twigs" })

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onworked)

        inst:AddComponent("combat")
        inst.components.combat:SetKeepTargetFunction(keeptargetfn)
        inst.components.combat.onhitfn = onhit

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(1)
        inst.components.health:SetAbsorptionAmount(1)
        inst.components.health.fire_damage_scale = 0
        inst.components.health.canheal = false
        inst.components.health.nofadeout = true
        inst:ListenForEvent("death", onhammered)

        MakeMediumBurnable(inst)
        MakeMediumPropagator(inst)
        inst.components.burnable.flammability = .5
        inst.components.burnable.nocharring = true

        MakeHauntableWork(inst)
        MakeSnowCovered(inst)
        

        inst.OnSave = onsave
        inst.OnLoad = onload
        inst.OnLoadPostPass = onloadpostpass
        inst.SetOrientation = SetOrientation

        return inst
    end

-------------------------------------------------------------------------------
--- 物品
    local function ondeploywall(inst, pt, deployer, rot )
        local wall = SpawnPrefab("fwd_in_pdt_building_flower_fence")
        if wall ~= nil then
            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5

            wall.Physics:SetCollides(false)
            wall.Physics:Teleport(x, 0, z)
            wall.Physics:SetCollides(true)
            inst.components.stackable:Get():Remove()

            FixUpFenceOrientation(wall, rot or 0)

            wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
        end
    end
    local function item_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("fencebuilder")

        inst.AnimState:SetBank("fence")
        inst.AnimState:SetBuild("fence")
        inst.AnimState:PlayAnimation("inventory")

		MakeInventoryFloatable(inst, "small", nil, 1.1)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploywall
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

        MakeHauntableLaunch(inst)

        return inst
    end
-------------------------------------------------------------------------------
------- placer 执行和更新函数
    local function placer_fn(inst)
        inst.components.placer.onupdatetransform = function(inst)
            FixUpFenceOrientation(inst, nil)
        end
        inst.anims = {wide="fence", narrow="fence_thin"}
    end
-------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_flower_fence", fence_fn, assets),
        Prefab("fwd_in_pdt_building_flower_fence_item", item_fn, assets),
            MakePlacer("fwd_in_pdt_building_flower_fence_item_placer","fence","fence","idle",nil, nil, true, nil, 0, "eight",placer_fn)


