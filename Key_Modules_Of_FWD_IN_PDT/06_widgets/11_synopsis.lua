------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 说明书 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_synopsis.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_synopsis.xml"),
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
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local TEMPLATES = require "widgets/redux/templates"
local TextEdit = require "widgets/textedit"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local page_current_num = 1
local page_max = 9
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0.5,function()
        if ThePlayer and ThePlayer.HUD then
            ThePlayer:ListenForEvent("fwd_in_pdt_event.synopsis_open",function()
                ThePlayer.HUD:fwd_in_pdt_synopsis_open()
            end)
        end
    end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self


    function self:fwd_in_pdt_synopsis_open()
        if self.fwd_in_pdt_synopsis_widget then
            self.fwd_in_pdt_synopsis_widget:Kill()
        end

        local root = self:AddChild(Screen())
        self.fwd_in_pdt_synopsis_widget = root
        ----------------------------------------------------------------
        local main_scale_num = 0.7
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        ----------------------------------------------------------------
        ------ page
            local page = root:AddChild(Image())
            root.page = page
            page:SetTexture("images/ui_images/fwd_in_pdt_synopsis.xml","page_"..tostring(page_current_num)..".tex")
            page:SetPosition(0,0)
            page:Show()
            page:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
        ------ page_num
            local page_num_txt = root:AddChild(Text(NEWFONT_OUTLINE_SMALL,40,tostring(page_current_num).."/"..tostring(page_max),{ 255/255 , 255/255 ,255/255 , 1}))
            page_num_txt:SetPosition(0,-220)
        ----------------------------------------------------------------
        ---- last button
            local last_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_synopsis.xml",
                "button.tex",
                "button2.tex",
                "button2.tex",
                "button2.tex",
                "button2.tex"
            ))
            root.last_button = last_button
            last_button:SetPosition(-340,-200)
            last_button:Show()
            last_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            last_button:SetOnDown(function()
                page_current_num = page_current_num - 1
                if page_current_num <= 0 then
                    page_current_num = page_max
                end
                page_num_txt:SetString(tostring(page_current_num).."/"..tostring(page_max))
                page:SetTexture("images/ui_images/fwd_in_pdt_synopsis.xml","page_"..tostring(page_current_num)..".tex")
            end)
        ----------------------------------------------------------------
        ---- next button
            local next_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_synopsis.xml",
                "button.tex",
                "button2.tex",
                "button2.tex",
                "button2.tex",
                "button2.tex"
            ))
            root.next_button = next_button
            next_button:SetPosition(340,-200)
            next_button:Show()
            next_button:SetScale(-main_scale_num,main_scale_num,main_scale_num)
            next_button:SetOnDown(function()
                page_current_num = page_current_num + 1
                if page_current_num > page_max then
                    page_current_num = 1
                end
                page_num_txt:SetString(tostring(page_current_num).."/"..tostring(page_max))
                page:SetTexture("images/ui_images/fwd_in_pdt_synopsis.xml","page_"..tostring(page_current_num)..".tex")
            end)
        ----------------------------------------------------------------
        ----- 锁住角色移动操作
            -- theCloseButton:MoveToFront()
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_synopsis_close()
                end
                if down and control == CONTROL_MOVE_UP or control == CONTROL_MOVE_DOWN or control == CONTROL_MOVE_LEFT or control == CONTROL_MOVE_RIGHT then
                    hud:fwd_in_pdt_synopsis_close()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end

    function self:fwd_in_pdt_synopsis_close()
        if self.fwd_in_pdt_synopsis_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_synopsis_widget)
            self.fwd_in_pdt_synopsis_widget:Kill()
            self.fwd_in_pdt_synopsis_widget = nil
        end

    end


end)