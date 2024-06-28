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

                    -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_attack_miss")
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
        -- ThePlayer.SoundEmitter:PlaySound("dontstarve/music/gramaphone_ragtime")
    ----------------------------------------------------------------------------------------------------------------
    -- 读取模块local 测试
            -- local worldmigrator = require("components/worldmigrator")
            --------------------------------------------------------------------------
            -- --- 读取某个 func 内部的 local 变量
            --     local debug_getupvalue = debug.getupvalue
            --     -- 尝试从加载的模块中找到对nextPortalID的引用
            --     for i = 1, math.huge do
            --         local name, value = debug.getupvalue(worldmigrator, i)
            --         if name == "nextPortalID" then
            --             print("Found nextPortalID:", value,i)
            --             break
            --         elseif not name then
            --             break -- 没有更多的上值了
            --         end
            --     end
            --------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------------------
    -- 
        -- print(TheWorld.Map:GetSize())

        -- local temp_size = 1000
        -- TheWorld.Map:SetSize(temp_size,temp_size)
        -- TheWorld:PushEvent("worldmapsetsize", { width = temp_size, height = temp_size, })
        -- TheWorld.Map:SetNavSize(temp_size, temp_size)
    ----------------------------------------------------------------------------------------------------------------
    ---- 鼠标模拟测试
    
        -- -- local mousepos = TheInput:GetScreenPosition()
        -- -- print(mousepos.x, mousepos.y)
       
        -- -- print(TheInput:ControllerAttached())
        -- -- local temp_TheInputProxy = getmetatable(TheInputProxy).__index
        -- -- for k, v in pairs(temp_TheInputProxy) do
        -- --     print(k,v,type(v))
        -- -- end

        -- ----------- 鼠标程序性移动
        --     -- TheInputProxy:SetOSCursorPos(0,0)
        --     -- local mx,my = TheInputProxy:GetOSCursorPos()
        --     -- print(mx,my)
        --     -- ThePlayer:DoTaskInTime(0.1,function()
        --     --     for i = 1, 1000, 1 do
        --     --     TheInput:OnMouseButton(i,true,mx,my)
                    
        --     --     end            
        --     -- end)
        -- ---------- 手柄按钮监听
        --     --[[

        --         CONTROL_MOVE_UP = 5  -- left joystick up
        --         CONTROL_MOVE_DOWN = 6 -- left joystick down
        --         CONTROL_MOVE_LEFT = 7 -- left joystick left
        --         CONTROL_MOVE_RIGHT = 8 -- left joystick right


        --         CONTROL_OPEN_INVENTORY = 45  -- right trigger
        --         CONTROL_OPEN_CRAFTING = 46   -- left trigger
        --         CONTROL_INVENTORY_LEFT = 47 -- right joystick left
        --         CONTROL_INVENTORY_RIGHT = 48 -- right joystick right
        --         CONTROL_INVENTORY_UP = 49 --  right joystick up
        --         CONTROL_INVENTORY_DOWN = 50 -- right joystick down
        --         CONTROL_INVENTORY_EXAMINE = 51 -- d-pad up
        --         CONTROL_INVENTORY_USEONSELF = 52 -- d-pad right
        --         CONTROL_INVENTORY_USEONSCENE = 53 -- d-pad left
        --         CONTROL_INVENTORY_DROP = 54 -- d-pad down
        --         CONTROL_PUTSTACK = 55
        --         CONTROL_CONTROLLER_ATTACK = 56 -- X on xbox controller
        --         CONTROL_CONTROLLER_ACTION = 57 -- A
        --         CONTROL_CONTROLLER_ALTACTION = 58 -- B
        --         CONTROL_USE_ITEM_ON_ITEM = 59
        --     ]]--
        --     -- if ThePlayer._temp_key_handler then
        --     --     ThePlayer._temp_key_handler:Remove()
        --     -- end
        --     -- ThePlayer._temp_key_handler = TheInput:AddGeneralControlHandler(function(key,down)  ------ 30FPS
        --     --     print(key,down)

        --     -- end)
        -- ------------
        --     -- ThePlayer:DoTaskInTime(0.5,function()
        --     --     -- TheInput:OnControl(MOUSEBUTTON_LEFT)

        --     --     local mx,my = TheInputProxy:GetOSCursorPos()
        --     --     print("mouse",mx,my)
        --     --     -- TheInput:OnMouseMove(0,0)
        --     --     TheInput:OnMouseButton(MOUSEBUTTON_LEFT,true,mx,my)
        --     -- end)
        -- ------------- TheFrontEnd
        --     -- for k, v in pairs(TheFrontEnd) do
        --     --     print(k,v,type(v))
        --     -- end
        -- ------------- 虚拟点击 目标 botton
        -- ThePlayer:DoTaskInTime(0.5,function()
        --     local crash_flag,reason = pcall(function()
        --         print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
        --         -- local mousepos = TheInput:GetScreenPosition()

        --         local temp = TheInput:GetHUDEntityUnderMouse()


        --         -- for k, v in pairs(temp.widget) do
        --         --     print(k,v,type(v),tostring(v))
        --         -- end
        --         local temp_widget = temp.widget
        --         local temp_button = nil
        --         while true do
        --             print("current:",temp_widget,"parent:",temp_widget.parent)
        --             if tostring(temp_widget.parent) == "BUTTON" then
        --                 temp_button = temp_widget.parent
        --             end
        --             temp_widget = temp_widget.parent
        --             if temp_widget == nil then
        --                 break
        --             end

        --         end
        --         if temp_button and temp_button.OnControl then
        --             print("button:",temp_button.OnControl)
        --             temp_button:SetControl(MOUSEBUTTON_LEFT)    --- 设置激活按键为XXX
        --             temp_button:OnControl(MOUSEBUTTON_LEFT,true)
        --             temp_button:OnControl(MOUSEBUTTON_LEFT,false)
        --         end
        --         print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
        --     end)

        --     if not crash_flag then
        --         print("Error ")
        --         print(reason)
        --     end
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    -- AddComponentPostInit("lunarthrall_plantspawner",function(self)
    --     local old_FindPlant = self.FindPlant
    --     self.FindPlant = function(self,...)
    --         local origin_ret = old_FindPlant(self,...)
    --         if type(origin_ret) == "table" and origin_ret.Transform then
    --             local x,y,z = origin_ret.Transform:GetWorldPosition()
    --             local ents = TheSim:FindEntities(x,y,z,60,{"___block_tag"})
    --             if #ents > 0 then
    --                 return nil
    --             end
    --         end
    --         return origin_ret
    --     end
    -- end)
    ----------------------------------------------------------------------------------------------------------------
    --- shader 测试
        local pigman = SpawnPrefab("pigman")
        pigman.Transform:SetPosition(x,y,z)
        pigman.AnimState:SetBloomEffectHandle(resolvefilepath("shaders/mod_test_shader.ksh"))
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))