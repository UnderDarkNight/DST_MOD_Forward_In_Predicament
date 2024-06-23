--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ 
    
        本模块为体质值的事件监听

        被攻击事件监听 

        吃食物事件监听

        季节变换事件监听

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)

    

    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------------------------
        inst:AddComponent("fwd_in_pdt_wellness") --- 添加体质值组件


    ----------------------------------------------------------------------------------------------------------
    -----------  玩家被攻击后，触发对应的事件，中毒、疾病等
        inst:ListenForEvent("attacked",function(inst,_table)
            if not (_table and _table.attacker ) then
                return
            end

            local attacker = _table.attacker

            ----------------------------------------------------------------------------------------------------------------------
                local events_fn_by_prefab = {   ------- 靠prefab 执行的事件
                    ["killerbee"] = function()  --- 被杀人蜂攻击绝对中蜜蜂毒
                        inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")                    
                    end,
                    ["bee"] = function()        --- 普通蜜蜂攻击 10% 概率中蜜蜂毒
                        if math.random(1000) <= 100 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")                        
                        end
                    end,
                    ["beeguard"] = function()        --- 蜂王的蜜蜂护卫攻击 3% 概率中蜜蜂毒
                        if math.random(1000) <= 30 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")                        
                        end
                    end,
                    ["beequeen"] = function()        --- 蜂后攻击 30% 概率中蜜蜂毒
                        if math.random(1000) <= 300 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")                        
                        end
                    end,
                    ["frog"] = function()
                        if attacker and attacker:HasTag("fwd_in_pdt_tag.mutant_frog") then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_frog_poison")                        
                        end
                    end,
                    ["fwd_in_pdt_animal_frog_hound"] = function()   ---- 二蛤有50%概率上毒
                        if math.random(100) < 50 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_frog_poison")                        
                        end
                    end,
                    ["fwd_in_pdt_animal_snake"] = function()            --- 蛇 20% 造成中毒
                        if math.random(1000) <= 200 then
                            -- print(" +++ 添加蛇毒 +++ ")
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_snake_poison")                        
                        end
                    end,
                    ["fwd_in_pdt_animal_snake_hound"] = function()            --- 蛇狗 50% 造成中毒
                        if math.random(1000) <= 500 then
                            -- print(" +++ 添加蛇毒 +++ ")
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_snake_poison")                        
                        end
                    end,
                    ["daywalker"] = function()            --- 梦魇疯猪 100% 癫痫
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")                        
                    end,
                    ["daywalker2"] = function()            --- 拾荒疯猪 100% 癫痫
                        inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")                        
                    end,
                    ["moonpig"] = function()            --- 月台疯猪 60% 癫痫
                        if math.random(1000) <= 600 then
                        inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_mouse_and_camera_crazy")                        
                        end
                    end,


                }

                local events_fn_by_tag = {      -------- 靠Tag 执行的事件


                    ["fwd_in_pdt_poison_frog"] = function()     ---- 毒青蛙
                        inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_frog_poison")                    
                    end,
                    ["spider"] = function()    
                        --[[                            
                            普通的蜘蛛 ： 0.5 %
                            其他蜘蛛   ： 5 %
                        ]]--
                        if attacker.prefab == "spider" then
                            if math.random(1000) <= 5 then
                                inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_spider_poison")
                            end
                            return
                        end
                        if math.random(1000) <= 50 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_spider_poison")
                        end
                    end,


                }








                if events_fn_by_prefab[attacker.prefab] then
                    events_fn_by_prefab[attacker.prefab]()
                end

                for theTAG, the_fn in pairs(events_fn_by_tag) do
                    if theTAG and the_fn and attacker:HasTag(theTAG) then
                        the_fn()
                    end
                end
            ----------------------------------------------------------------------------------------------------------------------

        end)




    ----------------------------------------------------------------------------------------------------------
    -----------  吃对应的东西后执行的事件
        local cooking = require("cooking")
        local cooking_ingredients = cooking.ingredients
        -------------- 血糖值
            local function GetGluByFood(food)
                local prefab_list_with_glu_value = {
                    --以下是和海洋传说做的兼容
                    ["lg_rice"] = 10,                     ---白饭
                    ["honey_cake"] = 20,                  ---金丝榴莲酥
                    ["lg_bigmilk"] = 20,                  ---手摇奶昔
                    ["lg_putea"] = 20,                    ---葡萄气泡水
                    ["lg_sweat"] = 40,                    ---蜂蜜面包
                    ["lg_caomei"] = 20,                   ---草莓甜甜圈
                    ["lg_dangao"] = 20,                   ---生日蛋糕
                    --以下是和小穹人物mod的兼容
                    ["sora_tangjianzhuzi"] = 20,            ---糖煎竹子
                    ["sora_qiaokeli"] = 20,                 ---甜心巧克力
                    ["sora_tongluoshao"] = 20,              ---铜锣烧
                    --以下是和枝江往事mod的兼容
                    ["goodies_bamboon"] = 10,               ---竹筒饭
                    ["goodies_carb"] = 10,                  ---蟹酿橙
                }

                local num = 0
                local food_base_prefab = food.nameoverride or food.prefab 

                ----- 靠prefab 定义血糖值
                if type(prefab_list_with_glu_value[food_base_prefab]) == "number" then
                    return prefab_list_with_glu_value[food_base_prefab]
                end

                if food:HasTag("honeyed") then
                    num = 10
                elseif cooking_ingredients[food_base_prefab] and cooking_ingredients[food_base_prefab].tags and cooking_ingredients[food_base_prefab].tags["sweetener"] then
                    num = 10
                elseif food.components.edible and food.components.edible.honeyvalue then
                    num = food.components.edible.honeyvalue
                elseif cooking_ingredients[food_base_prefab] and cooking_ingredients[food_base_prefab].tags and cooking_ingredients[food_base_prefab].tags["fruit"] then
                    num = 5
                end
                return num
            end
        --------------- VC 值
            local function GetVcByFood(food)
                local num = 0
                local food_base_prefab = food.nameoverride or food.prefab 
                -------------------------------------------------------------------
                local prefab_list_with_vc_value = {
                    ["tomato"] = 5,                                 --- 番茄
                    ["tomato_cooked"] = 5,                          --- 烤番茄
                    ["pomegranate"] = 10,                           --- 石榴
                    ["pomegranate_cooked"] = 10,                    --- 烤石榴
                    ["carrot"]  = 5,                                --- 胡萝卜
                    ["carrot_cooked"] = 5,                          --- 烤胡萝卜
                    -- ["berries"] = 10,                               --- 浆果
                    -- ["berries_cooked"] = 10,                        --- 烤浆果
                    -- ["berries_juicy"] = 10,                         --- 多汁浆果
                    ["dragonfruit"] = 10,                           --- 火龙果
                    ["dragonfruit_cooked"] = 10,                    --- 烤熟火龙果
                    ["fwd_in_pdt_food_mango_green"] = 20,           --- 青芒果
                    ["wormlight_lesser"] = 20,                      --- 小发光浆果
                    ["ratatouille"] = 30,                           --- 蔬菜杂烩
                    ["cave_fern"] = 10,                             --- 蕨类植物
                    ["hotchili"] = 20,                              --- 辣椒炒肉
                    --这里是和棱镜的兼容
                    ["pineananas"] = 10,                            --- 松萝
                    ["pineananas_cooked"] = 10,                     --- 烤松萝
                    ["dish_murmurananas"] = 30,                     --- 松萝咕咾肉
                    ["dish_sosweetjarkfruit"] = 40,                 --- 甜到裂开的松萝蜜
                    --以下是和海洋传说的兼容
                    ["sashimi"] = 30,                               ---柠檬鲈鱼片
                    ["lg_lemon_jelly"] = 30,                        ---冻柠蜜
                    ["lg_ning"] = 30,                               ---柠檬片
                    --以下是和山海密藏的兼容
                    ["fasam_cinnabar_fruit_stew_kangkang"] = 10,    ---朱果炖康康
                    ["fasam_osmanthus_cake"] = 20,                  ---桂花糕
                    ["fasam_osmanthus_tea"] = 30,                   ---桂花茶
                    --以下是和小穹人物mod的兼容
                    ["sora_aping"] = 30,                            ---阿瓶酱
                    ["sora_banhua"] = 30,                           ---花花沙拉
                    --以下是和枝江往事的兼容
                    ["goodies_rum"] = 20,                           ---海神朗姆
                    ["zhijiang_veggie_tree"] = 20,                  ---圣诞素
                }
                if prefab_list_with_vc_value[food_base_prefab] then
                    num = prefab_list_with_vc_value[food_base_prefab]
                end
                return num
            end

        --------------- 特殊食物特殊事件
            local function special_event_by_food(inst,food)
                local food_base_prefab = food.nameoverride or food.prefab  --- --- 得到加料食物的基础名字
                local food_events_by_prefab = {
                        ["taffy"] = function(inst)      --- 太妃糖移除蜜蜂毒
                            if inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_bee_poison") then
                                inst.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_bee_poison")
                                inst.components.fwd_in_pdt_wellness:DoDelta_Poison(-25)
                                if inst.components.sanity then
                                    inst.components.sanity:DoDelta(-10)
                                end
                                if inst.components.health and inst.components.health.currenthealth > 10 then
                                    inst.components.health:DoDelta(-10,nil,"taffy")
                                end
                            end
                        end,
                        ["frogglebunwich"] = function(inst)      --- 蛙腿三明治 移除青蛙毒
                            if inst.components.fwd_in_pdt_wellness:Get_Debuff("fwd_in_pdt_welness_frog_poison") then
                                inst.components.fwd_in_pdt_wellness:Remove_Debuff("fwd_in_pdt_welness_frog_poison")
                                inst.components.fwd_in_pdt_wellness:DoDelta_Poison(-25)
                                if inst.components.sanity then
                                    inst.components.sanity:DoDelta(-10)
                                end
                                if inst.components.health and inst.components.health.currenthealth > 10 then
                                    inst.components.health:DoDelta(-10,nil,"frogglebunwich")
                                end
                            end
                        end,
                }
                if food_events_by_prefab[food_base_prefab] then
                    food_events_by_prefab[food_base_prefab](inst)
                end
            end
        ---------------- 监听玩家吃食物的事件
            inst:ListenForEvent("oneat",function(inst,_table)
                if not (_table and _table.food) then
                    return
                end

                local feeder = _table.feeder        --- 其他人喂食
                local food = _table.food            --- 食物 inst
                local food_base_prefab = food.nameoverride or food.prefab  --- --- 得到加料食物的基础名字

                ----------- 血糖值
                    local glu_delta_num = GetGluByFood(food)
                    if glu_delta_num ~= 0 then
                        inst.components.fwd_in_pdt_wellness:DoDelta_Glucose(glu_delta_num)
                    end
                ----------- vc 值
                    local vc_delta_num = GetVcByFood(food)
                    if vc_delta_num ~= 0 then
                        inst.components.fwd_in_pdt_wellness:External_DoDelta_Vitamin_C(vc_delta_num)
                    end
                ----------- 特殊事件
                    special_event_by_food(inst, food)
                ---------- 刷新一下
                    inst.components.fwd_in_pdt_wellness:ForceRefresh()
            end)





    ----------------------------------------------------------------------------------------------------------
    -----------  季节变换后触发的事件    
                ---  只会得一次
            inst:WatchWorldState("cycles",function()
                inst:DoTaskInTime(math.random(100),function()
                    if TheWorld.state.isspring then
                        --- 春天的前两天
                        if TheWorld.state.seasonprogress <= 2 then
                                if math.random(1000) < 200 then -- 20% 得发烧
                                        if not inst.components.fwd_in_pdt_wellness:Get("fever_block") then
                                                    inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_fever")
                                                    inst.components.fwd_in_pdt_wellness:Set("fever_block",true)
                                        end
                                end
                                if math.random(1000) < 200 then -- 20% 得咳嗽
                                    if not inst.components.fwd_in_pdt_wellness:Get("cough_block") then
                                                    inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_cough")
                                                    inst.components.fwd_in_pdt_wellness:Set("cough_block",true)
                                    end
                                end
                        else
                            inst.components.fwd_in_pdt_wellness:Set("fever_block",false)
                            inst.components.fwd_in_pdt_wellness:Set("cough_block",false)
                        end

                    elseif TheWorld.state.iswinter then
                        --- 冬天的前两天
                        if TheWorld.state.seasonprogress <= 2 then
                                if math.random(1000) < 200 then -- 20% 得发烧
                                    if not inst.components.fwd_in_pdt_wellness:Get("fever_block") then                                    
                                                inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_fever")
                                                inst.components.fwd_in_pdt_wellness:Set("fever_block",true)
                                    end
                                end
                                if math.random(1000) < 200 then -- 20% 得咳嗽
                                    if not inst.components.fwd_in_pdt_wellness:Get("cough_block") then
                                                inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_cough")
                                                inst.components.fwd_in_pdt_wellness:Set("cough_block",true)
                                    end
                                end
                        else
                            inst.components.fwd_in_pdt_wellness:Set("fever_block",false)
                            inst.components.fwd_in_pdt_wellness:Set("cough_block",false)
                        end

                    end
                end)
            end)
    ----------------------------------------------------------------------------------------------------------
    ----------- 官方道具物品使用
            
    ----------------------------------------------------------------------------------------------------------
    ----------- 死亡后清除中毒值，和所有毒
            inst:ListenForEvent("death",function()
                local poisons = {
                    ["fwd_in_pdt_welness_snake_poison"] = true,
                    ["fwd_in_pdt_welness_frog_poison"] = true,
                    ["fwd_in_pdt_welness_spider_poison"] = true,
                    ["fwd_in_pdt_welness_bee_poison"] = true,
                }
                for poison_prefab, v in pairs(poisons) do
                    inst.components.fwd_in_pdt_wellness:Remove_Debuff(poison_prefab)
                end
                inst.components.fwd_in_pdt_wellness:SetCurrent_Poison(0)
            end)
    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------
end)