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
                local fx = SpawnPrefab("fwd_in_pdt_fx_clock")
                fx:PushEvent("Set",{
                    pt = Vector3(x,3,z),
                    color = Vector3(255,0,0),
                    a = 0.7,
                    MultColour_Flag = true,
                    scale = 2,
                })
                fx.AnimState:SetOrientation(0)
                fx.AnimState:SetLayer(LAYER_WORLD)
                fx:DoTaskInTime(10,fx.Remove)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))