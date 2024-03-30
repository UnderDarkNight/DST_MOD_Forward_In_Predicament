----------------------------------------------------------------------------------------------------------------------------------
--[[

     一帧给予 5 条 RPC 管道足够了

     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_rpc_event = Class(function(self, inst)
    self.inst = inst


end,
nil,
{

})


function fwd_in_pdt_com_rpc_event:PushEvent(event_name, event_data,tar_inst)
    
    if type(event_name) ~= "string" then
        return
    end


    local rpc_data = {
        event_name = event_name,
        event_data = event_data,
    }

    -- SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client"],self.inst.userid,self.inst,json.encode(rpc_data))

    if not self.lock_1 then
        self.lock_1 = true
        SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client.1"],self.inst.userid,self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_1 = false
        end)
    elseif not self.lock_2 then
        self.lock_2 = true
        SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client.2"],self.inst.userid,self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_2 = false
        end)
    elseif not self.lock_3 then
        self.lock_3 = true
        SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client.3"],self.inst.userid,self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_3 = false
        end)
    elseif not self.lock_4 then
        self.lock_4 = true
        SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client.4"],self.inst.userid,self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_4 = false
        end)
    elseif not self.lock_5 then
        self.lock_5 = true
        SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client.5"],self.inst.userid,self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_5 = false
        end)
    else
        --- 信道用完了，延迟
        -- print("error : RPC信道用完")

        self.inst:DoTaskInTime(0.1,function()
            self:PushEvent(event_name,event_data,tar_inst)
        end)
    end


end


return fwd_in_pdt_com_rpc_event






