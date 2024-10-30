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
    --- 
        -- ThePlayer:ListenForEvent("newstate",function(_,_table)
        --     local statename = _table and _table.statename
        --     print("++ newstate",statename)
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt_container_tv_box")
        -- inst.AnimState:PlayAnimation("idle",true)
        -- local item = SpawnPrefab("fwd_in_pdt_equipment_vampire_sword")
        -- -- local item = SpawnPrefab("fwd_in_pdt_material_chaotic_cookpot_puzzle_4")
        -- if inst.item then
        --     inst.item:Remove()
        -- end
        -- inst.item = item
        -- inst:AddChild(item)
        -- item:AddTag("NOCLICK")
    	-- item:ReturnToScene()
        -- item:AddTag("outofreach")
        -- if item.Follower == nil then
        --     item.entity:AddFollower()
        -- end
        -- item.Transform:SetPosition(0, 0, 0)
        -- item.Follower:FollowSymbol(inst.GUID, "SWAP_SIGN", 0, 0, 0, true)


        -- -- local test = TheSim:FindFirstEntityWithTag("fwd_in_pdt_material_chaotic_cookpot_puzzles")
        -- -- ThePlayer.Transform:SetPosition(test.Transform:GetWorldPosition())
    ----------------------------------------------------------------------------------------------------------------
    --- 

        -- ThePlayer.__test_fn = function(inst,tar_atlas,tar_image)
        --     local item = nil
        --     for num, temp_item in pairs(inst.components.container.slots) do
        --         if temp_item and temp_item:IsValid() then
        --                 -- local imagename = temp_item.nameoverride or temp_item.components.inventoryitem.imagename or temp_item.prefab
        --                 -- imagename  = string.gsub(imagename,".tex", "") .. ".tex"
        --                 -- local atlasname = temp_item.components.inventoryitem.atlasname or GetInventoryItemAtlas(imagename)
        --                 -- if TheSim:AtlasContains(atlasname, imagename) then
        --                 --     tar_atlas = atlasname
        --                 --     tar_image = imagename
        --                 --     break
        --                 -- end
        --                 item = temp_item
        --                 break
        --         end
        --     end
        --     if item then
        --         local crash_flag,atlas,image = pcall(function()
        --             -- print("+++",item.inv_image_bg)
        --             -- -- local atlas, bgimage, bgatlas
        --             -- -- local image = FunctionOrValue(item.drawimageoverride, item, inst) or (#(item.components.inventoryitem.imagename or "") > 0 and item.components.inventoryitem.imagename) or item.prefab or nil
                    
        --             local imagename = item.nameoverride or item.components.inventoryitem.imagename or item.prefab
        --             local imagename  = string.gsub(imagename,".tex", "") .. ".tex"
        --             local atlasname = item.components.inventoryitem.atlasname or GetInventoryItemAtlas(imagename)
        --             -- print("pre",atlasname)

        --             if TheSim:AtlasContains(atlasname, imagename) then
        --                 --- 官方物品
        --                 print("official item",atlasname, imagename)
        --                 return atlasname,imagename
        --             else
        --                 --- 自定义MOD物品
        --                 atlasname = GetInventoryItemAtlas(imagename)
        --                 atlasname = resolvefilepath_soft(atlasname) --为了兼容mod物品，不然是没有这道工序的
        --                 print("custom item",atlasname, imagename)

        --                 return atlasname,imagename
        --             end

        --             -- print("imagename:",imagename)
        --             -- print("atlasname:",atlasname)

        --             return atlasname,imagename





                    
                


        --         end)
        --         -- print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
        --         -- print("tar_atlas:",tar_atlas)
        --         -- print("tar_image:",tar_image)
        --         -- print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
        --         if not crash_flag then
        --             print("Error : ",atlas)
        --         else
        --             tar_atlas = atlas
        --             tar_image = image
        --         end
        --     end
        --     return tar_atlas,tar_image
        -- end
        -- print(TheSim:AtlasContains("images/inventoryimages3.xml", "fwd_in_pdt_item_orthopedic_water.tex"))
        print(GetInventoryItemAtlas("fwd_in_pdt_item_orthopedic_water.tex"))
    ----------------------------------------------------------------------------------------------------------------
    -- lua 加载路径 测试 使用 gmatch 方法来分割字符串
        -- for path in package.path:gmatch("[^;]+") do
        --     print(path)
        -- end

        -- -- 如果你使用的是 Lua 5.3 或更高版本，可以使用 string.split
        -- if _VERSION >= "Lua 5.3" then
        --     local function split(str, delimiter)
        --         local result = {}
        --         for substr in str:gsub("([^^" .. delimiter .. "]+)"):gmatch("%1") do
        --             table.insert(result, substr)
        --         end
        --         return result
        --     end

        --     local paths = split(package.path, ";")
        --     for _, path in ipairs(paths) do
        --         print(path)
        --     end
        -- else
        --     -- 对于低于 Lua 5.3 的版本，手动实现一个简单的 split 函数
        --     local function split(str, delimiter)
        --         local result = {}
        --         local from = 1
        --         local delim_from = string.find(str, delimiter, from)
        --         while delim_from do
        --             table.insert(result, string.sub(str, from, delim_from - 1))
        --             from = delim_from + 1
        --             delim_from = string.find(str, delimiter, from)
        --         end
        --         if from <= #str then
        --             table.insert(result, string.sub(str, from))
        --         end
        --         return result
        --     end

        --     local paths = split(package.path, ";")
        --     for _, path in ipairs(paths) do
        --         print(path)
        --     end
        -- end
    ----------------------------------------------------------------------------------------------------------------
    --- lua 已经加载素材检测
        -- 遍历 package.loaded 表中的所有键（模块名）
        -- for moduleName, moduleObject in pairs(package.loaded) do
        --     print("+++++++++++++++++++++++++++++++++++")
        --     print("Module Name:", moduleName)
        --     print("Module Object:", moduleObject)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))