-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    小偷/抢劫事件




]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function check_can_steal_target(player)
        local container_inst = {}
        local green_coins_num = 0
        local black_coins_num = 0
        local function each_item_fn(item)
            if item == nil then
                return
            end
            if item.components.container then
                container_inst[item] = true
                return
            end
            if item.prefab == "fwd_in_pdt_item_jade_coin_green" then
                green_coins_num = green_coins_num + item.components.stackable.stacksize
                return
            end
            if item.prefab == "fwd_in_pdt_item_jade_coin_black" then
                black_coins_num = black_coins_num + item.components.stackable.stacksize
                return
            end                
        end

        player.components.inventory:ForEachItem(each_item_fn)
        for temp_container, flag in pairs(container_inst) do
            if temp_container and flag then
                temp_container.components.container:ForEachItem(each_item_fn)
            end
        end

        if green_coins_num >= 40 or black_coins_num >= 2 then   ----- 绿币超过 40 或者 黑币超过 2
            return true
        end

        return false
    end

    -------------------------------------------------------------
    ----- 执行偷到函数
        local function steal_target_player(player)
            if player:HasTag("playerghost") or not player:IsValid() then
                return
            end
            local container_inst = {}
            local green_coins = {}
            local green_coins_num = 0
            local black_coins = {}
            local black_coins_num = 0
            local function each_item_fn(item)
                if item == nil then
                    return
                end
                if item.components.container then
                    container_inst[item] = true
                    return
                end
                if item.prefab == "fwd_in_pdt_item_jade_coin_green" then
                    green_coins[item] = true
                    green_coins_num = green_coins_num + item.components.stackable.stacksize                    
                    return
                end
                if item.prefab == "fwd_in_pdt_item_jade_coin_black" then
                    black_coins[item] = true
                    black_coins_num = black_coins_num + item.components.stackable.stacksize
                    return
                end                
            end
    
            player.components.inventory:ForEachItem(each_item_fn)


            for temp_container, flag in pairs(container_inst) do
                if temp_container and flag then
                    temp_container.components.container:ForEachItem(each_item_fn)
                end
            end

            ---------------------------------------------------------
            --- 删除玩家身上的
                for item_inst, v in pairs(green_coins) do
                    item_inst:Remove()
                end
                for item_inst, v in pairs(black_coins) do
                    item_inst:Remove()
                end
            ---------------------------------------------------------
            --- 随机偷取量
                local steal_green_num = 0
                local steal_black_num = 0
                if green_coins_num > 0 then
                    steal_green_num = math.random(math.ceil(green_coins_num/2),green_coins_num)
                end
                if black_coins_num > 0 then
                    steal_black_num = math.random(math.ceil(black_coins_num/2),black_coins_num)
                end
            ---------------------------------------------------------
                if steal_green_num > 0 and steal_green_num <= green_coins_num and green_coins_num - steal_green_num > 0 then
                    TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                            target = player,
                            name = "fwd_in_pdt_item_jade_coin_green",
                            num = green_coins_num - steal_green_num,    -- default
                            range = 5, -- default
                            height = 3,-- default
                    })
                end
                if steal_black_num > 0 and steal_black_num <= black_coins_num and black_coins_num - steal_black_num > 0 then
                    TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                            target = player,
                            name = "fwd_in_pdt_item_jade_coin_black",
                            num = black_coins_num - steal_black_num,    -- default
                            range = 5, -- default
                            height = 3,-- default
                    })
                end
            ---------------------------------------------------------



        end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        -------------------------------------------------------------------------------------------------
        ---- 偷取event
            inst:ListenForEvent("fwd_in_pdt_world_spawner.thief_2_player",function(_,player)
                if player:HasTag("playerghost") then    --- 玩家死了也不管
                    return
                end
                if player.components.playercontroller == nil then
                    return
                end
                if not player.components.playercontroller:IsEnabled() then
                    return
                end
                if player.sg and player.sg:HasStateTag("sleeping") then
                    return
                end

                if not check_can_steal_target(player) then
                    return
                end

                local x,y,z = player.Transform:GetWorldPosition()
                if y > 0 then   --- 某些MOD让玩家飞天，也不管了。
                    return
                end
                if not TheWorld.Map:IsAboveGroundAtPoint(x, y, z,false) then    ---- 在海上就不管了
                    return
                end

                local surround_points = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                        target = player,
                        range = 8,
                        num = 20,
                })
                local temp_points = {}
                for k, temp_pt in pairs(surround_points) do
                    if TheWorld.Map:IsAboveGroundAtPoint(x, y, z,false) then
                        table.insert(temp_points,temp_pt)
                    end
                end

                local pt = temp_points[math.random(#temp_points)]

                local npc = SpawnPrefab("shadowprotector")

                ---------------------------------------------------------------
                --- 外观
                    if npc.components.skinner == nil then
                        npc:AddComponent("skinner")
                    end
                    npc.components.skinner:CopySkinsFromPlayer(player)
                    npc.AnimState:SetMultColour(0, 0, 0, 0.5)

                ---------------------------------------------------------------
                npc.components.combat:SetRetargetFunction(1, nil)
                npc.components.combat:SetKeepTargetFunction(nil)
                ---------------------------------------------------------------

                npc.Transform:SetPosition(pt.x, pt.y, pt.z)
                npc.components.combat:SuggestTarget(player)
                local temp_task = npc:DoPeriodicTask(0.5,function()
                    -- npc.components.combat:SuggestTarget(player)
                    npc.components.combat:SetTarget(player)
                    npc.components.combat:SetRange(5)   --- 冲锋

                    ----------------------------------------------------------------------
                    --- 出现期间玩家死了
                            if player:HasTag("playerghost") or not player:IsValid() then
                                SpawnPrefab("fwd_in_pdt_fx_spawn"):PushEvent("Set",{
                                    pt = Vector3(npc.Transform:GetWorldPosition())
                                })
                                npc:Remove()
                            end
                    ----------------------------------------------------------------------
                end)

                npc.___thief_event_onhitother_fn = function(_,_table)
                    if _table and _table.target == player then
                        temp_task:Cancel()
                        npc:RemoveEventCallback("onhitother", npc.___thief_event_onhitother_fn)
                        npc:DoTaskInTime(2,function()
                            SpawnPrefab("fwd_in_pdt_fx_spawn"):PushEvent("Set",{
                                pt = Vector3(npc.Transform:GetWorldPosition())
                            })
                            npc:Remove()
                        end)
                        steal_target_player(player)
                    end
                end

                npc:ListenForEvent("onhitother",npc.___thief_event_onhitother_fn)

                -- npc:DoTaskInTime(1,function()
                --     if not npc.components.combat:CanAttack(player) then
                --         npc:Remove()
                --     end
                -- end)

            end)
        -------------------------------------------------------------------------------------------------
        ---- 单个玩家判定
            local function single_player_decide_fn(player)
                if not check_can_steal_target(player) then
                    return
                end

                if TheWorld.state.cycles - player.components.fwd_in_pdt_data:Add("last_thief_event_day",0) 
                    and ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE or math.random(1000)/1000 <= 0.3 ) then

                        player.components.fwd_in_pdt_data:Set("last_thief_event_day",TheWorld.state.cycles) 
                        TheWorld:PushEvent("fwd_in_pdt_world_spawner.thief_2_player",player)
                end

            end
        -------------------------------------------------------------------------------------------------

            inst:WatchWorldState("isnight",function()
                inst:DoTaskInTime(TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 5 or math.random(30,60),function()
                    for k, player in pairs(AllPlayers) do
                        if player and player.components.playercontroller and not player:HasTag("playerghost") then
                            single_player_decide_fn(player)
                        end
                    end
                end)
            end)
        -------------------------------------------------------------------------------------------------


    end
)


