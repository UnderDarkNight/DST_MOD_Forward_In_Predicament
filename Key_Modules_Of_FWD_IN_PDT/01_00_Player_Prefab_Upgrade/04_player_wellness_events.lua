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
                        if math.random(100) <= 10 then
                            inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_bee_poison")                        
                        end
                    end,


                }

                local events_fn_by_tag = {      -------- 靠Tag 执行的事件


                    ["fwd_in_pdt_poison_frog"] = function()     ---- 毒青蛙
                        inst.components.fwd_in_pdt_wellness:Add_Debuff("fwd_in_pdt_welness_frog_poison")                    
                    end,
                    ["spider"] = function()    
                        --[[
                            被除了一级蜘蛛之外的蜘蛛攻击50%中毒
                        ]]--
                        if attacker.prefab == "spider" then
                            return
                        end
                        if math.random(100) < 50 then
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
        inst:ListenForEvent("oneat",function(inst,_table)
            if not (_table and _table.food) then
                return
            end

            local feeder = _table.feeder        --- 其他人喂食
            local food = _table.food            --- 食物 inst
            local food_base_prefab = food.nameoverride or food.prefab  --- --- 得到加料食物的基础名字


            


        end)





    ----------------------------------------------------------------------------------------------------------
    -----------  吃对应的东西后执行的事件

    ----------------------------------------------------------------------------------------------------------
end)