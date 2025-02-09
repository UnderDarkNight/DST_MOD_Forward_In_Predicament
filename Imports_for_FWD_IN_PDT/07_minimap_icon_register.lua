---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\map_icons 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {
	-------------------------------------------------------------------------------------------------
	---- 00_fwd_in_pdt_others
	-------------------------------------------------------------------------------------------------
	---- 01_fwd_in_pdt_items
	-------------------------------------------------------------------------------------------------
	---- 02_fwd_in_pdt_materials
	-------------------------------------------------------------------------------------------------
	---- 03_fwd_in_pdt_equipments
	-------------------------------------------------------------------------------------------------
	---- 04_fwd_in_pdt_foods
	-------------------------------------------------------------------------------------------------
	---- 05_fwd_in_pdt_foods_cooked
	-------------------------------------------------------------------------------------------------
	---- 06_fwd_in_pdt_containers
		"fwd_in_pdt_fish_farm",										--- 养鱼池
		"fwd_in_pdt_moom_jewelry_lamp",								--- 天体珠宝灯
		"fwd_in_pdt_moom_jewelry_lamp_moon",						--- 天体珠宝灯皮肤（月亮）
		"fwd_in_pdt_building_special_production_table",				--- 特殊工作台
		"fwd_in_pdt_building_special_production_table_punk",				--- 特殊工作台（朋克皮肤）
		"fwd_in_pdt_building_fermenter",							--- 发酵缸
		"fwd_in_pdt_building_fermenter_honey",						--- 发酵缸（皮肤）
		"fwd_in_pdt_building_special_cookpot",						--- 万能烹饪锅
		"fwd_in_pdt_building_special_cookpot_lantern",				--- 万能烹饪锅【神灯皮肤】
		"fwd_in_pdt_container_tv_box",								--- 电视机
		"fwd_in_pdt_container_tv_box_laser",						--- 电视机（皮肤）
		"fwd_in_pdt_building_drying_rack",							--- 晾晒架
		"fwd_in_pdt_container_mahogany_table",						--- 红木桌
		"fwd_in_pdt_container_mahogany_table_dilapidated",			--- 红木桌（破旧皮肤）
		"fwd_in_pdt_deep_freeze",									--- 冰柜
	-------------------------------------------------------------------------------------------------
	---- 07_fwd_in_pdt_buildings
		"fwd_in_pdt_building_special_shop",							--- 纪念品商店
		"fwd_in_pdt_building_materials_shop",					    --- 材料商店
		"fwd_in_pdt_building_cuisines_shop",					    --- 美食商店
		"fwd_in_pdt_building_hotel",					    		--- 旅店
		"fwd_in_pdt_building_medical_check_up_machine",				--- 健康检查机
		"fwd_in_pdt_building_medical_check_up_machine_punk",		--- 健康检查机【朋克皮肤】
		"fwd_in_pdt_building_paddy_windmill",						--- 稻田风车
		"fwd_in_pdt_building_paddy_windmill_pink",					--- 稻田风车
		"fwd_in_pdt_building_pawnshop",								--- 当铺
		"fwd_in_pdt_building_atm",									--- ATM
		"fwd_in_pdt_building_bulletin_board",						--- 公告板
		"fwd_in_pdt_building_hospital",								--- 医院
		"fwd_in_pdt_building_doll_clamping_machine",				--- 娃娃机
		"fwd_in_pdt_building_lantern",								--- 灯笼
		"fwd_in_pdt_building_lantern_moon",							--- 灯笼（月光皮肤）
		"fwd_in_pdt_building_potting_cotton",						--- 棉花盆栽（盆栽皮肤）
		"fwd_in_pdt_building_lantern_gothic",						--- 灯笼哥特皮肤
	-------------------------------------------------------------------------------------------------
	---- 08_fwd_in_pdt_resources
		"fwd_in_pdt_minimap_glacier"	, 							--- 冰川

	-------------------------------------------------------------------------------------------------
	---- 09_fwd_in_pdt_plants
		"fwd_in_pdt_plant_paddy_rice",								--- 水稻
		"fwd_in_pdt_plant_wheat",									--- 小麦
		"fwd_in_pdt_plant_atractylodes_macrocephala",				--- 苍术
		"fwd_in_pdt_plant_pinellia_ternata",						--- 半夏
		"fwd_in_pdt_plant_aster_tataricus_l_f",						--- 紫苑
		"fwd_in_pdt_plant_coffeebush",								--- 咖啡树
		"fwd_in_pdt_plant_mango_tree",								--- 芒果树
		"fwd_in_pdt_plant_bean",									--- 大豆
		"fwd_in_pdt_plant_orange",									--- 橙子

	-------------------------------------------------------------------------------------------------
	---- 10_fwd_in_pdt_minerals
	-------------------------------------------------------------------------------------------------
	---- 11_fwd_in_pdt_animals
	-------------------------------------------------------------------------------------------------
	---- 12_fwd_in_pdt_boss
	-------------------------------------------------------------------------------------------------
	---- 13_fwd_in_pdt_pets
	-------------------------------------------------------------------------------------------------
	---- 14_fwd_in_pdt_turfs
	-------------------------------------------------------------------------------------------------
	---- 15_fwd_in_pdt_debuffs
	-------------------------------------------------------------------------------------------------
	---- 16_fwd_in_pdt_spells
	-------------------------------------------------------------------------------------------------
	---- 17_fwd_in_pdt_FX
	-------------------------------------------------------------------------------------------------
	---- 18_fwd_in_pdt_projectiles
	-------------------------------------------------------------------------------------------------
	---- 19_fwd_in_pdt_characters
		"fwd_in_pdt_carl",
		"fwd_in_pdt_cyclone",
	-------------------------------------------------------------------------------------------------
	---- 20_fwd_in_pdt_events
	-------------------------------------------------------------------------------------------------
	---- 21_fwd_in_pdt_rooms
		"fwd_in_pdt_minimap_quirky_red_leaf_tree",					--- 红叶木
		"fwd_in_pdt_minimap_mini_portal_door",						--- 迷你传送门


	-------------------------------------------------------------------------------------------------
	---- 22_fwd_in_pdt_npc
	-------------------------------------------------------------------------------------------------
	---- 23_fwd_in_pdt_wellness


}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/map_icons/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/map_icons/".. name ..".xml" ))
	AddMinimapAtlas("images/map_icons/".. name ..".xml")
	RegisterInventoryItemAtlas("images/map_icons/".. name ..".xml",name..".tex")	
end


