-- 升级后 的 避雷针
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    避茄针（hook就行了 把寄生函数顶掉）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod.zip"),
    Asset("ANIM", "anim/lightning_rod_fx.zip"),
    Asset("ANIM", "anim/firefighter_placement.zip"),
}


local prefabs =
{
    "lightning_rod_fx",
    "collapse_small",
}

local function onhammered(inst, worker)  -- 敲击发生的事情
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)  -- 敲击在这，回调在后面
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function dozap(inst)
    if inst.zaptask ~= nil then
        inst.zaptask:Cancel()
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.zaptask = inst:DoTaskInTime(math.random(10, 40), dozap)
end

local ondaycomplete
local function discharge(inst)
    if inst.charged then
        inst:StopWatchingWorldState("cycles", ondaycomplete)
        inst.AnimState:ClearBloomEffectHandle()
        inst.charged = false
        inst.chargeleft = nil
        inst.Light:Enable(false)
        if inst.zaptask ~= nil then
            inst.zaptask:Cancel()
            inst.zaptask = nil
        end
    end
end

local function ondaycomplete(inst)
    dozap(inst)
    if inst.chargeleft > 1 then
        inst.chargeleft = inst.chargeleft - 1
    else
        discharge(inst)
    end
end

local function setcharged(inst, charges)
    if not inst.charged then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.Light:Enable(true)
        inst:WatchWorldState("cycles", ondaycomplete)
        inst.charged = true
    end
    inst.chargeleft = math.max(inst.chargeleft or 0, charges)
    dozap(inst)
end

local function onlightning(inst)
    onhit(inst)
    setcharged(inst, 3)
end

local function OnSave(inst, data)
    if inst.charged then
        data.charged = inst.charged
        data.chargeleft = inst.chargeleft
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.charged and data.chargeleft ~= nil and data.chargeleft > 0 then
        setcharged(inst, data.chargeleft)
    end
end

local function getstatus(inst)
    return inst.charged and "CHARGED" or nil
end

------------------------------------------------------------------------------

local function CanBeUsedAsBattery(inst, user)
    if inst.charged then
        return true
    else
        return false, "NOT_ENOUGH_CHARGE"
    end
end

local function UseAsBattery(inst, user)
    discharge(inst)
end

------------------------------------------------------------------------------

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/lightning_rod_craft")
end

--------------------------------------------------------------------------
local range = 30 --- 范围设置30
local PLACER_SCALE = math.sqrt(range * 300 / 1900)
local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0,.227, .45, .322)

            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end
--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Light:Enable(false)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,121/255,12/255)

    --Dedicated server does not need deployhelper
    if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod")
    inst:AddTag("lightningrod")
    -- inst:AddTag("lunarthrall_plant") --- 月奴植物


    inst.AnimState:SetBank("fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod")
    inst.AnimState:SetBuild("fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

   
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("lightningstrike", onlightning) --处理雷击事件

    inst:AddComponent("lootdropper") --设置允许掉落物
    inst:AddComponent("workable") --设置可交互
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER) --使用锤子交互
    inst.components.workable:SetWorkLeft(4) --交互4次
    inst.components.workable:SetOnFinishCallback(onhammered) --交互完成后的回调函数
    inst.components.workable:SetOnWorkCallback(onhit) --交互中的回调函数

    inst:AddComponent("inspectable") --可检查
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("battery") --实现电池功能
    inst.components.battery.canbeused = CanBeUsedAsBattery
    inst.components.battery.onused = UseAsBattery

    inst:AddTag("adbn_updatable")

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt) --监听修建事件并触发回调

    MakeHauntableWork(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod", fn, assets, prefabs),
    MakePlacer("fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod_placer", "fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod", "fwd_in_pdt_building_avoidable_lunarthrall_plant_lightning_rod", "idle")

