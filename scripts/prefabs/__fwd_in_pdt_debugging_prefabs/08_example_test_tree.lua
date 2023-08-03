

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, .5)



    inst.AnimState:SetBank("mushroom_light")
    inst.AnimState:SetBuild("mushroom_light")
    inst.AnimState:PlayAnimation("idle")

    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetLightOverride(0.4)

    inst:AddTag("fwd_in_pdt_test_tree")
    -- inst:AddTag("structure")
    -- inst:AddTag("npng_moom_jewelry_lamp")


    inst.entity:SetPristine()
    --------------------------------------------------------------------------------------------------------------------   
    --- 植物生长系统,server only
        if TheWorld.ismastersim  then
            inst:AddComponent("fwd_in_pdt_func"):Init("growable","mouserover_colourful")    --- 初始化植物生长组件（按天生长）
            local cmd_table = {
                [1] = {
                    test = function(days)
                        if days < 2 then
                            return true
                        end
                    end,
                    fn = function(inst,days,awake_flag,refresh_flag)
                        print("stage 1")                
                    end
                },
                [2] = {
                    test = function(days)
                        if days < 4 then
                            return true
                        end
                    end,
                    fn = function(inst,days,awake_flag,refresh_flag)
                        print("stage 2")                
                    end
                },
                [3] = {
                    test = function(days)
                        if days > 6 then
                            return true
                        end
                    end,
                    fn = function(inst,days,awake_flag,refresh_flag)
                        print("stage 3")
                    end
                },
        
            }    
            inst.components.fwd_in_pdt_func:Growable_Add_Stage_Fns(cmd_table)
        end
    --------------------------------------------------------------------------------------------------------------------
    --- 物品接受 server and cilent
        inst:AddComponent("fwd_in_pdt_com_acceptable")    --- 通用物品接受组件
        inst.components.fwd_in_pdt_com_acceptable:SetPreActionFn(function(inst,item,doer) 
            print("fwd_in_pdt_com_acceptable pre action",item,doer)
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
            -- print("fwd_in_pdt_com_acceptable:SetTestFn")
            if right_click and item and item.prefab == "poop" then
                return true
            else
                return false
            end
        end)
        inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)  ---- server only
            print(" fwd_in_pdt_com_acceptable  on accept")
            if not TheWorld.ismastersim then
                return false
            end
            if item then
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
            end
            if doer and doer.components.fwd_in_pdt_com_action_fail_reason then
                doer.components.fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str("5555555555555")
            end

            inst.components.fwd_in_pdt_com_acceptable:SetCanAccept(false)
            inst:DoTaskInTime(5,function()
                inst.components.fwd_in_pdt_com_acceptable:SetCanAccept(true)            
            end)

            return true,"test"
        end)

        inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStrByIndex("fertilize") --- 设置动作显示名字，这里已经提前注册文本index和内容了。
        inst.components.fwd_in_pdt_com_acceptable:SetSGAction("dolongaction") --- 设置执行动作 SGWilson 里面的
    --------------------------------------------------------------------------------------------------------------------
    --- 直接交互组件（采集）
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetPreActionFn(function(inst,doer)
            print("preaction",inst,doer)
        end)
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(doer,right_click)
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return false
            end 
            print("on work")

            -- if doer and doer.components.fwd_in_pdt_com_action_fail_reason then
            --     doer.components.fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str("666666666666")
            --     return false
            -- end
            if not inst._color_flag then
                inst._color_flag = not inst._color_flag
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(0,1,0)
                -- inst.components.fwd_in_pdt_com_workable:SetSGAction("dolongaction")
            else
                inst._color_flag = not inst._color_flag
                -- inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
                inst.components.fwd_in_pdt_func:Mouseover_SetColour(1,0,0)
            end

            inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
            inst:DoTaskInTime(5,function()
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)            
            end)
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetSGAction("give") --- 设置执行动作 SGWilson 里面的
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("TEST","采集采集采集")    --- 配置显示的文本，index 注意避让
    --------------------------------------------------------------------------------------------------------------------
    --- 失败原因说话 server only
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_com_action_fail_reason")
        inst.components.fwd_in_pdt_com_action_fail_reason:Add_Reason("test","正在测试")
    end
    --------------------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    -- inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容

    -- -------------------------------------------------------------------------------------------------
    -- -- inst:AddComponent("fwd_in_pdt_func"):Init("long_update")

    -- -- inst.components.fwd_in_pdt_func:Add_LongUpdate_Func(function(inst,dt)
    -- --     print("fwd_in_pdt_test_tree longupdate",dt)
    -- -- end)

    -- -- inst.components.fwd_in_pdt_func:Add_OnEntitySleep_Fn(function()
    -- --     print("fwd_in_pdt_test_tree sleep")
    -- -- end)
    -- -- inst.components.fwd_in_pdt_func:Add_OnEntityWake_Fn(function()
    -- --     print("fwd_in_pdt_test_tree wake")
    -- -- end)
    -- -------------------------------------------------------------------------------------------------
    -- inst:AddComponent("fwd_in_pdt_func"):Init("growable","rpc")
    
    -- -- inst.components.fwd_in_pdt_func:Growable_Add_Grow_Days_Fn(function(inst,days)
    -- --     print("fwd_in_pdt_test_tree",days)
    -- -- end)
    -- -------------------------------------------------------------------------------------------------
    -- local cmd_table = {
    --     [1] = {
    --         test = function(days)
    --             if days < 2 then
    --                 return true
    --             end
    --         end,
    --         fn = function(inst,days,awake_flag,refresh_flag)
    --             print("stage 1")                
    --         end
    --     },
    --     [2] = {
    --         test = function(days)
    --             if days < 4 then
    --                 return true
    --             end
    --         end,
    --         fn = function(inst,days,awake_flag,refresh_flag)
    --             print("stage 2")                
    --         end
    --     },
    --     [3] = {
    --         test = function(days)
    --             if days > 6 then
    --                 return true
    --             end
    --         end,
    --         fn = function(inst,days,awake_flag,refresh_flag)
    --             print("stage 3")
    --         end
    --     },

    -- }

    -- inst.components.fwd_in_pdt_func:Growable_Add_Stage_Fns(cmd_table)
    -- -- inst.components.fwd_in_pdt_func:Growable_CanBeFertilized(true)
    -- -- inst.components.fwd_in_pdt_func:Growable_Set_Fertilize_Fn(function(inst,item,doer)
    -- --     local num = inst.components.fwd_in_pdt_func:Add("FertilizeNum",1)
    -- --     if num > 5 then
    -- --         inst.components.fwd_in_pdt_func:Growable_CanBeFertilized(false)
    -- --     end
    -- --     return true
    -- -- end)
    -- -------------------------------------------------------------------------------------------------
    inst.components.fwd_in_pdt_func:Add_OnEntitySleep_Fn(function()
        print("fwd_in_pdt_test_tree sleep")
    end)
    inst.components.fwd_in_pdt_func:Add_OnEntityWake_Fn(function()
        print("fwd_in_pdt_test_tree wake")
    end)
    -------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_example_test_tree", fn)