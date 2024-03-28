-- 这是一个全部食物的effect
local prefs = {}
------------------------------------------------------------------------------------------------
local oppositeBuffs = {
    buff_hungerretarder = { buff_oilflow = true },
    buff_oilflow = { buff_hungerretarder = true }
}

local function CheckOppositeBuff(buff, target) --去除相克的buff，不让某些buff同时存在
    local nobuffs = oppositeBuffs[buff.prefab]
    if nobuffs == nil then
        return
    end
    local abuff
    for k, _ in pairs(nobuffs) do
        abuff = target:GetDebuff(k)
        if abuff ~= nil then
            if abuff.oppositefn_l ~= nil then
                abuff.oppositefn_l(abuff, buff, target)
            end
            target:RemoveDebuff(k)
        end
    end
end

local function StartTimer_attach(buff, target, timekey, timedefault)
    --因为是新加buff，不需要考虑buff时间问题
    if timekey == nil or target[timekey] == nil then
        if not buff.components.timer:TimerExists("buffover") then --因为onsave比这里先加载，所以不能替换先加载的
            buff.components.timer:StartTimer("buffover", timedefault)
        end
    else
        if not buff.components.timer:TimerExists("buffover") then
            local times = target[timekey]
            if times.add ~= nil then
                times = times.add
            elseif times.replace ~= nil then
                times = times.replace
            elseif times.replace_min ~= nil then
                times = times.replace_min
            else
                buff:DoTaskInTime(0, function()
                    buff.components.debuff:Stop()
                end)
                target[timekey] = nil
                return
            end
            buff.components.timer:StartTimer("buffover", times)
        end
        target[timekey] = nil
    end
end
local function StartTimer_extend(buff, target, timekey, timedefault)
    --因为是续加buff，需要考虑buff时间的更新方式
    if timekey == nil or target[timekey] == nil then
        buff.components.timer:StopTimer("buffover")
        buff.components.timer:StartTimer("buffover", timedefault)
    else
        local times = target[timekey]
        target[timekey] = nil
        if times.add ~= nil then --增加型：在已有时间上增加，可设置最大时间限制
            local timeleft = buff.components.timer:GetTimeLeft("buffover") or 0
            timeleft = timeleft + times.add

            if times.max ~= nil and timeleft > times.max then
                timeleft = times.max
            end
            buff.components.timer:StopTimer("buffover")
            buff.components.timer:StartTimer("buffover", timeleft)
        elseif times.replace ~= nil then --替换型：不管已有时间，直接设置
            buff.components.timer:StopTimer("buffover")
            buff.components.timer:StartTimer("buffover", times.replace)
        elseif times.replace_min ~= nil then --最小替换型：若已有时间<该时间时才设置新时间（比较建议的类型）
            local timeleft = buff.components.timer:GetTimeLeft("buffover") or 0
            if timeleft < times.replace_min then
                buff.components.timer:StopTimer("buffover")
                buff.components.timer:StartTimer("buffover", times.replace_min)
            end
        end
    end
end

local function Attached_timer(inst, target, ...)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function(owner, data)
        inst.components.debuff:Stop()
    end, target)

    local data = inst._dd
    StartTimer_attach(inst, target, data.time_key, data.time_default)
    if data.fn_start ~= nil then
        data.fn_start(inst, target, ...)
    end
end
local function Detached_timer(inst, target, ...)
    if inst._dd.fn_end ~= nil then
        inst._dd.fn_end(inst, target, ...)
    end
    inst:Remove()
end
local function Extended_timer(inst, target, ...)
    local data = inst._dd
    StartTimer_extend(inst, target, data.time_key, data.time_default)
    if data.fn_again ~= nil then
        data.fn_again(inst, target, ...)
    end
end
local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
        return
    end
    if inst._dd.fn_timerdone ~= nil then
        inst._dd.fn_timerdone(inst, data)
    end
end
local function InitTimerBuff(inst)
    inst.components.debuff:SetAttachedFn(Attached_timer)
    inst.components.debuff:SetDetachedFn(Detached_timer)
    inst.components.debuff:SetExtendedFn(Extended_timer)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
end

local function Attached_notimer(inst, target, ...)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function(owner, data)
        inst.components.debuff:Stop()
    end, target)

    if inst._dd.fn_start ~= nil then
        inst._dd.fn_start(inst, target, ...)
    end
end
local function Detached_notimer(inst, target, ...)
    if inst._dd.fn_end ~= nil then
        inst._dd.fn_end(inst, target, ...)
    end
    inst:Remove()
end
local function Extended_notimer(inst, target, ...)
    if inst._dd.fn_again ~= nil then
        inst._dd.fn_again(inst, target, ...)
    end
end
local function InitNoTimerBuff(inst)
    inst.components.debuff:SetAttachedFn(Attached_notimer)
    inst.components.debuff:SetDetachedFn(Detached_notimer)
    inst.components.debuff:SetExtendedFn(Extended_notimer)
end

local function MakeBuff(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
            local inst = CreateEntity()

            if data.addnetwork then --带有网络组件
                inst.entity:AddTransform()
                inst.entity:AddNetwork()
                -- inst.entity:Hide()
                inst.persists = false

                -- inst:AddTag("CLASSIFIED")
                inst:AddTag("NOCLICK")
                inst:AddTag("NOBLOCK")

                if data.fn_common ~= nil then
                    data.fn_common(inst)
                end

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then
                    return inst
                end
            else --无网络组件
                if not TheWorld.ismastersim then
                    --Not meant for client!
                    inst:DoTaskInTime(0, inst.Remove)
                    return inst
                end
                inst.entity:AddTransform()
                --Non-networked entity
                inst.entity:Hide()
                inst.persists = false
                inst:AddTag("CLASSIFIED")
            end

            inst._dd = data

            inst:AddComponent("debuff")
            inst.components.debuff.keepondespawn = true
            if data.notimer then
                InitNoTimerBuff(inst)
            else
                InitTimerBuff(inst)
            end

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
		end,
		data.assets,
		data.prefabs
	))
end

-----

local function BuffTalk_start(target, buff)
    if not target:HasTag("player") then
        return
    end
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(buff.prefab), priority = 1 })
end
local function BuffTalk_end(target, buff)
    if not target:HasTag("player") then
        return
    end
    target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(buff.prefab), priority = 1 })
end

local function IsAlive(inst)
    return inst.components.health ~= nil and not inst.components.health:IsDead() and not inst:HasTag("playerghost")
end
------------------------------------------------------------------------------------------------
-- 血库
-- 自定义一个buff  每2s  +2血  50次任务  buff次数可以叠加  满血不加血  受伤自动开始
------------------------------------------------------------------------------------------------
local function OnTick_healthstorage(inst, target)
    if IsAlive(target) then
        if target.components.health:IsHurt() then --需要加血
            target.components.health:DoDelta(2, true, "shyerry", true, nil, true)
            inst.times = inst.times - 1
            if inst.times <= 0 then
                inst.components.debuff:Stop()
            end
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnSave_healthstorage(inst, data)
	if inst.times ~= nil and inst.times > 0 then
        data.times = inst.times
    end
end

local function OnLoad_healthstorage(inst, data)
	if data ~= nil and data.times ~= nil and data.times > 0 then
        inst.times = inst.times + data.times
    end
end

local function BuffSet_healthstorage(buff, target)
    if target.buff_healthstorage_times ~= nil then --buff次数可以无限叠加
        buff.times = buff.times + target.buff_healthstorage_times
        target.buff_healthstorage_times = nil
    end
    if buff.task_l_heal ~= nil then
        buff.task_l_heal:Cancel()
        buff.task_l_heal = nil
    end
    if buff.times > 0 then
        buff.task_l_heal = buff:DoPeriodicTask(2, OnTick_healthstorage, nil, target)
    end
end
-- 名字在这
MakeBuff({
    name = "fwd_in_pdt_buff_healthstorage",
    assets = nil,
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    fn_start = BuffSet_healthstorage,
    fn_again = BuffSet_healthstorage,
    fn_end = function(buff, target)
        if buff.task_l_heal ~= nil then
            buff.task_l_heal:Cancel()
            buff.task_l_heal = nil
        end
        buff.times = 0
    end,
    fn_server = function(buff)
        buff.times = 0
        buff.OnSave = OnSave_healthstorage
        buff.OnLoad = OnLoad_healthstorage --这个比OnAttached更早执行
    end
})
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--- 减伤
--- 减伤50%
MakeBuff({
    name = "fwd_in_pdt_buff_reduceinjury",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_reduceinjury",
    time_default = TUNING.SEG_TIME*6, --3分钟
    notimer = nil,
    fn_start = function(buff, target)
        if buff.task == nil then
            buff.task = buff:DoPeriodicTask(0.7, function()
                buff:DoTaskInTime(math.random()*0.6, function()
                    if
                        not (
                            target.components.health == nil or target.components.health:IsDead() or
                            target.sg:HasStateTag("nomorph") or
                            target.sg:HasStateTag("silentmorph") or
                            target.sg:HasStateTag("ghostbuild")
                        ) and target.entity:IsVisible()
                        then
                    end
                end)
            end)
            if target.components.health ~= nil then
                target.components.health.externalabsorbmodifiers:SetModifier(buff, 0.5)
            end
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        if target.components.health ~= nil then
            target.components.health.externalabsorbmodifiers:RemoveModifier(buff)
        end
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = nil,
    -- eater.time_l_reduceinjury = { add = TUNING.SEG_TIME*24, max = TUNING.SEG_TIME*30 }
    --         eater:AddDebuff("fwd_in_pdt_buff_reduceinjury", "fwd_in_pdt_buff_reduceinjury")
})
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


return unpack(prefs)