--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 芒果树
--[[
    动画 
        step_1
        step_1_to_2
        step_2
        step_2_to_3
        step_3
        step_4
        step_5
        item
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_plant_mango_tree"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_mango_tree.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --  采收动作
        local function add_workable_action(inst)
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
            inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
                return true
            end)
            inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
                if not TheWorld.ismastersim then
                    return
                end
                -- doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_paddy_rice_seed",rice_num)
                -- inst:Remove()
                return true
            end)
            inst.components.fwd_in_pdt_com_workable:SetPreActionFn(function(inst,doer)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
            end)
            inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_special_pick")
            inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_plant_mango_tree",STRINGS.ACTIONS.PICK.HARVEST)

        end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 根据阶段切状态
    local function chop_tree(inst, chopper, chopsleft, numchops)
        if not (chopper ~= nil and chopper:HasTag("playerghost")) then
            inst.SoundEmitter:PlaySound(
                chopper ~= nil and chopper:HasTag("beaver") and
                "dontstarve/characters/woodie/beaver_chop_tree" or
                "dontstarve/wilson/use_axe_tree"
            )
        end
    end
    local function change_type_by_step(inst,step)
        --[[
            step 1 : 铲子铲
            step 2、3、4、5 ：斧头砍
            step 4、5 砍后掉落对应芒果
        ]]--
        -- inst.components.fwd_in_pdt_data:Set("step",step)
        if step == 1 then
            ---------------------------------------------------------------------------------------------
                inst:PushEvent("mouseover_text")                                    --- 名字颜色
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)          --- 采摘交互        
                inst.components.workable:SetWorkAction(ACTIONS.DIG)                 --- 挖掘
                inst.components.workable:SetWorkLeft(1)
                inst.components.workable:SetOnFinishCallback(function()
                    inst.components.lootdropper:SetLoot({"twigs"})
                    inst.components.lootdropper:DropLoot()
                    inst:Remove()
                end)
                return
            ---------------------------------------------------------------------------------------------
        elseif step == 2 then
            
            ---------------------------------------------------------------------------------------------
                inst:PushEvent("mouseover_text")                                    --- 名字颜色
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)          --- 采摘交互  
                inst.components.workable:SetWorkAction(ACTIONS.CHOP)                --- 砍伐
                inst.components.workable:SetWorkLeft(5)
                inst.components.workable:SetOnWorkCallback(chop_tree)
                inst.components.workable:SetOnFinishCallback(function()
                    inst.components.lootdropper:SetLoot({"twigs","log"})
                    inst.components.lootdropper:DropLoot()
                    inst:Remove()
                end)
                return
            ---------------------------------------------------------------------------------------------
        
        elseif step == 3 then
            
            ---------------------------------------------------------------------------------------------
                inst:PushEvent("mouseover_text")                                    --- 名字颜色
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)          --- 采摘交互
                inst.components.workable:SetWorkAction(ACTIONS.CHOP)                --- 砍伐
                inst.components.workable:SetWorkLeft(10)
                inst.components.workable:SetOnWorkCallback(chop_tree)
                inst.components.workable:SetOnFinishCallback(function()
                    inst.components.lootdropper:SetLoot({"log","log","log"})
                    inst.components.lootdropper:DropLoot()
                    inst:Remove()
                end)
                return
            ---------------------------------------------------------------------------------------------
        
        elseif step == 4 then
            
            ---------------------------------------------------------------------------------------------
            --- 绿芒果
                inst:PushEvent("mouseover_text","GREEN")                            --- 名字颜色
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)           --- 采摘交互
                inst.components.workable:SetWorkAction(ACTIONS.CHOP)                --- 砍伐
                inst.components.workable:SetWorkLeft(10)
                inst.components.workable:SetOnWorkCallback(chop_tree)
                inst.components.workable:SetOnFinishCallback(function()
                    inst.components.lootdropper:SetLoot({"log","log","log","fwd_in_pdt_food_mango_green"})
                    inst.components.lootdropper:DropLoot()
                    inst:Remove()
                end)
                inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
                    if not TheWorld.ismastersim then
                        return
                    end
                    doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_food_mango_green",math.random(4))
                    inst.components.growable:SetStage(3)  -- 采摘后返回 第三阶段
                    inst.components.growable:StartGrowing()
                    return true
                end)
                return
            ---------------------------------------------------------------------------------------------
        elseif step == 5 then
            
            ---------------------------------------------------------------------------------------------
            --- 绿芒果
                inst:PushEvent("mouseover_text","YELLOW")                           --- 名字颜色
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)           --- 采摘交互
                inst.components.workable:SetWorkAction(ACTIONS.CHOP)                --- 砍伐
                inst.components.workable:SetWorkLeft(10)
                inst.components.workable:SetOnWorkCallback(chop_tree)
                inst.components.workable:SetOnFinishCallback(function()
                    local loots = {"log","log","log","fwd_in_pdt_food_mango"}
                    if math.random(1000) <= 200 then    --- 20% 得芽穂
                        table.insert(loots,"fwd_in_pdt_plant_mango_tree_item")
                    end
                    inst.components.lootdropper:SetLoot(loots)
                    inst.components.lootdropper:DropLoot()
                    inst:Remove()
                end)
                inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
                    if not TheWorld.ismastersim then
                        return
                    end
                    if math.random(1000) <= 100 then    --- 10% 概率得芽穂
                        doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_mango_tree_item",math.random(2))
                    end
                    doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_food_mango",math.random(6))
                    inst.components.growable:SetStage(3)  -- 采摘后返回 第三阶段
                    inst.components.growable:StartGrowing()
                    return true
                end)
                return
            ---------------------------------------------------------------------------------------------

        end

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_plant_mango_tree.tex")

    inst.AnimState:SetBank("fwd_in_pdt_plant_mango_tree")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_mango_tree")
    inst.AnimState:PlayAnimation("step_1",true)

    MakeObstaclePhysics(inst, .25)

    inst:AddTag("plant")
    inst:AddTag("silviculture") -- for silviculture book
    inst:AddTag("lunarplant_target")


    inst.entity:SetPristine()
    ------------------------------------------------------------------------------------
    --- 采收
        add_workable_action(inst)
    ------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
        inst:AddComponent("fwd_in_pdt_data")
        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")
    ------------------------------------------
    --- 可以挖掘、砍伐
        inst:AddComponent("workable")
        -- inst.components.workable:SetWorkAction(ACTIONS.DIG)
        -- inst.components.workable:SetOnFinishCallback(function()
        --     if inst.components.growable:GetStage() == 3 then
        --         inst.components.lootdropper:SetLoot({"fwd_in_pdt_material_aster_tataricus_l_f"})
        --     end
        --     inst.components.lootdropper:DropLoot()
        --     inst:Remove()
        -- end)
        -- inst.components.workable:SetWorkLeft(1)
    ------------------------------------------
    --- 种植
        inst:AddComponent("growable")
        local function grow_time_by_step(inst,step) 
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                return 10
            end
            return 10*TUNING.TOTAL_DAY_TIME
        end
        ---------------------
        --[[ 
            【笔记】
            fn 先执行
            growfn 则在 fn 之后
            growable:SetStage  执行的是 fn ,不会执行 growfn
        ]]--
        inst.components.growable.stages = {
            {
                name = "step1",     --- 阶段1  刚种下的时候
                time = function(inst) return grow_time_by_step(inst,1) end,
                fn = function(inst)                                                 -- SetStage 的时候执行
                    inst.AnimState:PlayAnimation("step_1") 
                    change_type_by_step(inst,1)
                end,      
                growfn = nil,                                                        -- DoGrowth 的时候执行（时间到了）
            },
            {
                name = "step2",     --- 阶段2
                time = function(inst) return grow_time_by_step(inst,2) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_2",true)
                    change_type_by_step(inst,2)
                    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
                end,
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_1_to_2")
                    inst.AnimState:PushAnimation("step_2",true)
                end,
            },
            {   --- num 3                    ---
                name = "step3  no mango",    --- 没芒果阶段
                time = function(inst) return grow_time_by_step(inst,3) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_3",true)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    change_type_by_step(inst,3)
                end,         
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_2_to_3")
                    inst.AnimState:PushAnimation("step_3",true)
                    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
                    inst:DoTaskInTime(0.6,function()
                        inst.AnimState:SetTime(math.random(5000)/1000)                        
                    end)
                end,
            },
            {   --- num 4
                name = "step4",    ---  绿芒果阶段
                time = function(inst) return grow_time_by_step(inst,4) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_4",true)
                    change_type_by_step(inst,4)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
                end,         
                growfn = nil,
            },
            {   --- num 5
                name = "step4",    ---   黄芒果阶段
                time = function(inst) return grow_time_by_step(inst,5) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_5",true)
                    change_type_by_step(inst,5)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
                end,         
                growfn = fn,
            },
        }

        inst.components.growable:SetStage(TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 1 or 3)
        inst.components.growable.loopstages = false
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()
        inst.components.growable.magicgrowable = true

        inst:AddComponent("simplemagicgrower")  --- 魔法书
        inst.components.simplemagicgrower:SetLastStage(#inst.components.growable.stages)
        inst:ListenForEvent("_OnPlanted",function(_,_table)
            inst.components.growable:SetStage(1)
            if _table and _table.pt then
                inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
            end
        end)
    ------------------------------------------
    --- 可燃
        MakeMediumBurnable(inst)    
    ----------------------------------------
    --- 冬天
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:ShowSymbol("snow")   --- 图层文件夹
            else
                inst.AnimState:HideSymbol("snow")   --- 图层文件夹
            end
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        inst:DoTaskInTime(0,snow_init)
    ----------------------------------------
    inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
    inst:ListenForEvent("mouseover_text",function(inst,str)
        if str == "GREEN" then
            inst.components.fwd_in_pdt_func:Mouseover_SetColour(0/255,255/255,0/255,255/255)
        elseif str == "YELLOW" then
            inst.components.fwd_in_pdt_func:Mouseover_SetColour(255/255,200/255,0/255,255/255)
        else
            inst.components.fwd_in_pdt_func:Mouseover_SetColour(1,1,1,1)            
        end

    end)
    ------------------------------------------
    --- 季节检查和限定生长
        -- inst:ListenForEvent("season_check",function()
        --     -- autumn , winter , spring , summer
        --     if TheWorld.state.season == "winter" or TheWorld.state.season == "spring" then
        --         inst.components.growable:StartGrowing()
        --     else
        --         inst.components.growable:StopGrowing()
        --     end
        -- end)
        -- inst:DoTaskInTime(0.1,function()
        --     inst:PushEvent("season_check")
        -- end)
        -- inst:WatchWorldState("season", function()
        --     inst:DoTaskInTime(0.1,function()
        --         inst:PushEvent("season_check")
        --     end)
        -- end)
    ------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_plant_mango_tree", fn, assets)