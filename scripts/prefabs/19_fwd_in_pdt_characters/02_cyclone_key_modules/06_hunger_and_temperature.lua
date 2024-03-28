--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    洞里饥饿不会下降
    洞外 5 倍威尔逊速度

    消耗饥饿， 保持玩家 30 - 40 度

    自动从饥饿补充血量。

    被冰冻会急剧降低 饥饿

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("cyclone_master_postinit", function()

        --------------------------------------------------------------------------
            local BASE_HUNGER_RATE = 1
        --------------------------------------------------------------------------
        ---- 饥饿速度
            if TheWorld:HasTag("cave") then
                -- inst.components.hunger.hungerrate = 0
                BASE_HUNGER_RATE = 0
            else
                -- inst.components.hunger.hungerrate = 5 * TUNING.WILSON_HUNGER_RATE
                BASE_HUNGER_RATE = 5 * TUNING.WILSON_HUNGER_RATE
            end
            inst.components.hunger.hungerrate = BASE_HUNGER_RATE
        --------------------------------------------------------------------------
        ---- 温度 任务。消耗饥饿， 保持玩家 30 - 40度。 自动从饥饿补充血量。
            inst:DoPeriodicTask(1,function(inst)                
                -----------------------------------------------------------------------------------
                ---- 

                -----------------------------------------------------------------------------------
                ---- 温度
                    local current_temperature = inst.components.temperature.current
                    local current_hunger_value = inst.components.hunger.current
                    if current_hunger_value > 1 then
                        if current_temperature < 30 then

                            inst.components.temperature.current = current_temperature + 1
                            inst.components.hunger:DoDelta(-1,true)

                        elseif current_temperature > 40 then

                            inst.components.temperature.current = current_temperature - 1
                            inst.components.hunger:DoDelta(-1,true)

                        end
                    end

                    inst.components.fwd_in_pdt_func:RPC_PushEvent("cyclone_temperature_updata",inst.components.temperature.current)
                -----------------------------------------------------------------------------------
                ---- 血量,洞里回血不消耗血量
                    current_hunger_value = inst.components.hunger.current
                    local current_health = inst.components.health:GetPercent()
                    if current_hunger_value > 1 and not TheWorld:HasTag("cave") then
                        inst.components.health:DoDelta(1,true)
                        inst.components.hunger:DoDelta(-1,true)
                    elseif TheWorld:HasTag("cave") then
                        inst.components.health:DoDelta(1,true)
                    end
                -----------------------------------------------------------------------------------
            end)
        --------------------------------------------------------------------------
        ---- 免疫火焰伤害
            inst.components.health.externalfiredamagemultipliers:SetModifier(inst,0.5) -- 被火焰直接烧掉血
        --------------------------------------------------------------------------
        ---- 被冰冻急剧降低 饥饿
            inst:ListenForEvent("freeze",function(inst)
                inst.components.hunger.hungerrate = 50 * TUNING.WILSON_HUNGER_RATE
            end)
            inst:ListenForEvent("unfreeze",function(inst)
                inst.components.hunger.hungerrate = BASE_HUNGER_RATE
            end)
        --------------------------------------------------------------------------


    end)

end