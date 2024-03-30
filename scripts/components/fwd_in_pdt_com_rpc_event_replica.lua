----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_rpc_event = Class(function(self, inst)
    self.inst = inst


end,
nil,
{

})


function fwd_in_pdt_com_rpc_event:PushEvent(event_name,event_data,tar_inst)
    
    if type(event_name) ~= "string" then
        return
    end


    local rpc_data = {
        event_name = event_name,
        event_data = event_data,
    }

    -- SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server"],self.inst,json.encode(rpc_data))

    if not self.lock_1 then
        self.lock_1 = true
        SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server.1"],self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_1 = false
        end)
    elseif not self.lock_2 then
        self.lock_2 = true
        SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server.2"],self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_2 = false
        end)
    elseif not self.lock_3 then
        self.lock_3 = true
        SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server.3"],self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_3 = false
        end)
    elseif not self.lock_4 then
        self.lock_4 = true
        SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server.4"],self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_4 = false
        end)
    elseif not self.lock_5 then
        self.lock_5 = true
        SendModRPCToServer(MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.client2server.5"],self.inst,json.encode(rpc_data),tar_inst)
        self.inst:DoTaskInTime(0,function()
            self.lock_5 = false
        end)
    else
        --- 信道用完
        -- print("error : RPC信道用完")
        self.inst:DoTaskInTime(0.1,function()
            self:PushEvent(event_name, event_data,tar_inst)
        end)

    end


end



return fwd_in_pdt_com_rpc_event






