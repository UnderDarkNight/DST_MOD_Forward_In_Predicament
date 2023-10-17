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
            print("info : 04_red_tree_island.lua start")
            if TheWorld.components.fwd_in_pdt_data:Get("ice_moon_island_creater.island.created") == true then
                print("info : 04_red_tree_island.lua jump out")
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
                    local area_flag = TheWorld.components.fwd_in_pdt_func:Map_Quick_Area_Check_In_Tiles(start_x,start_y,19,19,target_tile_check_fn,can_not_have_this_inst___check_fn,quik_search_temp_flags_table)
                    
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


                    local end_tile_x = start_tile_x + 19
                    local end_tile_y = start_tile_y + 19

                    local the_end_tile = TheWorld.components.fwd_in_pdt_func.map_data.TileMap[end_tile_y][end_tile_x]
                    local end_mid_pt = the_end_tile.mid_pt


                    local island_mid_pt = Vector3( (start_mid_pt.x + end_mid_pt.x)/2,0,(start_mid_pt.z + end_mid_pt.z)/2)
                    
                    -- local rd1 = WORLD_TILES[string.upper("fwd_in_pdt_turf_cobbleroad")]
                    local carp = 11 --- 牛毛地毯
                    local redt = 30 --- 落叶林地毯
                    local fost = 7  --- 森林地皮
                    local cobb = WORLD_TILES[string.upper("fwd_in_pdt_turf_cobbleroad")]
                    local lawn = WORLD_TILES[string.upper("fwd_in_pdt_turf_grasslawn")]
                    local snak = WORLD_TILES[string.upper("fwd_in_pdt_turf_snakeskin")]

                    local cmd_table = {
                         pt = island_mid_pt,         --- 中心点坐标
                        remove_entities_flag = true,    --- 清空内部东西
                        -- remove_scan_range = 4,          --- 清空的半径，默认3.5
                        width = 19,
                        height = 19,
                        data = {
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                    0,   0,carp,carp,   0,   0,   0,   0,   0,   0,   0,   0,   0,cobb,cobb,   0,   0,   0,   0,   
                                    0,carp,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,cobb,cobb,   0,   0,   
                                    0,carp,   0,carp,   0,redt,redt,redt,redt,redt,redt,redt,   0,carp,   0,cobb,cobb,   0,   0,   
                                    0,carp,   0,   0,   0,redt,cobb,cobb,cobb,cobb,cobb,redt,   0,   0,   0,cobb,cobb,   0,   0,   
                                    0,   0,   0,   0,redt,redt,cobb,lawn,lawn,lawn,cobb,redt,redt,   0,   0,   0,cobb,   0,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,   0,cobb,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,   0,cobb,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,cobb,   0,   0,   
                                    0,   0,   0,   0,cobb,cobb,cobb,lawn,lawn,lawn,cobb,cobb,cobb,cobb,cobb,cobb,   0,   0,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,cobb,   0,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,   0,cobb,   0,   
                                    0,   0,   0,   0,redt,cobb,lawn,snak,lawn,snak,lawn,cobb,redt,   0,   0,   0,   0,cobb,   0,   
                                    0,   0,   0,   0,redt,redt,cobb,lawn,lawn,lawn,cobb,redt,redt,   0,   0,   0,cobb,   0,   0,   
                                    0,carp,   0,   0,   0,redt,cobb,cobb,cobb,cobb,cobb,redt,   0,   0,   0,fost,cobb,   0,   0,   
                                    0,carp,   0,carp,   0,redt,redt,redt,redt,redt,redt,redt,   0,carp,   0,fost,cobb,   0,   0,   
                                    0,carp,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,fost,cobb,   0,   0,   
                                    0,   0,carp,carp,   0,   0,   0,   0,   0,   0,   0,   0,   0,fost,fost,   0,   0,   0,   0,   
                                    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                        }, 
                        edge = {
                            [1] = {
                                data = {
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,  17,   0,  19,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  14,   0,   0,   
                                        0,   0,   0,   1,   0,   2,   0,   2,   0,   2,   0,   2,   0,   1,   0,   0,  15,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,  22,   0,   0,   0,   0,   0,   0,   0,  14,   0,   0,   
                                        0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   6,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   2,   0,   0,   8,   0,  10,   0,   0,   2,  12,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   5,   0,   0,   0,   4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   2,   0,   0,   9,   0,  11,   0,   0,   3,  13,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   7,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,  23,   0,   0,   0,   0,   0,   0,  21,   0,  24,   0,   
                                        0,   0,   0,   1,   0,   2,   0,   2,   0,   2,   0,   2,   0,   1,   0,  21,   0,  24,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  16,   0,  24,   0,   
                                        0,   0,   0,  18,   0,  20,   0,   0,   0,   0,   0,   0,   0,  16,  16,   0,   0,   0,   0,   
                                        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
                                },
                                fns = {                            
                                    [1] = function(pt)  --- 1 号位置： 幡灯
                                            SpawnPrefab("fwd_in_pdt_building_banner_light").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [2] = function(pt)  --- 2 号位置 ： 树
                                            SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [3] = function(pt)  --- 3 号位置： 特殊树（传送门）
                                            SpawnPrefab("fwd_in_pdt__rooms_quirky_red_tree_special").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [4] = function(pt)  --- 4 号位置：  避雷针（中点）
                                            SpawnPrefab("fwd_in_pdt__resources_occupancy_sign"):PushEvent("Set",{
                                                pt = Vector3(pt.x,0,pt.z),
                                                tag = "fwd_in_pdt__red_tree_island_mid_point",
                                                hide = true,
                                            })

                                            SpawnPrefab("lightning_rod").Transform:SetPosition(pt.x, 0, pt.z)
                                            local f_x,f_y,f_z = pt.x,0,pt.z
                                            local f_delta_z = 4/3
                                            f_z = f_z + 2 
                                            for i = 1, 12, 1 do
                                                SpawnPrefab("flower").Transform:SetPosition(f_x,f_y,f_z)
                                                f_z = f_z + f_delta_z
                                            end
                                            f_z = pt.z
                                            f_z = f_z - 2 
                                            for i = 1, 12, 1 do
                                                SpawnPrefab("flower").Transform:SetPosition(f_x,f_y,f_z)
                                                f_z = f_z - f_delta_z
                                            end

                                    end,
                                    [5] = function(pt)  --- 5 号位置：   迷你传送门
                                            SpawnPrefab("fwd_in_pdt__rooms_mini_portal_door").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [6] = function(pt)  --- 6 号位置：  公告栏
                                            SpawnPrefab("fwd_in_pdt_building_bulletin_board").Transform:SetPosition(pt.x , 0, pt.z)
                                    end,
                                    [7] = function(pt)  --- 7 号位置：  ATM
                                            SpawnPrefab("fwd_in_pdt_building_atm").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [8] = function(pt)  --- 8 号位置：  医院
                                            SpawnPrefab("fwd_in_pdt_building_hospital").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [9] = function(pt)  --- 9 号位置：  特殊商店
                                            SpawnPrefab("fwd_in_pdt_building_special_shop").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [10] = function(pt)  --- 10 号位置： 材料商店                                            
                                            SpawnPrefab("fwd_in_pdt_building_materials_shop").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [11] = function(pt)  --- 11 号位置： 点心商店
                                            SpawnPrefab("fwd_in_pdt_building_cuisines_shop").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [12] = function(pt)  --- 12 号位置： 冰川
                                            SpawnPrefab("fwd_in_pdt_resource_glacier_huge").Transform:SetPosition(pt.x-3, 0, pt.z-4)
                                    end,
                                    [13] = function(pt)  --- 13 号位置： 冰川
                                            SpawnPrefab("fwd_in_pdt_resource_glacier_huge").Transform:SetPosition(pt.x-3, 0, pt.z+4)                                        
                                    end,
                                    [14] = function(pt)  --- 14 号位置： 圣诞树
                                            SpawnPrefab("winter_treestand").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [15] = function(pt)  --- 15 号位置： 旅馆
                                            SpawnPrefab("fwd_in_pdt_building_hotel").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [16] = function(pt)  --- 16 号位置： 芒果树
                                            SpawnPrefab("fwd_in_pdt_plant_mango_tree").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [17] = function(pt)  --- 17 号位置： 大象
                                            SpawnPrefab("koalefant_summer").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [18] = function(pt)  --- 18 号位置： 冬象
                                            SpawnPrefab("koalefant_winter").Transform:SetPosition(pt.x, 0, pt.z)
                                    end,
                                    [19] = function(pt)  --- 19 号位置： 船
                                            local x,y,z = pt.x + 0 , 0 , pt.z
                                            SpawnPrefab("boat").Transform:SetPosition(x,y,z)
                                            SpawnPrefab("oar_driftwood").Transform:SetPosition(x, 1, z)
                                    end,
                                    [20] = function(pt)  --- 20 号位置： 船
                                            local x,y,z = pt.x + 0 , 0 , pt.z
                                            SpawnPrefab("boat").Transform:SetPosition(x,y,z)
                                            SpawnPrefab("oar_driftwood").Transform:SetPosition(x, 1, z)
                                    end,
                                    [21] = function(pt)  --- 21  号位置： 猪屋                                        
                                            SpawnPrefab("pighouse").Transform:SetPosition(pt.x, 0, pt.z)                                        
                                    end,
                                    [22] = function(pt)  --- 22 号位置： 幡灯
                                            SpawnPrefab("fwd_in_pdt_building_banner_light").Transform:SetPosition(pt.x, 0, pt.z-2)
                                    end,
                                    [23] = function(pt)  --- 23 号位置： 幡灯
                                            SpawnPrefab("fwd_in_pdt_building_banner_light").Transform:SetPosition(pt.x, 0, pt.z+2)
                                    end,
                                    [24] = function(pt)  --- 24 号位置： 养鱼池
                                            local farm = SpawnPrefab("fwd_in_pdt_fish_farm")
                                            farm.Transform:SetPosition(pt.x, 0, pt.z)
                                            farm:DoTaskInTime(1,function()
                                                farm.components.container:GiveItem(SpawnPrefab("chum"))
                                                farm.components.container:GiveItem(SpawnPrefab("chum"))
                                                local fishs = {
                                                    "pondfish",
                                                    "pondeel",
                                                    "oceanfish_medium_1_inv",
                                                    "oceanfish_medium_2_inv",
                                                    "oceanfish_medium_3_inv",
                                                    "oceanfish_medium_4_inv",
                                                    "oceanfish_medium_5_inv",
                                                    "oceanfish_medium_6_inv",
                                                    "oceanfish_medium_7_inv",
                                                    "oceanfish_medium_8_inv",
                                                    "oceanfish_small_8_inv",
                                                    "oceanfish_small_7_inv",
                                                    "oceanfish_small_6_inv",
                                                    "oceanfish_small_5_inv",
                                                    "oceanfish_small_4_inv",
                                                    "oceanfish_small_3_inv",
                                                    "oceanfish_small_2_inv",
                                                    "oceanfish_small_1_inv",
                                                    "oceanfish_small_9_inv",
                                                }
                                                farm.components.container:GiveItem(SpawnPrefab(fishs[math.random(#fishs)]))
                                                farm.components.container:GiveItem(SpawnPrefab(fishs[math.random(#fishs)]))
                                            end)
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
            print("info : 04_red_tree_island.lua end")
            ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        end)
    end
)


