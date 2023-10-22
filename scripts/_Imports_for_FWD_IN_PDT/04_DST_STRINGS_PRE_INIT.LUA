
------------------------------------------------------------------------------------------------------------------------------------------------------
--往 STRINGS.NAMES (index 为prefab大写) 存进 prefab 的显示名字
-- STRINGS.RECIPE_DESC  （index 为prefab大写）-- 制作栏的描述文本
-- TUNING["Forward_In_Predicament.Strings"]["ch"]
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("npc_item_pigman_arena_spell_coin")]    -- 通用缺省检查文本
-- 中文肯定有数据，列表读取中文的，文本按照API读取
------------------------------------------------------------------------------------------------------------------------------------------------------

local ch_str_table = TUNING["Forward_In_Predicament.Strings"]["ch"]
local LANGUAGE = "ch"
if type(TUNING["Forward_In_Predicament.Language"]) == "function" then
    LANGUAGE = TUNING["Forward_In_Predicament.Language"]()
elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" then
    LANGUAGE = TUNING["Forward_In_Predicament.Language"]
end
        

for prefab_name, temp_str_table in pairs(ch_str_table) do
    if prefab_name and temp_str_table and type(temp_str_table) == "table" then
            local ret_table = TUNING["Forward_In_Predicament.Strings"][LANGUAGE] and TUNING["Forward_In_Predicament.Strings"][LANGUAGE][tostring(prefab_name)]
            if ret_table == nil then
                ret_table = TUNING["Forward_In_Predicament.Strings"]["ch"][tostring(prefab_name)]
            end
            if ret_table.name then -- 如果有名字
                STRINGS.NAMES[string.upper(prefab_name)] = ret_table.name
            end
            if ret_table.inspect_str then   -- 检查名字
                STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(prefab_name)] = ret_table.inspect_str
            end
            if ret_table.recipe_desc then   -- 制作栏描述
                STRINGS.RECIPE_DESC[string.upper(prefab_name)] = ret_table.recipe_desc
            end
    end
end




