------------------------------------------------------------------------------------------------------------------------------
------ replica 模块
------ 根据服务器来的简单数据初始化本模块拥有的函数。
------ 可以传送简单的 数据table
------------------------------------------------------------------------------------------------------------------------------



local fwd_in_pdt_func = Class(function(self, inst)
    self.inst = inst
    self.is_replica = true
    self.__loaded_modules = {}  --- 已经加载的模块，避免重复加载
    self.simple_data_table = {}
    self.tempData = {}
    self.TempData = self.tempData
    -----------------------------------------------------------------------------------------------------------------------
    self._simple_data_table_json_str = net_string(self.inst.GUID, "fwd_in_pdt_net_sting","fwd_in_pdt_func.replica.simple_data_table_json_str") 
    if not TheWorld.ismastersim then
        self.inst:ListenForEvent("fwd_in_pdt_func.replica.simple_data_table_json_str",function()
            local str = self._simple_data_table_json_str:value()
            self:set_simple_data_table_json_str(str)
        end)
    end    
    -- -----------------------------------------------------------------------------------------------------------------------
    -- ---- 暂时不再使用的模块。
        -- local module_fns = {
        --     ["rpc"] = require("components/fwd_in_pdt_func/02_RPC_Event"),                 ---- 使用RPC形式下发/上传 event 数据
        -- }


        -- if self.inst:HasTag("player") and self.inst.userid and type(self.inst.userid) == "string" then  --- 玩家独有的replica
        --     local player_only_module_fns = {
        --         ["cross_archived_data_sys"] = require("components/fwd_in_pdt_func/08_cross_archived_data_sys"),        ---- 跨存档数据系统。
        --     }
        --     for module_name, fn in pairs(player_only_module_fns) do
        --         module_fns[module_name] = fn
        --     end        
        -- end

        -- for module_name, fn in pairs(module_fns) do
        --     if fn and type(fn) == "function" then
        --         fn(self)
        --     end
        -- end
    -- -----------------------------------------------------------------------------------------------------------------------
end)

---- 使用 net_string 下发参数给replica 初始化。
function fwd_in_pdt_func:Init(cmd_table,...)    
    -- print("info : fwd_in_pdt_func replica init fn")
    if cmd_table  then
        local _table = {}
        if type(cmd_table)== "table" then   ------------    参数形式 1
            _table = cmd_table
        elseif type(cmd_table) == "string" then    ---------   参数形式 2
            local args = {...}
            table.insert(_table,cmd_table)
            for k, v in pairs(args) do
                if v and type(v) == "string" then
                    table.insert(_table,v)
                end
            end
        else
            print("fwd_in_pdt_func replica :Init error")
            return
        end

        local module_fns = {
            ["skin_player"]      = require("components/fwd_in_pdt_func/00_01_skin_api_for_player"),       ---- 皮肤API  玩家专属
            ["skin"]      = require("components/fwd_in_pdt_func/00_02_skin_api_for_others"),       ---- 非玩家用的皮肤API

            ["player"]      = require("components/fwd_in_pdt_func/01_00_player_only_func"),       ---- 玩家独有的func
            ["camera"]      = require("components/fwd_in_pdt_func/01_01_ThePlayerCamera"),       ---- 玩家镜头。
            ["picksound"]   = require("components/fwd_in_pdt_func/01_02_pick_sound"),       ---- 客制化拾取声音。
            ["pre_dodelta"]     = require("components/fwd_in_pdt_func/01_03_com_pre_dodleta"),         ---- 在官方的 DoDodelta之前，添加一些拦截API
            ["cross_archived_data_sys"] = require("components/fwd_in_pdt_func/01_04_cross_archived_data_sys"),        ---- 跨存档储存系统
            ["vip"] = require("components/fwd_in_pdt_func/01_05_vip_sys"),        ---- vip / cd-key 系统
            ["daily_task"] = require("components/fwd_in_pdt_func/01_06_daily_task"),        ---- 日常系统
            ["jade_coin_sys"] = require("components/fwd_in_pdt_func/01_07_jade_coin_sys"),        ---- 专属货币的自动拆解和计数

            ["rpc"] = require("components/fwd_in_pdt_func/02_RPC_Event"),                 ---- 使用RPC形式下发/上传 event 数据
            ["long_update"] = require("components/fwd_in_pdt_func/04_LongUpdate"),        ---- 长更新，可以用于作物，或者加载范围重刷
                        
            ["map_modifier"] = require("components/fwd_in_pdt_func/09_theworld_map_modifier"),        ---- 地图修改器（包括资源刷新器）
            ["growable"] = require("components/fwd_in_pdt_func/10_growable"),        ---- 植物类使用的生长组件
            ["mouserover_colourful"] = require("components/fwd_in_pdt_func/11_mouserover_str_colourful"),        ---- 鼠标放上去显示颜色的组件
            ["item_tile_fx"] = require("components/fwd_in_pdt_func/12_item_tile_icon_fx"),        ---- 物品栏图标的动画特效

            ["normal_api"] = require("components/fwd_in_pdt_func/13_normal_api"),        ---- 常用API
        }

        for k, module_name in pairs(_table) do
            if type(module_name) == "string" and module_fns[module_name] and type(module_fns[module_name]) == "function" and self.__loaded_modules[module_name] ~= true then
                self.__loaded_modules[module_name] = true
                module_fns[module_name](self)
            end
        end
    end
end

function fwd_in_pdt_func:set_simple_data_table_json_str(str) -- 给主模块调用
    if type(str) ~= "string" then
        return
    end
    -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
    --     print("info simple_data_table_json_str",self.inst,str)
    -- end
    if TheWorld.ismastersim then
        self._simple_data_table_json_str:set(str)
    end

    -- self.simple_data_table = json.decode(str)
    local crash_flag , temp_table = pcall(json.decode,str)
    if crash_flag == true and type(temp_table) == "table" then  -- 没发生崩溃
        for index, data in pairs(temp_table) do
            self.simple_data_table[index] = data
        end
    end

    --- 模块初始化
    if self.simple_data_table.init_cmd_table then
        self:Init(self.simple_data_table.init_cmd_table)
    end
    ---- 简单的事件触发器。
    if self.simple_data_table["Simple_PushEvent"] and self.simple_data_table["Simple_PushEvent"].event_name then
        self.inst:PushEvent(self.simple_data_table["Simple_PushEvent"].event_name,self.simple_data_table["Simple_PushEvent"].data)
    end
end

function fwd_in_pdt_func:Replica_Get_Simple_Data(name_str)
    if type(name_str) == "string" then
        return self.simple_data_table[name_str]
    end
    return nil
end

function fwd_in_pdt_func:Replica_Set_Simple_Data(name_str,data)   --- 客户端单独使用，一定程度上有数据同步问题，慎用。
    if type(name_str) ~= "string" then
        return
    end
    self.simple_data_table[name_str] = data
end

return fwd_in_pdt_func