--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 水稻
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_plant_paddy_rice"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_plant_paddy_rice.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 使用官方的 pickable 组件
    local function pickable_check_by_step(inst,step)
        if step == 4 then
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
                -- print("+++++++6666666666666666+++",doer)
                local rice_num = 5
                if inst.components.fwd_in_pdt_data:Get("fertilized") then
                    rice_num = 10
                end
                if doer:HasTag("player") then
                    doer.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                    doer.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_plant_paddy_rice_seed",rice_num)
                else
                    TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                            target = inst,
                            name = "fwd_in_pdt_plant_paddy_rice_seed",
                            num = rice_num,    -- default
                            range = 2, -- default
                            height = 3,-- default
                    })
                end
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
        if inst.components.fwd_in_pdt_data:Get("fertilized") or step == 4 then
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
-- 水波特效
    local function add_wave_fx(inst)
        --Dedicated server does not need to spawn local particle fx
        -- 特效只在 客户端 有就行了，服务端不需要
        if TheNet:IsDedicated() then
            return
        end
        local x,y,z = inst.Transform:GetWorldPosition()
        local scale_num = 0.6
        ------------------------------------------
        --- 后端
            local back = CreateEntity()
            back.entity:AddTransform()
            back.entity:AddAnimState()
            back:AddTag("NOBLOCK")
            back:AddTag("FX")
            back.AnimState:SetBuild("float_fx")
            back.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)
            back.AnimState:SetBank("float_back")
            back.AnimState:SetLayer(LAYER_BACKGROUND)
            back.AnimState:PlayAnimation("idle_back_small", true)
            back.Transform:SetPosition(x, 0, z)
            back.AnimState:SetScale(scale_num,scale_num,scale_num)
        ------------------------------------------
        --- 前端
            local front = CreateEntity()
            front.entity:AddTransform()
            front.entity:AddAnimState()
            front:AddTag("NOBLOCK")
            front:AddTag("FX")
            front.AnimState:SetBuild("float_fx")
            front.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)
            front.AnimState:SetBank("float_front")
            front.AnimState:PlayAnimation("idle_front_small", true)
            front.Transform:SetPosition(x, 0, z)
            front.AnimState:SetScale(scale_num,scale_num,scale_num)
        ------------------------------------------

        inst:ListenForEvent("onremove",function()
            front:Remove()
            back:Remove()
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_plant_paddy_rice.tex")

    inst.AnimState:SetBank("fwd_in_pdt_plant_paddy_rice")
    inst.AnimState:SetBuild("fwd_in_pdt_plant_paddy_rice")
    inst.AnimState:PlayAnimation("step1")

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
    --- 水波
        inst:DoTaskInTime(0, add_wave_fx)
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
            if inst.components.growable:GetStage() == 4 then
                inst.components.lootdropper:SetLoot({"fwd_in_pdt_plant_paddy_rice_seed","fwd_in_pdt_plant_paddy_rice_seed"})
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
            return 3*TUNING.TOTAL_DAY_TIME
        end
        inst.components.growable.stages = {
            {
                name = "step1",     --- 阶段1  刚种下的时候
                time = function(inst) return grow_time_by_step(inst,1) end,
                fn = function(inst)                                                 -- SetStage 的时候执行
                    inst.AnimState:PlayAnimation("step1") 
                    fertilize_check_by_step(inst,1)
                    pickable_check_by_step(inst,1)
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
                end,
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step1_to_step2")
                    inst.AnimState:PushAnimation("step2",true)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
            {
                name = "step3",    --- 阶段3
                time = function(inst) return grow_time_by_step(inst,3) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step3",true)
                    fertilize_check_by_step(inst,3)
                    pickable_check_by_step(inst,3)
                end,         
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step2_to_step3")
                    inst.AnimState:PushAnimation("step3",true)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
            {
                name = "step4",
                time = function(inst) return grow_time_by_step(inst,4) end,
                fn = function(inst)
                    inst.AnimState:PlayAnimation("step4",true)
                    fertilize_check_by_step(inst,4)
                    pickable_check_by_step(inst,4)
                end, 
                growfn = function(inst)
                    inst.AnimState:PlayAnimation("step3_to_step4")
                    inst.AnimState:PushAnimation("step4",true)
                    inst:DoTaskInTime(1.2, function()
                        inst.AnimState:SetTime(math.random(5000)/1000)
                    end)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                end,
            },
        }

        inst.components.growable:SetStage(4)
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
    --- 冬天
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                local x,y,z  = inst.Transform:GetWorldPosition()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
                inst:Remove()
                SpawnPrefab("cutgrass").Transform:SetPosition(x,2, z)
            end
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        inst:DoTaskInTime(0,snow_init)
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

return Prefab("fwd_in_pdt_plant_paddy_rice", fn, assets)