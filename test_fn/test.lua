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
<<<<<<< HEAD
    -- miss 测试
                    
                    -- ThePlayer.components.combat:Fwd_In_Pdt_Add_Miss_Check(ThePlayer,function(targ,...)
                    --     print("Miss target",targ)
                    --     SpawnPrefab("fwd_in_pdt_fx_miss"):PushEvent("Set",{
                    --         target = targ,
                    --         speed = 2,
                    --     })
                    --     return true
                    -- end)
                     ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_attack_miss")

                    -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_attack_miss")
    ----------------------------------------------------------------------------------------------------------------
    -------
    -- 癫痫测试
        --ThePlayer.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")
        -- ThePlayer.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")
=======
    ----
        -- local BASE_SCALE = Vector3(0.5,0.5,0.5)
        -- local inst = ThePlayer
        -- inst.body_fx.AnimState:SetScale(0.5,0.5,0.5)
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- ThePlayer.components.freezable:Freeze(10)
        -- ThePlayer.___light___fx:Remove()

        SpawnPrefab("fwd_in_pdt_spell_time_stopper"):PushEvent("Set",{
            target = ThePlayer,
            range = 30,
            time = 30,
        })
>>>>>>> 85bd7551272cc5354244846ece50ed3abe47321d
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))
