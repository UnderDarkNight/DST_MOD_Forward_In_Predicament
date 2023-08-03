------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件作为 cd-key  / vip 系统的验证模块
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 预留多个激活码实现不同模块激活的功能
---- key 的格式 ： XXXX-XXXX-XXXX-XXXX      #str = 19

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function main_com(self)
    self.TempData.VIP = {}
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
    end

    function self:VIP_Set_CDKEY(str)
        if type(str) == "string" then
            self:Set_Cross_Archived_Data("cd_key",str)
        end
    end

    function self:VIP_Get_CDKEY()
        return self:Get_Cross_Archived_Data("cd_key")
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
                local end_num = num     ----- 
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
                local function key2_check(str)
                    local num_1,num_2,num_3,num_4 = str2number(str)
                    if num_1 and num_2 and num_3 and num_4 then
                        if (num_1+num_2+num_3+num_4)%13 == 0 then   --- 和为13的倍数
                            return true
                        end
                    end
                    return false
                end
                local function key3_check(str)    
                    local num_1,num_2,num_3,num_4 = str2number(str)
                    if num_1 and num_2 and num_3 and num_4 then
                        if (num_1+num_2+num_3+num_4)%5 == 0 then    --- 和为5的倍数
                            return true
                        end
                    end    
                    return false
                end
                local function key4_check(str)    
                    local num_1,num_2,num_3,num_4 = str2number(str) --- 和为12的倍数
                    if num_1 and num_2 and num_3 and num_4 then
                        if (num_1+num_2+num_3+num_4)%12 == 0 then
                            return true
                        end
                    end
                    return false
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
                if (t1+t2+t3+t4)%13 == 0 then   --- 和为 13 的倍数
                    num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                    break
                end 
            end
            local key_2 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)
            ---------------------------------------------
            --- key 2
            while true do
                local t1 = math.random(start_num, end_num)
                local t2 = math.random(start_num, end_num)
                local t3 = math.random(start_num, end_num)
                local t4 = math.random(start_num, end_num)
                if (t1+t2+t3+t4)%5 == 0 then   --- 和为 5 的倍数
                    num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                    break
                end 
            end
            local key_3 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)
            ---------------------------------------------
            --- key 3
            while true do
                local t1 = math.random(start_num, end_num)
                local t2 = math.random(start_num, end_num)
                local t3 = math.random(start_num, end_num)
                local t4 = math.random(start_num, end_num)
                if (t1+t2+t3+t4)%12 == 0 then   --- 和为 12 的倍数
                    num_1,num_2,num_3,num_4 = t1,t2,t3,t4
                    break
                end 
            end
            local key_4 = num2alphabet(num_1)..num2alphabet(num_2)..num2alphabet(num_3)..num2alphabet(num_4)  
            
            
            -----------------------------
            local ret_CDKEY = "FVIP-"..key_2.."-"..key_3.."-"..key_4
            if string.find(ret_CDKEY,"#") == nil then
                print(ret_CDKEY)
            end
        end
    end
    ------------------------------------------------------------

    function self:VIP_Start_Check_CDKEY(input_key) ------- 检查入口
        local cdkey = input_key or self:VIP_Get_CDKEY()
        if type(cdkey) ~= "string" then
            return
        end
        if #cdkey < 19 then    ---  XXXX-XXXX-XXXX-XXXX  文本长度为19
            return
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
        if  key_1 == "FVIP" and key2_check(key_2) and key3_check(key_3) and key4_check(key_4) then
            if input_key then
                print("key check succeed:",input_key)
            else
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    print("info cd-key check succeed:",cdkey)
                end
                self:VIP_Do_Check_Succeed_Fns()
            end
        end
        -------------------------------------------------------

    end

    self.inst:ListenForEvent("fwd_in_pdt_event.Get_Cross_Archived_Data_From_Client",function()  --- 监听同步来的数据
        self.inst:DoTaskInTime(0.1,function()
            self:VIP_Start_Check_CDKEY()
        end)
    end)

end



local function replica(self)  
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