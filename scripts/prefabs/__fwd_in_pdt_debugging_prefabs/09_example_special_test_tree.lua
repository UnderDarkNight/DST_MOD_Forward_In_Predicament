

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
    --------------------------------------------------------------------------------------------------------------------  -------------------------------------------------------------------------------------------------------------------- 
    --- 交互组件（采集）
        inst:AddComponent("fwd_in_pdt_com_special_workable")
        -------------------------------------------------
        -- 预动作
            inst.components.fwd_in_pdt_com_special_workable:AddPreActionFn("give",function(inst,doer)
                print("pre action give")
            end)
            inst.components.fwd_in_pdt_com_special_workable:AddPreActionFn("dolongaction",function(inst,doer)
                print("pre action dolongaction")
            end)
            inst.components.fwd_in_pdt_com_special_workable:SetPreActionIndex("give")
        -------------------------------------------------
        --- 测试能否执行动作
            inst.components.fwd_in_pdt_com_special_workable:AddTestFn("give",function(inst,doer,right_click)       -- 添加
                return true
            end)
            inst.components.fwd_in_pdt_com_special_workable:AddTestFn("dolongaction",function(inst,doer,right_click)   -- 添加
                return true
            end)
            inst.components.fwd_in_pdt_com_special_workable:SetTestIndex("give")      -- 设置为

        -------------------------------------------------
        --- 动作执行
            inst.components.fwd_in_pdt_com_special_workable:AddOnWorkFn("dolongaction",function(inst,doer)        --- 添加
                if not TheWorld.ismastersim then
                    return false
                end 
                print("on work  dolongaction")
                inst.components.fwd_in_pdt_com_special_workable:SetSGAction("give")
                inst.components.fwd_in_pdt_com_special_workable:SetOnWorkIndex("give")
                inst.components.fwd_in_pdt_com_special_workable:SetActionDisplayStrByIndex("give")            --- 设置为
                inst.components.fwd_in_pdt_com_special_workable:SetPreActionIndex("give")
                
                inst.components.fwd_in_pdt_com_special_workable:SetCanWorlk(false)
                inst:DoTaskInTime(5,function()
                    inst.components.fwd_in_pdt_com_special_workable:SetCanWorlk(true)            
                end)
                return true
            end)
            inst.components.fwd_in_pdt_com_special_workable:AddOnWorkFn("give",function(inst,doer)                --- 添加
                if not TheWorld.ismastersim then
                    return false
                end 
                print("on work  give")
                inst.components.fwd_in_pdt_com_special_workable:SetCanWorlk(false)
                inst:DoTaskInTime(5,function()
                    inst.components.fwd_in_pdt_com_special_workable:SetCanWorlk(true)            
                end)
                inst.components.fwd_in_pdt_com_special_workable:SetSGAction("dolongaction")
                inst.components.fwd_in_pdt_com_special_workable:SetOnWorkIndex("dolongaction")
                inst.components.fwd_in_pdt_com_special_workable:SetActionDisplayStrByIndex("dolongaction")            --- 设置为
                inst.components.fwd_in_pdt_com_special_workable:SetPreActionIndex("dolongaction")

                return true
            end)
            inst.components.fwd_in_pdt_com_special_workable:SetOnWorkIndex("give")                                --- 设置为

        -------------------------------------------------
        --- 配置 角色运行的 sg ，来自 SGWilson.lua
            inst.components.fwd_in_pdt_com_special_workable:AddSGAction("give")           --- 添加
            inst.components.fwd_in_pdt_com_special_workable:AddSGAction("dolongaction")   --- 添加
            inst.components.fwd_in_pdt_com_special_workable:SetSGAction("give")      --- 设置为

        -------------------------------------------------
        --- 配置显示的文本
            inst.components.fwd_in_pdt_com_special_workable:AddActionDisplayStr("give","给")              --- 添加
            inst.components.fwd_in_pdt_com_special_workable:AddActionDisplayStr("dolongaction","做")      --- 添加
            inst.components.fwd_in_pdt_com_special_workable:SetActionDisplayStrByIndex("give")            --- 设置为
    --------------------------------------------------------------------------------------------------------------------  -------------------------------------------------------------------------------------------------------------------- 
    ---- 物品接受组件
    inst:AddComponent("fwd_in_pdt_com_special_acceptable")
    -------------------------------------------------
    --- 预动作
        inst.components.fwd_in_pdt_com_special_acceptable:AddPreActionFn("give",function(inst,item,doer)
            print("fwd_in_pdt_com_special_acceptable  pre action  give",item,doer)
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:AddPreActionFn("dolongaction",function(inst,item,doer)
            print("fwd_in_pdt_com_special_acceptable  pre action  dolongaction",item,doer)
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:SetPreActionIndex("give")
    -------------------------------------------------
    --- test 函数
        inst.components.fwd_in_pdt_com_special_acceptable:AddTestFn("give",function(inst,item,doer,right_click)           --- 添加
            if item and item.prefab == "seeds" then
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:AddTestFn("dolongaction",function(inst,item,doer,right_click)   --- 添加
            if item and item.prefab == "poop" then
                return true
            end
            return false
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:SetTestIndex("give")        -- 设置

    -------------------------------------------------
    --- 物品接受执行函数
        inst.components.fwd_in_pdt_com_special_acceptable:AddOnAcceptFn("give",function(inst,item,doer)       --- 添加
            if not TheWorld.ismastersim then
                return
            end
            if item then
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
            end
            inst.components.fwd_in_pdt_com_special_acceptable:SetTestIndex("dolongaction")                    --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetSGAction("dolongaction")                     --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetOnAcceptIndex("dolongaction")                --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetActionDisplayStrByIndex("test_fertilize")    --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetPreActionIndex("dolongaction")

            inst.components.fwd_in_pdt_com_special_acceptable:SetCanAccept(false)
            inst:DoTaskInTime(5,function()
                inst.components.fwd_in_pdt_com_special_acceptable:SetCanAccept(true)                
            end)

            print("on accept fn : give")
            return true
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:AddOnAcceptFn("dolongaction",function(inst,item,doer)    --- 添加
            if not TheWorld.ismastersim then
                return
            end
            if item then
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
            end

            inst.components.fwd_in_pdt_com_special_acceptable:SetTestIndex("give")                    --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetSGAction("give")                     --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetOnAcceptIndex("give")                --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetActionDisplayStrByIndex("test_give") --- 设置
            inst.components.fwd_in_pdt_com_special_acceptable:SetPreActionIndex("give")

            inst.components.fwd_in_pdt_com_special_acceptable:SetCanAccept(false)
            inst:DoTaskInTime(5,function()
                inst.components.fwd_in_pdt_com_special_acceptable:SetCanAccept(true)                
            end)
            
            print("on accept fn : dolongaction")
            return true
        end)
        inst.components.fwd_in_pdt_com_special_acceptable:SetOnAcceptIndex("give")        -- 设置

    -------------------------------------------------
    --- 配置动作 sg ，来自 SGWilson.lua
        inst.components.fwd_in_pdt_com_special_acceptable:AddSGAction("give")     -- 添加
        inst.components.fwd_in_pdt_com_special_acceptable:AddSGAction("dolongaction")     -- 添加
        inst.components.fwd_in_pdt_com_special_acceptable:SetSGAction("give")     -- 设置
    
    -------------------------------------------------
    --- 配置动作显示的文本，注意index避让
        inst.components.fwd_in_pdt_com_special_acceptable:AddActionDisplayStr("test_give","给给给给给给给")           --- 设置
        inst.components.fwd_in_pdt_com_special_acceptable:AddActionDisplayStr("test_fertilize","施肥  施肥  施肥")    --- 设置
        inst.components.fwd_in_pdt_com_special_acceptable:SetActionDisplayStrByIndex("test_give")                    --- 设置
    
    --------------------------------------------------------------------------------------------------------------------  -------------------------------------------------------------------------------------------------------------------- 

    if not TheWorld.ismastersim then
        return inst
    end    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    -- inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容

  
    -------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_example_special_test_tree", fn)