-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    幽灵狗刷新器

    --- 玩家站船上，入夜瞬间判定。 5%概率出现。或者手拿火把必出。


]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        if TheWorld:HasTag("cave") then
            return
        end


        inst:WatchWorldState("isnight",function()
            inst:DoTaskInTime(5,function()
                --------------------------------------------------------------------------------------------
                

                            local on_boat_players = {}
                            for k, temp_player in pairs(AllPlayers) do
                                local x,y,z = temp_player.Transform:GetWorldPosition()
                                if TheWorld.Map:IsOceanAtPoint(x, 0, z,true) then
                                    table.insert(on_boat_players,temp_player)
                                end                
                            end
                            
                            if #on_boat_players == 0 then  ---- 没有玩家在海上
                                return
                            end

                            local ret_target_player = on_boat_players[math.random(#on_boat_players)]

                            local in_hand_item = ret_target_player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

                            local torch_in_hand = false
                            if in_hand_item and in_hand_item.prefab == "torch" then
                                torch_in_hand = true
                            end
                            if not ( torch_in_hand or math.random(1000)/1000 <= (0.05 + TheWorld.components.fwd_in_pdt_data:Add("ghost_hound_event",0)  ) ) then
                                TheWorld.components.fwd_in_pdt_data:Add("ghost_hound_event",0.01)
                                return
                            end
                            TheWorld.components.fwd_in_pdt_data:Set("ghost_hound_event",0)
                            --------------------------------------------------------------------------------
                            ----- 找在 海上的那些个点
                                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                                    target = ret_target_player,
                                    range = 25,
                                    num = 20
                                })
                                local locations_ocean = {}
                                for k, temp_pt in pairs(locations) do
                                    if TheWorld.Map:IsOceanAtPoint(temp_pt.x, 0, temp_pt.z) then
                                        table.insert(locations_ocean,temp_pt)
                                    end
                                end
                                if #locations_ocean == 0 then
                                    return
                                end
                            --------------------------------------------------------------------------------

                            local ghost_spawn_pt = locations_ocean[math.random(#locations_ocean)]
                            SpawnPrefab("fwd_in_pdt_animal_ghost_hound").Transform:SetPosition(ghost_spawn_pt.x, 0, ghost_spawn_pt.z)

                --------------------------------------------------------------------------------------------
            end)
        end)


        

    end
)


