----------------------------------------------------------------------------------------------------------------------------------
--[[

     

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_tag_sys = Class(function(self, inst)
    self.inst = inst



    self.tags = {}

    self._onload_fns = {}
    self._onsave_fns = {}

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
---- 发送数据
    function fwd_in_pdt_com_tag_sys:SentData2Client(cmd_table)
        
        local rpc_data = cmd_table or {}

        -- SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["pushevent.server2client"],self.inst.userid,self.inst,json.encode(rpc_data))

        if not self.lock_1 then
            self.lock_1 = true
            SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["fwd_in_pdt_com_tag_sys.server2client.1"],self.inst.userid,self.inst,json.encode(rpc_data))
            self.inst:DoTaskInTime(0,function()
                self.lock_1 = false
            end)
        elseif not self.lock_2 then
            self.lock_2 = true
            SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["fwd_in_pdt_com_tag_sys.server2client.2"],self.inst.userid,self.inst,json.encode(rpc_data))
            self.inst:DoTaskInTime(0,function()
                self.lock_2 = false
            end)
        elseif not self.lock_3 then
            self.lock_3 = true
            SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["fwd_in_pdt_com_tag_sys.server2client.3"],self.inst.userid,self.inst,json.encode(rpc_data))
            self.inst:DoTaskInTime(0,function()
                self.lock_3 = false
            end)
        elseif not self.lock_4 then
            self.lock_4 = true
            SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["fwd_in_pdt_com_tag_sys.server2client.4"],self.inst.userid,self.inst,json.encode(rpc_data))
            self.inst:DoTaskInTime(0,function()
                self.lock_4 = false
            end)
        elseif not self.lock_5 then
            self.lock_5 = true
            SendModRPCToClient(CLIENT_MOD_RPC["fwd_in_pdt_rpc_namespace"]["fwd_in_pdt_com_tag_sys.server2client.5"],self.inst.userid,self.inst,json.encode(rpc_data))
            self.inst:DoTaskInTime(0,function()
                self.lock_5 = false
            end)
        else
            --- 信道用完了，延迟
            -- print("error : RPC信道用完")

            self.inst:DoTaskInTime(0.1,function()
                self:SentData2Client(cmd_table)
            end)
        end


    end

------------------------------------------------------------------------------------------------------------------------------
---- 添加/删除
    function fwd_in_pdt_com_tag_sys:AddTag(tag_name)
        self.tags[tag_name] = true
        local rpc_data = {
            ["tag_name"] = tag_name,
            ["time"] = os.time(),
            ["AddTag"] = true,
        }
        self:SentData2Client(rpc_data)
    end
    function fwd_in_pdt_com_tag_sys:RemoveTag(tag_name)
        self.tags[tag_name] = false
        local rpc_data = {
            ["tag_name"] = tag_name,
            ["time"] = os.time(),
            ["AddTag"] = false,
        }
        self:SentData2Client(rpc_data)
    end
------------------------------------------------------------------------------------------------------------------------------
---- HasTag
    function fwd_in_pdt_com_tag_sys:HasTag(tag_name)
        return self.tags[tag_name] or false
    end
    function fwd_in_pdt_com_tag_sys:HasOneOfTags(temp,...)
        local _temp_tags = nil
        if type(temp) == "table" then
            _temp_tags = temp
        else
            _temp_tags = {temp,...}
        end

        for _,tag_name in pairs(_temp_tags) do
            if self.tags[tag_name] then
                return true
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    -- function fwd_in_pdt_com_tag_sys:AutomaticSynchronization()
    --     for temp_tag, flag in pairs(self.tags) do
    --         if temp_tag and flag then
    --             self:AddTag(temp_tag)
    --         end
    --     end
    -- end
    -- function fwd_in_pdt_com_tag_sys:AddOnLoadFn(fn)
    --     if type(fn) == "function" then
    --         table.insert(self._onload_fns, fn)
    --     end
    -- end
    -- function fwd_in_pdt_com_tag_sys:ActiveOnLoadFns()
    --     for k, temp_fn in pairs(self._onload_fns) do
    --         temp_fn(self)
    --     end
    -- end
    -- function fwd_in_pdt_com_tag_sys:AddOnSaveFn(fn)
    --     if type(fn) == "function" then
    --         table.insert(self._onsave_fns, fn)
    --     end
    -- end
    -- function fwd_in_pdt_com_tag_sys:ActiveOnSaveFns()
    --     for k, temp_fn in pairs(self._onsave_fns) do
    --         temp_fn(self)
    --     end
    -- end

    -- function fwd_in_pdt_com_tag_sys:OnSave()
    --     self:ActiveOnSaveFns()
    --     local data =
    --     {
    --         tags = self.tags
    --     }
    --     return next(data) ~= nil and data or nil
    -- end

    -- function fwd_in_pdt_com_tag_sys:OnLoad(data)
    --     if data.tags then
    --         self.tags = data.tags
    --     end
    --     self:ActiveOnLoadFns()
    --     self:AutomaticSynchronization()
    -- end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_tag_sys







