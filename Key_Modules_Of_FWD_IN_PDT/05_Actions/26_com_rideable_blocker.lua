--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

     所有物品挂上 交互组件，触发交互 函数。
     玩家身上挂上 检查组件和函数。
     
     
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




local FWD_IN_PDT_COM_RIDEABLE_BLOCKER = Action({priority = 999})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_RIDEABLE_BLOCKER.id = "FWD_IN_PDT_COM_RIDEABLE_BLOCKER"
FWD_IN_PDT_COM_RIDEABLE_BLOCKER.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    return "DEFAULT"
end

FWD_IN_PDT_COM_RIDEABLE_BLOCKER.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if doer and doer.components.fwd_in_pdt_rideable_blocker then
        doer.components.fwd_in_pdt_rideable_blocker:ActiveRefuse(target)
    end
    return true
end
AddAction(FWD_IN_PDT_COM_RIDEABLE_BLOCKER)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。


-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

-- 在后续注册了，这里暂时注释掉。


AddComponentAction("SCENE", "rideable" , function(inst, doer, actions, right_click)
    if doer then
        local replica_com = doer.replica.fwd_in_pdt_rideable_blocker or doer.replica._.fwd_in_pdt_rideable_blocker
        if replica_com then
            table.insert(actions,ACTIONS.FWD_IN_PDT_COM_RIDEABLE_BLOCKER)
        end
    end
end)


local handler_fn = function(player)
    local replica_com = player.replica.fwd_in_pdt_rideable_blocker or player.replica._.fwd_in_pdt_rideable_blocker
    if replica_com then
        return replica_com:GetRefuseSG() or "give"
    end
    return "give"
end

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_RIDEABLE_BLOCKER,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_RIDEABLE_BLOCKER, function(player)
    return handler_fn(player)
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_RIDEABLE_BLOCKER = STRINGS.ACTIONS.FWD_IN_PDT_COM_RIDEABLE_BLOCKER or {
    DEFAULT = STRINGS.ACTIONS.MOUNT
}



