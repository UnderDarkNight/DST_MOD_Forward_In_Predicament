-- require("componentactions")
-- local AddComponentAction = GLOBAL.AddComponentAction
--------------------------------------------------------------------------------
--- fwd_in_pdt_com_workable 的交互动作，可以自定义形态
--- hook GetActionFailString 函数可以做动作失败 str
--- 动作显示的文本 需要 和 index 对应。
--------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_com_workable"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end


-- local FWD_IN_PDT_COM_WORKABLE_ACTION = Action({mount_valid = true,distance = 6})
local FWD_IN_PDT_COM_WORKABLE_ACTION = Action({ priority=10 })   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_WORKABLE_ACTION.id = "FWD_IN_PDT_COM_WORKABLE_ACTION"
FWD_IN_PDT_COM_WORKABLE_ACTION.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    -- if act.doer then
    --     return "DEFAULT"
    -- end
    if act.target and act.target.components.fwd_in_pdt_com_workable then  --- 建筑类交互对象

        return act.target.components.fwd_in_pdt_com_workable:GetSGActionNameIndex()

    elseif act.invobject and act.invobject.components.fwd_in_pdt_com_workable then    -- 物品类交互对象

        return act.invobject.components.fwd_in_pdt_com_workable:GetSGActionNameIndex()
    end

end

FWD_IN_PDT_COM_WORKABLE_ACTION.fn = function(act)    --- 只在服务端执行~
    -- local inst = act.invobject
    -- local inst = act.target
    -- local doer = act.doer

    if  act.target and act.doer and act.target.components.fwd_in_pdt_com_workable then            ---- 建筑类
        local succeed,reason = act.target.components.fwd_in_pdt_com_workable:OnWork(act.doer)
        -- print("FWD_IN_PDT_COM_WORKABLE_ACTION  OnWork",succeed,reason)
        return succeed,reason
    elseif act.invobject and act.doer and act.invobject.components.fwd_in_pdt_com_workable then   ---- 物品类

        local succeed,reason = act.invobject.components.fwd_in_pdt_com_workable:OnWork(act.doer)
        -- print("FWD_IN_PDT_COM_WORKABLE_ACTION  OnWork",succeed,reason)
        return succeed,reason
    end
    return false
end

----- 玩家站的远的话，跑路开始的时候就执行了，没什么用。
-- FWD_IN_PDT_COM_WORKABLE_ACTION.pre_action_cb = function(act) -- client only  ， 执行动作前的预执行函数
--     if act.doer and  act.target and act.target.components.fwd_in_pdt_com_workable then  --- 建筑类交互对象
--         act.target.components.fwd_in_pdt_com_workable:DoPreActionFn(act.doer)
--     elseif act.doer and  act.invobject and act.invobject.components.fwd_in_pdt_com_workable then    -- 物品类交互对象
--         act.invobject.components.fwd_in_pdt_com_workable:DoPreActionFn(act.doer)
--     end
-- end


AddAction(FWD_IN_PDT_COM_WORKABLE_ACTION)

-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用,在背包里就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。


AddComponentAction("SCENE", "fwd_in_pdt_com_workable" , function(inst, doer, actions, right_click)-------    建筑一类的特殊交互使用
    if doer and inst and inst.components.fwd_in_pdt_com_workable and inst.components.fwd_in_pdt_com_workable:WorkTest(doer,right_click) then
        --   table.insert(actions, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION)
        table.insert(actions, ACTIONS[inst.components.fwd_in_pdt_com_workable:GetSGActionInserIndex()])
    end
end,modname)
AddComponentAction("INVENTORY", "fwd_in_pdt_com_workable" , function(inst, doer, actions, right_click)    -------    物品一类交互使用
    if doer and inst and inst.components.fwd_in_pdt_com_workable and inst.components.fwd_in_pdt_com_workable:WorkTest(doer,right_click) then
        --   table.insert(actions, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION)        
        table.insert(actions, ACTIONS[inst.components.fwd_in_pdt_com_workable:GetSGActionInserIndex()])
    end
end,modname)




AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_WORKABLE_ACTION,function(player)
    local creash_flag , ret = pcall(function()
        local inst = player.bufferedaction.target or player.bufferedaction.invobject
        local ret_action = inst.components.fwd_in_pdt_com_workable:GetSGAction()

        inst.components.fwd_in_pdt_com_workable:DoPreActionFn(player)
        return ret_action
    end)

    if creash_flag == true then
        return ret
    else
        print("error in 06_inst_workable_action__register.lua")
        print(ret)
    end
    return "dolongaction"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_WORKABLE_ACTION, function(player)
    -- print(player.bufferedaction)
    -- if type(player.bufferedaction) == "table" then
    --     for k, v in pairs(player.bufferedaction) do
    --         print(k,v)
    --     end
    -- end
    local creash_flag , ret = pcall(function()
        local inst = player.bufferedaction.target or player.bufferedaction.invobject
        local ret_action =  inst.components.fwd_in_pdt_com_workable:GetSGAction()
        inst.components.fwd_in_pdt_com_workable:DoPreActionFn(player)
        return ret_action
    end)

    if creash_flag == true then
        return ret
    else
        print("error in 06_inst_workable_action__register.lua")
        print(ret)            
    end
    return "dolongaction"
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION = {
    DEFAULT = GetStringsTable().DEFAULT
}

for index, str in pairs(GetStringsTable()) do
    STRINGS.ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION[string.upper(index)] = str
end

