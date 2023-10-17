--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 公告板
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
            local daily_datas = inst.components.fwd_in_pdt_data:Get("daily_datas") or {}
            if not daily_datas[player.userid] then
                player.components.inventory:GiveItem(SpawnPrefab("fwd_in_pdt_item_advertising_leaflet"))

            end
            daily_datas[player.userid] = true
            inst.components.fwd_in_pdt_data:Set("daily_datas",daily_datas)
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
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,righ_click)
            -- return not TheWorld.state.isnight
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_special_pick")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_building_bulletin_board",STRINGS.ACTIONS.ACTIVATE.INVESTIGATE)
        inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            player_active(inst,doer)
            return true
        end)
        
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