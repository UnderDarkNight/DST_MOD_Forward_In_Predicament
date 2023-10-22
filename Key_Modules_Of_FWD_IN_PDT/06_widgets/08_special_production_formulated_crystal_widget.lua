------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 说明书 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.tex"),
	Asset("ATLAS", "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.xml"),
    Asset("IMAGE", "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal_recipes.tex"),
	Asset("ATLAS", "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal_recipes.xml"),
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local tex_max_num = 20   --- 最大张数
local current_tex_num = 1   --- 当前张数
local tex_base_name = "fwd_in_pdt_special_production_formulated_crystal_recipe_"
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


AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self



    function self:fwd_in_pdt_special_production_formulated_crystal_widget_open()
       

        if self.fwd_in_pdt_special_production_formulated_crystal_widget ~= nil then
            self.fwd_in_pdt_special_production_formulated_crystal_widget:Kill()
        end
        local root = self:AddChild(Screen())
        self.fwd_in_pdt_special_production_formulated_crystal_widget = root

        ----------------------------------------------------------------
        local main_scale_num = 1
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -------- 添加主背景 
            local background = root:AddChild(Image())
            root.background = background
            background:SetTexture("images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.xml","fwd_in_pdt_special_production_formulated_crystal_background.tex")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)

        ----------------------------------------------------------------
        --- 页码数
            local page_text = root:AddChild(Text(NEWFONT_OUTLINE_SMALL,40,tostring(current_tex_num).."/"..tostring(tex_max_num),{ 255/255 , 255/255 ,255/255 , 1}))
            page_text:SetPosition(0,-250)

        ----------------------------------------------------------------
        --- 图片
            local pic = root:AddChild(Image())
            root.pic = pic
            pic:SetPosition(0,0)
            pic:Show()
            pic:SetScale(main_scale_num,main_scale_num,main_scale_num)
            pic:SetTexture("images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal_recipes.xml",tex_base_name..tostring(current_tex_num)..".tex")
            function pic:LastPic()
                current_tex_num = current_tex_num - 1
                if current_tex_num <= 0 then
                    current_tex_num = tex_max_num
                end
                pic:SetTexture("images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal_recipes.xml",tex_base_name..tostring(current_tex_num)..".tex")
                page_text:SetString(tostring(current_tex_num).."/"..tostring(tex_max_num))
                page_text:MoveToFront()
            end
            function pic:NexPic()
                current_tex_num = current_tex_num + 1
                if current_tex_num > tex_max_num  then
                    current_tex_num = 1
                end
                pic:SetTexture("images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal_recipes.xml",tex_base_name..tostring(current_tex_num)..".tex")
                page_text:SetString(tostring(current_tex_num).."/"..tostring(tex_max_num))
                page_text:MoveToFront()
            end
            page_text:MoveToFront()
        ----------------------------------------------------------------
        ---- 左边按钮
            local left_button = root:AddChild(ImageButton(
                "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.xml",
                "fwd_in_pdt_special_production_formulated_crystal_left.tex",
                "fwd_in_pdt_special_production_formulated_crystal_left.tex",
                "fwd_in_pdt_special_production_formulated_crystal_left.tex",
                "fwd_in_pdt_special_production_formulated_crystal_left.tex",
                "fwd_in_pdt_special_production_formulated_crystal_left.tex"
            ))
            left_button:SetPosition(-320,-200)
            left_button:Show()
            left_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            left_button:SetOnDown(function()
                pic:LastPic()
            end)
        ----------------------------------------------------------------
        ---- 右边按钮
            local right_button = root:AddChild(ImageButton(
                "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.xml",
                "fwd_in_pdt_special_production_formulated_crystal_right.tex",
                "fwd_in_pdt_special_production_formulated_crystal_right.tex",
                "fwd_in_pdt_special_production_formulated_crystal_right.tex",
                "fwd_in_pdt_special_production_formulated_crystal_right.tex",
                "fwd_in_pdt_special_production_formulated_crystal_right.tex"
            ))
            right_button:SetPosition(320,-200)
            right_button:Show()
            right_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            right_button:SetOnDown(function()
                pic:NexPic()
            end)
        ----------------------------------------------------------------
        ---- 关闭按钮
            local close_button = root:AddChild(ImageButton(
                "images/fwd_in_pdt_special_production_formulated_crystal/fwd_in_pdt_special_production_formulated_crystal.xml",
                "fwd_in_pdt_special_production_formulated_crystal_close.tex",
                "fwd_in_pdt_special_production_formulated_crystal_close.tex",
                "fwd_in_pdt_special_production_formulated_crystal_close.tex",
                "fwd_in_pdt_special_production_formulated_crystal_close.tex",
                "fwd_in_pdt_special_production_formulated_crystal_close.tex"
            ))
            close_button:SetPosition(380,220)
            close_button:Show()
            close_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            -- close_button:SetOnDown(function()    --- 不用这个方法，不然关掉后会导致角色移动
            --     hud:fwd_in_pdt_special_production_formulated_crystal_widget_close()                
            -- end)
            close_button.OnControl = function(self,control,down)
                if not down then
                    hud:fwd_in_pdt_special_production_formulated_crystal_widget_close()
                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                end
            end
        ----------------------------------------------------------------
            ----- 锁住角色移动操作
            -- theCloseButton:MoveToFront()
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_special_production_formulated_crystal_widget_close()
                end
                -- if down and control == CONTROL_MOVE_UP or control == CONTROL_MOVE_DOWN or control == CONTROL_MOVE_LEFT or control == CONTROL_MOVE_RIGHT then
                --     hud:fwd_in_pdt_special_production_formulated_crystal_widget_close()
                -- end
                if not down then
                    if control == CONTROL_MOVE_LEFT then
                        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                        pic:LastPic()
                    end
                    if control == CONTROL_MOVE_RIGHT then
                        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                        pic:NexPic()
                    end
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end

    function self:fwd_in_pdt_special_production_formulated_crystal_widget_close()
        if self.fwd_in_pdt_special_production_formulated_crystal_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_special_production_formulated_crystal_widget)
            self.fwd_in_pdt_special_production_formulated_crystal_widget:Kill()
            self.fwd_in_pdt_special_production_formulated_crystal_widget = nil
        end
        ThePlayer:PushEvent("fwd_in_pdt_client_event.shop_close")
    end


end)