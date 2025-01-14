-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/00_player_upgrade.lua")   
 --- 基础组件的添加和初始化

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/01_player_new_spawn_pt.lua")   
 --- 出生地点的修改

-- modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/02_recipes_making_with_fx.lua")   
 --- 制作物品的时候播放特效动画inst

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/03_daily_task.lua")   
 --- 日常任务系统/签到

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/04_00_login_task.lua")   
 --- 登录执行任务
 
modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/04_01_vip_login_task.lua")   
 --- VIP专属内容执行函数，并且包含了非vip玩家说话也能领取vip礼包

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/05_player_wellness_events.lua")   
 --- 体质值 相关的监听事件，以及疾病获取。

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/06_player_default_unlock_skins.lua")   
 --- 默认送给玩家的

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/07_doll_clamping_machine_events.lua")   
 --- 娃娃机事件

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/08_hit_other_bleed_event.lua")   
 --- 伤害太高造成的流血事件

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/09_careful_walking.lua")   
 --- 谨慎走路状态(用来辅助骨折)

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/10_fracture_event.lua")   
 --- 骨折

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/11_map_controller.lua")   
 --- 地图打开/关闭控制

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/12_player_combat_attack_miss_sys.lua")   
 --- 玩家miss 系统

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/13_attack_miss.lua")
 --- 失明触发

modimport("Key_Modules_Of_FWD_IN_PDT/01_00_Player_Prefab_Upgrade/14_inspectacle_searcher_init.lua")
 --- 寻宝系统的初始化标记



