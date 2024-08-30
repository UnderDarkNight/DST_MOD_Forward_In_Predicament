------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 火鸡掉落鸡爪   掉落8个  真坑人
--- 100%掉落1个  30%额外掉落一个
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "perd",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                    self:SpawnLootPrefab("fwd_in_pdt_food_chicken_feet")
                    if math.random(100) <= 30 then
                        self:SpawnLootPrefab("fwd_in_pdt_food_chicken_feet")
                    end              
                return old_DropLoot(self,...)
            end
            
        end

    end)

-- AddPrefabPostInit(
--     "perd",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end

--         inst:ListenForEvent("death",function()
--             if inst.components.lootdropper then
--                 inst.components.lootdropper:SpawnLootPrefab("fwd_in_pdt_food_chicken_feet")
--                 if math.random(100) <= 30 then
--                     inst.components.lootdropper:SpawnLootPrefab("fwd_in_pdt_food_chicken_feet")
--                 end
--             end
--         end)

--     end
-- )

