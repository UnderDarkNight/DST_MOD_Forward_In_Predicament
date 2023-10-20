--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 迷你传送门，给两个独特的岛进行 传送 进出的。
-- 地面的只能当做 公车站，无法使用。
-- 洞里的就能传送到地下的绚丽之门
-- 外部道具通过 event active 进行传送触发
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_building_banner_light"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_banner_light.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Light:SetIntensity(0.5)		-- 强度
    inst.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
    inst.Light:SetFalloff(1)		-- 下降梯度
    inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, 0.1)


    inst.AnimState:SetBank("fwd_in_pdt_building_banner_light")
    inst.AnimState:SetBuild("fwd_in_pdt_building_banner_light")
    inst.AnimState:PlayAnimation("idle",true)
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num,scale_num,scale_num)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_banner_light")
    
    inst.entity:SetPristine()


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
            inst.AnimState:Hide("LIGHT_OFF")
            inst.AnimState:Show("LIGHT_ON")
            inst.Light:Enable(true)

            if inst.__ground_fx == nil then
                inst.__ground_fx = inst:SpawnChild("fwd_in_pdt_building_banner_light_fx")
                inst.__ground_fx:PushEvent("Set",{pt = Vector3(0,0,0)})
            end
        end)
        inst:ListenForEvent("LIGHT_OFF",function()
            inst.AnimState:Show("LIGHT_OFF")
            inst.AnimState:Hide("LIGHT_ON")
            inst.Light:Enable(false)
            if inst.__ground_fx then
                inst.__ground_fx:Remove()
                inst.__ground_fx = nil
            end
        end)

        local function SwitchTheLight(inst)
            if TheWorld.state.isnight or TheWorld:HasTag("cave") then
                inst:PushEvent("LIGHT_ON")
            else
                inst:PushEvent("LIGHT_OFF")
            end
        end
        inst:DoTaskInTime(0,SwitchTheLight)
        inst:WatchWorldState("isnight",function()
            inst:DoTaskInTime(math.random(3, 8),SwitchTheLight)
        end)
        inst:WatchWorldState("isday",function()
            inst:DoTaskInTime(math.random(3,8),SwitchTheLight)
        end)
    -------------------------------------------------------------------------------------

    return inst
end

local function ground_fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fwd_in_pdt_building_banner_light")
    inst.AnimState:SetBuild("fwd_in_pdt_building_banner_light")
    local scale_num = 1.5
    inst.AnimState:SetScale(scale_num, scale_num, scale_num)
    inst.AnimState:SetMultColour(1, 1, 1, 0.3)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(0)
    inst.AnimState:PlayAnimation("fx",true)
    
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
    inst:AddTag("quake_blocker")  --- 屏蔽地震落石

    inst.Transform:SetRotation(math.random(350))

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("Set",function(_,_table)
        if type(_table) == "table" then
            if _table.pt and _table.pt.x then
                inst.Transform:SetPosition(_table.pt.x,0,_table.pt.z)
            end
            inst.Ready = true
        end
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end


return Prefab("fwd_in_pdt_building_banner_light", fn, assets),
            Prefab("fwd_in_pdt_building_banner_light_fx", ground_fx, assets)