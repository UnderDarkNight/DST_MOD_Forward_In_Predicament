-- 靠近不出马蜂


AddPrefabPostInit("wasphive",function(inst)
	if TheWorld.ismastersim then
		if inst.components.playerprox then
			local oldonnear=inst.components.playerprox.onnear
			inst.components.playerprox:SetOnPlayerNear(function(inst, target)
				if target and not target.isbeeking then
					if oldonnear then
						oldonnear(inst, target)
					end
				end
			end)
		end
	end
end)

-- function AddfwdTag(owner,tag)
-- 	owner.fwd_tag = owner.fwd_tag or {}
	
-- 	if owner:HasTag(tag) then
-- 		owner.fwd_tag[tag] = (owner.fwd_tag[tag] or 1) + 1
-- 	else
-- 		owner.fwd_tag[tag] = 1
-- 		owner:AddTag(tag)
-- 	end
-- end
-- --移除临时标签
-- function RemovefwdTag(owner,tag)
-- 	if owner.fwd_tag and owner.fwd_tag[tag] then
-- 		owner.fwd_tag[tag] = owner.fwd_tag[tag] > 1 and owner.fwd_tag[tag]-1 or nil
-- 		if owner.fwd_tag[tag] == nil then
-- 			owner:RemoveTag(tag)
-- 		end
-- 	else
-- 		owner:RemoveTag(tag)
-- 	end
-- end
-- GLOBAL.AddTag=AddfwdTag--添加临时标签,参数(目标对象,标签)
-- GLOBAL.RemoveMedalTag=RemovefwdTag--移除临时标签,参数(目标对象,标签)