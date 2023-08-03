

--------------------------------------------------------------------------
------ 灯光控制组件安装。 API ： 
------  inst:HasTag("has.light") 的时候会入夜开启增亮任务
------  inst:PushEvent("light.off")    inst:PushEvent("light.on") 
local function Light_Setup(inst)

    local Max_Intensity = 0.8       --- 最大亮度
    local delta_Intensity = 0.0025  --- 增亮速度

    inst._Light_Intensity = 0
    inst.Light:SetIntensity(0)

    inst:ListenForEvent("light.on",function()
        if not inst:HasTag("has.light") then
            return
        end

        inst.Light:Enable(true)
        -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh") -- 添加贴图荧光效果
        -- inst.AnimState:SetLightOverride(0.4)

        -------- 关闭逐渐熄灭任务
        if inst.__light_off_task then
            inst.__light_off_task:Cancel()
            inst.__light_off_task = nil
        end
        -------- 逐渐增亮任务
        if inst.__light_on_task == nil then
            inst.__light_on_task = inst:DoPeriodicTask(FRAMES, function()
                inst.Light:SetIntensity(inst._Light_Intensity)
                inst._Light_Intensity = inst._Light_Intensity + delta_Intensity
                if inst._Light_Intensity >= Max_Intensity then
                    -- print("light.on  task end")

                    inst._Light_Intensity = Max_Intensity
                    inst.Light:SetIntensity(Max_Intensity)
                    inst.__light_on_task:Cancel()
                    inst.__light_on_task = nil

                    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh") -- 添加贴图荧光效果
                    inst.AnimState:SetLightOverride(0.4)

                end
            end)
        end

    end)

    inst:ListenForEvent("light.off",function()
        if not inst:HasTag("has.light") then
            return
        end

        ------ 关闭逐渐增亮任务
        if inst.__light_on_task then
            inst.__light_on_task:Cancel()
            inst.__light_on_task = nil
        end

        -------- 逐渐熄灭任务
        if inst.__light_off_task == nil then
            inst.__light_off_task = inst:DoPeriodicTask(FRAMES,function()
                inst.Light:SetIntensity(inst._Light_Intensity)
                inst._Light_Intensity = inst._Light_Intensity - delta_Intensity
                if inst._Light_Intensity <= 0 then
                    -- print("light.off  task end")

                    inst.__light_off_task:Cancel()
                    inst.__light_off_task = nil

                    inst._Light_Intensity = 0
                    inst.Light:SetIntensity(0)
                    inst.Light:Enable(false)
                    inst.AnimState:ClearBloomEffectHandle() -- 移除贴图荧光效果
                    inst.AnimState:SetLightOverride(0)

                end

            end)
        end


    end)

    ---------- 监控世界状态，白天关灯，晚上开灯
    inst:WatchWorldState("isday", function()
        if inst:HasTag("has.light") and TheWorld.state.isday then
            -- print("light off task start")
            inst:PushEvent("light.off")
        end
    end)
    inst:WatchWorldState("isnight", function()
        if inst:HasTag("has.light") and TheWorld.state.isnight then
            -- print("light on task start")
            inst:PushEvent("light.on")
        end
    end)

end
--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(2)   -- 光照半径
    inst.Light:SetFalloff(.5)   -- 距离衰减速度（越大衰减越快）
    -- inst.Light:SetIntensity(0.6)    --- 光照强度 --- 靠task 渐变亮度
    inst.Light:SetColour(235 / 255, 255 / 255, 255 / 255)   --- 颜色 RGB


    inst:SetPhysicsRadiusOverride(.5)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    -- Set Tent icon
    inst.MiniMapEntity:SetIcon("portabletent.png")

    inst:AddTag("tent")
    inst:AddTag("portabletent")
    inst:AddTag("structure")

    inst.AnimState:SetBank("tent_walter")
    inst.AnimState:SetBuild("tent_walter")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------------------------
    ------ 为了方便 动作可以触发，组件在 client 和 server 都加载
    ------ 注意部分执行函数必须放 server 上
    inst:AddComponent("fwd_in_pdt_com_sleeping_tent")
        ---------------------------------------------------------------
        --- RPC 往返用的函数
        --- Client 这边用本地玩家 ThePlayer ， Server 这边需要 _table.player
        -------- 【默认】client 这边接收信号 _table.player_join  和 _table.sleeping_end
        -------- 【默认】服务器这边接收 _table.wakeup_key_down  和 _table.camera_down_vec
        inst.components.fwd_in_pdt_com_sleeping_tent:Set_RPC_Client_Only_Fn(function(inst,_table)
            if _table.player_join then
                if  _table.player_join then     ----- 服务器下发 玩家进入 标记
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
                                    ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task:Cancel()   --- 停掉监控任务
                                    ThePlayer.__fwd_in_pdt_com_sleeping_tent_keys_listener_task = nil      --- 注销标记位
                                    inst.components.fwd_in_pdt_com_sleeping_tent:rpc_client2server({wakeup_key_down = true , camera_down_vec = TheCamera:GetDownVec()})    --- 上传数据（包括 镜头矢量坐标）
                                    TheCamera:SetTarget(ThePlayer)
                                    TheCamera.fov = TheCamera.fov___fwd_in_pdt_old or 35
                                end            
                            end)
                        TheCamera:SetTarget(inst)
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
            end
        end)
        inst.components.fwd_in_pdt_com_sleeping_tent:Set_RPC_Server_Only_Fn(function(inst,_table)
            if _table.wakeup_key_down then
                inst.components.fwd_in_pdt_com_sleeping_tent:DoWakeUp(_table.player,_table)
            end
        end)


        ---------------------------------------------------------------

        ------------------- 允许进入检查函数， 自定义或者预设 白天/黑夜，这些函数相互冲突，具体去看com 组件相关代码
        -- inst.components.fwd_in_pdt_com_sleeping_tent:Set_Allow_Join_Night(true)    -- 允许晚上/黄昏进入
        -- inst.components.fwd_in_pdt_com_sleeping_tent:Set_Allow_Join_Day(false)      -- 允许白天 进入
        inst.components.fwd_in_pdt_com_sleeping_tent:SetJoinTestFn(function(inst,doer) 
            ---- 玩家进入检查（action 里会调用这个检查函数,会瞬间多次执行，注意不要过于复杂）
            if doer then
                local pt = Vector3(doer.Transform:GetWorldPosition())
                if pt.y > 0 then    ------- 正在飞的不能进。
                    return false
                elseif  doer:HasTag("insomniac") then    --- 失眠症（老奶奶）
                    return false
                elseif doer.replica and doer.replica.rider and  doer.replica.rider:IsRiding() then --- 必须用 replica ，不然带洞穴时客户端会崩溃
                    return false
                end
            end

            if TheWorld.state.isday then        --- 允许白天进去
                return true
            elseif TheWorld.state.isdusk then   --- 允许黄昏进去
                return true
            elseif TheWorld.state.isnight then  --- 允许晚上进去
                return true
            end
            
            return false
        end)

        if TheWorld.ismastersim then    --- 必须放服务器上的代码

            inst.components.fwd_in_pdt_com_sleeping_tent.tick_period = 2      --- 循环任务周期(单位：秒)
            inst.components.fwd_in_pdt_com_sleeping_tent:SetSleepingTickFn(function(inst,sleeper)      ---- 按照循环周期性执行这个函数
                local sleeping_players_num = inst.components.fwd_in_pdt_com_sleeping_tent.sleeping_players_num

                -------------------------------------------------------------------------------
                --- 体温恢复
                --- 往 35度聚拢
                --- temperature 组件里的 OnUpdate 有sleepingbag_ambient_temp 参数聚拢，无法hook 进去，外部 dodelta 粗糙了点。
                --- 使用  temperature:SetModifier() 会导致 夏天/冬天 的温度控制不好计算。
                if sleeper.components.temperature then
                    local current_temperature = sleeper.components.temperature:GetCurrent()
                    if current_temperature - 35 > 3 then
                        sleeper.components.temperature:DoDelta(-5)
                    elseif 35 - current_temperature > 3 then
                        sleeper.components.temperature:DoDelta(5)                        
                    end
                end
                -------------------------------------------------------------------------------
                ---- 潮湿度
                ---- DoDelta 等很多 函数 会被 增益器 forceddrymodifiers 屏蔽，注意选择其他方式
                if sleeper.components.moisture and sleeper.components.moisture:GetMoisturePercent() > 0 then
                    sleeper.components.moisture:DoDelta(-1,true)
                    -- sleeper.components.moisture.moisture = sleeper.components.moisture.moisture - 1
                end


                -------------------------------------------------------------------------------
                ----- 以下代码参考 sleepingbaguser.lua
                ----- DoDelta 加上额外参数后（overtime参数），没那么吵闹了。
                ----- 注意配合增益器

                local hunger_tick = 0

                local health_tick = 1.5 * sleeping_players_num
                local sanity_tick = 1.5 * sleeping_players_num
            
                local isstarving = false
                if sleeper.components.hunger ~= nil then
                    sleeper.components.hunger:DoDelta(hunger_tick, true, true)
                    isstarving = sleeper.components.hunger:IsStarving()
                end
            
                if sleeper.components.sanity ~= nil and sleeper.components.sanity:GetPercentWithPenalty() < 1 then
                    sleeper.components.sanity:DoDelta(sanity_tick, true)
                end
            
                if not isstarving and sleeper.components.health ~= nil then
                    sleeper.components.health:DoDelta(health_tick, true, inst.prefab, true)
                end
            
                --------- 饿醒
                if isstarving then
                    inst.components.fwd_in_pdt_com_sleeping_tent:DoWakeUp(sleeper)
                end

                -------------------------------------------------------------------------------
            end)


            inst:ListenForEvent("player_number_changed",function(_,_table)  ---- 玩家进出触发这个，用来检查玩家数量，和 修改相关的 三维 恢复
                if _table == nil or _table.sleeping_players == nil then
                    return
                end

                local sleeping_players = _table.sleeping_players or {}  --- 所有正在里面的 玩家
                local players_last = _table.players_last or {}          --- 上一次的玩家列表
                local current_leave_player = _table.current_leave_player     --- 刚刚离开的单个玩家inst
                local current_join_player = _table.current_join_player       --- 刚刚进来的单个玩家inst
                local num = #sleeping_players                           --- 所有正在里面的玩家数量

                -- print("current_join_player",current_join_player)
                -- print("current_leave_players",current_leave_player)
                -- print("players_last",unpack(players_last))
                -- print("sleeping_players",unpack(sleeping_players))

                ----------------------------------------------------------------------------------
                ----- 彻底天黑后 没光源疯狂掉San ,不好处理相关函数，最简单的给帐篷加个光源并启动
                if num == 0 then    --- 切换激活光源相关组件函数。
                    inst:PushEvent("light.off") --- 没玩家了，开始关灯
                    inst:RemoveTag("has.light")
                else
                    inst:AddTag("has.light")
                    if TheWorld.state.isnight then
                        inst:PushEvent("light.on") 
                    end
                end
                ----------------------------------------------------------------------------------


                ------- 增益器 速度 不够快。需要配合DoDelta
                ------- 增益器 会让 三维图标上出现 上下箭头。（箭头大小和参数有关）
                ------- 饥饿值的参数不会有任何箭头出现

                                --- 饥饿值变化 增益器
                                -- target.components.hunger.burnratemodifiers:SetModifier(inst, 0)
                                -- target.components.hunger.burnratemodifiers:RemoveModifier(inst)

                                --- 精神值 变化增益器   ---- 彻底无光环境下，San还是狂 掉，得处理
                                -- target.components.sanity.externalmodifiers:SetModifier(inst, TUNING.WINTERSFEASTBUFF.SANITY_GAIN)
                                -- target.components.sanity.externalmodifiers:RemoveModifier(inst)

                                --- 潮湿值 变化增益器   --- 强制干燥器 可以 免疫雨水，会关闭很多函数运行，包括OnUpdate（），几乎锁死潮湿度的相关变化。
                                -- target.components.moisture.waterproofnessmodifiers:SetModifier(inst, 0)  ---- 参数不是很好整，不能大于 1
                                -- target.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
                                -- target.components.moisture.forceddrymodifiers:RemoveModifier(inst)   --- 强制干燥器
                                -- target.components.moisture.forceddrymodifiers:SetModifier(source or self.inst, true)   --- 强制干燥器 bool

                                --- 温度变化增益器 温度过载不好控制切换
                                --- target.components.temperature:SetModifier(name, value)
                                --- target.components.temperature:RemoveModifier(name)
                                --- 

                --------- 移除旧的增益器
                for k, temp_player in pairs(sleeping_players) do

                    if temp_player.components.sanity then
                        temp_player.components.sanity.externalmodifiers:RemoveModifier(inst)
                    end
                    if temp_player.components.hunger then
                        temp_player.components.hunger.burnratemodifiers:RemoveModifier(inst)
                    end
                    ---- health 没找到 增益器

                    if temp_player.components.moisture then
                        temp_player.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
                        -- temp_player.components.moisture.forceddrymodifiers:RemoveModifier(inst)   --- 强制干燥器
                    end

                    -- if temp_player.components.temperature then
                    --     temp_player.components.temperature:RemoveModifier(inst.prefab)
                    -- end

                end

                -------- 添加新的增益器，参数可以随num 变化
                for k, temp_player in pairs(sleeping_players) do
                    if temp_player.components.sanity then
                        temp_player.components.sanity.externalmodifiers:SetModifier(inst,TUNING.WINTERSFEASTBUFF.SANITY_GAIN * num)
                    end
                    if temp_player.components.hunger then
                        temp_player.components.hunger.burnratemodifiers:SetModifier(inst,5) ---- 注意参数
                    end
                    ---- health 没找到 增益器

                    if temp_player.components.moisture then
                        -- local temp_mois = temp_player.components.moisture:GetMoistureRate()
                        temp_player.components.moisture.waterproofnessmodifiers:SetModifier(inst, 5)
                        -- temp_player.components.moisture.forceddrymodifiers:SetModifier(inst, true)   --- 强制干燥器 bool
                    end

                    -- if temp_player.components.temperature then
                    --     temp_player.components.temperature:SetModifier(inst.prefab,10)
                    -- end

                end

                -------- 清除离开的人的增益器
                if current_leave_player then
                    if current_leave_player.components.sanity then
                        current_leave_player.components.sanity.externalmodifiers:RemoveModifier(inst)
                    end
                    if current_leave_player.components.hunger then
                        current_leave_player.components.hunger.burnratemodifiers:RemoveModifier(inst)
                    end
                    ---- health 没找到 增益器
                    if current_leave_player.components.moisture then
                        current_leave_player.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
                        -- current_leave_player.components.moisture.forceddrymodifiers:RemoveModifier(inst)   --- 强制干燥器
                    end

                    -- if current_leave_player.components.temperature then
                    --     current_leave_player.components.temperature:RemoveModifier(inst.prefab)
                    -- end

                end



            end)


            -- inst:ListenForEvent("player_number_changed",function(_,_table)
            --     if _table == nil or _table.num == nil then
            --         return
            --     end

            --     local sleeping_players = _table.sleeping_players or {}  --- 所有正在里面的 玩家
            --     local players_last = _table.players_last or {}          --- 上一次的玩家列表
            --     local current_leave_player = _table.current_leave_player     --- 刚刚离开的单个玩家inst
            --     local current_join_player = _table.current_join_player       --- 刚刚进来的单个玩家inst
            --     local num = #sleeping_players                           --- 所有正在里面的玩家数量

            --     if num == 0 then
            --         inst.AnimState:PlayAnimation("idle",true)
            --     elseif num == 1 then
            --         inst.AnimState:PlayAnimation("idle_2",true)                    
            --     elseif num == 2 then
            --         inst.AnimState:PlayAnimation("test_anim",true)                    
            --     elseif num == 3 then
            --         inst.AnimState:PlayAnimation("test_anim_3",true)                    
            --     end

            -- end)


        end
    -----------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    Light_Setup(inst)

    inst:AddComponent("inspectable")
    -- inst:AddComponent("lootdropper")

    -- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    -- inst.components.workable:SetWorkLeft(4)
    -- inst.components.workable:SetOnFinishCallback(OnHammered)
    -- inst.components.workable:SetOnWorkCallback(OnHit)



    return inst
end
return Prefab("fwd_in_pdt_test_tent", fn)