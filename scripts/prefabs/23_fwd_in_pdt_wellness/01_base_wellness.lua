----------------------------------------------------------------------------------------------------------------------------------
--- 体质值
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
                    -- if self.com.DEBUGGING_MODE then
                    --     print("体质值 【直加】的上限 增加到 ",the_max_num)
                    -- end
                end)
            --------------------------------------------------------    
            ---- 回光返照CD天数初始化
                self:Final_Radiance_Buff_Cooldown_Days_Init()  
                self:Add_Final_Radiance_Buff_Day_Cycles_Watcher()      
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
           local value,percent,max = self.com:GetCurrent_Wellness()
           self:Penalize_Player_By_Value(value)
        end
    ------------------------------------------------------------------------------
    -- 移除，看情况需要回收数据
        function inst:OnDetached()
            self:Remove_Final_Radiance_Buff_Day_Cycles_Watcher()            
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

            if  self:HasTag("Final_Radiance") then  --- 有回光返照buff的时候不做任何惩罚奖励
                return
            end

            if num == 0 then
                self:Add_Final_Radiance_Buff_By_CD()                
            end

            ----------------------- 290 以上加速
                if num >= 290 then
                    self:Add_Speed_Up_Mult()
                else
                    self:Remove_Speed_Up_Mult()
                end
            ------------------------280 以上 攻击增加
                if num >= 280 then
                    self:Add_Damage_Mult()
                else
                    self:Remove_Damage_Mult()
                end
            ----------------------- 180 以下
                if num < 180 then
                    self:Add_Sanity_Down_Task()
                else
                    self:Remove_Sanity_Down_Task()
                end
            ----------------------- 160 以下
                if num < 160 then
                    self:Add_Health_Down_Task()
                else
                    self:Remove_Health_Down_Task()
                end
            ----------------------- 100 以下
                if num < 100 then
                    self:Add_Speed_Down_Mult()
                else
                    self:Remove_Speed_Down_Mult()
                end


        end
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 各种 光环效果
        --- 移动速度增加10%
            function inst:Add_Speed_Up_Mult()
                if not self._____speed_up_mult_added_flag then
                    self._____speed_up_mult_added_flag = true
                    self.player.components.locomotor:SetExternalSpeedMultiplier(self,self.prefab,1.1)
                end
            end    
            function inst:Remove_Speed_Up_Mult()
                if self._____speed_up_mult_added_flag then
                    self.player.components.locomotor:RemoveExternalSpeedMultiplier(self,self.prefab)
                    self._____speed_up_mult_added_flag = nil
                end
            end
        ---- 攻击力增加 20%
            function inst:Add_Damage_Mult()
                if not self.____damage_mult_added_flag then
                    self.____damage_mult_added_flag = true
                    self.player.components.combat.externaldamagemultipliers:SetModifier(self,1.2)
                end
            end
            function inst:Remove_Damage_Mult()
                if self.____damage_mult_added_flag then
                    self.____damage_mult_added_flag = nil
                    self.player.components.combat.externaldamagemultipliers:RemoveModifier(self)
                end
            end
        ---- 5秒扣一点 San 。 
            function inst:Add_Sanity_Down_Task()
                if self:HasTag("Final_Radiance") then
                    return
                end
                if self.__sanity_down_task == nil then
                    self.__sanity_down_task = self.player:DoPeriodicTask(1,function(player)
                        if player.components.sanity then
                            player.components.sanity:DoDelta(-0.2,true)
                        end
                    end)
                end
            end
            function inst:Remove_Sanity_Down_Task()
                if self.__sanity_down_task then
                    self.__sanity_down_task:Cancel()
                    self.__sanity_down_task = nil
                end
            end
        ---- 每2秒扣1血
            function inst:Add_Health_Down_Task()
                if self:HasTag("Final_Radiance") then
                    return
                end
                if self.__health_down_task == nil then
                    self.__health_down_task = self.player:DoPeriodicTask(1,function(player)
                        if player.components.health then
                            player.components.health:DoDelta(-0.5,true,self.prefab)
                            ------------------------------------------
                            --- 特殊死亡通告
                                local str = GetStringsTable()["health_down_death_announce"]
                                player.components.fwd_in_pdt_func:Add_Death_Announce({
                                    source = self.prefab,
                                    announce = string.gsub(str, "XXXX", player:GetDisplayName())
                                })
                            ------------------------------------------
                        end
                    end)
                end
            end
            function inst:Remove_Health_Down_Task()
                if self.__health_down_task then
                    self.__health_down_task:Cancel()
                    self.__health_down_task = nil
                end
            end
        
        ---- 移动速度减缓50%
            function inst:Add_Speed_Down_Mult()
                if self:HasTag("Final_Radiance") then
                    return
                end
                if not self.__speed_down_mult_added_flag then
                    self.__speed_down_mult_added_flag = true
                    self.player.components.locomotor:SetExternalSpeedMultiplier(self,self.prefab,0.5)
                end
            end
            function inst:Remove_Speed_Down_Mult()
                if self.__speed_down_mult_added_flag then
                    self.__speed_down_mult_added_flag = nil
                    self.player.components.locomotor:RemoveExternalSpeedMultiplier(self,self.prefab)
                end
            end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---- 回光返照buff .CD 10天
        function inst:Add_Final_Radiance_Buff()
            if self:HasTag("Final_Radiance") then
                return
            end
            self:AddTag("Final_Radiance")

            ------------------------------------
            --- step 1 先清除所有 效果
                self:Remove_Speed_Up_Mult()
                self:Remove_Damage_Mult()
                self:Remove_Sanity_Down_Task()
                self:Remove_Health_Down_Task()
                self:Remove_Speed_Down_Mult()
            ------------------------------------
            --- step 2  增加移速，增加 攻击伤害（自身health_max 的 5% ）
                self:Add_Speed_Up_Mult()    -- 增加移速
                if self._player_final_radiance_event__onhitother == nil then
                    self._player_final_radiance_event__onhitother = function(player,_cmd_table)
                        if type(_cmd_table) == "table" and player and _cmd_table.target then
                            local target = _cmd_table.target
                            if target.components.health then
                                local player_max_health = 100
                                if player.components.health then
                                    player_max_health = player.components.health:GetMaxWithPenalty()
                                end
                                local dmg = -1 * player_max_health * 0.05
                                target.components.health:DoDelta(dmg,true)
                            end
                        end
                    end
                    self.player:ListenForEvent("onhitother",self._player_final_radiance_event__onhitother)

                    self.player:DoTaskInTime(180,function() --- 180s 后移除 增益效果
                        self:RemoveTag("Final_Radiance")
                        self.player:RemoveEventCallback("onhitother",self._player_final_radiance_event__onhitother)
                        self._player_final_radiance_event__onhitother = nil

                        ------------ 扣除血量 20% ，扣除上限 20%
                            if self.player.components.health then
                                local max_health = self.player.components.health.maxhealth
                                local dmg = -1 * max_health * 0.2

                                self.player.components.health:DoDelta(dmg,nil,self.prefab)
                                self.player.components.health:DeltaPenalty(0.2)
                            end
                        if self.com.DEBUGGING_MODE then
                            print("info 回光返照 光环 时间到")
                        end
                    end)
                    if self.com.DEBUGGING_MODE then
                        print("info  回光返照 光环 启动")
                    end



                end

            
        end

        function inst:Add_Final_Radiance_Buff_By_CD()
            if self:Final_Radiance_Buff_IsReady() then
                self:Add_Final_Radiance_Buff()
            end
        end

        function inst:Final_Radiance_Buff_IsReady()     -- 检查是否有CD 并重置计数
            if self.com:Add("Final_Radiance_Buff_CD_Days",0) > 10 then
                self.com:Set("Final_Radiance_Buff_CD_Days",0)
                return true
            else                   
                return false
            end
        end
        function inst:Final_Radiance_Buff_Cooldown_Days_Init()  --- 初始化CD天数,给 OnAttached 使用的
            local days = self.com:Get("Final_Radiance_Buff_CD_Days")
            if days == nil then
                self.com:Add("Final_Radiance_Buff_CD_Days",10)
            end
        end

        function inst:Add_Final_Radiance_Buff_Day_Cycles_Watcher()      --- 每天 天数 + 1 的循环监控任务
            if self.____Final_Radiance_Buff_Day_Cycles_Watcher == nil then
                self.____Final_Radiance_Buff_Day_Cycles_Watcher = function()
                    self.com:Add("Final_Radiance_Buff_CD_Days",1)
                end
                self.player:WatchWorldState("cycles",self.____Final_Radiance_Buff_Day_Cycles_Watcher)
            end
        end
        function inst:Remove_Final_Radiance_Buff_Day_Cycles_Watcher()
            if self.____Final_Radiance_Buff_Day_Cycles_Watcher then
                self.player:StopWatchingWorldState("cycles",self.____Final_Radiance_Buff_Day_Cycles_Watcher)
                self.____Final_Radiance_Buff_Day_Cycles_Watcher = nil
            end
        end


        -- function inst:Remove_Final_Radiance_Buff()
        --     if not self:HasTag("Final_Radiance") then
        --         return
        --     end
        -- end
    ------------------------------------------------------------------------------
    

    return inst
end

return Prefab(this_prefab_name, fn, assets)