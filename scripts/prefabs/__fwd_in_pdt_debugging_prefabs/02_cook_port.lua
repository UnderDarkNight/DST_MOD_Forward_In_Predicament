local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),

    -- Asset( "IMAGE", "images/widget/npng_moom_jewelry_lamp_slot_1.tex" ),    ---- 加载widget 贴图
    -- Asset( "ATLAS", "images/widget/npng_moom_jewelry_lamp_slot_1.xml" ),
    -- Asset( "IMAGE", "images/widget/npng_moom_jewelry_lamp_slot_2.tex" ), 
    -- Asset( "ATLAS", "images/widget/npng_moom_jewelry_lamp_slot_2.xml" ),
}
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_gift_pack"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

--------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面安装组件
    local function container_Widget_change(theContainer)
        local params = {}
        params._theContainerWidget =
        {
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


        params._theContainerWidget.itemtestfn =  function(container_com, item, slot)
            ---- 该fn 会在 服务器上执行2次？？   服务器上的replica 一次， com 一次.  往总containers 界面表里注册就不会发生
            -- print("itemtestfn")
            if item and item.prefab then
                if slot == 2 and item.prefab == "moonglass" then    --- 2号格子 和玻璃
                    return true
                end
                
                if slot == 1 then                   --- 1号格子
                    local items = {
                        ["redgem"] = true,          --- 红宝石
                        ["yellowgem"] = true,       --- 黄宝石
                        ["bluegem"]  = true,        --- 蓝宝石
                    }
                    return items[item.prefab] or false
                end
            end
            return false
        end
        

        theContainer:WidgetSetup("wobysmall",params._theContainerWidget)
        theContainer:SetNumSlots(#params._theContainerWidget.widget.slotpos)

        ------------------------
        --- 声音关闭
        if theContainer.SetSkipOpenSnd then
            theContainer:SetSkipOpenSnd(true)   ---- 打开时候的声音
            theContainer:SetSkipCloseSnd(true)  ---- 关闭时候的声音
        end


    end

    local function container_Widget_change2(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名
        local container_widget_name = "test_fwd_in_pdt_container_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = 
            {
                widget =
                {
                    slotpos =
                    {
                        Vector3(0, 64 + 32 + 8 + 4, 0),
                        Vector3(0, 32 + 4, 0),
                        Vector3(0, -(32 + 4), 0),
                        Vector3(0, -(64 + 32 + 8 + 4), 0),
                    },
                    animbank = "ui_cookpot_1x4",
                    animbuild = "ui_cookpot_1x4",
                    pos = Vector3(200, 0, 0),
                    side_align_tip = 100,
                    buttoninfo =
                    {
                        text = STRINGS.ACTIONS.COOK,
                        position = Vector3(0, -165, 0),
                    }
                },
                acceptsstacks = false,
                type = "cooker",
            }
            params[container_widget_name].itemtestfn = function(container, item, slot)
                return true
            end
            
            params[container_widget_name].widget.buttoninfo.fn = function(inst, doer)
                print("buttoninfo",doer) 
            end
            
            params[container_widget_name].widget.buttoninfo.validfn = function(inst)
                return true
                -- return inst.replica.container ~= nil and inst.replica.container:IsFull()
            end


        end

        -----------------------------------------------------------------------------------
        ----- 往容器 添加界面
        theContainer:WidgetSetup(container_widget_name)

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
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        

        if TheWorld.ismastersim then

                        inst:AddComponent("container")
                        inst.components.container.openlimit = 1  ---- 限制1个人打开
                        container_Widget_change2(inst.components.container)    

        else
                        inst:DoTaskInTime(0, function()
                            if inst.replica and inst.replica.container  then
                                container_Widget_change2(inst.replica.container)
                            end
                        end)

                        inst._replica_widget_rigister_task = inst:DoPeriodicTask(0.1,function()
                                if inst.replica and inst.replica.container then
                                    if inst.replica.container:GetWidget() == nil then
                                        container_Widget_change2(inst.replica.container)
                                    elseif inst._replica_widget_rigister_task then                    
                                        inst._replica_widget_rigister_task:Cancel()
                                        inst._replica_widget_rigister_task = nil
                                    end
                                end
                        end)
        end

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
    inst:AddTag("fwd_in_pdt_test_cookpot")


    inst.entity:SetPristine()

    add_container_before_not_ismastersim_return(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    -- inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容
    inst:AddComponent("named")
    -- inst.components.named:SetName(GetStringsTable().name)           -- 设置物品名字
    --------------------------------------------------------------------------------------------
     
    MakeHauntableWork(inst)

    return inst
end

return Prefab("fwd_in_pdt_test_cookpot", fn,assets)