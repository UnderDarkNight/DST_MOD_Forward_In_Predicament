--------------------------------------------------------------------------------------------------------------------------------------------
---- 技能指示条
--------------------------------------------------------------------------------------------------------------------------------------------

local Widget = require "widgets/widget"
-- local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"

-- local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
-- local ImageButton = require "widgets/imagebutton"
-- local Menu = require "widgets/menu"
local Text = require "widgets/text"
-- local TEMPLATES = require "widgets/redux/templates"


AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self



    function hud:fwd_in_pdt_carl_spell_bar()
        ------------------------------------------------------------
        if ThePlayer.prefab ~= "fwd_in_pdt_carl" then
            return
        end
        ------------------------------------------------------------
        --- 获取坐标
            local carl_spell_bar_pt = ThePlayer.replica.fwd_in_pdt_func:Get_Cross_Archived_Data("carl_spell_bar_pt")
            if carl_spell_bar_pt == nil then
                carl_spell_bar_pt = {
                    x = 0.5,
                    y = 0.5,
                }
            end
        ------------------------------------------------------------
        --- 添加主节点
            local main_scale_num = 0.7
            local root = hud:AddChild(Widget())

            -------- 设置锚点
                root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetPosition(1000,500)
                root:MoveToBack()
            -------- 设置缩放模式
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   
            -------- 启动坐标跟随缩放循环任务，缩放的时候去到指定位置。官方好像没预留这类API，或者暂时找不到方法
                root.x_percent = carl_spell_bar_pt.x
                root.y_percent = carl_spell_bar_pt.y
                function root:LocationScaleFix()
                    if self.x_percent and not self.__mouse_holding  then
                        local scrnw, scrnh = TheSim:GetScreenSize()
                        if self.____last_scrnh ~= scrnh then
                            local tarX = self.x_percent * scrnw
                            local tarY = self.y_percent * scrnh
                            self:SetPosition(tarX,tarY)
                        end
                        self.____last_scrnh = scrnh
                    end
                end

                -- ThePlayer:DoPeriodicTask(2,function()
                --     root:LocationScaleFix()
                -- end)
        -----------------------------------------------------------------------------------------------------------------
        ----- 往主节点添加按钮
            local button = root:AddChild(AnimButton("fwd_in_pdt_carl_spell_bar",{
                idle = "idle",
                over = "idle",
                disabled = "idle"
            }))
            -- button.anim:GetAnimState():SetScale(main_scale_num,main_scale_num,main_scale_num)
            button:SetScale(main_scale_num,main_scale_num,main_scale_num)

            button:SetOnDown(function()                      --- 鼠标按下去的时候
                    if not root.__mouse_holding  then
                        root.__mouse_holding = true      --- 上锁
                            --------- 添加鼠标移动监听任务
                            root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
                                root:SetPosition(x,y,0)
                            end)
                            --------- 添加鼠标按钮监听
                            root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
                                if button == MOUSEBUTTON_LEFT and down == false then    ---- 左键被抬起来了
                                    root.___mouse_button_up_event:Remove()       ---- 清掉监听
                                    root.___mouse_button_up_event = nil

                                    root.___follow_mouse_event:Remove()          ---- 清掉监听
                                    root.___follow_mouse_event = nil

                                    root:SetPosition(x,y,0)                      ---- 设置坐标
                                    root.__mouse_holding = false                 ---- 解锁

                                    local scrnw, scrnh = TheSim:GetScreenSize()
                                    root.x_percent = x/scrnw
                                    root.y_percent = y/scrnh

                                    -- owner:PushEvent("fwd_in_pdt_wellness_bars.save_cmd",{    --- 发送储存坐标。
                                    --     pt = {x_percent = root.x_percent,y_percent = root.y_percent},
                                    -- })
                                    ThePlayer.replica.fwd_in_pdt_func:Set_Cross_Archived_Data("carl_spell_bar_pt",{
                                        x = root.x_percent,
                                        y = root.y_percent,
                                    })

                                end
                            end)
                    end                            
            end)
        -----------------------------------------------------------------------------------------------------------------
        ----- 
            local font = CODEFONT
            local font_size = 15
        -----------------------------------------------------------------------------------------------------------------
        ----- 技能A
            local spell_a_str = "Primary Spell CD: "
            local spell_a_text = root:AddChild(Text(font,font_size,spell_a_str,{ 255/255 , 255/255 ,255/255 , 1}))
            spell_a_text:SetPosition(-17,-18)
            spell_a_text:SetScale(0.7,1,1)

            local spell_a_num = root:AddChild(Text(font,font_size,tostring(0),{ 255/255 , 255/255 ,255/255 , 1}))
            spell_a_num:SetPosition(35,-18)
        -----------------------------------------------------------------------------------------------------------------
        ----- 技能B
            local spell_b_str = "Auxiliary Spell CD: "
            local spell_b_text = root:AddChild(Text(font,font_size,spell_b_str,{ 255/255 , 255/255 ,255/255 , 1}))
            spell_b_text:SetPosition(-15,-33)
            spell_b_text:SetScale(0.7,1,1)

            local spell_b_num = root:AddChild(Text(font,font_size,tostring(0),{ 255/255 , 255/255 ,255/255 , 1}))
            spell_b_num:SetPosition(35,-33)
        -----------------------------------------------------------------------------------------------------------------





        -----------------------------------------------------------------------------------------------------------------
        ---- 循环监视任务
            ThePlayer:DoPeriodicTask(1,function()
                root:LocationScaleFix()

                
                local spell_a_time = ThePlayer.replica.fwd_in_pdt_func:Spell_Get("spell_a_time") or 0
                spell_a_num:SetString(tostring(spell_a_time))

                local spell_b_time = ThePlayer.replica.fwd_in_pdt_func:Spell_Get("spell_b_time") or 0
                spell_b_num:SetString(tostring(spell_b_time))
            end)
        -----------------------------------------------------------------------------------------------------------------
    end



end)