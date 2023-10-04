------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 咳嗽SG 动作，同时往玩家自身push event
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "fwd_in_pdt_play_horn",
    tags = { "doing", "busy", "canrotate","nointerrupt" },

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("horn", false)
        inst.AnimState:OverrideSymbol("horn01", "horn", "horn01")
        local item = inst.bufferedaction.invobject
        if item then
            local anim_build = item.AnimState:GetBuild()
            if anim_build then
                inst.AnimState:OverrideSymbol("horn01", anim_build, "horn01")
            end
        end
    end,
    timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                else
					inst.sg.statemem.action_failed = true
                end
            end),
			TimeEvent(29 * FRAMES, function(inst)
				if inst.sg.statemem.action_failed then
					inst.AnimState:SetFrame(50)
				end
			end),
			TimeEvent(34 * FRAMES, function(inst)
				if inst.sg.statemem.action_failed then
					inst.sg:RemoveStateTag("busy")
				end
			end),
			TimeEvent(43 * FRAMES, function(inst)
				if not inst.sg.statemem.action_failed then
					inst.sg:RemoveStateTag("busy")
				end
			end),
        },
    events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    onexit = function(inst)
        inst.AnimState:ClearOverrideSymbol("horn01")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
local TIMEOUT = 2
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_play_horn",
    tags = { "doing", "busy", "canrotate","nointerrupt" },
    server_states = { "fwd_in_pdt_play_horn" },

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
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