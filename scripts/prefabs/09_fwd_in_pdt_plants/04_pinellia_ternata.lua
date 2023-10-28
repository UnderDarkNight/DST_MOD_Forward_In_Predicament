--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 半夏
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_plant_pinellia_ternata"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_pinellia_ternata.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 使用官方的 pickable 组件
    local function pickable_check_by_step(inst,step)
        if step == 3 then
            inst.components.pickable.canbepicked = true
        else
            inst.components.pickable.canbepicked = false
        end
    end
    local function add_workable_action(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("pickable")
        ------------------------
            inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
            inst.components.pickable:SetOnPickedFn(function(inst,doer)  --- 被玩家采集后执行

                if not inst.components.fwd_in_pdt_data:Get("fertilized") then   --- 没施肥
                    doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_material_pinellia_ternata",1)
                else    
                    --- 施肥给2个，概率得种子
                    doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_material_pinellia_ternata",2)
                    if math.random(1000) < 100 then
                        doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_pinellia_ternata_seed",math.random(3))
                    end
                end
                doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                inst:Remove()
            end)
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
        if inst.components.fwd_in_pdt_data:Get("fertilized") or step == 3 then
            inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(false)
        else
            inst.components.pickable:fwd_in_pdt_SetCanBeFertilized(true)  
        end
        inst:PushEvent("fertilize_mouseover")
    end
    local function add_fertilize_acceptable(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end
    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_plant_pinellia_ternata.tex")

    inst.AnimState:SetBank("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_pinellia_ternata")
    inst.AnimState:PlayAnimation("step1",true)

    inst:AddTag("plant")
    inst:AddTag("silviculture") -- for silviculture book
    inst:AddTag("lunarplant_target")


    inst.entity:SetPristine()
    ------------------------------------------------------------------------------------
    --- 采收
        add_workable_action(inst)
    ------------------------------------------------------------------------------------
    --- 施肥
        add_fertilize_acceptable(inst)
    ------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
        inst:AddComponent("fwd_in_pdt_data")
        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")
    ------------------------------------------
    --- 可以挖掘
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(function()
            if inst.components.growable:GetStage() == 3 then
                inst.components.lootdropper:SetLoot({"fwd_in_pdt_material_pinellia_ternata"})
            end
            inst.components.lootdropper:DropLoot()
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
            return 2*TUNING.TOTAL_DAY_TIME
        end
        inst.components.growable.stages = {
            {
                name = "step1",     --- 阶段1  刚种下的时候
                time = function(inst) return grow_time_by_step(inst,1) end,
                fn = function(inst)                                                 -- SetStage 的时候执行
                    inst.AnimState:PlayAnimation("step1") 
                    fertilize_check_by_step(inst,1)
                    pickable_check_by_step(inst,1)
                    inst:PushEvent("season_check")
                end,      
                growfn = function(inst)
                    
                end,                                                        -- DoGrowth 的时候执行（时间到了）
            },
            {
                name = "step2",     --- 阶段2
                time = function(inst) return grow_time_by_step(inst,2) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step2",true)
                    fertilize_check_by_step(inst,2)
                    pickable_check_by_step(inst,2)
                    inst:PushEvent("season_check")
                end,
                growfn = function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                    inst.AnimState:PlayAnimation("step1_to_step2")
                    inst.AnimState:PushAnimation("step2",true)
                end,
            },
            {
                name = "step3",    --- 阶段3
                time = function(inst) return grow_time_by_step(inst,3) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step3",true)
                    fertilize_check_by_step(inst,3)
                    pickable_check_by_step(inst,3)                    
                    inst:PushEvent("season_check")
                end,         
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step2_to_step3")
                    inst.AnimState:PushAnimation("step3",true)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                    inst:DoTaskInTime(0.6,function()
                        inst.AnimState:SetTime(math.random(5000)/1000)
                    end)
                end,
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
        --- 季节检查和限定生长
        inst:ListenForEvent("season_check",function()
            -- autumn , winter , spring , summer
            if TheWorld.state.season == "summer" then
                inst.components.growable:StartGrowing()
            else
                inst.components.growable:StopGrowing()
            end
        end)
        inst:DoTaskInTime(0.1,function()
            inst:PushEvent("season_check")
        end)
        inst:WatchWorldState("season", function()
            inst:DoTaskInTime(0.1,function()
                inst:PushEvent("season_check")
            end)
        end)
    ------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_plant_pinellia_ternata", fn, assets)