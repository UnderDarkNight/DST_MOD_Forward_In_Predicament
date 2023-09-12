---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------
	-- 01_fwd_in_pdt_items
		"fwd_in_pdt_item_ice_core"	, 							--- 冰核心
		"fwd_in_pdt_item_flame_core"	, 						--- 火核心
		"fwd_in_pdt_item_jade_coin_green"	, 					--- 玉龙币·翠
		"fwd_in_pdt_item_jade_coin_black"	, 					--- 玉龙币·墨
		"fwd_in_pdt_item_transport_stone"	, 					--- 传送石
	---------------------------------------------------------------------------------------
	-- 02_fwd_in_pdt_materials
		"fwd_in_pdt_material_tree_resin",						--- 树脂
		"fwd_in_pdt_material_snake_skin",						--- 蛇皮
	---------------------------------------------------------------------------------------
	-- 02_fwd_in_pdt_materials
		"fwd_in_pdt_equipment_blazing_nightmaresword",			--- 炽热影刀
		"fwd_in_pdt_equipment_frozen_nightmaresword",			--- 极寒影刀
		"fwd_in_pdt_equipment_blazing_hambat",					--- 炽热火腿
		"fwd_in_pdt_equipment_frozen_hambat",					--- 极寒火腿
		"fwd_in_pdt_equipment_blazing_spear",					--- 炽热长矛
		"fwd_in_pdt_equipment_frozen_spear",					--- 极寒火腿

		"fwd_in_pdt_equipment_repair_staff",					--- 修复法杖
		





	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


