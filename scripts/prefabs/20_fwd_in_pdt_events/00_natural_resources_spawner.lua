---------------------------------------------------------------------------------------------------------------------
--- 本刷新器是用来刷新自然资源的，包括植物、矿石、或者部分生物
--- 利用天数，和 加载范围实现效果。
--- This refresher is used to refresh natural resources, including plants, ores, or some creatures
--- Use the number of days, and the loading range to achieve the effect.

-- -- API :
--     SpawnPrefab("fwd_in_pdt_natural_resources_spawner"):PushEvent("Set",{
--         pt = Vector3(x,0,z),        --- 刷新器坐标。                    spawner's location
--         days = 0,                    --- 经过多少天刷新资源 。            After XX days of refreshing resources。
--         season = "summer" ,         -- nil ， autumn , winter , spring , summer ,        --- -- TheWorld.state.season == "winter"  --
--         prefab = "berrybush",       -- target prefab name


--         range = 10,                 -- nil or number . 随机坐标偏移范围 。    Random Coordinate Offset Range
--         tile = nil,                 -- nil or number or number table 。 在随机坐标偏移范围内的指定地皮，或者地皮组。   -- 地皮
--                                     --  A specified tile, or group of tiles, within a random coordinate offset.                                    
--         ignore_tile = nil ,         -- nil or number or number table 。 在随机坐标偏移范围内需要忽略掉的地皮，或者地皮组。
--                                     -- tile, or groups of tiles, that need to be ignored within the random coordinate offset range.
--     })

---------------------------------------------------------------------------------------------------------------------




local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then  -- 测试的时候弄个外观，方便观察
    --     inst.AnimState:SetBank("mushroom_light")
    --     inst.AnimState:SetBuild("mushroom_light")
    --     inst.AnimState:PlayAnimation("idle")
    -- end


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fwd_in_pdt_data")
    inst:AddComponent("fwd_in_pdt_func"):Init({"long_update"})

    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     day = 0,
        --     season = "summer" , -- nil,  --- -- TheWorld.state.season == "winter"  -- autumn , winter , spring , summer
        --     prefab = "name",
        --     tile = nil,    -- tile num or table      --- 地皮的数字，或者数字table
        --     ignore_tile = nil , -- 需要屏蔽的地皮 tile num or table      --- 地皮的数字，或者数字table
        --     range = 1,   -- or nil
        -- }
        if _table == nil then
            return
        end
        if _table.pt == nil or _table.pt.x == nil or _table.prefab == nil then
            return
        end
        _table.days = _table.days or 0    --- 天数初始化
        inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)

        inst.components.fwd_in_pdt_data:Set("data",_table)        
        inst.components.fwd_in_pdt_data:Set("Ready",true)
    end)

    ------ 没数据就删除
    inst.__onload_flag = true       ---- 用来解决0天的时候，玩家在附近的时候，立马刷内容的问题
    inst:DoTaskInTime(0,function()
        if inst.components.fwd_in_pdt_data:Get("Ready") ~= true then
            print("error : fwd_in_pdt_natural_resources_spawner is not ready and remove")
            inst:Remove()
        end
        inst.__onload_flag = nil
    end)
    -----------------------------------------------------------------------------------------------------
    ---- 运行逻辑
        local function spawner_fn(inst)
            local x,y,z = inst.Transform:GetWorldPosition()
            local cmd_table = inst.components.fwd_in_pdt_data:Get("data")
            local current_days = inst.components.fwd_in_pdt_data:Add("days",0)
            local tar_days = cmd_table.days or 0
            local prefab = cmd_table.prefab or "log"
            local spawned_target_flag = false

            if current_days < tar_days then      
                return
            end

            if cmd_table.season and cmd_table.season ~= TheWorld.state.season then  --- 季节不对
                return
            end

            if cmd_table.range == nil then                              ---- 没有设置距离，则直接在原位生成。
                SpawnPrefab(prefab).Transform:SetPosition(x, y, z)
                spawned_target_flag = true
            elseif type(cmd_table.range) == "number" then

                    local function get_pt_random_fix(range)
                        local num = math.random( (range or 1)*100)/100
                        if math.random(100) < 50 then
                            num = -1 * num
                        end
                        return num
                    end
                    local range = cmd_table.range
                    local tile = cmd_table.tile
                    local ignore_tile = cmd_table.ignore_tile

                    if tile == nil and ignore_tile == nil then         ------ 没有地皮限制
                            local tar_x = x + get_pt_random_fix(range)
                            local tar_z = z + get_pt_random_fix(range)
                            SpawnPrefab(prefab).Transform:SetPosition(tar_x, 0, tar_z)
                            spawned_target_flag = true
                    else                        ------ 有地皮限制

                            local tar_tiles = {}

                            if type(tile) == "number" then          --- 单个地皮
                                tar_tiles[tile] = true
                            elseif type(tile) == "table" then       --- 多个地皮的时候
                                for k, v in pairs(tile) do
                                    tar_tiles[v] = true
                                end
                            end

                            local ignore_tiles = {}                 --- 需要屏蔽的地皮
                            if type(ignore_tile) == "number" then
                                ignore_tiles[ignore_tile] = true
                            elseif type(ignore_tile) == "table" then
                                for k, v in pairs(ignore_tile) do
                                    ignore_tiles[v] = true
                                end 
                            end


                            local tar_x = nil
                            local tar_z = nil
                            local found_flag = false
                            local try_num = 100     --- 尝试 100次寻找
                            while try_num > 0 do
                                try_num = try_num - 1
                                tar_x = x + get_pt_random_fix(range)
                                tar_z = z + get_pt_random_fix(range)
                                local current_tile = TheWorld.Map:GetTileAtPoint(tar_x,0, tar_z)
                                if tar_tiles[current_tile] == true and ignore_tiles[current_tile] ~= true then
                                    found_flag = true
                                    try_num = -1
                                end
                            end
                            if found_flag == true and tar_x ~= nil and tar_z ~= nil then
                                SpawnPrefab(prefab).Transform:SetPosition(tar_x, 0, tar_z)
                                spawned_target_flag = true
                            end

                        
                    end



            end






            if spawned_target_flag == true then
                inst:Remove()
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
                    print("info fwd_in_pdt_natural_resources_spawner : spawned target and inst remove",cmd_table.prefab)
                end
            end
        end
        inst:WatchWorldState("cycles", function()
            local current_days = inst.components.fwd_in_pdt_data:Add("days",1)
            if  inst:GetDistanceSqToClosestPlayer() < 25*25 then
                return
            end
            spawner_fn(inst)
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
                print("info fwd_in_pdt_natural_resources_spawner  cycles day",current_days ,inst)
            end
        end)

        inst.components.fwd_in_pdt_func:Add_OnEntityWake_Fn(function(inst)
            if inst.__onload_flag ~= nil then
                return
            end
            spawner_fn(inst)
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
                print("info fwd_in_pdt_natural_resources_spawner  OnEntityWake",inst)
            end
        end)

        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
            inst.components.fwd_in_pdt_func:Add_OnEntitySleep_Fn(function()
                print("info fwd_in_pdt_natural_resources_spawner  OnEntitySleep",inst )                
            end)
        end

    -----------------------------------------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_natural_resources_spawner",fn)







