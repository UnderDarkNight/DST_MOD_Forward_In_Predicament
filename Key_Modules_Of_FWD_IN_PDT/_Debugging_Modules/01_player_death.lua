-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 角色死亡的时候会执行的程序流程，通过修改这几个组件/函数实现灵魂外观切换
--- 【注意】状态不保持，重载存档就会变成没死状态。
---  三维等属性会停摆，不再变化。【没测试月岛变化】
--- ThePlayer:HasTag("playerghost") = false
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- AddPlayerPostInit(function(inst)
-- 	if not TheWorld.ismastersim then
--         return
--     end

-- 	local ex_fns = require "prefabs/player_common_extensions"
--     if inst.components.revivablecorpse == nil then
-- 	    inst:AddComponent("revivablecorpse")
--     end

-- 	inst:RemoveEventCallback("playerdied", ex_fns.OnPlayerDied)
-- 	inst:ListenForEvent("playerdied",function()
-- 		-- inst:Hide()
-- 		inst.sg:GoToState("idle")
-- 	end)

--     ThePlayer.AnimState:PlayAnimation("dissipate") -- 作祟的动画 ，正常情况会触发 Event("ghostdissipated"
-- end)


