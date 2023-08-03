-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 特定玩家刷新到特定地方用的，不论任何游戏模式。
---- playerspawner.lua 组件里操作部分东西。
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        if TheWorld:HasTag("cave") then
            return
        end

        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        inst.components.playerspawner.SpawnAtLocation_fwd_in_pdt_old = inst.components.playerspawner.SpawnAtLocation
        inst.components.playerspawner.SpawnAtLocation = function(self,inst, player, x, y, z, isloading)

            -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            --     if player and player.prefab == "woodie" and player.components.fwd_in_pdt_data:Get("character_create_trans_pt") ~= true then
            --         player.components.fwd_in_pdt_data:Set("character_create_trans_pt",true)
            --         local pigking = TheSim:FindFirstEntityWithTag("king")
            --         if pigking and pigking.prefab == "pigking" then
            --             local temp_pt = Vector3(pigking.Transform:GetWorldPosition())
            --             local range = 5
            --             local offset = FindWalkableOffset(temp_pt,0,range,false,false) or Vector3(0,0,0)
            --             local pt = Vector3(temp_pt.x + offset.x,0,temp_pt.z+offset.z)

            --             x = pt.x
            --             y = 0
            --             z = pt.z
            --             -- player:DoTaskInTime(10,function()   ---- 不需要手动删除buff 。
            --             --     player:RemoveDebuff("spawnprotectionbuff")
            --             -- end)
            --         end
            --     end
            -- end

            if player.components.fwd_in_pdt_data:Get("character_create_trans_pt") ~= true then
                player.components.fwd_in_pdt_data:Set("character_create_trans_pt",true)
                local fn = player.components.fwd_in_pdt_func:Get_Or_Set_New_Spawn_Pt_Fn()
                if fn then
                    local pt = fn()
                    if pt and type(pt) == "table" and pt.x then
                        x = pt.x
                        y = pt.y
                        z = pt.z

                        player:DoTaskInTime(0,function()    --- 关掉传送门特效
                            local door = TheSim:FindFirstEntityWithTag("multiplayer_portal")
                            if door and door.sg then
                                door.sg:GoToState("idle")
                            end
                        end)

                    end
                end
            end



            self:SpawnAtLocation_fwd_in_pdt_old(inst, player, x, y, z, isloading)

        end


        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- inst:ListenForEvent("ms_newplayercharacterspawned",function(inst,_table)
        --     if _table and _table.player then
        --         print("ms_newplayercharacterspawned",_table.player)
        --     end
        -- end)
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    end
)


