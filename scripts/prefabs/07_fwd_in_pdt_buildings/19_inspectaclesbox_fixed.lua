---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        -- Asset("ANIM", "anim/inspectaclesbox.zip"),
        Asset("ANIM", "anim/fwd_in_pdt_building_inspectaclesbox.zip"),
        Asset("ANIM", "anim/fwd_in_pdt_building_inspectaclesbox_empty.zip"),
    }
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local SCALE = 1.5
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 容器
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_building_inspectaclesbox_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank = "ui_fish_box_5x4",
                    animbuild = "ui_fish_box_5x4",
                    pos = Vector3(0, 220, 0),
                    side_align_tip = 160,
                },
                type = "chest",
                acceptsstacks = true,                
            }

            for y = 2.5, -0.5, -1 do
                for x = -1, 3 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
                end
            end
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
            --     theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            -- end
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        -- local container_WidgetSetup = "wobysmall"
            if TheWorld.ismastersim then
                inst:AddComponent("container")
                inst.components.container.openlimit = 1  ---- 限制1个人打开
                -- inst.components.container:WidgetSetup(container_WidgetSetup)
                container_Widget_change(inst.components.container)
            else
                inst.OnEntityReplicated = function(inst)
                    container_Widget_change(inst.replica.container)
                end
            end        
        -------------------------------------------------------------------------------------------------
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddAnimState()


        -- inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_inspectaclesbox.tex")
        -- inst.MiniMapEntity:SetPriority(6)

        inst.AnimState:SetBank("fwd_in_pdt_building_inspectaclesbox")
        inst.AnimState:SetBuild("fwd_in_pdt_building_inspectaclesbox")
        inst.AnimState:PlayAnimation("idle",true)
        -- inst.AnimState:SetErosionParams(0.1,-0.1,-1)
        inst.AnimState:SetScale(SCALE,SCALE,SCALE)

        inst:AddTag("NOBLOCK")
        inst:AddTag("fwd_in_pdt_com_inspectacle_searcher_target")

        -- MakeInventoryPhysics(inst)
        -- MakeInventoryFloatable(inst)

        inst.entity:SetPristine()
        add_container_before_not_ismastersim_return(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        -------------------------------------------------------------------------------------------------
        --- 
            inst:AddComponent("inspectable")
        -------------------------------------------------------------------------------------------------
        --- 锤子拆卸
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetOnFinishCallback(function()
                local x,y,z = inst.Transform:GetWorldPosition()
                local fx = SpawnPrefab("halloween_moonpuff")
                fx.Transform:SetPosition(x,y,z)
                if inst.components.container then
                    inst.components.container:DropEverything()
                end
                -- inst:AddComponent("lootdropper")
                -- for i = 1, 3, 1 do
                --     inst.components.lootdropper:SpawnLootPrefab("log")                
                -- end
                inst:Remove()
            end)
            inst.components.workable:SetWorkLeft(4)
        -------------------------------------------------------------------------------------------------
        ---
        -------------------------------------------------------------------------------------------------
        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_building_inspectaclesbox_fixed", fn, assets)
