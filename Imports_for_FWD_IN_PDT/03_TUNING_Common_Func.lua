--------------------------------------------------------------------------------------------
------ 常用函数放 TUNING 里
--------------------------------------------------------------------------------------------
----- RPC 命名空间
TUNING["Forward_In_Predicament.RPC_NAMESPACE"] = "Forward_In_Predicament_RPC"


--------------------------------------------------------------------------------------------

TUNING["Forward_In_Predicament.fn"] = {}
TUNING["Forward_In_Predicament.fn"].GetStringsTable = function(prefab_name)
    -------- 读取文本表
    -------- 如果没有当前语言的问题，调取中文的那个过去
    -------- 节省重复调用运算处理
    if TUNING["Forward_In_Predicament.fn"].GetStringsTable_last_prefab_name == prefab_name then
        return TUNING["Forward_In_Predicament.fn"].GetStringsTable_last_table or {}
    end


    local LANGUAGE = "ch"
    if type(TUNING["Forward_In_Predicament.Language"]) == "function" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]()
    elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" then
        LANGUAGE = TUNING["Forward_In_Predicament.Language"]
    end
    local ret_table = prefab_name and TUNING["Forward_In_Predicament.Strings"][LANGUAGE] and TUNING["Forward_In_Predicament.Strings"][LANGUAGE][tostring(prefab_name)] or nil
    if ret_table == nil and prefab_name ~= nil then
        ret_table = TUNING["Forward_In_Predicament.Strings"]["ch"][tostring(prefab_name)]
    end

    ret_table = ret_table or {}
    TUNING["Forward_In_Predicament.fn"].GetStringsTable_last_prefab_name = prefab_name
    TUNING["Forward_In_Predicament.fn"].GetStringsTable_last_table = ret_table

    return ret_table
end


--------------------------------------------------------------------------------------------
---- 统一 func 初始化列表
TUNING["Forward_In_Predicament.World_Com_Func"] = {"map_modifier"}



--------------------------------------------------------------------------------------------
--- 自制一个多返回值的pcall ，应对hook 官方 api的可能问题。
--- 返回一个 table ，需要 unpack(list, i, j) 函数
rawset(_G,"fwd_in_pdt_pcall",function(fn,...)
    local temp_ret_table = {pcall(fn,...)}
    local crash_flag = true
    local ret_pack = {}
    for k, v in pairs(temp_ret_table) do
        if k == 1 then
            crash_flag = v
        else
            table.insert(ret_pack,v)
        end
    end
    return crash_flag,ret_pack
end)
--------------------------------------------------------------------------------------------