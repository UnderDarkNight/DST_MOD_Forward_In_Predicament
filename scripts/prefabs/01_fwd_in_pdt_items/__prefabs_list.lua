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
    "00_gift_pack",
    "01_ice_core",                       ---- 冰核心
    "02_flame_core",                     ---- 火核心
    "03_jade_coin",                      -- 玉龙币 （绿、黑）
    "04_transport_stone",                -- 传送石，直接传送到岛上的
    "05_insulin_syringe",                -- 胰岛素注射器
    "06_disease_treatment_book",         -- 《伤寒病论》
    "07_book_of_harvest",                -- 《丰收之书》
    "08_medical_certificate",            -- 诊断单
    "09_locked_book",                    -- 被锁住的书
    "10_cursed_pig_skin",                -- 被诅咒的猪皮
    "11_book_of_gardening",              -- 《园艺之书》
    "12_book_of_newmoon",                -- 《新月之书》
    "13_formulated_crystal",             -- 工作台配方水晶
    "14_glass_pig_skin",                 -- 玻璃猪皮
    "15_glass_horn",                     -- 玻璃号角
    "16_synopsis",                       -- MOD说明书
    "17_advertising_leaflet",            -- 广告单
    "18_chaotic_cookpot_puzzles",        -- 混沌万能锅碎片
    "19_adrenaline_injection",           -- 肾上腺注射剂
    "20_bloody_flask",                   -- 卡尔收藏的血瓶
    "21_treatment_from_doctor",          -- 来自医生的治疗
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