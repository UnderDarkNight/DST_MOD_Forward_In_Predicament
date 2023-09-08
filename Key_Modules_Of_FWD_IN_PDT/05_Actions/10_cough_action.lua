------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 咳嗽SG 动作，同时往玩家自身push event
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "fwd_in_pdt_wellness_cough",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("sing_fail", false)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/characters/wathgrithr/fail")
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("info +++++++++++++++++++ 开始咳嗽")
        end
    end,
    timeline =
    {
        TimeEvent(13 * FRAMES, function(inst)
            -- if inst.sg.statemem.castsound then
            --     inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
            --     inst.sg.statemem.castsound = nil
            -- end
            inst:PushEvent("fwd_in_pdt_wellness.cough_start")

        end),
    },
    events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end

            end),
        },
    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        inst:PushEvent("fwd_in_pdt_wellness.cough_end")
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("info +++++++++++++++++++ 咳嗽结束")
        end
    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 客户端上的，同 SGWilson_client.lua
local TIMEOUT = 2
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_wellness_cough",
    tags = { "doing", "busy", "canrotate" },
    server_states = { "fwd_in_pdt_wellness_cough" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("sing_fail",false)
        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst)
        if inst.sg:ServerStateMatches() then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})