------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 使用说明在  inst:ListenForEvent("Set"
-- 使用示例在本文件的末尾
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local assets = {
	-- Asset("ANIM", "anim/anim_test.zip"),
	-- Asset("ANIM", "anim/test_anim.zip"),
}


local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("fwd_in_pdt_island_creater")

    if not TheWorld.ismastersim then
        return inst
    end

    ----------------------------------------------------------------------------
    ---- 输入命令表，得到转置后的 地块表 tile_map  以及地皮参数 tile_map[y][x]
        local function exchange_tile_map(_table)
            -------- 坐标信息数据转换，方便代码阅读  由原来的一维数组转换成二维数组
            -------- 坐标数据会有时候产生Y轴镜像，留API自由处理
            -------- tile_map[y][x]  

            local tile_map = {}
            if _table.y_mirror == true then

                        local temp_x ,temp_y= 1,1
                        for i, the_ground in ipairs(_table.data) do
                            tile_map[temp_y] = tile_map[temp_y] or {}
                            tile_map[temp_y][temp_x] = the_ground
                            if i % _table.width == 0 then
                                temp_y = temp_y + 1
                                temp_x = 1
                            else
                                temp_x = temp_x + 1
                            end
                        end

            else                               
                        local temp_x ,temp_y= _table.width,1    --- 反向处理
                        for i, the_ground in ipairs(_table.data) do
                            tile_map[temp_y] = tile_map[temp_y] or {}
                            tile_map[temp_y][temp_x] = the_ground
                            if i % _table.width == 0 then
                                temp_y = temp_y + 1
                                temp_x = _table.width --- 反向处理
                            else
                                temp_x = temp_x - 1  --- 反向处理
                            end
                        end
            end
            return tile_map
        end
        inst._fn_exchange_tile_map = exchange_tile_map


    ----------------------------------------------------------------------------
    -- -- 输入整个命令表，返回起始操作 的 地块XY
        local function get_start_xy(_table)
            local map_width,map_height = TheWorld.Map:GetSize()

            local mid_tile_x , mid_tile_y = TheWorld.Map:GetTileCoordsAtPoint(_table.pt.x, 0, _table.pt.z) 
        
            local start_x = mid_tile_x - math.floor( _table.width/2 ) 
            local start_y = mid_tile_y - math.floor( _table.height/2 ) 
            
            ---------------------------------
            ---- 处理边界，不让生成的地区外溢地图尺寸
                if _table.within_map_limit_off ~= true then
                    if start_x < 1 then
                        start_x = 1
                    end
                    if start_y < 1 then
                        start_y = 1
                    end
                    if start_x + _table.width > map_width then
                        start_x = map_width - _table.width
                    end
                    if start_y + _table.height > map_height then
                        start_y = map_height - _table.height
                    end
                end
            --------------------------------
            return start_x,start_y
        end
    

    ----------------------------------------------------------------------------
    --- 输入地块的 XY 得到这个地块中心的 世界坐标Vector3()
        local function GetWorldPointByTileXY(x,y,map_width,map_height)
            if map_width == nil or map_height == nil then
                map_width,map_height = TheWorld.Map:GetSize()
            end
            local ret_x = x - map_width/2
            local ret_z = y - map_height/2
            return Vector3(ret_x*TILE_SCALE,0,ret_z*TILE_SCALE)
        end

        inst._fn_GetWorldPointByTileXY = GetWorldPointByTileXY
    ----------------------------------------------------------------------------


    ----------------------------------------------------------------------------
    ----- 使用event Set 进入命令表，生成 地形和删除本inst
    inst:ListenForEvent("Set",function(inst,_table)
        -- 命令表 和相关参数说明
        -- _table = {
        --     pt = Vector3(0,0,0),                         ------ 地形生成器中心点，生成的地形以该点所在的地皮为中心地皮
        --     width = 15,                                  ------ 数据宽度  15x15已经足够了，最大推荐31x31，再大就卡顿明显。
        --     height = 15,                                 ------ 数据高度
        --     data = {},                                   ------ data 来自 tiled.exe 生成的字符串（导出）。
        --                                                          -- tiled软件里，单个地块用 64x64 pix，然后载入饥荒地皮资源 ground.tsx。导出后直接复制字符串过来
        --                                                          -- 【警告】 数据必须是 奇数，不能是偶数！！！！！！！
        --                                                          -- 【警告】 数据必须是 奇数，不能是偶数！！！！！！！
        --                                                          -- 【警告】 数据必须是 奇数，不能是偶数！！！！！！！
        --     y_mirror = nil or true,                      -------- 是否Y轴镜像，可以缺省
        --     within_map_limit_off = nil,-- or true        ---- 【一般用不上】关闭 地图内部生成检测，以允许 修改地图尺寸以外的地皮，为true 的时候不检测
        --     remove_entities_flag = nil,-- or true ,      ---- 是否删除原有物品
        --     remove_scan_range = 3,                       ---- 每个地皮的扫描半径
        --     remove_ban_tags = {"epic"},                  ---- 不删除带有这些tag的物品
        --     remove_ban_prefabs = {"log"},                ---- 不删除指定prefab名字的inst

        --     
        --     【地形生态创建方案1 】【不推荐】： 边改边刷物品。注意利用 tag 避免下一个地块生成的时候扫到删除
        --     fn_in_tile = {                               ---- 用于一边改地皮一边在上面生成inst 
        --             ["tile_name"] = function(pt)                 --      由于删除物品的搜索是圆形半径4，生成的地皮是矩形4x4，对角距离6,        --                                                          
        --                                                          --      可能需要配合 remove_ban 使用以防止新生成物品被删
        --             end,
        --     },
            
        --     【地形生态创建方案2】： 地形创建完成后，根据另外一张 地形图 和对应 func  生成物品。
        --     edge = {                                                  ----  手动边界处理，可以多个边界
        --         [1] = {                                               ----  边界tile图表，可以多张类别的表 , 0 
        --             data = {},                                        ----  data 来自 tiled.exe 生成的字符串，0为无操作 ，剩下的 数字 和 fns 里的func对应  
        --                                                               ----  高宽一定要严格一致。
        --             fns = {
        --                 [1] = function(pt) end,                       ---- 进入 世界坐标，格式 Vector3(0,0,0)
        --             },
        --         },
        --     },
        
        --     【地形生态创建方案3】： 地形创建完成后，根据 所有地块中点坐标和总中心地块坐标，生成物品
        --     fn_insides = function(points,mid_world_pt) end,           ----  陆地生成完成后，执行该fn并进入 所有内部地皮中点坐标,还有该创建区域的中点坐标

        -- }

        if _table == nil or _table.pt == nil or _table.pt.x == nil 
        or _table.width == nil or _table.height == nil then
            return
        end
        

        ---- 创建器移动到指定坐标
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end

        ---------------------------------------------------------------------------------
        -------- 坐标信息数据转换，方便代码阅读  由原来的一维数组转换成二维数组
        -------- 坐标数据会有时候产生Y轴镜像，留API自由处理
        -------- tile_map[y][x]  
        local tile_map = exchange_tile_map(_table)
        local edge_tile_maps = nil  -- 地图组
        local edge_tile_maps_fns = nil   -- 函数组
        if _table.edge then
            edge_tile_maps = {}
            edge_tile_maps_fns = {}
            for i, v in ipairs(_table.edge ) do
                edge_tile_maps[i] = exchange_tile_map({
                    width = _table.width,
                    height = _table.height,
                    y_mirror = _table.y_mirror,
                    data = v.data,
                })
                edge_tile_maps_fns[i] = v.fns
            end
        end

        
        ---------------------------------------------------------------------------------
        ----- 给指定格子生成地形数据
        -- -- 获取坐标点的 地图格子 x，y
            local map_width,map_height = TheWorld.Map:GetSize()

            local start_x,start_y = get_start_xy(_table)

            --------------------------------
                ----- 原有物品相关的 tag 和 prefab 表,用于生成地皮的时候删除原有物品
                local musthavetags = nil
                local canthavetags = {"player","INLIMBO","nosteal","irreplaceable","flying","FX","multiplayer_portal","NOCLICK","birdblocker","antlion_sinkhole_blocker"}
                local musthaveoneoftags = nil
                if _table.remove_ban_tags then  ---- 扫描时候ban掉的tag
                    for k, v in pairs(_table.remove_ban_tags) do
                        table.insert(canthavetags,v)
                    end
                end
                local remove_ban_prefabs = {}   ---- table 转置一下
                if _table.remove_ban_prefabs then
                    for k, v in pairs(_table.remove_ban_prefabs) do
                        remove_ban_prefabs[v] = true
                    end
                end

                ----------- 用来检查要删除的 inst 能否被删
                    local function Check_Can_Be_Removed(target)
                        if target == nil or target.prefab == nil or not target:IsValid() then
                            return false
                        end                        
                        ------ 白名单上的prefab
                        if remove_ban_prefabs[target.prefab] then
                            return false
                        end

                         ------ y坐标轴高于 0 的东西不管
                         if target.Transform then
                            local temp_pt_x,temp_pt_y,temp_pt_z = target.Transform:GetWorldPosition()
                            if temp_pt_y > 0 then
                                return false
                            end
                        end

                        ----  parent 为玩家等物品
                        if target.parent and target.parent.HasOneOfTags and target.parent:HasOneOfTags(canthavetags) then
                            return false
                        end

                        if target and target.components then
                            ----- 正在跟随的生物（猪人，牛，蜘蛛 等）
                            if  target.components.follower and target.components.follower.leader 
                                and target.components.follower.leader.HasOneOfTags 
                                and target.components.follower.leader:HasOneOfTags(canthavetags) then
                                    return false
                        
                            elseif target.components.container or target.components.inventory then  
                                ------- 带容器的物品就不删了，避免出意外
                                return false
                            end

                        end

                        return true
                    end
                ----------------------------------------------------------------------

            local points = {}
            local mid_tile_x = start_x + math.floor( _table.width/2 ) 
            local mid_tile_y = start_y + math.floor( _table.height/2 ) 

            for x = 1, _table.width, 1 do
                for y = 1, _table.height, 1 do
                            local temp_tile = tile_map[y] and tile_map[y][x] or 0
                            if temp_tile ~= nil and temp_tile ~= 0 then
                                local the_x = start_x + x - 1
                                local the_y = start_y + y - 1

                                -- TheWorld.Map:SetTile(the_x,the_y, temp_tile) ---

                                -- ------------------------------------------------------------
                                local pt = GetWorldPointByTileXY(the_x,the_y,map_width,map_height)
                                table.insert(points,pt)   ---- 储存每个地皮中点坐标
                                ---  是否删除原有地形物品   ---- 每个地皮 4x4 距离，对角 4*1.414 = 5.656 ，搜索半径设置为 3.5
                                local range = _table.remove_scan_range or 3.5
                                if _table.remove_entities_flag == true then
                                    local ents = TheSim:FindEntities(pt.x, 0, pt.z, range, musthavetags, canthavetags, musthaveoneoftags)
                                    for k, v in pairs(ents) do
                                            if Check_Can_Be_Removed(v) then
                                                v:Remove()
                                            end
                                    end
                                    -- SpawnPrefab("log").Transform:SetPosition(pt.x, 0, pt.z)
                                end
                                --------------------------------------------------------------
                                ----- 先删除原有东西再生成地皮
                                TheWorld.Map:SetTile(the_x,the_y, temp_tile)    ---- 生成指定地皮

                                ----- 【方案1】 地皮生成完成，执行地皮内部资源生成func   
                                if _table.fn_in_tile then
                                    if _table.fn_in_tile and _table.fn_in_tile[temp_tile] and type(_table.fn_in_tile[temp_tile]) == "function" then
                                        _table.fn_in_tile[temp_tile](pt)
                                    end
                                end
                                -- -- ------------------------------------------------------------
                            end
                end
            end


        ---------------------------------------------------------------------------------
            --- 【方案2】  边缘相关算法 
            if edge_tile_maps ~= nil then
                    for x = 1, _table.width, 1 do
                        for y = 1, _table.height, 1 do

                                    for i, temp_edge_tile_map in ipairs(edge_tile_maps) do
                                        if temp_edge_tile_map[y][x] ~= nil and temp_edge_tile_map[y][x] ~= 0 and edge_tile_maps_fns[i] then
                                            local the_x = start_x + x - 1
                                            local the_y = start_y + y - 1
                                            local pt = GetWorldPointByTileXY(the_x,the_y,map_width,map_height)
                                            local the_type = temp_edge_tile_map[y][x]
                                            if edge_tile_maps_fns[i][the_type] then
                                                edge_tile_maps_fns[i][the_type](pt)
                                            end

                                        end
                                    end

                        end
                    end
            end
        ---------------------------------------------------------------------------------
            ---- 【方案3】 陆地生成完成后，执行该fn并进入 所有内部地皮中点坐标 
            if _table.fn_insides and type(_table.fn_insides) == "function" then
                local mid_world_pt = GetWorldPointByTileXY(mid_tile_x,mid_tile_y)
                _table.fn_insides(points,mid_world_pt)
            end

        ---------------------------------------------------------------------------------
        
        inst:Remove()
    end)



    inst:DoTaskInTime(0,inst.Remove)
    return inst
end

return Prefab("fwd_in_pdt_island_creater",fx,assets)


-------- 使用示例：

-- SpawnPrefab("fwd_in_pdt_island_creater"):PushEvent("Set",{
--     pt = Vector3(x,y,z),
--     width = 15,
--     height = 15,
--     remove_entities_flag = true,
--     remove_ban_tags = {"temp_create"},
--     data = {
--         0, 0,12,12,12, 0, 0, 0, 0, 0,12,12,12, 0, 0,
--         0,12,12,12,12,12, 0, 0, 0,12,12,12,12,12, 0,
--        12,12,12,12,12,12,12, 0,12,12,12,12,12,12,12,
--        12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--        12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--        12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--        12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--        12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--         0,12,12,12,12,12,12,12,12,12,12,12,12,12, 0,
--         0, 0,12,12,12,12,12,12,12,12,12,12,12, 0, 0,
--         0, 0, 0,12,12,12,12,12,12,12,12,12, 0, 0, 0,
--         0, 0, 0, 0,12,12,12,12,12,12,12, 0, 0, 0, 0,
--         0, 0, 0, 0, 0,12,12,12,12,12, 0, 0, 0, 0, 0,
--         0, 0, 0, 0, 0, 0,12,12,12, 0, 0, 0, 0, 0, 0,
--         0, 0, 0, 0, 0, 0, 0,12, 0, 0, 0, 0, 0, 0, 0
--     },
--     -- fn_in_tile = {
--     --     [7] = function(pt)  ---- 7 类型执行
--     --         SpawnPrefab("log").Transform:SetPosition(pt.x, 0, pt.z)
--     --     end,
--     --     [6] = function(pt)
--     --         SpawnPrefab("malbatross_beak").Transform:SetPosition(pt.x, 0, pt.z)                
--     --     end,
--     -- },
--     edge = {
--         [1] = {
--             data = {
--                 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0,
--                 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0,
--                 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1,
--                 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
--                 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
--                 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1,
--                 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1,
--                 1, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 1,
--                 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0,
--                 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, 0,
--                 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
--                 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
--                 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0,
--                 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0,
--                 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
--             },
--             fns = {
                
--                 [1] = function(pt)
--                         SpawnPrefab("pepper_oversized_waxed").Transform:SetPosition(pt.x, 0, pt.z)
--                 end,
--                 [2] = function(pt)
--                         SpawnPrefab("watermelon_oversized_waxed").Transform:SetPosition(pt.x, 0, pt.z)
--                 end,
--             }
--         }
--     }
-- })