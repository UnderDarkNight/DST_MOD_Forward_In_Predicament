
--------------------------------------------------------------------------------------------------------
--- 配合组件 fwd_in_pdt_sound_sys 屏蔽 某些 声音。
--- 有 player inst 进入index 是为了 切换角色的时候不屏蔽声音。
--- 穿越洞穴的话，也需要服务器重新下发屏蔽列表。
--------------------------------------------------------------------------------------------------------
TUNING["Forward_In_Predicament.sound_block_sys"] = {}
TUNING["Forward_In_Predicament.sound_block_sys"].theSounds = {}
TUNING["Forward_In_Predicament.sound_block_sys"].Check_Is_Blocked = function(player_inst,addr)
    if TUNING["Forward_In_Predicament.sound_block_sys"].theSounds[player_inst] then
        return TUNING["Forward_In_Predicament.sound_block_sys"].theSounds[player_inst][addr] or false
    else
        return false
    end
end
--------------------------------------------------------------------------------------------------------
AddClientModRPCHandler(TUNING["Forward_In_Predicament.RPC_NAMESPACE"],"fwd_in_pdt_sound_sys",function(inst,data)
    local _table = json.decode(data)
    TUNING["Forward_In_Predicament.sound_block_sys"].theSounds[inst] = _table
    for k, v in pairs(_table) do
        print("Client Sound Block :",k,v)
    end
end)

if TheNet:IsDedicated() then    ------- 如果是专属服务器端（洞穴服务端），在这返回。
    return
end

SoundEmitter.PlaySound_fwd_in_pdt_old = SoundEmitter.PlaySound
SoundEmitter.PlaySound = function(emitter, sound_addr, name, volume, ...)
    if not TheNet:IsDedicated() and TUNING["Forward_In_Predicament.sound_block_sys"].Check_Is_Blocked(ThePlayer,sound_addr) then    
        --- 如果是本地(避免修改操作其他客机玩家)
        return --  TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and print("info : sound blocked",sound_addr)
    end
	SoundEmitter.PlaySound_fwd_in_pdt_old(emitter, sound_addr, name, volume, ...)
end
---------------------------------------------------------------------------------------------------------------------------
--------- 旧函数
    -- SoundEmitter.PlaySound = function(emitter, sound_addr, name, volume, ...)
    -- 	-- local inst = emitter:GetEntity()
    --     if not TheNet:IsDedicated() then    --- 如果是本地(避免修改操作其他客机玩家)

    --         -- print(inst,sound_addr)

    --         -- if string.match(sound_addr,"/HUD/") then
    --         --     print(inst,sound_addr)
    --         -- end

    --         if TUNING["Forward_In_Predicament.sound_block_sys"].Check_Is_Blocked(sound_addr) then
    --             return TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and print("info : sound blocked",sound_addr)
    --         end
    --     end

    --     if not TheNet:IsDedicated() and TUNING["Forward_In_Predicament.sound_block_sys"].Check_Is_Blocked(sound_addr) then    --- 如果是本地(避免修改操作其他客机玩家)
    --         return TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and print("info : sound blocked",sound_addr)
    --     end
    -- 	SoundEmitter.PlaySound_fwd_in_pdt_old(emitter, sound_addr, name, volume, ...)
    -- end


---------------------------------------------------------------------------------------------------------------------------
------------- 一般需要屏蔽的HUD声音。
--[[
-- TheFrontEnd:GetSound():KillSound("gift_idle")


100032 - focalpoint	dontstarve/HUD/research_available   --- 靠近科技有 可解锁项目时候的声音
dontstarve/HUD/click_mouseover	----- 鼠标碰到 制作栏按钮的声音

100020 - 	dontstarve/HUD/click_mouseover_controller        ---- 手柄  在制造栏上移动的声音
100020 - 	dontstarve/HUD/click_move	                     ---- 鼠标/手柄  在物品栏上移动的声音
100020 - 	dontstarve/HUD/craft_open	
100032 - focalpoint	dontstarve/HUD/craft_open
100020 - 	dontstarve/HUD/craft_close	
100032 - focalpoint	dontstarve/HUD/craft_close	


[01:00:46]: 100032 - focalpoint	dontstarve/HUD/collect_resource	------- 物品进入物品栏的声音
[01:00:46]: 100032 - focalpoint	dontstarve/HUD/recipe_ready	    ------- 物品凑够了，可以制作东西时候的声音
100032 - focalpoint	dontstarve/HUD/collect_newitem	            ------- 成功制作出物品时候的奖励声音

[01:04:06]: 100020 - 	dontstarve/HUD/health_down              ------- 掉血时候的声音
[01:04:06]: 100020 - 	dontstarve/HUD/health_up                ------- 回血时候的声音

[01:04:06]: 100020 - 	dontstarve/HUD/hunger_up                ------- 回饥饿时候的声音
[01:04:06]: 100020 - 	dontstarve/HUD/hunger_down              ------- 回饥饿时候的声音

-- 100020 - 	        dontstarve/HUD/sanity_up                --- 回San时候的声音
-- 100020 - 	        dontstarve/HUD/sanity_down                --- 回San时候的声音


]]--