--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    技能介绍页 下发显示

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if inst == ThePlayer then
            inst:ListenForEvent("cyclone_spell_introduction_page_open",function()
                

                local root = ThePlayer.HUD.controls:AddChild(Screen())
                local main_scale = 0.6
                root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetPosition(0,0)
                root:MoveToBack()
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
    
                local bg = root:AddChild(Image("images/ui_images/fwd_in_pdt_cyclone_spell_page.xml","page.tex"))
                bg:SetScale(main_scale,main_scale,main_scale)
                bg:SetPosition(0,0)
    
                local temp_botton = root:AddChild(ImageButton(
                    "images/ui_images/fwd_in_pdt_cyclone_spell_page.xml",
                    "close.tex",
                    "close.tex",
                    "close.tex",
                    "close.tex",
                    "close.tex"
                ))
                temp_botton:SetScale(main_scale,main_scale,main_scale)
                temp_botton:SetPosition(400,230)
                temp_botton:SetOnDown(function()
                    root:Kill()
                end)


            end)
        end
    end)


    if TheWorld.ismastersim then
        inst:DoTaskInTime(3,function()
            if not inst.components.fwd_in_pdt_data:Get("cyclone_spell_introduction_page_open") then
                inst.components.fwd_in_pdt_data:Set("cyclone_spell_introduction_page_open",true)
                inst.components.fwd_in_pdt_com_rpc_event:PushEvent("cyclone_spell_introduction_page_open")                
            end
        end)
    end

end