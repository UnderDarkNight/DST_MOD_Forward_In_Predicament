
if Assets == nil then
    Assets = {}
end

local temp_assets = {


	Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_empty_icon.tex"),
	Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_empty_icon.xml"),
	
	-- Asset("IMAGE", "images/inventoryimages/default.tex"),
	-- Asset("ATLAS", "images/inventoryimages/default.xml"),

	-- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("IMAGE", "images/inventoryimages/npc_item_tree_trade_station_kit.tex"),
	-- Asset("ATLAS", "images/inventoryimages/npc_item_tree_trade_station_kit.xml"),
	-- Asset("IMAGE", "images/inventoryimages/npc_item_sign_for_sale.tex"),
	-- Asset("ATLAS", "images/inventoryimages/npc_item_sign_for_sale.xml"),

	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble_monsters.zip"),
	-- Asset("ANIM", "anim/npc_fx_trade_bubble.zip"),
	-- Asset("ANIM", "anim/npc_fx_sign_for_sale.zip"),


	-- Asset("SHADER", "shaders/mod_test_shader.ksh"),		--- 测试用的


	-- ---------------------------------------------------------------------------
	-- ----- 地图上的标记
	-- Asset( "IMAGE", "images/map_icons/npc_item_treasure_map.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/npc_item_treasure_map.xml" ),

	-- Asset( "IMAGE", "images/inventoryimages/npc_item_cards_station.tex" ),  
    -- Asset( "ATLAS", "images/inventoryimages/npc_item_cards_station.xml" ),

	-- Asset( "IMAGE", "images/map_icons/npc_card_teleportation_mark.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/npc_card_teleportation_mark.xml" ),
	-- ---------------------------------------------------------------------------


	-- -------------- 暴食猪人的素材包
	-- ---- 使用 TheSim:LoadPrefabs({ "quagmire_swampig" })   加载方法，不用这里添加
	-- Asset("ATLAS", "images/quagmire_hud.xml"),
	-- Asset("IMAGE", "images/quagmire_hud.tex"),
}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

-- RegisterInventoryItemAtlas("images/inventoryimages/"..tex_name.. ".xml", tex_name..".tex")  -- 注册贴图文件【必须要做】

-- AddMinimapAtlas("images/map_icons/npc_item_treasure_map.xml")	----- 小地图上的标记得用这个func 在modmain 里加载
-- AddMinimapAtlas("images/inventoryimages/npc_item_cards_station.xml")
-- AddMinimapAtlas("images/map_icons/npc_card_teleportation_mark.xml")