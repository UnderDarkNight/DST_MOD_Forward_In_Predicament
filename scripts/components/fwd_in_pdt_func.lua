----------------------------------------------------------------------------------------------------------------------------------
-- 通用数据储存库，用来储存各种 【文本】数据
-- 模块使用了 replica 和 net_vars 下发初始化数据。整个模块不能在 client 端加载了。
-- 其他MOD想要hook 进本模块，监听事件  self.inst:PushEvent("fwd_in_pdt.event.main_func_inited")  后做函数hook即可。
----------------------------------------------------------------------------------------------------------------------------------
-- local function loaded_modules_name_json_str(self,str)
--     self.inst.replica.fwd_in_pdt_func:On_Replica_Init_Json(str)
-- end
local function simple_data_table_json_str(self,str)
    self.inst.replica.fwd_in_pdt_func:set_simple_data_table_json_str(str)
end
local fwd_in_pdt_func = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.tempData = {}
    self.TempData = self.tempData
    self.tempData.__func_init_loaded_module_names = {}  --- 已经加载了的模块名字，防止重复加载同一个模块。
    self.loaded_modules_name_json_str = nil --- 用来下发初始化的模块数据给 replica 。不用担心新进来的玩家不会得到下发的数据。
    self.simple_data_table = {}
    self.simple_data_table_json_str = nil
end,
nil,
{
    -- loaded_modules_name_json_str = loaded_modules_name_json_str,    ---- self.loaded_modules_name_json_str 变动的时候会直接执行这里的函数。
    simple_data_table_json_str = simple_data_table_json_str
})

function fwd_in_pdt_func:SaveData(DataName_Str,theData)
    if DataName_Str then
        self.DataTable[DataName_Str] = theData
    end
end

function fwd_in_pdt_func:ReadData(DataName_Str)
    if DataName_Str then
        if self.DataTable[DataName_Str] then
            return self.DataTable[DataName_Str]
        else
            return nil
        end
    end
end
function fwd_in_pdt_func:Get(DataName_Str)
    return self:ReadData(DataName_Str)
end
function fwd_in_pdt_func:Set(DataName_Str,theData)
    self:SaveData(DataName_Str, theData)
end

function fwd_in_pdt_func:Add(DataName_Str,num)
    if self:Get(DataName_Str) == nil then
        self:Set(DataName_Str, 0)
    end
    if type(num) ~= "number" or type(self:Get(DataName_Str))~="number" then
        return
    end
    self:Set(DataName_Str, self:Get(DataName_Str) + num)
    return self:Get(DataName_Str)
end

------------------------------------------------------------------------------------------------------------------------------
--- 下发简易参数表，简易参数触发器
function fwd_in_pdt_func:Replica_Set_Simple_Data(DataName_Str,theData)
    if type(DataName_Str) == "string" and theData ~= nil then
        self.simple_data_table[DataName_Str] = theData
    end
    -- self.simple_data_table_json_str = json.encode(self.simple_data_table)

    ---- 处理批量发送造成的延迟或者阻塞，第一次发送不进行任何延迟(通常为init的时候)
    if not self.simple_data_table_json_str_trans_flag then  
        self.simple_data_table_json_str = json.encode(self.simple_data_table)
        self.simple_data_table_json_str_trans_flag = true
    else    

        if self.simple_data_table_json_str_trans_task then
            self.simple_data_table_json_str_trans_task:Cancel()
            self.simple_data_table_json_str_trans_task = nil
        end
        self.simple_data_table_json_str_trans_task = self.inst:DoTaskInTime(0,function()
            self.simple_data_table_json_str = json.encode(self.simple_data_table)
            self.simple_data_table_json_str_trans_task = nil
        end)
    end
    ----------------------------------------------------------------
end
function fwd_in_pdt_func:Replica_Simple_PushEvent(event_name,data)
    self:Replica_Set_Simple_Data("Simple_PushEvent",{
        event_name = event_name,
        data = data
    })
    self.inst:DoTaskInTime(0.5,function()     --- 延迟一下清除数据
        self:Replica_Set_Simple_Data("Simple_PushEvent", {
            event_name = nil,
            data = nil,
        })
    end)
end
------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------
-- ----- 另一个数据罐,不是很好用，可能会有加载问题，遇到的时候 time 0 就行了。
function fwd_in_pdt_func:OnSave()
    local data =
    {
        DataTable = self.DataTable
    }
    return next(data) ~= nil and data or nil
end

function fwd_in_pdt_func:OnLoad(data)
    if data.DataTable then
        self.DataTable = data.DataTable
    end
    self:Init_For_OnLoad()
end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
------ OnPostInit 的时候执行（这个在 DoTaskInTime 0 之前） ，这个时候地图和所有inst已经加载完了（除了玩家和与玩家绑定的inst）
------ fn 没任何参数
------ 所有的 fn 都往 TheWorld 的 OnPostInit 里挂载。
------ 只有TheWorld 会执行 Com 里面的 OnPostInit ，其他实体的不会执行。
function fwd_in_pdt_func:OnPostInit()
    self.tempData.___OnPostInit_Fns = self.tempData.___OnPostInit_Fns or {}
    if #self.tempData.___OnPostInit_Fns > 0 then
        for k, fn in pairs(self.tempData.___OnPostInit_Fns) do
            fn()
        end
    end
    self.tempData.___OnPostInit_Fns = nil   --- 避免今后Klei哪天抽风了所有inst 都有这个。
    self.tempData.___OnPostInit_flag = true
end

--------------------
-- 当 TheWorld 执行 OnPostInit 的时候，会顺带执行其他inst里的fwd_in_pdt_func.OnPostInit
-- 加了 fn 的才会执行，节省资源
function fwd_in_pdt_func:Add_TheWorld_OnPostInit_Fn(fn)
    ---- TheWorld 已经执行过OnPostInit 了，不再允许添加新的函数。
    if self.inst ~= TheWorld and TheWorld.components.fwd_in_pdt_func.tempData.___OnPostInit_flag == true then
        print("FWD_IN_PDT Add_TheWorld_OnPostInit_Fn Error :",self.inst)
        return
    end
    -----------------------------------------------------------------------
    self.tempData.___OnPostInit_Fns = self.tempData.___OnPostInit_Fns or {}
    if fn and type(fn) == "function" then
        table.insert(self.tempData.___OnPostInit_Fns,fn)
    end
    -----------------------------------------------------------------------
    ---------- 往TheWorld 添加执行函数,只有theworld 会执行 OnPostInit
    if self.inst ~= TheWorld then
        TheWorld.components.fwd_in_pdt_func.tempData.___OnLoad_Fn_Insts = TheWorld.components.fwd_in_pdt_func.tempData.___OnLoad_Fn_Insts or {}
        if TheWorld.components.fwd_in_pdt_func.tempData.___OnLoad_Fn_Insts[self.inst] ~= true then
            TheWorld.components.fwd_in_pdt_func.tempData.___OnLoad_Fn_Insts[self.inst] = true
            TheWorld.components.fwd_in_pdt_func:Add_TheWorld_OnPostInit_Fn(function()
                self.inst.components.fwd_in_pdt_func:OnPostInit()
            end)
        end
    end
    -----------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--- 加载函数，给不同的目标加载不同的函数
--- 参数可以是 table  ，如   {"player","points",....}
--- 参数可以是 string ， 如  fwd_in_pdt_func:Init("player","points")
----------------------------------------------------------------------------------
function fwd_in_pdt_func:Init(cmd_table,...)
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
            print("fwd_in_pdt_func:Init error",self.inst)
            return
        end
        ---- 模块index 字段在这里
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


        -- ----------------------------------------------------------------------------------

        ----------------------------------------------------------------------------------
        -- 执行相关函数模块加载
        for k, name in pairs(_table) do
            local module_name = tostring(name)
            if type(module_fns[module_name]) ~= "function" then
                print("error : module_name with no function",module_name)
            end

            if module_fns[module_name] and self.tempData.__func_init_loaded_module_names[module_name] ~= true then
                self.tempData.__func_init_loaded_module_names[module_name] = true
                module_fns[module_name](self)
            end
        end
        ----------------------------------------------------------------------------------
        local replica_init_table = {}   --- 需要replica 加载完后初始化的模块。
        for module_name, flag in pairs(self.tempData.__func_init_loaded_module_names) do
            if flag == true then
                table.insert(replica_init_table,module_name)
            end
        end
        
        if #replica_init_table > 0 then
            -- self.loaded_modules_name_json_str = json.encode(replica_init_table)
            self:Replica_Set_Simple_Data("init_cmd_table",replica_init_table)
        end
        ----------------------------------------------------------------------------------
        ---- 给onload 快速初始化和执行函数
        self:Set("__func_init_loaded_module_names",self.tempData.__func_init_loaded_module_names)
        ----------------------------------------------------------------------------------
        ---- 给其他模组方便hook进来准备的event
        self.inst:PushEvent("fwd_in_pdt.event.main_func_inited")
        ----------------------------------------------------------------------------------
        -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and self.inst:HasTag("player") then
        --     print("info main com init",self.inst,unpack(_table))
        -- end
        ----------------------------------------------------------------------------------
    end
end

function fwd_in_pdt_func:Init_For_OnLoad()    --- 新创建的物品不会执行该函数，储存有数据的物品才会执行该函数。
    local loaded_module = self:Get("__func_init_loaded_module_names") or {}
    local temp = {}
    for module_name, flag in pairs(loaded_module) do
        if module_name and flag then
            table.insert(temp,module_name)
        end
    end
    self:Init(temp)
    if self.tempData._____onload_fns then
        for k, fn in pairs(self.tempData._____onload_fns) do
            if type(fn) == "function" then
                fn()
            end
        end
    end
end
-------------- 给模块单独执行onload
function fwd_in_pdt_func:Add_OnLoad_Fn(fn)
    if type(fn) == "function" then
        self.tempData._____onload_fns = self.tempData._____onload_fns or {}
        table.insert(self.tempData._____onload_fns,fn)
    end
end

return fwd_in_pdt_func








------------------------------------------------------------------------------------------------------------------------------
-------- Update测试用的代码残留，作为线索遗留在这。
--------方案 1 ：函数 RegisterStaticComponentUpdate     RegisterStaticComponentLongUpdate 注册 ， 但是不能停止。进入参数只有dt,没有self。
--------方案 2 ： inst:StartUpdatingComponent(com,do_static_update)  和  inst:StopUpdatingComponent(com)

-------- Update 刷新以 30FPS
-------- LongUpdate : 并不是实时刷新。inst重新进入玩家加载范围内才会执行（未能成功测试）。 配合  DoTaskInTime 执行。
-------- DoPeriodicTask  不受到加载范围的限制。
-- function fwd_in_pdt_func:LongUpdate(dt)
--     print("fwd_in_pdt_func LongUpdate test",dt,math.random(100) )
-- end
-- function fwd_in_pdt_func:OnUpdate(dt)
--     print("fwd_in_pdt_func OnUpdate test",dt,math.random(100) )
-- end

-- ---- 方案2
-- fwd_in_pdt_func.OnUpdate = function(dt)
--     print("fwd_in_pdt_func OnUpdate test",dt,math.random(100) )    
-- end
-- RegisterStaticComponentLongUpdate(fwd_in_pdt_func,fwd_in_pdt_func.OnUpdate)
------------------------------------------------------------------------------------------------------------------------------