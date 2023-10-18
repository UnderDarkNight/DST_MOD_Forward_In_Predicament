----------------------------------------------------------------------------------------------------------------------------------
--- 血糖值
--- 只有执行函数，不做任何数据存储

--[[

    关键外部API 说明：
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

local this_prefab_name = "fwd_in_pdt_wellness_glucose"
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

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
    -- 添加的瞬间执行的函数组。直接绑定给父节点 
        function inst:OnAttached(com)
            --------------------------------------------------------
            -- 必须要做的，模板化模块 
                self.com = com
                self.player = com.inst  --- 玩家链路进来到这
            --------------------------------------------------------

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
           -------------------------------------------------
           --[[
                · 血糖值有过高惩罚区，和过低惩罚区。
                · OnUpdate 以每天 100 次计算
                · 低血糖惩罚区每天提供-10点体质值
                · 高血糖惩罚区每天提供-20点体质值
                · 奖励区每天提供+15点体质值

                ·以下光环数据为每天的量


                · 每天会扣除10血糖，夏季每天扣除20血糖。
                · 每次 0.1     0.2
           ]]--
           -------------------------------------------------
           ---- 自身血糖值计算
                self.com:DoDelta_Glucose(TheWorld.state.issummer and -0.2 or -0.1)
           -------------------------------------------------
           ---- 光环贡献计算
                local value,percent,max = self.com:GetCurrent_Glucose()
                local delta_num = 0
                if value <= 20 then
                    delta_num = -0.1
                elseif value >= 80 then
                    delta_num = -0.2
                else
                    delta_num = 0.15
                end
                -- if self.com.DEBUGGING_MODE then
                --     print("本周期血糖值为",value,"贡献光环",delta_num)
                -- end
                self.com:DoDelta_Wellness(delta_num)
           -------------------------------------------------
                self:Penalize_Player_By_Value(value)
           -------------------------------------------------
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            self:Remove_Low_Value_Task()
            self:Remove_Perfect_Value_Task()
            self:Remove_High_Value_Task()
        end
    ------------------------------------------------------------------------------
    -- 强制刷新,给吃道具的瞬间用的。
        function inst:ForceRefresh()
            local value,percent,max = self.com:GetCurrent_Glucose()
            self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------
    -- 玩家惩罚
        function inst:Penalize_Player_By_Value(num)
            --[[
                    低血糖惩罚区： 饥饿值每秒-1点，每2秒+1点san
                    高血糖惩罚区： 每2秒降低1点san
                    完美血糖奖励区：每5s + 1 血，每2s +1 San
            ]]--
            if num <= 20 then  -------------------------------------------------------------------------------------------------------------------------

                                            self:Add_Low_Value_Task()
                                            self:Remove_Perfect_Value_Task()
                                            self:Remove_High_Value_Task()

            elseif num >= 80 then -------------------------------------------------------------------------------------------------------------------------

                                            self:Add_High_Value_Task()
                                            self:Remove_Low_Value_Task()
                                            self:Remove_Perfect_Value_Task()


            else    -------------------------------------------------------------------------------------------------------------------------
                                            
                                            self:Add_Perfect_Value_Task()
                                            self:Remove_Low_Value_Task()
                                            self:Remove_High_Value_Task()

            end

                
        end
    ------------------------------------------------------------------------------
    ---- 各种task
        ------- 低血糖惩罚task
            function inst:Add_Low_Value_Task() 
                if self.___low_value_task == nil then
                    self.___low_value_task = self.player:DoPeriodicTask(1,function(player)
                        if player:HasTag("playerghost") then
                            return
                        end 
                        if player.components.sanity then
                            player.components.sanity:DoDelta(-0.2,true)
                        end
                        if player.components.hunger then
                            player.components.hunger:DoDelta(-0.1,true)
                        end
                    end)
                    if self.com.DEBUGGING_MODE then
                        print("血糖值到达【低】血糖惩罚区，惩罚Task启动")
                    end
                end
            end
            function inst:Remove_Low_Value_Task()
                if self.___low_value_task then          --- 关闭低血糖惩罚Task
                    self.___low_value_task:Cancel()
                    self.___low_value_task = nil
                end
            end
        ------ 高血糖惩罚Task
            function inst:Add_High_Value_Task()
                if self.___high_value_task == nil then
                    self.___high_value_task = self.player:DoPeriodicTask(1,function(player)
                        if player:HasTag("playerghost") then
                            return
                        end 
                        if player.components.sanity then
                            player.components.sanity:DoDelta(-0.1,true)
                        end
                    end)
                    if self.com.DEBUGGING_MODE then
                        print("血糖值到达【高】血糖惩罚区，惩罚任务启动")
                    end
                end
            end
            function inst:Remove_High_Value_Task()
                if self.___high_value_task then         --- 关闭高血糖惩罚Task
                    self.___high_value_task:Cancel()
                    self.___high_value_task = nil
                end
            end
        ----- 完美血糖奖励Task
            function inst:Add_Perfect_Value_Task()
                    if self.__perfect_value_task == nil then
                        self.__perfect_value_task = self.player:DoPeriodicTask(1,function(player)
                            if player:HasTag("playerghost") then
                                return
                            end 
                            if player.components.health then
                                player.components.health:DoDelta(0.2,true)
                            end
                            if player.components.sanity then
                                player.components.sanity:DoDelta(0.5,true)
                            end
                        end)
                        if self.com.DEBUGGING_MODE then
                            print("血糖值到达【完美】血糖奖励区。奖励任务启动")
                        end
                    end
            end
            function inst:Remove_Perfect_Value_Task()
                if self.__perfect_value_task then       --- 关闭完美血糖奖励Task
                    self.__perfect_value_task:Cancel()
                    self.__perfect_value_task = nil
                end
            end
    ------------------------------------------------------------------------------



    return inst
end

return Prefab(this_prefab_name, fn, assets)