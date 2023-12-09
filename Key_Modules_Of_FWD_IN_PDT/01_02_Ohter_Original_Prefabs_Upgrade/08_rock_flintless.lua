------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级 岩石，能挖出  雄黄矿石
--- rocks.lua
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local target_rocks = {
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low"
}

for k, prefab_name in pairs(target_rocks) do
                                    AddPrefabPostInit(
                                        prefab_name,
                                        function(inst)
                                            if not TheWorld.ismastersim then
                                                return
                                            end


                                            inst:ListenForEvent("onremove",function()
                                                local x,y,z = inst.Transform:GetWorldPosition()
                                                local current_tile = TheWorld.Map:GetTileAtPoint(x,y,z)
                                                if current_tile == 4 or current_tile == 31 then
                                                    SpawnPrefab("fwd_in_pdt_natural_resources_spawner"):PushEvent("Set",{
                                                        pt = Vector3(inst.Transform:GetWorldPosition()),
                                                        prefab = target_rocks[math.random(#target_rocks)],
                                                        days = math.random(15, 30),
                                                    })
                                                end
                                            end)

                                        end
                                    )
end
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

                table.insert(   LootTables["rock1"]       ,   {"fwd_in_pdt_material_realgar",0.1}     )
                -- table.insert(   LootTables["rock2"]       ,   {"fwd_in_pdt_material_realgar",0.1}     )

                table.insert(   LootTables["rock_flintless"]       ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_flintless_med"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_flintless_low"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )

                table.insert(   LootTables["rock_petrified_tree"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_petrified_tree_tall"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_petrified_tree_short"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )
                table.insert(   LootTables["rock_petrified_tree_old"]   ,   {"fwd_in_pdt_material_realgar",0.2}     )
            
        end)

    end
)
