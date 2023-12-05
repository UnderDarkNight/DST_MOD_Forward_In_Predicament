------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 货币相关的操作函数
--- 用于两种货币的混合计算，和自动拆解
--- 1 黑币 =>  100 绿币
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    ----------------------------------------------------------
    --- 基础的货币获取和消耗
        function self:Jade_Coin__Has(num)
            return self.inst.replica.fwd_in_pdt_func:Jade_Coin__Has(num)
        end

        function self:Jade_Coin__GetAllNum()
            return self.inst.replica.fwd_in_pdt_func:Jade_Coin__GetAllNum()
        end

        function self:Jade_Coin__Spend_old(num)
            if type(num) ~= "number" then
                return false
            end

            local has_green_coins = 0
            local has_black_coins = 0


            local function each_item_search_fn___num_count(item_inst)
                if item_inst == nil then
                    return
                end
                if item_inst.components.container then
                    item_inst.components.container:ForEachItem(each_item_search_fn___num_count)
                    return
                end

                if item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" then
                    has_green_coins = item_inst.components.stackable.stacksize + has_green_coins
                    return
                end
                if item_inst.prefab == "fwd_in_pdt_item_jade_coin_black" then
                    has_black_coins = item_inst.components.stackable.stacksize + has_black_coins
                    return
                end
            end
            self.inst.components.inventory:ForEachItem(each_item_search_fn___num_count)

            if num > (has_green_coins + 100*has_black_coins) then
                -- print("不够货币",has_green_coins,has_black_coins)
                return false
            end
            -- print("当前货币",has_green_coins,has_black_coins)
            -------------------------------------------------------------------------------------------------------------------
            --- 单独绿币足够
                            if num <= has_green_coins then
                                local need_2_remove_num = num
                                local function each_item_search_fn___remove(item_inst)
                                    if item_inst == nil then
                                        return
                                    end
                                    if item_inst.components.container then
                                        item_inst.components.container:ForEachItem(each_item_search_fn___remove)
                                        return
                                    end
                                    if need_2_remove_num <= 0 then
                                        return
                                    end
                                    if item_inst.prefab ~= "fwd_in_pdt_item_jade_coin_green" then
                                        return
                                    end
                                    
                                    local current_stack_num = item_inst.components.stackable.stacksize
                                    if need_2_remove_num <= current_stack_num then
                                        item_inst.components.stackable:Get(need_2_remove_num):Remove()
                                        need_2_remove_num = 0
                                    else
                                        item_inst:Remove()
                                        need_2_remove_num = need_2_remove_num - current_stack_num
                                    end
                                end
                                self.inst.components.inventory:ForEachItem(each_item_search_fn___remove)
                                return true
                            end
            -------------------------------------------------------------------------------------------------------------------
            --- 绿币不够，黑币来凑
                    --- 第一步，删除所有绿币
                            local function each_item_search_fn___remove(item_inst)
                                if item_inst == nil then
                                    return
                                end
                                if item_inst.components.container then
                                    item_inst.components.container:ForEachItem(each_item_search_fn___remove)
                                    return
                                end

                                if item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" then
                                    item_inst:Remove()
                                end                                
                            end
                            self.inst.components.inventory:ForEachItem(each_item_search_fn___remove)
                            num = num - has_green_coins
                    --- 第二步，计算黑币消耗数量
                            local need_green_coins = num%100 
                            local need_black_coins = math.floor(num/100) + 1
                            local give_back_green_num = 100 - need_green_coins

                            local need_2_remove_num = need_black_coins
                            local function each_item_search_fn__black_remove(item_inst)
                                if item_inst == nil then
                                    return
                                end
                                if item_inst.components.container then
                                    item_inst.components.container:ForEachItem(each_item_search_fn__black_remove)
                                    return
                                end
                                if need_black_coins <= 0 then
                                    return
                                end                                    
                                if item_inst.prefab ~= "fwd_in_pdt_item_jade_coin_black" then
                                    return
                                end

                                local current_stack_num = item_inst.components.stackable.stacksize
                                if need_2_remove_num <= current_stack_num then
                                    item_inst.components.stackable:Get(need_2_remove_num):Remove()
                                    need_2_remove_num = 0
                                else
                                    item_inst:Remove()
                                    need_2_remove_num = need_2_remove_num - current_stack_num
                                end
                            end
                            self.inst.components.inventory:ForEachItem(each_item_search_fn__black_remove)
                            self:GiveItemByPrefab("fwd_in_pdt_item_jade_coin_green",give_back_green_num)
                            


            -------------------------------------------------------------------------------------------------------------------




            return true
        end

        function self:Jade_Coin__Spend(num)
            if type(num) ~= "number" then
                return false
            end


            local the_green_coins_inst = {}
            local the_black_coins_inst = {}
            local function each_item_search_fn___num_count(item_inst)
                if item_inst == nil then
                    return
                end
                if item_inst.components.container and item_inst.components.inventoryitem and item_inst.components.inventoryitem:GetGrandOwner() == self.inst then
                    item_inst.components.container:ForEachItem(each_item_search_fn___num_count)
                    return
                end
                if item_inst.components.inventoryitem == nil then
                    return
                end
                
                if item_inst.components.inventoryitem:GetGrandOwner() ~= self.inst then
                    return
                end

                if item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" then
                    the_green_coins_inst[item_inst] = item_inst.components.stackable.stacksize
                    return
                end
                if item_inst.prefab == "fwd_in_pdt_item_jade_coin_black" then
                    the_black_coins_inst[item_inst] = item_inst.components.stackable.stacksize
                    return
                end
            end
            self.inst.components.inventory:ForEachItem(each_item_search_fn___num_count)


            local has_green_coins = 0
            local has_black_coins = 0

            for k, v in pairs(the_green_coins_inst) do
                has_green_coins = has_green_coins + v
            end
            for k, v in pairs(the_black_coins_inst) do
                has_black_coins = has_black_coins + v
            end

            if (has_green_coins + 100*has_black_coins) < num then
                return false
            end

            ----------- 单独绿币足够
                    if has_green_coins >= num then
                        local need_num = num
                        for temp_inst, temp_num in pairs(the_green_coins_inst) do
                            if temp_num <= need_num then
                                temp_inst:Remove()
                                need_num = need_num - temp_num
                            else
                                temp_inst.components.stackable:Get(need_num):Remove()
                                need_num = 0                                
                            end
                            if need_num <= 0 then
                                break
                            end
                        end
                        return true
                    end
            ---------- 绿币不够，黑币来凑
                    local need_num = num

                    ----- 第一步，计算需要删除的黑币，和返还的绿币
                        local need_black_num = math.ceil(need_num/100)
                        local give_back_green_num = -(need_num - 100*need_black_num)

                        -- print("+++++",need_num,need_black_num,give_back_green_num)
                    ----- 第二步，删除黑币
                        for temp_inst, temp_num in pairs(the_black_coins_inst) do
                            if temp_num <= need_black_num then
                                temp_inst:Remove()
                                need_black_num = need_black_num - temp_num
                            else
                                temp_inst.components.stackable:Get(need_black_num):Remove()
                                need_black_num = 0
                            end
                            if need_black_num <= 0 then
                                break
                            end
                        end
                    ----- 第三步，返还绿币
                        if give_back_green_num >= 1 then
                            self:GiveItemByPrefab("fwd_in_pdt_item_jade_coin_green",give_back_green_num)
                        end

                    return true
        end
    ----------------------------------------------------------
    --- ATM
        --[[
            · 四种模式 ： TUNING["Forward_In_Predicament.Config"].ATM_CROSS_ARCHIVE
                        Admin                跨存档储存
                        Moderator            跨存档储存
                        Anyone               跨存档储存
                        Nobody               仅仅储存在标记位(玩家身上)
            · 标记位 ：  jade_coins_in_atm
            · 标记位 ：  jade_coins_in_atm_save_money_lock   为避免玩家重读存档无限存钱，限制每天只能存一次
        ]]--

        --------- 单纯的数据读取
            function self:Jade_Coin__ATM_Set(num)
                if type(num) ~= "number" then
                    return
                end

                    local config = TUNING["Forward_In_Predicament.Config"].ATM_CROSS_ARCHIVE or "nil"
                    if config == "Nobody" then
                        self:Set("jade_coins_in_atm",num)
                    else
                        local has_right = false
                        if self:IsAdmin() and ( config == "Admin" or config == "Moderator") then
                            has_right = true
                        elseif self:IsModerator() and config == "Moderator" then
                            has_right = true
                        elseif config == "Anyone" then
                            has_right = true 
                        end
                        -------------------------------------------------------
                        if has_right then
                            self:Set_Cross_Archived_Data("jade_coins_in_atm",num)
                        else                    
                            self:Set("jade_coins_in_atm",num)
                        end                
                        -------------------------------------------------------
                    end
            end

            function self:Jade_Coin__ATM_Get()
                    local config = TUNING["Forward_In_Predicament.Config"].ATM_CROSS_ARCHIVE or "nil"
                    if config == "Nobody" then
                        return self:Add("jade_coins_in_atm",0)
                    else
                        local has_right = false
                        if self:IsAdmin() and ( config == "Admin" or config == "Moderator") then
                            has_right = true
                        elseif self:IsModerator() and config == "Moderator" then
                            has_right = true
                        elseif config == "Anyone" then
                            has_right = true 
                        end
                        -------------------------------------------------------
                        if has_right then
                            return self:Get_Cross_Archived_Data("jade_coins_in_atm") or 0
                        else                    
                            return self:Add("jade_coins_in_atm",0)
                        end                
                        -------------------------------------------------------
                    end
            end
        --------- 存钱取钱
            function self:Jade_Coin__ATM_SaveMoney(num) ---- 存钱
                if type(num) ~= "number" or num < 0 then
                    return
                end
                if not self:Jade_Coin__Has(num) then
                    return
                end
                if self:Jade_Coin__Spend(num) then
                    local old_num = self:Jade_Coin__ATM_Get() or 0
                    local new_num = old_num + num
                    self:Jade_Coin__ATM_Set(new_num)
                    -------------------------------------------------------------------------------
                        self:Replica_Set_Simple_Data("jade_coins_in_atm",new_num)   -- 给 client 端hud读取
                            for i = 1, 50, 1 do  --- 为避免 netvars 更新不及时造成显示问题，多刷新那么几下，下发数据。
                                self.inst:DoTaskInTime(i*0.5,function()
                                    self:Replica_Set_Simple_Data("temp_force_update_num",math.random(1000))                            
                                end)
                            end
                    -------------------------------------------------------------------------------
                end          
            end
            function self:Jade_Coin__ATM_WithdrawMoney(num) -- 取钱
                if type(num) ~= "number" or num <= 0 then
                    return
                end
                local current_num = self:Jade_Coin__ATM_Get()
                local out_num = 0
                if num > current_num then
                    out_num = current_num
                else
                    out_num = num
                end
                local rest_num = current_num - out_num
                self:Jade_Coin__ATM_Set(rest_num)
                -------------------------------------------------------------------------------
                    self:Replica_Set_Simple_Data("jade_coins_in_atm",rest_num)  -- 给 client 端hud读取
                    for i = 1, 50, 1 do  --- 为避免 netvars 更新不及时造成显示问题，多刷新那么几下，下发数据。
                        self.inst:DoTaskInTime(i*0.5,function()
                            self:Replica_Set_Simple_Data("temp_force_update_num",math.random(1000))                            
                        end)
                    end
                -------------------------------------------------------------------------------
                if out_num >= 1 then
                    self:GiveItemByPrefab("fwd_in_pdt_item_jade_coin_green",out_num)
                end
            end
            self.inst:ListenForEvent("fwd_in_pdt_event.atm_save_money",function(_,num)
                if type(num) == "number" then
                    self:Jade_Coin__ATM_SaveMoney(num)
                end
            end)
            self.inst:ListenForEvent("fwd_in_pdt_event.atm_withdraw_money",function(_,num)
                if type(num) == "number" then
                    self:Jade_Coin__ATM_WithdrawMoney(num)
                end
            end)
            self:Add_Cross_Archived_Data_Special_Onload_Fn(function()
                self:Replica_Set_Simple_Data("jade_coins_in_atm",self:Jade_Coin__ATM_Get() or 0)   -- 给 client 端hud读取                
            end)
    ----------------------------------------------------------
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(self)

    function self:Jade_Coin__GetAllNum()
        local flag_green,green_coins = self.inst.replica.inventory:Has("fwd_in_pdt_item_jade_coin_green",1,true)
        local flag_black,black_coins = self.inst.replica.inventory:Has("fwd_in_pdt_item_jade_coin_black",1,true)
        local all_has_num = green_coins + black_coins*100
        return all_has_num
    end
    function self:Jade_Coin__Has(num)
        num = num or 1
        local all_has_num = self:Jade_Coin__GetAllNum()
        return num <= all_has_num
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