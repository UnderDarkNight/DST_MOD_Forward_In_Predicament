----------------------------------------------------------------------------------------------------------------------------------
--- VC值
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

    额外特殊API：
    ·  inst:Set_Value_Block_Go_Down_Update_Times(num)   设置不允许VC值降低的循环次数。
    ·  inst:Allow_Value_OnUpdate_Go_Down()  每次 update 里，VC要降低的时候，这个检查 次数 并 -1 ，再 return 是否允许降低


]]--

--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。
--- 【重要提醒】 光环循环任务 player.DoPeriodicTask  注意判断 玩家 死亡等状态。

----------------------------------------------------------------------------------------------------------------------------------

local this_prefab_name = "fwd_in_pdt_wellness_vitamin_c"
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
            ------------------------------------------
            --[[ 
                    · 按照每天OnUpdate执行100次计算

                    · VC 每天 -5 点，每次 OnUpdate 则为 -0.05


                    · 贡献光环函数说明：
                            0  => 15   点的时候，不提供任何加成
                            15 => 90   点的时候，【每天】提供  0  =>  +2 的加成 。 
                            90 => 100  点的时候，【每天】提供 +2  =>  +5 的加成。

                            ，线性函数为：
                            y = （ k·x + b ）/100
            ]]--                
            ------------------------------------------
            if self:Allow_Value_OnUpdate_Go_Down() then
                self.com:DoDelta_Vitamin_C(-0.05)
            end

            local value ,percent,max = self.com:GetCurrent_Vitamin_C()
            local delta_num = 0
            if value < 15 then
                delta_num = 0
            elseif value < 90 then
                -- 15 => 90
                local k = 2/(90-15)
                local b = -0.4
                local y = ( k * value + b) / 100
                -- self.com:DoDelta_Wellness(y)
                delta_num = y
            elseif value < 100 then
                local k = 0.3
                local b = -25
                local y = (k*value + b)/100
                -- self.com:DoDelta_Wellness(y)
                delta_num = y
            else
                -- self.com:DoDelta_Wellness(0.05)
                delta_num = 0.05
            end
            if self.com.DEBUGGING_MODE then
                print("本周期 VC 值",value,"光环贡献了",delta_num)
            end
            self.com:DoDelta_Wellness(delta_num)
            self:Penalize_Player_By_Value(value)    --- 根据当前VC值 提供/移除惩罚
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()

            self:Remove_Sanity_Down_Task()

        end   
    ------------------------------------------------------------------------------
    -- 强制刷新,给吃道具的瞬间用的。
        function inst:ForceRefresh()
            local value,percent,max = self.com:GetCurrent_Vitamin_C()
            self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    --  文本信息读取
        function inst:GetStringsTable()
            return GetStringsTable(self.prefab) or {}
        end
    ------------------------------------------------------------------------------
    -- 根据VC值执行惩罚函数
        function inst:Penalize_Player_By_Value(num)
            if self.player then
                if num < 15 then
                        self:Add_Sanity_Down_Task()
                else
                        self:Remove_Sanity_Down_Task()
                end
                        
            end
        end
    ------------------------------------------------------------------------------
    --- 降San 任务
        function inst:Add_Sanity_Down_Task()
            if self.___player_sanity_dodelta_task == nil then
                self.___player_sanity_dodelta_task = self.player:DoPeriodicTask(1,function(player)
                    if self.player:HasTag("playerghost") then
                        return
                    end
                    if self.player.components.sanity.DoDelta then
                        player.components.sanity:DoDelta(-1,true)
                    end
                end)
                if self.com.DEBUGGING_MODE then
                    print("VC 值过低，启动每秒 -1 San 的任务")
                end
            end
        end
        function inst:Remove_Sanity_Down_Task()
            if self.___player_sanity_dodelta_task then
                self.___player_sanity_dodelta_task:Cancel()
                self.___player_sanity_dodelta_task = nil
                if self.com.DEBUGGING_MODE then
                    print("VC值足够，停掉降San任务")
                end
            end
        end
    ------------------------------------------------------------------------------
    --- 让VC值一段时间不降低的函数
        function inst:Allow_Value_OnUpdate_Go_Down()
            local update_times_num = self.com:Add("vc_value_go_down_in_update_check_times_num",-1)
            if update_times_num <= 0 then
                return true
            end
            return false
        end
        function inst:Set_Value_Block_Go_Down_Update_Times(num)
            if type(num) == "number" then
                self.com:Set("vc_value_go_down_in_update_check_times_num",num)
            end
        end
    ------------------------------------------------------------------------------



    return inst
end

return Prefab(this_prefab_name, fn, assets)