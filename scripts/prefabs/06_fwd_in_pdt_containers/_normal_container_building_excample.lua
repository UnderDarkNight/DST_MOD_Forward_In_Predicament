--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 示例冰箱
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_fish_farm_widget"

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
            ---- item test。判断是否允许物品进入该格子。
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        ---- 检查、注册完 容器界面后，安装界面给  container 组件。replica 和 component  都是用的相同函数 安装
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音。如果注释掉，则是默认的开关声音。
            if theContainer.widget then
                theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
                theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            end
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
    Asset("ANIM", "anim/fwd_in_pdt_fish_farm.zip"),
}

local function fn()
    -------------------------------------------------------------------------------------
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()


        inst.entity:AddSoundEmitter()

        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("fwd_in_pdt_fish_farm.tex")

        -- MakeObstaclePhysics(inst, 1.5)
        -- MakeObstaclePhysics(inst, 2)


        inst.AnimState:SetBank("icebox")
        inst.AnimState:SetBuild("icebox")
        inst.AnimState:PlayAnimation("closed",true)

        inst:AddTag("fridge")  --- 默认冰箱的 必备的 tag
        inst:AddTag("structure")
        -- inst:AddTag("antlion_sinkhole_blocker")
        -- inst:AddTag("birdblocker")
        -- inst:AddTag("fwd_in_pdt_fish_farm")
        
        inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
        add_container_before_not_ismastersim_return(inst)   --- 安装容器界面
    -------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")

    -------------------------------------------------------------------------------------
    ---- 每个物品进出容器的时候 执行的  event
        
        inst:ListenForEvent("itemget",function(_,_table)
            inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")

                if _table and _table.item then      ---- 停止腐烂计算
                    local tempItem = _table.item
                    if tempItem.components.perishable then
                        tempItem.components.perishable:StopPerishing()
                    end
                end

        end)
        inst:ListenForEvent("itemlose",function(inst,_table)    
            inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")

                    if _table and _table.prev_item then  --- 恢复腐烂计算
                        local tempItem = _table.prev_item
                        if tempItem.components.perishable then
                            tempItem.components.perishable:StartPerishing()
                        end
                    end
                    
        end)
    -------------------------------------------------------------------------------------
    ---- 打开、关闭 容器的时候触发的事件。可以用来播放动画
        inst:ListenForEvent("onopen",function()

        end)
        inst:ListenForEvent("onclose",function()

        end)
    -------------------------------------------------------------------------------------
    ---- 被敲打拆除
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnWorkCallback(function(inst,doer)
            ----- 每敲一下就会执行一次的代码
        end)
        inst.components.workable:SetOnFinishCallback(function(inst,doer)
            ---- 敲完次数后执行的代码
            ---- 可能需要在这里处理把 内部东西全部丢出来的操作。
            inst:Remove()
        end)
    -------------------------------------------------------------------------------------
        inst:ListenForEvent("onbuilt",function()
            ---- 刚刚从制作兰制作出来才会触发的代码，通常用来触发 建造动画。
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

return Prefab("fwd_in_pdt_container_excample", fn, assets)