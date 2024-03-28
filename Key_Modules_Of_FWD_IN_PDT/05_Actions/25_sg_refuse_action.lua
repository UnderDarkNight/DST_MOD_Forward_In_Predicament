------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    拒绝动作

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------
    local function DoTalkSound(inst)
        if inst.talksoundoverride ~= nil then
            inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
            return true
        elseif not inst:HasTag("mime") then
            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/talk_LP", "talk")
            return true
        end
    end
    local function StopTalkSound(inst, instant)
        if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
            inst.SoundEmitter:PlaySound(inst.endtalksound)
        end
        inst.SoundEmitter:KillSound("talk")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "fwd_in_pdt_sg_action_refuse",
    tags = {  "busy", "pausepredict" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()

        if inst.components.rider:IsRiding() then
            DoTalkSound(inst)
            inst.AnimState:PlayAnimation("dial_loop")
        else
            DoTalkSound(inst)
            inst.AnimState:PlayAnimation(inst.components.inventory:IsHeavyLifting() and "heavy_refuseeat" or "refuseeat")
            inst.sg:SetTimeout(60 * FRAMES)
        end

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
        

    end,
    timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
            TimeEvent(22 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("pausepredict")
            end),

        },
    ontimeout = function(inst)
        StopTalkSound(inst)
    end,
    events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    onexit = function(inst)
        StopTalkSound(inst)
    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
    local TIMEOUT = 2
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_sg_action_refuse",
        tags = { },
        server_states = { "fwd_in_pdt_sg_action_refuse" },

        onenter = function(inst)

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