--------------------------------------------------------------------------------------------------------------------
-- -- 秋天最后一天必定下雨 降雨量是10倍（我没找到官方给的SetModifier倍增器  貌似无法实现 降水的倍增）
-- --------------------------------------------------------------------------------------------------------------------AddPrefabPostInit(local function OnSeasonChange(inst, data)
--     AddPrefabPostInit("world",function(inst)
--         -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--         if TheWorld.ismastersim then
--             return
--         end
--         -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--             if TheWorld.state.season == "autumn" and TheWorld.state.remainingdaysinseason == 1 then -- 秋天的最后一天开始
            
--             if not TheWorld.state.israining then

--                 -- TheWorld:PushEvent("ms_setprecipitationrate", 10 * TheWorld.state.precipitationrate)
--                 TheWorld:PushEvent("ms_forceprecipitation", true)
--             else

--                 TheWorld:PushEvent("ms_setprecipitationrate", 10 * TheWorld.state.precipitationrate)
--             end
--         end
--     end)

