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

    ----------------------------------------------------------------------------------------------------------------
    --- 路灯灯光调试
            local ents = TheSim:FindEntities(x, y, z, 50, {"fwd_in_pdt_building_banner_light"}, nil, nil)
            for k, inst in pairs(ents) do
                if inst then
                    inst.Light:SetIntensity(0.5)		-- 强度
                    inst.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
                    inst.Light:SetFalloff(1)		-- 下降梯度
                    inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)

                end
            end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))
