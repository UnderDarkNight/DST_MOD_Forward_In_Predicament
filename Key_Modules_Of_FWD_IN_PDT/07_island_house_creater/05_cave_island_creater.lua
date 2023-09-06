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
        if not TheWorld:HasTag("cave") then
            return
        end

        inst.components.fwd_in_pdt_func:Map__Add_Terrain_Modifier("cave_island_creater",function()
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            print("info : 05_cave_island_creater.lua start")
            if TheWorld.components.fwd_in_pdt_data:Get("cave_island_creater.island.created") == true then
                print("info : 05_cave_island_creater.lua jump out")
                return
            end            
            TheWorld.components.fwd_in_pdt_data:Set("cave_island_creater.island.created",true)

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
                            0,  0,264,264,264,264,  0,  0,  0,  0,  0,  0,  0,
                            0,  3,  3,  3,  3,  3,264,264,  0,  0,  0,  0,  0,
                            0,  3,  3,  3,  3,  3,  3,  3,264,  0,  0,  0,  0,
                            0,  3, 11,  3,  3,  3, 11,  3,  3,264,  0,  0,  0,
                            0, 11, 11, 11,  3, 11, 11, 11,  3,  3,264,  0,  0,
                            0,  3, 11,  3,  3,  3, 11,  3,  3,  3,264,  0,  0,
                            0,  3,  3,  3, 30,  3,  3,  3,  3,  3,264,  0,  0,
                            0,  3, 11,  3,  3,  3, 11,  3,  3,  3,264,  0,  0,
                            0, 11, 11, 11,  3, 11, 11, 11,  3,  3,264,  0,  0,
                            0,  3, 11,  3,  3,  3, 11,  3,  3,  3,264,  0,  0,
                            0,  3,  3,  3,263,  3,  3,  3,  3,  3,264,  0,  0,
                            0,  3,  3,  3,  3,  3,  3,  3,  3,  3,264,  0,  0,
                            0,  3,263,  3,263,  3,263,  3,  3,  3,264,  0,  0,
                            0,  3,  3,  3,  3,  3,  3,  3,  3,  3,264,  0,  0,
                            0,  3,  3,  3,263,  3,  3,  3,  3,264,  0,  0,  0,
                            0,  3,  3,  3,  3,  3,  3,  3,264,  0,  0,  0,  0,
                            0,  3,  3,  3,  3,  3,264,264,  0,  0,  0,  0,  0,
                            0,  0,264,264,264,264,  0,  0,  0,  0,  0,  0,  0,
                            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                            0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                        }, 
                        edge = {
                            [1] = {
                                data = {
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                                    0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,
                                    0,  0,  9,  0, 10,  0,  1,  1,  0,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0, 11,  0,  1,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0, 12,  1,  0,  0,  0,
                                    0,  4,  0,  5,  0,  0,  2,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0, 13,  1,  0,  0,
                                    0,  0,  0,  0,  7,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  2,  0,  0,  0,  2,  0,  6,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  3,  0,  0,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0, 16,  1,  0,  0,
                                    0,  0,  3,  0, 19,  0,  3,  0,  0,  0,  1,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0, 18,  1,  0,  0,
                                    0,  0,  0,  0,  3,  0,  0,  0,  0,  1,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0, 17,  1,  0,  0,  0,  0,
                                    0,  8,  0, 14,  0, 15,  1,  1,  0,  0,  0,  0,  0,
                                    0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
                                    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                                },
                                fns = {                            
                                    [1] = function(pt)  --- 1 号位置：暗影灯
                                            SpawnPrefab("nightlight").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [2] = function(pt)  --- 2 号位置 ：大理石树
                                            SpawnPrefab("eyeturret").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [3] = function(pt)  --- 3 号位置： 暗影灯2
                                            SpawnPrefab("nightlight").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [4] = function(pt)  --- 4 号位置： 赌博机
                                            SpawnPrefab("yotr_decor_2").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [5] = function(pt)  --- 5 号位置： ATM
                                            SpawnPrefab("pigshrine").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [6] = function(pt)  --- 6 号位置： 医院
                                            SpawnPrefab("carnivalgame_puckdrop_station").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [7] = function(pt)  --- 7 号位置： 离开洞穴传送门                           
                                            SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree_special").Transform:SetPosition(pt.x, 0, pt.z)
                                            -- local tree = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_quirky_red_tree_special")
                                            -- if tree then
                                            --     tree.Transform:SetPosition(pt.x,0,pt.z)
                                            -- end
                                    end,
                                    [8] = function(pt)  --- 8 号位置： 绚丽之门传送
                                        SpawnPrefab("fwd_in_pdt__rooms_mini_portal_door").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [9] = function(pt)  --- 9 号位置：NPC A
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__special_island.npc_a",
                                                hide = true,
                                            })
                                    end,
                                    [10] = function(pt)  --- 10 号位置： NPC B
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__special_island.npc_b",
                                                hide = true,
                                            })
                                    end,
                                    [11] = function(pt)  --- 11 号位置：NPC C
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_c",
                                            hide = true,
                                        })                                         
                                    end,
                                    [12] = function(pt)  --- 12 号位置：NPC D
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_d",
                                            hide = true,
                                        })                                       
                                    end,
                                    [13] = function(pt)  --- 13 号位置：NPC E
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_e",
                                            hide = true,
                                        })                                          
                                    end,
                                    [14] = function(pt)  --- 14 号位置： NPC F
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_f",
                                            hide = true,
                                        })
                                    end,
                                    [15] = function(pt)  --- 15 号位置： NPC G
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_g",
                                            hide = true,
                                        })

                                    end,
                                    [16] = function(pt)  --- 16 号位置： NPC H
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_h",
                                            hide = true,
                                        })
                                    end,
                                    [17] = function(pt)  --- 17 号位置：NPC I
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_i",
                                            hide = true,
                                        })
                                    end,
                                    [18] = function(pt)  --- 17 号位置：NPC J
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_j",
                                            hide = true,
                                        })
                                    end,
                                    [19] = function(pt)  --- 17 号位置：NPC K
                                        SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                            pt = Vector3(pt.x,0,pt.z),
                                            tag = "fwd_in_pdt__special_island.npc_k"
                                        })
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
            print("info : 05_cave_island_creater.lua end")
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        end)
    end
)


