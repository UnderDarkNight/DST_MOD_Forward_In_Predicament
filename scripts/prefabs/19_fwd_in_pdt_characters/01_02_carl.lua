
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- 初始物品
local start_inv = {
}

-- 当人物复活的时候
local function onbecamehuman(inst)
	-- 设置人物的移速（1表示1倍于wilson）
	-- inst.components.locomotor:SetExternalSpeedMultiplier(inst, "fwd_in_pdt_carl_speed_mod", 1.25)
	--（也可以用以前的那种
	--inst.components.locomotor.walkspeed = 4
	--inst.components.locomotor.runspeed = 6）

	inst:PushEvent("fwd_in_pdt_event.character.carl.run_speed")
end
--当人物死亡的时候
local function onbecameghost(inst)
	-- 变成鬼魂的时候移除速度修正
--    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "fwd_in_pdt_carl_speed_mod")

	inst:PushEvent("fwd_in_pdt_event.character.carl.run_speed")
end

-- 重载游戏或者生成一个玩家的时候
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


--这个函数将在服务器和客户端都会执行
--一般用于添加小地图标签等动画文件或者需要主客机都执行的组件（少数）
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "fwd_in_pdt_carl.tex" )

	----------------------------------------------------------------------
	---- 功能模块嵌入初始化
		local main_modules_init_fn = require("prefabs/19_fwd_in_pdt_characters/01_carl_modules/00_main")
		if type(main_modules_init_fn) == "function" then
			main_modules_init_fn(inst)
		end
	----------------------------------------------------------------------



end

-- 这里的的函数只在主机执行  一般组件之类的都写在这里
local master_postinit = function(inst)
	-- 人物音效
	inst.soundsname = "wilson"

	
	-- 三维	
	inst.components.health:SetMaxHealth(TUNING[string.upper("fwd_in_pdt_carl").."_HEALTH"])
	inst.components.hunger:SetMax(TUNING[string.upper("fwd_in_pdt_carl").."_HUNGER"])
	inst.components.sanity:SetMax(TUNING[string.upper("fwd_in_pdt_carl").."_SANITY"])
	
	-- 伤害系数
    inst.components.combat.damagemultiplier = 1
	
	-- 饥饿速度
	inst.components.hunger.hungerrate = 2 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("fwd_in_pdt_carl", prefabs, assets, common_postinit, master_postinit, start_inv)
