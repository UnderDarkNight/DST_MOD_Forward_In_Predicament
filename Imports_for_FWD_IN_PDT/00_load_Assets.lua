
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


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

