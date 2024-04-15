------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    搜寻小岛中心标记位，给小岛地皮添加tag 和 对应地皮的 event

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        if TheWorld:HasTag("cave") then
            return
        end


        inst:DoTaskInTime(5,function()            

            --------------------------------------------------------------------------------------------------------------------------
            --- 
                ---- 第一步，找到小岛中心点
                    local island_center_inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt__red_tree_island_mid_point")
                    if island_center_inst == nil then
                        return
                    end
                    local island_mid_pt = Vector3(island_center_inst.Transform:GetWorldPosition())
                    island_mid_pt.y = 0


                ---- 第二步，基于小岛中心点坐标，获取全岛地块坐标
                    local tx,ty = inst.components.fwd_in_pdt_com_world_map_tile_sys:Get_Tile_XY_By_World_Point(island_mid_pt)

                ---- 第三步，基于中心点坐标，添加 tag 和 event


                    local start_tx = tx - 9     --- 地块 起始/结束 坐标
                    local end_tx = tx + 8
                    local start_ty = ty - 8
                    local end_ty = ty + 8

                    local player_join_fn = function(player,tx,ty) --- 玩家进入地块触发的事件
                        -------------------------------------------------------------------------------
                        ----
                            if not player.components.fwd_in_pdt_com_tag_sys:HasTag("in_red_tree_island") then
                                player.components.fwd_in_pdt_com_tag_sys:AddTag("in_red_tree_island")
                                TheNet:Announce("玩家进入小岛")
                                --- 下发背景音乐播放事件
                            end
                        -------------------------------------------------------------------------------

                    end
                    local player_leave_fn = function(player,tx,ty)    --- 玩家离开地块触发的事件
                        --- 需要延时，不然同岛上的地块会移除tag
                        player:DoTaskInTime(0,function()
                            local player_pt = Vector3(player.Transform:GetWorldPosition())
                            if not inst.components.fwd_in_pdt_com_world_map_tile_sys:Has_Tag_In_Point(player_pt,"fwd_in_pdt__red_tree_island_tile") then
                                -------------------------------------------------------------------------------
                                -----
                                    player.components.fwd_in_pdt_com_tag_sys:RemoveTag("in_red_tree_island")
                                    TheNet:Announce("+++ 玩家离开小岛 +++")
                                    --- 下发背景音乐播放事件

                                -------------------------------------------------------------------------------
                            end
                        end)
                    end


                    for i = start_tx,end_tx do  --- 遍历并添加 tag 和 event
                        for j = start_ty,end_ty do
                            inst.components.fwd_in_pdt_com_world_map_tile_sys:Add_Tag_To_Tile_XY(i,j,"fwd_in_pdt__red_tree_island_tile")
                            inst.components.fwd_in_pdt_com_world_map_tile_sys:Add_Join_Event_Fn_To_Tile_XY(i,j,player_join_fn)
                            inst.components.fwd_in_pdt_com_world_map_tile_sys:Add_Leave_Event_Fn_To_Tile_XY(i,j,player_leave_fn)
                        end
                    end









            --------------------------------------------------------------------------------------------------------------------------
        end)
    end
)