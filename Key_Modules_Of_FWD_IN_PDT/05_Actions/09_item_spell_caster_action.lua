---------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用的物品法术施放sg，用来方便做特效添加到光环中间
--- 复制自 sg 的  name = "castspell"  部分，修改添加相关 API

--- item_inst.fx_prefab = ""
--- item_inst.sound = ""
--- item_inst.color = { r, g , b , a}   --- 光线的颜色
---------------------------------------------------------------------------------------------------------------------------------------------------------
local TIMEOUT = 2
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 服务器上的  ，同 SGwilson.lua
AddStategraphState("wilson",State{
    name = "fwd_in_pdt_castspell",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.AnimState:PlayAnimation("staff_pre")
        inst.AnimState:PushAnimation("staff", false)
        inst.components.locomotor:Stop()
        -----------------------------------------------------------------------------------------------------------------------------------
                        --Spawn an effect on the player's location
                        -- local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        -- local colour = staff ~= nil and staff.fxcolour or { 1, 1, 1 }

                        -- inst.sg.statemem.stafffx = SpawnPrefab(inst.components.rider:IsRiding() and "staffcastfx_mount" or "staffcastfx")
                        -- inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
                        -- inst.sg.statemem.stafffx:SetUp(colour)

                        -- inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
                        -- inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
                        -- inst.sg.statemem.stafflight:SetUp(colour, 1.9, .33)

                        -- if staff ~= nil and staff.components.aoetargeting ~= nil then
                        --     local buffaction = inst:GetBufferedAction()
                        --     if buffaction ~= nil then
                        --         inst.sg.statemem.targetfx = staff.components.aoetargeting:SpawnTargetFXAt(buffaction:GetDynamicActionPoint())
                        --         if inst.sg.statemem.targetfx ~= nil then
                        --             inst.sg.statemem.targetfx:ListenForEvent("onremove", OnRemoveCleanupTargetFX, inst)
                        --         end
                        --     end
                        -- end
                        -- if staff ~= nil then
                        --     inst.sg.statemem.castsound = staff.skin_castsound or staff.castsound or "dontstarve/wilson/use_gemstaff"
                        -- else
                        --     inst.sg.statemem.castsound = "dontstarve/wilson/use_gemstaff"
                        -- end
        -----------------------------------------------------------------------------------------------------------------------------------
            local item = inst.bufferedaction.invobject
            if item then
                local staff_fx_name = inst.components.rider:IsRiding() and "staffcastfx_mount" or "staffcastfx"
                local light_inst = inst:SpawnChild(staff_fx_name)
                ---- 光线中间
                if type(item.fx_prefab) == "string" then
                    local fx = SpawnPrefab(item.fx_prefab)
                    if fx then
                        light_inst.__fx = fx
                        fx.entity:SetParent(light_inst.entity)
                        fx.entity:AddFollower()
                        fx.Follower:FollowSymbol(light_inst.GUID, "FX", 0, 0, 1)
                    end
                end


                if type(item.sound) == "string" then
                    inst.sg.statemem.castsound = item.sound
                end


                light_inst:ListenForEvent("animover",function()
                    if light_inst.__fx then
                        light_inst:Remove()
                    end
                    light_inst:Remove()
                end)

            end
        -----------------------------------------------------------------------------------------------------------------------------------

    end,

    timeline =
    {
        TimeEvent(13 * FRAMES, function(inst)
            if inst.sg.statemem.castsound then
                inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
                inst.sg.statemem.castsound = nil
            end
        end),
        TimeEvent(53 * FRAMES, function(inst)
            -- if inst.sg.statemem.targetfx ~= nil then
            --     if inst.sg.statemem.targetfx:IsValid() then
            --         OnRemoveCleanupTargetFX(inst)
            --     end
            --     inst.sg.statemem.targetfx = nil
            -- end
            -- inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
            -- inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
            -- --V2C: NOTE! if we're teleporting ourself, we may be forced to exit state here!
            inst:PerformBufferedAction()
        end),
        TimeEvent(69 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
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
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end

    end,

})
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 客户端上的，同 SGWilson_client.lua
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_castspell",
    tags = { "doing", "busy", "canrotate" },
    server_states = { "castspell" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("staff_pre")
        inst.AnimState:PushAnimation("staff_lag", false)

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