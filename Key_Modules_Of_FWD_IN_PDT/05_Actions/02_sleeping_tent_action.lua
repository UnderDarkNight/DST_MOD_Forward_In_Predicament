
--------------------------------------------------------------------------------
--- 自制帐篷组件相关动作
--- 
--------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "sleeping_tent_action"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end


-- local FWD_IN_PDT_SLEEPING_TENT = Action({mount_valid = true,distance = 6})
local FWD_IN_PDT_SLEEPING_TENT = Action()   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_SLEEPING_TENT.id = "FWD_IN_PDT_SLEEPING_TENT"
FWD_IN_PDT_SLEEPING_TENT.strfn = function(act)
    if act.doer then
        return "JOIN"
    end
end

FWD_IN_PDT_SLEEPING_TENT.fn = function(act)    --- 只在服务端执行~
    local inst = act.target
    local doer = act.doer
    if  inst and doer and inst.components.fwd_in_pdt_com_sleeping_tent and inst.components.fwd_in_pdt_com_sleeping_tent:Check_Can_Join(doer) then
            inst.components.fwd_in_pdt_com_sleeping_tent:DoSleep(doer)
        return true
    else
        return false
    end
end
AddAction(FWD_IN_PDT_SLEEPING_TENT)

-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，目标身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

    
AddComponentAction("SCENE", "fwd_in_pdt_com_sleeping_tent", function(inst, doer,actions, right)
    if doer and inst and inst.components.fwd_in_pdt_com_sleeping_tent and inst.components.fwd_in_pdt_com_sleeping_tent:Check_Can_Join(doer) then
        table.insert(actions, ACTIONS.FWD_IN_PDT_SLEEPING_TENT)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_SLEEPING_TENT,function(inst)
    -- return "give"
    return "fwd_in_pdt_sleeping_tent_action"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_SLEEPING_TENT, function(inst)
    -- return "give"
    return "fwd_in_pdt_sleeping_tent_action"
end))

STRINGS.ACTIONS.FWD_IN_PDT_SLEEPING_TENT = {
    -- JOIN = "进入",
    JOIN = GetStringsTable().join
}




---- 添加RPC，用于监控 键盘按下离开 帐篷,封装 RPC的调用 在 fwd_in_pdt_com_sleeping_tent.lua
---------------------------------------------------------------------------------------------------------------------------------
---------- RPC 下发 event 事件
AddClientModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"],"fwd_in_pdt_com_sleeping_tent.server2client",function(inst,data)
    if inst and data then               
        local _table = json.decode(data)
        if _table and inst.components and inst.components.fwd_in_pdt_com_sleeping_tent then
            _table.player = ThePlayer
            inst.components.fwd_in_pdt_com_sleeping_tent:rpc_func_run_in_client(_table)    ---- 执行 需要在客户端运行的程序
        end
    end
end)
-- SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_com_sleeping_tent.server2client"],inst.userid,inst,json.encode(json_data))
-- 给 指定userid 的客户端发送RPC，inst 可以是任何实体


---------- RPC 上传 event 事件
AddModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"], "fwd_in_pdt_com_sleeping_tent.client2server", function(player_inst,inst,data_json) ----- Register on the server
    -- 客户端回传 event 给 服务端,player_inst 为数据来源的玩家的inst。

    if player_inst and inst and data_json then
        local _table = json.decode(data_json)
        if _table and inst.components and inst.components.fwd_in_pdt_com_sleeping_tent then
            _table.player = player_inst
            inst.components.fwd_in_pdt_com_sleeping_tent:rpc_func_run_in_server(_table)    ---- 执行需要在服务端运行的程序
        end
    end
end)
-- SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_com_sleeping_tent.client2server"],inst,json.encode(data_table))

---------------------------------------------------------------------------------------------------------------------------------




local function DoYawnSound(inst)
    if inst.yawnsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.yawnsoundoverride)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/yawn")
    end
end
--------------------------------------------------------------------------------------------------------------------------------
----- server 上用的     -- 抄自SGwilson.lua 的 give,只改动画
local state_yawn_server = State{  --------------- give 拿来改，根据技能播放不同的声音。
    name = "fwd_in_pdt_sleeping_tent_action",
    tags = { "giving" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("yawn")
    end,

    timeline =
    {
        -- TimeEvent(20 * FRAMES, function(inst)
        --     inst:PerformBufferedAction()
        -- end),
        TimeEvent(15 * FRAMES, function(inst)
            DoYawnSound(inst)            
        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst:PerformBufferedAction()    ----- 这一句最重要，触发动作完成后的 代码执行。
                inst.sg:GoToState("idle")
            end
        end),
    },
}
AddStategraphState('wilson',state_yawn_server)
--------------------------------------------------------------------------------------------------------------------------------
--- client 上用的  抄自 SGwilson_client.lua  的 give ，只改动画，其他完全不动，避免bug
--- 网络卡顿的情况无法得到充分测试，其他玩家可能遭遇意想不到的延迟造成bug。
local TIMEOUT = 2
local state_yawn_client= State{
        name = "fwd_in_pdt_sleeping_tent_action",
        tags = { "giving" },
		server_states = { "give" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
			if not inst.sg:ServerStateMatches() then
                inst.AnimState:PlayAnimation("yawn")
            end

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("yawn")
                inst.sg:GoToState("idle", true)
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("yawn")
            inst.sg:GoToState("idle", true)
        end,
}
AddStategraphState('wilson_client',state_yawn_client)