------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块用来修改  inst.sg:GoToState,实现 进入响应的 state 的时候 pushevent
--- DoTaskInTime 0 的时候执行hook，避免加载过早造成bug。
--- 允许 client hook
--- ThePlayer.components.fwd_in_pdt_func:Add_SG_State_Listener("atk",function(inst,params) end)
--- hook 执行函数在真正的 GoToState之前，可以进行 action_buffer 相关的修改。如果非要在 GoToState 之后，

--- onenter 函数之后，可以利用官方的 self.inst:PushEvent("newstate", {statename = statename})

--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
--- 【注意】使用官方的 Event newstate 可以解决大部分问题了，实在特殊才启用本模块（比如 client 相关的特殊动作）
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return function(fwd_in_pdt_func)
    fwd_in_pdt_func.tempData.____sg_event_listeners = {}
    fwd_in_pdt_func.inst:DoTaskInTime(0,function(inst)
        if inst.sg and inst.sg.GoToState then
                ------------------------------------------------------------
                inst.sg.GoToState___fwd_in_pdt_old = inst.sg.GoToState
                inst.sg.GoToState = function(sg,statename,params,...)
                    -- sg:GoToState___fwd_in_pdt_old(statename,params,...)
                    -- print("GoToState",statename)
                    if sg.inst and sg.inst.components.fwd_in_pdt_func.SG_State_Event_Push then      --- 触发 event 事件
                        sg.inst.components.fwd_in_pdt_func:SG_State_Event_Push(statename,params)
                    end
                    sg:GoToState___fwd_in_pdt_old(statename,params,...)

                end
                
                ------------------------------------------------------------
        else
            print("error : 06_sg_event_listener.lua    sg is nil")
        end
    end)


    function fwd_in_pdt_func:Add_SG_State_Listener(event_name,fn)
        self.tempData.____sg_event_listeners[event_name] = self.tempData.____sg_event_listeners[event_name] or {}   -- 初始化

        table.insert(self.tempData.____sg_event_listeners[event_name],fn)
    end
    function fwd_in_pdt_func:Remove_SG_State_Listener(event_name,fn)
        self.tempData.____sg_event_listeners[event_name] = self.tempData.____sg_event_listeners[event_name] or {}   -- 初始化
        local new_table = {}
        for k, temp_fn in pairs(self.tempData.____sg_event_listeners[event_name]) do
            if temp_fn ~= fn then
                table.insert(new_table,temp_fn)
            end
        end
        self.tempData.____sg_event_listeners[event_name] = new_table
    end

    function fwd_in_pdt_func:SG_State_Event_Push(event_name,params)
        ---- 不监听执行持续的事件（比如 run ）
        if event_name == self.tempData.____sg_event_listeners_last 
            or self.tempData.____sg_event_listeners[event_name] == nil 
            or #self.tempData.____sg_event_listeners[event_name] == 0 then
            return
        end
        self.tempData.____sg_event_listeners_last = event_name
        -- print("SG_State_Event_Push",event_name)
        local fn_tables = self.tempData.____sg_event_listeners[event_name] 
        if fn_tables and #fn_tables > 0 then
            for k, fn in pairs( self.tempData.____sg_event_listeners[event_name] ) do
                fn(self.inst,params)
            end
        end

    end

end