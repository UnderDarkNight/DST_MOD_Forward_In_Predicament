
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
	-- Asset( "IMAGE", "images/map_icons/fwd_in_pdt_minimap_glacier.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/fwd_in_pdt_minimap_glacier.xml" ),

	-- Asset( "IMAGE", "images/map_icons/fwd_in_pdt_minimap_quirky_red_leaf_tree.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/fwd_in_pdt_minimap_quirky_red_leaf_tree.xml" ),

	-- Asset( "IMAGE", "images/map_icons/fwd_in_pdt_minimap_mini_portal_door.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/fwd_in_pdt_minimap_mini_portal_door.xml" ),

	-- Asset( "IMAGE", "images/inventoryimages/npc_item_cards_station.tex" ),  
    -- Asset( "ATLAS", "images/inventoryimages/npc_item_cards_station.xml" ),

	-- Asset( "IMAGE", "images/map_icons/npc_card_teleportation_mark.tex" ),  
    -- Asset( "ATLAS", "images/map_icons/npc_card_teleportation_mark.xml" ),
	-- ---------------------------------------------------------------------------

	Asset("ANIM", "anim/fwd_in_pdt_hud_wellness.zip"),	--- 体质值进度条
	Asset("ANIM", "anim/fwd_in_pdt_item_medical_certificate.zip"),	--- 诊断单 界面
	Asset("ANIM", "anim/fwd_in_pdt_hud_shop_widget.zip"),	--- 商店界面和按钮

	-- ---------------------------------------------------------------------------
	Asset("ANIM", "anim/fwd_in_pdt_mutant_frog.zip"),	--- 变异青蛙贴图包

	-- ---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end
