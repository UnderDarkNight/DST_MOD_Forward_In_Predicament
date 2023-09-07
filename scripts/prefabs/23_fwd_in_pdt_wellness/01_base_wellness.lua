----------------------------------------------------------------------------------------------------------------------------------
--- 体质值
--- 只有执行函数，不做任何数据存储

--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

----------------------------------------------------------------------------------------------------------------------------------

local this_prefab_name = "fwd_in_pdt_wellness"
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
            --- 体质值每天靠食物/道具 最多直接恢复 20 点 。 一天 480s 。 每10s  恢复 0.42
                if self.com:Get("add_wellness_by_external.max_num") == nil then                
                    self.com:Add("add_wellness_by_external.max_num",20)
                end
                self:DoPeriodicTask(10,function()
                    local the_max_num = self.com:Add("add_wellness_by_external.max_num",0)
                    the_max_num = math.clamp(the_max_num + 0.42, 0 , 20)
                    self.com:Set("add_wellness_by_external.max_num",the_max_num)
                    if self.com.DEBUGGING_MODE then
                        print("体质值 【直加】的上限 增加到 ",the_max_num)
                    end
                end)
            --------------------------------------------------------            
        end
    ------------------------------------------------------------------------------
    -- External_DoDelta 外部执行 DoDelta 用做限位的。
        function inst:External_DoDelta(num)
            if type(num) ~= "number" or num <= 0 then
                return
            end
            local ret_add_num = 0
            ---- step 1   获取目前能直加的数
                local the_max_num = self.com:Add("add_wellness_by_external.max_num",0)
            ---- step 2   判断能直加多少
                if num < the_max_num then
                    ret_add_num = num
                    the_max_num = math.clamp(the_max_num - num , 0 , 20)
                    self.com:Set("add_wellness_by_external.max_num",the_max_num)
                else
                    ret_add_num = the_max_num
                    self.com:Set("add_wellness_by_external.max_num",0)
                end
            ---- step 3  DoDelta
                self.com:DoDelta_Wellness(ret_add_num)
            if self.com.DEBUGGING_MODE then
                print("-------- 本次 【体质值】 直加了",ret_add_num,"剩余能直加的数",self.com:Add("add_wellness_by_external.max_num",0))
            end
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
    -- 强制刷新,给吃道具的瞬间用的。
        function inst:ForceRefresh()
            local value,percent,max = self.com:GetCurrent_Wellness()
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
                
        end
    ------------------------------------------------------------------------------



    return inst
end

return Prefab(this_prefab_name, fn, assets)