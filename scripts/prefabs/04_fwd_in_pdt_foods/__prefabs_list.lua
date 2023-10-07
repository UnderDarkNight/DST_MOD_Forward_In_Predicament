----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------
--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------

-- local Prefabs_addr_base = "scripts/prefabs/04_fwd_in_pdt_foods/"
local prefabs_name_list = {
    "01_raw_milk",                           --- 生牛奶
    "02_andrographis_paniculata_botany",     --- 雄黄饮剂
    "03_universal_antidote",                 --- 万能解毒剂
    "04_rise",                               --- 脱壳的稻米
    "05_wheat_flour",                        --- 面粉
    "06_mango",                              --- 芒果（两种）
    "07_orange",                             --- 橙子
    "08_soybeans",                           --- 大豆
    "09_coffebeans",                         --- 咖啡豆
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