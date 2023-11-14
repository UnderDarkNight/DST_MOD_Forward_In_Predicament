------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 任务卷轴的HUD
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_task_scrolls.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_task_scrolls.xml"),
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_task_scroll_base.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_task_scroll_base.xml"),
   
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


    function self:fwd_in_pdt_task_scroll_widget_open(inst,cmd_table)
        ----------------------------------------------------------------
            if inst == nil then
                return
            end
            cmd_table = cmd_table or {}
            local task_content_atlas = cmd_table.atlas or "images/ui_images/fwd_in_pdt_task_scrolls.xml"
            local task_content_image = cmd_table.image or "fwd_in_pdt_task_scroll__rumstick.tex"
            local task_content_x = cmd_table.x or 0
            local task_content_y = cmd_table.y or 0

        ----------------------------------------------------------------
            local root = self:AddChild(Screen())
            self.fwd_in_pdt_task_scroll_widget = root
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
            background:SetTexture("images/ui_images/fwd_in_pdt_task_scroll_base.xml","background.tex")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
            local task_content = root:AddChild(Image())
            task_content:SetTexture(task_content_atlas,task_content_image)
            task_content:SetPosition(task_content_x,task_content_y)
            task_content:Show()
            task_content:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
        --- 关闭按钮
            local close_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_task_scroll_base.xml",
                "close_button.tex",
                "close_button.tex",
                "close_button.tex",
                "close_button.tex",
                "close_button.tex"
            ))
            close_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            close_button:SetPosition(300,150)
            -- close_button:SetOnDown(function()
            --     hud:fwd_in_pdt_task_scroll_widget_close()
            -- end)
            close_button.__old_fwd_in_pdt_OnMouseButton = close_button.OnMouseButton
            close_button.OnMouseButton = function(self,button,down,x,y)
                local ret = self:__old_fwd_in_pdt_OnMouseButton(button,down,x,y)
                if button == MOUSEBUTTON_LEFT and down == false then
                    ret = true
                    hud:fwd_in_pdt_task_scroll_widget_close()
                end
                return ret
            end
        ----------------------------------------------------------------
        --- 完成按钮
            local finish_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_task_scroll_base.xml",
                "finish_button.tex",
                "finish_button.tex",
                "finish_button.tex",
                "finish_button.tex",
                "finish_button.tex"
            ))
            finish_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            finish_button:SetPosition(300,-150)
            -- close_button:SetOnDown(function()
            --     hud:fwd_in_pdt_task_scroll_widget_close()
            -- end)
            finish_button.__old_fwd_in_pdt_OnMouseButton = finish_button.OnMouseButton
            finish_button.OnMouseButton = function(self,button,down,x,y)
                local ret = self:__old_fwd_in_pdt_OnMouseButton(button,down,x,y)
                if button == MOUSEBUTTON_LEFT and down == false then
                    ret = true
                    ------------------------------------------------                    
                        local com = inst.replica.fwd_in_pdt_com_task_scroll or inst.replica._.fwd_in_pdt_com_task_scroll
                        com:FinishButtonClick(ThePlayer)
                    ------------------------------------------------
                    hud:fwd_in_pdt_task_scroll_widget_close()
                end
                return ret
            end
        ----------------------------------------------------------------
        ----- 锁住角色移动操作
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_task_scroll_widget_close()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end

    function self:fwd_in_pdt_task_scroll_widget_close()
        if self.fwd_in_pdt_task_scroll_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_task_scroll_widget)
            self.fwd_in_pdt_task_scroll_widget:Kill()
            self.fwd_in_pdt_task_scroll_widget = nil
        end
    end


end)