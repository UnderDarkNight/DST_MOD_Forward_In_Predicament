------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 每天只会检查执行一次的任务系统
--- 通常用于广告，签到

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function Get_OS_Time_Num()
    local year = tonumber(os.date("%Y"))
    local month = tonumber(os.date("%m"))
    local day = tonumber(os.date("%d"))
    local ret_num = year*10000+month*100+day
    return ret_num
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    self.TempData._Daily_Task_Data = {}
    function self:DailyTask_Add_Fn(fn)
        if type(fn) == "function" then
            self.TempData._Daily_Task_Data.___task_fns = self.TempData._Daily_Task_Data.___task_fns or {}
            table.insert(self.TempData._Daily_Task_Data.___task_fns,fn)
        end
    end

    function self:DailyTask_Run()
        if self.TempData._Daily_Task_Data.___task_fns then
            for k, fn in pairs(self.TempData._Daily_Task_Data.___task_fns) do
                fn()
            end
            self.TempData._Daily_Task_Data.___task_fns = nil
        end
    end

    self:Add_Cross_Archived_Data_Special_Onload_Fn(function()
        local time = Get_OS_Time_Num()
        local saved_time = self:Get_Cross_Archived_Data("DailyTaskFlag")
        if time ~= saved_time then
            self:DailyTask_Run()
            self:Set_Cross_Archived_Data("DailyTaskFlag",time)
        end
    end)

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(self)
    
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(self)
    if self.inst == nil or not self.inst:HasTag("player") then    --- 本系统只注册给玩家。 不能在这检查 userid ，不然初始化失败
        return
    end
    self:Init("cross_archived_data_sys")
    if self.is_replica ~= true then        --- 不是replica
        main_com(self)
    else      
        replica(self)
    end
end