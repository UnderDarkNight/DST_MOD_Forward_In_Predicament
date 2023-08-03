------------------------------------------------------------------------------------------------
---- 本文件使用 RPC 下发Event 和 数据
---- 相关的RPC API 只能在 服务器注册
---- 通常用于 玩家自身的事件触发。但是也可以广播某个 inst 的事件。
---- 监听方 只能在 Client 注册
---- 注意下发的数据里不能包含 任何 inst ，json 无法编码 inst数据
---- 【特别注意】 超出玩家加载范围外的实体，是无法接受 rpc 所下发数据的。（OnEntitySleep/OnEntityWake）
------------------------------------------------------------------------------------------------
---- replica 也使用本lua 注册函数
------------------------------------------------------------------------------------------------

local function main_com(fwd_in_pdt_func)
    --------------------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return
    end    
    function fwd_in_pdt_func:RPC_PushEvent(_target_inst,_event_name,_cmd_table)
        ------- 可以向前缺省 inst，
        local inst = nil
        local event_name = nil
        local cmd_table = nil

        if type(_target_inst) == "string" then  ---- 缺省前移参数
            inst = self.inst
            event_name = _target_inst
            cmd_table = _event_name or {}
        else
            inst = _target_inst
            event_name = _event_name
            cmd_table = _cmd_table or {}
        end


        local json_data = {
            event_name = event_name,
            cmd_table = cmd_table,
        }


        if inst.userid then ---- 如果是玩家，直接RPC发送     
            -- print("inst.userid",inst.userid,json_data.event_name)       
            SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))
            
        else    ----- 如果不是玩家自身的RPC，群发所有玩家
            for k, temp_player in pairs(AllPlayers) do
                if temp_player.userid then
                    SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.server2client"],temp_player.userid,inst,json.encode(json_data))
                end
            end
        end

        ----------------------------------------------------------------------
        ---- 添加警告信息，今后万一出现同时大量RPC下发导致信道阻塞，打印这个警告，方便排查。
            if self.____rpc_warning_task_inst and  self.____rpc_warning_task then
                print("Warning : FWD_IN_PDT RPC_PushEvent Channel blocked warning",self.____rpc_warning_task_last_event_name,event_name)
                self.____rpc_warning_task:Cancel()
                self.____rpc_warning_task_inst:Remove()
            end
            self.____rpc_warning_task_inst = CreateEntity()
            self.____rpc_warning_task = self.____rpc_warning_task_inst:DoTaskInTime(0,function()
                self.____rpc_warning_task:Cancel()
                self.____rpc_warning_task = nil
                self.____rpc_warning_task_inst:Remove()
                self.____rpc_warning_task_inst = nil
                self.____rpc_warning_task_last_event_name = nil
            end)
            self.____rpc_warning_task_last_event_name = event_name
        ----------------------------------------------------------------------

    end


    function fwd_in_pdt_func:RPC_PushEvent2(_target_inst,_event_name,_cmd_table)  --- 尝试使用自动延迟 避免阻塞
        ------- 可以向前缺省 inst，
        local inst = nil
        local event_name = nil
        local cmd_table = nil

        if type(_target_inst) == "string" then  ---- 缺省前移参数
            inst = self.inst
            event_name = _target_inst
            cmd_table = _event_name or {}
        else
            inst = _target_inst
            event_name = _event_name
            cmd_table = _cmd_table or {}
        end


        local json_data = {
            event_name = event_name,
            cmd_table = cmd_table,
        }

        if self.____rpc_warning_task == nil then

            if inst.userid then ---- 如果是玩家，直接RPC发送     
                -- print("inst.userid",inst.userid,json_data.event_name)       
                SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.server2client"],inst.userid,inst,json.encode(json_data))
                
            else    ----- 如果不是玩家自身的RPC，群发所有玩家
                for k, temp_player in pairs(AllPlayers) do
                    if temp_player.userid then
                        SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.server2client"],temp_player.userid,inst,json.encode(json_data))
                    end
                end
            end

        else
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("Warning : FWD_IN_PDT RPC_PushEvent Channel blocked warning , rpc event task will delay 0.1s",self.inst)
                print("current rpc task event name:",self.____rpc_warning_task_last_event_name)
                print("delayed task event name :",event_name)
            end
            self.inst:DoTaskInTime(0.1,function()
                self:RPC_PushEvent2(_target_inst,_event_name,_cmd_table)
            end)

        end

        ----------------------------------------------------------------------
        ---- 添加警告信息，今后万一出现同时大量RPC下发导致信道阻塞，打印这个警告，方便排查。
            if self.____rpc_warning_task_inst and  self.____rpc_warning_task then
                -- print("Warning : FWD_IN_PDT RPC_PushEvent Channel blocked warning",self.____rpc_warning_task_last_event_name,event_name)
                self.____rpc_warning_task:Cancel()
                self.____rpc_warning_task_inst:Remove()
            end
            self.____rpc_warning_task_inst = CreateEntity()
            self.____rpc_warning_task = self.____rpc_warning_task_inst:DoTaskInTime(0,function()
                self.____rpc_warning_task:Cancel()
                self.____rpc_warning_task = nil
                self.____rpc_warning_task_inst:Remove()
                self.____rpc_warning_task_inst = nil
                self.____rpc_warning_task_last_event_name = nil
            end)
            self.____rpc_warning_task_last_event_name = event_name
        ----------------------------------------------------------------------

    end

    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(fwd_in_pdt_func)
    --------------------------------------------------------------------------------------------------------------------
    ----- 往 replica 注册执行函数
    fwd_in_pdt_func.inst:ListenForEvent("fwd_in_pdt_event.RPC_Remove",fwd_in_pdt_func.inst.Remove)  ---- 使用RPC 快速删除实体

    function fwd_in_pdt_func:RPC_PushEvent(event_name,data_table)
        if type(event_name) ~= "string" then
            return
        end
        
        if self.inst.components.fwd_in_pdt_func then
            self.inst:PushEvent(event_name,data_table)
        else
            SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.client2server"],self.inst,event_name,json.encode(data_table))
        end
    end
    function fwd_in_pdt_func:RPC_PushEvent2(event_name,data_table)
        if type(event_name) ~= "string" then
            return
        end
        
        if self.inst.components.fwd_in_pdt_func then
            self.inst:PushEvent(event_name,data_table)
        else

            if self.tempData.____rpc_warning_task then
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    print("Warning : FWD_IN_PDT replica RPC_PushEvent Channel blocked warning , rpc event task will delay 0.1s",self.inst)
                    print("current rpc task event name:",self.tempData.____rpc_warning_task_last_event_name)
                    print("delayed task event name :",event_name)
                end
                self.inst:DoTaskInTime(0.1,function()
                    self:RPC_PushEvent2(event_name,data_table)
                end)
                return
            end

            SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["pushevent.client2server"],self.inst,event_name,json.encode(data_table))
            self.tempData.____rpc_warning_task = self.inst:DoTaskInTime(0,function()
                self.tempData.____rpc_warning_task = nil
            end)
            self.tempData.____rpc_warning_task_last_event_name = event_name
        end
    end
    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func) 
    else      
        replica(fwd_in_pdt_func)
    end

end