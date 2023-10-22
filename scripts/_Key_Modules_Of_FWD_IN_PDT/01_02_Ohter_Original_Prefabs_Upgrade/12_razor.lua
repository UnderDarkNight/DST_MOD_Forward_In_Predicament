------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 剃刀有几率导致受伤
--- 事件推送 ： 【_Key_Modules_Of_FWD_IN_PDT\05_Actions\16_shave_action_upgrade.lua】
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function bleed_player(item,player)
    -- player:DoTaskInTime(0.5,function()
        
                        player.__temp_task_num_of_razor_bleed = ( player.__temp_task_num_of_razor_bleed or 0 ) + 9

                        if player.__temp_task_of_razor_bleed == nil then
                                    player.__temp_task_of_razor_bleed = player:DoPeriodicTask(1,function(player)
                                        player.__temp_task_num_of_razor_bleed =  player.__temp_task_num_of_razor_bleed - 1
                                        if player.components.health and not player:HasTag("playerghost") then
                                            player.components.health:DoDelta(-2,nil,item.prefab)
                                        end
                                        if  player.__temp_task_num_of_razor_bleed <= 0 then
                                            player.__temp_task_of_razor_bleed:Cancel()
                                            player.__temp_task_of_razor_bleed = nil
                                            player.__temp_task_num_of_razor_bleed = nil
                                        end
                                    end)
                        end
                        if player.components.combat then
                            player.components.combat:GetAttacked(item,2)
                        end

    -- end)

end

AddPrefabPostInit(
    "razor",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("fwd_in_pdt_event.action.shave",function(_,_table)
            -- print("fwd_in_pdt_event.action.shave",_table.target,_table.doer,_table.item)
            if _table and _table.doer and _table.item and math.random(1000) <= 700 then
                bleed_player(_table.item,_table.doer)
            end
        end)

    end
)

