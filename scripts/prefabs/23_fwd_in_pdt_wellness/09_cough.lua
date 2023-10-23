----------------------------------------------------------------------------------------------------------------------------------
--- 【咳嗽】


--- 只有执行函数，不做任何数据存储

--[[

    关键外部API 说明：
    ·  inst:PreAttach(com)             预添加本debuff的时候检查，return true 则允许添加
    ·  inst:OnAttached(com)            添加这个 debuff_inst 的时候执行。绑定 组件 和玩家给本inst ，顺便初始化一些数据。玩家进出洞穴重新添加也会执行。
    ·  inst:External_DoDelta(num)      常驻的debuff 才会执行这个，给外部道具或食物调用，进行各种  上下限 ，比例缩放的操作。
    ·  inst:RepeatedlyAttached()       同一个debuff 重复 添加的时候执行这部分。
    ·  inst:OnUpdate()                 每个扫描周期内都会执行的函数。默认执行周期为 5秒
    ·  inst:OnDetached()               debuff_inst 删除的时候执行。整个Wellness 模块重置的时候，也会调用这个删除 光环循环任务。

    注意事项：
    ·  扫描周期为 5秒，但是提供的光环效果却不是以5s为单位计算的。而是使用 player.DoPeriodicTask 
    ·  注意监控玩家死亡，来停掉 debuff 的光环  player:ListenForEvent("death",fn)  player:RemoveEventCallback("death",fn)   
    ·  OnDetached 的时候也需要 停掉 player.DoPeriodicTask 。不然无法重置整个模块。

]]--

--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

----------------------------------------------------------------------------------------------------------------------------------

local this_prefab_name = "fwd_in_pdt_welness_cough"
local function GetStringsTable(name)
    local prefab_name = name or this_prefab_name
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    -- Asset("ANIM", "anim/fwd_in_pdt_jade_coins.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.tex" ),
    -- Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_jade_coin_green.xml" ),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    --------------------------------------------------------------------------------------
    -- 带洞穴的时候，服务端 执行 player.sg:GoToState 会和 client 端冲突，导致动作播放失败
    inst.___net_entity = net_entity(inst.GUID,"fwd_in_pdt_welness_cough.net_entity","fwd_in_pdt_welness_cough.net_entity")
    if not TheWorld.ismastersim then
        inst:ListenForEvent("fwd_in_pdt_welness_cough.net_entity",function()
            local target = inst.___net_entity:value()   ---- 下发inst

            if target:HasTag("player") then             ---- 如果是玩家，绑定为 inst.player
                inst.player = target
            else                                        ---- 如果不是，则执行 动作,注意 net_vars 不会重复下发相同的东西
                if inst.player and inst.player.sg and inst.player.sg.GoToState then
                    inst.player.sg:GoToState("fwd_in_pdt_wellness_cough")
                end
            end
        end)
        
    end

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
    -- 预添加本Debuff 的时候检查函数，如果通过，则添加，不通过，则不添加
        function inst:PreAttach(com)
            return true
        end
    ------------------------------------------------------------------------------
    -- 添加的瞬间执行的函数组。直接绑定给父节点 
        function inst:OnAttached(com)
            --------------------------------------------------------
            -- 必须要做的，模板化模块 
                self.com = com
                self.player = com.inst  --- 玩家链路进来到这
            --------------------------------------------------------
                self:Add_Cough_Action_Task()
                self:Add_Cough_Action_Event_Fn()
                self:Add_Speed_Down_Mult()
            --------------------------------------------------------    
                if self.com.DEBUGGING_MODE then
                   print(" ------------ 得到咳嗽 debuff") 
                end
                self.___net_entity:set(self.player)     --- 下发 需要绑定的玩家
            --------------------------------------------------------     
            
            
        end
    ------------------------------------------------------------------------------
    -- External_DoDelta 外部执行 DoDelta 用做限位的。
        function inst:External_DoDelta(num)
            
        end
    ------------------------------------------------------------------------------
    -- 重复添加的时候执行的函数
        function inst:RepeatedlyAttached()
            
        end
    ------------------------------------------------------------------------------
    -- 周期性刷新的时候执行
        function inst:OnUpdate()
           --[[
                每天贡献 -10
                每个周期贡献 -0.1
           ]]--
           self.com:DoDelta_Wellness(-0.1)
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            self:Remove_Cough_Action_Task()
            self:Remove_Cough_Action_Event_Fn()
            self:Remove_Speed_Down_Mult()
            if self.com.DEBUGGING_MODE then
                print(" ------------ 咳嗽消失") 
             end
            
        end
    ------------------------------------------------------------------------------
    -- 玩家惩罚
        function inst:Penalize_Player_By_Value(num)
                
        end
    ------------------------------------------------------------------------------
    -- 强制刷新，给道具使用的时候执行的
        function inst:ForceRefresh()
            -- local value,percent,max = self.com:GetCurrent_Wellness()
            -- self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- 负面效果函数
        ------ 10s 执行一次咳嗽动作
            function inst:Add_Cough_Action_Task()
                if self.___cough_action_task == nil then
                    self.___cough_action_task = self.player:DoPeriodicTask(10, function(player)
                        if player and player.sg and player.sg.GoToState and not player:HasTag("playerghost") then
                            player.sg:GoToState("fwd_in_pdt_wellness_cough")
                            self.___net_entity:set(self)    --- 下发自己 inst ,触发 客户端 的 player.sg:GoToState
                            self:DoTaskInTime(3,function()          ---  延时重新下发另一个内容，让下一次 net_vars 可以继续下发
                                self.___net_entity:set(player)
                            end)
                        end
                    end)
                end
            end
            function inst:Remove_Cough_Action_Task()
                if self.___cough_action_task then
                    self.___cough_action_task:Cancel()
                    self.___cough_action_task = nil
                end
            end
        ------ 咳嗽动作的 event 监听
            function inst:Add_Cough_Action_Event_Fn()
                if self.___cough_action_event_fn == nil then
                    self.___cough_action_event_fn = function(player)
                        if player and player:HasTag("player") then
                            local weapon = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                            if weapon then
                                player.components.inventory:DropItem(weapon)
                            end
                        end
                    end
                    self.player:ListenForEvent("fwd_in_pdt_wellness.cough_start",self.___cough_action_event_fn)
                end
            end
            function inst:Remove_Cough_Action_Event_Fn()
                if self.___cough_action_event_fn then
                    self.player:RemoveEventCallback("fwd_in_pdt_wellness.cough_start",self.___cough_action_event_fn)
                    self.___cough_action_event_fn = nil
                end
            end
        ------ 移动速度减缓20%
            function inst:Add_Speed_Down_Mult()
                if not self.___speed_down_mult_flag then
                    self.___speed_down_mult_flag = true
                    self.player.components.locomotor:SetExternalSpeedMultiplier(self,self.prefab,0.8)
                end
            end
            function inst:Remove_Speed_Down_Mult()
                if self.___speed_down_mult_flag then
                    self.___speed_down_mult_flag = nil
                    self.player.components.locomotor:RemoveExternalSpeedMultiplier(self,self.prefab)
                end
            end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------



    return inst
end

return Prefab(this_prefab_name, fn, assets)