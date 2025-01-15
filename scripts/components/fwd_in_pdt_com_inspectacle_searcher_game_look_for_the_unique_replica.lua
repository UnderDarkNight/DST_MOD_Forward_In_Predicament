----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
------------------------------------------------------------------------------------------------------------------------------
---
    local MAX_IMAGE_NUM = 20
    local IMAGES_DATA = {
        [1] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 12,y = 6 ,radius = 70 },
        [2] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 14,y = 8 ,radius = 60 },
        [3] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 12,y = 6 ,radius = 70 },
        [4] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 12,y = 6 ,radius = 65 ,succeed_color = {0,0,1,1} },
        [5] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [6] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [7] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 12,y = 6 ,radius = 70 },
        [8] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [9] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [10] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [11] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 13,y = 7 ,radius = 60 },
        [12] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 17,y = 10 ,radius = 45 ,succeed_color = {0,0,1,1}},
        [13] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 55},
        [14] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 55},
        [15] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 55},
        [16] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 55},
        [17] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 17,y = 9 ,radius = 45},
        [18] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 52},
        [19] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 17,y = 10 ,radius = 45},
        [20] = { atlas = "images/fwd_in_pdt_inspectaclesbox/game_look_for_the_unique.xml", x = 15,y = 8 ,radius = 55},
    }
------------------------------------------------------------------------------------------------------------------------------
    local function CreateGameWidget(self)
        ----------------------------------------------------
        --- 前置准备
            if self.game_widget and self.game_widget.inst:IsValid() then
                return
            end
        ----------------------------------------------------
        --- 前置根节点、素材库
            local front_root = ThePlayer.HUD:AddChild(Widget())
            local atlas = "images/fwd_in_pdt_inspectaclesbox/game_widget_1.xml"
            front_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            front_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            front_root:SetPosition(0,0)
            front_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            front_root:MoveToBack()
        ----------------------------------------------------
        --- 前置根节点绑定相关
            self.game_widget = front_root
            front_root.inst:ListenForEvent("onremove",function()
                front_root:Kill()
            end,self.inst)
            front_root.inst:DoPeriodicTask(0.5,function()
                if ThePlayer and self.inst and self.inst:GetDistanceSqToInst(ThePlayer) < 25 then
                    return
                else
                    front_root:Kill()
                end                    
            end)
        ----------------------------------------------------
        --- 根节点
            local root = front_root:AddChild(Widget())
            local scale = 0.6
            root:SetScale(scale,scale,scale)
        ----------------------------------------------------
        ---
            local bg = root:AddChild(Image(atlas,"background.tex"))
        ----------------------------------------------------
        --- 关闭按钮
            local button_close = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_close:SetPosition(630,370)
            button_close:SetOnClick(function()
                front_root:Kill()
                self.game_widget = nil
            end)
            button_close.image:AddChild(Image(atlas,"icon_close.tex"))
            root.button_close = button_close
        ----------------------------------------------------
        --- 刷新按钮
            local button_refresh = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_refresh:SetPosition(440,-380)
            button_refresh:SetOnClick(function()
                -- print("refresh")
                self:RefreshClick()
            end)
            button_refresh.image:AddChild(Image(atlas,"icon_refresh.tex"))
            root.button_refresh = button_refresh
        ----------------------------------------------------
        --- 星星按钮
            local button_star = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_star:SetPosition(570,-380)
            button_star:SetOnClick(function()
                -- print("star")
                self:Submit()
                self.game_widget:Kill()
                self.game_widget = nil
            end)
            local star_icon = button_star.image:AddChild(Image(atlas,"icon_star.tex"))
            root.button_star = button_star
            button_star.img_show = true
            function button_star:SetActive(flag)
                if flag then
                    self:SetTextures(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex")
                    self:SetClickable(true)
                    if self.aciving_task then
                        self.aciving_task:Cancel()
                    end
                    self.aciving_task = self.inst:DoPeriodicTask(0.3,function()
                        if self.img_show then
                            star_icon:Show()
                        else
                            star_icon:Hide()
                        end
                        self.img_show = not self.img_show
                    end)
                else
                    self:SetTextures(atlas,"button_deacitve.tex","button_deacitve.tex","button_deacitve.tex","button_deacitve.tex","button_deacitve.tex")
                    self:SetClickable(false)
                    if self.aciving_task then
                        self.aciving_task:Cancel()
                        self.aciving_task = nil
                    end
                end
            end
            button_star:SetActive(false)
        ----------------------------------------------------
        --- box
            local box = bg:AddChild(Image(atlas,"box_frame.tex"))
            box:SetScale(1.2,1.2,1.2)
        ----------------------------------------------------
        --- 图片放置图层
            local images_layer = box:AddChild(Widget())
        ----------------------------------------------------
        --- 透明按钮图层
            local select_button = box:AddChild(ImageButton("images/fwd_in_pdt_inspectaclesbox/transparent_button_box.xml",
                "transparent_button_box.tex",
                "transparent_button_box.tex",
                "transparent_button_box.tex",
                "transparent_button_box.tex",
                "transparent_button_box.tex"
            ))
            select_button.focus_scale = {1,1,1}
            select_button:SetOnClick(function()
                local screen_w,screen_h = TheSim:GetScreenSize()
                local mouse_pos = TheInput:GetScreenPosition()
                local pos = Vector3(mouse_pos.x-screen_w/2,mouse_pos.y-screen_h/2,0)
                -- print("select",pos)
                front_root.inst:PushEvent("select",pos)
            end)
            select_button.clickoffset = Vector3(0,0,0)
            -- select_button.__OnMouseButton = select_button.OnMouseButton
            -- select_button.OnMouseButton = function(self,button,down,x,y,...)
            --     if down and MOUSEBUTTON_LEFT == button then
            --         print("select",x,y)
            --     end
            --     return self:__OnMouseButton(button,down,x,y,...)
            -- end
            select_button.image:SetTint(1,1,1,0.01)
            select_button:SetScale(1.1,1.1,1.1)
        ----------------------------------------------------
        --- 数据获取
            local data_index = math.clamp(self.GetImageIndex and self:GetImageIndex() or 1,1,MAX_IMAGE_NUM)
            local image_data = IMAGES_DATA[data_index] or {}
            local image_atlas = image_data.atlas
            local image_name = tostring(data_index).."_normal.tex"
            local image_special_name = tostring(data_index).."_special.tex"
            local x_num = math.ceil(image_data.x/2) *2 + 1  --- 确保奇数
            local y_num = math.ceil(image_data.y/2) *2 + 1  --- 确保奇数
            local radius = image_data.radius
            local offset = radius
            local succeed_color = image_data.succeed_color or {1,0,0,1}
        ----------------------------------------------------
        --- 基于中点（0，0） 计算图片位置。 左上角 math.floor(-x_num), math.floor(-y_num)
            local all_points = {}
            for temp_y = 1, y_num do
                for temp_x = 1, x_num do
                    table.insert(all_points,Vector3(math.floor(-x_num/2 + temp_x)*offset,math.floor(-y_num/2 + temp_y)*offset,0))
                end
            end
        ----------------------------------------------------
        --- 图片放置
            local all_images = {}
            local function GetOffset()
                local base_offset = offset/6
                if math.random() > 0.5 then
                    base_offset = -base_offset
                end
                return base_offset
            end
            for i, pos in ipairs(all_points) do
                local temp_image = images_layer:AddChild(Image(image_atlas,image_name))
                if math.random() > 0.5 then
                    temp_image:SetScale(1,-1)
                end
                temp_image:SetPosition(pos.x+GetOffset(),pos.y+GetOffset(),0)
                temp_image:SetRotation(math.random(0,7)*45)  -- 45度一节 8 个
                table.insert(all_images,temp_image)
            end
        ----------------------------------------------------
        --- 特殊图片
            local special_image = all_images[math.random(#all_images)]
            special_image:MoveToFront()
            special_image:SetTexture(image_atlas,image_special_name)
            -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            --     -- special_image:SetTint(1,0,0,1)
            --     special_image:SetTint(unpack(succeed_color))
            -- end
        ----------------------------------------------------
        --- 点击判定
            front_root.inst:ListenForEvent("select",function(inst,pos)
                local target_pos = special_image:GetPosition()
                local delta_x = math.abs(target_pos.x - pos.x)
                local delta_y = math.abs(target_pos.y - pos.y)
                if delta_x <= radius*1.2 and delta_y <= radius*1.2 then
                    special_image:SetTint(unpack(succeed_color))
                    select_button:SetClickable(false)
                    button_star:SetActive(true)
                    front_root.inst:PushEvent("succeed_click")
                else
                    front_root.inst:PushEvent("wrong_click")
                end
            end)
        ----------------------------------------------------
        --- 错误判定
            local temp_text = "0/"..self:GetMaxTestNum()
            local test_num_text = root:AddChild(Text(CODEFONT,60,temp_text or "0/5",{ 255/255 , 0/255 ,0/255 , 1}))
            test_num_text:SetPosition(-550,-340,0)
            local current_test_num = 0
            front_root.inst:ListenForEvent("wrong_click",function()
                current_test_num = current_test_num + 1
                local max_test_num = self:GetMaxTestNum()
                test_num_text:SetString(current_test_num.."/"..max_test_num)
                if current_test_num >= max_test_num then
                    self:RefreshClick()
                end
            end)
            front_root.inst:ListenForEvent("succeed_click",function()
                test_num_text:SetColour(0,1,0,1)
            end)
        ----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique = Class(function(self, inst)
    self.inst = inst
    
    --------------------------------------------------------
    ---
        self.__index = net_tinybyte(inst.GUID,"game_look_for_the_unique.index","game_look_for_the_unique_update")
        self.__max_test_num = net_uint(inst.GUID,"game_look_for_the_unique.max_test_num","game_look_for_the_unique_update")

    --------------------------------------------------------
end)
------------------------------------------------------------------------------------------------------------------------------
--- 控制API
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:RefreshClick()
        if self.game_widget then
            self.game_widget:Kill()
        end
        CreateGameWidget(self)
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:Submit()
        if self.submit_fn then
            self.submit_fn(self.inst)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetSubmitFn(fn)
        self.submit_fn = fn
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:StartGame()
        if self.game_widget then
            self.game_widget:Kill()
            self.game_widget = nil
        end
        if ThePlayer and ThePlayer.HUD then
            CreateGameWidget(self)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:IsGamePlaying()
        if self.game_widget and self.game_widget.inst and self.game_widget.inst:IsValid() then
            return true
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:GetImageIndex()
        return self.__index:value()
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetImageIndex(index)
        if TheWorld.ismastersim then
            self.__index:set(index)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:GetMaxTestNum()
        return self.__max_test_num:value()
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetMaxTestNum(num)
        if TheWorld.ismastersim then
            self.__max_test_num:set(math.clamp(num,1,10000))
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique







