-- 这个文件是给 modmain.lua 调用的总入口
-- 本lua 和 modmain.lua 平级
-- 子分类里有各自的入口
-- 注意文件路径


modimport("Key_Modules_Of_FWD_IN_PDT/00_Others/_All_Others_Init.lua") 
------ 无法归类的注册

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/_All_Player_Prefabs_Upgrade_Init.lua") 
-- 玩家组件的修改
modimport("Key_Modules_Of_FWD_IN_PDT/01_01_TheWorld_Prefab_Upgrade/_All_TheWorld_Modules_Upgrade_Init.lua") 
-- TheWorld 组件的修改和 相关 任务添加
modimport("Key_Modules_Of_FWD_IN_PDT/01_02_Ohter_Original_Prefabs_Upgrade/_All_Original_Prefabs_Upgrade_Init.lua") 
-- 饥荒原有物品修改

modimport("Key_Modules_Of_FWD_IN_PDT/02_Original_Components_Upgrade/_All_Original_Components_Upgrade_Init.lua") 
-- Components Hook / com's replica hook

modimport("Key_Modules_Of_FWD_IN_PDT/03_Auxiliary_File_Registration_System/__Auxiliary_File_Registration_System_Init.lua")
-- 辅助文件注册, replica注册/ RPC 等在这类里注册

modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/_All_Original_AnimState_Upgrade_Init.lua")
--- hook AnimState 组件

modimport("Key_Modules_Of_FWD_IN_PDT/05_Actions/_All_Actions_Init.lua")
--- 添加自定义动作 或者 hook 现有动作组件

modimport("Key_Modules_Of_FWD_IN_PDT/06_widgets/_All_Widgets_Init.lua")
--- 添加自定义界面，和相关事件


modimport("Key_Modules_Of_FWD_IN_PDT/07_island_house_creater/_All_Rooms_Creater_Init.lua")
--- 添加岛屿 / 房间 的初始化代码

modimport("Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/_skin_sys_Init.lua")
--- 皮肤切换相关的组件代码

modimport("Key_Modules_Of_FWD_IN_PDT/09_Recipes/_All_Recpies_and_Tech_Init.lua")
--- 制作栏和科技的添加

modimport("Key_Modules_Of_FWD_IN_PDT/10_Cook/_All_Cooking_Related_Init.lua")
--- 烹饪相关的

modimport("Key_Modules_Of_FWD_IN_PDT/12_turfs/_All_Turfs_Related_Init.lua")
--- 地皮相关的注册



-------------- 不同版本开发专用的调试区域
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    modimport("Key_Modules_Of_FWD_IN_PDT/_Debugging_Modules/_All_Debugging_Modules_Init.lua") 
end

