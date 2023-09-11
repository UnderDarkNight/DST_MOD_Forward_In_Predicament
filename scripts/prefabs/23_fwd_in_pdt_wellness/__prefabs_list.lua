----------------------------------------------------
--- 体质值所有的子项目 inst 内容
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

local prefabs_name_list = {
    "01_base_wellness",     -- 体质值
    "02_vitamin_c",         -- VC值
    "03_glucose",           -- 血糖值
    "03_glucose",           -- 血糖值
    "04_01_poison",            -- 中毒值
    "04_02_poison_blocker",            -- 中毒屏蔽计数器

    "05_snake_poison",            -- 蛇毒
    "06_frog_poison",             -- 青蛙毒
    "07_spider_poison",           -- 蜘蛛毒
    "08_bee_poison",              -- 蜜蜂毒

    "09_cough",                   -- 咳嗽
    "10_fever",                   -- 发烧




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