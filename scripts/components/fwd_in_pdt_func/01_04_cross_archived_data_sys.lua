------------------------------------------------------------------------------------------------
-- 跨存档储存系统
-- 使用 json 储存
-- 只注册给玩家实体inst
-- DoTaskInTime 0 的时候由 client 的 replica 上传到 server 
-- 相关的检查需要时间延后一点。
------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------
            --- 基础的文件读写函数
local function Get_Data_File_Name()
    return "Forward_In_Predicament_DATA.TEXT"
end
local function Read_All_Json_Data()

    local function Read_data_p()
        local file = io.open(Get_Data_File_Name(), "r")
        local text = file:read('*line')
        file:close()
        return text
    end

    local flag,ret = pcall(Read_data_p)

    if flag == true then
        local retTable = json.decode(ret)
        return retTable
    else
        print("FWD_IN_PDT ERROR :read cross archived data error : Read_All_Json_Data got nil")
        return {}
    end
end

local function Write_All_Json_Data(json_data)
    local w_data = json.encode(json_data)
    local file = io.open(Get_Data_File_Name(), "w")
    file:write(w_data)
    file:close()
end

local function Get_Cross_Archived_Data_By_userid(userid)
    local temp_json_data = Read_All_Json_Data() or {}
    return temp_json_data[userid] or {}                
end

local function Set_Cross_Archived_Data_By_userid(userid,_table)
    local temp_json_data = Read_All_Json_Data() or {}
    temp_json_data[userid] = _table
    Write_All_Json_Data(temp_json_data)
end
--------------------------------------------------------------------------------------------------------------------


local function main_com(self)
    --------------------------------------------------------------------------------------------------------------------
    self.TempData.Cross_Archived_Data = {}
    self.TempData.Cross_Archived_Data.__Data = {}
    --------------------------------------------------------------------------------------------------------------------
    ---- data 【初次】上传过来触发的执行函数，仅限每次玩家进出存档的时候。
    function self:Add_Cross_Archived_Data_Special_Onload_Fn(fn)
        if type(fn) == "function" then
            self.TempData.Cross_Archived_Data.___sp_onload_fns = self.TempData.Cross_Archived_Data.___sp_onload_fns or {}
            table.insert(self.TempData.Cross_Archived_Data.___sp_onload_fns,fn)
        end
    end
    function self:Run_Cross_Archived_Data_Special_Onload_Fns()
        if self.TempData.Cross_Archived_Data.___sp_onload_fns then
            for k, fn in pairs(self.TempData.Cross_Archived_Data.___sp_onload_fns) do
                fn()
            end
        end
    end
    --------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
    ---- 玩家角色加载的时候，client 主动上传一次数据。
    function self:Get_Cross_Archived_Data(name)
        if self.TempData.Cross_Archived_Data.__Data then
            return self.TempData.Cross_Archived_Data.__Data[name] or nil
        end
        return nil
    end

    self.inst:ListenForEvent("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",function(inst,_table)
        inst.components.fwd_in_pdt_func.TempData.Cross_Archived_Data.__Data = _table
        self:Run_Cross_Archived_Data_Special_Onload_Fns()
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("info: fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client")
        end
    end)

    function self:Set_Cross_Archived_Data(name,data)
        if type(name) ~= "string" then
            return
        end
        self.TempData.Cross_Archived_Data.__Data = self.TempData.Cross_Archived_Data.__Data or {}
        self.TempData.Cross_Archived_Data.__Data[name] = data
        -- self:RPC_PushEvent("fwd_in_pdt_event.Set_Cross_Archived_Data_To_Client",self.TempData.Cross_Archived_Data.__Data)
        self:Cross_Archived_Data_RPC_Server2Client(self.TempData.Cross_Archived_Data.__Data)
    end
    --------------------------------------------------------------------------------------------------------------------
    function self:Cross_Archived_Data_RPC_Server2Client(data)
        SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["cross_archived_data.server2client"],self.inst,json.encode(data or {}))
    end
    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(self)
    --------------------------------------------------------------------------------------------------------------------
    function self:Cross_Archived_Data_RPC_Client2Server(data)
        SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["cross_archived_data.client2server"],json.encode(data or {}))
    end
    --------------------------------------------------------------------------------------------------------------------
    ----- 往 replica 注册执行函数
    local function send_data_2_server(inst)
        if inst.userid == nil then
            return
        end
        local ret_table = Get_Cross_Archived_Data_By_userid(inst.userid) or {}
        -- inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",ret_table)
        self:Cross_Archived_Data_RPC_Client2Server(ret_table)
        inst:PushEvent("fwd_in_pdt_event.Cross_Archived_Data_Send_2_Server_Finish")     --- 给client 挂个事件监听
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("fwd_in_pdt info: send all Cross_Archived_Data to Server",inst)
        end
    end 

    function self:Set_Cross_Archived_Data(name,data)   --- replica 这边直接储存数据，并更新同步给server
        local ret_table = Get_Cross_Archived_Data_By_userid(self.inst.userid) or {}
        ret_table[name] = data
        Set_Cross_Archived_Data_By_userid(self.inst.userid,ret_table)
        send_data_2_server(self.inst)
    end

    function self:Get_Cross_Archived_Data(name)
        if name then
            local ret_table = Get_Cross_Archived_Data_By_userid(self.inst.userid) or {}
            return ret_table[name]
        else
            return nil
        end
    end

    self.inst:DoTaskInTime(0,send_data_2_server)

    self.inst:ListenForEvent("fwd_in_pdt_event.Set_Cross_Archived_Data_To_Client",function(inst,_table)
        _table = _table or {}
        Set_Cross_Archived_Data_By_userid(inst.userid,_table)
        -- inst:DoTaskInTime(0.5,send_data_2_server)   --- 延迟一下，然后把本地的数据重新同步给服务器。
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("fwd_in_pdt info: Save all Cross_Archived_Data to data file",inst)
        end
    end)
    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(self)
    if not self.inst:HasTag("player") then    --- 本系统只注册给玩家。
        return
    end            
    if self.is_replica ~= true then        --- 不是replica
        main_com(self)
    else      
        replica(self)
    end

end