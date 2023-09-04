------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 货币相关的操作函数
--- 用于两种货币的混合计算，和自动拆解
--- 1 黑币 =>  100 绿币
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    function self:Jade_Coin__Has(num)
        return self.inst.replica.fwd_in_pdt_func:Jade_Coin__Has(num)
    end

    function self:Jade_Coin__GetAllNum()
        return self.inst.replica.fwd_in_pdt_func:Jade_Coin__GetAllNum()
    end

    function self:Jade_Coin__Spend(num)
        if type(num) ~= "number" then
            return false
        end
        if not self:Jade_Coin__Has(num) then
            return false
        end 
        local flag_green,has_green_coins = self.inst.replica.inventory:Has("fwd_in_pdt_item_jade_coin_green",1,true)
        local flag_black,has_black_coins = self.inst.replica.inventory:Has("fwd_in_pdt_item_jade_coin_black",1,true)
        -- print("目前拥有 绿",has_green_coins,"黑",has_black_coins)
        -------- 单独绿币足够了
            if num <= has_green_coins then   
                    print("绿币足够",has_green_coins,has_black_coins)
                    local need_to_remove_num = num
                    self.inst.components.inventory:ForEachItem(function(item_inst)  
                        if not (item_inst and  item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" ) then
                            return
                        end
                        if  need_to_remove_num <= 0 then    --- 凑够数了，后面不继续了
                            return
                        end

                        if item_inst.components.stackable.stacksize >= need_to_remove_num then
                            item_inst.components.stackable:Get(need_to_remove_num):Remove()
                            need_to_remove_num = 0
                        else
                            need_to_remove_num = need_to_remove_num - item_inst.components.stackable.stacksize
                            item_inst:Remove()
                        end
                        
                    end)

                return true
            end
        ------- 绿币不够，黑币来凑
            
            local need_green_coins = num%100 
            local need_black_coins = math.floor(num/100)
            -- print("绿币不够 need ",need_green_coins,need_black_coins)

            if need_green_coins <= has_green_coins and need_black_coins <= has_black_coins  then --- 已有的绿币足够,黑币足够，直接清场。
                    -- print("已有的绿币足够,黑币足够，直接清场")
                    self.inst.components.inventory:ForEachItem(function(item_inst)  
                        if not item_inst then
                            return
                        end

                        if item_inst.prefab == "fwd_in_pdt_item_jade_coin_green"  then

                            if  need_green_coins <= 0 then    --- 凑够数了，后面不继续了
                                return
                            end

                            if item_inst.components.stackable.stacksize >= need_green_coins then
                                item_inst.components.stackable:Get(need_green_coins):Remove()
                                need_green_coins = 0
                            else
                                need_green_coins = need_green_coins - item_inst.components.stackable.stacksize
                                item_inst:Remove()
                            end

                        end

                        if item_inst.prefab == "fwd_in_pdt_item_jade_coin_black" then
                            if need_black_coins <= 0 then
                                return
                            end
                            if item_inst.components.stackable >= need_black_coins then
                                item_inst.components.stackable:Get(need_black_coins):Remove()
                                need_black_coins = 0
                            else
                                need_black_coins = need_black_coins - item_inst.components.stackable.stacksize
                                item_inst:Remove() 
                            end
                        end
                        
                    end)
                return true
            else        ----- 绿币不够 
                    -- print("绿币不够，黑币填充")

                    ------ 删掉所有绿币
                    local current_green_coins = 0   -- 计数删了多少绿币
                    local need_2_remove_item_inst = {}  --- 后面统一删除，先添加到这个表里
                    self.inst.components.inventory:ForEachItem(function(item_inst)
                        if item_inst and item_inst.prefab == "fwd_in_pdt_item_jade_coin_green" then
                            current_green_coins = current_green_coins + item_inst.components.stackable.stacksize
                            -- item_inst:Remove()
                            need_2_remove_item_inst[item_inst] = true
                        end
                    end)

                    num = num - current_green_coins    -- 需要继续删多少绿币
                    need_black_coins = need_black_coins + 1     -- 黑币消耗+1
                    local rest_green_coins_num = 100 - num          -- 需要退还多少绿币
                    -- print("------green",need_green_coins,has_green_coins)
                    -- print("------black",need_black_coins,has_black_coins)
                    if need_black_coins > has_black_coins then  -- 黑币不够，计算失败
                        return false
                    end
                    --- 黑币足够，删光已有的绿币，和足够的黑币。
                        for k, v in pairs(need_2_remove_item_inst) do
                            if k and v then
                                k:Remove()
                            end
                        end
                        self.inst.components.inventory:ForEachItem(function(item_inst)
                            if not (item_inst and item_inst.prefab == "fwd_in_pdt_item_jade_coin_black") then
                                return
                            end
                            if need_black_coins <= 0 then
                                return
                            end
                            if item_inst.components.stackable.stacksize >= need_black_coins then
                                item_inst.components.stackable:Get(need_black_coins):Remove()
                                need_black_coins = 0
                            else
                                need_black_coins = need_black_coins - item_inst.components.stackable.stacksize
                                item_inst:Remove()
                            end
                        end)
                    --- 退还绿币,做避免卡顿处理
                        local rest_green_coins_inst = SpawnPrefab("fwd_in_pdt_item_jade_coin_green")
                        local temp_max_stack_num = rest_green_coins_inst.components.stackable.maxsize

                        local temp_rest_num = rest_green_coins_num%temp_max_stack_num   -- 不够一组的数量
                        local temp_stack_num = math.floor(rest_green_coins_num/temp_max_stack_num)  -- 组数
                        if temp_rest_num >= 0 then
                            rest_green_coins_inst.components.stackable.stacksize = temp_rest_num
                            self.inst.components.inventory:GiveItem(rest_green_coins_inst)
                        else
                            rest_green_coins_inst:Remove()
                        end

                        if temp_stack_num > 0 then
                            while temp_stack_num > 0 do
                                local temp_item_inst = SpawnPrefab("fwd_in_pdt_item_jade_coin_green")
                                temp_item_inst.components.stackable.stacksize = temp_max_stack_num
                                self.inst.components.inventory:GiveItem(temp_item_inst)
                                temp_stack_num = temp_stack_num - 1
                            end
                        end

                return true



            end




    end

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