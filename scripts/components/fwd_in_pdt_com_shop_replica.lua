---------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块给商店使用，配合replica启用
--- 通过replica 下发商品列表
--- net_entity 触发启用玩家界面
--- 商品列表有两个，A类商品和B类商品，通过 json 下发
---------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_shop = Class(function(self, inst)
    self.inst = inst
    self.items = {}

    self.json_str_net_string = net_string(inst.GUID, "fwd_in_pdt_com_shop.list", "fwd_in_pdt_com_shop.list")
    self.inst:ListenForEvent("fwd_in_pdt_com_shop.list",function()
        local cmd_table = json.decode(self.json_str_net_string:value())
        self:SaveItemsList(cmd_table)
    end)

    --------------------------------------
    --- 玩家触发打开界面
        self.__player_inst = net_entity(inst.GUID, "fwd_in_pdt_com_shop.player", "fwd_in_pdt_com_shop.player")
        self.inst:ListenForEvent("fwd_in_pdt_com_shop.player",function()
            local player = self.__player_inst:value()
            if ThePlayer and player and player:HasTag("player") and player == ThePlayer then
                -- ThePlayer:PushEvent("fwd_in_pdt_client_event.shop_open",self:GetItemsList())
                self:Client_PlayerEnter()

            end
        end)
end)
-----------------------------------------------------------------------------------------------------------
--- 数据同步以及表格获取
    function fwd_in_pdt_com_shop:Send_List_2_Client(cmd_table_or_string)
        if type(cmd_table_or_string) == "table" then
            self.json_str_net_string:set(json.encode(cmd_table_or_string))
        elseif type(cmd_table_or_string) == "string" then
            self.json_str_net_string:set(cmd_table_or_string)
        end
    end
    function fwd_in_pdt_com_shop:SaveItemsList(cmd_table)
        self.items = cmd_table
    end
    function fwd_in_pdt_com_shop:GetItemsList()
        return self.items or {}
    end

    function fwd_in_pdt_com_shop:PlayerEnter(player)
        print("fwd_in_pdt_com_shop replica  PlayerEnter ",player)
        self.__player_inst:set(player)
        self.inst:DoTaskInTime(0.5,function()
            self.__player_inst:set(self.inst)
        end)
    end
-----------------------------------------------------------------------------------------------------------
--- 只在客户端执行，必须确认 ThePlayer 存在
function fwd_in_pdt_com_shop:Client_PlayerEnter()
    if ThePlayer then
        ThePlayer.HUD:fwd_in_pdt_shop_open(self:GetItemsList(),self.inst:HasTag("trade_back"))    
    end
end
-----------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_shop
