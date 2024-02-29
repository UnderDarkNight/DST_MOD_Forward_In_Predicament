----------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    特殊自制笛子播放动作

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_com_telescope"
--     return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
-- end

local FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE = Action({priority = 50})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE.id = "FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE"
FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    -- local item = act.invobject
    -- local doer = act.doer
    return "DEFAULT"
end

FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    -- local target = act.target
    local doer = act.doer
    -- local pos = act.pos
    -- local_pt
    -- print("+++++66",item,doer,pos)
    -- if pos and doer and item and item.components.fwd_in_pdt_com_telescope then
    --     item.components.fwd_in_pdt_com_telescope:CastSpell(doer,pos.local_pt)
    -- end
    if item.components.fwd_in_pdt_com_play_flute then
        item.components.fwd_in_pdt_com_play_flute:CastSpell(doer)
    end

    return true
end
AddAction(FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE)

--[[
        以下这些只在客户端执行，30FPS

        AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
        AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
        AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
        AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
        AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。
            
]]--



AddComponentAction("INVENTORY", "fwd_in_pdt_com_play_flute", function(item, doer, actions, right)   ---- 拖到玩家自己身上就能用
    if item and doer then
        local replica_com = item.replica.fwd_in_pdt_com_play_flute or item.replica._.fwd_in_pdt_com_play_flute
        if replica_com and replica_com:Test(doer) then
            table.insert(actions, ACTIONS.FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE)
        end
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE,function(player)
    return "fwd_in_pdt_action_play_flute"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE, function(player)
    return "fwd_in_pdt_action_play_flute"
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_PLAY_FLUTE = {
    DEFAULT = STRINGS.ACTIONS.CASTSPELL.MUSIC
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    AddStategraphState("wilson",State{
        name = "fwd_in_pdt_action_play_flute",
        tags = { "doing", "busy", "canrotate","nointerrupt" },

        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("flute", false)

            local buffaction = inst:GetBufferedAction()
            if buffaction then

                local item = buffaction.invobject
                item.replica.fwd_in_pdt_com_play_flute:ActivePreAction(inst)

                local build = item.replica.fwd_in_pdt_com_play_flute:GetBuild()
                local layer = item.replica.fwd_in_pdt_com_play_flute:GetLayer()
                inst.AnimState:OverrideSymbol("pan_flute01", build or "pan_flute", layer or "pan_flute01")
                inst.sg.statemem.sound = item.replica.fwd_in_pdt_com_play_flute:GetSound()
            end


        end,
        timeline =
        {
            TimeEvent(30 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound(inst.sg.statemem.sound or "dontstarve/wilson/flute_LP", "flute")
                else
					inst.sg.statemem.action_failed = true
					inst.AnimState:SetFrame(94)
                end
            end),
			TimeEvent(36 * FRAMES, function(inst)
				if inst.sg.statemem.action_failed then
					inst.sg:RemoveStateTag("busy")
				end
			end),
			TimeEvent(52 * FRAMES, function(inst)
				if not inst.sg.statemem.action_failed then
					inst.sg:RemoveStateTag("busy")
				end
			end),
            TimeEvent(85 * FRAMES, function(inst)
				if not inst.sg.statemem.action_failed then
					inst.SoundEmitter:KillSound("flute")
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
            inst.SoundEmitter:KillSound("flute")
			inst.AnimState:ClearOverrideSymbol("pan_flute01")
        end,
    })

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
    local TIMEOUT = 2
    AddStategraphState("wilson_client",State{
        name = "fwd_in_pdt_action_play_flute",
        tags = { "doing", "busy", "canrotate","nointerrupt" },
        server_states = { "fwd_in_pdt_action_play_flute" },

        onenter = function(inst)
            -- if inst.components.playercontroller ~= nil then
            --     inst.components.playercontroller:Enable(false)
            -- end
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("flute", false)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
            -- print("client_fwd_in_pdt_wellness_cough")
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