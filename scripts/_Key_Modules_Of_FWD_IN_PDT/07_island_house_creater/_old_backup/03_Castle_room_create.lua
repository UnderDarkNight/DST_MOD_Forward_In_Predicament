-- ----------------------------------------
-- ------ 创建房间用
-- ------ 房间地皮 5x5 足够了
-- ------ 使用  01_island_creater.lua 创建
 
-- ----------------------------------------
-- --- 房间要求 ：
-- --- 已完成：防雷,防鸟
-- --- 未完成：防雨,防雪,地面防雪
-- --- 浪声音处理 ambientsound.lua 组件： dontstarve/AMB/waves    dontstarve/AMB/chess   dontstarve/AMB/rain	
-- ----------------------------------------
-- --- 虚空海 的 tile 为 65535
--     --- 洞穴里的虚空tile 为 1
--     ---  201 ~ 247 都是海洋
--     --- 浅海 tile  201
--     --- 中海 tile  203
--     --- 深海 tile  204
--     --- 其他  205 
--     --- API   IsOceanTile(tile)
--     --- 牛毛地毯  12
--     --- 棋盘地毯  11
-- ----------------------------------------

-- AddPrefabPostInit(
--     "world",
--     function(inst)

--         if inst:HasTag("cave") then
--             return
--         end

--         if not inst:HasTag("cave") then
--             return
--         end


--         if not TheWorld.ismastersim then
--             return
--         end


--         if inst.components.fwd_in_pdt_data == nil then
--             inst:AddComponent("fwd_in_pdt_data")
--         end
--         if inst.components.fwd_in_pdt_func == nil then
--             inst:AddComponent("fwd_in_pdt_func"):Init(TUNING["Forward_In_Predicament.World_Com_Func"])  
--         end        
        
--         ----------------------------------------------------------------------------------------------------------------
--         inst:DoTaskInTime(0,function()  --------- 用该方案创建 需要 延时,不然会报错
            
--                         ----------------------------------------------------------------------------------------------------------------
--                         ----- 创建 2 楼
--                         local pt_2 = inst.components.fwd_in_pdt_func:Get_New_House_Point()
--                         if pt_2 == nil then
--                             print("error : Create Castle Room Error")
--                             return
--                         else
--                             print("Castle Room PT",pt_2)
--                         end
                        
--                         SpawnPrefab("fwd_in_pdt_room_creater"):PushEvent("Set",{
--                             pt = pt_2,
--                             width = 5,
--                             height = 6,
--                             data = {
--                                 11,11,11,11,11,
--                                 11,11,11,11,11,
--                                 11,11,11,11,11,
--                                 11,11,11,11,11,
--                                 11,11,11,11,11,
--                                 00,00,12,00,00
--                             },
--                             ents = {
--                                 [1] = {
--                                     data = {
--                                         11,11,11,11,11,
--                                         11,11,11,11,11,
--                                         11,11,01,11,11,
--                                         11,11,11,11,11,
--                                         11,11,11,11,11,
--                                         00,00,12,00,00
--                                     },
--                                     fns = {
                                        
--                                         [1] = function(pt)
--                                             SpawnPrefab("fwd_in_pdt_room_background").Transform:SetPosition(pt.x, 0, pt.z)
--                                         end,
--                                         [2] = function(pt)
--                                                 -- SpawnPrefab("sentryward").Transform:SetPosition(pt.x, 0, pt.z)
--                                         end,
--                                         [12] = function(pt)
--                                             SpawnPrefab("sentryward").Transform:SetPosition(pt.x, 0, pt.z)
--                                         end,
--                                     }
--                                 }
--                             },

--                             mind_fn = function(pt)
--                                 SpawnPrefab("sentryward").Transform:SetPosition(pt.x, 0, pt.z)                                
--                             end,
--                         })
--                         ----------------------------------------------------------------------------------------------------------------
--         end)
--         ----------------------------------------------------------------------------------------------------------------
--     end
-- )