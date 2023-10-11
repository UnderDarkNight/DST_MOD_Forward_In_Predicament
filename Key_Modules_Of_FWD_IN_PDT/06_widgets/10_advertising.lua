------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 广告 HUD
--- 挂载去 ThePlayer.HUD里
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Assets == nil then
    Assets = {}
end
local temp_assets = {
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_ad_background.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_ad_background.xml"),
    Asset("IMAGE", "images/ui_images/fwd_in_pdt_ad.tex"),
	Asset("ATLAS", "images/ui_images/fwd_in_pdt_ad.xml"),
}
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------- 语言检测
    local LANGUAGE = "ch"
    if type(TUNING["Forward_In_Predicament.Language"]) == "function" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]()
    elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local time = 15      --- 倒计时时间
----------- 广告图片
local pics = {
    ["ch"] = "ad_ch.tex",
    ["en"] = "ad_en.tex"
}
----------- 按钮访问链接
local urls = {
    ["ch"] = "https://www.bilibili.com/",
    ["en"] = "https://www.bilibili.com/",
}

local ad_tex = pics[LANGUAGE] or pics["ch"]
local ad_atlas = "images/ui_images/fwd_in_pdt_ad.xml"
local ad_url = urls[LANGUAGE] or urls["ch"]
local function button_click()
    VisitURL(ad_url)
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


AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self
    function self:fwd_in_pdt_ad(display_time)
        ThePlayer:PushEvent("fwd_in_pdt_event.display_ad",display_time)
    end
    ThePlayer:ListenForEvent("fwd_in_pdt_event.display_ad",function(_,display_time)
        local root = self:AddChild(Screen())
        local tempInst = CreateEntity()
        local count_down_started_flag = false
        function root:temp_close()
            tempInst:Remove()
            root:Kill()
        end
        ----------------------------------------------------------------
        local time_num = display_time or time
        ----------------------------------------------------------------
            local main_scale_num = 0.6
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
            background:SetTexture("images/ui_images/fwd_in_pdt_ad_background.xml","background.tex")
            background:SetPosition(0,0)
            background:Show()
            background:SetScale(main_scale_num,main_scale_num,main_scale_num)
        ----------------------------------------------------------------
        --- 倒数
            local count_down = root:AddChild(Text(CODEFONT,50,tostring(time_num),{ 255/255 , 0/255 ,0/255 , 1}))
            root.count_down = count_down
            count_down:SetPosition(350,250)
            function count_down:Start()
                if count_down_started_flag then
                    return
                end
                count_down_started_flag = true
                tempInst:DoPeriodicTask(1,function()
                    time_num = time_num - 1
                    count_down:SetString(tostring(time_num))
                    if time_num <= 0 then
                        root:temp_close()
                    end
                end)
            end
        ----------------------------------------------------------------
            --- 广告内容
            local ad = root:AddChild(ImageButton(ad_atlas,ad_tex,ad_tex,ad_tex,ad_tex,ad_tex))
            root.ad = ad
            ad.focus_scale = {1,1,1}
            ad:SetPosition(0,0)
            ad:Show()
            ad:SetScale(main_scale_num,main_scale_num,main_scale_num)
            --- 鼠标经过页面就开始计时
                ad.OnGainFocus__temp_old__ = ad.OnGainFocus
                ad.OnGainFocus = function(self,...)
                    count_down:Start()
                    return self:OnGainFocus__temp_old__(...)
                end
            local ad_num = 3
            ad:SetOnDown(function()
                ad_num = ad_num - 1
                if ad_num <= 0 then
                    root:temp_close()
                end
            end)
        ----------------------------------------------------------------
            --- 关闭按钮
            local go_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_ad_background.xml",
                "button_go.tex",
                "button_go.tex",
                "button_go.tex",
                "button_go.tex",
                "button_go.tex"
            ))
            root.go_button = go_button
            go_button:SetPosition(300,-230)
            go_button:Show()
            go_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            go_button:SetOnDown(function()
                button_click()
                -- VisitURL("http://forums.kleientertainment.com/klei-bug-tracker/dont-starve-together/")            
            end)

        ----------------------------------------------------------------
        --- QQ群按钮
            local qq_group_image = root:AddChild(Image())
            root.qq_group_image = qq_group_image
            qq_group_image:SetTexture("images/ui_images/fwd_in_pdt_ad_background.xml","qq_group.tex")
            qq_group_image:SetPosition(500,0)
            qq_group_image:Hide()
            local qq_group_image_scale = 1
            qq_group_image:SetScale(main_scale_num*qq_group_image_scale,main_scale_num*qq_group_image_scale,main_scale_num*qq_group_image_scale)
            
            local qq_group_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_ad_background.xml",
                "button_qq.tex",
                "button_qq.tex",
                "button_qq.tex",
                "button_qq.tex",
                "button_qq.tex"
            ))
            root.qq_group_button = qq_group_button
            qq_group_button:SetPosition(350,200)
            qq_group_button:Show()
            qq_group_button:SetScale(main_scale_num,main_scale_num,main_scale_num)
            
            qq_group_button.OnGainFocus = function()
                qq_group_image:Show()
            end
            qq_group_button.OnLoseFocus = function()
                qq_group_image:Hide()
            end
        ----------------------------------------------------------------
        ----------------------------------------------------------------
        --- 抖音按钮
            local tiktok_image = root:AddChild(Image())
            root.tiktok_image = tiktok_image
            tiktok_image:SetTexture("images/ui_images/fwd_in_pdt_ad_background.xml","tiktok.tex")
            tiktok_image:SetPosition(500,0)
            tiktok_image:Hide()
            local tiktok_image_image_scale = 1
            tiktok_image:SetScale(main_scale_num*tiktok_image_image_scale,main_scale_num*tiktok_image_image_scale,main_scale_num*tiktok_image_image_scale)
            
            local tiktok_button = root:AddChild(ImageButton(
                "images/ui_images/fwd_in_pdt_ad_background.xml",
                "button_tiktok.tex",
                "button_tiktok.tex",
                "button_tiktok.tex",
                "button_tiktok.tex",
                "button_tiktok.tex"
            ))
            root.tiktok_button = tiktok_button
            tiktok_button:SetPosition(350,160)
            tiktok_button:Show()
            tiktok_button:SetScale(main_scale_num,main_scale_num,main_scale_num)            
            tiktok_button.OnGainFocus = function()
                tiktok_image:Show()
            end
            tiktok_button.OnLoseFocus = function()
                tiktok_image:Hide()
            end
        ----------------------------------------------------------------
            count_down:MoveToFront()
        ----------------------------------------------------------------
        ----- 锁住角色移动操作
            root.__old_fwd_in_pdt_OnControl = root.OnControl
            root.OnControl = function(self,control, down)
                -- print("widget key down",control,down)
                if CONTROL_CANCEL == control and down == false or control == CONTROL_OPEN_DEBUG_CONSOLE then
                    -- hud:fwd_in_pdt_atm_close()
                    root:Kill()
                end
                -- if down and control == CONTROL_MOVE_UP or control == CONTROL_MOVE_DOWN or control == CONTROL_MOVE_LEFT or control == CONTROL_MOVE_RIGHT then
                --     hud:fwd_in_pdt_atm_close()
                -- end
                if down then
                    count_down:Start()
                end
                return self:__old_fwd_in_pdt_OnControl(control,down)
            end
            root:OnGainFocus()  -- 试着兼容手柄
        ----------------------------------------------------------------
        ----------------------------------------------------------------
    end)


end)
