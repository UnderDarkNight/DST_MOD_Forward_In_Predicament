---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\map_icons 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {
	"fwd_in_pdt_minimap_glacier"	, 							--- 冰川
	"fwd_in_pdt_minimap_quirky_red_leaf_tree",					--- 红叶木
	"fwd_in_pdt_minimap_mini_portal_door",						--- 迷你传送门
	"fwd_in_pdt_building_special_shop",							--- 纪念品商店
	"fwd_in_pdt_building_materials_shop",					    --- 材料商店
	"fwd_in_pdt_building_cuisines_shop",					    --- 美食商店
	"fwd_in_pdt_building_hotel",					    		--- 旅店

	"fwd_in_pdt_building_medical_check_up_machine",				--- 健康检查机

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/map_icons/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/map_icons/".. name ..".xml" ))
	AddMinimapAtlas("images/map_icons/".. name ..".xml")

end


