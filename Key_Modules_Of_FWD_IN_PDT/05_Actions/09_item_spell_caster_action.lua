---------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用的物品法术施放sg，用来方便做特效添加到光环中间
--- 复制自 sg 的  name = "castspell"  部分，修改添加相关 API

--- 【原始】API 使用方案 1：
--- item_inst.fx_prefab = ""                  --- 中间特效的 prefab
--- item_inst.spellsound = ""                 --- 声音路径
--- item_inst.light_color = { r, g , b , a}   --- 光线的颜色



--- 【推荐】API 使用方案 2： 
--- item_inst.castspell_onenter_fn = function(item_inst,player_inst) ... end       ---- 给 onenter 里执行用的
--- item_inst.spellsound = ""                                       ---- 声音路径
--- item_inst.castspell_onexit_fn = func(item_inst,player).. end              ---- 给 onexit  里执行用的
--- item_inst.castspell_animover_fn = func(item_inst,player) ... end          ---- 给 animover event 里执行用的
--  【提示】 如果不知道方案2 怎么用，请看 方案1里的执行代码，理解逻辑原理就行了。
--- 【注意】 骑牛和不骑牛的 区别
--- 【注意】 临时参数请挂载在  player.sg.statemem 的子节点里。并在用完后 nil
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
            local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item then

                if type(item.spellsound) == "string" then
                    inst.sg.statemem.castsound = item.spellsound
                end

                if type(item.castspell_onenter_fn) == "function" then
                    ---------------------------------------------------------------------------------------------------------
                    --- 方案 2：
                        inst.sg.statemem.___fwd_spell_casting_item = item
                        item.castspell_onenter_fn(item,inst)
                    ---------------------------------------------------------------------------------------------------------
                else
                    ---------------------------------------------------------------------------------------------------------
                    --- 方案1 
                        if weapon and weapon ~= item then
                            inst.sg.statemem.__need_2_hide_in_hand_weapon = true
                            inst.AnimState:HideSymbol("swap_object")
                        end

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


                        if type(item.light_color) and  item.light_color[1] and item.light_color[2] and item.light_color[3] then
                            local r,g,b,a =  item.light_color[1] , item.light_color[2] , item.light_color[3] , item.light_color[4] or 1
                            light_inst.AnimState:SetMultColour(r,g,b,a)
                        end

                        light_inst:ListenForEvent("animover",function()
                            if light_inst.__fx then
                                light_inst:Remove()
                            end
                            light_inst:Remove()
                        end)
                    ---------------------------------------------------------------------------------------------------------
                end

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

                ----- 方案 1
                if inst.sg.statemem.__need_2_hide_in_hand_weapon then
                    inst.sg.statemem.__need_2_hide_in_hand_weapon = nil
                    inst.AnimState:ShowSymbol("swap_object")
                end
        
                ----- 方案 2
                if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn then
                    inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                    inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn = nil
                end

        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
            ------- 方案 1
                if inst.sg.statemem.__need_2_hide_in_hand_weapon then
                    inst.sg.statemem.__need_2_hide_in_hand_weapon = nil
                    inst.AnimState:ShowSymbol("swap_object")
                end

            ------- 方案 2
                if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.castspell_animover_fn then
                    inst.sg.statemem.___fwd_spell_casting_item.castspell_animover_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                    inst.sg.statemem.___fwd_spell_casting_item.castspell_animover_fn = nil
                end

        end),
    },

    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        ----- 方案 1
            if inst.sg.statemem.__need_2_hide_in_hand_weapon then
                inst.sg.statemem.__need_2_hide_in_hand_weapon = nil
                inst.AnimState:ShowSymbol("swap_object")
            end

        ----- 方案 2
            if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn then
                inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                inst.sg.statemem.___fwd_spell_casting_item.castspell_onexit_fn = nil
            end
            inst.sg.statemem.___fwd_spell_casting_item = nil

    end,

})
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 客户端上的，同 SGWilson_client.lua
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_castspell",
    tags = { "doing", "busy", "canrotate" },
    server_states = { "fwd_in_pdt_castspell" },

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