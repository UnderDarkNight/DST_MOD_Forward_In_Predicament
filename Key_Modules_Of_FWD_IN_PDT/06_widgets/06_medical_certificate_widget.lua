------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 诊断单的 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    function self:fwd_in_pdt_medical_certificate_show(cmd_table)
        if self.fwd_in_pdt_medical_certificate_widget then
            self.fwd_in_pdt_medical_certificate_widget:Kill()
        end
        local root = self:AddChild(Screen())
        self.fwd_in_pdt_medical_certificate_widget = root


        local main_scale_num = 1
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -------- 添加主背景 
            local background = root:AddChild(UIAnim())
            root.background = background
            background:GetAnimState():SetBuild("fwd_in_pdt_item_medical_certificate")
            background:GetAnimState():SetBank("fwd_in_pdt_item_medical_certificate")
            background:GetAnimState():PlayAnimation("hud")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)
            -- background.OnMouseButton = function(self,button,down,x,y)
            --     if down then
            --         print(x,y)
            --     end
            --     return true
            -- end
        ------- 添加按钮
            local theCloseButton = root:AddChild(UIAnim())
            root.background = theCloseButton
            theCloseButton:GetAnimState():SetBuild("fwd_in_pdt_item_medical_certificate")
            theCloseButton:GetAnimState():SetBank("fwd_in_pdt_item_medical_certificate")
            theCloseButton:GetAnimState():PlayAnimation("button")
            theCloseButton:SetPosition(420,300)
            theCloseButton:Show()
            theCloseButton:SetScale(main_scale_num,main_scale_num,main_scale_num)
            theCloseButton.__old_fwd_in_pdt_OnMouseButton = theCloseButton.OnMouseButton
            theCloseButton.OnMouseButton = function(self,button,down,x,y)
                local ret = self:__old_fwd_in_pdt_OnMouseButton(button,down,x,y)
                if button == MOUSEBUTTON_LEFT and down == false then
                    ret = true
                    hud:fwd_in_pdt_medical_certificate_hide()
                end
                return ret
            end
        ----------------------------------------------------------------
        ---- 根据 table 添加 内容
            if type(cmd_table) == "table" then
                if cmd_table.days then
                    local days_widget = root:AddChild(Text(TALKINGFONT,30,tostring(cmd_table.days),{ 255/255 , 255/255 ,255/255 , 1}))
                    days_widget:SetPosition(320,200)                    
                end
                if cmd_table.player_name then
                    local name_widget = root:AddChild(Text(TALKINGFONT,30,tostring(cmd_table.player_name),{ 255/255 , 255/255 ,255/255 , 1}))
                    name_widget:SetPosition(320,260)
                end
                if type(cmd_table.debuffs) == "table" then
                    local start_x ,start_y = -320 , 135
                    local delta_y = 22
                    local line_max = 17
                    -- local line = root:AddChild(Text(TALKINGFONT,25,tostring("#########"),{ 255/255 , 255/255 ,255/255 , 1}))
                    -- line:SetPosition(start_x,start_y)
                    local function create_text_line(str,x,y)
                        if line_max <= 0 then
                            return
                        end

                        local line = root:AddChild(Text(NEWFONT_OUTLINE_SMALL,25,str,{ 255/255 , 255/255 ,255/255 , 1}))
                        line:SetPosition(x + 500,y)
                        -- line:EnableWhitespaceWrap(true)
                        -- line:SetVAlign(ANCHOR_MIDDLE)
                        line:SetHAlign(ANCHOR_LEFT)
                        line:SetRegionSize(1000, 500)     --- 处理定格锚点用的。
                        line_max = line_max - 1
                    end
                    for i, debuff_table in pairs(cmd_table.debuffs) do
                        if type(debuff_table) == "table" and debuff_table.name and debuff_table.treatment then
                            create_text_line(tostring(debuff_table.name).."   :  ",start_x,start_y)
                            start_y = start_y - delta_y

                                if type(debuff_table.treatment) == "table" then
                                    for k, temp_treatment in pairs(debuff_table.treatment) do
                                        create_text_line("            "..tostring(temp_treatment),start_x,start_y)
                                        start_y = start_y - delta_y
                                    end
                                else
                                    create_text_line("            "..tostring(debuff_table.treatment),start_x,start_y)
                                    start_y = start_y - delta_y
                                end

                        end
                    end
                end
            end
        ----------------------------------------------------------------
        ----- 锁住角色移动操作
            theCloseButton:MoveToFront()
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_medical_certificate_hide()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------
    end
    function self:fwd_in_pdt_medical_certificate_hide()
        if self.fwd_in_pdt_medical_certificate_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_medical_certificate_widget)
            self.fwd_in_pdt_medical_certificate_widget:Kill()
            self.fwd_in_pdt_medical_certificate_widget = nil
        end
    end



end)