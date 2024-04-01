----------------------------------------------------------------------------------------------------------------------------------
--[[

     停止器

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_time_stopper = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("fwd_in_pdt_tag.time_pause_blocker")

    self._stopping_task = nil

    self._entity_list = {}
    self._entity_list_index_with_dissq = {}

    self.inst:ListenForEvent("onremove",function()  --- 被移除的时候解除定时器
        self:Clear()
    end)
    self.inst:ListenForEvent("entitysleep",function()   ---- 加载范围外 就移除
        self:Clear()
        self.inst:Remove()
    end)

    self.__target_entitysleep_event_fn = function(temp_inst)    --- 给目标内部检查使用
        self:Remove(temp_inst)
    end

    self.__target_minhealth_event_fn = function(temp_inst)    --- 给目标内部检查使用,锁死1血
        if temp_inst.components.health then
            temp_inst.components.health.currenthealth = 1
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("target health locked by time stopper",temp_inst)
            end
        end
    end

end,
nil,
{

})

------------------------------------------------------------------------------------------------------------------------------
---- 参考官方的相关API
    local function Self_RemoveFromScene(inst)
        local self = inst
        -- self:AddTag("INLIMBO")
        self:StopBrain()
        if self.sg then
            self.sg:Stop()
        end
        if self.Physics then

            self.Physics:ClearMotorVelOverride()
            self.Physics:SetMotorVel(0,0,0)
            self.Physics:SetMotorVelOverride(0,0,0)

            if self.Transform then
                    local x,y,z = self.Transform:GetWorldPosition()
                    if y > 0.5 then
                        self.Physics:SetActive(false)                
                    end
            end
        end

        if self.AnimState then
            self.AnimState:Pause()
        end

        if self.components.inventoryitem ~= nil and self.components.health == nil then   --- 不允许拾取物品
            self:AddTag("INLIMBO")
            self.entity:SetInLimbo(not self.forcedoutoflimbo)
            self.inlimbo = true
        end
        inst:PushEvent("fwd_in_pdt_com_time_stopper_start")

    end
    local function Self_ReturnToScene(inst)
        local self = inst
        -- self:RemoveTag("INLIMBO")
        if not self:IsValid() then
            print("[ERROR] Calling ReturnToScene on an invalid entity!", self.prefab) -- Keep this for debug logs to come.
        end

        self.entity:Show()
        if self.Physics then
            self.Physics:SetActive(true)
        end
        -- if self.Light then
        --     self.Light:Enable(true)
        -- end
        if self.AnimState then
            self.AnimState:Resume()
        end
        self:RestartBrain()    
        if self.sg then
            self.sg:Start()
        end

        if self.components.inventoryitem ~= nil and self.components.health == nil then --- 重新允许拾取物品
            self.entity:RemoveTag("INLIMBO")
            self.entity:SetInLimbo(false)
            self.inlimbo = false
        end

        inst:PushEvent("fwd_in_pdt_com_time_stopper_end")
    end
------------------------------------------------------------------------------------------------------------------------------
----
    local function time_stopper_for_single_target(inst)     --- 单个目标 定时（每帧都需要执行）
        ------------------------------------------------------------
        ---- DoTaskInTime 推迟
            for PERIODIC, v in pairs(inst.pendingtasks or {}) do
                if PERIODIC and PERIODIC.Cancel and PERIODIC.FWD_IN_PDT_AddTick then
                    PERIODIC:FWD_IN_PDT_AddTick()
                end
            end
        ------------------------------------------------------------
        ---- tag  fwd_in_pdt_tag.time_pause
            if not inst:HasTag("fwd_in_pdt_tag.time_pause") then
                inst:AddTag("fwd_in_pdt_tag.time_pause")
                -- inst:RemoveFromScene()
                Self_RemoveFromScene(inst)
                -- inst.entity:Show()
                inst:RemoveTag("INLIMBO")

            end
        ------------------------------------------------------------
        ---- sg 停掉
            if inst.sg and inst.sg.Stop then
                inst.sg:Stop()
            end
        ------------------------------------------------------------
        ---- EntityScript:RemoveFromScene()
            
        ------------------------------------------------------------
    end
    local function time_stopper_remove_from_single_target(inst) ---- 单个目标，解除定时
        ------------------------------------------------------------
        ---- 
        ------------------------------------------------------------
        ---- tag
            if inst:HasTag("fwd_in_pdt_tag.time_pause") then
                inst:RemoveTag("fwd_in_pdt_tag.time_pause")
                -- inst:ReturnToScene()
                -- inst.entity:Show()
                Self_ReturnToScene(inst)
            end
        ------------------------------------------------------------
        ---- sg 恢复
            if inst.sg and inst.sg.Stop then
                inst.sg:Start()
            end
        ------------------------------------------------------------
    end

------------------------------------------------------------------------------------------------------------------------------
---- 按帧 处理列表里的 inst
    function fwd_in_pdt_com_time_stopper:Start_Task()  --- 开始停止计时器
        if self._stopping_task then
            return
        end
        self._stopping_task = self.inst:DoPeriodicTask(FRAMES, function() --- 以30FPS执行内部扫描
            -------------------------------------------------------------
            ---- 检查列表里的东西
                if #self._entity_list == 0 then
                    self:Stop_Task()
                    return
                end
            -------------------------------------------------------------
            ---- 遍历列表，启动定时器，插入指定的东西
            -------------------------------------------------------------
            ----
                for temp_inst, flag in pairs(self._entity_list_index_with_dissq) do
                    if temp_inst and temp_inst:IsValid() then
                        time_stopper_for_single_target(temp_inst)
                    else
                        self:Remove(temp_inst)
                    end
                end
            -------------------------------------------------------------
        end)
    end
    function fwd_in_pdt_com_time_stopper:Stop_Task()
        if self._stopping_task then
            self._stopping_task:Cancel()
            self._stopping_task = nil
        end
        -------------------------------------------------------------
        ---- 遍历列表，停掉 定时器
        -------------------------------------------------------------
        ----
            for temp_inst, flag in pairs(self._entity_list_index_with_dissq) do
                if temp_inst then
                    time_stopper_remove_from_single_target(temp_inst)
                end
            end
        -------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
---- 添加/移除列表
    local function get_top_parent(temp_inst)
        local top_parent = temp_inst
        while top_parent and top_parent.entity:GetParent() do
            top_parent = top_parent.entity:GetParent()
        end
        return top_parent
    end
    local blocker_tag = "fwd_in_pdt_tag.time_pause_blocker"
    local ignore_tags = {"INLIMBO","invisible","player","fwd_in_pdt_tag.time_pause",blocker_tag}
    function fwd_in_pdt_com_time_stopper:Add(temp_inst)  ---- 添加目标到列表并启动 定时器
        if temp_inst and not self._entity_list_index_with_dissq[temp_inst] 
            and temp_inst:IsValid() and temp_inst ~= self.inst and temp_inst ~= TheWorld 
                and not temp_inst:HasOneOfTags(ignore_tags) and not temp_inst:IsAsleep() then

                if (temp_inst.components.inventory and temp_inst.components.inventory:EquipHasTag(blocker_tag) ) or  ---- 目标身上有屏蔽器
                   ( get_top_parent(temp_inst):HasOneOfTags(ignore_tags) ) then ------ 目标的父节点 不在屏蔽范围内。
                    ---------
                else
                    --------------------------------------------------
                    ---- 插入列表
                        local crash_flag ,dissq = pcall(function()
                            return temp_inst:GetDistanceSqToInst(self.inst)
                        end)
                        self._entity_list_index_with_dissq[temp_inst] = crash_flag and dissq or 1000000
                        table.insert(self._entity_list, temp_inst)
                    
                    --------------------------------------------------
                    ---- 插入 entitysleep event,超出加载范围就移出定时器   
                            temp_inst:ListenForEvent("entitysleep",self.__target_entitysleep_event_fn)
                    --------------------------------------------------
                    ---- 目标带血槽,则进行锁血
                            if temp_inst.components.health then
                                temp_inst:ListenForEvent("minhealth",self.__target_minhealth_event_fn)
                                temp_inst:ListenForEvent("onremove",function()
                                    temp_inst:RemoveEventCallback("minhealth",self.__target_minhealth_event_fn)
                                end,self.inst)
                            end
                    --------------------------------------------------
                end

        end
        self:Start_Task()   ---- 启动任务
    end
    function fwd_in_pdt_com_time_stopper:Remove(temp_inst)
        if self._entity_list_index_with_dissq[temp_inst] then
            local new_table = {}
            local new_table_index = {}
            for k, temp in pairs(self._entity_list) do
                if temp and temp:IsValid() and temp ~= temp_inst then
                    table.insert(new_table, temp)
                    new_table_index[temp] = true
                end
            end
            self._entity_list = new_table
            self._entity_list_index_with_dissq = new_table_index
            --------------------------------------------------
            ---- 移除目标的 entitysleep event 监听
                temp_inst:RemoveEventCallback("entitysleep",self.__target_entitysleep_event_fn)
            --------------------------------------------------
            ---- 移除血条锁血
                temp_inst:RemoveEventCallback("minhealth",self.__target_minhealth_event_fn)
            --------------------------------------------------
        end
        if #self._entity_list == 0 then
            self:Stop_Task()   ---- 停止任务
        end
    end
    function fwd_in_pdt_com_time_stopper:Has(temp_inst)
        if self._entity_list_index_with_dissq[temp_inst] then
            return true
        else
            return false
        end
    end
    function fwd_in_pdt_com_time_stopper:Clear()
        self:Stop_Task()
        self._entity_list = {}
        self._entity_list_index_with_dissq = {}
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_time_stopper







