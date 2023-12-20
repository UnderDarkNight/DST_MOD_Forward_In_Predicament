------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    砍树出蛇

    杀死树精出蛇   leif_sparse  leif

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 砍树出蛇

    local function setup_workfinished_event(inst)
        inst:ListenForEvent("workfinished",function(_,_table)
            -- if _table and _table.worker then
            -- end
            if inst:HasTag("fwd_in_pdt_tag.snake_spawned") then
                return
            end
            inst:AddTag("fwd_in_pdt_tag.snake_spawned")

            if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 < 0.8 then    --- 20%概率出蛇
                return
            end

            local x,y,z = inst.Transform:GetWorldPosition()

            local offset_x = math.random(10,20)/10
            local offset_z = math.random(10,20)/10

            if math.random(100) < 50 then
                offset_x = -1 * offset_x
            end
            if math.random(100) < 50 then
                offset_z = -1 * offset_z
            end

            local snake =  SpawnPrefab("fwd_in_pdt_animal_snake")
            snake.Transform:SetPosition(x+offset_x, 0, z+offset_z)

            local nearest_player = snake:GetNearestPlayer(true) --- 找半径10内最近的玩家打
            if nearest_player and snake:GetDistanceSqToInst(nearest_player) <= 10*10 then
                snake.components.combat:SuggestTarget(nearest_player)
            end

        end)
    end

    local tree_prefabs = {
        "evergreen",
        "evergreen_normal",
        "evergreen_tall",
        "evergreen_short",
        "evergreen_sparse",
        "evergreen_sparse_normal",
        "evergreen_sparse_tall",
        "evergreen_sparse_short",

        "deciduoustree",
        "deciduoustree_normal",
        "deciduoustree_tall",
        "deciduoustree_short",
    }

    for k, the_prefab in pairs(tree_prefabs) do   
            AddPrefabPostInit(
                the_prefab,
                function(inst)

                    if not TheWorld.ismastersim then
                        return
                    end


                    setup_workfinished_event(inst)

                end
            )
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 树精BOSS 出蛇
    local tree_monster_prefabs = {
        "leif_sparse",
        "leif",
    }
    for k, the_prefab in pairs(tree_monster_prefabs) do
        AddPrefabPostInit(
                the_prefab,
                function(inst)

                    if not TheWorld.ismastersim then
                        return
                    end


                    inst:ListenForEvent("death",function()
                        if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 > 0.25 then
                            return
                        end
                        local x,y,z = inst.Transform:GetWorldPosition()
                        local snake_num = math.random(2,8)
                        for i = 1, snake_num, 1 do
                            local snake = SpawnPrefab("fwd_in_pdt_animal_snake")
                            snake.Transform:SetPosition(x, y, z)
                            local nearest_player = snake:GetNearestPlayer(true) --- 找半径10内最近的玩家打
                            if nearest_player and snake:GetDistanceSqToInst(nearest_player) <= 10*10 then
                                snake.components.combat:SuggestTarget(nearest_player)
                            end
                        end
                        
                    end)


                end
            )
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------