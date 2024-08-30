------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 猫掉落猫屎
--- 100%掉落1个  30%额外掉落一个
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit(
    "catcoon",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        if inst.components.lootdropper then

            local old_DropLoot = inst.components.lootdropper.DropLoot
            inst.components.lootdropper.DropLoot = function(self,...)
                    self:SpawnLootPrefab("fwd_in_pdt_food_cat_feces")
                    if math.random(100) <= 30 then
                        self:SpawnLootPrefab("fwd_in_pdt_food_cat_feces")
                    end              
                return old_DropLoot(self,...)
            end
            
        end

    end)
