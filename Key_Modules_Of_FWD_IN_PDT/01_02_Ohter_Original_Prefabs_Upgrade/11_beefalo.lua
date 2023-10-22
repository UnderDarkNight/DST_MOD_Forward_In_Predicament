------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 牛掉落牛奶
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
    "beefalo",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                local loot = inst.components.lootdropper.loot or {}
                if math.random(100) <= 50 then
                    table.insert(loot,"fwd_in_pdt_food_raw_milk")
                    if math.random(100) <= 30 then
                        table.insert(loot,"fwd_in_pdt_food_raw_milk")
                    end
                end
                inst.components.lootdropper.loot = loot
            end
        end)

    end
)

