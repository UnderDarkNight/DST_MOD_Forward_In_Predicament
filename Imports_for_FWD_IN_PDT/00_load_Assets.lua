
if Assets == nil then
    Assets = {}
end

local temp_assets = {


	Asset("IMAGE", "images/inventoryimages/fwd_in_pdt_empty_icon.tex"),
	Asset("ATLAS", "images/inventoryimages/fwd_in_pdt_empty_icon.xml"),
	
	-- Asset("SHADER", "shaders/mod_test_shader.ksh"),		--- 测试用的

	---------------------------------------------------------------------------

	Asset("ANIM", "anim/fwd_in_pdt_hud_wellness.zip"),	--- 体质值进度条
	Asset("ANIM", "anim/fwd_in_pdt_item_medical_certificate.zip"),	--- 诊断单 界面
	Asset("ANIM", "anim/fwd_in_pdt_hud_shop_widget.zip"),	--- 商店界面和按钮

	---------------------------------------------------------------------------
	Asset("ANIM", "anim/fwd_in_pdt_mutant_frog.zip"),	--- 变异青蛙贴图包
	Asset("ANIM", "anim/fwd_in_pdt_animal_frog_hound.zip"),	--- 变异青蛙狗贴图包

	---------------------------------------------------------------------------
	-- Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),	--- 单机声音集
	---------------------------------------------------------------------------
		Asset("ANIM", "anim/player_actions_telescope.zip"),	--- 望远镜动作

	---------------------------------------------------------------------------
		Asset("ANIM", "anim/fwd_in_pdt_active_item_cursor_sight.zip"),	--- 鼠标物品施法指示圈
	---------------------------------------------------------------------------
	--- 寻宝游戏的界面和素材
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_widget_1.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_widget_1.xml"),

		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/test_puzzle.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/test_puzzle.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_1.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_1.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_2.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_2.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_3.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_3.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_4.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_4.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_5.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_5.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_6.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_6.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_7.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_7.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_8.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_8.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_9.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_9.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_10.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_10.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_11.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_11.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_12.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_12.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_13.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_13.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_14.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_14.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_15.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_15.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_16.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_16.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_17.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_17.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_18.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_18.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_19.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_19.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_20.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_20.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_21.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_21.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_22.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_22.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_23.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_23.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_24.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_24.xml"),
		Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_25.tex"),
		Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/game_puzzle_25.xml"),


	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

