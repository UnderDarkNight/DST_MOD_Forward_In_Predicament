------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级 岩石，能挖出  雄黄矿石
--- rocks.lua
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- AddPrefabPostInit(
--     "rock_flintless",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end

--     end
-- )


AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(1,function()

                table.insert(   LootTables["rock_flintless"]       ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_flintless_med"]   ,   {"fwd_in_pdt_material_realgar",0.1}     )
                table.insert(   LootTables["rock_flintless_low"]   ,   {"fwd_in_pdt_material_realgar",0.05}    )
            
        end)

    end
)
