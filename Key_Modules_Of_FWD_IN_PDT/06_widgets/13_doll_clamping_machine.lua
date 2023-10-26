------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 娃娃机的 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.xml"),
   
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Widget = require "widgets/widget"
local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"


local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
-- local Menu = require "widgets/menu"
-- local Text = require "widgets/text"
-- local TEMPLATES = require "widgets/redux/templates"

-- AddPlayerPostInit(function(inst)
--     inst:DoTaskInTime(0,function()
--         if inst.HUD then
--             inst:ListenForEvent("fwd_in_pdt_client_event.shop_click",function(_,prefab)
--                 -- print("client shop widget select",prefab)
--                 inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.shop.buy",prefab)
--             end)
--             inst:ListenForEvent("fwd_in_pdt_client_event.shop_close",function()
--                 inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.shop.close")                
--             end)
--         end
--     end)
-- end)
AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self



    function self:fwd_in_pdt_doll_clamping_machine_open(cmd_table,trade_back_flag)
       

        if self.fwd_in_pdt_doll_clamping_machine_widget ~= nil then
            self.fwd_in_pdt_doll_clamping_machine_widget:Kill()
        end
        if self.fwd_in_pdt_doll_clamping_machine_widget_inst then
            self.fwd_in_pdt_doll_clamping_machine_widget_inst:Remove()
        end
        local root = self:AddChild(Screen())
        self.fwd_in_pdt_doll_clamping_machine_widget = root

        self.fwd_in_pdt_doll_clamping_machine_widget_inst = CreateEntity()
        ----------------------------------------------------------------
        local main_scale_num = 0.8
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -------- 添加主背景 
            local background = root:AddChild(Image())
            root.background = background
            background:SetTexture("images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.xml","background.tex")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
            --- 按钮test
            -- local button_test = root:AddChild(ImageButton(
            --     "images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.xml",
            --     "ragdoll_2.tex",
            --     "ragdoll_2.tex",
            --     "ragdoll_2.tex",
            --     "ragdoll_2.tex",
            --     "ragdoll_2.tex"
            -- ))
            -- button_test:SetScale(main_scale_num,main_scale_num,main_scale_num)
            -- button_test:SetPosition(0,0)
        ----------------------------------------------------------------
            local function display_selection(image_name)
                local display = root:AddChild(Image())
                display:SetTexture("images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.xml",image_name)
                display:SetPosition(0,0)
                display:Show()
                local fix_scale = 2.5
                local delta_scale = 0.1
                local scale_down = false
                display:SetScale(main_scale_num*fix_scale,main_scale_num*fix_scale,main_scale_num*fix_scale)
                local inst = self.fwd_in_pdt_doll_clamping_machine_widget_inst
                inst:DoPeriodicTask(FRAMES,function()
                    if fix_scale > 3.5 then
                        scale_down = true
                    end
                    if fix_scale < 2.5 then
                        scale_down = false
                    end

                    if not scale_down then
                        fix_scale = fix_scale + delta_scale
                    else
                        fix_scale = fix_scale - delta_scale
                    end

                    display:SetScale(main_scale_num*fix_scale,main_scale_num*fix_scale,main_scale_num*fix_scale)
                end)
            end
        ----------------------------------------------------------------
            local deta_x,delta_y = 160,160
            local locations = {
                Vector3(-deta_x,10 + delta_y,0) ,Vector3(0,10 + delta_y,0), Vector3(deta_x,10 + delta_y,0),
                Vector3(-deta_x,10,0)           ,Vector3(0,10,0)          , Vector3(deta_x,10,0),
                Vector3(-deta_x,10 - delta_y,0) ,Vector3(0,10 - delta_y,0), Vector3(deta_x,10 - delta_y,0),
            }
            local buttons = {}
            local function create_button_at_point(pt)
                local image_name = "ragdoll_"..tostring(math.random(9)) .. ".tex"
                local temp_button = root:AddChild(ImageButton(
                    "images/ui_images/fwd_in_pdt_building_doll_clamping_machine_widget.xml",
                    image_name,
                    image_name,
                    image_name,
                    image_name,
                    image_name
                ))
                temp_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
                temp_button:SetPosition(pt.x,pt.y)
                temp_button.__image = image_name
                table.insert(buttons,temp_button)
                temp_button:SetOnDown(function()
                    for k, v in pairs(buttons) do
                        v:Disable()
                    end
                    display_selection(image_name)
                    ThePlayer:DoTaskInTime(2,function()
                        hud:fwd_in_pdt_doll_clamping_machine_close()
                        ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("doll_clamping_machine_selected")
                    end)
                end)

            end
            for i, pt in pairs(locations) do
                create_button_at_point(pt)
            end
        ----------------------------------------------------------------
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_doll_clamping_machine_close()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end

    function self:fwd_in_pdt_doll_clamping_machine_close()
        if self.fwd_in_pdt_doll_clamping_machine_widget_inst then
            self.fwd_in_pdt_doll_clamping_machine_widget_inst:Remove()
            self.fwd_in_pdt_doll_clamping_machine_widget_inst = nil
        end
        if self.fwd_in_pdt_doll_clamping_machine_widget then
            self.fwd_in_pdt_doll_clamping_machine_widget:Kill()
            self.fwd_in_pdt_doll_clamping_machine_widget = nil
        end
    end


end)