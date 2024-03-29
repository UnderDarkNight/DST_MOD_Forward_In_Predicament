--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer:ListenForEvent("newstate",function(_,_table)
        --     print("state",_table and _table.statename)
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- local BASE_SCALE = Vector3(0.5,0.5,0.5)
        -- local inst = ThePlayer
        -- inst.body_fx.AnimState:SetScale(0.5,0.5,0.5)
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer.components.freezable:Freeze(10)
        -- ThePlayer.___light___fx:Remove()

        -- SpawnPrefab("fwd_in_pdt_spell_time_stopper"):PushEvent("Set",{
        --     target = ThePlayer,
        --     range = 30,
        --     time = 30,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ---- 技能立绘
            -- ThePlayer:PushEvent("fwd_in_pdt.drawing.display",{
            --     bank = "fwd_in_pdt_drawing_cyclone_spell_a",
            --     build = "fwd_in_pdt_drawing_cyclone_spell_a",
            --     anim = "idle",
            --     location = 9,
            --     pt = Vector3(0,0),
            --     scale = 0.7,
            -- })
    ----------------------------------------------------------------------------------------------------------------
                -- local fx = SpawnPrefab("fwd_in_pdt_fx_clock")
                -- fx:PushEvent("Set",{
                --     pt = Vector3(x,3,z),
                --     color = Vector3(255,0,0),
                --     a = 0.7,
                --     MultColour_Flag = true,
                --     scale = 2,
                -- })
                -- fx.AnimState:SetOrientation(0)
                -- fx.AnimState:SetLayer(LAYER_WORLD)
                -- fx:DoTaskInTime(10,fx.Remove)
    ----------------------------------------------------------------------------------------------------------------
    ------
        -- local inst = ThePlayer
        -- local function hook_hunger_bage(inst,HungerBadge)
            
        --     HungerBadge.anim:Hide()

        --     HungerBadge.circular_meter = HungerBadge:AddChild(UIAnim())
        --     HungerBadge.circular_meter:GetAnimState():SetBank( "status_meter_circle")
        --     HungerBadge.circular_meter:GetAnimState():SetBuild("status_meter_circle")
        --     HungerBadge.circular_meter:GetAnimState():PlayAnimation("meter")
        --     HungerBadge.circular_meter:GetAnimState():AnimateWhilePaused(true)

        --     HungerBadge.circular_meter:GetAnimState():SetMultColour(unpack{0/255,255/255,255/255,1})
        --     HungerBadge.circular_meter:GetAnimState():Pause()


        --     HungerBadge.backing:GetAnimState():SetBank ("status_clear_bg")
        --     HungerBadge.backing:GetAnimState():SetBuild("status_clear_bg")
        --     HungerBadge.backing:GetAnimState():PlayAnimation("backing")

        --     HungerBadge.circleframe:GetAnimState():ClearOverrideSymbol("icon")
        --     HungerBadge.iconbuild = nil

        --     if HungerBadge.temp_number_arrow then
        --         HungerBadge.temp_number_arrow:Kill()
        --     end
        --     HungerBadge.temp_number_arrow = HungerBadge:AddChild(UIAnim())
        --     HungerBadge.temp_number_arrow:GetAnimState():SetBank("fwd_in_pdt_hud_cyclone_status_meter_circle")
        --     HungerBadge.temp_number_arrow:GetAnimState():SetBuild("fwd_in_pdt_hud_cyclone_status_meter_circle")
        --     HungerBadge.temp_number_arrow:GetAnimState():PlayAnimation("idle")
        --     HungerBadge.temp_number_arrow:GetAnimState():AnimateWhilePaused(true)
        --     HungerBadge.temp_number_arrow:GetAnimState():Pause()
        --     local scale = 0.55
        --     HungerBadge.temp_number_arrow:SetScale(scale,scale,scale)
        --     HungerBadge.temp_number_arrow.inst:ListenForEvent("hungerdelta",function()
        --         local percent = inst.replica.hunger:GetPercent() - 0.001
        --         HungerBadge.temp_number_arrow:GetAnimState():SetPercent("idle",1-percent)
        --         HungerBadge.circular_meter:GetAnimState():SetPercent("meter",percent)
        --     end,inst)

        --     HungerBadge.temp_number_arrow:MoveToBack()
        --     HungerBadge.circular_meter:MoveToBack()
        --     HungerBadge.backing:MoveToBack()


        --     -- HungerBadge.circleframe:MoveToFront() --- 外框框
        --     -- HungerBadge.underNumber:MoveToFront() --- 数字
        --     -- HungerBadge.num:MoveToFront()
        -- end
        -- hook_hunger_bage(inst,inst.HUD.controls.status.stomach)
    ----------------------------------------------------------------------------------------------------------------
        local inst = ThePlayer
        local function hook_health_bage(inst,HealthBadge)
            HealthBadge.anim:GetAnimState():SetMultColour(unpack({153/255,76/255,0/255,1}))

            HealthBadge.circleframe:GetAnimState():ClearOverrideSymbol("icon")
            HealthBadge.iconbuild = nil

            if HealthBadge.__temp_fx then
                HealthBadge.__temp_fx:Kill()
            end
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
        hook_health_bage(inst,inst.HUD.controls.status.heart)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))