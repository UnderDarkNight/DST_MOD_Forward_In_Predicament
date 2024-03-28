-- require("componentactions")
-- local AddComponentAction = GLOBAL.AddComponentAction

--------------------------------------------------------------------------------
--- fwd_in_pdt_com_special_acceptable 的交互动作，可以自定义形态
--- hook GetActionFailString 函数可以做动作失败 str
--- 动作显示的文本 需要 和 index 对应。
--------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_com_special_acceptable"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end


-- local FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION = Action({mount_valid = true,distance = 6})
local FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION = Action({priority = 10})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION.id = "FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION"
FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    -- if act.doer then
    --     return "DEFAULT"
    -- end
    if act.target and act.target.components.fwd_in_pdt_com_special_acceptable then
        return act.target.components.fwd_in_pdt_com_special_acceptable:GetActionDisplayStrIndex()
    end
end

FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if  target and doer and target.components.fwd_in_pdt_com_special_acceptable then
        local succeed,reason = target.components.fwd_in_pdt_com_special_acceptable:OnAccept(item,doer)
        -- print("FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION  OnAccept",succeed,reason)
        return succeed,reason
    end
    return false
end
AddAction(FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。

-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。


AddComponentAction("USEITEM", "inventoryitem", function(item, doer, target, actions, right_click) -- -- 一个物品对另外一个目标用的技能，
    ---- 试着同时兼容 简单 fwd_in_pdt_com_acceptable 组件和高阶 fwd_in_pdt_com_special_acceptable 组件
    if doer and item and target then
 
            if target.components.fwd_in_pdt_com_special_acceptable and target.components.fwd_in_pdt_com_special_acceptable:AcceptTest(item,doer,right_click) then
                --   table.insert(actions, ACTIONS.FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION)
                table.insert(actions, ACTIONS[target.components.fwd_in_pdt_com_special_acceptable:GetSGActionInserIndex()])
                
            elseif target.components.fwd_in_pdt_com_acceptable and target.components.fwd_in_pdt_com_acceptable:AcceptTest(item,doer,right_click) then

                table.insert(actions, ACTIONS[target.components.fwd_in_pdt_com_acceptable:GetSGActionInserIndex()])

            end
    end
end,modname)


AddStategraphActionHandler("wilson",ActionHandler(FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION,function(player)
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local ret_action =  target.components.fwd_in_pdt_com_special_acceptable:GetSGAction()
        target.components.fwd_in_pdt_com_special_acceptable:DoPreActionFn(player.bufferedaction.invobject,player)
        return ret_action
    end)

    if creash_flag == true then
        return ret
    end
    return "give"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION, function(player)
    -- print(player.bufferedaction)
    -- if type(player.bufferedaction) == "table" then
    --     for k, v in pairs(player.bufferedaction) do
    --         print(k,v)
    --     end
    -- end
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local ret_action =  target.components.fwd_in_pdt_com_special_acceptable:GetSGAction()
        target.components.fwd_in_pdt_com_special_acceptable:DoPreActionFn(player.bufferedaction.invobject,player)
        return ret_action
    end)

    if creash_flag == true then
        return ret
    end
    return "give"
end))


STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION = {
    DEFAULT = GetStringsTable().DEFAULT
}

for index, str in pairs(GetStringsTable()) do
    STRINGS.ACTIONS.FWD_IN_PDT_COM_SPECIAL_ACCEPTABLE_ACTION[string.upper(index)] = str
end

