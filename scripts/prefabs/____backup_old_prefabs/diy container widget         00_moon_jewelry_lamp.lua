local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),

    Asset( "IMAGE", "images/widget/npng_moom_jewelry_lamp_slot_1.tex" ),    ---- 加载widget 贴图
    Asset( "ATLAS", "images/widget/npng_moom_jewelry_lamp_slot_1.xml" ),
    Asset( "IMAGE", "images/widget/npng_moom_jewelry_lamp_slot_2.tex" ), 
    Asset( "ATLAS", "images/widget/npng_moom_jewelry_lamp_slot_2.xml" ),
}
local function GetStringsTable()
    ---- 本函数是用来获取多语言情况下相关文本用的
    local prefab_name = "npng_moom_jewelry_lamp"
    local LANGUAGE = type(TUNING.__NoPainNoGain_LANGUAGE)=="function" and TUNING.__NoPainNoGain_LANGUAGE() or TUNING.__NoPainNoGain_LANGUAGE
    return TUNING.NoPainNoGain_Strings[LANGUAGE] [prefab_name] or {}
end

--------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面安装组件
    local function container_Widget_change(theContainer)
         -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "npng_moom_jewelry_lamp_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos =
                    {
                        Vector3(0, 32 + 4, 0),
                        Vector3(0, -(32 + 4), 0),
                    },
                    slotbg =    --- 格子背景贴图
                    {
                        { image = "npng_moom_jewelry_lamp_slot_1.tex" ,atlas = "images/widget/npng_moom_jewelry_lamp_slot_1.xml"},
                        { image = "npng_moom_jewelry_lamp_slot_2.tex" ,atlas = "images/widget/npng_moom_jewelry_lamp_slot_2.xml"},
                    },
                    animbank = "ui_cookpot_1x2",        -- 箱子背景贴图动画
                    animbuild = "ui_cookpot_1x2",
                    pos = Vector3(200, 0, 0),
                    side_align_tip = 100,
                },
    
                type = "chest",
                acceptsstacks = false,              ---- 是否允许叠堆
                usespecificslotsforitems = true,    ----- 特殊格子指定东西 
    
                
            }

            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    -- print(item,slot)
                    -------- 点击shift 进去的时候，slot 会得到 nil
                    if item and item.prefab then
                        if (slot == 2 or slot == nil) and item.prefab == "moonglass" then    --- 2号格子 和玻璃
                            return true
                        end
                        local items = {
                            ["redgem"] = true,          --- 红宝石
                            ["yellowgem"] = true,       --- 黄宝石
                            ["bluegem"]  = true,        --- 蓝宝石
                        }
                        if items[item.prefab]  and ( slot == 1 or slot == nil ) then                   --- 1号格子                            
                            return true
                        end
                    end
                    return false
                end
            ------------------------------------------------------------------------------------------
        end
       
        theContainer:WidgetSetup(container_widget_name)

        ------------------------
        -----------------------------------------------------------------------------------
        ----- 关闭 声音
        ----- 只有 replica 里才有这个函数
        if theContainer.SetSkipOpenSnd then     ---- container_replica
            theContainer:SetSkipOpenSnd(true)   ---- 打开时候的声音
            theContainer:SetSkipCloseSnd(true)  ---- 关闭时候的声音
        else
            theContainer.inst.replica.container:SetSkipOpenSnd(true)
            theContainer.inst.replica.container:SetSkipCloseSnd(true)
        end
        -----------------------------------------------------------------------------------
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        -- -- local container_WidgetSetup = "wobysmall"
        

        if TheWorld.ismastersim then

                        inst:AddComponent("container")
                        inst.components.container.openlimit = 1  ---- 限制1个人打开
                        container_Widget_change(inst.components.container)    

        else
                        inst:DoTaskInTime(0, function()
                            if inst.replica and inst.replica.container  then
                                container_Widget_change(inst.replica.container)
                            end
                        end)

                        inst._replica_widget_rigister_task = inst:DoPeriodicTask(0.1,function()
                                if inst.replica and inst.replica.container then
                                    if inst.replica.container:GetWidget() == nil then
                                        container_Widget_change(inst.replica.container)
                                    elseif inst._replica_widget_rigister_task then                    
                                        inst._replica_widget_rigister_task:Cancel()
                                        inst._replica_widget_rigister_task = nil
                                    end
                                end
                        end)
        end

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
------ 灯光控制组件安装
    local function Light_Setup(inst)

        local Max_Intensity = 0.6       --- 最大亮度
        local delta_Intensity = 0.0025  --- 增亮速度

        inst._Light_Intensity = 0
        inst.Light:SetIntensity(0)

        inst:ListenForEvent("light.on",function()
            if not inst:HasTag("has.light") then
                return
            end

            inst.Light:Enable(true)
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh") -- 添加贴图荧光效果
            inst.AnimState:SetLightOverride(0.4)

            -------- 关闭逐渐熄灭任务
            if inst.__light_off_task then
                inst.__light_off_task:Cancel()
                inst.__light_off_task = nil
            end
            -------- 逐渐增亮任务
            if inst.__light_on_task == nil then
                inst.__light_on_task = inst:DoPeriodicTask(FRAMES, function()
                    inst.Light:SetIntensity(inst._Light_Intensity)
                    inst._Light_Intensity = inst._Light_Intensity + delta_Intensity
                    if inst._Light_Intensity >= Max_Intensity then
                        -- print("light.on  task end")

                        inst._Light_Intensity = Max_Intensity
                        inst.Light:SetIntensity(Max_Intensity)
                        inst.__light_on_task:Cancel()
                        inst.__light_on_task = nil


                    end
                end)
            end

        end)

        inst:ListenForEvent("light.off",function()
            if not inst:HasTag("has.light") then
                return
            end

            ------ 关闭逐渐增亮任务
            if inst.__light_on_task then
                inst.__light_on_task:Cancel()
                inst.__light_on_task = nil
            end

            -------- 逐渐熄灭任务
            if inst.__light_off_task == nil then
                inst.__light_off_task = inst:DoPeriodicTask(FRAMES,function()
                    inst.Light:SetIntensity(inst._Light_Intensity)
                    inst._Light_Intensity = inst._Light_Intensity - delta_Intensity
                    if inst._Light_Intensity <= 0 then
                        -- print("light.off  task end")

                        inst.__light_off_task:Cancel()
                        inst.__light_off_task = nil

                        inst._Light_Intensity = 0
                        inst.Light:SetIntensity(0)
                        inst.Light:Enable(false)
                        inst.AnimState:ClearBloomEffectHandle() -- 移除贴图荧光效果
                        inst.AnimState:SetLightOverride(0)

                    end

                end)
            end


        end)

        ---------- 监控世界状态，白天关灯，晚上开灯
        inst:WatchWorldState("isday", function()
            if inst:HasTag("has.light") and TheWorld.state.isday then
                -- print("light off task start")
                inst:PushEvent("light.off")
            end
        end)
        inst:WatchWorldState("isnight", function()
            if inst:HasTag("has.light") and TheWorld.state.isnight then
                -- print("light on task start")
                inst:PushEvent("light.on")
            end
        end)

    end
--------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, .5)

    inst.Light:Enable(false)
    inst.Light:SetRadius(1.5)   -- 光照半径
    inst.Light:SetFalloff(.5)   -- 距离衰减速度（越大衰减越快）
    -- inst.Light:SetIntensity(0.6)    --- 光照强度 --- 靠task 渐变亮度
    inst.Light:SetColour(235 / 255, 255 / 255, 255 / 255)   --- 颜色 RGB

    inst.AnimState:SetBank("mushroom_light")
    inst.AnimState:SetBuild("mushroom_light")
    inst.AnimState:PlayAnimation("idle")

    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetLightOverride(0.4)

    inst:AddTag("structure")
    inst:AddTag("npng_moom_jewelry_lamp")


    inst.entity:SetPristine()

    add_container_before_not_ismastersim_return(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    --- 被锤子拆解的组件
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(6)
        -- inst.components.workable:SetOnWorkCallback(onworkfinished)   --- 每次敲击执行的代码，可以做敲击动画    
        inst.components.workable:SetOnFinishCallback(function()         --- 敲够次数后执行的代码
            inst.components.container:DropEverything()
            SpawnPrefab('collapse_small').Transform:SetPosition(inst.Transform:GetWorldPosition())  --- 烟雾
            inst:Remove()
        end)

    -----------------------
    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容
    inst:AddComponent("named")
    inst.components.named:SetName(GetStringsTable().name)           -- 设置物品名字
    --------------------------------------------------------------------------------------------
    ---- 冷热源添加和关闭
            -- inst:AddComponent("heater")
            -- inst.components.heater.heat = 115
            -- inst.components.heater:SetThermics(false, true)
            -- inst.components.heater.heatfn = GetHeatFn
            inst:ListenForEvent("Set.Hot",function()
                ---- 热源
                if inst.components.heater == nil then
                    inst:AddComponent("heater")
                end
                inst.components.heater:SetThermics(true, false)
                inst.components.heater.heatfn = function() return 115 end
            end)
            inst:ListenForEvent("Set.Cold",function()
                ---- 冷源
                if inst.components.heater == nil then
                    inst:AddComponent("heater")
                end
                inst.components.heater:SetThermics(false, true)
                inst.components.heater.heatfn = function() return -40 end
            end)
            inst:ListenForEvent("Set.OFF",function()
                ---- 关闭冷热
                if inst.components.heater ~= nil then
                    inst:RemoveComponent("heater")
                end
            end)
    

    --------------------------------------------------------------------------------------------
    ---- 光源
        Light_Setup(inst)

    --------------------------------------------------------------------------------------------
    ---- 容器关闭后触发事件

        ---- 检查事件
        inst:ListenForEvent("lamp_slots_check",function()
            local items = {
                ["redgem"] = true,          --- 红宝石
                ["yellowgem"] = true,       --- 黄宝石
                ["bluegem"]  = true,        --- 蓝宝石
            }

            local gem = inst.components.container.slots[1]
            local moonglass = inst.components.container.slots[2]
            
            if moonglass == nil or moonglass.prefab ~="moonglass"  or gem == nil or items[gem.prefab] ~= true then
                return
            end

            inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")

            if gem.prefab == "redgem" then
                inst:PushEvent("light.off") -- 先关闭光源
                inst:RemoveTag("has.light") -- 再移除拥有光源标记
                inst:PushEvent("Set.Hot")   -- 添加热源

            elseif gem.prefab == "bluegem" then
                inst:PushEvent("light.off") -- 先关闭光源
                inst:RemoveTag("has.light") -- 再移除拥有光源标记
                inst:PushEvent("Set.Cold")   -- 添加冷

            elseif gem.prefab == "yellowgem" then
                inst:PushEvent("Set.OFF")   -- 移除 冷热源
                inst:AddTag("has.light") -- 再添加拥有光源标记

                if TheWorld.state.isnight then
                    inst:PushEvent("light.on") -- 检查是否天黑，直接开启光源
                end
            end
            
        end)

        inst:ListenForEvent("onclose",function()    -- 有人关闭容器的是时候触发检查
            inst:PushEvent("lamp_slots_check")
        end)
        inst:DoTaskInTime(0, function()             --  加载的时候触发检查
            inst:PushEvent("lamp_slots_check")
        end)
    --------------------------------------------------------------------------------------------
    MakeHauntableWork(inst)

    return inst
end

return Prefab("npng_moom_jewelry_lamp", fn,assets),
        MakePlacer("npng_moom_jewelry_lamp_placer", "mushroom_light", "mushroom_light", "idle")