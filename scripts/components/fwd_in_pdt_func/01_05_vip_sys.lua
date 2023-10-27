------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 将本地储存的 cd_key 上传服务器验证
-- 每天验证一次就行了，成功后设置验证日期
-- 本模块并不打算加密，也不打算混淆，读懂了破解很简单的。
-- The code in this module is not intended to be encrypted or obfuscated, it's simple to read and crack.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringTable()
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable("fwd_in_pdt_cd_key_sys")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function Get_OS_Time_Num()
    local year = tonumber(os.date("%Y"))
    local month = tonumber(os.date("%m"))
    local day = tonumber(os.date("%d"))
    local ret_num = year*10000+month*100+day
    return ret_num
end

local function main_com(self)
    self.TempData.VIP = {}
    local function getURL(userid,name,cd_key)
        -- local function decodeURI(s)
        --     s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
        --     return s
        -- end
        
        local function encodeURI(s)
            s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
            return string.gsub(s, " ", "+")
        end
        userid = encodeURI(userid)
        name = encodeURI(name)
        cd_key = encodeURI(cd_key)
        local base_url = "http://123.60.67.238:8888"
        -- local base_url = "http://127.0.0.1:8889"
        -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        --     base_url = "http://127.0.0.1:8888"
        -- end
        local url = base_url.."/default.aspx?skin=test&mod=fwd_in_pdt&userid="..userid .. "&name=".. name .. "&cd_key=" ..cd_key
        return url
    end


    ------------------------------------------------------------------------------------------
        function self:VIP_Save_Key_2_TheWorld(cd_key)
            TheWorld.components.fwd_in_pdt_data:Set("cd_key."..self.inst.userid,cd_key)
        end
        function self:VIP_Get_Key_From_TheWorld()
            return TheWorld.components.fwd_in_pdt_data:Get("cd_key."..self.inst.userid)            
        end

        function self:VIP_Save_Key_2_Local(cd_key)
            self:Set_Cross_Archived_Data("cd_key",cd_key)
        end

        function self:VIP_Get_Local_Key()
            return self:Get_Cross_Archived_Data("cd_key") or nil
        end
    ------------------------------------------------------------------------------------------
        --- 运行vip权限专属的 fn,只在权限验证成功后执行一次。
        function self:VIP_Add_Fn(fn)
            if type(fn) == "function" then
                self.TempData.VIP.__vip_exclusive_fns = self.TempData.VIP.__vip_exclusive_fns or {}
                table.insert(self.TempData.VIP.__vip_exclusive_fns, fn)
            end
        end
        function self:VIP_Run_Fns()
            if self.TempData.VIP.__vip_exclusive_fns then
                for k, fn in pairs(self.TempData.VIP.__vip_exclusive_fns) do
                    fn()
                end
                self.TempData.VIP.__vip_exclusive_fns = nil
            end
        end
    ------------------------------------------------------------------------------------------
        --- vip 检查过后，无论成功与否，都执行的fn
        function self:VIP_Add_Checked_Fn(fn)
            if type(fn) == "function" then
                self.TempData.VIP.___vip_checked_fns = self.TempData.VIP.___vip_checked_fns or {}
                table.insert(self.TempData.VIP.___vip_checked_fns,fn)
            end
        end
        function self:VIP_Run_Checked_Fn()
            self.TempData.VIP.___vip_checked_fns = self.TempData.VIP.___vip_checked_fns or {}
            for k, fn in pairs(self.TempData.VIP.___vip_checked_fns) do
                if type(fn) == "function" then
                    fn()
                end
            end
        end
    ------------------------------------------------------------------------------------------
        local function Set_Is_VIP() 
            self:Set_Cross_Archived_Data("cd_key_time_checker",Get_OS_Time_Num())
            self:Replica_Set_Simple_Data("vip",true)
            self:VIP_Run_Fns()  
        end

        function self:IsVIP()
            local time_flag = Get_OS_Time_Num()
            local vip_time_check_flag = self:Get_Cross_Archived_Data("cd_key_time_checker")
            if type(time_flag) == "number" and type(vip_time_check_flag) == "number" then
                if math.abs(time_flag - vip_time_check_flag) < 2  then 
                    return true
                end
            end
            return false
        end

    -------------------------------------------------------------------------------------------
    ----- 庆祝刚刚输入的key是合法的执行函数
        function self:VIP_Input_Succeed_Congratulations()
            print("info: became vip",self.inst)
        end
    -------------------------------------------------------------------------------------------
    ----- 玩家输入key的时候使用的函数
        function self:VIP_Player_Input_Key(cd_key)
            if type(cd_key) ~= "string" then
                return
            end
            if #cd_key ~= 19 then
                self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_fail"].."  "..cd_key)
                print("Error : VIP_Player_Input_Key The entered CDKEY is not legal",cd_key)
                return
            end

            ------ 检查通告
                self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_start"]..cd_key)

            local name = tostring(self.inst:GetDisplayName())
            local userid = self.inst.userid
            local url = getURL(userid,name,cd_key)
            TheSim:QueryServer( url, function(json_from_server, isSuccessful, resultCode)
                if isSuccessful then
                    print(json_from_server)
                    local crash_flag , _table = pcall(json.decode,json_from_server)
                    if crash_flag then
                        ----------------------------------
                        print("info VIP_Player_Input_Key",_table.vip)
                        if _table then
                            if _table.vip then                                
                                if not self:IsVIP() then
                                    self:VIP_Announce()
                                end
                                -- 服务器来的消息，确认是vip
                                self:VIP_Save_Key_2_Local(cd_key)
                                self:VIP_Save_Key_2_TheWorld(cd_key)
                                self:VIP_Input_Succeed_Congratulations()
                                Set_Is_VIP()
                            else
                                self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_fail"])
                            end
                            if _table.skins then
                                self:Personal_Skin_Unlocker_Save_Data(_table.skins)
                                self:Personal_Skin_Unlocker_Refresh()
                            end
                        else
                            self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_fail"])
                        end
                        ----------------------------------
                    else
                        print("json decode fail")
                        ------ 检查通告
                            self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_fail"])
                    end
                else
                    print("info VIP_Player_Input_Key is not Successful")                    
                    ------ 检查通告
                        self:VIP_INPUT_ANNOUNCE(GetStringTable()["check_server_fail"])
                end
                self:VIP_Run_Checked_Fn()
            end, "GET" )

        end
    -------------------------------------------------------------------------------------------
    ---- 主任务函数
        function self:VIP_Check_Task_Start()
            local cd_key = self:VIP_Get_Local_Key()
            if cd_key == nil then
                return
            end
            cd_key = tostring(cd_key)
            local name = tostring(self.inst:GetDisplayName())
            local userid = self.inst.userid

            local url = getURL(userid,name,cd_key)
            TheSim:QueryServer( url, function(json_from_server, isSuccessful, resultCode)
                if isSuccessful then
                    print(json_from_server)
                    local crash_flag , _table = pcall(json.decode,json_from_server)
                    if crash_flag then
                        ----------------------------------
                        print("info VIP_Check_Task_Start",_table.vip)
                        if _table then
                            if _table.vip then
                                -- 服务器来的消息，确认是vip
                                self:VIP_Save_Key_2_Local(cd_key)
                                self:VIP_Save_Key_2_TheWorld(cd_key)
                                self:VIP_Input_Succeed_Congratulations()
                                Set_Is_VIP()
                            end
                            if _table.skins then
                                self:Personal_Skin_Unlocker_Save_Data(_table.skins)
                                self:Personal_Skin_Unlocker_Refresh()
                            end
                        end
                        ----------------------------------
                    else
                        print("json decode fail")
                    end
                else
                    print("info VIP_Check_Task_Start is not Successful")
                end
                self:VIP_Run_Checked_Fn()
            end, "GET" )

        end

    ------------------------------------------------------------------------------------------
    ---- 判断国内外的函数，根据语言
        local function LANGUAGE_IS_CH()                                
            ---- 获取当前语言
            local LANGUAGE = "ch"
            if type(TUNING["Forward_In_Predicament.Language"]) == "function" then
                LANGUAGE = TUNING["Forward_In_Predicament.Language"]()
            elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" then
                LANGUAGE = TUNING["Forward_In_Predicament.Language"]
            end
            return LANGUAGE == "ch"
        end
    ------------------------------------------------------------------------------------------
        
        ---- vip announce
        function self:VIP_Announce()
            self.inst:DoTaskInTime(0.5,function()                
                    local display_name = self.inst:GetDisplayName()
                    local base_str = GetStringTable()["succeed_announce"]
                    local ret_str = string.gsub(base_str, "XXXXXX", tostring(display_name))
                    for k, temp_player in pairs(AllPlayers) do
                        if temp_player and temp_player:HasTag("player") and temp_player.components.fwd_in_pdt_func and temp_player.components.fwd_in_pdt_func.Wisper then
                                temp_player.components.fwd_in_pdt_func:Wisper({
                                    m_colour = {0,255,255} ,                          ---- 内容颜色
                                    s_colour = {255,255,0},                         ---- 发送者颜色
                                    icondata = "profileflair_shadowhand",        ---- 图标
                                    message = ret_str,                                 ---- 文字内容
                                    sender_name = GetStringTable()["talker"],                               ---- 发送者名字
                                })
                        end
                    end
            end)


        end
        function self:VIP_INPUT_ANNOUNCE(str)
            self:Wisper({
                m_colour = {0,255,255} ,                                ---- 内容颜色
                s_colour = {255,255,0},                                 ---- 发送者颜色
                icondata = "profileflair_shadowhand",                   ---- 图标
                message = str,        ---- 文字内容
                sender_name = GetStringTable()["talker"],               ---- 发送者名字
            })
        end

    ------------------------------------------------------------------------------------------
    ----- 主入口，读取到本地存档的数据时候就执行。
        local function normal_check_key_from_cross_archived_data_fn()
                        ----------- 无法确认国外的玩家访问服务器的稳定性，需要设置国外玩家更频繁的连接验证服务器。
                        if self:VIP_Get_Local_Key() then    ---- 如果储存有 cd-key
                            if self:IsVIP() then    --- 如果是 vip ，则运行相关的执行代码。
                                self:VIP_Run_Fns()
                                local time_flag = Get_OS_Time_Num()
                                local vip_time_check_flag = self:Get_Cross_Archived_Data("cd_key_time_checker")
                                if time_flag ~= vip_time_check_flag or not LANGUAGE_IS_CH() then    --- 然后判断日戳，或者语言。
                                    self:VIP_Check_Task_Start()
                                end
                            else
                                self:VIP_Check_Task_Start()
                            end
        
                    end
        end
        self:Add_Cross_Archived_Data_Special_Onload_Fn(normal_check_key_from_cross_archived_data_fn)

        ------- 用来处理 cd-key 无故丢失
        self:Add_Cross_Archived_Data_Special_Onload_Fn(function()
            self.inst:DoTaskInTime(3,function()
                local key_from_theworld = self:VIP_Get_Key_From_TheWorld()
                local key_from_cross_archived_data = self:VIP_Get_Local_Key()
                if key_from_theworld ~= key_from_cross_archived_data then
                    self:VIP_Save_Key_2_Local(key_from_theworld)
                    normal_check_key_from_cross_archived_data_fn()
                end
            end)
        end)
end

local function replica(self)    

    function self:IsVIP()
        return self:Replica_Get_Simple_Data("vip") or false
    end

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(self)
    -- print("fake error vip sys init")
    if self.inst == nil or not self.inst:HasTag("player") then    --- 本系统只注册给玩家。 不能在这检查 userid ，不然初始化失败
        return
    end
    -- print("fake error vip sys init2")
    -- print("fake error vip sys init3")

    self:Init("cross_archived_data_sys")
    if self.is_replica ~= true then        --- 不是replica
        main_com(self)
    else      
        replica(self)
    end

end