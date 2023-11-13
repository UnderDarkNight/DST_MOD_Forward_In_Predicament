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
    -- "01_whip",
    "02_cook_port",
    "03_test_blue_print",
    "04_cave_hole",             ---- 自制洞穴出入口
    "05_test_tent",             ---- 自制多人帐篷
    "06_skin_test_item",        ---- 皮肤测试物品
    "07_skin_test_building",    ---- 皮肤测试建筑
    "08_example_test_tree",     ---- 【模块测试】可生长的树
    "09_example_special_test_tree", ---- 【模块测试】可生长的树
    "10_example_workable_test_item",    ---【模块测试】物品
    "11_special_npc_test",              --- 【功能测试】不同角色对同一实体看到不一样的内容。
    -- "12_container_replica_test_box",    --- 【功能测试】测试replica event
    "13_stack_item_anim_icon_test",     --- 【功能测试】叠堆物品的动态图标
    "14_test_skeleton",                 --- 【物品测试】角色独有骷髅
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