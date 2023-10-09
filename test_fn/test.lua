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
        -- print(TheWorld.Map:GetTileCoordsAtPoint(ThePlayer.Transform:GetWorldPosition()))
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
    ----------------------------------------------------------------------------------------------------------------
    --- 体质值系统调试
        -- local num,p = ThePlayer.replica.fwd_in_pdt_wellness:Get_Wellness()
        -- print(num,p)
        -- ThePlayer.components.fwd_in_pdt_wellness:All_Datas_Reset()
        -- print( ThePlayer.components.fwd_in_pdt_wellness:GetCurrent_Wellness())
        -- print( ThePlayer.components.fwd_in_pdt_wellness:GetCurrent())
        -- ThePlayer.components.fwd_in_pdt_wellness:DoDelta_Wellness(-100)
        -- ThePlayer.components.fwd_in_pdt_wellness:Refresh()

        -- ThePlayer.components.fwd_in_pdt_wellness:External_DoDelta_Wellness(5)

        -- ThePlayer.components.fwd_in_pdt_wellness:Refresh()

        -- ThePlayer.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,0.5,ThePlayer)
        -- ThePlayer.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP,ThePlayer)
        -- ThePlayer.components.health:DeltaPenalty(0.2)
        -- ThePlayer.sg:GoToState("fwd_in_pdt_wellness_cough")

        -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_cough")
        -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_cough")

        -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_fever")
        -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_fever")

        -- ThePlayer.components.fwd_in_pdt_wellness.DEBUGGING_MODE = true
    ----------------------------------------------------------------------------------------------------------------
    --- 体质值 HUD 调试
            -- local TheAnim = ThePlayer.HUD.fwd_in_pdt_wellness.wellness_bar:GetAnimState()
            -- TheAnim:SetTime(0)
            -- ThePlayer.HUD.fwd_in_pdt_wellness:HideOhters()
            -- ThePlayer.HUD.fwd_in_pdt_wellness:ShowOhters()
        -- ThePlayer.components.fwd_in_pdt_wellness:HudShowOhters(true)
        -- ThePlayer.components.fwd_in_pdt_wellness:HudShowOhters(false)
            -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_snake_poison")  
            -- ThePlayer.components.fwd_in_pdt_wellness:SetCurrent_Wellness(0)
            -- ThePlayer.components.fwd_in_pdt_wellness:DoDelta_Wellness(-10)
            -- ThePlayer.components.fwd_in_pdt_wellness:DoDelta_Vitamin_C(100)
            -- ThePlayer.components.fwd_in_pdt_wellness:Refresh()
    ----------------------------------------------------------------------------------------------------------------
    --- 路灯灯光调试
            -- local ents = TheSim:FindEntities(x, y, z, 50, {"fwd_in_pdt_building_banner_light"}, nil, nil)
            -- for k, inst in pairs(ents) do
            --     if inst then
            --         inst.Light:SetIntensity(0.5)		-- 强度
            --         inst.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
            --         inst.Light:SetFalloff(1)		-- 下降梯度
            --         inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)

            --     end
            -- end
    ----------------------------------------------------------------------------------------------------------------
            -- ThePlayer.components.fwd_in_pdt_func:TheCamera_ClearTarget()
                
    ----------------------------------------------------------------------------------------------------------------
    --- 青蛙变异测试
                -- local frog = SpawnPrefab("frog")
                -- frog.Transform:SetPosition(x+10, y, z)
                -- frog:PushEvent("fwd_in_pdt_event.start_mutant")
    ----------------------------------------------------------------------------------------------------------------
    --- 书本动作
                -- ThePlayer.AnimState:PlayAnimation("book")
                -- ThePlayer.AnimState:PushAnimation("book")
                -- ThePlayer.AnimState:PlayAnimation("action_uniqueitem_pre")
                -- ThePlayer.AnimState:PushAnimation("peruse", false)
                -- ThePlayer.SoundEmitter:PlaySound("dontstarve/common/book_spell")
                -- ThePlayer.SoundEmitter:PlaySound("wickerbottom_rework/book_spells/upgraded_horticulture")
    ----------------------------------------------------------------------------------------------------------------
    --- 鱼池 container widget 穿插
                -- for k, widget in pairs(ThePlayer.HUD.controls.containers) do
                --     -- print(k,v)
                --     -- for kk, vv in pairs(v) do
                --     --     print(kk,vv)

                --     -- end
                --     local text = widget.__test_str
                --     if text == nil then
                --         text = widget:AddChild(Text(CODEFONT,100,"100.42",{ 255/255 , 255/255 ,255/255 , 1}))
                --         widget.__test_str = text
                --     end
                -- end
                -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt_fish_farm")
                -- if inst then
                --     inst:PushEvent("daily_task_start")
                -- end
    ----------------------------------------------------------------------------------------------------------------
    ---- 诊断单界面测试
                    -- ThePlayer.HUD:fwd_in_pdt_medical_certificate_show()
                -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_snake_poison")
                -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_frog_poison")
                -- -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_spider_poison")
                -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")
                -- -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_cough")
                -- ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_fever")
    ----------------------------------------------------------------------------------------------------------------
    -- 新月
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "full"})
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new" ,iswaxing = true})
    ----------------------------------------------------------------------------------------------------------------
    -- 工作台界面
        -- ThePlayer.HUD:fwd_in_pdt_special_production_formulated_crystal_widget_open()
    ----------------------------------------------------------------------------------------------------------------
    -- sg 监控
                    -- ThePlayer:ListenForEvent("newstate",function(_,_table)
                    --     if _table and _table.statename then
                    --         print("statename",_table.statename)
                    --     end
                    -- end)
    ----------------------------------------------------------------------------------------------------------------
    -- ATM 核心 API 测试
                    -- ThePlayer.components.fwd_in_pdt_func:Jade_Coin__ATM_SaveMoney(30)
                    -- ThePlayer.components.fwd_in_pdt_func:Jade_Coin__ATM_WithdrawMoney(25)
                    -- ThePlayer.HUD:fwd_in_pdt_ad()
    ----------------------------------------------------------------------------------------------------------------
    -- bonestew   fwd_in_pdt_food_mixed_potato_soup
                    -- local cooking = require("cooking")
                    -- local recipes = {}
                    -- for port, temp_recipe in pairs(cooking.recipes) do
                    --     for food_name, _table in pairs(temp_recipe) do
                    --         recipes[food_name] = _table
                    --     end
                    -- end
                    -- local temp = ThePlayer.components.knownfoods:_SmartSearch(recipes["fwd_in_pdt_food_mixed_potato_soup"].test)
                    -- print(temp)
                    -- for k, v in pairs(ThePlayer.components.knownfoods._knownfoods) do
                    --     print(k,v)
                    -- end
    ----------------------------------------------------------------------------------------------------------------
                -- local TileManager = require("tilemanager")
                print(WORLD_TILES[string.upper("fwd_in_pdt_turf_test")])
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))
