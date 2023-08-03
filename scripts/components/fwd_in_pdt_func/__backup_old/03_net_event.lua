------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件使用 net_string 广播下发数据，虽然比RPC响应慢一丢丢。不能用于 client2server 的交互。

---- net_vars 触发的 event 会在服务器和客户端 同时执行。注意 监听方 的Server和Client的区别。

---- 为下发的数据使用 时间戳 是为了避免 net_vars 不会下发重复的数据造成 事件无响应。

---- 【注意】函数需要在  TheWorld.ismastersim 的 return 前，inst.entity:SetPristine() 之后注册加载。

---- 注意下发的数据里不能包含 任何 inst ，json 无法编码 inst数据

---- 【特别注意】 超出玩家加载范围外的实体，是无法接受 net_vars 所广播下发的数据的。（OnEntitySleep/OnEntityWake）

---- 在 TheWorld.ismastersim return 前加载 fwd_in_pdt_func 组件会造成 replica 重复加载的问题。
---- 尤其是每次OnEntityWake的时候，客户端都会 重新注册replica。需要做避免阻塞崩溃的处理。
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return function(fwd_in_pdt_func)
    fwd_in_pdt_func.__net_string_event = net_string(fwd_in_pdt_func.inst.GUID,"fwd_in_pdt_net_sting", "fwd_in_pdt_net_string_event.pushevent")
    fwd_in_pdt_func.inst:ListenForEvent("fwd_in_pdt_net_string_event.pushevent",function()
        local json_data = fwd_in_pdt_func.__net_string_event:value()
        local cmd_table = json.decode(json_data)
        local event_name = cmd_table.event_name
        local event_data_table = cmd_table.event_data_table
        fwd_in_pdt_func.inst:PushEvent(event_name,event_data_table)
    end)
    function fwd_in_pdt_func:Net_PushEvent(event_name,event_data_table)   --- 只允许服务器使用
        if event_name == nil or type(event_name) ~= "string" or not TheWorld.ismastersim then
            return
        end
        event_data_table = event_data_table or {}
        local cmd_table = {
            event_name = event_name,
            event_data_table = event_data_table,
            date_test_66666666 = os.date("%Y-%m-%d %H:%M:%S");   --- 创建个时间戳，避免重复下发event 的时候 net_string 不做任何事。
        }
        local json_data = json.encode(cmd_table)
        fwd_in_pdt_func.__net_string_event:set(json_data) --- 发送数据
    end

    -- ------ 阻塞崩溃处理  -- 模块暂时独立出去
    -- ------ 在客户端， OnEntityWake 的时候会重新注册一次 组件的replica。 
    -- if fwd_in_pdt_func.inst.ReplicateComponent__fwd_in_pdt_old == nil then
    --         fwd_in_pdt_func.inst.ReplicateComponent__fwd_in_pdt_old = fwd_in_pdt_func.inst.ReplicateComponent
    --         fwd_in_pdt_func.inst.ReplicateComponent = function(inst,name)
    --             if name == "fwd_in_pdt_func" and inst.replica and inst.replica.fwd_in_pdt_func ~= nil then
    --                 -- print("error : ReplicateComponent fwd_in_pdt_func")
    --                 return
    --             end
    --             inst:ReplicateComponent__fwd_in_pdt_old(name)
    --         end
    -- end

end