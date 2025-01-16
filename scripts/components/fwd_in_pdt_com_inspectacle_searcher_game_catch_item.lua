----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplica(self)
        return self.inst.replica.fwd_in_pdt_com_inspectacle_searcher_game_catch_item or self.inst.replica._.fwd_in_pdt_com_inspectacle_searcher_game_catch_item
    end
    local function SetCurrent(self, current)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetCurrent(current)
        end
    end
    local function SetMax(self, max)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetMax(max)
        end
    end
    local function SetTime(self, time)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetTime(time)
        end
    end
    local function SetOffset(self,num)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetOffset(num)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher_game_catch_item = Class(function(self, inst)
    self.inst = inst
    
    self.current = 0    -- 当前收集的数量
    self.max = 10       -- 需要收集的数量
    self.time = 60      -- 当前剩余时间
    self.max_time = 60  -- 游戏时间

    self.offset = 30                    -- 随机偏移量
    self.spawn_mark_num_per_second = 2  -- 每秒生成标记数量
    self.mark_on_hit_radius = 1.2       -- 标记碰撞半径
    self.fall_down_delay = 3            -- 标记掉落延迟
    self.fall_down_speed_mult = 1       -- 标记掉落速度倍率
    self.on_hit_fn = function(fx)
        local x,y,z = fx.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x, 0, z, self.mark_on_hit_radius,{"player"},{"playerghost"})
        for _,player in ipairs(players) do
            if player and player.components.playercontroller and player.userid then
                self:OnHit()
                fx:Remove()
                SpawnPrefab("halloween_moonpuff").Transform:SetPosition(x,y,z)
                return
            end
        end
        SpawnPrefab("slurper_respawn").Transform:SetPosition(x,y,z)
    end

    self.playing = false -- 是否正在游戏
    self.marks = {} -- 标记列表
    self.mark_spawn_tasks = {} -- 标记生成任务
    inst:ListenForEvent("onremove",function()
        self:StopGame()
    end)
end,
nil,
{
    current = SetCurrent,
    max = SetMax,
    time = SetTime,
    offset = SetOffset
})

------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetMaxTime(time)
        self.max_time = time
        self.time = time
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:ResetTime()
        self.time = self.max_time
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetMax(max)
        self.max = max
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetMarkNumPerSecond(num)
        self.spawn_mark_num_per_second = math.clamp(num or 0, 1, 50)
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetOnHitRadius(num)
        self.mark_on_hit_radius = num
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetGameRadius(num)
        self.offset = num
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetFallDownDelay(delay)
        self.fall_down_delay = delay
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetFallDownSpeedMult(speed)
        self.fall_down_speed_mult = speed
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetOnHitFn(fn)
        self.on_hit_fn = fn
    end
------------------------------------------------------------------------------------------------------------------------------
--- start game
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:StartGame()
        if self.playing then
            return
        end
        self:ResetTime()
        self.current = 0
        self.playing = true
        self.playing_task = self.inst:DoPeriodicTask(1, function()
            self.time = self.time - 1
            if self.time <= 0 then
                self:StopGame()
                -- if self.current >= self.max then
                --     self.inst:PushEvent("inspectacle_searcher_game_catch_item_win")
                -- end
                self.playing = false
                return
            end
            self:SpawnMark()
        end)
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:OnHit()
        self.current = self.current + 1
        if self.current >= self.max then
            self:StopGame()
            if self.game_win_fn then
                self.game_win_fn(self.inst)
            end
            self.inst:PushEvent("inspectacle_searcher_game_catch_item_win")
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetGameWinFn(fn)
        self.game_win_fn = fn
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:StopGame()
        if self.playing_task then
            self.playing_task:Cancel()
            self.playing_task = nil
        end
        self.playing = false
        for k, temp_mark in pairs(self.marks) do
            if temp_mark and temp_mark:IsValid() then
                temp_mark:Remove()
            end
        end
        self.marks = {}
        for k, temp_task in pairs(self.mark_spawn_tasks) do
            if temp_task then
                temp_task:Cancel()
            end
        end
        self.mark_spawn_tasks = {}
        self.current = 0
        self.time = self.max_time
    end
------------------------------------------------------------------------------------------------------------------------------
---
    local function GetRandomOffset(offset)
        offset = math.random(offset)
        if math.random() > 0.5 then
            return -1 * offset
        else
            return offset
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SpawnMark()
        local x,y,z = self.inst.Transform:GetWorldPosition()
        for i = 1, self.spawn_mark_num_per_second, 1 do
            local task = self.inst:DoTaskInTime(math.random(),function()
                local mark = SpawnPrefab("fwd_in_pdt_fx_catch_game_mark")
                mark:PushEvent("Set",{
                    pt = Vector3(x+GetRandomOffset(self.offset),y,z+GetRandomOffset(self.offset)),
                    delay = self.fall_down_delay,
                    mult = self.fall_down_speed_mult,
                    animover_fn = self.on_hit_fn,
                })
                self.inst:PushEvent("created_mark", mark)
                table.insert(self.marks, mark)
            end)
            table.insert(self.mark_spawn_tasks, task)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher_game_catch_item







