------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------- 体质值  的HUD

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

-------------------------------------------- 能量条的坐标储存
    AddPlayerPostInit(function(inst)    

        inst:ListenForEvent("fwd_in_pdt_event.Cross_Archived_Data_Send_2_Server_Finish",function()
            if inst.HUD and inst.HUD.fwd_in_pdt_wellness then
                local pt_percent_of_screen = inst.replica.fwd_in_pdt_func:Get_Cross_Archived_Data("wellness_bars_screen_xy")
                -- print("error +++++++++++++ ")
                if pt_percent_of_screen and pt_percent_of_screen.x_percent then
                    inst.HUD.fwd_in_pdt_wellness.x_percent = pt_percent_of_screen.x_percent
                    inst.HUD.fwd_in_pdt_wellness.y_percent = pt_percent_of_screen.y_percent
                    inst.HUD.fwd_in_pdt_wellness:LocationScaleFix()
                end

                ----- 
                local wellness_main_icon_hide_flag = inst.replica.fwd_in_pdt_func:Get_Cross_Archived_Data("wellness_main_icon_hide_flag")
                if wellness_main_icon_hide_flag then
                    inst.HUD.fwd_in_pdt_wellness:HideMainIcon(true)
                else
                    inst.HUD.fwd_in_pdt_wellness:HideMainIcon(false)                    
                end

            end
        end)

        --------- 监听 体质条 的移动和储存数据到跨存档保存表
        inst:DoTaskInTime(1,function()
            if inst.HUD and inst.HUD.fwd_in_pdt_wellness then
                inst:ListenForEvent("fwd_in_pdt_wellness_bars.save_cmd",function(_,cmd_table)
                    if type(cmd_table) ~= "table" then
                        return
                    end
                    if cmd_table.pt and cmd_table.pt.x_percent then
                        inst.replica.fwd_in_pdt_func:Set_Cross_Archived_Data("wellness_bars_screen_xy",cmd_table.pt)
                    end
                    if cmd_table.HideMainIcon ~= nil then
                        inst.replica.fwd_in_pdt_func:Set_Cross_Archived_Data("wellness_main_icon_hide_flag",cmd_table.HideMainIcon)
                    end

                end)
            end
        end)

    end)

-------------------- 直接在这添加界面节点和数据

AddClassPostConstruct("widgets/controls", function(self, owner)
    ------ 把界面挂载到  owner.HUD 里面，方便调用
    if owner == nil or owner.HUD == nil or owner.HUD.fwd_in_pdt_wellness ~= nil then
        return
    end
    --------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------------------
        ----- 添加主节点
            local main_scale_num = 0.6
            local root = self:AddChild(Widget())
            -------- 设置锚点
                root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetPosition(1000,500)
                root:MoveToBack()
            -------- 设置缩放模式
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   
                owner.HUD.fwd_in_pdt_wellness = root        --- 挂载到  HUD节点，方便replica 调用
            -------- 启动坐标跟随缩放循环任务，缩放的时候去到指定位置。官方好像没预留这类API，或者暂时找不到方法
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

                owner:DoPeriodicTask(0.3,function()
                    root:LocationScaleFix()
                end)
        -----------------------------------------------------------------------------------------------------------------
        ----- 往主节点添加透明按钮
                    local button = root:AddChild(AnimButton("fwd_in_pdt_hud_wellness",{
                        idle = "button",
                        over = "button",
                        disabled = "button"
                    }))
                    button.anim:GetAnimState():SetScale(main_scale_num,main_scale_num,main_scale_num)

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

                                            owner:PushEvent("fwd_in_pdt_wellness_bars.save_cmd",{    --- 发送储存坐标。
                                                pt = {x_percent = root.x_percent,y_percent = root.y_percent},
                                            })

                                        end
                                    end)
                            end                            
                    end)
        -----------------------------------------------------------------------------------------------------------------
        ----- 体质值图标
                local wellness_icon = root:AddChild(UIAnim())
                root.wellness_icon = wellness_icon
                wellness_icon:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                wellness_icon:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                wellness_icon:GetAnimState():PlayAnimation("icon_wellness",true)
                wellness_icon:SetPosition(0,0)
                wellness_icon:Show()
                wellness_icon.show_flag = true
                wellness_icon:SetScale(main_scale_num,main_scale_num,main_scale_num)
        -----------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------------------
        ----- 体质值条
                local wellness_bar = root:AddChild(UIAnim())
                root.wellness_bar = wellness_bar
                wellness_bar:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                wellness_bar:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                wellness_bar:GetAnimState():PlayAnimation("bar_wellness")
                wellness_bar:GetAnimState():Pause()
                wellness_bar:SetPosition(21,0)
                wellness_bar:GetAnimState():SetTime(5)
                wellness_bar:Show()
                wellness_bar:SetScale(main_scale_num,main_scale_num,main_scale_num)

                --- 调换顺序
                wellness_icon:MoveToFront()                
                wellness_bar:MoveToBack()

                ------------------------------------------------------
                --- 添加文本
                    local wellness_frame = wellness_bar:AddChild(UIAnim())
                    wellness_frame:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                    wellness_frame:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                    wellness_frame:GetAnimState():PlayAnimation("big_frame")
                    wellness_frame:SetPosition(178,0)
                    local wellness_text = wellness_frame:AddChild(Text(CODEFONT,30,"100.42",{ 255/255 , 255/255 ,255/255 , 1}))
                    wellness_text:SetPosition(45,0)
                ------------------------------------------------------
                --- 添加升降标识
                    local wellness_up_down_icon = wellness_bar:AddChild(UIAnim())
                    wellness_up_down_icon:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                    wellness_up_down_icon:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                    wellness_up_down_icon:GetAnimState():PlayAnimation("up")
                    wellness_up_down_icon:Hide()
                    wellness_up_down_icon:SetPosition(10,-30)
                ------------------------------------------------------
                ---- 体质条按钮 ----- 隐藏主图标的按钮
                    function root:HideMainIcon(flag)
                        if flag then
                            wellness_icon:Hide()
                            wellness_icon.show_flag = false
                            button:Hide()
                            wellness_up_down_icon:SetPosition(15,0)

                        else
                            wellness_icon:Show()
                            wellness_icon.show_flag = true
                            button:Show()
                            wellness_up_down_icon:SetPosition(10,-30)
                        end
                    end
                    wellness_bar.OnMouseButton__fwd_in_pdt_old = wellness_bar.OnMouseButton
                    wellness_bar.OnMouseButton = function(self,t_button,down,x,y)
                        -- print("test ++ ",t_button,down,x,y)
                        if t_button == MOUSEBUTTON_LEFT and down == false then
                            if wellness_icon.show_flag then
                                root:HideMainIcon(true)
                                owner:PushEvent("fwd_in_pdt_wellness_bars.save_cmd",{
                                    HideMainIcon = true
                                })
                            else
                                root:HideMainIcon(false)
                                owner:PushEvent("fwd_in_pdt_wellness_bars.save_cmd",{
                                    HideMainIcon = false
                                })
                            end
                        end
                        return self:OnMouseButton__fwd_in_pdt_old(t_button,down,x,y)
                    end
                ------------------------------------------------------

                function owner.HUD.fwd_in_pdt_wellness:SetCurrent_Wellness(num,percent,max) 
                    -- 10s = 100%                    
                    wellness_bar:GetAnimState():SetTime(percent*10)
                    wellness_text:SetString(tostring(string.format("%.2f",num)))    --- 保留2位小数

                    ----- 升降符号
                    if wellness_bar.__last_percent then
                        if wellness_bar.__last_percent > percent then
                            wellness_up_down_icon:GetAnimState():PlayAnimation("down")
                            wellness_up_down_icon:Show()
                        elseif wellness_bar.__last_percent < percent then
                            wellness_up_down_icon:GetAnimState():PlayAnimation("up")
                            wellness_up_down_icon:Show()
                        else                                        
                            -- wellness_up_down_icon:Hide()                            
                        end
                    end
                    wellness_bar.__last_percent = percent

                end
        -----------------------------------------------------------------------------------------------------------------
        ----- VC 值
                local vc_bar = root:AddChild(UIAnim())
                root.vc_bar = vc_bar
                vc_bar:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                vc_bar:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                vc_bar:GetAnimState():PlayAnimation("mini_bar")
                vc_bar:GetAnimState():Hide("BLUE")
                vc_bar:GetAnimState():Hide("RED")
                vc_bar:GetAnimState():Hide("GREEN")
                vc_bar:GetAnimState():Show("YELLOW")
                vc_bar:GetAnimState():Pause()
                vc_bar:SetPosition(68,-30)
                vc_bar:GetAnimState():SetTime(5)
                vc_bar:Show()
                vc_bar:SetScale(main_scale_num,main_scale_num,main_scale_num)

                -------- 文本框  和 文本
                local vc_text_frame = vc_bar:AddChild(UIAnim())
                vc_text_frame:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                vc_text_frame:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                vc_text_frame:GetAnimState():PlayAnimation("small_frame")
                vc_text_frame:SetPosition(100,0)

                local vc_text = vc_text_frame:AddChild(Text(CODEFONT,20,"11.35/100",{ 255/255 , 255/255 ,255/255 , 1}))
                vc_text:SetPosition(45,0)

                local vc_icon = vc_bar:AddChild(UIAnim())
                vc_icon:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                vc_icon:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                vc_icon:GetAnimState():PlayAnimation("icon_vc")
                vc_icon:SetPosition(-25,0)
                vc_icon:Show()

                function owner.HUD.fwd_in_pdt_wellness:SetCurrent_Vitamin_C(num,percent,max)
                    -- 10s = 100%                    
                    vc_bar:GetAnimState():SetTime(percent*10)
                    vc_text:SetString(tostring(string.format("%.2f",num)))    --- 保留2位小数
                end

        -----------------------------------------------------------------------------------------------------------------
        ----- 血糖 值
                local glu_bar = root:AddChild(UIAnim())
                root.glu_bar = glu_bar
                glu_bar:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                glu_bar:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                glu_bar:GetAnimState():PlayAnimation("mini_bar")
                glu_bar:GetAnimState():Hide("BLUE")
                glu_bar:GetAnimState():Show("RED")
                glu_bar:GetAnimState():Hide("GREEN")
                glu_bar:GetAnimState():Hide("YELLOW")
                glu_bar:GetAnimState():Pause()
                glu_bar:SetPosition(68,-30 - 25)
                glu_bar:GetAnimState():SetTime(5)
                glu_bar:Show()
                glu_bar:SetScale(main_scale_num,main_scale_num,main_scale_num)

                -------- 文本框  和 文本
                local glu_text_frame = glu_bar:AddChild(UIAnim())
                glu_text_frame:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                glu_text_frame:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                glu_text_frame:GetAnimState():PlayAnimation("small_frame")
                glu_text_frame:SetPosition(100,0)

                local glu_text = glu_text_frame:AddChild(Text(CODEFONT,20,"11.35",{ 255/255 , 255/255 ,255/255 , 1}))
                glu_text:SetPosition(45,0)

                local glu_icon = glu_bar:AddChild(UIAnim())
                glu_icon:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                glu_icon:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                glu_icon:GetAnimState():PlayAnimation("icon_glu")
                glu_icon:SetPosition(-25,0)
                glu_icon:Show()

                function owner.HUD.fwd_in_pdt_wellness:SetCurrent_Glucose(num,percent,max)
                    -- 10s = 100%                    
                    glu_bar:GetAnimState():SetTime(percent*10)
                    glu_text:SetString(tostring(string.format("%.2f",num)))    --- 保留2位小数
                end

        -----------------------------------------------------------------------------------------------------------------
        ----- 中毒 值
                local poison_bar = root:AddChild(UIAnim())
                root.glu_bar = poison_bar
                poison_bar:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                poison_bar:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                poison_bar:GetAnimState():PlayAnimation("mini_bar")
                poison_bar:GetAnimState():Hide("BLUE")
                poison_bar:GetAnimState():Hide("RED")
                poison_bar:GetAnimState():Show("GREEN")
                poison_bar:GetAnimState():Hide("YELLOW")
                poison_bar:GetAnimState():Pause()
                poison_bar:SetPosition(68,-30 - 25 -25)
                poison_bar:GetAnimState():SetTime(5)
                poison_bar:Show()
                poison_bar:SetScale(main_scale_num,main_scale_num,main_scale_num)

                -------- 文本框  和 文本
                local poison_text_frame = poison_bar:AddChild(UIAnim())
                poison_text_frame:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                poison_text_frame:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                poison_text_frame:GetAnimState():PlayAnimation("small_frame")
                poison_text_frame:SetPosition(100,0)

                local poison_text = poison_text_frame:AddChild(Text(CODEFONT,20,"11.35",{ 255/255 , 255/255 ,255/255 , 1}))
                poison_text:SetPosition(45,0)

                local poison_icon = poison_bar:AddChild(UIAnim())
                poison_icon:GetAnimState():SetBuild("fwd_in_pdt_hud_wellness")
                poison_icon:GetAnimState():SetBank("fwd_in_pdt_hud_wellness")
                poison_icon:GetAnimState():PlayAnimation("icon_poison")
                poison_icon:SetPosition(-25,0)
                poison_icon:Show()

                function owner.HUD.fwd_in_pdt_wellness:SetCurrent_Poison(num,percent,max)
                    -- 10s = 100%                    
                    poison_bar:GetAnimState():SetTime(percent*10)
                    poison_text:SetString(tostring(string.format("%.2f",num)))    --- 保留2位小数
                end

        -----------------------------------------------------------------------------------------------------------------
        --- 统一API显示
                function owner.HUD.fwd_in_pdt_wellness:HideOhters()
                    vc_bar:Hide()
                    glu_bar:Hide()
                    poison_bar:Hide()
                end
                function owner.HUD.fwd_in_pdt_wellness:ShowOhters()
                    vc_bar:Show()
                    glu_bar:Show()
                    poison_bar:Show()
                end

        -----------------------------------------------------------------------------------------------------------------

        button:MoveToFront()    --- 按钮永远在最上面
        
        owner.HUD.fwd_in_pdt_wellness:HideOhters() --- 默认隐藏

        ------ 
    --------------------------------------------------------------
    --- 死亡隐藏
            -- owner:ListenForEvent("death",function()
            --     root:Hide()
            -- end)
            -- owner:ListenForEvent("respawnfromghost",function()
            --     owner:DoTaskInTime(9,function()
            --         root:Show()                    
            --     end)
            -- end)

    --------------------------------------------------------------
end)