
-- -- 小穹的
-- local fixlunarthrall = function(self, target)
--     if target and target:IsValid() then
--         if FindEntity(target, 60, nil, {"fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod"}) then
--             return true
--         end
--     end
--     return false
-- end

-- AddComponentPostInit("lunarthrall_plantspawner", function(i)
--     local SpawnGestalt = i.SpawnGestalt
--     i.SpawnGestalt = function(s, target, ...)
--         if fixlunarthrall(s, target) then
--             return false
--         end
--         return SpawnGestalt(s, target, ...)
--     end

--     local SpawnPlant = i.SpawnPlant
--     i.SpawnPlant = function(s, target, ...)
--         if fixlunarthrall(s, target) then
--             return false
--         end
--         return SpawnPlant(s, target, ...)
--     end

-- end)
-- 自己hook
AddComponentPostInit("lunarthrall_plantspawner", function(self)
    local old_FindPlant = self.FindPlant
    self.FindPlant = function(self,...)
        local origin_ret = old_FindPlant(self,...)
        if type(origin_ret) == "table" and origin_ret.Transform then
            local x,y,z = origin_ret.Transform:GetWorldPosition()
            local ents = TheSim:FindEntity(x,y,z,60,{"fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod"})
            if #ents > 0 then
                return nil
            end
        end
        return origin_ret
    end
end)