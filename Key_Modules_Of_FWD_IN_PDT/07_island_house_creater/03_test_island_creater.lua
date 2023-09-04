-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- 测试用的岛屿刷新器
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end
--         -- if TheWorld:HasTag("cave") then
--         --     return
--         -- end

--         inst.components.fwd_in_pdt_func:Map__Add_Terrain_Modifier("03_test_island_creater",function()
--             ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--             print("info : 03_test_island_creater.lua start")
--             if TheWorld.components.fwd_in_pdt_data:Get("test.island.created") == true then
--                 print("info : 03_test_island_creater.lua jump out")
--                 return
--             end            
--             TheWorld.components.fwd_in_pdt_data:Set("test.island.created",true)

--             local start_time = os.clock(); 
--             ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                 local tiles_for_search = TheWorld.components.fwd_in_pdt_func.map_data.OceanTileMap  or {}
--                 if TheWorld:HasTag("cave") then
--                     tiles_for_search = TheWorld.components.fwd_in_pdt_func.map_data.VoidTileMap or {}
--                     print("info tiles_for_search in cave",#tiles_for_search)
--                 end

--                 local ret_appropriate_tiles = {}

--                 local target_tile_check_fn = function(tile_num)     
--                     if TheWorld:HasTag("cave") then   ---- 洞穴里的虚空
--                         return not TileGroupManager:IsLandTile(tile_num)
--                     else       
--                         return TileGroupManager:IsOceanTile(tile_num)
--                     end
--                 end


--                 local the_tags = {"epic","charactor","cocoon_home","shadecanopy","structure","antlion_sinkhole_blocker","oceanvine","plant"}
--                 local can_not_have_this_inst___check_fn = function(temp_inst)
--                     if temp_inst and temp_inst:HasOneOfTags(the_tags) then
--                         return false
--                     end
--                     return true
--                 end
--                 if TheWorld:HasTag("cave") then
--                     can_not_have_this_inst___check_fn = function()
--                         return false
--                     end
--                 end


--                 local quik_search_temp_flags_table = {}
--                 for k, temp_tile_data in pairs(tiles_for_search) do

--                     local start_x = temp_tile_data.tile_x
--                     local start_y = temp_tile_data.tile_y
--                     local area_flag = TheWorld.components.fwd_in_pdt_func:Map_Quick_Area_Check_In_Tiles(start_x,start_y,15,15,target_tile_check_fn,can_not_have_this_inst___check_fn,quik_search_temp_flags_table)
                    
--                     if area_flag == true then 
--                         table.insert(ret_appropriate_tiles,temp_tile_data)
--                     end                    
--                 end

--                 print("ret_appropriate_tiles num",#ret_appropriate_tiles)
--                 if #ret_appropriate_tiles > 0 then
--                     local the_start_tile = ret_appropriate_tiles[math.random(#ret_appropriate_tiles)]
--                     local start_tile_x = the_start_tile.tile_x
--                     local start_tile_y = the_start_tile.tile_y
--                     local start_mid_pt = the_start_tile.mid_pt


--                     local end_tile_x = start_tile_x + 15
--                     local end_tile_y = start_tile_y + 15

--                     local the_end_tile = TheWorld.components.fwd_in_pdt_func.map_data.TileMap[end_tile_y][end_tile_x]
--                     local end_mid_pt = the_end_tile.mid_pt


--                     local island_mid_pt = Vector3( (start_mid_pt.x + end_mid_pt.x)/2,0,(start_mid_pt.z + end_mid_pt.z)/2)
                    
--                     local cmd_table = {
--                          pt = island_mid_pt,         --- 中心点坐标
--                         remove_entities_flag = true,    --- 清空内部东西
--                         -- remove_scan_range = 4,          --- 清空的半径，默认3.5
--                         width = 15,
--                         height = 15,
--                         data = {
--                             0, 0,12,12,12, 0, 0, 0, 0, 0,12,12,12, 0, 0,
--                             0,12,12,12,12,12, 0, 0, 0,12,12,12,12,12, 0,
--                             12,12,12,12,12,12,12, 0,12,12,12,12,12,12,12,
--                             12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--                             12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--                             12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--                             12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--                             12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
--                             0,12,12,12,12,12,12,12,12,12,12,12,12,12, 0,
--                             0, 0,12,12,12,12,12,12,12,12,12,12,12, 0, 0,
--                             0, 0, 0,12,12,12,12,12,12,12,12,12, 0, 0, 0,
--                             0, 0, 0, 0,12,12,12,12,12,12,12, 0, 0, 0, 0,
--                             0, 0, 0, 0, 0,12,12,12,12,12, 0, 0, 0, 0, 0,
--                             0, 0, 0, 0, 0, 0,12,12,12, 0, 0, 0, 0, 0, 0,
--                             0, 0, 0, 0, 0, 0, 0,12, 0, 0, 0, 0, 0, 0, 0
--                         }, 
--                         edge = {
--                             [1] = {
--                                 data = {
--                                     0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0,
--                                     0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0,
--                                     1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1,
--                                     1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
--                                     1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
--                                     1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1,
--                                     1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1,
--                                     1, 0, 0, 0, 0, 2, 2, 3, 2, 2, 0, 0, 0, 0, 1,
--                                     0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 0,
--                                     0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, 0,
--                                     0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
--                                     0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
--                                     0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0,
--                                     0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0,
--                                     0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
--                                 },
--                                 fns = {                            
--                                     [1] = function(pt)
--                                             SpawnPrefab("pepper_oversized_waxed").Transform:SetPosition(pt.x, 0, pt.z)
--                                     end,
--                                     [2] = function(pt)
--                                             SpawnPrefab("watermelon_oversized_waxed").Transform:SetPosition(pt.x, 0, pt.z)
--                                     end,
--                                     [3] = function(pt)
--                                             SpawnPrefab("sentryward").Transform:SetPosition(pt.x, 0, pt.z)
--                                     end,
--                                 }
--                             }
--                         }
--                     }
--                     SpawnPrefab("fwd_in_pdt_island_creater"):PushEvent("Set",cmd_table)
--                 end
--             ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--             local end_time = os.clock();            
--             print(string.format(" special island create task cost time  : %.4f", end_time - start_time));
--             print("info : 03_test_island_creater.lua end")
--             ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--         end)
--     end
-- )


