------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 测试用的岛屿刷新器
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- if true then
--     return
-- end

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        if TheWorld:HasTag("cave") then
            return
        end

        inst.components.fwd_in_pdt_func:Map__Add_Terrain_Modifier("ice_moon_island_creater",function()
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            print("info : 04_ice_moon_island_creater.lua start")
            if TheWorld.components.fwd_in_pdt_data:Get("ice_moon_island_creater.island.created") == true then
                print("info : 04_ice_moon_island_creater.lua jump out")
                return
            end            
            TheWorld.components.fwd_in_pdt_data:Set("ice_moon_island_creater.island.created",true)

            local start_time = os.clock(); 
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                local tiles_for_search = TheWorld.components.fwd_in_pdt_func.map_data.OceanTileMap  or {}
                if TheWorld:HasTag("cave") then
                    tiles_for_search = TheWorld.components.fwd_in_pdt_func.map_data.VoidTileMap or {}
                    print("info tiles_for_search in cave",#tiles_for_search)
                end

                local ret_appropriate_tiles = {}

                local target_tile_check_fn = function(tile_num,all_tile_datas)
                    -- -- 加了月岛地皮检测后，费时陡增，得想其他方法应对
                    -- if all_tile_datas and all_tile_datas.mid_pt then 
                    --     local x,z = all_tile_datas.mid_pt.x , all_tile_datas.mid_pt.z
                    --     if TheWorld.Map:FindVisualNodeAtPoint(x, 0 , z, "lunacyarea") then
                    --         return false
                    --     end
                    -- end

                    
                    if TheWorld:HasTag("cave") then   ---- 洞穴里的虚空
                        return not TileGroupManager:IsLandTile(tile_num)
                    else  
                        if all_tile_datas and all_tile_datas.mid_pt then
                            local x,z = all_tile_datas.mid_pt.x , all_tile_datas.mid_pt.z
                            local node_index = TheWorld.Map:GetNodeIdAtPoint(x, 0, z) or 0
                            local node = TheWorld.topology.nodes[node_index]
                            if node and table.contains(node.tags, "lunacyarea") then
                                return false
                            end
                        end                       

                        return TileGroupManager:IsOceanTile(tile_num)
                    end
                end


                local the_tags = {"epic","charactor","cocoon_home","shadecanopy","structure","antlion_sinkhole_blocker","oceanvine","plant"}
                local can_not_have_this_inst___check_fn = function(temp_inst)
                    if temp_inst and temp_inst:HasOneOfTags(the_tags) then
                        return false
                    end
                    return true
                end
                if TheWorld:HasTag("cave") then
                    can_not_have_this_inst___check_fn = function()
                        return false
                    end
                end


                local quik_search_temp_flags_table = {}
                for k, temp_tile_data in pairs(tiles_for_search) do

                    local start_x = temp_tile_data.tile_x
                    local start_y = temp_tile_data.tile_y
                    local area_flag = TheWorld.components.fwd_in_pdt_func:Map_Quick_Area_Check_In_Tiles(start_x,start_y,13,21,target_tile_check_fn,can_not_have_this_inst___check_fn,quik_search_temp_flags_table)
                    
                    if area_flag == true then 
                        table.insert(ret_appropriate_tiles,temp_tile_data)
                    end                    
                end

                print("ret_appropriate_tiles num",#ret_appropriate_tiles)
                if #ret_appropriate_tiles > 0 then
                    local the_start_tile = ret_appropriate_tiles[math.random(#ret_appropriate_tiles)]
                    local start_tile_x = the_start_tile.tile_x
                    local start_tile_y = the_start_tile.tile_y
                    local start_mid_pt = the_start_tile.mid_pt


                    local end_tile_x = start_tile_x + 13
                    local end_tile_y = start_tile_y + 21

                    local the_end_tile = TheWorld.components.fwd_in_pdt_func.map_data.TileMap[end_tile_y][end_tile_x]
                    local end_mid_pt = the_end_tile.mid_pt


                    local island_mid_pt = Vector3( (start_mid_pt.x + end_mid_pt.x)/2,0,(start_mid_pt.z + end_mid_pt.z)/2)
                    
                    local cmd_table = {
                         pt = island_mid_pt,         --- 中心点坐标
                        remove_entities_flag = true,    --- 清空内部东西
                        -- remove_scan_range = 4,          --- 清空的半径，默认3.5
                        width = 13,
                        height = 21,
                        data = {
                            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                            0, 30, 30, 30, 30, 30,  0,  0,  0,  0,  0,  0,  0,
                            0,  0,  0,  2,  2,  2, 30, 30,  0,  0,  0,  0,  0,
                            0,  0,  0,  0,  6,  2,  2,  2, 30,  0,  0,  0,  0,
                            0,  0,  0,  0,  0,  6,  6,  2,  2, 30,  0,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,  2,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,256,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,256,256,  2,  2, 30,  0,  0,
                            0,  0,  0,  0,  0,  6,  6,  2,  2, 30,  0,  0,  0,
                            0,  0,  0,  0,  6,  2,  2,  2, 30,  0,  0,  0,  0,
                            0,  0,  0,  2,  2,  2, 30, 30,  0,  0,  0,  0,  0,
                            0, 30, 30, 30, 30, 30,  0,  0,  0,  0,  0,  0,  0,
                            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                        }, 
                        edge = {
                            [1] = {
                                data = {
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                                    0,  1,  1,  1,  1,  1,  0,  0,  0, 14,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0,  0,
                                    0,  0,  0,  0,  2,  0,  2,  0,  1,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0, 16,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  3,  0,  7,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  4,  0,  8,  0,  1,  0,  0,
                                    0,  0,  0,  0, 13,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  5,  0,  9,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  6,  0, 10,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 17,  0,  0,
                                    0,  0,  0,  0,  0,  0, 11,  0,  0, 12,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,
                                    0,  0,  0,  0,  2,  0,  2,  0,  1,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0,  0,
                                    0,  1,  1,  1,  1,  1,  0,  0,  0, 15,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                                },
                                fns = {                            
                                    [1] = function(pt)  --- 1 号位置：树木
                                            SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [2] = function(pt)  --- 2 号位置 ：猪屋
                                            SpawnPrefab("pighouse").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [3] = function(pt)  --- 3 号位置： 商店
                                            SpawnPrefab("wardrobe").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [4] = function(pt)  --- 4 号位置： 材料店铺
                                            SpawnPrefab("wardrobe").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [5] = function(pt)  --- 5 号位置： 料理商店
                                            SpawnPrefab("wintersfeastoven").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [6] = function(pt)  --- 6 号位置： ATM
                                            SpawnPrefab("sisturn").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [7] = function(pt)  --- 7 号位置： 占位 ，上标记
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__ice_moon_island_tile_7"
                                            })
                                    end,
                                    [8] = function(pt)  --- 8 号位置： 占位 ，上标记
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__ice_moon_island_tile_8"
                                            })
                                    end,
                                    [9] = function(pt)  --- 9 号位置： 占位 ，上标记
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__ice_moon_island_tile_9"
                                            })
                                    end,
                                    [10] = function(pt)  --- 10 号位置： 占位 ，上标记
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__ice_moon_island_tile_10"
                                            })
                                    end,
                                    [11] = function(pt)  --- 11 号位置：NPC 面善的法师
                                        SpawnPrefab("wargshrine").Transform:SetPosition(pt.x, 0, pt.z)                                            
                                    end,
                                    [12] = function(pt)  --- 12 号位置：NPC 农业小亨
                                        SpawnPrefab("pigshrine").Transform:SetPosition(pt.x, 0, pt.z)                                            
                                    end,
                                    [13] = function(pt)  --- 13 号位置：冰川创建基点
                                        -- SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                        --     pt = Vector3(pt.x,0,pt.z+2),
                                        --     tag = "fwd_in_pdt__ice_moon_island_tile_13"
                                        -- })
                                        local base_pt = Vector3(pt.x+13,0,pt.z + 2)    --- 基点

                                        SpawnPrefab("fwd_in_pdt_resource_glacier_small").Transform:SetPosition(base_pt.x, 0, base_pt.z + 6)                                            
                                        SpawnPrefab("fwd_in_pdt_resource_glacier_small").Transform:SetPosition(base_pt.x, 0, base_pt.z - 6)  
                                        SpawnPrefab("fwd_in_pdt_resource_glacier_small").Transform:SetPosition(base_pt.x-12, 0, base_pt.z + 6)                                            
                                        SpawnPrefab("fwd_in_pdt_resource_glacier_small").Transform:SetPosition(base_pt.x-12, 0, base_pt.z - 6)                                          
                                        

                                        SpawnPrefab("fwd_in_pdt_resource_glacier_huge").Transform:SetPosition(base_pt.x - 6, 0, base_pt.z )

                                    end,
                                    [14] = function(pt)  --- 14 号位置：船
                                        local x,y,z = pt.x + 3.5 , 0 , pt.z - 3.5
                                        SpawnPrefab("boat").Transform:SetPosition(x,y,z)
                                        SpawnPrefab("oar_driftwood").Transform:SetPosition(x, 1, z)
                                    end,
                                    [15] = function(pt)  --- 15 号位置：船
                                        local x,y,z = pt.x + 3.5 , 0 , pt.z + 3.5
                                        SpawnPrefab("boat").Transform:SetPosition(pt.x+3.5, 0, pt.z+3.5)
                                        SpawnPrefab("oar_driftwood").Transform:SetPosition(x, 1, z)

                                    end,
                                    [16] = function(pt)  --- 16 号位置：传送站
                                        SpawnPrefab("fwd_in_pdt__rooms_mini_portal_door").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [17] = function(pt)  --- 17 号位置：洞穴出入口
                                        SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree_special").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                }
                            }
                        }
                    }
                    SpawnPrefab("fwd_in_pdt_island_creater"):PushEvent("Set",cmd_table)
                end
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            local end_time = os.clock();            
            print(string.format(" special island create task cost time  : %.4f", end_time - start_time));
            print("info : 04_ice_moon_island_creater.lua end")
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        end)
    end
)


