------------------------------------------------------------------------------------------------
--- 这个文件是给 TheWorld 使用。
-- 至少在 DoTaskInTime 0 的时候执行并扫描全图。然后所有操作都在扫描全图后。
------ 使用 协程 避免可能的存档创建的时候造成掉线的问题。（尤其是地图扫描造成的超时）

-- 1、用来修改地图。岛屿生成，或者陆地生成。
-- 2、用来添加生物、自然资源等。

-- tiled软件里，单个地块用 64x64 pix，然后载入饥荒地皮资源 ground.tsx。导出后直接复制字符串过来
-- 【警告】 由于快速查找法函数过于简单，地图数据库的 W H 数据必须是 奇数，不能是偶数！！！！！！！
-- 【警告】 由于快速查找法函数过于简单，地图数据库的 W H 数据必须是 奇数，不能是偶数！！！！！！！
-- 【警告】 由于快速查找法函数过于简单，地图数据库的 W H 数据必须是 奇数，不能是偶数！！！！！！！
-- 【警告】 由于快速查找法函数过于简单，地图数据库的 W H 数据必须是 奇数，不能是偶数！！！！！！！
------------------------------------------------------------------------------------------------
--- 【笔记】别问为什么 是 TileMap[y][x] ，python留下的习惯。
------------------------------------------------------------------------------------------------



local function main_com(fwd_in_pdt_func)
    if not TheWorld.ismastersim then 
        return
    end
    if fwd_in_pdt_func.inst ~= TheWorld then
        return
    end
    if fwd_in_pdt_func.map_data ~= nil then   -- 避免极端情况下重复注册了该函数
        return
    end
    ---------------------------------------------------------------------------------------------
    fwd_in_pdt_func.map_data = {}
    fwd_in_pdt_func.map_data.creaters_task_names = {} --- 有新增岛屿的时候自动启动扫描全图任务
    fwd_in_pdt_func.map_data.TileMap = {}             ---    
                                                -- map_data.TileMap[y][x] = { 
                                                --                 tile = 1,
                                                --                 ents = {}, 
                                                --                 tile_x = 0,tile_y = 0,
                                                --                 mid_pt = Vector3()
                                                --
                                                -- }

    fwd_in_pdt_func.map_data.LandTileMap = {}         --- 陆地
    fwd_in_pdt_func.map_data.OceanTileMap = {}        --- 海洋
    fwd_in_pdt_func.map_data.VoidTileMap = {}         --- 虚空（洞穴里用）

    fwd_in_pdt_func.map_data.w = 0
    fwd_in_pdt_func.map_data.h = 0
    fwd_in_pdt_func.map_data.creaters_fn = {}
    ---------------------------------------------------------------------------------------------
    --- 可能有用的函数
    -- GetTileCenterPoint
    ---------------------------------------------------------------------------------------------
    --- 输入地块的 XY 得到这个地块中心的 世界坐标Vector3() -- 默认每个格子为 4x4距离
        function fwd_in_pdt_func:Map_GetWorldPointByTileXY(x,y,map_width,map_height)
                if map_width == nil or map_height == nil then
                    map_width,map_height = TheWorld.Map:GetSize()
                end
                local ret_x = x - map_width/2
                local ret_z = y - map_height/2
                return Vector3(ret_x*TILE_SCALE,0,ret_z*TILE_SCALE)
        end
    ---------------------------------------------------------------------------------------------
    --- 输入地块的坐标，得到tile 的XY
        function fwd_in_pdt_func:Map_GetTileAtPoint(x,y,z)
            return TheWorld.Map:GetTileAtPoint(x,0,z)
        end
    ---------------------------------------------------------------------------------------------
    --- 地图区域限制检查
        function fwd_in_pdt_func:Map_Area_Plenty_Check(x,y,w,h)
            if type(x) ~= "number" or type(y) ~= "number" or type(w) ~= "number" or type(h) ~= "number" then
                return nil
            end
            ------------- 刷一下上下限，避免bug
            local start_x = x
            if start_x < 1 then start_x = 1 end
            if start_x > self.map_data.w then start_x = self.map_data.w end

            local start_y = y
            if start_y < 1 then start_y = 1 end
            if start_y > self.map_data.h then start_y = self.map_data.h end

            local end_x = start_x + w
            if end_x > self.map_data.w then 
                return false
            end

            local end_y = start_y + h
            if end_y > self.map_data.h then
                return false
            end

            return true,start_x,start_y,end_x,end_y
        end
    ---------------------------------------------------------------------------------------------
    --- 扫描一个方形区域，根据tag 得到里面的 inst
        ---- 耗时间太久，每个地皮都扫描了。
        ---- 如果条件不正常，或者区域超出地图，返回nil
        ---- tile_check_fn 检查地皮。  tile_check_fn(tile_num)
        ---- inst_check_fn 检查内部inst,返回所有检测结果为 true 的 inst
        function fwd_in_pdt_func:Map_Find_Ents_In_Tiles(x,y,w,h,tile_check_fn,inst_check_fn)            

            -- if type(x) ~= "number" or type(y) ~= "number" or type(w) ~= "number" or type(h) ~= "number" then
            --     return nil
            -- end
            -- ------------- 刷一下上下限，避免bug
            -- local start_x = x
            -- if start_x < 1 then start_x = 1 end
            -- if start_x > self.map_data.w then start_x = self.map_data.w end

            -- local start_y = y
            -- if start_y < 1 then start_y = 1 end
            -- if start_y > self.map_data.h then start_y = self.map_data.h end

            -- local end_x = start_x + w
            -- if end_x > self.map_data.w then 
            --     return nil
            -- end

            -- local end_y = start_y + h
            -- if end_y > self.map_data.h then
            --     return nil
            -- end
            local check_flag,start_x,start_y,end_x,end_y = self:Map_Area_Plenty_Check(x, y, w, h)
            if check_flag ~= true then
                return nil
            end
            
            local ret_insts = {}
            for t_y = start_y, end_y, 1 do
                for t_x = start_x, end_x, 1 do
                    ------------------------------------------------
                    local temp_map_data = self.map_data.TileMap[t_y][t_x]

                    if tile_check_fn and type(tile_check_fn) == "function" and tile_check_fn(temp_map_data.tile) ~= true then     --- 地皮检查未通过
                        return nil
                    end

                    for k, temp_inst in pairs(temp_map_data.ents) do
                        if inst_check_fn and type(inst_check_fn) == "function"  then
                                if inst_check_fn(temp_inst) == true then
                                    table.insert(ret_insts,temp_inst)
                                end
                        else
                                table.insert(ret_insts,temp_inst)
                        end
                    end
                    
                    ------------------------------------------------
                end
            end

            return ret_insts
        end

    ---------------------------------------------------------------------------------------------
    --- 获取某个区域内的所有inst
        function fwd_in_pdt_func:Map_Get_Ents_In_Tiles_Area(start_x,start_y,end_x,end_y)
            local crash_flag,ret_insts = pcall(function()
                local temp_ents = {}
                for y = start_y, end_y, 1 do
                    for x = start_x, end_x, 1 do
                        --------------------------------------------------------
                        local temp_table = self.map_data.TileMap[y][x].ents or {}
                        for k, v in pairs(temp_table) do
                            table.insert(temp_ents,v)
                        end
                        --------------------------------------------------------
                    end
                end
                return temp_ents
            end)

            if crash_flag then
                return ret_insts
            else
                return {}
            end
        end
    ---------------------------------------------------------------------------------------------
    --- 使用快速地皮检测法。检查目标区域内是否合适。
        ---- 四个顶点，和中间十字，扫描地皮。然后判断所有内部inst
        ---- target_tile_check_fn(num)
        ---- can_not_have_this_inst___check_fn(inst)  , true 的时候不通过检查。
        ---- quik_search_temp_table 外部table，用来储存暂时安全的tile。加速算法匹配。index 使用 self.map_data.TileMap[y][x]
        function fwd_in_pdt_func:Map_Quick_Area_Check_In_Tiles(x,y,w,h,target_tile_check_fn,can_not_have_this_inst___check_fn,quik_search_temp_table)
            local check_flag,start_x,start_y,end_x,end_y = self:Map_Area_Plenty_Check(x, y, w, h)
            if check_flag ~= true then
                return false
            end

            local mid_x = math.floor( (start_x + end_x)/2 )
            local mid_y = math.floor( (start_y + end_y)/2 )

            quik_search_temp_table = quik_search_temp_table or {}       --- init
            quik_search_temp_table.tiles_check = quik_search_temp_table.tiles_check or {}
            quik_search_temp_table.insts_check = quik_search_temp_table.insts_check or {}

            ----- 检查地皮
            if target_tile_check_fn and type(target_tile_check_fn) == "function" then

                    ---- 第一步，检查角落四个点
                    if target_tile_check_fn(self.map_data.TileMap[start_y][start_x].tile,self.map_data.TileMap[start_y][start_x]) == true and
                        target_tile_check_fn(self.map_data.TileMap[end_y][end_x].tile,self.map_data.TileMap[end_y][end_x]) == true and
                        target_tile_check_fn(self.map_data.TileMap[start_y][end_x].tile,self.map_data.TileMap[start_y][end_x]) == true and
                        target_tile_check_fn(self.map_data.TileMap[end_y][start_x].tile,self.map_data.TileMap[end_y][start_x]) == true then
                            --- 四个点检查通过
                    else
                        ---- 四个点地皮检查未通过，直接返回
                        return false
                    end                    

                    --- 第二步，中心十字
                    for ty = start_y, end_y, 1 do
                        
                        if target_tile_check_fn(self.map_data.TileMap[ty][mid_x].tile,self.map_data.TileMap[ty][mid_x]) ~= true then
                            return false
                        end
                    end

                    for tx = start_x, end_x, 1 do
                        if target_tile_check_fn(self.map_data.TileMap[mid_y][tx].tile,self.map_data.TileMap[mid_y][tx]) ~= true then
                            return false
                        end
                    end


                    -- local temp_current_tile_data_table = nil

                    -- --- start_x,start_y
                    -- temp_current_tile_data_table = self.map_data.TileMap[start_y][start_x]
                    -- if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --     quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false
                    --     return false
                    -- end

                    -- --- end_x,end_y
                    -- temp_current_tile_data_table = self.map_data.TileMap[end_y][end_x]
                    -- if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --     quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false
                    --     return false
                    -- end

                    -- --- start_x,end_y
                    -- temp_current_tile_data_table = self.map_data.TileMap[end_y][start_x]
                    -- if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --     quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false
                    --     return false
                    -- end

                    -- --- end_x,start_y
                    -- temp_current_tile_data_table = self.map_data.TileMap[start_y][end_x]
                    -- if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --     quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false
                    --     return false
                    -- end

                    -- for y = start_y, end_y, 1 do
                    --     temp_current_tile_data_table = self.map_data.TileMap[y][mid_x]
                    --     if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --         quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false 
                    --         return false
                    --     end
                    -- end

                    -- for x = start_x, end_x, 1 do
                    --     temp_current_tile_data_table = self.map_data.TileMap[mid_y][x]
                    --     if quik_search_temp_table.tiles_check[temp_current_tile_data_table] == false or target_tile_check_fn(temp_current_tile_data_table.tile) ~= true then
                    --         quik_search_temp_table.tiles_check[temp_current_tile_data_table] = false
                    --         return false
                    --     end
                    -- end

            end


            ------ 内部inst 检查
            if can_not_have_this_inst___check_fn and type(can_not_have_this_inst___check_fn)  == "function" then                
            
                        for ty = start_y, end_y, 1 do
                            for tx = start_x, end_x, 1 do
                                local temp_map_data_table = self.map_data.TileMap[ty][tx]
                                
                                if quik_search_temp_table.insts_check[temp_map_data_table] == false then
                                    return false
                                end

                                local tile_ents = temp_map_data_table.ents or {}
                                for k, temp_inst in pairs(tile_ents) do
                                    if can_not_have_this_inst___check_fn(temp_inst) == true then
                                        quik_search_temp_table.insts_check[temp_map_data_table] = false
                                        return false
                                    end                                    
                                end

                            end
                        end

            end


            return true
        end

    ---------------------------------------------------------------------------------------------

    

    
    function fwd_in_pdt_func:Map__Add_Terrain_Modifier(task_name,fn)              ----- 添加创建的任务
        if task_name and  type(task_name) == "string" and fn and type(fn) == "function" then
            table.insert(self.map_data.creaters_task_names,task_name)
            table.insert(self.map_data.creaters_fn, fn)
        end
    end

    function fwd_in_pdt_func:Map__DataInit()  ----- 获取当前地图上所有的数据，每个地形创建任务执行后，最好都初始化一次
        ------------------------------------------------ step 0 : 清空地图相关的数据。
            self.map_data.TileMap = {}             ---    
                                                -- map_data.TileMap[y][x] = { 
                                                --                 tile = 1,
                                                --                 ents = {}, 
                                                --                 tile_x = 0,tile_y = 0,
                                                --                 mid_pt = Vector3()
                                                --
                                                -- }

            self.map_data.LandTileMap = {}         --- 陆地
            self.map_data.OceanTileMap = {}        --- 海洋
            self.map_data.VoidTileMap = {}         --- 虚空（洞穴里用）



        ------------------------------------------------ step 1 : 得到地图的 tile 尺寸，和 tile
        local map_w,map_h = TheWorld.Map:GetSize()
        self.map_data.w = map_w
        self.map_data.h = map_h
        -- -- 得到整个地图的地形表 world_tile_map[y][x] 
        -- local world_tile_map = {}   -- 整个地图的地形表
        -- for y = 1, map_h, 1 do
        --     world_tile_map[y] = world_tile_map[y] or {}
        --     for x = 1, map_w, 1 do
        --         world_tile_map[y][x] = TheWorld.Map:GetTile(x,y)                        
        --     end
        -- end
        for y = 1, map_h, 1 do
            self.map_data.TileMap[y] = self.map_data.TileMap[y] or {}
            for x = 1, map_w, 1 do
                self.map_data.TileMap[y][x] = self.map_data.TileMap[y][x] or {}
                local temp_current_tile = TheWorld.Map:GetTile(x,y) 
                self.map_data.TileMap[y][x].tile = temp_current_tile
                self.map_data.TileMap[y][x].tile_x = x
                self.map_data.TileMap[y][x].tile_y = y
                local mid_pt = self:Map_GetWorldPointByTileXY(x, y, map_w, map_h)
                self.map_data.TileMap[y][x].mid_pt = mid_pt
                self.map_data.TileMap[y][x].ents = self.map_data.TileMap[y][x].ents or {}
                if TileGroupManager:IsOceanTile(temp_current_tile) then                     ----- 海洋
                    table.insert(self.map_data.OceanTileMap, self.map_data.TileMap[y][x])
                end

                if TileGroupManager:IsLandTile(temp_current_tile) then                      ----- 陆地
                    table.insert(self.map_data.LandTileMap, self.map_data.TileMap[y][x])
                end

                -- if not TileGroupManager:IsInvalidTile(temp_current_tile) then               ---- 洞穴虚空（没什么用，暂时留着）
                --     table.insert(self.map_data.VoidTileMap, self.map_data.TileMap[y][x])
                -- end
                if TheWorld:HasTag("cave") and not TileGroupManager:IsLandTile(temp_current_tile) then  ---- 洞穴虚空
                    table.insert(self.map_data.VoidTileMap, self.map_data.TileMap[y][x])
                end 

            end
        end
        
        ------------------------------------------------ step 2 : 得到每个tile 里的 ents
        -- 扫描 Ents
        -- TheWorld.Map:GetTileAtPoint(x,y,z)
        for k, temp_inst in pairs(Ents) do
            if temp_inst and temp_inst.Transform then
                local tx,ty,tz = temp_inst.Transform:GetWorldPosition()
                local temp_tile_x ,temp_tile_y = TheWorld.Map:GetTileXYAtPoint(tx, 0, tz)
                if type(temp_tile_x) == "number" and type(temp_tile_y) == "number" and temp_tile_x <= map_w and temp_tile_y <= map_h then
                    self.map_data.TileMap[temp_tile_y][temp_tile_x].ents = self.map_data.TileMap[temp_tile_y][temp_tile_x].ents or {}
                    table.insert(self.map_data.TileMap[temp_tile_y][temp_tile_x].ents,temp_inst)
                end
            end
        end



    end

    function fwd_in_pdt_func:Map_Time_0_Task_Start()
        local inst = self.inst
        -------------------------------------------------------------------------------------------------------------
        ---- 检查是否需要执行地图扫描任务。如果有新增的岛屿计划，则启动扫描任务，不然就跳过。
        local start_map_base_data_scan = false
        for k, temp_task_name in pairs(self.map_data.creaters_task_names) do
            local flag_name = "TheWorld_Map_Modifier_Tasks."..temp_task_name
            if TheWorld.components.fwd_in_pdt_data:Get(flag_name) ~= true then
                start_map_base_data_scan = true
            end
        end

        if start_map_base_data_scan ~= true then
            return
        end

        for k, temp_task_name in pairs(self.map_data.creaters_task_names) do
            local flag_name = "TheWorld_Map_Modifier_Tasks."..temp_task_name
            TheWorld.components.fwd_in_pdt_data:Set(flag_name,true)
        end

        print("info : FWD_IN_PDT TheWorld map modifier task start")

        -------------------------------------------------------------------------------------------------------------

        self:Map__DataInit()    ---- 直接替代了下面的代码
        -- ------------------------------------------------ step 1 : 得到地图的 tile 尺寸，和 tile
        -- local map_w,map_h = TheWorld.Map:GetSize()
        -- self.map_data.w = map_w
        -- self.map_data.h = map_h
        -- -- -- 得到整个地图的地形表 world_tile_map[y][x] 
        -- -- local world_tile_map = {}   -- 整个地图的地形表
        -- -- for y = 1, map_h, 1 do
        -- --     world_tile_map[y] = world_tile_map[y] or {}
        -- --     for x = 1, map_w, 1 do
        -- --         world_tile_map[y][x] = TheWorld.Map:GetTile(x,y)                        
        -- --     end
        -- -- end
        -- for y = 1, map_h, 1 do
        --     self.map_data.TileMap[y] = self.map_data.TileMap[y] or {}
        --     for x = 1, map_w, 1 do
        --         self.map_data.TileMap[y][x] = self.map_data.TileMap[y][x] or {}
        --         local temp_current_tile = TheWorld.Map:GetTile(x,y) 
        --         self.map_data.TileMap[y][x].tile = temp_current_tile
        --         self.map_data.TileMap[y][x].tile_x = x
        --         self.map_data.TileMap[y][x].tile_y = y
        --         local mid_pt = self:Map_GetWorldPointByTileXY(x, y, map_w, map_h)
        --         self.map_data.TileMap[y][x].mid_pt = mid_pt
        --         self.map_data.TileMap[y][x].ents = self.map_data.TileMap[y][x].ents or {}
        --         if TileGroupManager:IsOceanTile(temp_current_tile) then                     ----- 海洋
        --             table.insert(self.map_data.OceanTileMap, self.map_data.TileMap[y][x])
        --         end

        --         if TileGroupManager:IsLandTile(temp_current_tile) then                      ----- 陆地
        --             table.insert(self.map_data.LandTileMap, self.map_data.TileMap[y][x])
        --         end

        --         -- if not TileGroupManager:IsInvalidTile(temp_current_tile) then               ---- 洞穴虚空（没什么用，暂时留着）
        --         --     table.insert(self.map_data.VoidTileMap, self.map_data.TileMap[y][x])
        --         -- end
        --         if TheWorld:HasTag("cave") and not TileGroupManager:IsLandTile(temp_current_tile) then  ---- 洞穴虚空
        --             table.insert(self.map_data.VoidTileMap, self.map_data.TileMap[y][x])
        --         end 

        --     end
        -- end
        
        -- ------------------------------------------------ step 2 : 得到每个tile 里的 ents
        -- -- 扫描 Ents
        -- -- TheWorld.Map:GetTileAtPoint(x,y,z)
        -- for k, temp_inst in pairs(Ents) do
        --     if temp_inst and temp_inst.Transform then
        --         local tx,ty,tz = temp_inst.Transform:GetWorldPosition()
        --         local temp_tile_x ,temp_tile_y = TheWorld.Map:GetTileXYAtPoint(tx, 0, tz)
        --         self.map_data.TileMap[temp_tile_y][temp_tile_x].ents = self.map_data.TileMap[temp_tile_y][temp_tile_x].ents or {}
        --         table.insert(self.map_data.TileMap[temp_tile_y][temp_tile_x].ents,temp_inst)
        --     end
        -- end

        ------------------------------------------------ step 3 : 执行创建函数
        for k, temp_fn in pairs(self.map_data.creaters_fn) do
            if temp_fn and type(temp_fn) == "function" then
                temp_fn()
            end
        end

        -------------------------------------------------------------------------------------------------------------

        print("info : FWD_IN_PDT TheWorld map modifier task end")
    end

    ------ 使用 协程 避免可能的存档创建的时候造成掉线的问题。（尤其是地图扫描造成的连接超时）
    fwd_in_pdt_func:Add_TheWorld_OnPostInit_Fn(function()    
        local inst = fwd_in_pdt_func.inst
        inst:StartThread(function()        --- 启用协程
            inst.components.fwd_in_pdt_func:Map_Time_0_Task_Start()            
        end)
    end)

    -- fwd_in_pdt_func.inst:DoTaskInTime(0,function(inst)
    --     inst.components.fwd_in_pdt_func:Map_Time_0_Task_Start()
    -- end)

end

local function replica(fwd_in_pdt_func)
    
end

return function(fwd_in_pdt_func)
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func) 
    else      
        replica(fwd_in_pdt_func)
    end
end