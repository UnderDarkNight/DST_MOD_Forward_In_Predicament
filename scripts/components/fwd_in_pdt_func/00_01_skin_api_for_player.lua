------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  皮肤相关的API ，在玩家身上的
---  SkinAPI__Unlock_Skin 的参数格式： 
                -- _cmd_table = {
                --     ["prefab_A"] = {"skin_A","skin_B"},
                --     ["prefab_B"] = {"skin_C","Skin_D"},
                -- }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function main_com(self)
        self.DataTable.player_unlocked_skins_PREFAB_SKINS = {}          ---- index 为数字 内容为 skin_name
        self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS = {}      ---- index 为skin_name ,内容为数字

        -------------------------------------------------------------
        ---- 解锁皮肤用的API
            function self:_SkinAPI__Unlock_Skin(cmd_table)   ----- 解锁皮肤
                -- _cmd_table = {
                --     ["prefab_A"] = {"skin_A","skin_B"},
                --     ["prefab_B"] = {"skin_C","Skin_D"},
                -- }
                if type(cmd_table) ~= "table" then
                    return
                end
                --------------------------------------------------------------------------------------------
                ---- 连携解锁 skin_link 检查和延迟执行
                local need_2_link_unlock_cmd_table = {}
                local need_2_link_unlock_flag = false

                local all_skins_cmd_tables = FWD_IN_PDT_MOD_SKIN.GET_ALL_SKINS_DATA() or {}    
                for prefab_name, skin_list in pairs(cmd_table) do
                    for k, skin_name in pairs(skin_list) do
                        local skin_cmd_table = all_skins_cmd_tables[skin_name] or {}
                        if skin_cmd_table.skin_link then
                                    -- print("error : skin link check++",skin_cmd_table.skin_link)
                                    local linked_prefab_name,linked_skin_data = self:SkinAPI__Get_Prefab_By_Skin(skin_cmd_table.skin_link)
                                    local linked_skin_name = skin_cmd_table.skin_link
                                    -- print("error : ",linked_prefab_name,linked_skin_name,self:Has_Skin(linked_skin_name,linked_prefab_name))
                                    if not self:SkinAPI__Has_Skin(linked_skin_name,linked_prefab_name) then
                                        need_2_link_unlock_flag = true
                                        need_2_link_unlock_cmd_table[linked_prefab_name] = need_2_link_unlock_cmd_table[linked_prefab_name] or {}
                                        table.insert(need_2_link_unlock_cmd_table[linked_prefab_name],linked_skin_name)
                                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                                            print("linked unlock",linked_prefab_name,linked_skin_name)
                                        end
                                    end
                        end
                    end
                end

                if need_2_link_unlock_flag then ---- 链路解锁
                    self.inst:DoTaskInTime(1,function()
                        self:SkinAPI__Unlock_Skin(need_2_link_unlock_cmd_table)
                    end)
                end

                --------------------------------------------------------------------------------------------
                ----- 插入表格
                self.DataTable.player_unlocked_skins_PREFAB_SKINS = self.DataTable.player_unlocked_skins_PREFAB_SKINS or {}
                self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS or {}
                for prefab_name, skin_list in pairs(cmd_table) do
                    if type(prefab_name) == "string" and type(skin_list) == "table" then
                        for k, skin_name in pairs(skin_list) do
                            self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] or {}
                            self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] or {}
                            
                            if self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name][skin_name] == nil then    --- 没解锁过的皮肤
                                -- local current_max_index = #self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name]
                                -- local new_index = current_max_index + 1
                                table.insert(self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name],skin_name)
                                -- self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name][new_index] = skin_name
                                self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name][skin_name] = #self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name]
                            end
                        end
                    end
                end
                --------------------------------------------------------------------------------------------
                ---- 同步数据去客户端和TheWorld
                self:Replica_Simple_PushEvent("fwd_in_pdt_com_skin.hud_data_sync",{
                    PREFAB_SKINS = self.DataTable.player_unlocked_skins_PREFAB_SKINS,
                    PREFAB_SKINS_IDS = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS
                })
                if self.inst.userid then
                    local index = "fwd_in_pdt_com_skins."..tostring(self.inst.userid)
                    TheWorld.components.fwd_in_pdt_data:Set(index,self.DataTable.player_unlocked_skins_PREFAB_SKINS)
                end
                --------------------------------------------------------------------------------------------
            end
            function self:SkinAPI__Unlock_Skin(cmd_table)   ------ 延迟一丢丢，避免初始化的时候造成问题。
                self.inst:DoTaskInTime(0.2,function()
                    self:_SkinAPI__Unlock_Skin(cmd_table)
                end)
            end

            function self:SkinAPI__Has_Skin(skin_name,prefab_name)
                if skin_name == nil then
                    return true
                end
                if prefab_name then
                    if self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] and self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name][skin_name] ~= nil then
                        return true
                    else
                        return false
                    end
                else
                    for prefab_name, skin_list in pairs(self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS) do
                        if type(skin_list) == "table" and skin_list[skin_name] ~= nil then
                            return true
                        end
                    end
                    return false
                end
            end

            function self:SkinAPI__Get_Prefab_By_Skin(skin_name)
                local skin_data = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)]
                if type(skin_data) == "table" then
                    local prefab_name = skin_data.prefab_name
                    if prefab_name == nil then
                        print("error SkinAPI__Get_Prefab_By_Skin",skin_name) 
                    end
                    return prefab_name,skin_data
                end
            end
        
            ------ 给外部调用，获取随机皮肤用的,返回的数据可直接给 self:_SkinAPI__Unlock_Skin
            function self:SkinAPI__Get_Random_Locked_Skin(num)
                num = num or 1
                local prep_skin_list = {}
                local count_num = 0
                for skin_name, cmd_table in pairs(FWD_IN_PDT_MOD_SKIN.SKINS_DATA) do
                    if type(skin_name) == "string" and type(cmd_table) == "table" and not self:SkinAPI__Has_Skin(skin_name,cmd_table.prefab_name) then
                        table.insert(prep_skin_list,skin_name)
                        count_num = count_num + 1
                    end
                end     
                
                if num > count_num then
                    num = count_num
                end
                if num == 0 then
                    return {}
                end

                local ret_skin_list = {}
                local safe_num = 100
                while num > 0 and safe_num > 0 do
                    local temp_skin_name = prep_skin_list[math.random(#prep_skin_list)]
                    if temp_skin_name and ret_skin_list[temp_skin_name] ~= true then
                        ret_skin_list[temp_skin_name] = true
                        num = num - 1
                    end
                    safe_num = safe_num - 1
                end

                ------------------- 生成解锁表
                local cmd_table_for_unlock = {}
                for skin_name, flag in pairs(ret_skin_list) do
                    if skin_name and FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin_name] then
                        local this_skin_cmd_table = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin_name]
                        local prefab_name = this_skin_cmd_table.prefab_name
                        if prefab_name then
                            cmd_table_for_unlock[prefab_name] =  cmd_table_for_unlock[prefab_name] or {}
                            table.insert(cmd_table_for_unlock[prefab_name],skin_name)
                            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                                print("SkinAPI__Get_Random_Locked_Skin",prefab_name,skin_name)
                            end
                        end
                    end
                end
                return cmd_table_for_unlock
            end

            function self:SkinAPI__Get_Unlocked_Num()   --- 数一下当前解锁的皮肤数
                local num = 0
                for prefab_name, skin_list in pairs(self.DataTable.player_unlocked_skins_PREFAB_SKINS) do
                    for index, skin_name in pairs(skin_list) do
                        if skin_name then
                            num = num + 1
                        end
                    end
                end
            end

            function self:SkinAPI__Get_All_Skin_Num()   --- 数一下所有系统拥有皮肤的
                if self.TempData.__________all_skins_num == nil then
                    local num = 0
                    for skin_name, v in pairs(FWD_IN_PDT_MOD_SKIN.SKINS_DATA) do
                        if skin_name and v then
                            num = num + 1
                        end
                    end
                    self.TempData.__________all_skins_num = num
                    return num
                else
                    return self.TempData.__________all_skins_num
                end
            end
        -------------------------------------------------------------
        ----- 给皮肤工具调用的
            function self:SkinAPI__Get_Prefab_Next_Skin_By_Current(prefab_name,current_skin)
                -- print("SkinAPI__Get_Prefab_Next_Skin_By_Current",current_skin)

                self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] or {}
                self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] or {}
                local current_index_num = 0
                if current_skin == nil then --- 没皮肤则返回第一个皮肤，或者 nil
                    current_index_num = 0
                else
                    current_index_num = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name][current_skin]
                end
                -- print("current_index_num",current_index_num)

                local next_index_num = current_index_num + 1
                return self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name][next_index_num] or nil,next_index_num
            end

            function self:SkinAPI__Get_Prefab_Last_Skin_By_Current(prefab_name,current_skin)
                -- print("SkinAPI__Get_Prefab_Last_Skin_By_Current",current_skin)

                self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] or {}
                self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name] or {}

                local current_index_num = nil

                if current_skin == nil then   --- 没皮肤，则返回最后一个皮肤
                    current_index_num = #self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name] +1
                else
                    current_index_num = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS[prefab_name][current_skin]
                end

                -- print("current_index_num",current_index_num)
                local last_index_num = current_index_num - 1
                return self.DataTable.player_unlocked_skins_PREFAB_SKINS[prefab_name][last_index_num] or nil,last_index_num
            end

            function self:SkinAPI__Set_Target_Next_Skin(target_inst,last_flag)  --- 给扫把调用
                if target_inst == nil or not target_inst:HasTag("fwd_in_pdt_com_skins") then
                    return
                end
                local prefab_name = target_inst.prefab
                local current_skin = target_inst.components.fwd_in_pdt_func:SkinAPI__GetCurrent()
                local next_skin = nil
                if last_flag then
                    next_skin = self:SkinAPI__Get_Prefab_Last_Skin_By_Current(prefab_name,current_skin)
                else
                    next_skin = self:SkinAPI__Get_Prefab_Next_Skin_By_Current(prefab_name,current_skin)
                end

                -- if next_skin ~= nil and not self:SkinAPI__Has_Skin(next_skin,prefab_name) then
                --     return
                -- end

                print("info :SkinAPI__Set_Target_Next_Skin   ",current_skin,next_skin)
                target_inst.components.fwd_in_pdt_func:SkinAPI__SetCurrent(next_skin)
                
                ----- 发送个event
                target_inst:PushEvent("fwd_in_pdt_event.next_skin",{
                    skin_name = next_skin,
                    last_skin_name = current_skin,
                    doer = self.inst
                })
            end

        -------------------------------------------------------------
        ---- 制作栏RPC回传event , 解决带洞穴的情况下制作的物品没皮肤的问题
            self.inst:ListenForEvent("fwd_in_pdt_com_skins.data_from_rpc",function(inst,_table)
                if _table and _table.prefab then
                    self.TempData.__product_data = _table
                end
            end)
            function self:SkinAPI__Get_RPC_Data()
                if self.TempData.__product_data then
                    local prefab,skin = self.TempData.__product_data.prefab,self.TempData.__product_data.skin
                    self.TempData.__product_data = nil
                    return prefab,skin
                else
                    return nil,nil
                end
            end
        -------------------------------------------------------------
        ---- 同步去TheWorld
            function self:SkinAPI__Sync_With_TheWorld()
                --- self.DataTable.player_unlocked_skins_PREFAB_SKINS  储存和同步这个表足够了
                if self.inst.userid == nil then
                    return
                end
                local index = "fwd_in_pdt_com_skins."..tostring(self.inst.userid)
                local data_from_world = TheWorld.components.fwd_in_pdt_data:Get(index) or {}
                local data_from_self  = self.DataTable and self.DataTable.player_unlocked_skins_PREFAB_SKINS and self.DataTable.player_unlocked_skins_PREFAB_SKINS or {}
                
                ------------------------------ 合并表格
                local new_datas = {}
                for prefab_name, skin_list in pairs(data_from_world) do
                    if type(prefab_name) == "string" and type(skin_list) == "table" then
                        new_datas[prefab_name] = new_datas[prefab_name] or {}
                        for i, skin_name in ipairs(skin_list) do
                            if skin_name then
                                new_datas[prefab_name][skin_name] = true
                            end
                        end
                    end
                end

                for prefab_name, skin_list in pairs(data_from_self) do
                    if type(prefab_name) == "string" and type(skin_list) == "table" then
                        new_datas[prefab_name] = new_datas[prefab_name] or {}
                        for i, skin_name in ipairs(skin_list) do
                            if skin_name then
                                new_datas[prefab_name][skin_name] = true
                            end
                        end
                    end
                end
                ------------------------------ 转置一下表格 给 unlock 函数
                local skin_unlock_cmd_table = {}
                for prefab_name, skin_list in pairs(new_datas) do
                    if type(prefab_name) == "string" and type(skin_list) == "table" then
                        skin_unlock_cmd_table[prefab_name] = skin_unlock_cmd_table[prefab_name] or {}
                        for skin_name, flag in pairs(skin_list) do
                        if type(skin_name) == "string" then
                                table.insert(skin_unlock_cmd_table[prefab_name],skin_name)
                        end
                        end
                    end
                end
                self:SkinAPI__Unlock_Skin(skin_unlock_cmd_table)
                ------------------------------
            end

        -------------------------------------------------------------
        ---- onload 的时候
            function self:SkinAPI__OnLoad()
                self:SkinAPI__Sync_With_TheWorld()
                -- self:Replica_Simple_PushEvent("fwd_in_pdt_com_skin.hud_data_sync",{
                --     PREFAB_SKINS = self.DataTable.player_unlocked_skins_PREFAB_SKINS,
                --     PREFAB_SKINS_IDS = self.DataTable.player_unlocked_skins_PREFAB_SKINS_IDS
                -- })
            end
            -- self.inst:DoTaskInTime(0,function()     ---- 没办法更早的执行，只能用这个
            --     self:SkinAPI__OnLoad()
            -- end)
            self:Add_OnLoad_Fn(function()
                self:SkinAPI__OnLoad()
            end)
        -------------------------------------------------------------
end

local function replica(self)
    self.TempData.____PREFAB_SKINS_IDS = {}
    self.TempData.____PREFAB_SKINS = {}


    ----------------------------------------------------------------------------------------------------------
    ------ 下发来数据的时候，往HUD添加，并刷新制作栏
        self.inst:ListenForEvent("fwd_in_pdt_com_skin.hud_data_sync",function(_,cmd_data)
            if cmd_data and cmd_data.PREFAB_SKINS_IDS and cmd_data.PREFAB_SKINS then
                self.TempData.____PREFAB_SKINS_IDS = cmd_data.PREFAB_SKINS_IDS
                self.TempData.____PREFAB_SKINS  = cmd_data.PREFAB_SKINS
                if self.inst.HUD then   ---- 添加HUD 选项

                    -- STRINGS.SKIN_NAMES[string.upper( tostring(cmd_table.skin_name) )] = cmd_table.skin_name
                    for prefab_name, skins_list in pairs(self.TempData.____PREFAB_SKINS) do
                        if prefab_name and type(skins_list) == "table" then
                            local ALL_PREFAB_SKIN_DATA = FWD_IN_PDT_MOD_SKIN.SKINS_DATA_PREFABS[prefab_name]
                            if ALL_PREFAB_SKIN_DATA ~= nil then

                                for skin_name, skin_cmd_table in pairs(ALL_PREFAB_SKIN_DATA) do
                                    if type(skin_cmd_table) == "table" and skin_cmd_table.name then
                                        STRINGS.SKIN_NAMES[string.upper( tostring(skin_name) )] = skin_cmd_table.name
                                    end
                                end
                                PREFAB_SKINS[prefab_name] = self.TempData.____PREFAB_SKINS[prefab_name]
                                PREFAB_SKINS_IDS[prefab_name] = self.TempData.____PREFAB_SKINS_IDS[prefab_name]

                            else
                                print("error fwd_in_pdt_com_skin.hud_data_sync",prefab_name)
                            end

                        end
                    end
                    -- self.inst:PushEvent("playeractivated")   --- 
                end
                -- self.inst:PushEvent("refreshcrafting")  ---- 刷新UI
                self:SkinAPI__RefreshHUD()
            end
        end)

    ----------------------------------------------------------------------------------------------------------
    ------- 给hook 进系统的API 进行检查执行
        function self:SkinAPI__Has_Skin(skin_name,prefab_name)
            if skin_name == nil then
                return true
            end
            if prefab_name then
                if self.TempData.____PREFAB_SKINS_IDS[prefab_name] and self.TempData.____PREFAB_SKINS_IDS[prefab_name][skin_name] ~= nil then
                    return true
                else
                    return false
                end
            else
                for temp_prefab_name, skin_ids in pairs(self.TempData.____PREFAB_SKINS_IDS) do
                    if type(skin_ids) == "table" and skin_ids[skin_name] then
                        return true
                    end
                end
                return false
            end

        end

    -------- 有洞穴的情况下，需要回传数据确定玩家选的是哪个皮肤
        -------- 【笔记】自从官方改了相关的API，通过回传index（number）来选择皮肤，只能用rpc回传客户端的皮肤
        function self:SkinAPI__Set_RPC_Data(prefab,skin)
            if not TheWorld.ismastersim then
                self:RPC_PushEvent2("fwd_in_pdt_com_skins.data_from_rpc",{
                    prefab = prefab,
                    skin = skin,
                })
            else
                self.inst:PushEvent("fwd_in_pdt_com_skins.data_from_rpc",{
                    prefab = prefab,
                    skin = skin,
                })
            end
        end

    --------- 刷新制作栏HUD
        function self:SkinAPI__RefreshHUD()
            pcall(function()
                -- inst.HUD.controls --> controls.lua
                -- inst.HUD.controls.craftingmenu -->  craftingmenu_hud.lua 
                -- inst.HUD.controls.craftingmenu.craftingmenu  --> craftingmenu_widget.lua
                -- inst.HUD.controls.craftingmenu.craftingmenu.details_root  --> craftingmenu_details.lua
                -- inst.HUD.controls.craftingmenu.craftingmenu.details_root.skins_spinner  --> craftingmenu_skinselector.lua

                self.inst.HUD.controls.craftingmenu.craftingmenu:Initialize()    --- 初始化 制作栏

                -- self.inst.HUD.controls.craftingmenu.craftingmenu.details_root:refresh()    --- 单个物品的详情页
                
            end)
        end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    if not fwd_in_pdt_func.inst:HasTag("player") then
        return
    end
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end

end
