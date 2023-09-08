----------------------------------------------------------------------------------------------------------------------------------
--- 【发烧】


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

local this_prefab_name = "fwd_in_pdt_welness_fever"
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
                self:Add_Fever_Task()
                self:Add_Speed_Down_Mult()
            --------------------------------------------------------    
                if self.com.DEBUGGING_MODE then
                   print(" ------------ 开始发烧 ") 
                end
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

            self:Remove_Fever_Task()
            self:Remove_Speed_Down_Mult()
            if self.com.DEBUGGING_MODE then
                print(" ------------ 发烧消失") 
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
        ------ 体温增加
            function inst:Add_Fever_Task()
                if self.___fever_task == nil then
                    self.___fever_task = self.player:DoPeriodicTask(1,function(player)
                        --[[
                            往 75℃ 聚拢
                        ]]--
                        if player.components.temperature then
                            local current_num = player.components.temperature:GetCurrent()
                            local delta_num = math.abs( (current_num - 75)/5 )
                            player.components.temperature:DoDelta(delta_num)
                        end

                    end)
                end
            end
            function inst:Remove_Fever_Task()
                if self.___fever_task then
                    self.___fever_task:Cancel()
                    self.___fever_task = nil
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