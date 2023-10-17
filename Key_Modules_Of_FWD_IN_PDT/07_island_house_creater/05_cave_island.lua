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
                    local area_flag = TheWorld.components.fwd_in_pdt_func:Map_Quick_Area_Check_In_Tiles(start_x,start_y,23,13,target_tile_check_fn,can_not_have_this_inst___check_fn,quik_search_temp_flags_table)
                    
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


                    local end_tile_x = start_tile_x + 23
                    local end_tile_y = start_tile_y + 13

                    local the_end_tile = TheWorld.components.fwd_in_pdt_func.map_data.TileMap[end_tile_y][end_tile_x]
                    local end_mid_pt = the_end_tile.mid_pt


                    local island_mid_pt = Vector3( (start_mid_pt.x + end_mid_pt.x)/2,0,(start_mid_pt.z + end_mid_pt.z)/2)
                    
                    local road = 2  --卵石路
                    local roky = 3  -- 岩石地皮
                    local redt = 30 -- 红树林
                    local NONE = 4  -- 什么都没有
                    local ruin = 18 -- 远古地皮

                    local cmd_table = {
                         pt = island_mid_pt,         --- 中心点坐标
                        remove_entities_flag = true,    --- 清空内部东西
                        -- remove_scan_range = 4,          --- 清空的半径，默认3.5
                        width = 23,
                        height = 13,
                        data = {
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,   0,   0,roky,roky,roky,   0,   0,   0,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,   0,roky,   0,NONE,   0,roky,   0,   0,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,roky,   0,NONE,NONE,NONE,   0,roky,   0,   0,   0,   
                                    0,road,road,road,road,road,road,road,road,road,road,road,road,roky,NONE,NONE,redt,NONE,NONE,   0,roky,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,roky,   0,NONE,NONE,NONE,   0,roky,   0,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,   0,roky,   0,NONE,   0,roky,   0,NONE,   0,   0,   
                                    0,road,road,road,road,road,road,road,   0,   0,   0,   0,   0,   0,   0,roky,roky,roky,   0,NONE,NONE,   0,   0,   
                                    0,   0,   0,   0,road,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,road,   0,   0,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,road,road,road,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,ruin,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                        }, 
                        edge = {
                            [1] = {
                                data = {
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   3,   4,   3,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   3,   0,  12,   0,  12,   0,   3,   0,   0,   0,   
                                    0,   0,   0,   0,   1,   0,   0,   0,   0,   0,   8,   0,   0,   0,   0,   0,   2,   0,   0,   0,   6,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   3,   0,  12,   0,  12,   0,   3,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   3,   5,   3,   0,   0,   7,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   9,   0,   9,  10,   9,  11,   9,   0,   9,  11,   9,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,  14,   0,  14,   0,   0,  14,   0,   0,  13,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   9,   0,   9,  10,   9,  10,   9,  11,   9,  10,   9,   0,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                                },
                                fns = {                            
                                    [1] = function(pt)  --- 1 号位置： 娃娃机
                                            SpawnPrefab("fwd_in_pdt_building_doll_clamping_machine").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [2] = function(pt)  --- 2 号位置 ： 特殊树（离洞传送门） （中点）
                                            SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree_special").Transform:SetPosition(pt.x, 0, pt.z)
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__red_tree_island_mid_point",
                                                hide = true,
                                            })
                                    end,
                                    [3] = function(pt)  --- 3 号位置：  幡灯
                                            SpawnPrefab("fwd_in_pdt_building_banner_light").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [4] = function(pt)  --- 4 号位置：  公告
                                            SpawnPrefab("fwd_in_pdt_building_bulletin_board").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [5] = function(pt)  --- 5 号位置： ATM
                                            SpawnPrefab("fwd_in_pdt_building_atm").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [6] = function(pt)  --- 6 号位置： 当铺
                                            SpawnPrefab("fwd_in_pdt_building_pawnshop").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [7] = function(pt)  --- 7 号位置： 迷你传送门                                        
                                        SpawnPrefab("fwd_in_pdt__rooms_mini_portal_door").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [8] = function(pt)  --- 8 号位置： 幡灯2
                                        -- SpawnPrefab("fwd_in_pdt_building_banner_light").Transform:SetPosition(pt.x, 0, pt.z+1.5)
                                    end,
                                    [9] = function(pt)  --- 9 号位置： 雕像
                                        SpawnPrefab("ruins_statue_mage").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [10] = function(pt)  --- 10 号位置： 主教
                                        SpawnPrefab("bishop_nightmare").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [11] = function(pt)  --- 11 号位置： 发条骑士
                                        SpawnPrefab("knight_nightmare").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [12] = function(pt)  --- 12 号位置： 大理石树
                                        SpawnPrefab("marbletree").Transform:SetPosition(pt.x, 0, pt.z)                                     
                                    end,
                                    [13] = function(pt)  --- 13 号位置： 远古科技
                                        SpawnPrefab("ancient_altar_broken").Transform:SetPosition(pt.x-1, 0, pt.z)                                     
                                    end,
                                    [14] = function(pt)  --- 14 号位置： 战车
                                        SpawnPrefab("rook_nightmare").Transform:SetPosition(pt.x, 0, pt.z)                                     
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


