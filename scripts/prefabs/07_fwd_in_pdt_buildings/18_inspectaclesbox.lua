---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        -- Asset("ANIM", "anim/inspectaclesbox.zip"),
        Asset("ANIM", "anim/fwd_in_pdt_building_inspectaclesbox.zip"),
        Asset("ANIM", "anim/fwd_in_pdt_building_inspectaclesbox_empty.zip"),
    }
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local SCALE = 1.5
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function CreateLight(inst)
        -- minerhatlight
        if inst.light_fx and inst.light_fx:IsValid() then
            return
        end
        inst.light_fx = inst:SpawnChild("minerhatlight")
    end
    local function RemoveLight(inst)
        if inst.light_fx then
            inst.light_fx:Remove()
            inst.light_fx = nil
        end
    end
    local function light_on_checker_task(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, 0, z, 5, {"player"})
        local light_on_flag = false
        for k, temp_player in pairs(ents) do
            if temp_player and temp_player.components.inventory and temp_player.components.inventory:EquipHasTag("fwd_in_pdt_com_inspectacle_searcher") then
                light_on_flag = true
                break
            end
        end
        if light_on_flag then
            CreateLight(inst)
        else
            RemoveLight(inst)
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function Game_Com_Install(inst)
        inst:ListenForEvent("game_start",function()
            inst.replica.fwd_in_pdt_com_inspectacle_searcher_game_puzzle:StartGame()
        end)
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_inspectacle_searcher_game_puzzle",function(inst,replica_com)
            replica_com:SetSubmitFn(function(inst)
                local rpc = ThePlayer and ThePlayer.replica.fwd_in_pdt_com_rpc_event
                if rpc then
                    rpc:PushEvent("game_finish",{},inst)
                end
            end)
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("fwd_in_pdt_com_inspectacle_searcher_game_puzzle")
        inst:ListenForEvent("game_finish",function(inst)
            local x,y,z = inst.Transform:GetWorldPosition()
            local box = SpawnPrefab("fwd_in_pdt_building_inspectaclesbox_fixed")
            box.Transform:SetPosition(x,y,z)
            box:PushEvent("spawn_reward")
            SpawnPrefab("halloween_moonpuff").Transform:SetPosition(x,y,z)
            inst:Remove()
        end)
        inst:DoPeriodicTask(1,light_on_checker_task)
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function workable_install(inst)
        
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if doer and doer.replica.inventory:EquipHasTag("fwd_in_pdt_com_inspectacle_searcher") then
                    return true
                end
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("fwd_in_pdt_building_inspectaclesbox",STRINGS.ACTIONS.OCEAN_TRAWLER_FIX)
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
            local rpc = doer and doer.components.fwd_in_pdt_com_rpc_event
            if rpc then
                rpc:PushEvent("game_start",{},inst)
            end
            return true
        end)
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddAnimState()


        -- inst.MiniMapEntity:SetIcon("messagebottletreasure_marker.png")
        -- inst.MiniMapEntity:SetPriority(6)

        inst.AnimState:SetBank("fwd_in_pdt_building_inspectaclesbox")
        inst.AnimState:SetBuild("fwd_in_pdt_building_inspectaclesbox_empty")
        inst.AnimState:PlayAnimation("idle",true)
        inst.AnimState:SetErosionParams(0.1,-0.1,-1)
        inst.AnimState:SetScale(SCALE,SCALE,SCALE)

        inst:AddTag("NOBLOCK")
        inst:AddTag("fwd_in_pdt_com_inspectacle_searcher_target")

        inst.AnimState:SetClientsideBuildOverride("fwd_in_pdt_building_inspectaclesbox_searching", "fwd_in_pdt_building_inspectaclesbox_empty", "fwd_in_pdt_building_inspectaclesbox")

        inst.entity:SetPristine()
        Game_Com_Install(inst)
        workable_install(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        

        -- inst:AddComponent("workable")
        -- inst.components.workable:SetWorkAction(ACTIONS.DIG)
        -- inst.components.workable:SetOnFinishCallback(function()
        --     local x,y,z = inst.Transform:GetWorldPosition()
        --     local fx = SpawnPrefab("collapse_big")
        --     fx.Transform:SetPosition(x,y,z)
        --     fx:SetMaterial("wood")
        --     SpawnTreasureBox(x,y,z)
        --     inst:Remove()
        -- end)
        -- inst.components.workable:SetWorkLeft(1)

        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_building_inspectaclesbox", fn, assets)
