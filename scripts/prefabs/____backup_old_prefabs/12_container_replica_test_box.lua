local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),
    -- Asset( "IMAGE", "images/inventoryimages/panda_fisherman_supply_pack.tex" ),  -- 背包贴图
    -- Asset( "ATLAS", "images/inventoryimages/panda_fisherman_supply_pack.xml" ),
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function itemCheck(item)
    return true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
    ----- 容器界面名 --- 要独特一点，避免冲突
    local container_widget_name = "fwd_in_pdt_replica_test_widget"

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
                return itemCheck(item)
            end
        ------------------------------------------------------------------------------------------
    end
    
    theContainer:WidgetSetup(container_widget_name)
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
        -- inst.OnEntityReplicated = function(inst)
        --     container_Widget_change(inst.replica.container)
        -- end
        inst:ListenForEvent("fwd_in_pdt_event.OnReplicated",function()
            container_Widget_change(inst.replica.container)
            print("info : fwd_in_pdt_event.OnReplicated",inst)
        end)
    end
    -------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("chest")
    inst.AnimState:SetBuild("treasurechest_terrarium")
    inst.AnimState:PlayAnimation("closed")
    -- inst.AnimState:SetScale(0.5,0.5,0.5)
    inst.AnimState:SetMultColour(0,0, 0, 0.7)
    -- MakeObstaclePhysics(inst,0.5)

    -- inst:AddTag("npc_item_thief_box")

    inst.entity:SetPristine()

    add_container_before_not_ismastersim_return(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可检查组件
    inst.components.inspectable:SetDescription("55555555555555555")

    inst:AddComponent("named")
    inst.components.named:SetName("99999999999999999")
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper("npc_item_recycle_cart")] = GetStringsTable().box_inspect  --人物检查的描述

    -----------------------------------------------------------------------------------
    inst:ListenForEvent("itemget",function(inst,_table)
        if _table and _table.item then
            local tempItem = _table.item
            if tempItem.components.perishable then
                tempItem.components.perishable:StopPerishing()
            end
        end
    end)

    inst:ListenForEvent("itemlose",function(inst,_table)
        if _table and _table.prev_item then
            local tempItem = _table.prev_item
            if tempItem.components.perishable then
                tempItem.components.perishable:StartPerishing()
            end
        end
    end)
    -----------------------------------------------------------------------------------

    -- inst.components.container
    -- inst:ListenForEvent("onopen",function()
    --     inst.AnimState:PlayAnimation("open")
    --     inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    -- end)
    -- inst:ListenForEvent("onclose",function()
    --     inst.AnimState:PlayAnimation("close")
    --     inst.AnimState:PushAnimation("closed", false)
    --     inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    --     inst.components.container:DropEverything()
    --     inst:DoTaskInTime(0.5,inst.Remove)
    -- end)   

    -----------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_container_test_replica_box", fn,assets)