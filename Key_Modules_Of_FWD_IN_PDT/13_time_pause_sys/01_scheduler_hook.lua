----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[




    scheduler  DoTaskInTime  的暂停API 添加


    -- 遍历实体的所有计时器，并让它们的完成时间往后推1帧
    -- 配合组件的OnUpdate函数就能实现计时器暂停
    for k in pairs(inst.pendingtasks or {})do
        k:AddTick()
    end


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddGlobalClassPostConstruct("scheduler","Periodic",function(self)

    function self:FWD_IN_PDT_AddTick()
        local thislist = scheduler.attime[self.nexttick]
        self.nexttick = self.nexttick + 1
        if not thislist then
            return
        end
        if not scheduler.attime[self.nexttick] then
            scheduler.attime[self.nexttick] = {}
        end
        local nextlist = scheduler.attime[self.nexttick]
        thislist[self] = nil 
        nextlist[self] = true
        self.list = nextlist
    end

end)


