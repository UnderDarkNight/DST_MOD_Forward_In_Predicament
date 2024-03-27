--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 材料商店
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_hotel"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_hotel.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_hotel.tex")

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(3)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(1)		-- 下降梯度
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, 1.5)


    inst.AnimState:SetBank("fwd_in_pdt_building_hotel")
    inst.AnimState:SetBuild("fwd_in_pdt_building_hotel")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_hotel")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("quake_blocker")  --- 屏蔽地震落石

    
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    ---- 添加交互

            inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
                replica_com:SetTestFn(function(inst,doer,right_click)
                    return true                    
                end)
                replica_com:SetSGAction("give")
                replica_com:SetText("fwd_in_pdt_building_hotel",GetStringsTable()["action_str"])
                replica_com:SetPreActionFn(function(inst,doer)
                    
                end)
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("fwd_in_pdt_com_workable")
                inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                    inst:PushEvent("DOOR_OPEN")
                    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
                    inst:DoTaskInTime(3,function()
                        inst:PushEvent("DOOR_CLOSE")
                        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")                
                    end)
                    -- doer.components.fwd_in_pdt_func:TheCamera_SetTarget(inst)
        
                    return true
                end)
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            end
        
    -------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")


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
        inst:ListenForEvent("LIGHT_ON_ROOM",function(_,num)
            if num == 1 then
                inst.AnimState:Show("LIGHT_ON_ROOM_ONE")
            elseif num == 2 then
                inst.AnimState:Show("LIGHT_ON_ROOM_TWO")
            elseif num == 3 then
                inst.AnimState:Show("LIGHT_ON_ROOM_THREE")
            elseif num == 4 then
                inst.AnimState:Show("LIGHT_ON_ROOM_FOUR")
            elseif num == 5 then
                inst.AnimState:Show("LIGHT_ON_ROOM_FIVE")
            elseif num == 6 then
                inst.AnimState:Show("LIGHT_ON_ROOM_SIX")
            end                
        end)
        inst:ListenForEvent("LIGHT_OFF_ROOM",function(_,num)
            if num == 1 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_ONE")
            elseif num == 2 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_TWO")
            elseif num == 3 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_THREE")
            elseif num == 4 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_FOUR")
            elseif num == 5 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_FIVE")
            elseif num == 6 then
                inst.AnimState:Hide("LIGHT_ON_ROOM_SIX")
            end                
        end)
        inst:DoTaskInTime(0,function()
            for i = 1, 6, 1 do
                inst:PushEvent("LIGHT_OFF_ROOM",i)
            end
        end)
    -------------------------------------------------------------------------------------
    ----- 门的控制
        inst:ListenForEvent("DOOR_OPEN",function()
            inst.AnimState:Hide("DOOR_CLOSE")
            inst.AnimState:Show("DOOR_OPEN")
        end)
        inst:ListenForEvent("DOOR_CLOSE",function()
            inst.AnimState:Show("DOOR_CLOSE")
            inst.AnimState:Hide("DOOR_OPEN")
        end)
        inst:PushEvent("DOOR_CLOSE")    --- 默认关闭
    -------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------

    return inst
end


return Prefab("fwd_in_pdt_building_hotel", fn, assets)