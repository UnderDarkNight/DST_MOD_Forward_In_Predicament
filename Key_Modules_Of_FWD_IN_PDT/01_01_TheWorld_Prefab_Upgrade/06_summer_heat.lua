-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 世界温度锁定系统

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPrefabPostInit("world",function(inst)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        inst:WatchWorldState("cycles",function()

            if TheWorld.state.season == "summer" and TheWorld.state.remainingdaysinseason == 13 then -- 夏天的第三天开始

                        inst:PushEvent("fwd_in_pdt_event.lock_world_temperature",{
                            temperature = 120,
                            time = 6720, --- 持续到秋天第一天结束
                        })

                        return true
                end 
            end)
        end)



