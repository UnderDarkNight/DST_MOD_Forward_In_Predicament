---------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块给商店使用，配合replica启用
--- 通过replica 下发商品列表
--- net_entity 触发启用玩家界面
--- 商品列表有两个，A类商品和B类商品，通过 json 下发
--[[
    玩家 进入的时候，监听两个事件,且在close 后移除监听
        fwd_in_pdt_event.shop.buy
        fwd_in_pdt_event.shop.close


]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------
local function json_str_net_string(self,str)
    self.inst.replica.fwd_in_pdt_com_shop:Send_List_2_Client(str)
end
local fwd_in_pdt_com_shop = Class(function(self, inst)
    self.inst = inst

    self.Items_List_A = {}      --- 商品列表 A
    self.Items_List_B = {}      --- 商品列表 B

    self.Num_A = 0              --- A 中提取个数
    self.Num_B = 0              --- B 中提取个数

    self.json_str_net_string = ""





end,nil,
{
    json_str_net_string = json_str_net_string
})
--------------------------------------------------------------------------------------------------
--- 数据下发给 client
    function fwd_in_pdt_com_shop:Send_List_2_Client(items_table)
        if type(items_table) == "table" then
            self.json_str_net_string = json.encode(items_table)
        end
    end

--------------------------------------------------------------------------------------------------
--- 数据初始化
    function fwd_in_pdt_com_shop:SetListA(_table)
        if type(_table) == "table" then
            self.Items_List_A = _table
        end
    end
    function fwd_in_pdt_com_shop:SetListB(_table)
        if type(_table) == "table" then
            self.Items_List_B = _table
        end
    end
    function fwd_in_pdt_com_shop:SetNumA(num)
        if type(num) == "number" then
            self.Num_A = num
        end
    end
    function fwd_in_pdt_com_shop:SetNumB(num)
        if type(num) == "number" then
            self.Num_B = num
        end
    end
--------------------------------------------------------------------------------------------------
---- 获取AB商品列表
    local function GetRandomInTable(the_table,num)  --- 从表中获取不重复的 N 个
        if num >= #the_table then
            return the_table
        end

        local ret_flag = {}
        local flag_num = 0
        local result_table = {}
        for i = 1, 100000, 1 do
            local temp_item_data = the_table[math.random(#the_table)]
            local prefab = tostring( temp_item_data.prefab )
            if not ret_flag[prefab] and PrefabExists(prefab) then
                ret_flag[prefab] = true
                flag_num = flag_num + 1
                table.insert(result_table,temp_item_data)
            end
            if flag_num >= num then
                break
            end
        end
        return result_table
    end

    function fwd_in_pdt_com_shop:Refresh_Items_List()   ---- 刷新列表
        local list_a = GetRandomInTable(self.Items_List_A,self.Num_A)
        local list_b = GetRandomInTable(self.Items_List_B,self.Num_B)
        local final_list = {}
        local final_list_flags = {}

        -- for k, v in pairs(list_b) do
        --     table.insert(list_a,v)
        -- end
        for k, item_cmd_table in pairs(list_a) do
            if item_cmd_table and item_cmd_table.prefab and final_list_flags[item_cmd_table.prefab] == nil then
                final_list_flags[item_cmd_table.prefab] = true
                table.insert(final_list,item_cmd_table)
            end
        end
        for k, item_cmd_table in pairs(list_b) do
            if item_cmd_table and item_cmd_table.prefab and final_list_flags[item_cmd_table.prefab] == nil then
                final_list_flags[item_cmd_table.prefab] = true
                table.insert(final_list,item_cmd_table)
            end
        end

        self.DisplayItemsTable =  final_list
        self:Send_List_2_Client(final_list)
    end

    function fwd_in_pdt_com_shop:GetItemDataByPrefab(prefab)
        for k, v in pairs(self.DisplayItemsTable or {}) do
            if v and v.prefab == prefab then
                return v
            end
        end
        return nil
    end

--------------------------------------------------------------------------------------------------
---- 玩家进入商店和交易


    function fwd_in_pdt_com_shop:PlayerEnter(player)
        self.inst.replica.fwd_in_pdt_com_shop:PlayerEnter(player)
        -------- 点击购买的时候
        player.__fwd_in_pdt_com_shop__player_event_click = function(player,prefab)
            if type(prefab) == "string" then
                self:PlayerTrade(player,prefab)
            end
        end
        ------- 退出的时候
        player.__fwd_in_pdt_com_shop__player_event_widget_close = function(player)
            player:RemoveEventCallback("fwd_in_pdt_event.shop.buy",player.__fwd_in_pdt_com_shop__player_event_click)
            player:RemoveEventCallback("fwd_in_pdt_event.shop.close",player.__fwd_in_pdt_com_shop__player_event_widget_close)
            player.__fwd_in_pdt_com_shop__player_event_click = nil
            player.__fwd_in_pdt_com_shop__player_event_widget_close = nil
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("player leave",player)
            end
        end
        player:ListenForEvent("fwd_in_pdt_event.shop.buy",player.__fwd_in_pdt_com_shop__player_event_click)
        player:ListenForEvent("fwd_in_pdt_event.shop.close",player.__fwd_in_pdt_com_shop__player_event_widget_close)
    end

    function fwd_in_pdt_com_shop:PlayerTrade(player,prefab)
        if self.inst:HasTag("trade_back") then
            self:PlayerTradeBack(player,prefab)
        else
            self:PlayerBuy(player,prefab)
        end
    end
--------------------------------------------------------------------------------------------------
----- 购买
    function fwd_in_pdt_com_shop:PlayerBuy(player,prefab)
        -- print("info fwd_in_pdt_com_shop  buy",player,prefab)
        local item_cmd_table = self:GetItemDataByPrefab(prefab)
        if item_cmd_table == nil then
            return
        end

        local cost = item_cmd_table.cost
        local num2give = item_cmd_table.num2give or 1

        ----- vip 打折  8折
        if player.components.fwd_in_pdt_func:IsVIP() then
            cost = math.ceil(cost*0.8)
        end

        if player.components.fwd_in_pdt_func:Jade_Coin__Has(cost) then
            player.components.fwd_in_pdt_func:Jade_Coin__Spend(cost)
            player.components.fwd_in_pdt_func:GiveItemByPrefab(prefab,num2give)
        else
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("钱不够")
            end
        end
    end
--------------------------------------------------------------------------------------------------
---- 回收
    function fwd_in_pdt_com_shop:SetTradeBcak()
        self.inst:AddTag("trade_back")
    end
    function fwd_in_pdt_com_shop:PlayerTradeBack(player,prefab)
        local item_cmd_table = self:GetItemDataByPrefab(prefab)
        if item_cmd_table == nil then
            return
        end
        local cost = item_cmd_table.cost or 1
        local num2give = item_cmd_table.num2give or 1
        local item_insts = {}
        local stackable_flag = false
        -------- 第一步，判断玩家身上的够不够
            local current_num = 0
            player.components.inventory:ForEachItem(function(item)
                if item and item.prefab == prefab then
                    if item.components.stackable then
                        current_num = current_num + item.components.stackable.stacksize
                        stackable_flag = true
                    else
                        current_num = current_num + 1
                    end
                    table.insert(item_insts,item)
                end
            end)
            if current_num < cost then --- 身上的不够
                return
            end
        
        --------- 第二步，删除指定数量的物品
            if stackable_flag then  --- 叠堆的物品
                        for k, item in pairs(item_insts) do
                                local stack_num = item.components.stackable.stacksize
                                if stack_num >= cost then
                                    item.components.stackable:Get(cost):Remove()
                                    cost = 0
                                else
                                    cost = cost - stack_num
                                    item:Remove()
                                end
                                if cost <= 0 then
                                    break
                                end
                        end


            else                    --- 非叠堆的物品
                        current_num = 0
                        for k, item in pairs(item_insts) do
                        item:Remove()
                        current_num = current_num + 1
                        if current_num >= cost then
                            break
                        end
                        end
            end
        -------- 第三步，给货币
            player.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_item_jade_coin_green",num2give)



    end
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------

return fwd_in_pdt_com_shop
