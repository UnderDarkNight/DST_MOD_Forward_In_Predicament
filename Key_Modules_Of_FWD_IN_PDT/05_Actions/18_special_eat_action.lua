------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 特殊的吃东西动作 ，用 construct 改
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "fwd_in_pdt_special_eat",
    tags = { "doing", "busy", "canrotate","nointerrupt" },

    onenter = function(inst)
        -- if inst.components.playercontroller ~= nil then
        --     inst.components.playercontroller:Enable(false)
        -- end
        inst.components.locomotor:Stop()

        inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "fwd_in_pdt_special_eat")


        if inst.components.inventory:IsHeavyLifting() and
            not inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("heavy_eat")
        else
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat", false)
        end


    end,
    timeline =
        {

            TimeEvent(15 * FRAMES, function(inst)
                inst:PerformBufferedAction()                
            end),

			TimeEvent(130 * FRAMES, function(inst)
                inst.SoundEmitter:KillSound("fwd_in_pdt_special_eat")
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
			end),

        },
    events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
                inst.SoundEmitter:KillSound("fwd_in_pdt_special_eat")
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:PerformBufferedAction()

            end),
        },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("fwd_in_pdt_special_eat")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        inst:PerformBufferedAction()

    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
local TIMEOUT = 2
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_special_eat",
    tags = { "doing", "busy", "canrotate","nointerrupt"},
    server_states = { "fwd_in_pdt_special_eat" },

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