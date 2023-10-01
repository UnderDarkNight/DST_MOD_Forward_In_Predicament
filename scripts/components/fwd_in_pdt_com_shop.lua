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
            local prefab = temp_item_data.prefab
            if not ret_flag[prefab]  then
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
        for k, v in pairs(list_b) do
            table.insert(list_a,v)
        end
        self.DisplayItemsTable =  list_a
        self:Send_List_2_Client(list_a)
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
---- 玩家进入商店和购买


    function fwd_in_pdt_com_shop:PlayerEnter(player)
        self.inst.replica.fwd_in_pdt_com_shop:PlayerEnter(player)
        -------- 点击购买的时候
        player.__fwd_in_pdt_com_shop__player_event_click = function(player,prefab)
            if type(prefab) == "string" then
                self:PlayerBuy(player,prefab)
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

    function fwd_in_pdt_com_shop:PlayerBuy(player,prefab)
        -- print("info fwd_in_pdt_com_shop  buy",player,prefab)
        local item_cmd_table = self:GetItemDataByPrefab(prefab)
        if item_cmd_table == nil then
            return
        end

        local cost = item_cmd_table.cost
        local num2give = item_cmd_table.num2give or 1

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

return fwd_in_pdt_com_shop
