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

    local function main_rpc_api__server2client(inst,data)
        if inst and data then
            -- local _table = json.decode(data)
            local crash_flag,ret_table = pcall(json.decode,data)

            if crash_flag and type(ret_table) == "table" and inst then
                local replica_com = inst.replica.fwd_in_pdt_com_tag_sys or inst.replica._.fwd_in_pdt_com_tag_sys
                if replica_com then
                    replica_com:SwitchTagByCMD(ret_table)
                end
            end
        end
    end


    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","fwd_in_pdt_com_tag_sys.server2client.1",function(inst,data)
        main_rpc_api__server2client(inst,data)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","fwd_in_pdt_com_tag_sys.server2client.2",function(inst,data)
        main_rpc_api__server2client(inst,data)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","fwd_in_pdt_com_tag_sys.server2client.3",function(inst,data)
        main_rpc_api__server2client(inst,data)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","fwd_in_pdt_com_tag_sys.server2client.4",function(inst,data)
        main_rpc_api__server2client(inst,data)
    end)
    AddClientModRPCHandler("fwd_in_pdt_rpc_namespace","fwd_in_pdt_com_tag_sys.server2client.5",function(inst,data)
        main_rpc_api__server2client(inst,data)
    end)
-- SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))

