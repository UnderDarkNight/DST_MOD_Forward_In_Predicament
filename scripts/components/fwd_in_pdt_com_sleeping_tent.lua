------------------------------------------------------------------------------------------------------------------
----- 自制帐篷睡觉组件
----- 为了让 动作顺利执行，部分代码和参数需要放到  TheWorld.ismastersim return 前。
----- 注意代码的  client 和 server 的区别
----- RPC 和  动作 一起在同一个 lua 里注册了。02_sleeping_tent_action.lua
------------------------------------------------------------------------------------------------------------------



local fwd_in_pdt_com_sleeping_tent = Class(function(self, inst)
    self.inst = inst

    self.sleepers = {}
    self.sleeping_players_num = 5

    self.tick_period = TUNING.SLEEP_TICK_PERIOD


    self.sleeping_tick_fn = nil --- 睡觉周期性任务执行的 函数  -- self.sleeping_tick_fn(inst,sleeper)

    self.sleep_phase = {
        ["night"]  = true,
        ["day"]    = true,
    }

    -----------------------------------------------------------------------
    if TheWorld.ismastersim then
        self.inst:WatchWorldState("isday", function() 
            self.inst:DoTaskInTime(0.1,function()
                if self.sleeping_players_num ~= 0 then
                    self:ReCheck_Can_Join()
                end
            end)
        end)

        -- self.inst:WatchWorldState("isnight", function() 
        --     self:ReCheck_Can_Join()    
        -- end)
        -- self.inst:WatchWorldState("isdusk", function() 
        --     self:ReCheck_Can_Join()    
        -- end)

    end

    -----------------------------------------------------------------------

end,
nil,
{

})

function fwd_in_pdt_com_sleeping_tent:Set_Allow_Join_Night(flag)       --- 切换允许 晚上/傍晚 进入
    if flag then
        self.sleep_phase.night = true
    else
        self.sleep_phase.night = false
    end
end
function fwd_in_pdt_com_sleeping_tent:Set_Allow_Join_Day(flag)         --- 切换 允许 白天进入
    if flag then
        self.sleep_phase.day = true
    else
        self.sleep_phase.day = false
    end
end

function fwd_in_pdt_com_sleeping_tent:SetJoinTestFn(fn)        --- 设置独特检查函数，和 状态允许 冲突
    -- return self.player_join_test_fn(self.inst,doer)
    self.player_join_test_fn = fn
end
function fwd_in_pdt_com_sleeping_tent:Check_Can_Join(doer) ------ 检查允许进入。    
    if doer.__fwd_in_pdt_com_sleeping_tent_inst == nil and doer.IsNearDanger and doer:IsNearDanger() then
        return false
    elseif self.inst.components.burnable and self.inst.components.burnable:IsBurning() or self.inst:HasTag("burnt") then
        return false
    elseif self.player_join_test_fn then
        return self.player_join_test_fn(self.inst,doer)
    elseif TheWorld.state.isday and self.sleep_phase.day == true then
        return true
    elseif (TheWorld.state.isdusk or TheWorld.state.isnight) and self.sleep_phase.night == true then
        return true
    else
        return false
    end
end

function fwd_in_pdt_com_sleeping_tent:ReCheck_Can_Join()   ------ 世界状态变化的时候 重新检查和执行
    for temp_player, flag in pairs(self.sleepers) do
        if temp_player and temp_player:IsValid() and flag == true then
            if self:Check_Can_Join(temp_player) ~= true then
                self:DoWakeUp(temp_player)
            end
        end
    end
end

function fwd_in_pdt_com_sleeping_tent:Player_Number_Changed(player,join)  --------- 玩家进出的时候执行这个事件。
    ------------------------------------- 注意 table  的  index 和 value
    ------- setp 1 保存变动前的玩家列表,转置表格
    local last_sleeping_players = {}
    local sleeping_players_last = {}    --- 这个是 event 送出去用的

    for temp_player, flag in pairs(self.sleepers) do
        if temp_player and temp_player:IsValid() and flag == true then
            last_sleeping_players[temp_player] = true
            table.insert(sleeping_players_last,temp_player)
        else
           last_sleeping_players[temp_player] = false 
        end
    end
    self.last_sleeping_players = last_sleeping_players
    
    ------ setp 2 添加新进玩家,转置表格
    local current_leave_player = nil
    local current_join_player = nil

    if join == true then
        self.sleepers[player] = true
        current_join_player = player
    else
        self.sleepers[player] = false   
        current_leave_player = player
    end
    local sleeping_players = {}     --- 这个是 event 送出去用的
    for temp_player, flag in pairs(self.sleepers) do
        if temp_player and temp_player:IsValid() and flag == true then
            table.insert(sleeping_players,temp_player)
        end
    end

    


    --------- 监听事件，用来触发 inst 的动画变化等
    self.inst:PushEvent("player_number_changed",{   

        sleeping_players = sleeping_players,
        num = #sleeping_players, 

        players_last = sleeping_players_last,

        current_leave_player = current_leave_player,
        current_join_player = current_join_player,
    })
    self.sleeping_players_num = #sleeping_players
end

function fwd_in_pdt_com_sleeping_tent:SetSleepingTickFn(fn)    --------- 周期性执行任务
    -- self.sleeping_tick_fn(inst,sleeper)
    self.sleeping_tick_fn = fn
end


local function player_do_sleep_action(doer)
    local function SetSleeperSleepState(inst)   --- 复制自 SGWilson.lua
        if inst.components.grue ~= nil then ---- 屏蔽查理和相关声音
            -- inst.components.grue:AddImmunity("sleeping")
            inst.components.grue:SetSleeping(true)
        end
        if inst.components.talker ~= nil then   --- 屏蔽角色头上的话语
            inst.components.talker:IgnoreAll("sleeping")
        end
        if inst.components.firebug ~= nil then  --- 萤火虫相关的组件
            inst.components.firebug:Disable()
        end
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)
            inst.components.playercontroller:Enable(false)
        end
        if inst.DynamicShadow then              --- 地上的影子
            inst.DynamicShadow:Enable(false)
        end
        inst:OnSleepIn()
        inst.components.inventory:Hide()
        inst:PushEvent("ms_closepopups")
        inst:ShowActions(false)

        
    end
    doer.components.locomotor:Stop()
    SetSleeperSleepState(doer)
    doer:Hide()
    doer:AddTag("invisible")
    doer:AddTag("INLIMBO")
    doer:AddTag("noattack")
    doer:AddTag("notarget")
    if doer.sg then
        doer.sg:AddStateTag("sleeping")
    end

    if doer.components.sanity then  ---- 屏蔽黑夜疯狂掉san
        doer.components.sanity.__redirect__fwd_in_pdt_com_sleeping_tent = doer.components.sanity.redirect
        doer.components.sanity.redirect = function(...)        end
        doer.components.sanity:SetLightDrainImmune(true)    --- 设置灯光屏蔽掉San

    end

end
local function player_do_wakeup_action(inst,doer,_data_table)
    if _data_table and _data_table.camera_down_vec then     --- 得到上传来的 镜头矢量坐标，把玩家位置改为当前界面的 帐篷 下方位置
        local pt = Vector3(inst.Transform:GetWorldPosition())
        pt.x = pt.x +  _data_table.camera_down_vec.x
        pt.z = pt.z +  _data_table.camera_down_vec.z
        doer.Transform:SetPosition(pt.x,0,pt.z)
    end

    local function SetSleeperAwakeState(inst)
        if inst.components.grue ~= nil then     --- 屏蔽查理和黑暗攻击
            -- inst.components.grue:RemoveImmunity("sleeping")
            inst.components.grue:SetSleeping(false)
        end
        if inst.components.talker ~= nil then   --- 屏蔽角色头上的话语
            inst.components.talker:StopIgnoringAll("sleeping")
        end
        if inst.components.firebug ~= nil then  --- 萤火虫
            inst.components.firebug:Enable()
        end
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end
        if inst.DynamicShadow then              --- 地上的影子
            inst.DynamicShadow:Enable(true)
        end
        inst:OnWakeUp()
        inst.components.inventory:Show()
        inst:ShowActions(true)
    end
    SetSleeperAwakeState(doer)

    if doer.sg then
        doer.sg:RemoveStateTag("sleeping")
        doer.sg:GoToState("wakeup")
    end    
    doer:Show()
    doer:RemoveTag("invisible")
    doer:RemoveTag("INLIMBO")
    doer:RemoveTag("noattack")
    doer:RemoveTag("notarget")


    if doer.components.sanity then  ---- 屏蔽黑夜疯狂掉san (恢复原来的函数)
        doer.components.sanity.redirect = doer.components.sanity.__redirect__fwd_in_pdt_com_sleeping_tent
        doer.components.sanity:SetLightDrainImmune(false)
    end

end


function fwd_in_pdt_com_sleeping_tent:DoSleep(doer)

    self:Player_Number_Changed(doer,true)
    -- self.sleepers[doer] = true
    doer.__fwd_in_pdt_com_sleeping_tent_inst = self.inst   ---- 帐篷 inst 和玩家绑定，方便潮湿度 等操作

    if doer.__fwd_in_pdt_com_sleeping_tent_tick_task == nil then
        doer.__fwd_in_pdt_com_sleeping_tent_tick_task = doer:DoPeriodicTask(self.tick_period,function()    ---- 创建周期性执行函数

            if self.sleeping_tick_fn then               ---- 其他函数（比如温度）
                self.sleeping_tick_fn(self.inst,doer)
            end

        end)
    end
    player_do_sleep_action(doer)
    -- print(" fwd_in_pdt_com_sleeping_tent  DoSleep",doer)
    self:rpc_server2client({player_join = true , player = doer})

    if doer.player_classified then  --- 回血光环
        doer.player_classified.issleephealing:set(true)
    end
end

function fwd_in_pdt_com_sleeping_tent:DoWakeUp(doer,_data_table)
    -- print("info DoWakeUp")
    if not TheWorld.ismastersim then
        return
    end
    -- self.sleepers[doer] = false
    self:Player_Number_Changed(doer,false)

    if doer.__fwd_in_pdt_com_sleeping_tent_tick_task then  --- 清掉周期性任务
        doer.__fwd_in_pdt_com_sleeping_tent_tick_task:Cancel()
        doer.__fwd_in_pdt_com_sleeping_tent_tick_task = nil
    end
    doer.__fwd_in_pdt_com_sleeping_tent_inst = nil

    player_do_wakeup_action(self.inst,doer,_data_table)

    if doer.player_classified then --- 回血光环
        doer.player_classified.issleephealing:set(false)
    end

    self:rpc_server2client({sleeping_end = true,player = doer})

end

function fwd_in_pdt_com_sleeping_tent:DoAllWakeUp()    ----- 全部醒来
    for temp_player, flag in pairs(self.sleepers) do
        if temp_player and flag then
            self:DoWakeUp(temp_player)
        end
    end
end
-------------------------------------------------------------------------------------------------------------
-------- RPC 系统
-------- 玩家进入帐篷，下发数据启动监听 键盘按键。一旦按 移动按键或退出按键，关掉监听，并上传数据。
-------- 【默认】上传数据后，执行玩家醒来 的 sg
-------- 【默认】client 这边接收信号 _table.player_join  和 _table.sleeping_end
-------- 【默认】服务器这边接收 _table.wakeup_key_down 和 _table.camera_down_vec
-------- 自设定函数 和 默认函数冲突。（为了更自由的拓展）
function fwd_in_pdt_com_sleeping_tent:Set_RPC_Client_Only_Fn(fn)  --- 设置 客户端专属程序
    if TheNet:IsDedicated() then    ------  如果是专属服务器，则返回
        return
    end
    -- self.rpc_client_only_fn(self.inst,_table)
    self.rpc_client_only_fn = fn
end
function fwd_in_pdt_com_sleeping_tent:Set_RPC_Server_Only_Fn(fn)  --- 设置 服务端专属程序
    if not TheWorld.ismastersim then    ------
        return
    end
    -- self.rpc_server_only_fn(self.inst,_table)
    self.rpc_server_only_fn = fn
end


function fwd_in_pdt_com_sleeping_tent:rpc_func_run_in_client(_table)   ---- 运行在客户端的程序
    ---- 本地玩家 用 ThePlayer 足够了  --- 客户端 才存在的 TheInput 组件
    if self.rpc_client_only_fn == nil and _table then
            if  _table.player_join then     ----- 服务器下发 玩家进入 标记
                -- ThePlayer.components.playercontroller:Enable(false)      --- 已经其他地方执行了，这里没必要，暂时留着
                if ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task == nil then
                        ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task = ThePlayer:DoPeriodicTask(3*FRAMES,function()     --- 10 FPS 检查键盘
                            local keys = {CONTROL_CANCEL,CONTROL_MOVE_UP,CONTROL_MOVE_DOWN,CONTROL_MOVE_LEFT,CONTROL_MOVE_RIGHT} --- 检查这些按键
                            local flag = false
                            for k, temp_key in pairs(keys) do
                                if TheInput:IsControlPressed(temp_key) then
                                    flag = true
                                    break
                                end
                            end
                            if flag == true then
                                --         -- print("6666666666666")
                                ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task:Cancel()   --- 停掉监控任务
                                ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task = nil      --- 注销标记位
                                self:rpc_client2server({wakeup_key_down = true , camera_down_vec = TheCamera:GetDownVec()})    --- 上传数据（包括 镜头矢量坐标）
                                TheCamera:SetTarget(ThePlayer)
                                TheCamera.fov = TheCamera.fov___fwd_in_pdt_old or 35
                            end            
                        end)
                    TheCamera:SetTarget(self.inst)
                    TheCamera.fov___fwd_in_pdt_old = TheCamera.fov
                    TheCamera.fov = 20
                end
            elseif _table.sleeping_end then ----- 服务器下发 玩家离开 标记
                -- print("key event cancel")
                if ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task then
                    ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task:Cancel()
                    ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task = nil
                end
                TheCamera:SetTarget(ThePlayer)
                TheCamera.fov = TheCamera.fov___fwd_in_pdt_old or 35
            end
    elseif self.rpc_client_only_fn ~= nil and type(self.rpc_client_only_fn) == "function" and _table then       --- 自定义执行函数
        self.rpc_client_only_fn(self.inst,_table)
    end
end
function fwd_in_pdt_com_sleeping_tent:rpc_func_run_in_server(_table)   ---- 运行在服务端的程序
    if self.rpc_server_only_fn == nil and  _table and _table.player then
        if _table.wakeup_key_down then
            self:DoWakeUp(_table.player,_table)
        end
    elseif self.rpc_server_only_fn ~= nil and type(self.rpc_server_only_fn) == "function" and _table and _table.player then     --- 自定义执行函数
        self.rpc_server_only_fn(self.inst,_table)
    end
end

function fwd_in_pdt_com_sleeping_tent:rpc_server2client(_table)    ---- 服务器下发数据
    if _table and _table.player and _table.player.userid then
        local userid = _table.player.userid
        _table.player = nil     --- json 不能编码 player_inst
        SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_com_sleeping_tent.server2client"],userid,self.inst,json.encode(_table))
    else
        print("Error : fwd_in_pdt_com_sleeping_tent:rpc_server2client  data_table == nil or  player == nil or userid == nil  ") 
    end
end
function fwd_in_pdt_com_sleeping_tent:rpc_client2server(_table)    ---- 客户端上传数据
    if _table then
        _table.player = nil  --- json 不能编码  player_inst
        SendModRPCToServer(MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_com_sleeping_tent.client2server"],self.inst,json.encode(_table))
    end
end
-------------------------------------------------------------------------------------------------------------

fwd_in_pdt_com_sleeping_tent.OnRemoveFromEntity = fwd_in_pdt_com_sleeping_tent.DoAllWakeUp    ---- 有人正在睡觉，被拆除的时候执行
fwd_in_pdt_com_sleeping_tent.OnRemoveEntity = fwd_in_pdt_com_sleeping_tent.OnRemoveFromEntity

return fwd_in_pdt_com_sleeping_tent