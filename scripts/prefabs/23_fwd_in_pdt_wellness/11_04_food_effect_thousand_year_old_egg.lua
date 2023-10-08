----------------------------------------------------------------------------------------------------------------------------------
--- 【 皮蛋 buff】


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

local this_prefab_name = "fwd_in_pdt_welness_thousand_year_old_egg_buff"
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
                if self.com.DEBUGGING_MODE then
                   print(" ------------ 皮蛋 buff ") 
                end
            --------------------------------------------------------   
            --- 数据初始化
                if self.com:Get("fwd_in_pdt_welness_thousand_year_old_egg_buff_timer") == nil then
                    self.com:Set("fwd_in_pdt_welness_thousand_year_old_egg_buff_timer",300)   -- 3 days
                end
                self:Hook_The_Player()
            --------------------------------------------------------   
                self.player:ListenForEvent("death",function()                    
                    self.com:Remove_Debuff(self.prefab)
                end)
            --------------------------------------------------------            
            
        end
    ------------------------------------------------------------------------------
    -- External_DoDelta 外部执行 DoDelta 用做限位的。
        function inst:External_DoDelta(num)
            
        end
    ------------------------------------------------------------------------------
    -- 重复添加的时候执行的函数
        function inst:RepeatedlyAttached()
            self.com:Set("fwd_in_pdt_welness_thousand_year_old_egg_buff_timer",300)   -- 3 days
            if self.com.DEBUGGING_MODE then
                print("重复吃 皮蛋 了")
            end
        end
    ------------------------------------------------------------------------------
    -- 周期性刷新的时候执行
        function inst:OnUpdate()
           --[[
                每天贡献 -10
                每个周期贡献 -0.1
           ]]--
           local time = self.com:Add("fwd_in_pdt_welness_thousand_year_old_egg_buff_timer",-1)
           if time <= 0 then
                self.com:Remove_Debuff(self.prefab)
           end
           if self.com.DEBUGGING_MODE then
                print(" 皮蛋 buff 剩余时间",time*5)
           end
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            if self.com.DEBUGGING_MODE then
                print(" 皮蛋 buff 移除")
            end
            self.com:Set("fwd_in_pdt_welness_thousand_year_old_egg_buff_timer",nil)   
            self:Remove_Hook()
        end

    ------------------------------------------------------------------------------
    -- 强制刷新，给道具使用的时候执行的
        function inst:ForceRefresh()

        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------
    --- 速度乘法器
        ---- 主要用于移除 厨子 和 小恶魔 的食物 机制
        function inst:Hook_The_Player()
            ---- 厨子
                if self.player.components.foodmemory and self.player.components.foodmemory._GetFoodMultiplier_old_thousand_year_old_egg == nil then
                    self.player.components.foodmemory._GetFoodMultiplier_old_thousand_year_old_egg = self.player.components.foodmemory.GetFoodMultiplier
                    self.player.components.foodmemory.GetFoodMultiplier = function(self,...)
                        self.inst:DoTaskInTime(0.5,function()                            
                                for food_prefab, _table in pairs(self.foods) do
                                    if type(_table) == "table" and _table.task then
                                        _table.task:Cancel()
                                    end
                                    self.foods[food_prefab] = nil
                                end
                        end)

                        return 1
                    end
                end
            ---- 小恶魔
                if self.player.components.eater then
                    local healthabsorption = self.player.components.eater.healthabsorption
                    local hungerabsorption = self.player.components.eater.hungerabsorption
                    local sanityabsorption = self.player.components.eater.sanityabsorption
                    self.com:Set("thousand_year_old_egg_buff.healthabsorption",healthabsorption)
                    self.com:Set("thousand_year_old_egg_buff.hungerabsorption",hungerabsorption)
                    self.com:Set("thousand_year_old_egg_buff.sanityabsorption",sanityabsorption)
                    self.player.components.eater:SetAbsorptionModifiers(1, 1, 1)
                end
        end
        function inst:Remove_Hook()
            ---- 厨子
                if self.player.components.foodmemory and self.player.components.foodmemory._GetFoodMultiplier_old_thousand_year_old_egg then
                    self.player.components.foodmemory.GetFoodMultiplier = self.player.components.foodmemory._GetFoodMultiplier_old_thousand_year_old_egg
                    self.player.components.foodmemory._GetFoodMultiplier_old_thousand_year_old_egg = nil
                end
            ---- 小恶魔
            if self.player.components.eater then
                local healthabsorption = self.com:Get("thousand_year_old_egg_buff.healthabsorption") or 1
                local hungerabsorption = self.com:Get("thousand_year_old_egg_buff.hungerabsorption") or 1
                local sanityabsorption = self.com:Get("thousand_year_old_egg_buff.sanityabsorption") or 1
                self.player.components.eater:SetAbsorptionModifiers(healthabsorption, hungerabsorption, sanityabsorption)
            end
        end
    ------------------------------------------------------------------------------


    return inst
end

return Prefab(this_prefab_name, fn, assets)