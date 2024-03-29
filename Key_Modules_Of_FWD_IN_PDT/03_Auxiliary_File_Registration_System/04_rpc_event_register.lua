--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    注册客户端 <---> 服务端来回传送数据的RPC管道


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------
---------- RPC 下发 event 事件
-- AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client",function(inst,data)
--     -- print("pushevent.server2client")
--     if inst and data then
--         local _table = json.decode(data)
--         if _table and _table.event_name then
--             -- print(_table.event_name)
--             inst:PushEvent(_table.event_name,_table.cmd_table or {})        
--         end
--     end
-- end)
-- -- SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))
-- -- 给 指定userid 的客户端发送RPC


-- ---------- RPC 上传 event 事件
-- AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server", function(player_inst,inst,event_name,data_json) ----- Register on the server
--     -- user in client : inst.replica.fwd_in_pdt_func:PushEvent("event_name",data)
--     -- 客户端回传 event 给 服务端,player_inst 为来源玩家客户端。
--     if inst and inst.PushEvent and event_name then
--         local data = nil
--         if data_json then
--             data = json.decode(data_json)
--         end
--         inst:PushEvent(event_name,data)
--     end
-- end)
-- -- SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server"],self.inst,event_name,json.encode(data_table))

---------------------------------------------------------------------------------------------------------------------------------
---- 数据下发

    local function pushevent_server2client(inst,data,tar_inst)
        if inst and data then
            local _table = json.decode(data)

            if _table and _table.event_name then
                if tar_inst then
                    tar_inst:PushEvent(_table.event_name,_table.event_data or {})
                else
                    inst:PushEvent(_table.event_name,_table.event_data or {})
                end
                -- print(_table.event_name)
            end
        end
    end


    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client.1",function(inst,data,tar_inst)
        pushevent_server2client(inst,data,tar_inst)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client.2",function(inst,data,tar_inst)
        pushevent_server2client(inst,data,tar_inst)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client.3",function(inst,data,tar_inst)
        pushevent_server2client(inst,data,tar_inst)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client.4",function(inst,data,tar_inst)
        pushevent_server2client(inst,data,tar_inst)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","pushevent.server2client.5",function(inst,data,tar_inst)
        pushevent_server2client(inst,data,tar_inst)
    end)
-- SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))


---------------------------------------------------------------------------------------------------------------------------------
---- 数据上传

    local function pushevent_client2server(player_inst,data_json,tar_inst)
        -- print("info server side ",player_inst,data_json)
        pcall(function()
           local event_cmd = json.decode(data_json)
           if event_cmd.event_name then
                if tar_inst then
                    tar_inst:PushEvent(event_cmd.event_name,event_cmd.event_data)
                else
                    player_inst:PushEvent(event_cmd.event_name,event_cmd.event_data)
                end                
           end
        end)
    end

    AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server.1", function(player_inst,inst,data_json,tar_inst) ----- Register on the server
        pushevent_client2server(player_inst,data_json,tar_inst)
    end)
    AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server.2", function(player_inst,inst,data_json,tar_inst) ----- Register on the server
        pushevent_client2server(player_inst,data_json,tar_inst)
    end)
    AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server.3", function(player_inst,inst,data_json,tar_inst) ----- Register on the server
        pushevent_client2server(player_inst,data_json,tar_inst)
    end)
    AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server.4", function(player_inst,inst,data_json,tar_inst) ----- Register on the server
        pushevent_client2server(player_inst,data_json,tar_inst)
    end)
    AddModRPCHandler("fwd_in_pdt_rpc_namespace", "pushevent.client2server.5", function(player_inst,inst,data_json,tar_inst) ----- Register on the server
        pushevent_client2server(player_inst,data_json,tar_inst)
    end)
-- -- SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server"],self.inst,json.encode(data_table))
