------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 月台的疯猪掉落猪大肠和猪肝  普通的疯猪不行
--- 让 普通的猪也能掉落大肠和猪肝  只不过概率低
--- 100%掉落1个  30%额外掉落一个
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- LootTables["beefalo"]
-- require("components/lootdropper")

-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         inst:DoTaskInTime(1,function()
--                 for i, v in ipairs(LootTables["beefalo"]) do
--                     if v and v[1] == "fwd_in_pdt_food_raw_milk" then
--                         return
--                     end
--                 end

--                 table.insert(LootTables["beefalo"], {"fwd_in_pdt_food_raw_milk", 0.7})
--                 table.insert(LootTables["beefalo"], {"fwd_in_pdt_food_raw_milk", 0.7*0.3})
--         end)


--     end
-- )

AddPrefabPostInit(
    "moonpig",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                local loot = inst.components.lootdropper.loot or {}
                    table.insert(loot,"fwd_in_pdt_food_large_intestine")
                    table.insert(loot,"fwd_in_pdt_food_pig_liver")

                if math.random(100) <= 30 then                                              ---30%概率给一个
                        table.insert(loot,"fwd_in_pdt_food_large_intestine")
                        table.insert(loot,"fwd_in_pdt_food_pig_liver")
                end
                inst.components.lootdropper.loot = loot
            end
        end)

    end
)



AddPrefabPostInit(
    "pigman",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                local loot = inst.components.lootdropper.loot or {}
                    if math.random(100) <= 10 then                                              ---10%概率给一个
                        table.insert(loot,"fwd_in_pdt_food_large_intestine")
                        table.insert(loot,"fwd_in_pdt_food_pig_liver")
                    end
                inst.components.lootdropper.loot = loot
            end
        end)

    end
)