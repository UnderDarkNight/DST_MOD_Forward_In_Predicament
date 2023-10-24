--- 本文件和 modmain.lua 平级。
--- 本文件集中注册  RPC 系统
--- RPC 可以实现  【客户端 → 服务端】  和  【服务端 → 客户端】 的单项传输。还可以【服务端 → 服务端】（地面和洞穴）之间的 数据传输。
--- 用于高即时性的数据传送和事件触发。 用于客户端触发服务端代码执行（界面按钮点击等），服务端触发客户端代码执行（界面弹出等）

-- 常用函数 ： AddClientModRPCHandler  SendModRPCToClient  SendModRPCToServer  AddModRPCHandler  AddShardModRPCHandler
-- 具体用法请参照 _DST_API.lua 和其他模组（官方基本不用RPC，没啥可参考的）
-- 注意RPC的命名空间（namespace）一致，推荐MOD英文名，可以所有RPC用同一个。 eventname 则是对应事件名字，不能重复。




---------------------------------------------------------------------------------------------------------------------------------
---------- RPC 下发 event 事件
    AddClientModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"],"pushevent.server2client",function(inst,data)
        -- print("pushevent.server2client")
        if inst and data then
            local _table = json.decode(data)
            if _table and _table.event_name then
                -- print(_table.event_name)
                inst:PushEvent(_table.event_name,_table.cmd_table or {})        
            end
        end
    end)
    -- SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))
    -- 给 指定userid 的客户端发送RPC


---------- RPC 上传 event 事件
    AddModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"], "pushevent.client2server", function(player_inst,inst,event_name,data_json) ----- Register on the server
        -- user in client : inst.replica.fwd_in_pdt_func:PushEvent("event_name",data)
        -- 客户端回传 event 给 服务端,player_inst 为来源玩家客户端。
        if inst and inst.PushEvent and event_name then
            local data = nil
            if data_json then
                data = json.decode(data_json)
            end
            inst:PushEvent(event_name,data)
        end
    end)
    -- SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.client2server"],self.inst,event_name,json.encode(data_table))

---------------------------------------------------------------------------------------------------------------------------------
-------- 跨存档数据传送
    AddClientModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"],"cross_archived_data.server2client",function(data_json)
        if  TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("RPC cross_archived_data.server2client",data_json)
        end
        local crash_flag,data_table = pcall(json.decode,data_json)
        if crash_flag and ThePlayer then
            ThePlayer:PushEvent("fwd_in_pdt_event.Set_Cross_Archived_Data_To_Client",data_table)
        end
    end)
    --- -- SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["cross_archived_data.server2client"],self.inst,json.encode(data or {}))

    AddModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"], "cross_archived_data.client2server", function(player_inst,data_json) ----- Register on the server
        -- user in client : inst.replica.fwd_in_pdt_func:PushEvent("event_name",data)
        -- 客户端回传 event 给 服务端,player_inst 为来源玩家客户端。
        if  TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("RPC cross_archived_data.client2server",player_inst,data_json)
        end
        if player_inst and data_json then
            local crash_flag ,data_table = pcall(json.decode,data_json)
            if crash_flag then
                player_inst:PushEvent("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",data_table)
            end
        end
    end)
    --- -- SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["cross_archived_data.client2server"],json.encode(data or {}))



---------------------------------------------------------------------------------------------------------------------------------