local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/__fwd_in_pdt_debugging_prefabs/"
local Prefabs_name_list = {

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
if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
    Prefabs_name_list = {}
end

for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
