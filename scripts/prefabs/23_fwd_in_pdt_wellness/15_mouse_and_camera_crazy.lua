----------------------------------------------------------------------------------------------------------------------------------
--- 样板示例
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

local this_prefab_name = "fwd_in_pdt_welness_mouse_and_camera_crazy"
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
    -- inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
    ------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 使用net 下发控制
        inst._net_crazy_target = net_entity(inst.GUID,"fwd_in_pdt_welness_mouse_and_camera_crazy","fwd_in_pdt_welness_mouse_and_camera_crazy")
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("fwd_in_pdt_welness_mouse_and_camera_crazy",function()
                local temp_inst_from_server = inst._net_crazy_target:value()
                print("info test +++++++++++++")
                if temp_inst_from_server and temp_inst_from_server:HasTag("player") and temp_inst_from_server == ThePlayer and ThePlayer.HUD then
                    ------------------------------------------------------------------------------------------------------------
                    --- 执行指定动作
                        ------------------------------------------------------------
                        --- 鼠标相关.晃动 20s 鼠标
                            local function Get_Random_Offset_XY()
                                local x = math.random(10,50)
                                local y = math.random(10,50)
                                if math.random() < 0.5 then
                                    x = -x
                                end
                                if math.random() < 0.5 then
                                    y = -y
                                end
                                return x,y
                            end
                            if TheInputProxy then
                                for i = 1, 40, 1 do
                                    inst:DoTaskInTime(i*0.5,function()
                                            pcall(function()    --- 套上pcall 避免某些特殊情况下 数据丢失崩溃
                                                local mx,my = TheInputProxy:GetOSCursorPos()
                                                local offs_x,offs_y = Get_Random_Offset_XY()
                                                TheInputProxy:SetOSCursorPos(mx+offs_x,my+offs_y)
                                            end)
                                        
                                    end)
                                end
                            end
                        ------------------------------------------------------------
                    ------------------------------------------------------------------------------------------------------------
                end
            end)
        end
        if TheWorld.ismastersim then
            inst:ListenForEvent("set_target_crazy",function(inst,player)
                if player and player:HasTag("player") then
                    ----------------------------------------------------
                    ---- 
                        inst._net_crazy_target:set(player)
                        inst:DoTaskInTime(5,function()  --- 重置数据，net 不会重复下发同一个对象
                            inst._net_crazy_target:set(inst)
                        end)
                    ----------------------------------------------------
                    ---- 
                        for i = 1, 10, 1 do
                            player:DoTaskInTime(i,function()
                                local current_angle = player.components.fwd_in_pdt_func:TheCamera_GetHeadingTarget()
                                local delta_angle = 45
                                if math.random() < 0.5 then
                                    delta_angle = -delta_angle
                                end
                                player.components.fwd_in_pdt_func:TheCamera_SetHeadingTarget(current_angle+delta_angle)
                            end)
                        end
                    ----------------------------------------------------
                    --- 低语
                        player.components.fwd_in_pdt_func:Wisper({
                            m_colour = {255,0,0} ,                          ---- 内容颜色
                            message = GetStringsTable()["debuff_attach_whisper"],                            ---- 文字内容
                        })
                    ----------------------------------------------------


                end
            end)
        end
    ------------------------------------------------------------------------------------------------------------------------------------------------------------
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
                self:DoPeriodicTask(40,function()   --- 40s 下发一次数据
                    self:PushEvent("set_target_crazy",self.player)
                end)
                self:DoTaskInTime(5,function()
                    self:PushEvent("set_target_crazy",self.player)                    
                end)
            --------------------------------------------------------     
            ----
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    print(" 癫痫 buff 添加")
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