--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 公告板
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_building_bulletin_board"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_bulletin_board.zip"),
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 玩家激活广告牌
        local function player_active(inst,player)
            -- local daily_datas = inst.components.fwd_in_pdt_data:Get("daily_datas") or {}
            -- if not daily_datas[player.userid] then
            --     if not TheWorld:HasTag("cave") and (LANGUAGE ~= "ch" or player:HasTag("fwd_in_pdt_tag.vip")) then
            --         player.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_advertising_leaflet"))
            --     end
            -- end
            -- daily_datas[player.userid] = true
            -- inst.components.fwd_in_pdt_data:Set("daily_datas",daily_datas)



            -----------------------------------------------------------------------------------------
            local  fwd_in_pdt_item_advertising_leaflet__flag = false
            -----------------------------------------------------------------------------------------
            ---- 送玩家卷轴
                -- TheWorld.state.cycles
                local current_task_flag = player.components.fwd_in_pdt_data:Get("task_scroll_cd_days_flag") or 0
                if ( TheWorld.state.cycles - current_task_flag >= 5 ) or current_task_flag == 0 or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    player.components.fwd_in_pdt_data:Set("task_scroll_cd_days_flag",TheWorld.state.cycles)

                    local task_scroll_item = SpawnPrefab("fwd_in_pdt_task_scroll__items_ask")
                    local all_cmd_tables = task_scroll_item:Get_Missons_Cmd_Tables()
                    
                    local cmd_tables_for_random = {}
                    for index, cmd_table in pairs(all_cmd_tables) do
                        table.insert(cmd_tables_for_random,cmd_table)
                    end

                    local ret_cmd_table = cmd_tables_for_random[math.random(#cmd_tables_for_random)]
                    local ret_task_index = ret_cmd_table.index

                    task_scroll_item:PushEvent("Set",ret_task_index)
                    player.components.inventory:GiveItem(task_scroll_item)
                    -----------------------------------------------------------------------
                    ----- 领取超过 2 次任务，就能领到广告单
                        local cross_archive_data__get_task_scroll_times = player.components.fwd_in_pdt_func:Get_Cross_Archived_Data("task_scrolls_num") or 0
                        cross_archive_data__get_task_scroll_times = cross_archive_data__get_task_scroll_times + 1
                        player.components.fwd_in_pdt_func:Set_Cross_Archived_Data("task_scrolls_num",cross_archive_data__get_task_scroll_times)

                        if cross_archive_data__get_task_scroll_times >= 2 then
                            -- player.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_advertising_leaflet"))
                            fwd_in_pdt_item_advertising_leaflet__flag = true
                        end
                    -----------------------------------------------------------------------
                end
            -----------------------------------------------------------------------------------------
            --- VIP 必给广告单。非中文必给广告单。接取任务超过 50 次必须给（每天只给一次）
                            local daily_datas = inst.components.fwd_in_pdt_data:Get("daily_datas") or {}
                            if not daily_datas[player.userid] then
                                if not TheWorld:HasTag("cave") and (LANGUAGE ~= "ch" or player:HasTag("fwd_in_pdt_tag.vip") or fwd_in_pdt_item_advertising_leaflet__flag == true) then
                                    player.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_advertising_leaflet"))
                                end
                            end
                            daily_datas[player.userid] = true
                            inst.components.fwd_in_pdt_data:Set("daily_datas",daily_datas)
            -----------------------------------------------------------------------------------------
        end
    ---- event setup
        local function ad_event_setup(inst)
            -- local daily_datas = inst.components.fwd_in_pdt_data:Get("daily_datas")
            -- if daily_datas == nil then
            --     inst.components.fwd_in_pdt_data:Set("daily_datas",{})
            -- end

            inst:WatchWorldState("cycles", function()
                inst.components.fwd_in_pdt_data:Set("daily_datas",{})                
            end)
        end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_bulletin_board.tex")

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(3)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(1)		-- 下降梯度
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, .5)


    inst.AnimState:SetBank("fwd_in_pdt_building_bulletin_board")
    inst.AnimState:SetBuild("fwd_in_pdt_building_bulletin_board")
    inst.AnimState:PlayAnimation("idle")
    if TheWorld:HasTag("cave") then
        inst.AnimState:PlayAnimation("idle_2")
    end
    local scale = 1.5
    inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_bulletin_board")
    inst:AddTag("antlion_sinkhole_blocker")

    
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    ---- 添加交互
    
            inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
                replica_com:SetTestFn(function(inst,doer,right_click)
                    return true                    
                end)
                replica_com:SetSGAction("fwd_in_pdt_special_pick")
                replica_com:SetText("fwd_in_pdt_building_bulletin_board",STRINGS.ACTIONS.ACTIVATE.INVESTIGATE)
                replica_com:SetPreActionFn(function(inst,doer)
                    
                end)
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("fwd_in_pdt_com_workable")
                inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                    player_active(inst,doer)
                    return true
                end)
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            end
        
    -------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")
    inst:AddComponent("fwd_in_pdt_data")

    -------------------------------------------------------------------------------------
    ---- 添加广告牌交互事件
        ad_event_setup(inst)
    -------------------------------------------------------------------------------------
    ---- 积雪监听执行
        local function snow_over_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end
        end
        snow_over_init(inst)
        inst:WatchWorldState("issnowcovered", snow_over_init)
    -------------------------------------------------------------------------------------
    ----- 灯的开关控制
        inst:ListenForEvent("LIGHT_ON",function()
            inst.AnimState:Show("LIGHT_ON")
            inst.AnimState:Hide("LIGHT_OFF")
            inst.Light:Enable(true)

        end)
        inst:ListenForEvent("LIGHT_OFF",function()
            inst.AnimState:Hide("LIGHT_ON")
            inst.AnimState:Show("LIGHT_OFF")
            inst.Light:Enable(false)
        end)

        local function SwitchTheLight(inst)
            if TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld:HasTag("cave") then
                inst:PushEvent("LIGHT_ON")
            else
                inst:PushEvent("LIGHT_OFF")
            end
        end
        inst:DoTaskInTime(0,SwitchTheLight)
        inst:WatchWorldState("isdusk",function()
            inst:DoTaskInTime(3,SwitchTheLight)
        end)
        inst:WatchWorldState("isday",function()
            inst:DoTaskInTime(math.random(8),SwitchTheLight)
        end)    
    -------------------------------------------------------------------------------------
    return inst
end


return Prefab("fwd_in_pdt_building_bulletin_board", fn, assets)