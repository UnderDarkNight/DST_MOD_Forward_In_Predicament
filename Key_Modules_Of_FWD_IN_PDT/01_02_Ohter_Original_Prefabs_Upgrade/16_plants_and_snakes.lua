------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    砍树出蛇

    杀死树精出蛇   leif_sparse  leif

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装刷蛇Event
    local function setup_snake_spawn_event(inst)
        inst:ListenForEvent("fwd_in_pdt_event.spawn_snake",function(_,offset_flag)
            local x,y,z = inst.Transform:GetWorldPosition()

            if offset_flag then
                local offset_x = math.random(10,20)/10
                local offset_z = math.random(10,20)/10
                if math.random(100) < 50 then
                    offset_x = -1 * offset_x
                end
                if math.random(100) < 50 then
                    offset_z = -1 * offset_z
                end

                x = x + offset_x
                z = z + offset_z
            end

            local snake =  SpawnPrefab("fwd_in_pdt_animal_snake")
            snake.Transform:SetPosition(x, 0, z)

            local nearest_player = snake:GetNearestPlayer(true) --- 找半径10内最近的玩家打
            if nearest_player and snake:GetDistanceSqToInst(nearest_player) <= 10*10 then
                snake.components.combat:SuggestTarget(nearest_player)
            end
        end)
    end
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

            if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 < 0.95 then    --- 5%概率出蛇
                return
            end

            inst:PushEvent("fwd_in_pdt_event.spawn_snake",true)

        end)
    end

    local tree_prefabs = {
        "evergreen",
        "evergreen_normal",
        "evergreen_tall",
        "evergreen_short",
        "evergreen_sparse",

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

                    setup_snake_spawn_event(inst)
                    setup_workfinished_event(inst)

                end
            )
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 采集出蛇
    local pickable_prefabs = {
        ["rock_avocado_bush"] = 0.1,                --- 石果树
        ["berrybush"] = 0.1,                        --- 浆果
        ["berrybush2"] = 0.1,                       --- 浆果
        ["marsh_bush"] = 0.1,                       --- 尖刺灌木
        ["tallbirdnest"] = 0.8,                     --- 高脚鸟巢穴
        ["flower"] = 0.1,                           --- 花
        ["planted_flower"] = 0.1,                   --- 花
        ["flower_evil"] = 0.1,                      --- 花
        ["reeds"] = 0.1,                            --- 芦苇
        ["bananabush"] = 0.1,                       --- 香蕉丛
        ["monkeytail"] = 0.1,                       --- 猴尾草
    }
    for the_prefab, temp_num  in pairs(pickable_prefabs) do   
        AddPrefabPostInit(
            the_prefab,
            function(inst)

                if not TheWorld.ismastersim then
                    return
                end

                setup_snake_spawn_event(inst)
                inst:ListenForEvent("picked",function()
                    if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 > (pickable_prefabs[inst.prefab]) then
                        return
                    end
                    inst:PushEvent("fwd_in_pdt_event.spawn_snake")
                end)

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
                    setup_snake_spawn_event(inst)

                    inst:ListenForEvent("death",function()
                        if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and math.random(1000)/1000 > 0.25 then
                            return
                        end
                        -- local x,y,z = inst.Transform:GetWorldPosition()
                        local snake_num = math.random(2,8)
                        -- for i = 1, snake_num, 1 do
                        --     local snake = SpawnPrefab("fwd_in_pdt_animal_snake")
                        --     snake.Transform:SetPosition(x, y, z)
                        --     local nearest_player = snake:GetNearestPlayer(true) --- 找半径10内最近的玩家打
                        --     if nearest_player and snake:GetDistanceSqToInst(nearest_player) <= 10*10 then
                        --         snake.components.combat:SuggestTarget(nearest_player)
                        --     end
                        -- end
                        for i = 1, snake_num, 1 do
                            inst:PushEvent("fwd_in_pdt_event.spawn_snake")
                        end
                        
                    end)


                end
            )
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------