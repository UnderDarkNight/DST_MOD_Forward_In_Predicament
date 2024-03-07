--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 示例冰箱
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
local function container_Widget_change(theContainer)
    -----------------------------------------------------------------------------------
    ----- 容器界面名 --- 要独特一点，避免冲突
    local container_widget_name = "fwd_in_pdt_deep_freeze_widget"

    -----------------------------------------------------------------------------------
    ----- 检查和注册新的容器界面
    local all_container_widgets = require("containers")  --- 所有容器的总表
    local params = all_container_widgets.params             ---- 总参数表。 index 为该界面名字。
    if params[container_widget_name] == nil then            ---- 如果该界面不存在总表，则按以下规则注册。
        params[container_widget_name] = {
            widget =
            {
                slotpos = {},
                animbank = "ui_fish_box_5x4",   --- 格子背景动画
                animbuild = "ui_fish_box_5x4",  --- 格子背景动画
                pos = Vector3(0, 220, 0),       --- 基点坐标
                side_align_tip = 160,
            },
            type = "chest",
            acceptsstacks = true,               --- 是否允许叠堆 
        }

        ------ 格子的布局
        for y = 2.5, -0.5, -1 do
            for x = -1, 3 do
                table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
            end
        end
        ------------------------------------------------------------------------------------------
        -- ---- 餐桌的item test。判断是否允许物品进入该格子。
        -- local function IsCookedFood(item_inst)

        --     local food_base_prefab = item_inst.nameoverride or item_inst.prefab
        --     local crash_flag,ret = pcall(function()
        --         local recipe = cooking.GetRecipe("portablecookpot", food_base_prefab)   --- 获取大厨锅 的配方
        --         if recipe then
        --             return true
        --         end
        --         return false
        --     end)

        --     if crash_flag then
        --         return ret
        --     else
        --         return false
        --     end
        -- end
        --     params[container_widget_name].itemtestfn =  function(container_com, item, slot)
        --         -- return true
        --         if item and item.prefab then
        --             return IsCookedFood(item)
        --         end
        --         return false
        --     end
        -- ------------------------------------------------------------------------------------------
        -- -- ---尝试用一下官方的写法 来控制item 的进出（成功，官方的冰箱，这样不用去声明一些食物类型）
        params[container_widget_name].itemtestfn =  function(container_com, item, slot)
            if item:HasTag("icebox_valid") then
                return true
            end

            --Perishable
            if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
                return false
            end

            if item:HasTag("smallcreature") then
                return true
            end

            --Edible
            for k, v in pairs(FOODTYPE) do
                if item:HasTag("edible_"..v) then
                    return true
                end
            end

            return false
        end
    end
    -------------------------------------------------------------------------------------------
    ----- 检查、注册完 容器界面后，安装界面给  container 组件。replica 和 component  都是用的相同函数 安装
    theContainer:WidgetSetup(container_widget_name)
    ------------------------------------------------------------------------
    --- 开关声音。如果注释掉，则是默认的开关声音。
        -- if theContainer.widget then
        --     theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
        --     theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
        -- end
    ------------------------------------------------------------------------
end

local function add_container_before_not_ismastersim_return(inst)
    -------------------------------------------------------------------------------------------------
    ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            inst.components.container.openlimit = 1  ---- 限制1个人打开
            container_Widget_change(inst.components.container)
        else
            ------- 在客户端必须执行容器界面注册。不能像科雷那样只在服务端注册。
            inst.OnEntityReplicated = function(inst)
                container_Widget_change(inst.replica.container)
            end
        end
    -------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_deep_freeze.zip"),
}

local function fn()
-------------------------------------------------------------------------------------
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_deep_freeze.tex")

    MakeObstaclePhysics(inst, 0.5)---设置一下距离

    inst.AnimState:SetBank("fwd_in_pdt_deep_freeze")
    inst.AnimState:SetBuild("fwd_in_pdt_deep_freeze")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fridge")  --- 有这个才能给暖石降温
    inst:AddTag("structure")
    inst:AddTag("fwd_in_pdt_deep_freeze")


    -- inst:AddTag("antlion_sinkhole_blocker")
    -- inst:AddTag("birdblocker")
    -- inst:AddTag("fwd_in_pdt_fish_farm")
    
    inst.entity:SetPristine()
-------------------------------------------------------------------------------------
    add_container_before_not_ismastersim_return(inst)   --- 安装容器界面
-------------------------------------------------------------------------------------
-- 反鲜，在打开的时候反鲜（成功）
local function refreshFoods(inst)
    for k,v in pairs(inst.components.container.slots) do
        if v:IsValid() and v.components.perishable then
            v.components.perishable:SetPercent(1.0)
        end
    end
end
local function onWatchWorldState(inst)
        refreshFoods(inst)
end
-------------------------------------------------------------------------------------
-- 被敲打拆除，掉出所有东西（不知道为什么幕夜大大给的不行，并且 用幕夜大大的 还会导致敲击结束不给掉落物）
local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end
-- 被意外拆除
local function onhit(inst, worker)
    inst.components.container:DropEverything()
    inst.AnimState:PlayAnimation("idle")
    inst.components.container:Close()
end
-------------------------------------------------------------------------------------


if not TheWorld.ismastersim then
    return inst
end


inst:AddComponent("inspectable")
-------------------------------------------------------------------------------------
---- 打开、关闭 容器的时候触发的事件。可以用来播放动画
    inst:ListenForEvent("onopen",function()
        refreshFoods(inst)---这里反鲜
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
    end)
    inst:ListenForEvent("onclose",function()
        inst.AnimState:PlayAnimation("idle")
        inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
    end)
-------------------------------------------------------------------------------------
    inst:AddComponent("lootdropper")
---- 被敲打拆除设置次数
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 
-------------------------------------------------------------------------------------
    inst:ListenForEvent("onbuilt",function()
        inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
        ---- 刚刚制作出来才会触发的代码，通常用来触发 建造动画。
    end)
-------------------------------------------------------------------------------------
---- 积雪检查
    --[[ 
        【注意】 
            官方的   MakeSnowCoveredPristine(inst)  MakeSnowCovered(inst) 
            基本只对官方的东西有效，MOD作者需要自行在动画和代码上做额外处理。
            方式有两种： 
                基于文件夹的 隐藏/显示。
                基于标记位的 隐藏显示。（这里示例用的就是这一种）
    ]]------
    local function snow_init(inst)
        if TheWorld.state.issnowcovered then
            inst.AnimState:Show("SNOW")
        else
            inst.AnimState:Hide("SNOW")
        end    
    end
    inst:WatchWorldState("issnowcovered", snow_init)
    snow_init(inst)
-------------------------------------------------------------------------------------

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_deep_freeze", fn, assets),
    MakePlacer("fwd_in_pdt_deep_freeze_placer", "fwd_in_pdt_deep_freeze", "fwd_in_pdt_deep_freeze", "idle")