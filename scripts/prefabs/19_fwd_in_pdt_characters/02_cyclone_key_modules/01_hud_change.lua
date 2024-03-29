--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----
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
----- 血量修改
    local function hook_health_bage(inst,HealthBadge)
        
        HealthBadge.anim:GetAnimState():SetMultColour(unpack({153/255,76/255,0/255,1}))

        HealthBadge.circleframe:GetAnimState():ClearOverrideSymbol("icon")
        HealthBadge.iconbuild = nil

        HealthBadge.__temp_fx = HealthBadge.anim:AddChild(UIAnim())
        HealthBadge.__temp_fx:GetAnimState():SetBank("fwd_in_pdt_hud_cyclone_health")
        HealthBadge.__temp_fx:GetAnimState():SetBuild("fwd_in_pdt_hud_cyclone_health")
        HealthBadge.__temp_fx:GetAnimState():PlayAnimation("idle",true)
        -- HealthBadge.__temp_fx:GetAnimState():GetAnimState():AnimateWhilePaused(true)
        local scale = 0.2
        HealthBadge.__temp_fx:SetScale(scale,scale,scale)
        HealthBadge.backing:GetAnimState():SetBank ("status_clear_bg")
        HealthBadge.backing:GetAnimState():SetBuild("status_clear_bg")
        HealthBadge.backing:GetAnimState():PlayAnimation("backing")
        
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- hunger 修改
    local function hook_hunger_bage(inst,HungerBadge)

        HungerBadge.anim:Hide()

        HungerBadge.circular_meter2 = HungerBadge:AddChild(UIAnim())
        HungerBadge.circular_meter2:GetAnimState():SetBank( "status_meter_circle")
        HungerBadge.circular_meter2:GetAnimState():SetBuild("status_meter_circle")
        HungerBadge.circular_meter2:GetAnimState():PlayAnimation("meter")
        HungerBadge.circular_meter2:GetAnimState():AnimateWhilePaused(false)

        HungerBadge.circular_meter2:GetAnimState():SetMultColour(unpack{0/255,255/255,255/255,1})
        HungerBadge.circular_meter2:GetAnimState():Pause()


        HungerBadge.backing:GetAnimState():SetBank ("status_clear_bg")
        HungerBadge.backing:GetAnimState():SetBuild("status_clear_bg")
        HungerBadge.backing:GetAnimState():PlayAnimation("backing")

        HungerBadge.circleframe:GetAnimState():ClearOverrideSymbol("icon")
        HungerBadge.iconbuild = nil


        HungerBadge.temp_number_arrow = HungerBadge:AddChild(UIAnim())
        HungerBadge.temp_number_arrow:GetAnimState():SetBank("fwd_in_pdt_hud_cyclone_status_meter_circle")
        HungerBadge.temp_number_arrow:GetAnimState():SetBuild("fwd_in_pdt_hud_cyclone_status_meter_circle")
        HungerBadge.temp_number_arrow:GetAnimState():PlayAnimation("idle")
        HungerBadge.temp_number_arrow:GetAnimState():AnimateWhilePaused(false)
        HungerBadge.temp_number_arrow:GetAnimState():Pause()
        local scale = 0.55
        HungerBadge.temp_number_arrow:SetScale(scale,scale,scale)
        -----------------------------------------------------------------------------
        ---- 事件监听
            HungerBadge.temp_number_arrow.inst:ListenForEvent("hungerdelta",function()
                local percent = inst.replica.hunger:GetPercent()
                HungerBadge.temp_number_arrow:GetAnimState():SetPercent("idle",1-percent)
                HungerBadge.circular_meter2:GetAnimState():SetPercent("meter",percent)
            end,inst)
            HungerBadge.circular_meter2:GetAnimState():SetPercent("meter",1)

        -----------------------------------------------------------------------------

        HungerBadge.temp_number_arrow:MoveToBack()
        HungerBadge.circular_meter2:MoveToBack()
        HungerBadge.backing:MoveToBack()

        
        local temperature_widget = HungerBadge:AddChild(UIAnim())
        temperature_widget:SetPosition(-50,0)
        temperature_widget:GetAnimState():SetBank("status_meter")
        temperature_widget:GetAnimState():SetBuild("status_meter")
        temperature_widget:GetAnimState():PlayAnimation("frame")
        temperature_widget:MoveToBack()
        local temperature_widget_bg = temperature_widget:AddChild(UIAnim())
        temperature_widget_bg:GetAnimState():SetBank("status_meter")
        temperature_widget_bg:GetAnimState():SetBuild("status_meter")
        temperature_widget_bg:GetAnimState():PlayAnimation("bg")
        temperature_widget_bg:MoveToBack()
        
        temperature_widget:SetRotation(90) -- 旋转90度
        local temperature_widget_scale = 0.8
        temperature_widget:SetScale(temperature_widget_scale,temperature_widget_scale,temperature_widget_scale)

        local temperature_str = HungerBadge:AddChild(Text(BODYTEXTFONT, 30))
        temperature_str:SetHAlign(ANCHOR_MIDDLE)
        temperature_str:SetPosition(-47,0)
        temperature_str:SetString("0℃")
        temperature_str:SetScale(0.8,1,1)
        ------------------------------------------------------------------------
        ---- 事件监听
            inst:ListenForEvent("cyclone_temperature_updata",function(inst,num)
                temperature_str:SetString(tostring(math.floor(num)).."℃")
            end)
        ------------------------------------------------------------------------
        ---- 拦截一些API
            HungerBadge.PulseGreen = function()                
            end
            HungerBadge.PulseRed = function()
            end
            HungerBadge.StartWarning = function()
            end
        ------------------------------------------------------------------------

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0.5,function()        
        if inst == ThePlayer and inst.HUD then
            hook_health_bage(inst,inst.HUD.controls.status.heart)
            hook_hunger_bage(inst,inst.HUD.controls.status.stomach)
        end
    end)
end