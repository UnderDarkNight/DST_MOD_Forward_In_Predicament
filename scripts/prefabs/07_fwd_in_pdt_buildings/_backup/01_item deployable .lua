----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable()
    local prefab_name = "fwd_in_pdt_building_mock_wall_grass"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end




----------------------------------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------------------------
-------- 墙
local function wall_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState() --V2C: need this even if we are door, for mouseover sorting
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- inst.Transform:SetEightFaced()

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("wall")
    inst:AddTag("alignwall")
    inst:AddTag("noauradamage")
    inst:AddTag("structure")

    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("grass1")
    inst.AnimState:PushAnimation("idle", true)

    -----------------------------------------------------------------------
    inst.entity:SetPristine()
    -----------------------------------------------------------------------

    -----------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    ---------------------------------------------------------------------------------------------------------
    ---- 只能被玩家敲掉
    inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(_,worker)
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition()),
                type = "small",
            })
            inst:Remove()
        end)

        inst.components.workable.WorkedBy__fwd_in_pdt_old = inst.components.workable.WorkedBy
        inst.components.workable.WorkedBy = function(self,worker,...)
            if worker and worker:HasTag("player") then
                return self:WorkedBy__fwd_in_pdt_old(worker,...)
            else
                print("++++++++++ workable",worker)
            end
        end
    ---------------------------------------------------------------------------------------------------------

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------
---- 物品

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("grass1")
    inst.AnimState:PlayAnimation("idle",true)

    MakeInventoryFloatable(inst, "small", nil, 1.1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)
    inst.components.inventoryitem:fwd_in_pdt_icon_init("dug_grass")

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
    inst.components.deployable.ondeploy = function(inst, pt, deployer, rot )
        local wall = SpawnPrefab("fwd_in_pdt_building_mock_wall_grass")   --- 生成结果

        if wall ~= nil then
            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5

            wall.Physics:SetCollides(false)
            wall.Physics:Teleport(x, 0, z)
            wall.Physics:SetCollides(true)
            inst.components.stackable:Get():Remove()

            wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
        end        
    end

    MakeHauntableLaunch(inst)
    return inst
end

----------------------------------------------------------------------------------------------------------------------------------------------
local function placer_postinit_fn(inst)
    
end
----------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_mock_wall_grass", wall_fn),
          Prefab("fwd_in_pdt_building_mock_wall_grass_item",itemfn),
            MakePlacer("fwd_in_pdt_building_mock_wall_grass_item_placer", "grass", "grass1", "idle",nil, nil, true, nil, nil, nil, placer_postinit_fn)

-- function MakePlacer(name, bank, build, anim, onground, snap, metersnap, scale, fixedcameraoffset, facing, postinit_fn, offset, onfailedplacement)
-- metersnap -- 去某个基点
