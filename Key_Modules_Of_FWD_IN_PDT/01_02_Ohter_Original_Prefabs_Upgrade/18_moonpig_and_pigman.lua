------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 月台的疯猪掉落猪大肠和猪肝  普通的疯猪不行
--- 让 普通的猪也能掉落大肠和猪肝  只不过概率低
--- 100%掉落1个  30%额外掉落一个
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    "moonpig",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                    self:SpawnLootPrefab("fwd_in_pdt_food_large_intestine")
                    self:SpawnLootPrefab("fwd_in_pdt_food_pig_liver")

                    if math.random(100) <= 30 then
                        self:SpawnLootPrefab("fwd_in_pdt_food_large_intestine")
                        self:SpawnLootPrefab("fwd_in_pdt_food_pig_liver")
                    end

                return old_DropLoot(self,...)
            end
            
        end

    end)







-- AddPrefabPostInit(
--     "moonpig",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end
--         inst:ListenForEvent("death",function()
--             if inst.components.lootdropper then
--                 local loot = inst.components.lootdropper.loot or {}
--                     table.insert(loot,"fwd_in_pdt_food_large_intestine")
--                     table.insert(loot,"fwd_in_pdt_food_pig_liver")

--                 if math.random(100) <= 30 then                                              ---30%概率给一个
--                         table.insert(loot,"fwd_in_pdt_food_large_intestine")
--                         table.insert(loot,"fwd_in_pdt_food_pig_liver")
--                 end
--                 inst.components.lootdropper.loot = loot
--             end
--         end)

--     end
-- )

AddPrefabPostInit(
    "pigman",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                    if math.random(100) <= 10 then
                        self:SpawnLootPrefab("fwd_in_pdt_food_large_intestine")
                        self:SpawnLootPrefab("fwd_in_pdt_food_pig_liver")
                    end

                return old_DropLoot(self,...)    -- 不返回这个就不行的
            end
            
        end

    end)

-- AddPrefabPostInit(
--     "pigman",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end

--         inst:ListenForEvent("death",function()
--             if inst.components.lootdropper then
--                 local loot = inst.components.lootdropper.loot or {}
--                     if math.random(100) <= 10 then                                              ---10%概率给一个
--                         table.insert(loot,"fwd_in_pdt_food_large_intestine")
--                         table.insert(loot,"fwd_in_pdt_food_pig_liver")
--                     end
--                 inst.components.lootdropper.loot = loot
--             end
--         end)

--     end
-- )