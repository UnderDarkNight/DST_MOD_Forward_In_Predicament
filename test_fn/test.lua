--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer:ListenForEvent("newstate",function(_,_table)
        --     print("state",_table and _table.statename)
        -- end)
    ----------------------------------------------------------------------------------------------------------------

    -- miss 测试
                    
                    -- ThePlayer.components.combat:Fwd_In_Pdt_Add_Miss_Check(ThePlayer,function(targ,...)
                    --     print("Miss target",targ)
                    --     SpawnPrefab("fwd_in_pdt_fx_miss"):PushEvent("Set",{
                    --         target = targ,
                    --         speed = 2,
                    --     })
                    --     return true
                    -- end)
                    --  ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_attack_miss")

                    ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_attack_miss")
    ----------------------------------------------------------------------------------------------------------------
    -------
    -- 癫痫测试
        --ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")
        -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")

    ----
        -- local BASE_SCALE = Vector3(0.5,0.5,0.5)
        -- local inst = ThePlayer
        -- inst.body_fx.AnimState:SetScale(0.5,0.5,0.5)
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer.components.freezable:Freeze(10)
        -- ThePlayer.___light___fx:Remove()

        -- SpawnPrefab("fwd_in_pdt_spell_time_stopper"):PushEvent("Set",{
        --     target = ThePlayer,
        --     range = 30,
        --     time = 30,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer:RemoveEventCallback("changearea",ThePlayer.___area_event_fn or function()        end)

        -- ThePlayer.___area_event_fn = function(inst,_table)
        --     -- print(_table,type(_table))
        --     if type(_table) ~= "table" then
        --         return
        --     end
        --     print("+++++++++++++++++++++++++++++")
        --         print(_table.type)
        --         for k, v in pairs(_table.tags) do
        --             print(k,v)
        --         end
        --     print("+++++++++++++++++++++++++++++")

        -- end
        -- ThePlayer:ListenForEvent("changearea",ThePlayer.___area_event_fn)
    ----------------------------------------------------------------------------------------------------------------
    --- 
            -- for k, v in pairs(ThePlayer.replica._.fwd_in_pdt_com_inspectable_spell_caster) do
            --     print(k,v)
            -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- local map_width,map_height = TheWorld.Map:GetSize()
        -- print("map_width",map_width,"map_height",map_height)

        -- local tx, ty = TheWorld.Map:GetTileXYAtPoint(x,y,z)
        -- print(tx,ty)
    ----------------------------------------------------------------------------------------------------------------
    ---- 
        -- ThePlayer:RemoveEventCallback("fwd_in_pdt_event.enter_new_tile",ThePlayer.___test_area_event_fn or function()        end)

        -- ThePlayer.___test_area_event_fn = function(inst,_table)
        --     print("++++++++++++++++++++++++++++")
        --     print("tile : ",_table.tile)
        --     print("TileXY",_table.tx,_table.ty)
        --     local temp_data = TheWorld.components.fwd_in_pdt_com_world_map_tile_sys:Get_Data_By_Tile_XY(_table.tx,_table.ty)
        --     for k, v in pairs(temp_data.tags or {}) do
        --         print("+tag:",v)
        --     end
        --     print("++++++++++++++++++++++++++++")
        -- end
        -- ThePlayer:ListenForEvent("fwd_in_pdt_event.enter_new_tile",ThePlayer.___test_area_event_fn)

    ----------------------------------------------------------------------------------------------------------------
    ----
        -- TheWorld.components.fwd_in_pdt_com_world_map_tile_sys:Add_Tag_To_Tile_By_Point(x,y,z,"test_tag")
        -- TheWorld.components.fwd_in_pdt_com_world_map_tile_sys:Remove_Tag_From_Tile_By_Point(x,y,z,"test_tag")
    ----------------------------------------------------------------------------------------------------------------
        
        -- local ent = TheSim:FindFirstEntityWithTag("fwd_in_pdt__red_tree_island_mid_point")
        -- print("ent",ent)
        -- ThePlayer.Transform:SetPosition(ent.Transform:GetWorldPosition())
    ----------------------------------------------------------------------------------------------------------------
        ThePlayer.SoundEmitter:PlaySound("dontstarve/music/gramaphone_ragtime")
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))