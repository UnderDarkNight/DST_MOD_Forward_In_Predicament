----------------------------------------------------------------------------------------------------------------------------------
--- 样板示例
--- 只有执行函数，不做任何数据存储

--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

----------------------------------------------------------------------------------------------------------------------------------

local this_prefab_name = "fwd_in_pdt_wellness_poison"
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
           --[[
                · OnUpdate 按照每天 100 次执行计算

                0-50 低中毒惩罚区，每天提供 -15 体质值
                50-100 高中毒惩罚区，每天提供 -36 体质值

           ]]--

           local value,percent,max = self.com:GetCurrent_Poison()
            local delta_num = 0
            if value <= 50 then
                delta_num = (-0.3 * value)/100
            elseif value < 100 then
                delta_num = ( -0.42*value + 6)/100
            else
                delta_num = -0.36
            end
            if self.com.DEBUGGING_MODE then
                print("中毒值为",value,"光环贡献",delta_num)
            end
            self.com:DoDelta_Wellness(delta_num)
            self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            if self.___step_1_task then         --- 停掉任务
                self.___step_1_task:Cancel()
                self.___step_1_task = nil
            end
            if self.___step_2_task then         --- 停掉任务
                self.___step_2_task:Cancel()
                self.___step_2_task = nil
            end
        end
    ------------------------------------------------------------------------------
    -- 玩家惩罚
        function inst:Penalize_Player_By_Value(num)
            --[[
                    大于50：每2分钟降低10点san  --  3秒  -0.25
                    大于75：每两分钟降低5血量   -- 每1秒  -0.042 .  每5秒 -0.21
                    达到100：制作物品速度和移动速度变为原来的50%
                    【以上效果按区间累计叠加】
            ]]--

            ---------------------------------------------------------------------------------
            ----- 
                if num > 50 then
                        if self.___step_1_task == nil then
                            self.___step_1_task = self.player:DoPeriodicTask(3,function(player)
                                if player:HasTag("playerghost") then
                                    return
                                end 
                                if player.components.sanity then
                                    player.components.sanity:DoDelta(-0.25,true)
                                end
                            end)
                        end
                else
                        if self.___step_1_task then
                            self.___step_1_task:Cancel()
                            self.___step_1_task = nil
                        end
                end
            ---------------------------------------------------------------------------------
            ---- 
                if num > 75 then
                        if self.___step_2_task == nil then
                            self.___step_2_task = self.player:DoPeriodicTask(5,function(player)
                                if player:HasTag("playerghost") then
                                    return
                                end 
                                if player.components.health then
                                    --- 可以在这添加特殊死亡提示
                                    player.components.health:DoDelta(-0.2,true)
                                end
                            end)
                        end
                else
                        if self.___step_2_task then
                            self.___step_2_task:Cancel()
                            self.___step_2_task = nil
                        end
                end

            if num >= 100 then

            else

            end

        end
    ------------------------------------------------------------------------------
    -- 强制刷新，给道具使用的时候执行的
        function inst:ForceRefresh()
            local value,percent,max = self.com:GetCurrent_Poison()
            self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------



    return inst
end

return Prefab(this_prefab_name, fn, assets)