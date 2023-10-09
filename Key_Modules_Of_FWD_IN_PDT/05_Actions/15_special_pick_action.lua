------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 特殊的采集动作 ，用 construct 改
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "fwd_in_pdt_special_pick",
    tags = { "doing","canrotate" },

    onenter = function(inst)
        -- if inst.components.playercontroller ~= nil then
        --     inst.components.playercontroller:Enable(false)
        -- end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("construct_pre")
        inst.AnimState:PushAnimation("construct_loop", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "fwd_in_pdt_special_pick")
    end,
    timeline =
        {

			TimeEvent(60 * FRAMES, function(inst)
                inst.SoundEmitter:KillSound("fwd_in_pdt_special_pick")
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
			end),

        },
    events =
        {
            -- EventHandler("animqueueover", function(inst)
            --     if inst.AnimState:AnimDone() then
            --         inst.sg:GoToState("idle")
            --     end
            -- end),
        },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("fwd_in_pdt_special_pick")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
local TIMEOUT = 2
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_special_pick",
    tags = { "doing","canrotate" },
    server_states = { "fwd_in_pdt_special_pick" },

    onenter = function(inst)
        -- if inst.components.playercontroller ~= nil then
        --     inst.components.playercontroller:Enable(false)
        -- end
        inst.components.locomotor:Stop()
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
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
    end,
})