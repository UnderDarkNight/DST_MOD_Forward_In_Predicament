------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 诊断单的 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Widget = require "widgets/widget"
local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"


local Screen = require "widgets/screen"
-- local AnimButton = require "widgets/animbutton"
-- local ImageButton = require "widgets/imagebutton"
-- local Menu = require "widgets/menu"
-- local Text = require "widgets/text"
-- local TEMPLATES = require "widgets/redux/templates"

local ShopButton = require("widgets/01_fwd_in_pdt_shop_button")
AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0,function()
        if inst.HUD then

            inst:ListenForEvent("fwd_in_pdt_client_event.shop_click",function(_,prefab)
                -- print("client shop widget select",prefab)
                inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.shop.buy",prefab)
            end)
            inst:ListenForEvent("fwd_in_pdt_client_event.shop_close",function()
                inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.shop.close")                
            end)

        end
    end)
end)
AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self



    function self:fwd_in_pdt_shop_open(cmd_table,trade_back_flag)
       

        if self.fwd_in_pdt_shop_widget ~= nil then
            self.fwd_in_pdt_shop_widget:Kill()
        end
        local root = self:AddChild(Screen())
        self.fwd_in_pdt_shop_widget = root

        ----------------------------------------------------------------
        local main_scale_num = 0.6
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -------- 添加主背景 
            local background = root:AddChild(UIAnim())
            root.background = background
            background:GetAnimState():SetBuild("fwd_in_pdt_hud_shop_widget")
            background:GetAnimState():SetBank("fwd_in_pdt_hud_shop_widget")
            local temp_names = {"background_1","background_2","background_3","background_5"}  --- 饥荒引擎无法加载第四张图，暂时不想管
            local background_anim_name = temp_names[math.random(4)]
            background:GetAnimState():PlayAnimation(background_anim_name)
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)


        ----------------------------------------------------------------

            local function add_item_button(x,y,item_cmd_table)
                if item_cmd_table and item_cmd_table.image and item_cmd_table.prefab then
                    local temp_button = root:AddChild(ShopButton(item_cmd_table,trade_back_flag))
                    temp_button:SetPosition(x,y)
                    temp_button:Show()
                    temp_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
                    temp_button:SetOnDown(function()
                        ThePlayer:PushEvent("fwd_in_pdt_client_event.shop_click",item_cmd_table.prefab)
                    end)
                end
            end

            local start_x,start_y = -300,120
            local delta_x,delta_y = 150,-130
            
            local locations = {
                Vector3(start_x,start_y,0)                ,  Vector3(start_x + 1*delta_x, start_y,0) ,Vector3(start_x + 2*delta_x, start_y,0) ,Vector3(start_x + 3*delta_x, start_y,0)      ,Vector3(start_x + 4*delta_x, start_y,0)    ,
                Vector3(start_x,start_y + delta_y,0)      ,  Vector3(start_x + 1*delta_x, start_y + delta_y,0) ,Vector3(start_x + 2*delta_x, start_y + delta_y,0) ,Vector3(start_x + 3*delta_x, start_y + delta_y,0)      ,Vector3(start_x + 4*delta_x, start_y + delta_y,0)    ,
                Vector3(start_x,start_y + 2* delta_y,0)   ,  Vector3(start_x + 1*delta_x, start_y + 2*delta_y,0) ,Vector3(start_x + 2*delta_x, start_y + 2*delta_y,0) ,Vector3(start_x + 3*delta_x, start_y + 2*delta_y,0)      ,Vector3(start_x + 4*delta_x, start_y + 2*delta_y,0)    ,
            }

            for k, pt in pairs(locations) do
                add_item_button(pt.x,pt.y,cmd_table[k])
            end

        ----------------------------------------------------------------
            ----- 锁住角色移动操作
            -- theCloseButton:MoveToFront()
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_shop_close()
                end
                if down and control == CONTROL_MOVE_UP or control == CONTROL_MOVE_DOWN or control == CONTROL_MOVE_LEFT or control == CONTROL_MOVE_RIGHT then
                    hud:fwd_in_pdt_shop_close()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end

    function self:fwd_in_pdt_shop_close()
        if self.fwd_in_pdt_shop_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_shop_widget)
            self.fwd_in_pdt_shop_widget:Kill()
            self.fwd_in_pdt_shop_widget = nil
        end
        ThePlayer:PushEvent("fwd_in_pdt_client_event.shop_close")
    end


end)