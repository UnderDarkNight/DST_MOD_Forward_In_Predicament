------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 牛掉落牛奶
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "beefalo",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                if math.random(100) <= 50 then
                    self:SpawnLootPrefab("fwd_in_pdt_food_raw_milk")
                    if math.random(100) <= 30 then
                        self:SpawnLootPrefab("fwd_in_pdt_food_raw_milk")
                    end
                end                
                return old_DropLoot(self,...)
            end
            
        end

    end)

-- AddPrefabPostInit(
--     "beefalo",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end

--         inst:ListenForEvent("death",function()
--             if inst.components.lootdropper then
--                 local loot = inst.components.lootdropper.loot or {}
--                 if math.random(100) <= 50 then
--                     table.insert(loot,"fwd_in_pdt_food_raw_milk")
--                     if math.random(100) <= 30 then
--                         table.insert(loot,"fwd_in_pdt_food_raw_milk")
--                     end
--                 end
--                 inst.components.lootdropper.loot = loot
--             end
--         end)

--     end
-- )

