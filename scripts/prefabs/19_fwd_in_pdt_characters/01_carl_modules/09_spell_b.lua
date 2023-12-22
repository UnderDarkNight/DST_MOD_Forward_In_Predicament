--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    技能 b 
    辅助技能

    使用 5个【血瓶】释放技能：自己恢复三维 100/50/50 。给所其他玩家上buff ： 每秒+5血 持续10秒。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_carl"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 冷却、消耗数量
    local spell_cooldown_time = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 3 or 3
    local spell_item_cost_num = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 5 or 5
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 技能执行内容
    local function cast_spell(inst)
        -- local x,y,z = inst.Transform:GetWorldPosition()
        -- local ents = TheSim:FindEntities(x, y, z, 30, {"player"}, {"playerghost"}, nil)
        for k, the_player in pairs(AllPlayers) do
            if the_player and the_player.components.health then
                the_player:AddDebuff("fwd_in_pdt_buff_carl_healing_bats."..tostring(math.random(10000)),"fwd_in_pdt_buff_carl_healing_bats")
            end
        end
        if inst.sg then
            inst.sg:GoToState("combat_lunge_start")
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 技能执行
    local function spell_cast_succeed(inst)
        ------------------------------------------------------------
        ---- 骑牛不能施放
            if inst.components.rider and inst.components.rider:IsRiding() then
                return false
            end
        ------------------------------------------------------------

        local item_cost_num = spell_item_cost_num

        local items = {}    --- index : item_inst , value : stack num
        local total_num = 0
        local containers = {}

        ------------------------------------------------------------
        ---- 背包遍历扫描
            local each_item_check_fn = function(temp_item)
                if temp_item == nil or not temp_item:IsValid() then
                    return
                end
                if temp_item.prefab == "fwd_in_pdt_item_bloody_flask" and temp_item.components.inventoryitem:GetGrandOwner() == inst then
                    items[temp_item] = temp_item.components.stackable.stacksize
                    total_num = total_num + temp_item.components.stackable.stacksize
                elseif temp_item.components.container then
                    containers[temp_item] = true
                end
            end
            inst.components.inventory:ForEachItem(each_item_check_fn)
            for temp_conainer, v in pairs(containers) do
                if temp_conainer and v then
                    temp_conainer.components.container:ForEachItem(each_item_check_fn)
                end
            end
        ------------------------------------------------------------
        ---- 数量不够，终止执行技能
            if total_num < item_cost_num then
                inst.components.fwd_in_pdt_func:Wisper({
                    m_colour = {250,0,0} ,                                                                      ---- 内容颜色
                    message = GetStringsTable()["spell_cost_not_enough"]..tostring(item_cost_num),              ---- 文字内容
                })
                return false
            end
        ------------------------------------------------------------
        ---- 数量充足，移除物品
            for temp_item, item_num in pairs(items) do
                if item_num >= item_cost_num then
                    temp_item.components.stackable:Get(item_cost_num):Remove()
                    break
                else
                    temp_item:Remove()
                    item_cost_num = item_cost_num - item_num
                end
                if item_cost_num <= 0 then
                    break
                end
            end
        ------------------------------------------------------------
        ---- 执行技能
            cast_spell(inst)
        ------------------------------------------------------------
        return true
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0.5,function()
        
                    -------------------------------------------------------------------------
                    ---- 初始化
                        inst.components.fwd_in_pdt_data:Add("carl_spell_cd.b",0)

                    -------------------------------------------------------------------------
                    ---- 检查技能是否合适施放
                        local function spell_is_ready()
                            return inst.components.fwd_in_pdt_data:Add("carl_spell_cd.b",0) == 0
                        end
                    -------------------------------------------------------------------------
                    ---- 停掉 计时器
                        local function stop_cd_timer()
                            if inst.____spell_cd_task_b then
                                inst.____spell_cd_task_b:Cancel()
                                inst.____spell_cd_task_b = nil
                            end
                        end
                    -------------------------------------------------------------------------
                    ---- 技能CD 计时器启动
                        local function start_cd_timer(cool_down_time)
                            if inst.____spell_cd_task_b ~= nil then
                                return
                            end

                            if cool_down_time then
                                inst.components.fwd_in_pdt_data:Set("carl_spell_cd.b",cool_down_time)
                            end

                            local current_time = inst.components.fwd_in_pdt_data:Add("carl_spell_cd.b",0)
                            if current_time <= 0 then
                                stop_cd_timer()
                                return
                            end
                            inst.components.fwd_in_pdt_func:Spell_Set("spell_b_time",current_time) --- 下发数据
                            inst.____spell_cd_task_b = inst:DoPeriodicTask(1,function()
                                local num = inst.components.fwd_in_pdt_data:Add("carl_spell_cd.b",-1)
                                if  num <= 0 then
                                    stop_cd_timer()
                                    inst.components.fwd_in_pdt_data:Set("carl_spell_cd.b",0)
                                    num = 0
                                end
                                inst.components.fwd_in_pdt_func:Spell_Set("spell_b_time",num)
                            end)


                        end
                    -------------------------------------------------------------------------
                    ---- 监听客户端来的执行事件
                        inst:ListenForEvent("fwd_in_pdt_spell.b.start",function()
                            if spell_is_ready() and spell_cast_succeed(inst) then
                                start_cd_timer(spell_cooldown_time)
                                print("技能 B 施放 ++++++++++++++ ")
                            else
                                inst.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_spell.fail")        
                            end
                        end)
                    -------------------------------------------------------------------------
                    ---- 加载的时候检查一下CD
                        start_cd_timer()
                    -------------------------------------------------------------------------

    end)
end