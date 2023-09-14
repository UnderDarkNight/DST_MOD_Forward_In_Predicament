----------------------------------------------------------------------------------------------------------------------------------
--- 【 绿蘑菇汤低San debuff】


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

local this_prefab_name = "fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff"
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
                   print(" ------------ 绿蘑菇debuff ") 
                end
            --------------------------------------------------------   
            --- 数据初始化
                if self.com:Get("fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff_timer") == nil then
                    self.com:Set("fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff_timer",30)   -- 150s
                end
            --------------------------------------------------------     
            --- san 无法增加的hook 
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
            self.com:Set("fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff_timer",30)   -- 150s
            if self.com.DEBUGGING_MODE then
                print("重复吃绿蘑菇汤了")
            end
        end
    ------------------------------------------------------------------------------
    -- 周期性刷新的时候执行
        function inst:OnUpdate()
           --[[
                每天贡献 -10
                每个周期贡献 -0.1
           ]]--
           local time = self.com:Add("fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff_timer",-1)
           if time <= 0 then
                self.com:Remove_Debuff(self.prefab)
           end
           if self.com.DEBUGGING_MODE then
                print("绿蘑菇汤剩余时间",time*5)
           end
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            if self.com.DEBUGGING_MODE then
                print("绿蘑菇debuff 移除")
            end
            self.com:Set("fwd_in_pdt_welness_green_mushroom_soup_low_sanity_debuff_timer",nil)   
            --- 清除HOOK
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
    --- hook 玩家API
        function inst:Hook_The_Player()
            if self.player.components.sanity and self.player.components.sanity._DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff == nil then
                self.player.components.sanity._DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff = self.player.components.sanity.DoDelta
                self.player.components.sanity.DoDelta = function(self,num,...)
                    if num > 0 then
                        num = 0
                    end
                    return self:_DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff(num,...)
                end                    
            end
        end
        function inst:Remove_Hook()
            if self.player.components.sanity and self.player.components.sanity._DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff then
                self.player.components.sanity.DoDelta = self.player.components.sanity._DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff
                self.player.components.sanity._DoDelta_Old___welness_green_mushroom_soup_low_sanity_debuff = nil
            end
        end
    ------------------------------------------------------------------------------


    return inst
end

return Prefab(this_prefab_name, fn, assets)