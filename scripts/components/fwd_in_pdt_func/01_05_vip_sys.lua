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
---
    local reald_decryption = require("fwd_in_pdt_vip_decryption") -- 解密模块
    local temp_fns =  require("fwd_in_pdt_vip_data_api") -- 数据模块
    local VIP_SetData = temp_fns.VIP_SetData
    local VIP_GetData = temp_fns.VIP_GetData

    local cut_fns = require("fwd_in_pdt_cd_key_cutter") -- 切割模块
    local cut_cdk = cut_fns.cut_cdk
    local merge_cdk = cut_fns.merge_cdk

    local skin_api = require("fwd_in_pdt_skin_save_and_get") -- 皮肤模块
    local GetAllSkinDataByUserid = skin_api.GetAllSkinDataByUserid
    local SaveSkinKeyForPlayer = skin_api.SaveSkinKeyForPlayer

    local function GetDataIndex(userid)
        return userid .. ".fwd_in_pdt.cd_key"
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
            self.inst:DoTaskInTime(0,function()                    
                VIP_SetData(GetDataIndex(self.inst.userid),cd_key)
                self:RPC_PushEvent("fwd_in_pdt_vip.save_key_2_local",cd_key)
            end)
        end

        function self:VIP_Get_Local_Key()
            return nil
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
    ---- 
        local vip_flag = false
        local function Set_Is_VIP()
            self:Replica_Set_Simple_Data("vip",true)
            self:VIP_Run_Fns()
            vip_flag = true
        end
        function self:IsVIP()
            return vip_flag
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
            self.inst:PushEvent("fwd_in_pdt_vip.got_cd_key_from_client",cd_key)
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
    ----- 主入口，客户端 传来 cd-key 的时候执行     
        self.inst:ListenForEvent("fwd_in_pdt_vip.got_cd_key_from_client",function(inst,cd_key)
            local data = reald_decryption(inst.userid,cd_key)
            if type(data) == "table" then
                if data.vip then
                    self:VIP_Save_Key_2_Local(cd_key)
                    self:VIP_Save_Key_2_TheWorld(cd_key)
                    self:VIP_Input_Succeed_Congratulations()
                    Set_Is_VIP()
                end
                if type(data.skins) == "table" then
                    self:Personal_Skin_Unlocker_Save_Data(data.skins)
                    self:Personal_Skin_Unlocker_Refresh()
                end

            end
            self:VIP_Run_Checked_Fn()
        end)

        local cut_table = {}
        self.inst:ListenForEvent("fwd_in_pdt_vip.got_cd_key_from_client.cut",function(inst,_table)
            local index = _table.index
            local data = _table.data

            if type(index) == "number" then
                cut_table[index] = data
            elseif index == "end" then
                print("cd_key 传送完毕")
                local cd_key_str = merge_cdk(cut_table)
                print(cd_key_str)
                cut_table = {}
                inst:PushEvent("fwd_in_pdt_vip.got_cd_key_from_client",cd_key_str)
            elseif index == "start" then
                print("cd_key 传送开始")
                cut_table = {}
            end

        end)
    ------------------------------------------------------------------------------------------
    -- 单个皮肤解锁
        self.inst:ListenForEvent("fwd_in_pdt_vip.server_unlock_single_skin",function(inst,cd_key)
            local data = reald_decryption(inst.userid,cd_key) or {}
            print("服务器接到请求解锁单个皮肤命令",data.userid,data.skin)
            if data.skin and data.userid then
                if inst.userid == data.userid then
                    local prefab = self:SkinAPI__Get_Prefab_By_Skin(data.skin)
                    if prefab then
                        self:_SkinAPI__Unlock_Skin({
                            [prefab] = {data.skin}
                        })
                        print("解锁了皮肤",prefab,data.skin)
                        self:RPC_PushEvent2("fwd_in_pdt_vip.server_has_unlocked_single_skin",data.skin)
                    end
                end
            end
        end)
    ------------------------------------------------------------------------------------------
end

local function replica(self)

    local is_vip = false
    local client_side_checked_flag = false
    function self:IsVIP()
        if not client_side_checked_flag then
            client_side_checked_flag = true
            local cd_key = tostring(VIP_GetData(GetDataIndex(self.inst.userid)))
            local data = reald_decryption(self.inst.userid,cd_key)
            if type(data) == "table" and data.vip then
                is_vip = true
                VIP_SetData(GetDataIndex(self.inst.userid),cd_key)
            end
        end
        return is_vip
    end
    local temp_save_cd_key = ""
    function self:Send_CDK_2_server(cd_key_str) --- 给UI调用
        -----------------------------------------------------------
        -- 验证 cdk 的合法性
            local flag,data = pcall(json.decode,cd_key_str)
            if not flag then
                print("CDK 格式错误")
                print(cd_key_str)
                return
            end
        -----------------------------------------------------------
        --- 判定是不是皮肤解锁key
            local temp_data = reald_decryption(self.inst.userid,cd_key_str)
            if type(temp_data) == "table" and temp_data.skin and temp_data.userid and temp_data.userid == self.inst.userid then
                self:Send_Skin_Key_2_server(cd_key_str)
                return
            end
        -----------------------------------------------------------
        temp_save_cd_key = cd_key_str
        pcall(function()
            -----------------------------------------------------------
            --- 切割 CDK
                local cut_cdk_data = cut_cdk(cd_key_str)
            -----------------------------------------------------------
            ---
                self:RPC_PushEvent2("fwd_in_pdt_vip.got_cd_key_from_client.cut",{
                    index = "start",                                
                })
                for i = 1, #cut_cdk_data + 1, 1 do
                    self.inst:DoTaskInTime(0.1*(i),function()
                        if i == #cut_cdk_data + 1 then
                            self:RPC_PushEvent2("fwd_in_pdt_vip.got_cd_key_from_client.cut",{
                                index = "end",                                
                            })
                        else                            
                            self:RPC_PushEvent2("fwd_in_pdt_vip.got_cd_key_from_client.cut",{
                                index = i,
                                data = cut_cdk_data[i]
                            })
                        end
                    end)
                end
            -----------------------------------------------------------
        end)
    end

    local unlocked_skin = {}
    function self:Send_Skin_Key_2_server(skin_key_str) --- 给UI调用
        local data = reald_decryption(self.inst.userid,skin_key_str) or {}
        -- print("Send_Skin_Key_2_server",data.userid,data.skin)
        if type(data) == "table" and data.skin and data.userid and data.userid == self.inst.userid then
            self:RPC_PushEvent2("fwd_in_pdt_vip.server_unlock_single_skin",skin_key_str)
            unlocked_skin[data.skin] = skin_key_str
            print("客户端发送了皮肤CDK")
        end
    end
    self.inst:ListenForEvent("fwd_in_pdt_vip.server_has_unlocked_single_skin",function(inst,skin_name)
        if unlocked_skin[skin_name] then
            SaveSkinKeyForPlayer(inst.userid,unlocked_skin[skin_name])            
        end
    end)


    if TheNet:IsDedicated() then        
        return
    end

    self.inst:ListenForEvent("fwd_in_pdt_vip.save_key_2_local",function(inst)
        VIP_SetData(GetDataIndex(self.inst.userid),temp_save_cd_key)
    end)

    self.inst:DoTaskInTime(3,function()
        print("info FWD_IN_PDT 开始检查是否有 cdk")
        pcall(function()            
            local cd_key = VIP_GetData(GetDataIndex(self.inst.userid))
            if cd_key then
                self:Send_CDK_2_server(cd_key)
            end
        end)
    end)

    self.inst:DoTaskInTime(5,function()
        print("info FWD_IN_PDT 开始检查 皮肤 cdk")
        pcall(function()
            local ALL_SKIN_KEYS = GetAllSkinDataByUserid(self.inst.userid)
            local num = 1
            for skin_key,_ in pairs(ALL_SKIN_KEYS) do
                self.inst:DoTaskInTime(num*0.1,function()
                    self:Send_Skin_Key_2_server(skin_key)
                end)
                num = num + 1
            end
        end)
    end)

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