local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------    ----------------------------------------------------------------------------------------------------------------
    --- 洞穴里的虚空tile 为 1
    ---  201 ~ 247 都是海洋
    --- 浅海 tile  201
    --- 中海 tile  203
    --- 深海 tile  204
    --- 其他  205 
    --- API   IsOceanTile(tile)
    ---- 一个地皮 4X4 距离

    -- if not ThePlayer:HasTag("map_test") then
    --     TheCamera:SetMaxDistance(100)
    --     TheCamera.fov = 50
        -- Walk_in_sea_ON(ThePlayer)
    --     ThePlayer:AddTag("map_test")
    --     return
    -- end
    -- Walk_in_sea_OFF(ThePlayer)
    -- print("player",x,z)
    -- local map_w,map_h = TheWorld.Map:GetSize()
    -- print("map",map_w,map_h)
    -- local mid_tile_x , mid_tile_y = TheWorld.Map:GetTileCoordsAtPoint(x,0,z)
    -- print("tile",mid_tile_x,mid_tile_y)

    -- print("current tile ",TheWorld.Map:GetTileAtPoint(x,y,z))

    -- print("current tile ",TheWorld.Map:GetTileAtPoint(ThePlayer.Transform:GetWorldPosition()))
    -- TheWorld.Map:SetTile(mid_tile_x,mid_tile_y,4)

    -- ThePlayer.Transform:SetPosition(-14000, 0, -14000)
    -- print("Ocean Tile :",IsOceanTile(TheWorld.Map:GetTileAtPoint(x,y,z)))
    -- ThePlayer.Transform:SetPosition(0, 0, 0)
    -- 
        -- local ent = TheSim:FindFirstEntityWithTag("fwd_in_pdt__special_island.gateway")
        -- if ent then
        --     ThePlayer.Transform:SetPosition(ent.Transform:GetWorldPosition())
        -- end

        -- ThePlayer.components.fwd_in_pdt_func:TheCamera_SetFov(60)

        -- for k, v in pairs(TheWorld.topology.nodes) do
        --     print(k,v)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 洞穴穿越树木 测试
        -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_mini_portal_door")
        -- -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt__special_island.gateway2")
        -- -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt__rooms_quirky_red_tree")
        -- if inst then
        --     -- ThePlayer.Transform:SetPosition(inst.Transform:GetWorldPosition())
        --     inst:PushEvent("active",ThePlayer)

        -- end
    ----------------------------------------------------------------------------------------------------------------
    -- ThePlayer.Transform:SetPosition(-14000, 0, -14000)
    -- ThePlayer.Transform:SetPosition(0, 0, 0)
    -- x,y,z = ThePlayer.Transform:GetWorldPosition()  
    -- local mid_tile_x , mid_tile_z = TheWorld.Map:GetTileCoordsAtPoint(0, 0, 0)
    -- print(mid_tile_x , mid_tile_z)
    -- TheWorld.Map:SetTile(mid_tile_x,mid_tile_z,12)
    -- local xx = 2
    -- while xx < 4900 do        
    --     local mid_tile_x , mid_tile_z = TheWorld.Map:GetTileCoordsAtPoint(xx,0,2)
    --     print(mid_tile_x,mid_tile_z)
    --     TheWorld.Map:SetTile(mid_tile_x,mid_tile_z,12)
    --     xx = xx + 4
    -- end
    
    ----------------------------------------------------------------------------------------------------------------
    -------- 视野扩大
    -- TheCamera:SetMaxDistance(100)
    -- TheCamera.fov = 50
    ----------------------------------------------------------------------------------------------------------------
    ---- 礼物盒
        -- local gift = SpawnPrefab("fwd_in_pdt_gift_pack")
        -- gift:PushEvent("Set",{
        --         items = {
        --                    {"log",20},
        --                    {"goldnugget",100}
        --          },
        --         --  name = "FFFFFFFFFFFFFFFFFF",
        --         --  inspect_str = "666666666666666666666666666",
        --          skin_num = 5,   -- 1~6
        -- })
        -- ThePlayer.components.inventory:GiveItem(gift)

    ----------------------------------------------------------------------------------------------------------------
    ---- LongUpdate
    -- local inst = SpawnPrefab("meat")
    -- print(inst.components.dryable.drytime)
    -- inst:Remove()

    
    ----------------------------------------------------------------------------------------------------------------
    ----- 声音组件测试
        -- local sounds = {
        --     -- "summerevent/carnival_games/feedchicks/station/endbell",
        --     -- "summerevent/carnival_games/memory/spawn_rewards_endbell",
        --     "dontstarve/HUD/recipe_ready",
        --     "dontstarve/HUD/collect_newitem",
        -- }
        -- ThePlayer.components.fwd_in_pdt_func:Block_Client_Sound(sounds)
        -- ThePlayer.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/endbell")
        -- ThePlayer.SoundEmitter:PlaySound("dontstarve/HUD/sanity_down")
    
    ----------------------------------------------------------------------------------------------------------------
    --- 自制钓鱼测试
        -- ThePlayer.sg:GoToState("catchfish","fish01")
        -- print(ThePlayer.AnimState.OverrideSymbol__old_fwd_in_pdt)
        -- ThePlayer.sg:GoToState("fishing_nibble")
        -- ThePlayer.sg:GoToState("fishing_strain")
    ----------------------------------------------------------------------------------------------------------------
    --- 钓鱼HUD测试
        -- ThePlayer.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_widgets.fishing.start",{
        --     hook_times = 4,     --- 正确次数
        --     wrong_times = 3,    --- 错误次数
        --     speed_mult = 3,     --- 旋转速度
        -- })
    ----------------------------------------------------------------------------------------------------------------
    --- RPC 测试
    ----------------------------------------------------------------------------------------------------------------
    ---- 聊天框HUD测试
        -- local cmd_table = {
        --     m_colour = {255/255,100/255,100/255} ,
        --     s_colour = {0/255,255/255,0},
        --     icondata = "fwd_in_pdt_chat_message_icon_test",
        --     message = "测试 测试 测试 测试 测试",
        --     sender_name = "那谁谁谁",

        -- }        

        -- -- -- ThePlayer.components.fwd_in_pdt_func:RPC_PushEvent("fwd_in_pdt_event.whisper",cmd_table)
        -- ThePlayer.components.fwd_in_pdt_func:Wisper(cmd_table)
    ----------------------------------------------------------------------------------------------------------------
    ----- 
    ----------------------------------------------------------------------------------------------------------------
    -- 重置世界的命令
        -- ThePlayer:ListenForEvent("death",function()
        --     ThePlayer:DoTaskInTime(10,function()
        --         TheNet:SendWorldResetRequestToServer()
        --     end)
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------
    --- 皮肤相关的命令
        -- ThePlayer.components.fwd_in_pdt_com_skins:Unlock_Skins({
        --     fwd_in_pdt_skin_test_item = {"fwd_in_pdt_skin_test_item_red","fwd_in_pdt_skin_test_item_yellow"},
        --     fwd_in_pdt_skin_test_building = {"fwd_in_pdt_skin_test_building_glass","fwd_in_pdt_skin_test_building_night"}
        -- })
        -- print(PREFAB_SKINS_IDS["fwd_in_pdt_skin_test_item"]["fwd_in_pdt_skin_test_item_red"])
        -- print(ThePlayer.components.fwd_in_pdt_com_skins._tool__prefab_skins["fwd_in_pdt_skin_test_item"][1])

        -- ThePlayer.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin({
        --     ["fwd_in_pdt_building_mock_wall_grass"] = {"fwd_in_pdt_building_mock_wall_grass_monkeytail"}
        -- })
        -- for k, v in pairs(ThePlayer.HUD.controls.craftingmenu) do
        --     print(k,v)
        -- end
        -- local skin_cmd_table = ThePlayer.components.fwd_in_pdt_func:SkinAPI__Get_Random_Locked_Skin(2) or {}
        -- ThePlayer.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(skin_cmd_table)
    ----------------------------------------------------------------------------------------------------------------
        -- local ents = TheSim:FindEntities(x, y, z, 5, {"fwd_in_pdt_skin_test_item"})
        -- for k, inst in pairs(ents) do
        --     inst.components.fwd_in_pdt_com_skins:Do_Mirror()
        -- end
    ----------------------------------------------------------------------------------------------------------------
        -- ThePlayer.components.fwd_in_pdt_func:Add_Death_Announce("6666666666666666")
    ----------------------------------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------------------
    --- 跨存档数据测试/URL测试
        -- ThePlayer.components.fwd_in_pdt_func:Set_Cross_Archived_Data("fwd_in_pdt_cd_key","777777")
        -- local ret = ThePlayer.components.fwd_in_pdt_func:Get_Cross_Archived_Data("fwd_in_pdt_cd_key")
        -- print(ret)
        -- ThePlayer:DoTaskInTime(5,function()
        --     VisitURL("http://forums.kleientertainment.com/forums/forum/73-dont-starve-together/")
        -- end)

    ----------------------------------------------------------------------------------------------------------------
    ---- 测试资源刷新器
        -- SpawnPrefab("fwd_in_pdt_natural_resources_spawner"):PushEvent("Set",{
        --         pt = Vector3(x,0,z),
        --         day = 0,
        --     --     season = "summer" , -- nil,  --- -- TheWorld.state.season == "winter"  -- autumn , winter , spring , summer
        --         prefab = "berrybush",
        --     --     tile = nil,    -- tile num or table      --- 地皮的数字，或者数字table
        --     --     ignore_tile = nil , -- 需要屏蔽的地皮 tile num or table      --- 地皮的数字，或者数字table
        --         range = 10,   -- or nil
        -- })
    ----------------------------------------------------------------------------------------------------------------
    --- 测试地图扫描
        -- for k, v in pairs(getmetatable(TheWorld.Map).__index) do
        -- -- for k, v in pairs(Ents) do
        --     print(k,v)
        -- end
        -- print(TheWorld.Map:GetTileAtPoint(ConsoleWorldPosition():Get()))
    ----------------------------------------------------------------------------------------------------------------
    --- 测试获取MOD版本
            -- local modinfo = KnownModIndex:GetModInfo(TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE_MODNAME) or {}
            -- for k, v in pairs(modinfo) do
            --     print(k,v)
            -- end
            -- for k, v in pairs(ThePlayer.replica.fwd_in_pdt_func) do
            --     print(k,v)
            --     -- print(type(k),type(v))
            -- end
            -- ThePlayer.replica.fwd_in_pdt_func:Init("666655++")
    ----------------------------------------------------------------------------------------------------------------
    --- 测试replica 的init
            -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt_test_tree")
            -- if inst then
            --     print(inst.replica.fwd_in_pdt_func.RPC_PushEvent)
            -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 测试图标添加特效
                -- local ents = TheSim:FindEntities(x, y, z, 10, {"fwd_in_pdt_test_amulet"}, nil, nil)
                -- for k, v in pairs(ents) do
                --     if v then
                --         -- v.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Clear()

                --         -- v.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                --         --     bank = "archive_lockbox_player_fx",
                --         --     build = "archive_lockbox_player_fx",
                --         --     anim = "activation"
                --         -- })
                --         -- v.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                --         --     bank = "inventory_fx_shadow",
                --         --     build = "inventory_fx_shadow",
                --         --     anim = "idle"
                --         -- })

                        
                --         -- ThePlayer:DoTaskInTime(0.5,function()
                --         --     v.components.fwd_in_pdt_func:Replica_Simple_PushEvent("imagechange")
                --         -- end)
                --         -- v:PushEvent("imagechange")

                --         v.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_SetDisplay(true)

                --     end                    
                -- end
                -- -- print(ThePlayer.HUD.Refresh)
                -- -- for k, v in pairs(ThePlayer.HUD.children) do
                -- --     print(k,v)
                -- -- end
    ----------------------------------------------------------------------------------------------------------------
    --- prefab 文件路径自动获取
                    -- local temp = debug.getinfo(1)
                    -- for k, v in pairs(temp) do
                    --     print(k,v)
                    -- end
                -- local function sum(a, b)
                --     return a + b
                -- end
                
                -- local info = debug.getinfo(sum)
                
                -- for k,v in pairs(info) do
                --         print(k,v, ':', info[k])
                -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 是否有洞穴
        -- local temp = Shard_GetConnectedShards()
        -- print(#temp)
        -- for k, v in pairs(temp) do
        --     print("+++",k,v)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---- 服务器镜头控制
            -- ThePlayer.components.fwd_in_pdt_func:TheCamera_SetHeadingTarget(90)
            -- ThePlayer.components.fwd_in_pdt_func:TheCamera_SetFov()
            -- ThePlayer.components.fwd_in_pdt_func:TheCamera_SetDefault()
            -- print(ThePlayer.components.fwd_in_pdt_func:TheCamera_GetFov())
    ----------------------------------------------------------------------------------------------------------------
    ---- 客制化拾取声音
            -- ThePlayer.components.fwd_in_pdt_func:SetPickSound("wood","aqol/new_test/gem")
    ----------------------------------------------------------------------------------------------------------------
    ---- 多外观NPC测试
            -- ThePlayer.AnimState:SetClientSideBuildOverrideFlag("test_display_npc_flag",true)
    ----------------------------------------------------------------------------------------------------------------
    ---- RECIPE FX
            -- SpawnPrefab("fwd_in_pdt_fx_recipe_star"):PushEvent("Set",{
            --     pt = Vector3(x,y,z)
            -- })
            -- SpawnPrefab("fwd_in_pdt_fx_recipe_function"):PushEvent("Set",{
            --     pt = Vector3(x,y,z)
            -- })
    ----------------------------------------------------------------------------------------------------------------
    ----- pre dodelta
                -- ThePlayer.components.fwd_in_pdt_func:PreDoDelta_Add_Health_Fn(function(com,num,sound,...)                    
                --     if num < 0 then
                --         num = -1
                --         print("dodelta +++")
                --     end
                --     return num,sound,...
                -- end)
    ----------------------------------------------------------------------------------------------------------------
    ----- 复活通告
                -- ThePlayer.components.fwd_in_pdt_func:Add_Resurrection_Announce("666666666666",30)
    ----------------------------------------------------------------------------------------------------------------
    ----- SG 排查
                    -- ThePlayer:ListenForEvent("newstate",function(_,_table)
                    --     if _table and _table.statename then
                    --         print("newstate",_table.statename)
                    --     end
                    -- end)
    ----------------------------------------------------------------------------------------------------------------
    ---- cd-key
            -- for i = 1, 50, 1 do
            --     ThePlayer.components.fwd_in_pdt_func:VIP_CreateCDKEY()                            
            -- end

            -- local data_from_world = TheWorld.components.fwd_in_pdt_func:Get("all_player_cd_keys") or {}
            -- data_from_world["userid"] = "FVIP-35J3-9PP7-1Z4F"
            -- TheWorld.components.fwd_in_pdt_func:Set("all_player_cd_keys",data_from_world)
            

            -- -- ThePlayer.components.fwd_in_pdt_func:VIP_Start_Check_CDKEY("FVIP-957O-8KTR-R5TT",true)
            -- for k, v in pairs(data_from_world) do
            --     print(k,v)
            -- end
            -- ThePlayer.components.fwd_in_pdt_func:Set_Cross_Archived_Data("tts",33)
            -- print(ThePlayer.components.fwd_in_pdt_func:Get_Cross_Archived_Data("tts"))
            -- print(ThePlayer.components.fwd_in_pdt_func:VIP_Get_CDKEY())

            -- FVIP-A1H1-KY6V-LT02
            -- ThePlayer.components.fwd_in_pdt_func:VIP_Player_Input_Key("FVIP-A1H1-KY6V-LT02")
            -- print(ThePlayer.components.fwd_in_pdt_func:IsVIP())

    ----------------------------------------------------------------------------------------------------------------
    ------ cd-key 生成
            -- local ret_keys = {}
            -- local num = 0
            -- for i = 1, 30000, 1 do
            --     local temp_key = ThePlayer.components.fwd_in_pdt_func:VIP_CreateCDKEY()
            --     if temp_key and ThePlayer.components.fwd_in_pdt_func:VIP_Start_Check_CDKEY(temp_key) and ret_keys[temp_key] ~= true then
            --         ret_keys[temp_key] = true
            --         num = num + 1
            --     end
            -- end
            -- print("keys",num)
            -- local file = io.open("fvip_keys.txt","w")
            -- for key, v in pairs(ret_keys) do
            --     if key and v then
            --         file:write(key)
            --         file:write('\n')
            --     end
            -- end
            -- file:close()
    ----------------------------------------------------------------------------------------------------------------
    --- 货币系统排查
            -- print( ThePlayer.replica.inventory:Has("fwd_in_pdt_item_jade_coin_green",100,true) )

        -- local num = ThePlayer.components.fwd_in_pdt_func:Jade_Coin__GetAllNum()
        -- print(num)

        -- local succeed_flag = ThePlayer.components.fwd_in_pdt_func:Jade_Coin__Spend(50)
        -- print(succeed_flag)
    ----------------------------------------------------------------------------------------------------------------
    --- 体质值系统调试
        -- local num,p = ThePlayer.replica.fwd_in_pdt_wellness:Get_Wellness()
        -- print(num,p)
        -- ThePlayer.components.fwd_in_pdt_wellness:All_Datas_Reset()
        -- print( ThePlayer.components.fwd_in_pdt_wellness:GetCurrent_Wellness())
        -- print( ThePlayer.components.fwd_in_pdt_wellness:GetCurrent())
        -- ThePlayer.components.fwd_in_pdt_wellness:DoDelta_Wellness(0.5)
        -- ThePlayer.components.fwd_in_pdt_wellness:Refresh()

        -- ThePlayer.components.fwd_in_pdt_wellness:External_DoDelta_Wellness(5)

        -- ThePlayer.components.fwd_in_pdt_wellness:Refresh()

        -- ThePlayer.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,0.5,ThePlayer)
        -- ThePlayer.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,ThePlayer)
        -- ThePlayer.components.health:DeltaPenalty(0.2)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))
