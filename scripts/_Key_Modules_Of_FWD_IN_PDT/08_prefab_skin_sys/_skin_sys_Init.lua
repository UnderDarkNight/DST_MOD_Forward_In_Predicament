-- 这个文件是分类入口
-- 本lua 和 modmain.lua 平级
-- 注意文件路径
-----------------------------------------------------------------------------------------------------------------------------------------
---- 利用部分官方API ，创建一套自己的API封装，暂时不做角色用的皮肤切换弹窗。
---- 建筑类利用  player:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
---- 物品则利用  player:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper }) 
---- 其中的 skin 参数为 string  ，来自 HUD 的选择
---- bank build 全换掉，方便做更多不同的奇怪动画
-----------------------------------------------------------------------------------------------------------------------------------------
----- 官方API数据流转路径 ：
-- 1、没placer ：
-- PlayerController:RemoteMakeRecipeFromMenu -> builder:MakeRecipeFromMenu -> builder:MakeRecipe()
--  -> self.inst:PushEvent("makerecipe", { recipe = recipe })  ->  action buffer 
-- ->  playerinst.components.locomotor:PushAction -> builder:Dobuild
-- -> SpawnPrefab - >
--  playerinst:PushEvent("builditem", 

-- 2、有placer （建筑类）: 
-- 预览的时候：
-- PlayerController:StartBuildPlacementMode(recipe, skin)  ->
-- SpawnPrefab(XXX_placer)  -> placer:SetBuilder(...)
-- 执行的时候：
-- PlayerController:StartBuildPlacementMode(recipe, skin) with PREFAB_SKINS 和 PREFAB_SKINS_IDS ->
-- -> PlayerController:DoActionButton()  -> player.replica.builder:MakeRecipeAtPoint -> rpc or client 使用 PREFAB_SKINS 和 PREFAB_SKINS_IDS 的index
-- -> server side 服务端 ->
-- ->  Builder:MakeRecipeAtPoint(recipe,  -> builder:MakeRecipe()
-- -> self.inst:PushEvent("makerecipe", { recipe = recipe })  ->  action buffer 
-- ->  playerinst.components.locomotor:PushAction -> builder:Dobuild
-- -> SpawnPrefab - >   playerinst:PushEvent("buildstructure", { item



-- 3、deployable 物品有点特殊 ，需要单独处理部分相关函数。 可以考虑使用 replica 或者 net_string 传递参数

-----------------------------------------------------------------------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------------------------------------------------------------------

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/00_player_default_unlock_skins.lua")    --- 默认送给玩家的皮肤解锁列表

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/01_player_theworld_hook.lua")    --- hook 进 玩家身上/TheWorld的组件,组件的添加和 hook 部分函数。

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/02_item_prefab_skins_api.lua")    --- hook 进 系统API，以及添加自己的一套API基础数据容器。

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/03_placer_com_upgrade.lua")    --- hook 进 placer 组件，让建筑放置的时候显示皮肤。

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/04_test_add_recipe.lua")    --- 添加到制作栏 -- 测试用

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/05_inventoryitem_com_upgrade.lua")    --- 修改物品图标组件，让皮肤切换的时候可以让图标初始化掉。

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/06_named_com_upgrade.lua")    --- 修改名字组件，让名字可以初始化掉。

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/07_reskin_tool_upgrade.lua")    --- 清洁扫把

modimport("scripts/_Key_Modules_Of_FWD_IN_PDT/08_prefab_skin_sys/08_stackable_com_upgrade.lua")    --- hook 进叠堆组件，进行物品皮肤继承





