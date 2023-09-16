---------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用的物品法术施放sg，用来方便做特效添加到光环中间
--- 复制自 sg 的  name = "castspell"  部分，修改添加相关 API 
--- 重要参考 ： name = "cookbook_open",


--- API
--- item_inst.read_book_onenter_fn = function(item_inst,player_inst) ... end       ---- 给 onenter 里执行用的
--- item_inst.sound = ""                                       ---- 声音路径
--- item_inst.read_book_onexit_fn = func(item_inst,player).. end              ---- 给 onexit  里执行用的
--- item_inst.read_book_animover_fn = func(item_inst,player) ... end          ---- 给 animover event 里执行用的

--  图层替换参照 inst.AnimState:OverrideSymbol("book_cook", "cookbook", "book_cook")


--- 【注意】 骑牛和不骑牛的 区别
--- 【注意】 临时参数请挂载在  player.sg.statemem 的子节点里。并在用完后 nil

--- 【笔记】在角色动画player_actions_uniqueitem.scml 里
---  图层：  page_flip  书页翻动的时候 。可做特效锚点。
---  图层：  book_open   book_closed
---------------------------------------------------------------------------------------------------------------------------------------------------------
local TIMEOUT = 2
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 服务器上的  ，同 SGwilson.lua
AddStategraphState("wilson",State{
    name = "fwd_in_pdt_read_book_type_cookbook",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.AnimState:OverrideSymbol("book_cook", "cookbook", "book_cook")
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")   -- 0.267
        inst.AnimState:PushAnimation("reading_in", false)   -- 0.287s
        inst.AnimState:PushAnimation("reading_loop", false) -- 1.067s
        inst.AnimState:PushAnimation("reading_loop", false) -- 1.067s
        inst.AnimState:PushAnimation("reading_pst",false)   -- 0.6s
        inst.components.locomotor:Stop()

        inst.sg.statemem.castsound = "wickerbottom_rework/book_spells/upgraded_horticulture"

        -----------------------------------------------------------------------------------------------------------------------------------
            local item = inst.bufferedaction.invobject
            if item then

                if type(item.sound) == "string" then
                    inst.sg.statemem.castsound = item.sound
                end

                if type(item.read_book_onenter_fn) == "function" then
                    ---------------------------------------------------------------------------------------------------------
                        inst.sg.statemem.___fwd_spell_casting_item = item
                        item.read_book_onenter_fn(item,inst)
                    ---------------------------------------------------------------------------------------------------------

                    ---------------------------------------------------------------------------------------------------------
                end
                
            end
        -----------------------------------------------------------------------------------------------------------------------------------

    end,

    timeline =
    {
        TimeEvent(12 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/use_book_light","fwd_in_pdt_read_book_type_cookbook")
        end),
        TimeEvent(22 * FRAMES, function(inst)
            inst.SoundEmitter:KillSound("fwd_in_pdt_read_book_type_cookbook")
        end),
        TimeEvent(30 * FRAMES, function(inst)
            if inst.sg.statemem.castsound then
                inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound,"fwd_in_pdt_read_book_type_cookbook.reading")
                inst.sg.statemem.castsound = nil
            end
        end),
        TimeEvent(80 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end),
        TimeEvent(90 * FRAMES, function(inst)
            inst.SoundEmitter:KillSound("fwd_in_pdt_read_book_type_cookbook.reading")

            inst.sg:RemoveStateTag("busy")
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end

                if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn then
                    inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                    inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn = nil
                end

                if inst.sg.statemem.book_fx then
                    inst.sg.statemem.book_fx:Remove()
                    inst.sg.statemem.book_fx = nil
                end

        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
            ------- 
                if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.read_book_animover_fn then
                    inst.sg.statemem.___fwd_spell_casting_item.read_book_animover_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                    inst.sg.statemem.___fwd_spell_casting_item.read_book_animover_fn = nil
                end

        end),
    },

    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        ----- 方案 
            if inst.sg.statemem.___fwd_spell_casting_item and inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn then
                inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn(inst.sg.statemem.___fwd_spell_casting_item,inst)
                inst.sg.statemem.___fwd_spell_casting_item.read_book_onexit_fn = nil
            end
            inst.sg.statemem.___fwd_spell_casting_item = nil
        -----
            if inst.sg.statemem.book_fx then
                inst.sg.statemem.book_fx:Remove()
                inst.sg.statemem.book_fx = nil
            end

    end,

})
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 客户端上的，同 SGWilson_client.lua
AddStategraphState("wilson_client",State{
    name = "fwd_in_pdt_read_book_type_cookbook",
    tags = { "doing", "busy", "canrotate" },
    server_states = { "fwd_in_pdt_read_book_type_cookbook" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        -- inst.AnimState:PlayAnimation("book")


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