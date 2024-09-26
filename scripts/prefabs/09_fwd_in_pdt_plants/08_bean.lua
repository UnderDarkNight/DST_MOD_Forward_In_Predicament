--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 大豆
--[[
    施肥后才能长成巨大化。
    5 阶段为 最大化阶段
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_plant_bean"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_bean.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 使用官方的 pickable 组件

    local function add_pickable_action(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("pickable")
        ------------------------
            inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
            -- inst.components.pickable:SetOnPickedFn(function(inst,doer)  --- 被玩家采集后执行
            --     local rice_num = 5
            --     if inst.components.fwd_in_pdt_data:Get("fertilized") then
            --         rice_num = 10
            --     end
            --     doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")            

            --     doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_bean_seed",rice_num)
            --     inst:Remove()
            -- end)
        ------------------------
        ---- 自己封装个API 方便一些
            function inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(flag)
                if flag == true then
                    self.cycles_left = 0
                else
                    self.cycles_left = 10000
                end
                self.max_cycles = 10000
            end
        ------------------------
        --- 施肥的时候执行
            inst.components.pickable.Fertilize___old_temp = inst.components.pickable.Fertilize
            function inst.components.pickable:Fertilize(fertilizer, doer)
                local ret = self:Fertilize___old_temp(fertilizer, doer)
                if ret then
                    inst.components.fwd_in_pdt_data:Set("fertilized",true)
                    inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(false)
                end
                inst:PushEvent("fertilize_mouseover")
                return ret
            end


    end    
    local function fertilize_check_by_step(inst,step)
        if inst.components.fwd_in_pdt_data:Get("fertilized") or step >= 4 then
            inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(false)
        else
            inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(true)
        end
        inst:PushEvent("fertilize_mouseover")
    end

    local function change_type_by_step(inst,step)
        if step == 1 then
            --------------------------------------------------------------------
            --- 阶段 1
                inst.components.pickable.canbepicked = false
                fertilize_check_by_step(inst, 1)
                inst.components.workable:SetWorkAction(ACTIONS.DIG)
                inst.components.workable:SetOnFinishCallback(inst.Remove)
                inst.components.workable:SetWorkLeft(1)
            --------------------------------------------------------------------

        elseif step == 2 then
            --------------------------------------------------------------------
            --- 阶段 2
                inst.components.pickable.canbepicked = false
                fertilize_check_by_step(inst, 2)
                inst.components.workable:SetWorkAction(ACTIONS.DIG)
                inst.components.workable:SetOnFinishCallback(inst.Remove)
                inst.components.workable:SetWorkLeft(1)
            --------------------------------------------------------------------


        elseif step == 3 then
            --------------------------------------------------------------------
            --- 阶段 3
                inst.components.pickable.canbepicked = false
                fertilize_check_by_step(inst, 3)
                inst.components.workable:SetWorkAction(ACTIONS.DIG)
                inst.components.workable:SetOnFinishCallback(inst.Remove)
                inst.components.workable:SetWorkLeft(1)
            --------------------------------------------------------------------
        elseif step == 4 then
            --------------------------------------------------------------------
            --- 阶段 4
                inst.components.pickable.canbepicked = true
                fertilize_check_by_step(inst, 4)
                ---- 玩家挖掘
                    inst.components.workable:SetWorkAction(ACTIONS.DIG)
                    inst.components.workable:SetOnFinishCallback(function()
                        local loots = {"fwd_in_pdt_food_soybeans"}
                        
                            table.insert(loots,"fwd_in_pdt_food_soybeans")
                            table.insert(loots,"fwd_in_pdt_food_soybeans")
                            table.insert(loots,"fwd_in_pdt_food_soybeans")

                            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
                            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
                            table.insert(loots,"fwd_in_pdt_plant_bean_seed")
                            table.insert(loots,"fwd_in_pdt_plant_bean_seed")

                        
                        inst.components.lootdropper:SetLoot(loots)
                        inst.components.lootdropper:DropLoot()
                        inst:Remove()
                    end)
                    inst.components.workable:SetWorkLeft(1)
                --- 如果没施肥，则停止生长
                    inst:DoTaskInTime(0.5,function()
                        if not inst.components.fwd_in_pdt_data:Get("fertilized") then
                            inst.components.growable:StopGrowing()
                            -- print("stop growing")
                        else
                            -- print("continue growing")
                        end
                    end)
                    
                --- 玩家采集
                    inst.components.pickable:SetOnPickedFn(function(inst,doer)  --- 被玩家采集后执行

                        local item_prefab = "fwd_in_pdt_food_soybeans"
                        local seed_prefab = "fwd_in_pdt_plant_bean_seed"
                        if inst.components.fwd_in_pdt_data:Get("fertilized") then
                                    if doer:HasTag("player") then
                                        doer.components.fwd_in_pdt_func:GiveItemByPrefab(item_prefab,4)
                                        doer.components.fwd_in_pdt_func:GiveItemByPrefab(seed_prefab,4)
                                        doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")        

                                    else
                                        TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                                                target = inst,
                                                name = item_prefab,
                                                num = 4,    -- default
                                                range = 2, -- default
                                                height = 3,-- default
                                        })
                                        TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                                                target = inst,
                                                name = seed_prefab,
                                                num = 4,    -- default
                                                range = 2, -- default
                                                height = 3,-- default
                                        })
                                    end
                        else        -- 没施肥的话
                            if doer:HasTag("player") then
                                    doer.components.fwd_in_pdt_func:GiveItemByPrefab(item_prefab,1)
                                    
                                    -- doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")        

                                else
                                        TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                                                target = inst,
                                                name = item_prefab,
                                                num = 1,    -- default
                                                range = 2, -- default
                                                height = 3,-- default
                                        })
                                end
                        end
                        inst:Remove()
                    end)
            --------------------------------------------------------------------
        elseif step == 5 then
            --------------------------------------------------------------------
                --- 阶段 5
                inst.components.pickable.canbepicked = true
                fertilize_check_by_step(inst, 5)
                if inst.components.workable ~= nil then
                    inst:RemoveComponent("workable")
                end
                --- 玩家采集
                    inst.components.pickable:SetOnPickedFn(function(inst,doer)  --- 被玩家采集后执行
                        if doer:HasTag("player") then
                            doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_equipment_huge_soybean",1)
                            if math.random(100) <= 30 then
                                doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_bean_seed",1)
                            end
                            doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                        else
                           SpawnPrefab("fwd_in_pdt_equipment_huge_soybean").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
                        end

                        inst:Remove()
                    end)
            --------------------------------------------------------------------
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

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_plant_bean.tex")

    inst.AnimState:SetBank("fwd_in_pdt_plant_bean")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_bean")
    inst.AnimState:PlayAnimation("step_1",true)
    -- local scale = 1.3
    -- inst.AnimState:SetScale(scale,scale,scale)
    inst:AddTag("plant")
    -- inst:AddTag("silviculture") -- for silviculture book
    -- inst:AddTag("lunarplant_target")


    inst.entity:SetPristine()

    ------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
        inst:AddComponent("fwd_in_pdt_data")
        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")
    ------------------------------------------
    ------------------------------------------------------------------------------------
    --- 采收
        add_pickable_action(inst)
    ------------------------------------------------------------------------------------
    --- 可以挖掘
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(function()
            inst:Remove()
        end)
        inst.components.workable:SetWorkLeft(1)
    ------------------------------------------
    --- 种植
        inst:AddComponent("growable")
        local function grow_time_by_step(inst,step) 
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                return 10
            end
            return 3*TUNING.TOTAL_DAY_TIME
        end
        inst.components.growable.stages = {
            {
                name = "step1",     --- 阶段1  刚种下的时候
                time = function(inst) return grow_time_by_step(inst,1) end,
                fn = function(inst)                                                 -- SetStage 的时候执行
                    inst.AnimState:PlayAnimation("step_1") 
                    change_type_by_step(inst,1)
                end,      
                growfn = function(inst)
                    
                end,                                                        -- DoGrowth 的时候执行（时间到了）
            },
            {
                name = "step2",     --- 阶段2
                time = function(inst) return grow_time_by_step(inst,2) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_2",true)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    change_type_by_step(inst,2)

                end,
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_1_to_2")
                    inst.AnimState:PushAnimation("step_2",true)
                    inst:DoTaskInTime(0.6,function()
                        inst.AnimState:SetTime(math.random(5000)/1000)                        
                    end)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
            {
                name = "step3",    --- 阶段3
                time = function(inst) return grow_time_by_step(inst,3) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_3",true)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    change_type_by_step(inst,3)
                end,         
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_2_to_3")
                    inst.AnimState:PushAnimation("step_3",true)
                    inst:DoTaskInTime(0.6,function()
                        inst.AnimState:SetTime(math.random(5000)/1000)                        
                    end)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
            {
                name = "step4",  --- 可采摘阶段
                time = function(inst) return grow_time_by_step(inst,4) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_4",true)
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    change_type_by_step(inst,4)
                end, 
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_3_to_4")
                    inst.AnimState:PushAnimation("step_4",true)
                    inst:DoTaskInTime(0.6,function()
                        inst.AnimState:SetTime(math.random(5000)/1000)                        
                    end)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
            {
                name = "step5",  --- 巨大化阶段
                time = function(inst) return grow_time_by_step(inst,5) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step_5")
                    inst.AnimState:SetTime(math.random(5000)/1000)
                    change_type_by_step(inst,5)                    
                end, 
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step_4_to_5")
                    inst.AnimState:PushAnimation("step_5")
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
        }

        inst.components.growable:SetStage(1)
        inst.components.growable.loopstages = false
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()
        inst.components.growable.magicgrowable = false

        -- inst:AddComponent("simplemagicgrower")  --- 魔法书
        -- inst.components.simplemagicgrower:SetLastStage(#inst.components.growable.stages)
        inst:ListenForEvent("_OnPlanted",function(_,_table)
            inst.components.growable:SetStage(1)
            if _table and _table.pt then
                inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
            end
        end)
    ------------------------------------------
    --- 可燃
        MakeMediumBurnable(inst)    
    ------------------------------------------
    -- --- 冬天
    --     local function snow_init(inst)
    --         if TheWorld.state.issnowcovered then
    --             local x,y,z  = inst.Transform:GetWorldPosition()
    --             inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    --             inst:Remove()
    --             SpawnPrefab("cutgrass").Transform:SetPosition(x,2, z)
    --         end
    --     end
    --     inst:WatchWorldState("issnowcovered", snow_init)
    --     inst:DoTaskInTime(0,snow_init)
    ------------------------------------------
    inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful")
    inst:ListenForEvent("fertilize_mouseover",function()
        if inst.components.fwd_in_pdt_data:Get("fertilized") then
            inst.components.fwd_in_pdt_func:Mouseover_SetColour(0/255,255/255,0/255,255/255)
        else
            inst.components.fwd_in_pdt_func:Mouseover_SetColour(1,1,1,1)            
        end
    end)
    ------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_plant_bean", fn, assets)