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
-- 【笔记】
-- fruit- 水果度
-- monster- 怪物度
-- sweetener- 甜度
-- veggie- 菜度
-- meat- 肉度
-- frozen- 冰度
-- fish- 鱼度
-- egg- 蛋度
-- decoration- 装饰度
-- fat- 油脂度
-- dairy- 奶度
-- inedible- 不可食用度
-- seed- 种子
-- magic- 魔法度
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


    "01_raw_milk",                           --- 生牛奶
    "02_andrographis_paniculata_botany",     --- 雄黄饮剂
    "03_universal_antidote",                 --- 万能解毒剂
    "04_rise",                               --- 脱壳的稻米
    "05_wheat_flour",                        --- 面粉
    "06_mango",                              --- 芒果（两种）
    "07_orange",                             --- 橙子
    "08_soybeans",                           --- 大豆
    "09_coffebeans",                         --- 咖啡豆
    "10_dried_fruits_mango",                 --- 芒果干
    "11_dried_fruits_berries",               --- 浆果干
    "12_dried_fruits_watermelons",           --- 西瓜干
    "13_dried_fruits_pineananas",            --- 松萝干
    "14_dried_fruits_dragonfruits",          --- 火龙果干
    "15_dried_fruits_durians",               --- 榴莲干
    "16_dried_fruits_pomegranates",          --- 石榴干
    "17_dried_fruits_cave_bananas",          --- 香蕉干
    "18_dried_fish",                         --- 鱼干
    "19_large_intestine",                    --- 猪大肠
    "20_chicken_feet",                       --- 鸡爪
    "21_pig_liver",                          --- 猪肝
    "22_cat_feces",                          --- 猫屎
    "23_pericarpium_citri_reticulatae",      --- 陈皮
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