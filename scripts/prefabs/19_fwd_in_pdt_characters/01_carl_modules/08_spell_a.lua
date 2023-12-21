--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    技能 a 
    主技能

    【主动】【技能】【蝙蝠环绕】：消耗【血瓶】50个释放，8min CD ： 暗影主教的特效，
    （立绘）召唤蝙蝠环绕自己且同时攻击附近所有敌人（半径10），
    每秒钟对该敌人敌人造成50（暗影心房100）点伤害持续50秒。期间玩家不会受到任何形式掉血。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 冷却
    local spell_cooldown_time = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 30 or 480
    local spell_item_cost_num = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 5 or 50
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 技能执行内容
    local function cast_spell(inst)
        local spell_timer = 51

        local combat_block_fn = function(combat_com,attacker, damage, ...)  ----- 免疫伤害
            local fx = combat_com.inst:SpawnChild("fwd_in_pdt_fx_shadow_shell")
            fx:PushEvent("Set",{
                pt = Vector3(0,0,0),
                speed = 2,
                color = Vector3(255,0,0)
            })
            damage = 0
            return attacker,damage,...
        end

        inst.components.fwd_in_pdt_func:PreGetAttacked_Add_Fn(combat_block_fn)
        inst._________________spell_a_task = inst:DoPeriodicTask(1,function()
            spell_timer = spell_timer  - 1
            -----------------------------------------------------------------
                if spell_timer <= 0 then    ----- 时间到了
                    inst._________________spell_a_task:Cancel()
                    if inst._________________spell_a_task_mark_fx then  --- 移除所有特效
                        for k, temp_fx in pairs(inst._________________spell_a_task_mark_fx) do
                            temp_fx:PushEvent("Remove")                            
                        end
                        inst._________________spell_a_task_mark_fx = nil
                    end
                    inst.components.fwd_in_pdt_func:PreGetAttacked_Remove_Fn(combat_block_fn)
                end
            -----------------------------------------------------------------
            local heart_flag = inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_carl_thirst_for_blood__shadowheart") ~= nil
            local x,y,z = inst.Transform:GetWorldPosition()

            local canthavetags = { "companion","isdead","player","INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" ,"chester","hutch","wall","structure"}
            local musthavetags = nil
            local musthaveoneoftags = {"pig","rabbit","animal","smallcreature","epic","monster","insect"}
            local ents = TheSim:FindEntities(x, 0, z, 10, musthavetags, canthavetags, musthaveoneoftags)
            for k, temp_monster in pairs(ents) do
                if temp_monster and temp_monster:IsValid() and temp_monster.components.combat and temp_monster.components.health then
                    local fx = temp_monster:SpawnChild("fwd_in_pdt_fx_red_bats")
                    fx:PushEvent("Set",{
                        speed = 5,
                        sound = math.random(100)< 20 and "dontstarve/creatures/bat/bat_explode" or nil,
                    })
                    temp_monster.components.health:DoDelta(heart_flag and -100 or -50)  ---- 造成伤害
                    temp_monster.components.combat:SuggestTarget(inst)
                    inst.components.health:DoDelta(10,true) --- 玩家吸血
                end
            end

        end)
        ----------------------------------------------------
        -- 播放立绘
            inst:PushEvent("fwd_in_pdt.drawing.display",{
                bank = "fwd_in_pdt_drawing_carl_spell_a",
                build = "fwd_in_pdt_drawing_carl_spell_a",
                anim = "idle",
                location = 5,
                pt = Vector3(0,100),
                scale = 0.7,
                sound = "dontstarve/creatures/bat/bat_explode",
            })
            if inst.sg then
                inst.sg:GoToState("combat_lunge_start")
            end
        ----------------------------------------------------
        -- 给自己上标记
            inst._________________spell_a_task_mark_fx = {}
            local temp_fx = inst:SpawnChild("fwd_in_pdt_fx_red_bats_mark")
            temp_fx:PushEvent("Set",{
                pt = Vector3(0,3,0),
                scale = 0.5,
            })
            table.insert(inst._________________spell_a_task_mark_fx,temp_fx)

            local surround_locations =  TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = Vector3(0,0,0),
                    range = 10,
                    num = 24
            })
            for k, temp_pt in pairs(surround_locations) do
                local fx = inst:SpawnChild("fwd_in_pdt_fx_red_bats_mark")
                fx:PushEvent("Set",{
                    pt = temp_pt,
                })
                table.insert(inst._________________spell_a_task_mark_fx,fx)
            end
        ----------------------------------------------------

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
                        inst.components.fwd_in_pdt_data:Add("carl_spell_cd.a",0)

                    -------------------------------------------------------------------------
                    ---- 检查技能是否合适施放
                        local function spell_is_ready()
                            return inst.components.fwd_in_pdt_data:Add("carl_spell_cd.a",0) == 0
                        end
                    -------------------------------------------------------------------------
                    ---- 停掉 计时器
                        local function stop_cd_timer()
                            if inst.____spell_cd_task_a then
                                inst.____spell_cd_task_a:Cancel()
                                inst.____spell_cd_task_a = nil
                            end
                        end
                    -------------------------------------------------------------------------
                    ---- 技能CD 计时器启动
                        local function start_cd_timer(cool_down_time)
                            if inst.____spell_cd_task_a ~= nil then
                                return
                            end

                            if cool_down_time then
                                inst.components.fwd_in_pdt_data:Set("carl_spell_cd.a",cool_down_time)
                            end

                            local current_time = inst.components.fwd_in_pdt_data:Add("carl_spell_cd.a",0)
                            if current_time <= 0 then
                                stop_cd_timer()
                                return
                            end
                            inst.components.fwd_in_pdt_func:Spell_Set("spell_a_time",current_time)
                            inst.____spell_cd_task_a = inst:DoPeriodicTask(1,function()
                                local num = inst.components.fwd_in_pdt_data:Add("carl_spell_cd.a",-1)
                                if  num <= 0 then
                                    stop_cd_timer()
                                    inst.components.fwd_in_pdt_data:Set("carl_spell_cd.a",0)
                                    num = 0
                                end
                                inst.components.fwd_in_pdt_func:Spell_Set("spell_a_time",num)
                            end)


                        end
                    -------------------------------------------------------------------------
                    ---- 监听客户端来的执行事件
                        inst:ListenForEvent("fwd_in_pdt_spell.a.start",function()
                            if spell_is_ready() and spell_cast_succeed(inst) then
                                start_cd_timer(spell_cooldown_time)
                                print("技能 A 施放 ++++++++++++++ ")
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