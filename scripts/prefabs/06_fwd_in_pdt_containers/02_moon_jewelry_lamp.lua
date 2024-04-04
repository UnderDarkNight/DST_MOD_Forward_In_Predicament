----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 天体珠宝灯
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_moom_jewelry_lamp.zip"),
    Asset( "IMAGE", "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_1.tex" ),    ---- 加载widget 贴图
    Asset( "ATLAS", "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_1.xml" ),
    Asset( "IMAGE", "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_2.tex" ), 
    Asset( "ATLAS", "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_2.xml" ),
    Asset("ANIM", "anim/fwd_in_pdt_moom_jewelry_lamp_moon.zip"),
}
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_moom_jewelry_lamp"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

--------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_moom_jewelry_lamp_moon"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_moom_jewelry_lamp_moon",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_moom_jewelry_lamp_moon",                  --- 制作完成后切换的 build
            name = "走向月亮",                    --- 【制作栏】皮肤的名字
            name_color = {255/255,185/255,15/255,255/255},
            minimap = "fwd_in_pdt_moom_jewelry_lamp_moon.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_moom_jewelry_lamp_moon.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_moom_jewelry_lamp_moon",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_moom_jewelry_lamp")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面安装组件
    local function container_Widget_change(theContainer)
         -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_moom_jewelry_lamp_widget"

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
                        { image = "fwd_in_pdt_moom_jewelry_lamp_slot_1.tex" ,atlas = "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_1.xml"},
                        { image = "fwd_in_pdt_moom_jewelry_lamp_slot_2.tex" ,atlas = "images/widget/fwd_in_pdt_moom_jewelry_lamp_slot_2.xml"},
                    },
                    animbank = "ui_cookpot_1x2",        -- 箱子背景贴图动画
                    animbuild = "ui_cookpot_1x2",
                    pos = Vector3(200, 0, 0),
                    side_align_tip = 100,
                },
    
                type = "chest",
                acceptsstacks = false,              ---- 是否允许叠堆
                usespecificslotsforitems = true,    ----- 特殊格子指定东西 --- 好像不起效果(shift 进不去，只能手动放进去)
    
                
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
        --- 声音关闭
        if theContainer.SetSkipOpenSnd then
            theContainer:SetSkipOpenSnd(true)   ---- 打开时候的声音
            theContainer:SetSkipCloseSnd(true)  ---- 关闭时候的声音
        end
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

            inst.OnEntityReplicated = function(inst)
                container_Widget_change(inst.replica.container)
            end

        end


        -- inst:ListenForEvent("itemget",function()
        --     print("++++++ item get",inst)
        -- end)
        -- inst:ListenForEvent("itemlose",function()
        --     print("++++++ item lose",inst)
        -- end)


    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
------ 灯光控制组件安装
    local function Light_Setup(inst)

        local Max_Intensity = 0.6      --- 最大亮度
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

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_moom_jewelry_lamp.tex")

    MakeObstaclePhysics(inst, .5)

    inst.Light:Enable(false)
    -- inst.Light:SetRadius(1.5)   -- 光照半径
    inst.Light:SetRadius(10)   -- 光照半径
    inst.Light:SetFalloff(.5)   -- 距离衰减速度（越大衰减越快）
    -- inst.Light:SetIntensity(0.6)    --- 光照强度 --- 靠task 渐变亮度
    inst.Light:SetColour(235 / 255, 255 / 255, 255 / 255)   --- 颜色 RGB

    inst.AnimState:SetBank("fwd_in_pdt_moom_jewelry_lamp")
    inst.AnimState:SetBuild("fwd_in_pdt_moom_jewelry_lamp")
    inst.AnimState:PlayAnimation("idle")

    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetLightOverride(0.4)

    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_moom_jewelry_lamp")


    inst.entity:SetPristine()

    inst.AnimState:Hide("BLUE")
    inst.AnimState:Hide("YELLOW")
    inst.AnimState:Hide("RED")
    inst.AnimState:Hide("LIGHT_ON")


    add_container_before_not_ismastersim_return(inst)

    --- 皮肤API
    Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_moom_jewelry_lamp","fwd_in_pdt_moom_jewelry_lamp","fwd_in_pdt_moom_jewelry_lamp.tex")
    if TheWorld.ismastersim then
        inst:AddComponent("fwd_in_pdt_func"):Init("skin","normal_api")
    end

    if not TheWorld.ismastersim then
        return inst
    end
    
    -----------------------
    --- 被锤子拆解的组件
        inst:AddComponent("lootdropper")---这个才能让官方的敲击实现掉落一半
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(6)
        -- inst.components.workable:SetOnWorkCallback(onworkfinished)   --- 每次敲击执行的代码，可以做敲击动画
        inst.components.workable:SetOnFinishCallback(function()         --- 敲够次数后执行的代码
            inst.components.lootdropper:DropLoot()----这个才能让官方的敲击实现掉落一半
            inst.components.container:DropEverything()
            SpawnPrefab('collapse_small').Transform:SetPosition(inst.Transform:GetWorldPosition())  --- 烟雾
            inst:Remove()
        end)

    -----------------------
    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

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
        -- inst:ListenForEvent("light.off",function()
        --     inst.AnimState:Hide("LIGHT_ON")
        -- end)
        -- inst:ListenForEvent("light.on",function()
        --     inst.AnimState:Show("LIGHT_ON")
        -- end)
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
            
            if moonglass == nil or moonglass.prefab ~= "moonglass"  or gem == nil or items[gem.prefab] ~= true then
                inst.AnimState:ClearBloomEffectHandle()
                inst.AnimState:Hide("BLUE")
                inst.AnimState:Hide("YELLOW")
                inst.AnimState:Hide("RED")
                return
            end

            inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")

            if gem.prefab == "redgem" then
                inst:PushEvent("light.off") -- 先关闭光源
                inst:RemoveTag("has.light") -- 再移除拥有光源标记
                inst:PushEvent("Set.Hot")   -- 添加热源

                inst.AnimState:Hide("BLUE")
                inst.AnimState:Hide("YELLOW")
                inst.AnimState:Show("RED")
                inst:DoTaskInTime(0.2,function()
                    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")                    
                end)

            elseif gem.prefab == "bluegem" then
                inst:PushEvent("light.off") -- 先关闭光源
                inst:RemoveTag("has.light") -- 再移除拥有光源标记
                inst:PushEvent("Set.Cold")   -- 添加冷

                inst.AnimState:Show("BLUE")
                inst.AnimState:Hide("YELLOW")
                inst.AnimState:Hide("RED")
                inst:DoTaskInTime(0.2,function()
                    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")                    
                end)

            elseif gem.prefab == "yellowgem" then
                inst:PushEvent("Set.OFF")   -- 移除 冷热源
                inst:AddTag("has.light") -- 再添加拥有光源标记

                if TheWorld.state.isnight or TheWorld:HasTag("cave") then
                    inst:PushEvent("light.on") -- 检查是否天黑，直接开启光源
                end
                inst.AnimState:Hide("BLUE")
                inst.AnimState:Show("YELLOW")
                inst.AnimState:Hide("RED")
                inst.AnimState:ClearBloomEffectHandle()

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

local function placer_postinit_fn(inst)
    inst.AnimState:Hide("BLUE")
    inst.AnimState:Hide("YELLOW")
    inst.AnimState:Hide("RED")
end
return Prefab("fwd_in_pdt_moom_jewelry_lamp", fn,assets),
        MakePlacer("fwd_in_pdt_moom_jewelry_lamp_placer", "fwd_in_pdt_moom_jewelry_lamp", "fwd_in_pdt_moom_jewelry_lamp", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn)