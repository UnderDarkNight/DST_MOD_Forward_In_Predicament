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


local function main_com(fwd_in_pdt_func)
    --------------------------------------------------------------------------------------------------------------------
    ---- 玩家角色加载的时候，client 主动上传一次数据。
    function fwd_in_pdt_func:Get_Cross_Archived_Data(name)
        if self.tempData.__Cross_Archived_Data then
            return self.tempData.__Cross_Archived_Data[name] or nil
        end
        return nil
    end

    fwd_in_pdt_func.inst:ListenForEvent("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",function(inst,_table)
        inst.components.fwd_in_pdt_func.tempData.__Cross_Archived_Data = _table
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("info: fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client")
        end
    end)

    function fwd_in_pdt_func:Set_Cross_Archived_Data(name,data)
        if type(name) ~= "string" then
            return
        end
        self.tempData.__Cross_Archived_Data = self.tempData.__Cross_Archived_Data or {}
        self.tempData.__Cross_Archived_Data[name] = data
        self:RPC_PushEvent("fwd_in_pdt_event.Set_Cross_Archived_Data_To_Client",self.tempData.__Cross_Archived_Data)
    end
    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(fwd_in_pdt_func)
    --------------------------------------------------------------------------------------------------------------------
    ----- 往 replica 注册执行函数
    local function send_data_2_server(inst)
        local ret_table = Get_Cross_Archived_Data_By_userid(inst.userid) or {}
        inst.replica.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",ret_table)
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("fwd_in_pdt info: send Cross_Archived_Data to Server")
        end
    end 

    function fwd_in_pdt_func:Set_Cross_Archived_Data(name,data)   --- replica 这边直接储存数据，并更新同步给server
        local ret_table = Get_Cross_Archived_Data_By_userid(self.inst.userid) or {}
        ret_table[name] = data
        Set_Cross_Archived_Data_By_userid(self.inst.userid,ret_table)
        send_data_2_server(self.inst)
    end

    fwd_in_pdt_func.inst:DoTaskInTime(0,send_data_2_server)

    fwd_in_pdt_func.inst:ListenForEvent("fwd_in_pdt_event.Set_Cross_Archived_Data_To_Client",function(inst,_table)
        _table = _table or {}
        Set_Cross_Archived_Data_By_userid(inst.userid,_table)
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("fwd_in_pdt info: Save Cross_Archived_Data to data file")
        end
    end)
    --------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if not fwd_in_pdt_func.inst:HasTag("player") or fwd_in_pdt_func.inst.userid == nil then    --- 本系统只注册给玩家。
        return
    end            
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else      
        replica(fwd_in_pdt_func)
    end

end