------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 修改官方动作 SHAVE 。使用该动作的时候出发event的时候出发事件
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local SHAVE = ACTIONS.SHAVE
if SHAVE then
    local old_shave_fn = SHAVE.fn
    SHAVE.fn = function(act)
        local ret = {old_shave_fn(act)}
        if act.invobject then
            local item = act.invobject
            local doer = act.doer
            local target = act.target
            -- print("ACTIONS.SHAVE",item,doer,target)
            local cmd_table = {
                item = item,
                doer = doer,
                target = target
            }
            if item then
                item:PushEvent("fwd_in_pdt_event.action.shave",cmd_table)
            end
            if doer then
                doer:PushEvent("fwd_in_pdt_event.action.shave",cmd_table)
            end
            if target then
                target:PushEvent("fwd_in_pdt_event.action.shave",cmd_table)
            end
        end

        return unpack(ret)
    end

end