------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件作为 cd-key  / vip 系统的验证模块
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 预留多个激活码实现不同模块激活的功能
---- key 的格式 ： XXXX-XXXX-XXXX-XXXX      #str = 19


---- 都懒得加密混淆了，找到这里的程序员破解该cd-key系统是时间上的事，都是程序员，不用相互为难。
---- Here are lazy encryption obfuscation, to find the programmers here to crack that cd-key system is a matter of time, are programmers, do not have to be difficult for each other.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringTable()
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable("fwd_in_pdt_cd_key_sys")
end

local function main_com(self)
    self.TempData.VIP = {}
    ------------------------------------------------------------
        function self:VIP_Add_Fn(fn)    ----- vip 验证成功后执行的fn
            if type(fn) == "function" then
                self.TempData.VIP.___is_vip_fn = self.TempData.VIP.___is_vip_fn or {}
                table.insert(self.TempData.VIP.___is_vip_fn,fn)
            end
        end
        function self:VIP_Do_Check_Succeed_Fns()
            self.TempData.VIP.___is_vip_fn = self.TempData.VIP.___is_vip_fn or {}
            for k, fn in pairs(self.TempData.VIP.___is_vip_fn) do
                fn()
            end
            self.TempData.VIP.___is_vip_fn = {} --- 执行的代码为一次性的
        end

        function self:VIP_Set_CDKEY(str)
            if type(str) == "string" and self:VIP_Start_Check_CDKEY(str) then
                self:Set_Cross_Archived_Data("cd_key",str)
            end
        end

        function self:VIP_Get_CDKEY()
            return self:Get_Cross_Archived_Data("cd_key")
        end
    ------------------------------------------------------------
    -- bad key check  检查同一个世界里有多个玩家同一个CDKEY
        function self:VIP_Set_Bad_Key()
            self:Set("bad_cd_key",true)
        end
        function self:VIP_Is_Bad_Key()
            return self:Get("bad_cd_key") or false
        end

        function self:VIP_Bad_Key_Flag_Clear()
            self:Set("bad_cd_key",false)
        end
        
        function self:VIP_Save_Key_2_World()
            local cd_key = self:VIP_Get_CDKEY()
            local userid = self.inst.userid
            local data_from_world = TheWorld.components.fwd_in_pdt_func:Get("all_player_cd_keys") or {}
            data_from_world[userid] = cd_key
            TheWorld.components.fwd_in_pdt_func:Set("all_player_cd_keys",data_from_world)
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("VIP_Save_Key_2_World",userid,cd_key)
            end
        end

        function self:VIP_Bad_Key_Check()
            local my_userid = self.inst.userid
            local my_cd_key = self:VIP_Get_CDKEY()
            if type(my_cd_key) ~= "string" then
                return
            end
            local data_from_world = TheWorld.components.fwd_in_pdt_func:Get("all_player_cd_keys") or {}

            for temp_userid, temp_cd_key in pairs(data_from_world) do
                if temp_userid ~= my_userid and temp_cd_key == my_cd_key then
                    self:VIP_Set_Bad_Key()
                    return
                end
            end

        end

        function self:VIP_Bad_Key_Task_Start()
            if self:VIP_Is_Bad_Key() and self.TempData.VIP.____bad_key_announce_task == nil then
                self.TempData.VIP.____bad_key_announce_task = self.inst:DoPeriodicTask(5,function()
                    ----------------------------------------
                    --- 做通告
                    self:Wisper({
                        m_colour = {255,255,255} ,                           ---- 内容颜色
                        s_colour = {255,255,255},                            ---- 发送者颜色
                        message = GetStringTable()["bad_key.str"],           ---- 文字内容
                        sender_name = GetStringTable()["bad_key.talker"],    ---- 发送者名字
                    })
                    ----------------------------------------
                end)
            end
        end

        function self:VIP_Bad_Key_Task_Kill()
            if self.TempData.VIP.____bad_key_announce_task then
                self.TempData.VIP.____bad_key_announce_task:Cancel()
                self.TempData.VIP.____bad_key_announce_task = nil
            end
        end

        function self:VIP_Check_AllPlayers_Bad_Key()        ---- 有人登录、输入新的key 都会执行
            for k, temp_player in pairs(AllPlayers) do
                if temp_player and temp_player.userid and temp_player.components.fwd_in_pdt_func and temp_player.components.fwd_in_pdt_func.IsVIP then
                    temp_player.components.fwd_in_pdt_func:VIP_Bad_Key_Task_Kill()  --- 杀掉通告任务
                    temp_player.components.fwd_in_pdt_func:VIP_Bad_Key_Flag_Clear() --- 先清除标记
                    temp_player.components.fwd_in_pdt_func:VIP_Bad_Key_Check()      --- 再重新检查
                    temp_player.components.fwd_in_pdt_func:VIP_Bad_Key_Task_Start() --- 再检查任务重启
                end
            end
        end
    ------------------------------------------------------------
    ---- key 判断
                local alphabet = {
                    ["A"]=0,["B"]=0,["C"]=0,["D"]=0,["E"]=0,["F"]=0,["G"] = 0,
                    ["H"]=0,["I"]=0,["J"]=0,["K"]=0,["L"]=0,["M"]=0,["N"] = 0,
                    ["O"]=0,["P"]=0,["Q"]=0,["R"]=0,["S"]=0,["T"]=0,["U"] = 0,
                    ["V"]=0,["W"]=0,["X"]=0,["Y"]=0,["Z"]=0,["0"]=0,["1"] = 0,
                    ["2"]=0,["3"]=0,["4"]=0,["5"]=0,["6"]=0,["7"]=0,["8"] = 0,
                    ["9"]=0,
                }
                ------- 初始化偏移表格
                local start_num = 1111
                local num = start_num    ---- 1111 ~ 1145   （26+9=35）
                for k, v in pairs(alphabet) do
                    alphabet[k] = num
                    num = num + 1
                end
                local end_num = num - 1    ----- 
                local function str2number(str)
                    if string.len(str) ~= 4 then
                        return nil
                    end                    
                    local crash_flag,nums= pcall(function()
                        local ret = {}
                        for i = 1, 4, 1 do
                            local temp = string.sub(str,i,i)
                            local the_num = alphabet[tostring(temp)]
                            if type(the_num) == "number" then
                                table.insert(ret,the_num)
                            end
                        end
                        return ret
                    end)
                    if crash_flag and #nums == 4 then
                        return unpack(nums)
                    else
                        return nil
                    end
                end

                local function keys_check__typ_1(str2,str3,str4)
                    local function key2_check(str)
                        local num_1,num_2,num_3,num_4 = str2number(str)
                        if num_1 and num_2 and num_3 and num_4 and num_1>=num_2 and num_3>=num_4 then
                            if (num_1+num_2+num_3+num_4)%13 == 0 then   --- 和为13的倍数,
                                return true
                            end
                        end
                        return false
                    end
                    local function key3_check(str)    
                        local num_1,num_2,num_3,num_4 = str2number(str)
                        if num_1 and num_2 and num_3 and num_4 and num_2>=num_3 and num_4 >= num_1 then
                            if (num_1+num_2+num_3+num_4)%5 == 0 then    --- 和为5的倍数
                                return true
                            end
                        end    
                        return false
                    end
                    local function key4_check(str)    
                        local num_1,num_2,num_3,num_4 = str2number(str) --- 和为12的倍数
                        if num_1 and num_2 and num_3 and num_4 and num_2>=num_1 and num_4 >= num_3 then
                            if (num_1+num_2+num_3+num_4)%12 == 0 then
                                return true
                            end
                        end
                        return false
                    end
                    
                    if key2_check(str2) and key3_check(str3) and key4_check(str4) then
                        return true
                    else
                        return false
                    end
                end
    ------------------------------------------------------------
    --- cd-key 生成函数
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            function self:VIP_CreateCDKEY()
                local function num2alphabet(num)
                    for k, v in pairs(alphabet) do
                        if v == num then
                            return tostring(k)
                        end
                    end
                    return "#"
                end

                ---------------------------------------------
                --- key 2
                local num_1,num_2,num_3,num_4 = 0,0,0,0
                while true do
                    local t1 = math.random(start_num, end_num)
                    local t2 = math.random(start_num, end_num)
                    local t3 = math.random(start_num, end_num)
                    local t4 = math.random(start_num, end_num)
                    if t1>=t2 and t3>=t4 and (t1+t2+t3+t4)%13 == 0 then   --- 和为 13 的倍数
                        num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                        break
                    end 
                end
                local key_2 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)
                ---------------------------------------------
                --- key 3
                while true do
                    local t1 = math.random(start_num, end_num)
                    local t2 = math.random(start_num, end_num)
                    local t3 = math.random(start_num, end_num)
                    local t4 = math.random(start_num, end_num)
                    if t2>=t3 and t4>=t1 and  (t1+t2+t3+t4)%5 == 0 then   --- 和为 5 的倍数
                        num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                        break
                    end 
                end
                local key_3 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)
                ---------------------------------------------
                --- key 4
                while true do
                    local t1 = math.random(start_num, end_num)
                    local t2 = math.random(start_num, end_num)
                    local t3 = math.random(start_num, end_num)
                    local t4 = math.random(start_num, end_num)
                    if t2>=t1 and t4>=t3 and (t1+t2+t3+t4)%12 == 0 then   --- 和为 12 的倍数
                        num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                        break
                    end 
                end
                local key_4 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)  
                
                
                -----------------------------
                local ret_CDKEY = "FVIP-"..key_2.."-"..key_3.."-"..key_4
                -- if string.find(ret_CDKEY,"#") == nil then
                -- print(ret_CDKEY)
                -- end
                return ret_CDKEY
            end
        end
    ------------------------------------------------------------
    ------------------------------------------------------------

        function self:IsVIP()
            return self.TempData.VIP.______vip_player or false
        end
    ------------------------------------------------------------
    ---- 玩家输入key的函数
        function self:VIP_Player_Input_Key(input_key)
            if self:VIP_Start_Check_CDKEY(input_key, true) then
                print("玩家输入的key合法")
            else
                print("玩家输入了错误的key") 
            end
        end
        --------- 单纯的检查 key 的合法性
        function self:VIP_Checking_The_Legality_Of_Key(input_key)
            return self:VIP_Start_Check_CDKEY(input_key) or false
        end
    ------------------------------------------------------------
    ---- 主检查入口。可以仅仅只检查key是否通过。
        ---- 功能1：输入参数全为nil。为客户端上传来数据的时候检查key，并执行通过的函数。为进入世界的时候读取检查调用。
        ---- 功能2：用户输入激活码的时候， for_player_input_flag 需要为 true。 让玩家刚输入完key就能享受对应的功能。
        ---- 功能3：单纯的验证激活码是否通过， for_player_input_flag 为 nil 。  通常用于检查生成的key是否通过。
        ---- ThePlayer.components.fwd_in_pdt_func:VIP_Start_Check_CDKEY("FVIP-A1H1-KY6V-LT02",true)
        function self:VIP_Start_Check_CDKEY(input_key,for_player_input_flag)
            local cdkey = input_key or self:VIP_Get_CDKEY()
            if type(cdkey) ~= "string" then
                return false
            end
            if #cdkey < 19 then    ---  XXXX-XXXX-XXXX-XXXX  文本长度为19
                return false
            end
            -- string.sub(str,1,string.len(str)-1)  -- 截取文本
            cdkey = string.upper(cdkey)
            local key_1 = string.sub(cdkey,1,4)
            local key_2 = string.sub(cdkey, 6, 9)
            local key_3 = string.sub(cdkey, 11, 14)
            local key_4 = string.sub(cdkey, 16, 19)

            -------------------------------------------------------
            ----  FVIP-XXXX-XXXX-XXXX 
            ---- 以 FVIP 为开头
            if  key_1 == "FVIP" and keys_check__typ_1(key_2,key_3,key_4) then
                if input_key and for_player_input_flag == nil then
                    print("key check succeed:",input_key)
                    return true
                else
                    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                        print("info cd-key check succeed:",cdkey)
                    end
                    self.TempData.VIP.______vip_player = true
                    if for_player_input_flag then
                        self:VIP_Set_CDKEY(input_key)   ---- 下发保存数据
                    end
                    self:VIP_Do_Check_Succeed_Fns()
                    self:Replica_Set_Simple_Data("vip",true)
                    self.inst:AddTag("fwd_in_pdt_tag.vip")

                    self:VIP_Save_Key_2_World() --- 把 key 保存到 TheWorld
                    self:VIP_Check_AllPlayers_Bad_Key()
                    return true
                end
            end
            -------------------------------------------------------
            return false
        end

    ------------------------------------------------------------
    ---- 跨存档数据更新来的时候执行
        self:Add_Cross_Archived_Data_Special_Onload_Fn(function()
            if not self:IsVIP() then
                self:VIP_Start_Check_CDKEY()
            end
        end)
    ------------------------------------------------------------

end



local function replica(self)  
    function self:IsVIP()
        return self:Replica_Get_Simple_Data("vip") or false
    end
    
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if not fwd_in_pdt_func.inst:HasTag("player") then    --- 本系统只注册给玩家。
        return
    end             
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else      
        replica(fwd_in_pdt_func)
    end

end





    ----------------------------------------------------------------------------------------------------------------
    ------ cd-key 生成
            -- local ret_keys = {}
            -- local num = 0
            -- for i = 1, 30000, 1 do
            --     local temp_key = ThePlayer.components.fwd_in_pdt_func:VIP_CreateCDKEY()
            --     if temp_key and ThePlayer.components.fwd_in_pdt_func:VIP_Start_Check_CDKEY(temp_key) and ret_keys[temp_key] ~= true then
            --         ret_keys[temp_key] = true
            --         num = num + 1
            --     end
            -- end
            -- print("keys",num)
            -- local file = io.open("fvip_keys.txt","w")
            -- for key, v in pairs(ret_keys) do
            --     if key and v then
            --         file:write(key)
            --         file:write('\n')
            --     end
            -- end
            -- file:close()
    ----------------------------------------------------------------------------------------------------------------