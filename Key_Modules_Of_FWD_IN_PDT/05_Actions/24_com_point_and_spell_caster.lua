--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

     点、目标  技能施放组件
     
     
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




local FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER = Action({priority = 10})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER.id = "FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER"
FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local item = act.invobject
    local target = act.target
    local doer = act.doer
    local pos = act.pos or {}
    if item then
        local replica_com = item.replica.fwd_in_pdt_com_point_and_target_spell_caster or item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
        if replica_com then
            replica_com:ActiveTextUpdate(doer,target,pos.local_pt)
            return replica_com:GetTextIndex()
        end
    end
    return "DEFAULT"
end

FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer
    local pos = act.pos or {}

    if item and doer and item.components.fwd_in_pdt_com_point_and_target_spell_caster then
        local replica_com = item.replica.fwd_in_pdt_com_point_and_target_spell_caster or item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
        if replica_com and replica_com:Test(doer, target, pos.local_pt,true) then
            return item.components.fwd_in_pdt_com_point_and_target_spell_caster:CastSpell(doer, target,pos.local_pt)
        end
    end
    return false
end
AddAction(FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。


-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

-- 在后续注册了，这里暂时注释掉。
---------------------------------------------------------
---- 为了避免多个inst用同一个动作造成冲突，调用前清除一些额外插入的参数。（没法用deepcopy 只能这样）
    local base_index = {
        ["ghost_valid"] = true,
        ["id"] = true,
        ["instant"] = true,
        ["code"] = true,
        ["ghost_exclusive"] = true,
        ["mod_name"] = true,
        ["paused_valid"] = true,
        ["strfn"] = true,
        ["fn"] = true,
        ["encumbered_valid"] = true,
        ["mount_valid"] = true,
    }
    local function GetAction()
        local temp_action = ACTIONS.FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER
        for index, v in pairs(base_index) do
            if temp_action[index] then

            else
                temp_action[index] = nil
            end
        end
        return temp_action
    end
---------------------------------------------------------


AddComponentAction("POINT", "fwd_in_pdt_com_point_and_target_spell_caster",function(item, doer, pos, actions, right_click)   ------ 指定坐标位置用。
    if item and doer and pos then
        local replica_com = item.replica.fwd_in_pdt_com_point_and_target_spell_caster or item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
        if replica_com and replica_com:Test(doer,nil,pos,right_click) then
            -- local temp_action = ACTIONS.FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER
            local temp_action = GetAction()
            temp_action.distance = replica_com:GetDistance()
            temp_action.priority = replica_com:GetPriority()
            replica_com:ActiveActionParam(temp_action)
            table.insert(actions, temp_action)
        end
    end
end)

AddComponentAction("EQUIPPED", "fwd_in_pdt_com_point_and_target_spell_caster",function(item, doer, target, actions, right_click)    --- 装备后多个技能
    if item and doer and target then
        local replica_com = item.replica.fwd_in_pdt_com_point_and_target_spell_caster or item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
        if replica_com and replica_com:Test(doer,target,nil,right_click) then
            -- local temp_action = ACTIONS.FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER
            local temp_action = GetAction()
            temp_action.distance = replica_com:GetDistance()
            temp_action.priority = replica_com:GetPriority()
            replica_com:ActiveActionParam(temp_action)
            table.insert(actions, temp_action)
        end
    end
end)



local handler_fn = function(player)
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local item = player.bufferedaction.invobject
        local pos = player.bufferedaction.pos or {}

        local replica_com = item.replica.fwd_in_pdt_com_point_and_target_spell_caster or item.replica._.fwd_in_pdt_com_point_and_target_spell_caster
        if replica_com  then
            replica_com:DoPreAction(player,target,pos.local_pt)
            return replica_com:GetSGAction()
        end
        return "give"
    end)
    if creash_flag == true then
        return ret
    else
        print("error in FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER ActionHandler")
        print(ret)
    end
    return "give"
end

AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER, function(player)
    return handler_fn(player)
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER = STRINGS.ACTIONS.FWD_IN_PDT_COM_POINT_AND_TARGET_SPELL_CASTER or {
    DEFAULT = STRINGS.ACTIONS.CASTSPELL.GENERIC
}



