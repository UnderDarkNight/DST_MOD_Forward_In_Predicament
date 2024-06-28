------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    世界温度锁定系统

    TheWorld:PushEvent("lock_world_temperature",{
            temperature = 75,
            time = 10,
            cancel = false,  --- 取消锁定
        })

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("worldtemperature", function(self)

    local lock_task = nil
    local lock_target = 0
    self.fwd_in_pdt_lock_temperature = function(self,num,time)
        time = time or 10
        num = num or 30

        if lock_task ~= nil then
            lock_task:Cancel()
        end
        lock_task = self.inst:DoTaskInTime(time,function()
            lock_task = nil
            local str = "󰀒󰀒󰀒󰀒世界温度恢复正常"
            TheNet:Announce(str)
        end)
        lock_target = num
        local str = "󰀒󰀒󰀒󰀒世界温度将锁定在"..num.."℃,    󰀏󰀏󰀏󰀏持续时间："..time.."秒"
        TheNet:Announce(str)
    end

    local old_OnUpdate = self.OnUpdate
    self.OnUpdate = function(self,dt,...)
        if lock_task ~= nil then
            TheWorld:PushEvent("temperaturetick",lock_target)
            return
        end        
        old_OnUpdate(self,dt,...)
    end

    TheWorld:ListenForEvent("fwd_in_pdt_event.lock_world_temperature",function(inst,data)        
        local num = data.temperature
        local time = data.time
        local cancel = data.cancel or false

        if not cancel then
            self:fwd_in_pdt_lock_temperature(num,time)
        else
            if lock_task ~= nil then
                lock_task:Cancel()
                lock_task = nil
            end
        end
    end)

end)