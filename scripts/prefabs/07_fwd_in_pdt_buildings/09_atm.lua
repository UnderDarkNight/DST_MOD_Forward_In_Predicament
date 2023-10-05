--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 材料商店
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_atm"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_atm.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_atm.tex")

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(3)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(1)		-- 下降梯度
    inst.Light:SetColour(180 / 255, 195 / 255, 50 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, .5)


    inst.AnimState:SetBank("fwd_in_pdt_building_atm")
    inst.AnimState:SetBuild("fwd_in_pdt_building_atm")
    inst.AnimState:PlayAnimation("idle",true)
    local scale = 2
    inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_atm")
    
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    ---- net_entity
        inst.__net_entity_player = net_entity(inst.GUID, "fwd_in_pdt_building_atm", "fwd_in_pdt_building_atm")
        inst:ListenForEvent("fwd_in_pdt_building_atm",function()
            local player = inst.__net_entity_player:value()
            if ThePlayer and player and ThePlayer == player and ThePlayer.HUD then
                ThePlayer.HUD:fwd_in_pdt_atm_open()
            end
        end)
    -------------------------------------------------------------------------------------
    ---- 添加交互
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,righ_click)
            -- return not TheWorld.state.isnight
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_building_atm",STRINGS.ACTIONS.OPEN_CRAFTING.USE)
        inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            inst.__net_entity_player:set(doer)
            inst:DoTaskInTime(0.5,function()
                inst.__net_entity_player:set(inst)
            end)
            return true
        end)
        
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
        inst:ListenForEvent("entitywake",function()
            local anims = {"idle_blue","idle_pink","idle_red"}
            inst.AnimState:PlayAnimation(anims[math.random(3)])
        end)
    -------------------------------------------------------------------------------------
    return inst
end


return Prefab("fwd_in_pdt_building_atm", fn, assets)