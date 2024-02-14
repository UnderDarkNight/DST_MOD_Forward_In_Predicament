------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 猫掉落猫屎
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
    "catcoon",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("death",function()
            if inst.components.lootdropper then
                local loot = inst.components.lootdropper.loot or {}
                    table.insert(loot,"fwd_in_pdt_food_cat_feces")
                if math.random(100) <= 30 then
                    table.insert(loot,"fwd_in_pdt_food_cat_feces")
                end
                inst.components.lootdropper.loot = loot
            end
        end)

    end
)

