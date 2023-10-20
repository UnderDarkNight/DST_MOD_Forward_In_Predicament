--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 娃娃机
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_doll_clamping_machine"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_doll_clamping_machine.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_doll_clamping_machine.tex")

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(3)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(0.5)		-- 下降梯度
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, 1)


    inst.AnimState:SetBank("fwd_in_pdt_building_doll_clamping_machine")
    inst.AnimState:SetBuild("fwd_in_pdt_building_doll_clamping_machine")
    inst.AnimState:PlayAnimation("idle",true)
    -- local scale = 2
    -- inst.AnimState:SetScale(scale, scale, scale)
    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_doll_clamping_machine")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("quake_blocker")  --- 屏蔽地震落石

    
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    ---- 添加交互
        -- inst:AddComponent("fwd_in_pdt_com_workable")
        -- inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,righ_click)
        --     -- return not TheWorld.state.isnight
        --     return true
        -- end)
        -- inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        -- inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_building_doll_clamping_machine",GetStringsTable()["action_str"])
        -- inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
        -- inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
        --     if not TheWorld.ismastersim then
        --         return
        --     end
        --     inst:PushEvent("DOOR_OPEN")
        --     inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
            
        --     inst.components.fwd_in_pdt_com_shop:PlayerEnter(doer)

        --     return true
        -- end)
        
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


return Prefab("fwd_in_pdt_building_doll_clamping_machine", fn, assets)