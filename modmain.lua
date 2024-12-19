GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 屏蔽 windows 版本 32位 的饥荒。32位的饥荒问题很多，必须屏蔽。
if IsWin32() and APP_ARCHITECTURE == "x32" then
	return
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 语言设置Fn 放这里，方便外部API修改
--  type( TUNING["Forward_In_Predicament.Language"] ) is "function" or "string"
-- 
--  If anyone wants to add additional language support themselves, 
--  please add this function before this mod is loaded (set a higher priority)  : TUNING["Forward_In_Predicament.Language"]
--	and then mount a text table in the format of /Imports_for_FWD_IN_PDT/02_01_Strings_Table_EN.lua
--  The missing language text is automatically read from the "ch" text
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TUNING["Forward_In_Predicament.Language"] = TUNING["Forward_In_Predicament.Language"] or function()
	-- return "en"
	local language = "en"
	pcall(function()
		language = TUNING["Forward_In_Predicament.Config"].Language
		if language == "auto" then
			if LOC.GetLanguage() == LANGUAGE.CHINESE_S or LOC.GetLanguage() == LANGUAGE.CHINESE_S_RAIL or LOC.GetLanguage() == LANGUAGE.CHINESE_T then
				language = "ch"
			elseif  LOC.GetLanguage() == LANGUAGE.JAPANESE then
				language = "jp"
			else
				language = "en"
			end
		end
	end)
	return language
end
---------------------------------------------------------------------
-- 文本库调用func： （参考 00_gift_pack.lua）
-- inst.components.named:SetName(GetStringsTable().name)
-- inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)

		-- local function GetStringsTable(name)
		--     local prefab_name = name or "fwd_in_pdt_gift_pack"
		--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
		--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
		-- end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 自动兼容show me（中文/origin）
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
TUNING.MONITOR_CHESTS.fwd_in_pdt_deep_freeze = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_fish_farm = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_moom_jewelry_lamp = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_building_special_production_table = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_building_fermenter = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_building_special_cookpot = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_container_tv_box = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_building_drying_rack = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_container_wallet = true
TUNING.MONITOR_CHESTS.fwd_in_pdt_container_mahogany_table = true
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 调试模式开关
----- 用于新大型版本管理和上线后文件切割。修BUG不用担心新的未完成内容上线造成崩溃。
	TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE or GetModConfigData("DEBUGGING_MOD") or false	
		-- if modname == "Forward_In_Predicament" then -- 如果MOD文件夹名字是 "Forward_In_Predicament"
		-- 	TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = true	

		-- 	-- TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = false	

		-- 					-- local modnames = ModManager:GetEnabledModNames()
		-- 					-- KnownModIndex:GetModInfo(modname)
		-- 					-- TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE_MODNAME = modname or "dfadfeafgaegcvfglkjolnlngmg"
		-- end
		if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
			AddPlayerPostInit(function(player_inst)	---- 玩家进入后再执行。检查。
				if not TheWorld.ismastersim then
					return
				end
				player_inst:DoTaskInTime(2,function()
					TheNet:SystemMessage("FWD_IN_PDT DEBUGGING MODE ON")				
				end)
			end)
		end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Assets = {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modimport("Imports_for_FWD_IN_PDT/__All_imports_init.lua")	---- 所有 import  文本库（语言库），素材库

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- MOD屏蔽
	-- modimport("modblocker.lua")
	-- if TUNING["Forward_In_Predicament.Mod_Blocker"] then
	-- 	return
	-- end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 获取mod 版本
	local mod_info = KnownModIndex:GetModInfo(modname) or {}
	-- local mod_display_name = mod_info.name or ""
	-- local mod_version = mod_info.version
	TUNING["Forward_In_Predicament.mod_info"] = mod_info
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


modimport("Key_Modules_Of_FWD_IN_PDT/_All_Key_Modules_Init.lua")	---- 载入关键功能模块,在 prefab 加载之前，方便皮肤的API HOOK

PrefabFiles = {  "forward_in_predicament__all_prefabs"  }		---- 通过总入口 加载所有prefab。

-- GenerateSpicedFoods(require("script/prefabs/04_fwd_in_pdt_foods.lua"))
-- local spicedfoods = require("spicedfoods")
-- for k, recipe in pairs(spicedfoods) do
--     if recipe.mod and recipe.mod == "fwd_in_pdt" then
--         recipe.official = false
--         AddCookerRecipe("portablespicer", recipe)
--     end
-- end

if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
	modimport("test_fn/_Load_All_debug_fn.lua")	---- 载入测试用的模块
end
-- dofile(resolvefilepath("test_fn/test.lua"))