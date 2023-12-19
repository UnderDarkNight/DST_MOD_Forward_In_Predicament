------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    蝙蝠治疗术

    每3秒 回复 10 血。共计60血。 6 次

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

local function heal_player(player)
    for i = 1, 6, 1 do            
            player:DoTaskInTime((i-1)*3,function()
                    if player.components.health then
                        local fx = player:SpawnChild("fwd_in_pdt_fx_red_bats")
                        fx:PushEvent("Set",{
                            speed = 4,
                            color = Vector3(1,1,1),
                            a = 0.3,
                            sound = "dontstarve/creatures/bat/bat_explode",
                        })
                        player:DoTaskInTime(0.3,function()
                            player.components.health:DoDelta(10)
                        end)
                    end
            end)
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    local player = inst.entity:GetParent()
    -----------------------------------------------------
    if TheWorld.ismastersim then
        heal_player(player)
        inst:Remove()
    end
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.entity:GetParent()
end

local function OnUpdate(inst)
    local player = inst.entity:GetParent()
    if TheWorld.ismastersim then
        heal_player(player)

    end
end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = false -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务

    return inst
end

return Prefab("fwd_in_pdt_buff_carl_healing_bats", fn)
