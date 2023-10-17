-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径


modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/01_theworld_upgrade.lua")    --- 给 TheWorld 上关键组件

-- modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/02_spawner_hook.lua")    --- 各类刷新器（鸟，雷，雨，等）


modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/03_special_cave_entrance_spawner.lua")    --- 特制洞穴出入口
modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/04_red_tree_island.lua")    --- 创建地面上的岛屿
modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/05_cave_island_creater.lua")    --- 创建创建洞里的岛屿




if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    -- modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/03_test_island_creater.lua")    --- 测试用的岛屿刷新器


end
