-----------------------------------------------------------------------------------------------------------------------------------------
---- 默认直接送给玩家的解锁列表
-----------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim or TheWorld:HasTag("cave") then
        return
    end


    inst:DoTaskInTime(1,function()
            local list = {
                ----------------------------------------------------------------
                ----- \07_fwd_in_pdt_buildings\01_mock_wall_grass.lua
                ["fwd_in_pdt_building_mock_wall_grass"] = {
                    "fwd_in_pdt_building_mock_wall_grass_monkeytail",
                    "fwd_in_pdt_building_mock_wall_grass_reeds",
                },
                                        --- 有skin——link 了，不需要解锁下面这个。
                                        -- ["fwd_in_pdt_building_mock_wall_grass_item"] = {
                                        --     "fwd_in_pdt_building_mock_wall_item_monkeytail",
                                        --     "fwd_in_pdt_building_mock_wall_item_reeds",
                                        -- },
                ----------------------------------------------------------------
                ["fwd_in_pdt_skin_test_building"] = {
                    "fwd_in_pdt_skin_test_building_glass",
                    "fwd_in_pdt_skin_test_building_night"
                },
                ["fwd_in_pdt_skin_test_item"] = {
                    "fwd_in_pdt_skin_test_item_red",
                    "fwd_in_pdt_skin_test_item_yellow"
                }

                ----------------------------------------------------------------

            }

            inst.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(list)

    end)
end)







