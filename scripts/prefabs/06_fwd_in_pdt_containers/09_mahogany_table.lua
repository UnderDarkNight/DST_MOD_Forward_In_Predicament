----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    红木桌

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local cooking = require("cooking")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets = {
        Asset("ANIM", "anim/fwd_in_pdt_container_mahogany_table.zip"),
        Asset( "IMAGE", "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.tex" ), 
        Asset( "ATLAS", "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml" ),
    }

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_container_mahogany_table"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- item test 

    local function IsCookedFood(item_inst)

        local food_base_prefab = item_inst.nameoverride or item_inst.prefab

        local crash_flag,ret = pcall(function()
            local recipe = cooking.GetRecipe("portablecookpot", food_base_prefab)   --- 获取大厨锅 的配方
            if recipe then
                return true
            end
            return false
        end)
            
        if crash_flag then
            return ret
        else
            return false
        end

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_container_mahogany_table_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank = "fwd_in_pdt_container_mahogany_table",
                    animbuild = "fwd_in_pdt_container_mahogany_table",
                    pos = Vector3(0, 200, 0),
                    side_align_tip = 160,
                    slotbg =    --- 格子背景贴图
                    {
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                        { image = "fwd_in_pdt_container_mahogany_table_slot_bg.tex" ,atlas = "images/widget/fwd_in_pdt_container_mahogany_table_slot_bg.xml"},
                    },
                },

                type = "chest",
                acceptsstacks = true,                
            }

            for y = 2, 0, -1 do
                for x = 0, 2 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
                end
            end
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    -- return true
                    if item and item.prefab then
                        return IsCookedFood(item)
                    end
                    return false
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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 容器关闭才检查内部
    local function add_container_close_event(inst)

        inst:ListenForEvent("display_refresh",function()

            if inst:HasTag("burnt") then
                return
            end

                    for i = 1, 9, 1 do
                        local item_inst = inst.components.container.slots[i]
                        if item_inst then
                            local food_base_prefab = item_inst.nameoverride or item_inst.prefab
                            local product = food_base_prefab

                            local recipe = cooking.GetRecipe("portablecookpot", food_base_prefab)   --- 获取大厨锅 的配方


                            local potlevel = recipe ~= nil and recipe.potlevel or nil
                            local build = (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
                            local overridesymbol = (recipe ~= nil and recipe.overridesymbolname) or product


                            if build and overridesymbol then
                                inst.AnimState:Show("TEMP_SLOT"..tostring(i))
                                inst.AnimState:OverrideSymbol("slot_"..tostring(i), build, overridesymbol)
                            else
                                inst.AnimState:ClearOverrideSymbol("slot_"..tostring(i))
                                inst.AnimState:Hide("TEMP_SLOT"..tostring(i))

                            end

                        else

                            inst.AnimState:ClearOverrideSymbol("slot_"..tostring(i))
                            inst.AnimState:Hide("TEMP_SLOT"..tostring(i))


                        end

                    end


        end)

        inst:ListenForEvent("onclose",function()
            
            -- for k, item_inst in pairs(inst.components.container.slots) do
            --     if item_inst and item_inst
            -- end
            -- if TUNING.temp_test_fn then
            --     TUNING.temp_test_fn(inst)

            -- end
            inst:PushEvent("display_refresh")

        end)

        inst:DoTaskInTime(0,function()
            for i = 1, 9, 1 do
                inst.AnimState:Hide(string.upper("TEMP_SLOT"..tostring(i)))
            end            
            inst:PushEvent("display_refresh")
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_container_mahogany_table.tex")

    inst.AnimState:SetBank("fwd_in_pdt_container_mahogany_table")
    inst.AnimState:SetBuild("fwd_in_pdt_container_mahogany_table")
    inst.AnimState:PlayAnimation("idle")

    for i = 1, 9, 1 do
        inst.AnimState:Hide("TEMP_SLOT"..tostring(i))
    end

    -- local scale = 1.5
    -- inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    -- inst:AddTag("chest")
    inst:AddTag("fwd_in_pdt_container_mahogany_table")



    inst.entity:SetPristine()


    add_container_before_not_ismastersim_return(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------------------------------------------------------------------
    ---- 可检查组件
        inst:AddComponent("inspectable") --
        inst.components.inspectable.descriptionfn = function()
            if inst:HasTag("burnt") then
                return GetStringsTable()["inspect_str_burnt"]
            else
                return GetStringsTable()["inspect_str"]
            end
        end

    -----------------------------------------------------------------------------------
        add_container_close_event(inst)
    -----------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------
    ---- 积雪检查
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end    
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        snow_init(inst)
    -----------------------------------------------------------------------------------
        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(function()
            if not inst:HasTag("burnt") then
                inst.components.lootdropper:DropLoot()
                inst.components.container:DropEverything()
            end
            SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst:Remove()
        end)
    -----------------------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_data")
    --------------------------------------------------------
    ---- 燃烧
        MakeMediumBurnable(inst, nil, nil, true)
        inst:ListenForEvent("onburnt", function()          --- 烧完后执行
            inst.components.fwd_in_pdt_data:Set("burnt",true)
            inst.AnimState:PlayAnimation("burnt")
            inst:AddTag("burnt")
            snow_init(inst)            
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("burnt") then
                inst:PushEvent("onburnt")
                inst.components.burnable.onburnt(inst)
            end
        end)
        inst:ListenForEvent("onburnt",function()
            inst:RemoveComponent("container")
        end)
    --------------------------------------------------------
    return inst
end
-----------------------------------------------------------------------------------------------
    local function placer_postinit_fn(inst)
        -- local scale = 1.5
        -- inst.AnimState:SetScale(scale,scale,scale)
        inst.AnimState:Hide("SNOW")
        for i = 1, 9, 1 do
            inst.AnimState:Hide("TEMP_SLOT"..tostring(i))
        end
    end
-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_container_mahogany_table", fn,assets),
        MakePlacer("fwd_in_pdt_container_mahogany_table_placer", "fwd_in_pdt_container_mahogany_table", "fwd_in_pdt_container_mahogany_table", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)