GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 屏蔽 windows 版本 32位 的饥荒
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
----- 调试模式开关
----- 用于新大型版本管理和上线后文件切割。修BUG不用担心新的未完成内容上线造成崩溃。
	TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE or GetModConfigData("DEBUGGING_MOD") or false	
		-- if modname == "Forward In Predicament" then -- 如果MOD文件夹名字是 "Forward In Predicament"
		-- 	TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = true	

		-- 	-- TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE = false	

		-- 					-- local modnames = ModManager:GetEnabledModNames()
		-- 					-- KnownModIndex:GetModInfo(modname)
		-- 					-- TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE_MODNAME = modname or "dfadfeafgaegcvfglkjolnlngmg"
		-- end
		AddPlayerPostInit(function(player_inst)	---- 玩家进入后再执行。检查。
			if not TheWorld.ismastersim then
				return
			end
			player_inst:DoTaskInTime(2,function()
				if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
					TheNet:SystemMessage("FWD_IN_PDT DEBUGGING MODE ON")	
				end
			end)
		end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Assets = {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modimport("Imports_for_FWD_IN_PDT/__All_imports_init.lua")	---- 所有 import  文本库（语言库），素材库

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------- 提前加载这些公共函数，给检测 屏蔽 prefab 的时候调用。
-- 已经移动到  【 Imports_for_FWD_IN_PDT\_require_module_for_prefab_block.lua  】
if not TUNING["Forward_In_Predicament.Config"].compatibility_mode then
		require("prefabutil")
		require("maputil")
		require("vecutil")
		require("datagrid")
		require("worldsettingsutil")
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 为保证本MOD 的良好顺畅体验，屏蔽掉一些容易造成崩溃的MOD，或者检测到不利于本MOD运行的情况
			local temp_this_mod_name = modname
			local mod_info = KnownModIndex:GetModInfo(temp_this_mod_name) or {}
			local mod_display_name = mod_info.name or ""

			local need_2_block = false
			local block_reason_str = ""
			local block_check_pass__flag = false
			

			local function Quit_The_Game()
				if TheWorld and TheWorld.ismastersim and TheNet:IsDedicated() then
					TheSim:Quit()   --- 有洞穴的存档,关闭服务器就行。
				else
					----------- 没洞穴的存档，退出程序到主界面。
					-- TheSim:Reset()	--- 重置程序,会重载存档。
					--- 代码复制自 DoRestart
					PerformingRestart = true
					Settings.match_results = {}
					ShowLoading()
					TheFrontEnd:Fade(false, 1,function()
						TheNet:Disconnect(true)
						EnableAllMenuDLC()							
						if TheNet:GetIsHosting() then
							TheSystemService:StopDedicatedServers(not IsDynamicCloudShutdown)
						end							
						StartNextInstance()
						inGamePlay = false
						PerformingRestart = false
					end)

				end
			end
			local function Get_Block_Reason(index)
				return TUNING["Forward_In_Predicament.fn"].GetStringsTable("fwd_in_pdt_with_blocked_mods")[tostring(index)] or "Game Will Quit With No Reason"
			end

			local function block_by_workshop_id()		--- 检查steam 工坊 id
				local loaded_modnames = ModManager:GetEnabledModNames() or {}
				local block_mod_floder_name = {
					-- ["workshop-1699194522"] = true,		-- steam ID  神话书说
					-- ["workshop-1991746508"] = true,		-- steam ID	 神话书说
					["workshop-1505270912"] = true,		-- steam ID	 三合一
				}
				for k, temp in pairs(loaded_modnames) do
					if temp and block_mod_floder_name[temp] then
						print("fwd_in_pdt error : Loading with mods on the block list",temp)
						local str = mod_display_name .. " : ".. tostring(Get_Block_Reason("mods_ban")) .. "  ".. ModInfoname(temp)
						return true,str
					end
				end
				return false,""
			end

			local function block_by_prefab_loaded()		--- 检查某些 prefab 被加载了
				local blocked_prefab_name_list = {
					-- ["fangcunhill"] = true,						-- 神话书说 的方寸山
					-- ["pigsy"] = true,							-- 神话书说的 猪八戒
					["ancient_robots_assembly"] = true,			-- 三合一 模组的东西。
					["rainforesttree_cone"]= true,				-- 三合一 模组的东西。
					["cave_exit_vulcao"]= true,					-- 三合一 模组的东西。

				}
				for prefab_name,flag  in pairs(blocked_prefab_name_list) do
					if PrefabExists(tostring(prefab_name)) then
						print("fwd_in_pdt error : Loading with the mod in the blocked list")							
						local str = mod_display_name .. " : ".. tostring(Get_Block_Reason("prefab_block"))
						if STRINGS.NAMES[string.upper(prefab_name)] then
							str = str .. STRINGS.NAMES[string.upper(prefab_name)]
						else
							str = str .. "NONE"
						end
						return true,str
					end
				end
				return false,""
			end

			---------- 这个方法和 一些MOD冲突，尤其是 《能力勋章》这种hook prefab 注册函数的
							-- local function block_by_prefab_loaded__old()  --- 检查某些 prefab 被加载了
							-- 	-- print("info  start check block_by_prefab_loaded")
							-- 	local blocked_prefab_name_list = {
							-- 		-- ["fangcunhill"] = true,						-- 神话书说 的方寸山
							-- 		-- ["pigsy"] = true,							-- 神话书说的 猪八戒
							-- 		["ancient_robots_assembly"] = true,			-- 三合一 模组的东西。
							-- 		["rainforesttree_cone"]= true,				-- 三合一 模组的东西。
							-- 		["cave_exit_vulcao"]= true,					-- 三合一 模组的东西。

							-- 	}
							-- 	------ 代码参考来自 mods.lua
							-- 	local runmodfn = function(fn,mod,modtype)
							-- 		return (function(...)
							-- 			if fn then
							-- 				local status, r = xpcall( function() return fn(unpack(arg)) end, debug.traceback)
							-- 				if not status then
							-- 					pcall(function()
							-- 						print("error calling "..modtype.." in mod "..ModInfoname(mod.modname)..": \n"..(r or ""))
							-- 						ModManager:RemoveBadMod(mod.modname,r)
							-- 						ModManager:DisplayBadMods()
							-- 					end)
												
							-- 				else
							-- 					return r
							-- 				end
							-- 			end
							-- 		end)
							-- 	end

							-- 	local loaded_modnames = ModManager:GetEnabledModNames() or {}
							-- 	for i, modname in pairs(loaded_modnames) do
							-- 		-- print("++++",modname)
							-- 		local mod = ModManager:GetMod(modname)
							-- 		if mod and mod.PrefabFiles then		--- 得到每个MOD的 PrefabFiles 表
							-- 				for _, prefab_path in ipairs(mod.PrefabFiles) do	-- prefab lua 文件的路径
							-- 					local ret = runmodfn( mod.LoadPrefabFile, mod, "LoadPrefabFile" )("prefabs/"..prefab_path, nil, MODS_ROOT..modname.."/")
							-- 					if ret then
							-- 						for _, prefab in ipairs(ret) do
							-- 								-- print("Mod: "..ModInfoname(modname), "    "..prefab.name)
							-- 								-- mod.Prefabs[prefab.name] = prefab
							-- 							if blocked_prefab_name_list[prefab.name] then
							-- 								local str = mod_display_name .. " : ".. tostring(Get_Block_Reason("prefab_block")) .. ModInfoname(modname)
							-- 								return true,str
							-- 							end
							-- 							-- print("## -- ",prefab.name)
							-- 						end
							-- 					end

							-- 				end
							-- 		end
							-- 	end

							-- 	return false,""
							-- end

			local function block_by_stack_size()		--- 检查叠堆上限
				if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE__MAX_STACK_SIZE_CHECK_PASS then
					return false,""
				end
				-- local function stack_check(name) 
				-- 	local inst = SpawnPrefab(name)
				-- 	if inst and inst.components.stackable and inst.components.stackable.maxsize > 70 then
				-- 		inst:Remove()
				-- 		return true
				-- 	elseif inst then
				-- 		inst:Remove()
				-- 		return false
				-- 	end
				-- 	return false
				-- end
				
				-- local check_list = {"log","twigs","goldnugget","stinger"}	--- 多检查几个
				-- for k, temp_prefab_name in pairs(check_list) do
				-- 	local crash_flag,ret = pcall(stack_check,temp_prefab_name)
				-- 	if crash_flag and ret then
				-- 		print("fwd_in_pdt error : The number of items stacked is too high ")							
				-- 		local str = mod_display_name .. " : ".. tostring(Get_Block_Reason("maxsize_block"))		
				-- 		return true,str
				-- 	end
				-- end
				return false,""
			end

			local function block_by_no_cave()			---- 检查世界不存在洞穴,只能玩家加载后检查
				------------------------------------------------------
				----- 存档没有洞穴，关闭本MOD。测试模式不要紧。
					if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE ~= true then
							local world_shards_table = Shard_GetConnectedShards()
							local the_world_has_cave = false
							for k, v in pairs(world_shards_table) do
								if k then
									the_world_has_cave = true
									break
								end
							end
							if the_world_has_cave ~= true then
								print("fwd_in_pdt error : this world has not cave")
								local str = mod_display_name .. " : ".. tostring(Get_Block_Reason("has_not_cave"))
								-- crash_with_str(str)
								return true,str
							end
					end
				------------------------------------------------------
				return false,""
			end
			-------------------------------------------------------------------------------
			---- 加载的时候先检查一次
				-- if not TUNING["Forward_In_Predicament.Config"].compatibility_mode then
				-- 		if not need_2_block then	--- 检查工坊 id 
				-- 			need_2_block,block_reason_str = block_by_workshop_id()
				-- 		end
				-- 		if not need_2_block then	--- 检查 加载的东西
				-- 			need_2_block,block_reason_str = block_by_prefab_loaded()
				-- 		end
				-- end
			-------------------------------------------------------------------------------
			if not TUNING["Forward_In_Predicament.Config"].compatibility_mode then
					AddPlayerPostInit(function(player_inst)	---- 玩家进入后再执行。检查。
						if not TheWorld.ismastersim  then
							return
						end
						if block_check_pass__flag then
							return
						end

						player_inst:DoTaskInTime(10,function()
							------ 玩家进入世界后 再检查一次
							if not need_2_block then	--- 工坊id
								need_2_block,block_reason_str = block_by_workshop_id()
							end	
							if not need_2_block then	---- 某些prefab 
								need_2_block,block_reason_str = block_by_prefab_loaded()
							end
							if not need_2_block then	---- 最大叠堆数量
								need_2_block,block_reason_str = block_by_stack_size()						
							end
							if not need_2_block then	---- 洞穴存在否
								need_2_block,block_reason_str = block_by_no_cave()						
							end

							if need_2_block then
								local temp_inst = CreateEntity()
								temp_inst:DoPeriodicTask(1,function()
									TheNet:SystemMessage(block_reason_str)							
								end)
								temp_inst:DoTaskInTime(15,function()
									Quit_The_Game()
								end)
							else
								block_check_pass__flag = true
							end
						end)
					end)
			end
			if need_2_block then
				print("FWD_IN_PDT Error : Load with the mods in blocked list")
				print("Error",block_reason_str)
				return
			end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


modimport("Key_Modules_Of_FWD_IN_PDT/_All_Key_Modules_Init.lua")	---- 载入关键功能模块,在 prefab 加载之前，方便皮肤的API HOOK

PrefabFiles = {  "forward_in_predicament__all_prefabs"  }		---- 通过总入口 加载所有prefab。


if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
	modimport("test_fn/_Load_All_debug_fn.lua")	---- 载入测试用的模块
end
-- dofile(resolvefilepath("test_fn/test.lua"))