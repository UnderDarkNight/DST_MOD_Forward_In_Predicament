----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------

-- local function sum(a, b)
--     return a + b
-- end

-- local info = debug.getinfo(sum)

-- for k,v in pairs(info) do
--         print(k,':', info[k])
-- end

--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------
-- local Prefabs_addr_base = "scripts/prefabs/01_fwd_in_pdt_items/"               --- 文件夹路径
local prefabs_name_list = {

    "01_paddy_rice",                     --- 水稻
    "01_paddy_rice_seed",                --- 水稻种子
    "02_wheat",                          --- 小麦
    "02_wheat_seed",                        --- 麦种
    "03_atractylodes_macrocephala",         --- 苍术
    "03_atractylodes_macrocephala_seed",    --- 苍术种子
    "04_pinellia_ternata",                  --- 半夏
    "04_pinellia_ternata_seed",             --- 半夏种子
    "05_aster_tataricus_l_f",               --- 紫苑
    "05_aster_tataricus_l_f_seed",          --- 紫苑种子
    "06_coffeebush",                       --- 咖啡丛
    "07_mango_tree",                        --- 芒果树
    "07_mango_tree_item",                   --- 芒果树芽穂
    "08_bean",                              --- 大豆
    "08_bean_seed",                         --- 大豆种子
    "09_orange",                            --- 橙子
    "09_orange_seed",                       --- 橙子种子

}


---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    local debugging_name_list = {



    }
    for k, temp in pairs(debugging_name_list) do
        table.insert(prefabs_name_list,temp)
    end
end
---------------------------------------------------------------------------












local ret_addrs = {}
for i, v in ipairs(prefabs_name_list) do
    table.insert(ret_addrs,Prefabs_addr_base..v..".lua")
end
return ret_addrs