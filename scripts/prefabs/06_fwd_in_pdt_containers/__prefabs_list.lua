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


    "01_fish_farm",                           --- 养鱼池
    "02_moon_jewelry_lamp",                   --- 天体宝珠灯
    "03_special_production_table",            --- 特殊工作台
    "04_fermenter",                           --- 发酵缸
    "05_special_cookpot",                     --- 万能烹饪锅
    "06_tv_box",                              --- 电视机盒子
    "07_drying_rack",                         --- 晾晒架
    "08_wallet",                              --- 钱包
    "09_mahogany_table",                      --- 红木桌
    "10_01_deep_freeze",                      --- 冰柜
    "10_02_deep_freeze_new"                   --- 弹性冰柜
    -- "11_cutgrass_container",                  --- 草车
    -- "12_firewood_container",                --- 柴房
    
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