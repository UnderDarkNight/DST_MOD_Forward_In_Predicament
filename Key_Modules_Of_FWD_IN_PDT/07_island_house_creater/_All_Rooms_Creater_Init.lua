-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径


modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/01_theworld_upgrade.lua")    --- 给 TheWorld 上关键组件

-- modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/02_spawner_hook.lua")    --- 各类刷新器（鸟，雷，雨，等）

-- modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/03_Castle_room_create.lua")    --- 执行房间创建函数


if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/03_test_island_creater.lua")    --- 测试用的岛屿刷新器


end
