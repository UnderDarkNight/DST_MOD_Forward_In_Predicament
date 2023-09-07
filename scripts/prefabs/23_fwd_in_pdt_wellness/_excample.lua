----------------------------------------------------------------------------------------------------------------------------------
--- 样板示例
--- 只有执行函数，不做任何数据存储

--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

----------------------------------------------------------------------------------------------------------------------------------

local this_prefab_name = "fwd_in_pdt_welness_vc"
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
           
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            
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



    return inst
end

return Prefab(this_prefab_name, fn, assets)