------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ATM HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_atm_widget.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_atm_widget.xml"),
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local atm_atlas = "images/ui_images/fwd_in_pdt_atm_widget.xml"

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


AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self


    function self:fwd_in_pdt_atm_open()
        if self.fwd_in_pdt_atm_widget ~= nil then
            self.fwd_in_pdt_atm_widget:Kill()
        end
        if self.fwd_in_pdt_atm_widget_inst ~= nil then
            self.fwd_in_pdt_atm_widget_inst:Remove()
        end
        local root = self:AddChild(Screen())
        self.fwd_in_pdt_atm_widget = root
        self.fwd_in_pdt_atm_widget_inst = CreateEntity()
        ----------------------------------------------------------------
        local input_num = 0
        ----------------------------------------------------------------
        local main_scale_num = 0.7
        -------- 设置锚点
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:MoveToBack()
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        ----------------------------------------------------------------
        --- 背景
            local background = root:AddChild(Image())
            root.background = background
            background:SetTexture(atm_atlas,"atm_background.tex")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
        --- 关闭按钮
            local close_button = root:AddChild(ImageButton(
                atm_atlas,
                "atm_close.tex",
                "atm_close.tex",
                "atm_close.tex",
                "atm_close.tex",
                "atm_close.tex"
            ))
            root.close_button = close_button
            close_button:SetPosition(300,240)
            close_button:Show()
            close_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            -- close_button:SetOnDown(function()
            --     hud:fwd_in_pdt_atm_close()                
            -- end)
            close_button.OnControl = function(self,control,down)
                if not down then
                    hud:fwd_in_pdt_atm_close()
                    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                end
            end
        ----------------------------------------------------------------
        --- 余额
            local surplus_text = root:AddChild(Text(CODEFONT,40,"XXXXXXXX",{ 255/255 , 255/255 ,255/255 , 1}))
            root.surplus_text = surplus_text
            -- surplus_text:SetString("")
            surplus_text:SetPosition(50,180)
            surplus_text:Show()      
            self.fwd_in_pdt_atm_widget_inst:DoPeriodicTask(0.5,function()
                local temp_num = ThePlayer.replica.fwd_in_pdt_func:Replica_Get_Simple_Data("jade_coins_in_atm") or 0
                surplus_text:SetString(tostring(temp_num))
            end)
        ----------------------------------------------------------------
        --- 输入
            local enter_text = root:AddChild(Text(CODEFONT,40,tostring(input_num),{ 255/255 , 255/255 ,255/255 , 1}))
            root.enter_text = enter_text
            -- surplus_text:SetString("")
            enter_text:SetPosition(50,110)
            enter_text:Show()            
        ----------------------------------------------------------------
        --- 数字按钮
            root.num_buttons = {}
            local function create_num_key_button(x,y)
                local num_button = root:AddChild(ImageButton(
                    atm_atlas,
                    "atm_key.tex",
                    "atm_key.tex",
                    "atm_key.tex",
                    "atm_key.tex",
                    "atm_key.tex"
                ))
                num_button:SetPosition(x,y)
                num_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
                num_button.txt = num_button:AddChild(Text(CODEFONT,40,"X",{ 255/255 , 255/255 ,255/255 , 1}))
                table.insert(root.num_buttons,num_button)
                -- print(#root.num_buttons)
            end
            local x,y = -170,0
            local delta_x,delta_y = 100,-70
            local locations = {
                Vector3(x , y , 0)            , Vector3(x + delta_x , y ,0)           , Vector3( x + 2*delta_x , y ,0),
                Vector3(x , y + 1*delta_y ,0) , Vector3(x + delta_x , y + 1*delta_y ,0) , Vector3( x + 2*delta_x , y + 1*delta_y ,0),
                Vector3(x , y + 2*delta_y ,0) , Vector3(x + delta_x , y + 2*delta_y ,0) , Vector3( x + 2*delta_x , y + 2*delta_y ,0),
                Vector3(x , y + 3*delta_y ,0) , Vector3(x + delta_x , y + 3*delta_y ,0) , Vector3( x + 2*delta_x , y + 3*delta_y ,0),
            }
            for k, pt in pairs(locations) do
                create_num_key_button(pt.x,pt.y)
            end
            --------  键盘数字
                for i = 1, 9, 1 do
                    root.num_buttons[i].txt:SetString(tostring(i))
                    root.num_buttons[i]:SetOnDown(function()
                        if input_num > 10000000000000 then
                            return
                        end
                        input_num = input_num*10 + i
                        enter_text:SetString(tostring(input_num))
                    end)
                end
                --- 0 按钮
                root.num_buttons[11].txt:SetString(tostring(0))
                root.num_buttons[11]:SetOnDown(function()
                    input_num = input_num*10
                    enter_text:SetString(tostring(input_num))
                end)
                ---- 退格
                root.num_buttons[12].txt:SetString("←")
                root.num_buttons[12]:SetOnDown(function()
                    input_num = math.floor(input_num/10)
                    enter_text:SetString(tostring(input_num))
                end)
                ---- 清空
                root.num_buttons[10].txt:SetString("Clear")
                root.num_buttons[10]:SetOnDown(function()
                    input_num = 0
                    enter_text:SetString(tostring(input_num))
                end)
        ----------------------------------------------------------------
        --- 存款按钮
            local save_button = root:AddChild(ImageButton(
                atm_atlas,
                "atm_save.tex",
                "atm_save.tex",
                "atm_save.tex",
                "atm_save.tex",
                "atm_save.tex"
            ))
            root.save_button = save_button
            save_button:SetPosition(200,0)
            save_button:Show()
            save_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            save_button:SetOnDown(function()
                ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.atm_save_money",input_num)
                input_num = 0
                enter_text:SetString("0")

                save_button:Disable()
                self.fwd_in_pdt_atm_widget_inst:DoTaskInTime(3,function()
                    save_button:Enable()
                end)
            end)
            ---- 说明（每天一次）
                    save_button.txt = save_button:AddChild(Text(CODEFONT,50,"每天只能一次\n                        Limited to once per day",{ 255/255 , 255/255 ,255/255 , 1}))
                    save_button.txt:SetPosition(240,0)
                    save_button.txt:Hide()
                        save_button.OnGainFocus__temp_old__ = save_button.OnGainFocus
                        save_button.OnGainFocus = function(self,...)
                            self.txt:Show()
                            return self:OnGainFocus__temp_old__(...)
                        end
                        save_button.OnLoseFocus__temp_old__ = save_button.OnLoseFocus
                        save_button.OnLoseFocus = function(self,...)
                            self.txt:Hide()
                            return self:OnLoseFocus__temp_old__(...)
                        end
        ----------------------------------------------------------------
        --- 取款按钮
            local withdraw_button = root:AddChild(ImageButton(
                atm_atlas,
                "atm_withdraw.tex",
                "atm_withdraw.tex",
                "atm_withdraw.tex",
                "atm_withdraw.tex",
                "atm_withdraw.tex"
            ))
            root.withdraw_button = withdraw_button
            withdraw_button:SetPosition(200,-100)
            withdraw_button:Show()
            withdraw_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            withdraw_button:SetOnDown(function()
                ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.atm_withdraw_money",input_num)
                input_num = 0
                enter_text:SetString("0")

                withdraw_button:Disable()
                self.fwd_in_pdt_atm_widget_inst:DoTaskInTime(3,function()
                    withdraw_button:Enable()
                end)
            end)
        ----------------------------------------------------------------
        --- cd-key 输入界面
            local cd_key_input_background =  root:AddChild(Image())
            root.cd_key_input_background = cd_key_input_background
            cd_key_input_background:SetTexture(atm_atlas,"atm cd_key_background.tex")
            cd_key_input_background:SetPosition(0,0)
            cd_key_input_background:Show()
            cd_key_input_background:SetScale(main_scale_num,main_scale_num,main_scale_num)
            cd_key_input_background:Hide()
            ------------------------------------------------------------
                ----- text_box
                    local text_box = cd_key_input_background:AddChild(TextEdit(CODEFONT,40,"XXXX-XXXX-XXXX-XXXX",{ 255/255 , 255/255 ,255/255 , 1}))
                    text_box:SetAllowNewline(false)
                    text_box:SetForceEdit(true)
                    text_box:EnableWordWrap(true)
                    text_box:EnableWhitespaceWrap(true)
                    text_box:EnableRegionSizeLimit(true)
                    text_box:EnableScrollEditWindow(false)
                    text_box:SetTextLengthLimit(19)
                    text_box:SetPosition(-130,0)
                ------ close button
                    local cd_key_input_close_button = cd_key_input_background:AddChild(ImageButton(
                        atm_atlas,
                        "atm_close.tex",
                        "atm_close.tex",
                        "atm_close.tex",
                        "atm_close.tex",
                        "atm_close.tex"
                    ))
                    cd_key_input_close_button:SetPosition(250,100)
                    cd_key_input_close_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
                    cd_key_input_close_button:SetOnDown(function()
                        cd_key_input_background:Hide()
                    end)
                ---- enter button
                    local cd_key_input_enter_button = cd_key_input_background:AddChild(ImageButton(
                        atm_atlas,
                        "atm_key.tex",
                        "atm_key.tex",
                        "atm_key.tex",
                        "atm_key.tex",
                        "atm_key.tex"
                    ))
                    cd_key_input_enter_button:SetPosition(200,0)
                    cd_key_input_enter_button:SetScale(main_scale_num*2,main_scale_num*2,main_scale_num*2)
                    cd_key_input_enter_button:AddChild(Text(CODEFONT,45,"Enter",{ 255/255 , 255/255 ,255/255 , 1}))
                    cd_key_input_enter_button:SetOnDown(function()
                        print("input cd-key",text_box:GetLineEditString())
                        ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.atm_enter_cd_key",tostring(text_box:GetLineEditString()))
                        self.fwd_in_pdt_atm_widget_inst:DoTaskInTime(0.5,function()
                            hud:fwd_in_pdt_atm_close()                            
                        end)                     
                    end)
            ------------------------------------------------------------

            
        ----------------------------------------------------------------
        --- cd-key 按钮
            local cd_key_button = root:AddChild(ImageButton(
                atm_atlas,
                "atm_cd_key_button.tex",
                "atm_cd_key_button.tex",
                "atm_cd_key_button.tex",
                "atm_cd_key_button.tex",
                "atm_cd_key_button.tex"
            ))
            root.cd_key_button = cd_key_button
            cd_key_button:SetPosition(200,-200)
            cd_key_button:Show()
            cd_key_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            cd_key_button:SetOnDown(function()
                -- ThePlayer.replica.fwd_in_pdt_func:RPC_PushEvent2()
                cd_key_input_background:Show()
                text_box:SetString("XXXX-XXXX-XXXX-XXXX")
                cd_key_button:Disable()
                self.fwd_in_pdt_atm_widget_inst:DoTaskInTime(3,function()
                    cd_key_button:Enable()
                end)
            end)
        ----------------------------------------------------------------
        ----- 锁住角色移动操作
            -- theCloseButton:MoveToFront()
            self:OpenScreenUnderPause(root)
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    hud:fwd_in_pdt_atm_close()
                end
                -- if down and control == CONTROL_MOVE_UP or control == CONTROL_MOVE_DOWN or control == CONTROL_MOVE_LEFT or control == CONTROL_MOVE_RIGHT then
                --     hud:fwd_in_pdt_atm_close()
                -- end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
        ----------------------------------------------------------------

    end
    function self:fwd_in_pdt_atm_close()
        if self.fwd_in_pdt_atm_widget_inst then
            self.fwd_in_pdt_atm_widget_inst:Remove()
            self.fwd_in_pdt_atm_widget_inst = nil
        end
        if self.fwd_in_pdt_atm_widget then
            TheFrontEnd:PopScreen(self.fwd_in_pdt_atm_widget)
            self.fwd_in_pdt_atm_widget:Kill()
            self.fwd_in_pdt_atm_widget = nil
        end
    end


end)