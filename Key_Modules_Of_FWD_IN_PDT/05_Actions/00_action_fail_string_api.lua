----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块用来hook GetActionFailString
--- 实现动作失败的时候说的话语
--- 通常来说，这个函数只在 server 端运行。但还是要注意一下组件的加载。
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


require("stringutil")
local temp_inst = CreateEntity()

temp_inst:DoTaskInTime(0.5,function()
    
    local old_fn = rawget(_G,"GetActionFailString")
    rawset(_G, "GetActionFailString_fwd_in_pdt_old", old_fn)

    rawset(_G,"GetActionFailString",function(inst,action,reason)
        -- print("info GetActionFailString" ,inst,action,reason)
        -- print(type(action))
        local crash_flag , ret = pcall(function()   ---- 避免崩溃
            local doer = inst
            local target = doer.bufferedaction.target
            local ret_str = nil
            if doer.components.fwd_in_pdt_com_action_fail_reason then
                ret_str = doer.components.fwd_in_pdt_com_action_fail_reason:Get_Custom_Fail_Str()
            end
            if ret_str == nil and target.components.fwd_in_pdt_com_action_fail_reason then
                ret_str = target.components.fwd_in_pdt_com_action_fail_reason:Get_Reason_Talk_Str(reason)
            end
            return ret_str
        end)

        if crash_flag == false or ret == nil then
            return GetActionFailString_fwd_in_pdt_old(inst,action,reason)
        else
            return ret 
        end
    end)

    temp_inst:Remove()
end)
