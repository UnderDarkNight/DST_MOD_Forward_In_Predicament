--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 旅馆
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_hotel"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
        松果小屋 完全调用帐篷的参数
]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_hotel.zip"),
    
}

    local function sleeping_task_in_player(inst,player) --- 玩家周期性任务
        --------------------------------------------------------------------------
        --- 切换检查参数
            if player:HasTag("player") then
                inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
                inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK
                inst.components.sleepingbag.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK
            end
        --------------------------------------------------------------------------
        --- 血量上限
            if player.components.health then
                player.components.health:DeltaPenalty(-0.05)
            end
        --------------------------------------------------------------------------
    end
    local function onignite(inst)
        inst.components.sleepingbag:DoWakeUp()
    end
    local function onwake(inst, sleeper, nostatechange) --- 玩家醒来
        sleeper:RemoveEventCallback("onignite", onignite, inst)
        if inst.sleepingbag_task[sleeper] then
            inst.sleepingbag_task[sleeper]:Cancel()
            inst.sleepingbag_task[sleeper] = nil
        end
    end
    local function onsleep(inst, sleeper)       --- 玩家入睡
        sleeper:ListenForEvent("onignite", onignite, inst)

        if inst.sleepingbag_task[sleeper] then
            inst.sleepingbag_task[sleeper]:Cancel()
        end
        ---- 重新初始化帐篷的参数
        inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
        inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK
        inst.components.sleepingbag.sanity_tick = TUNING.SLEEP_SANITY_PER_TICK
        inst.sleepingbag_task[sleeper] = inst:DoPeriodicTask(1,function()

            sleeping_task_in_player(inst,sleeper)

        end)
    end
    
    local function temperaturetick(inst, sleeper)  --- 温度控制
        if sleeper.components.temperature ~= nil then
            if inst.is_cooling then
                if sleeper.components.temperature:GetCurrent() > TUNING.SLEEP_TARGET_TEMP_TENT then
                    sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() - TUNING.SLEEP_TEMP_PER_TICK)
                end
            elseif sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
                sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
            end
        end
    end
    local function sleepingbag_install(inst)
        inst:AddComponent("sleepingbag")
        inst.components.sleepingbag.onsleep = onsleep
        inst.components.sleepingbag.onwake = onwake
        ------------------------------------------------------------------
        -- 让帐篷全天候可进去
            local function GetPhase()
                if TheWorld.state.phase == "day" then
                    inst:AddTag("siestahut")
                    return "day"
                end
                inst:RemoveTag("siestahut")
                return "night"
            end
            inst.components.sleepingbag.GetSleepPhase = function()
                return TheWorld.state.phase
            end
            inst:DoTaskInTime(0,function()
                inst.components.sleepingbag:SetSleepPhase(GetPhase())
            end)
            inst:WatchWorldState("phase",function()
                inst.components.sleepingbag:SetSleepPhase(GetPhase())                
            end)
        ------------------------------------------------------------------

        --convert wetness delta to drying rate
        inst.components.sleepingbag.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
        inst.components.sleepingbag:SetTemperatureTickFn(temperaturetick)
        -----------------------------------------------------------
        --- 因意外移除而取消任务
            inst.sleepingbag_task = {}
        -----------------------------------------------------------
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)


    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_hotel.tex")

    inst.AnimState:SetBank("fwd_in_pdt_building_hotel")
    inst.AnimState:SetBuild("fwd_in_pdt_building_hotel")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("tent")

    inst:AddTag("structure")

    inst:AddTag("engineering")

    -- inst:AddTag("engineeringbatterypowered") 

    inst:AddTag("fwd_in_pdt_building_hotel")

    -----------------------------------------------------------
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------
    --- 
        inst:AddComponent("inspectable")
    -----------------------------------------------------------
    --- 官方的睡袋系统
        sleepingbag_install(inst)
    -----------------------------------------------------------
    inst.AddBatteryPower = function() end
    -----------------------------------------------------------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_building_hotel", fn, assets)
    



-- local assets =
-- {
--     Asset("ANIM", "anim/fwd_in_pdt_building_hotel.zip"),
-- }

-- local function fn()
--     local inst = CreateEntity()

--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddNetwork()
--     inst.entity:AddLight()
--     inst.entity:AddSoundEmitter()

--     inst.entity:AddMiniMapEntity()
--     inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_hotel.tex")

--     inst.Light:SetIntensity(0.5)		-- 强度
--     inst.Light:SetRadius(3)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
--     inst.Light:SetFalloff(1)		-- 下降梯度
--     inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)
--     inst.Light:Enable(false)

--     MakeObstaclePhysics(inst, 1.5)


--     inst.AnimState:SetBank("fwd_in_pdt_building_hotel")
--     inst.AnimState:SetBuild("fwd_in_pdt_building_hotel")
--     inst.AnimState:PlayAnimation("idle",true)

--     inst:AddTag("structure")
--     inst:AddTag("fwd_in_pdt_building_hotel")
--     inst:AddTag("antlion_sinkhole_blocker")
--     inst:AddTag("quake_blocker")  --- 屏蔽地震落石

    
--     inst.entity:SetPristine()
--     -------------------------------------------------------------------------------------
--     -- ---- 添加交互

--     --         inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
--     --             replica_com:SetTestFn(function(inst,doer,right_click)
--     --                 return true                    
--     --             end)
--     --             replica_com:SetSGAction("give")
--     --             replica_com:SetText("fwd_in_pdt_building_hotel",GetStringsTable()["action_str"])
--     --             replica_com:SetPreActionFn(function(inst,doer)
                    
--     --             end)
--     --         end)
--     --         if TheWorld.ismastersim then
--     --             inst:AddComponent("fwd_in_pdt_com_workable")
--     --             inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
--     --                 inst:PushEvent("DOOR_OPEN")
--     --                 inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
--     --                 inst:DoTaskInTime(3,function()
--     --                     inst:PushEvent("DOOR_CLOSE")
--     --                     inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")                
--     --                 end)
--     --                 -- doer.components.fwd_in_pdt_func:TheCamera_SetTarget(inst)
        
--     --                 return true
--     --             end)
--     --             inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
--     --         end
        
--     -------------------------------------------------------------------------------------


--     if not TheWorld.ismastersim then
--         return inst
--     end
   

--     inst:AddComponent("inspectable")


--     -------------------------------------------------------------------------------------
--     ---- 积雪监听执行
--         local function snow_over_init(inst)
--             if TheWorld.state.issnowcovered then
--                 inst.AnimState:Show("SNOW")
--             else
--                 inst.AnimState:Hide("SNOW")
--             end
--         end
--         snow_over_init(inst)
--         inst:WatchWorldState("issnowcovered", snow_over_init)
--     -------------------------------------------------------------------------------------
--     ----- 灯的开关控制
--         inst:ListenForEvent("LIGHT_ON_ROOM",function(_,num)
--             if num == 1 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_ONE")
--             elseif num == 2 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_TWO")
--             elseif num == 3 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_THREE")
--             elseif num == 4 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_FOUR")
--             elseif num == 5 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_FIVE")
--             elseif num == 6 then
--                 inst.AnimState:Show("LIGHT_ON_ROOM_SIX")
--             end                
--         end)
--         inst:ListenForEvent("LIGHT_OFF_ROOM",function(_,num)
--             if num == 1 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_ONE")
--             elseif num == 2 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_TWO")
--             elseif num == 3 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_THREE")
--             elseif num == 4 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_FOUR")
--             elseif num == 5 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_FIVE")
--             elseif num == 6 then
--                 inst.AnimState:Hide("LIGHT_ON_ROOM_SIX")
--             end                
--         end)
--         inst:DoTaskInTime(0,function()
--             for i = 1, 6, 1 do
--                 inst:PushEvent("LIGHT_OFF_ROOM",i)
--             end
--         end)
--     -------------------------------------------------------------------------------------
--     ----- 门的控制
--         inst:ListenForEvent("DOOR_OPEN",function()
--             inst.AnimState:Hide("DOOR_CLOSE")
--             inst.AnimState:Show("DOOR_OPEN")
--         end)
--         inst:ListenForEvent("DOOR_CLOSE",function()
--             inst.AnimState:Show("DOOR_CLOSE")
--             inst.AnimState:Hide("DOOR_OPEN")
--         end)
--         inst:PushEvent("DOOR_CLOSE")    --- 默认关闭
--     -------------------------------------------------------------------------------------

--     -------------------------------------------------------------------------------------

--     return inst
-- end


-- return Prefab("fwd_in_pdt_building_hotel", fn, assets)