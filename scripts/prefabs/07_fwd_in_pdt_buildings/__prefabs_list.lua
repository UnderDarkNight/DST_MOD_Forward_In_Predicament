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

    
    "01_banner_light",               -- 幡灯
    "02_special_shop",               -- 特殊商店
    "03_materials_shop",             -- 材料商店
    "04_cuisines_shop",              -- 美食商店
    "05_hotel",                      -- 旅馆
    "06_medical_check_up_machine",   -- 健康检查机
    "07_paddy_windmill",             -- 稻田风车
    "08_pawnshop",                   -- 当铺
    "09_atm",                        -- ATM
    "10_bulletin_board",             -- 公告板
    "11_hospital",                   -- 医院
    "12_doll_clamping_machine",      -- 娃娃机
    "13_fence",                      -- 围栏
    "14_lantern",                    -- 灯笼
    "15_building_panda",             -- 熊猫摆件
    "16_potting_a",                  -- 盆栽
    "17_lightning_rod",              -- 避茄针
    "18_01_inspectaclesbox_puzzle",                         -- 寻宝帽子用的箱子
    "18_02_inspectaclesbox_look_for_the_unique",            -- 寻宝帽子用的箱子
    "18_03_inspectaclesbox_catch_item",                     -- 寻宝帽子用的箱子
    "19_inspectaclesbox_fixed",      -- 寻宝帽子用的箱子(修复后的)
}


---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    local debugging_name_list = {

        "15_temp_building",

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