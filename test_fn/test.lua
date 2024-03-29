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
    ----
        -- local inst = ThePlayer
        -- local function hook_health_bage(inst,HealthBadge)
        --     HealthBadge.anim:GetAnimState():SetMultColour(unpack({153/255,76/255,0/255,1}))

        --     HealthBadge.circleframe:GetAnimState():ClearOverrideSymbol("icon")
        --     HealthBadge.iconbuild = nil

        --     if HealthBadge.__temp_fx then
        --         HealthBadge.__temp_fx:Kill()
        --     end
        --     HealthBadge.__temp_fx = HealthBadge.anim:AddChild(UIAnim())
        --     HealthBadge.__temp_fx:GetAnimState():SetBank("fwd_in_pdt_hud_cyclone_health")
        --     HealthBadge.__temp_fx:GetAnimState():SetBuild("fwd_in_pdt_hud_cyclone_health")
        --     HealthBadge.__temp_fx:GetAnimState():PlayAnimation("idle",true)
        --     -- HealthBadge.__temp_fx:GetAnimState():GetAnimState():AnimateWhilePaused(true)
        --     local scale = 0.2
        --     HealthBadge.__temp_fx:SetScale(scale,scale,scale)
        --     HealthBadge.backing:GetAnimState():SetBank ("status_clear_bg")
        --     HealthBadge.backing:GetAnimState():SetBuild("status_clear_bg")
        --     HealthBadge.backing:GetAnimState():PlayAnimation("backing")
        -- end
        -- hook_health_bage(inst,inst.HUD.controls.status.heart)
    ----------------------------------------------------------------------------------------------------------------
    ---- 虚线圈圈调试        
        -- fwd_in_pdt_fx_dotted_circle
        -- x,y,z = TheWorld.Map:GetTileCenterPoint(x,y,z)
        -- local fx = SpawnPrefab("fwd_in_pdt_fx_dotted_circle")
        -- fx:PushEvent("Set",{
        --     pt = Vector3(x,y,z),
        --     range = 2,
        -- })

        -- local pix_radious = 950
        -- local discanse_1_for_1_pix = 150

        -- local range = 4
        -- local scale = range * discanse_1_for_1_pix/pix_radious
        -- fx.AnimState:SetScale(scale,scale,scale)

        -- fx:DoTaskInTime(5,fx.Remove)
    ----------------------------------------------------------------------------------------------------------------
            if ThePlayer.__test_root then
                ThePlayer.__test_root:Kill()
                ThePlayer.__test_root = nil
            end


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
                ThePlayer.__test_root = nil
            end)
            ThePlayer.__test_root = root
            -- ThePlayer:DoTaskInTime(5,function()
            --     root:Kill()
            --     ThePlayer.__test_root = nil
            -- end)

    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))