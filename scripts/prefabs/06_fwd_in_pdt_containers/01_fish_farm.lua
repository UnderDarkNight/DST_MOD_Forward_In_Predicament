--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 养鱼池
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local widgets_Text = require "widgets/text"

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_fish_farm"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function itemCheck(item)
    local prefabs = {
        ["pondfish"] = true ,                --- 淡水鱼
        ["pondeel"] = true ,                 --- 鳗鱼
        ["spoiled_food"] = true,             --- 腐烂的食物
        ["rottenegg"] = true,                --- 腐烂的鸟蛋
        ["chum"] = true,                     --- 鱼食
        ["spoiled_fish"] = true,             --- 腐烂的鱼
        ["spoiled_fish_small"] = true,       --- 腐烂的小鱼
        
    }
    if prefabs[item.prefab] or item:HasTag("oceanfish") then
        return true
    end
    return false
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
            -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_fish_farm_widget"

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

            ------------------------------------------------------------------------------------------
        end
        
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            if theContainer.widget then
                theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
                theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            end
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
---- net_event install
    local function add_net_event(inst)
        inst.__fish_food_value_json_str = net_string(inst.GUID,"fwd_in_pdt_fish_farm","fwd_in_pdt_fish_farm")
        inst:ListenForEvent("fwd_in_pdt_fish_farm",function()
            local json_str = inst.__fish_food_value_json_str:value()
            local cmd_table = json.decode(json_str)
            inst.fish_food_value = cmd_table.num or 0
            inst:PushEvent("fish_food_value_refresh",cmd_table)
        end)

        if TheWorld.ismastersim then    --- 修改函数只添加在 服务器
            inst:ListenForEvent("add_food_value",function(_,num)  --- 添加数据。，并下发。
                if type(num) == "number" then
                    inst.fish_food_value = inst.components.fwd_in_pdt_data:Add("food_value",num)
                    if inst.fish_food_value < 0 then
                        inst.fish_food_value = 0
                    end
                    local cmd_table = {
                        num = inst.fish_food_value,
                        random = math.random(100000),
                    }
                    inst.__fish_food_value_json_str:set(json.encode(cmd_table))
                    inst.components.fwd_in_pdt_data:Set("food_value",inst.fish_food_value)
                end
            end)

        end
        
        --------------------------- 界面被打开(不管是 server 还是 client。有界面的那个端才触发的event)
        inst:ListenForEvent("fwd_in_pdt_event.container_widget_open",function(_,custom_widget)
            if custom_widget then
                inst.___container_widget = custom_widget
                local fish_food_value = custom_widget:AddChild(widgets_Text(DEFAULTFONT,50,"100.42",{ 255/255 , 255/255 ,255/255 , 1}))
                fish_food_value:SetPosition(0,160)
                fish_food_value:SetString("Food : "..tostring(inst.fish_food_value or 0))
                inst.___container_widget_food_value = fish_food_value
            end
        end)
        inst:ListenForEvent("fwd_in_pdt_event.container_widget_close",function()
            if inst.___container_widget_food_value then
                inst.___container_widget_food_value:Kill()
                inst.___container_widget_food_value = nil
            end
        end)
        inst:ListenForEvent("fish_food_value_refresh",function(_,cmd_table)
            if inst.___container_widget_food_value then
                inst.___container_widget_food_value:SetString("Food : "..tostring(inst.fish_food_value or 0))
            end
        end)



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

        MakeObstaclePhysics(inst, 1.5)


        inst.AnimState:SetBank("fwd_in_pdt_fish_farm")
        inst.AnimState:SetBuild("fwd_in_pdt_fish_farm")
        inst.AnimState:PlayAnimation("idle",true)
        inst.AnimState:SetTime(math.random(800)/10)
        local scale = 0.6
        inst.AnimState:SetScale(scale, scale, scale)
        inst.AnimState:SetFinalOffset(-10)
        inst.AnimState:SetSortOrder(-10)
        inst.AnimState:SetLayer(LAYER_BELOW_OCEAN)


        inst:AddTag("structure")
        inst:AddTag("antlion_sinkhole_blocker")
        inst:AddTag("birdblocker")
        inst:AddTag("fwd_in_pdt_fish_farm")
        
    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
        add_container_before_not_ismastersim_return(inst)
        add_net_event(inst)
    -------------------------------------------------------------------------------------
    ---- 批量采摘的动作
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return right_click
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            inst.components.container:Close()
            inst.components.container:ForEachItem(function(item)
                doer.components.inventory:GiveItem(item)
            end)
            return true
        end)
        -- inst.components.fwd_in_pdt_com_workable:SetSGAction("give")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_fish_farm",STRINGS.ACTIONS.HARVEST)
    -------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")
    inst:AddComponent("fwd_in_pdt_data")

    -------------------------------------------------------------------------------------
    ---- 东西放进去、拿出来
        
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
        inst:ListenForEvent("onopen",function()
            if inst.components.container:IsEmpty() then
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
            else
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            end
        end)
        inst:ListenForEvent("onclose",function()
            if inst.components.container:IsEmpty() then
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
            else
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            end
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.container:IsEmpty() then
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
            else
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
            end
        end)
    -------------------------------------------------------------------------------------
    ---- 鱼池内部计算
        inst:ListenForEvent("itemget",function(_,_table)
                local food_value_list = {
                    ["spoiled_food"] = 30,      --- 腐烂的食物
                    ["rottenegg"]    = 15,      --- 腐烂的鸟蛋
                    ["chum"] = 90,              --- 鱼食
                    ["spoiled_fish"] = 20,             --- 腐烂的鱼
                    ["spoiled_fish_small"] = 15,       --- 腐烂的小鱼
                }
                if _table and _table.item and food_value_list[_table.item.prefab] and _table.slot then   
                    inst:DoTaskInTime(0,function()
                        local item = _table.item 
                        local food_value = food_value_list[item.prefab]
                        local food_num = 1
                        if item.components.stackable then
                            food_num = item.components.stackable.stacksize
                        end
                        inst:PushEvent("add_food_value",food_value*food_num)
                        inst.components.container:DropItemBySlot(_table.slot)
                        item:Remove()
                    end)  
                    
                else
                    inst:PushEvent("add_food_value",0)                    
                end
        end)

        local function isFish(item)
            local prefabs = {
                ["pondfish"] = true ,       --- 淡水鱼
                ["pondeel"] = true ,      --- 鳗鱼
                -- ["spoiled_food"] = true,    --- 腐烂的食物
                -- ["rottenegg"] = true,       --- 腐烂的鸟蛋
                -- ["chum"] = true,       --- 鱼食
                -- ["spoiled_fish"] = true,             --- 腐烂的鱼
                -- ["spoiled_fish_small"] = true,       --- 腐烂的小鱼
            }
            if prefabs[item.prefab] or item:HasTag("oceanfish") then
                return true
            end
            return false
        end
        
        inst:WatchWorldState("cycles",function()
            inst:PushEvent("daily_task_start")
        end)
        inst:ListenForEvent("daily_task_start", function()
            -- print("daily_task_start")
            ----------------------------------------------------------------------
            ----- 预处理
                -- inst.components.container:IsEmpty()

                if inst.components.container:IsOpen() or inst.components.fwd_in_pdt_data:Add("food_value",0) <= 0 then
                    return
                end

                inst.components.container:ForEachItem(function(item)    --- 在新的一天到来的时候 才填满 鱼的保鲜值
                    if item and item.components.perishable then
                        item.components.perishable:SetPercent(1)
                    end
                end)
            ---------------------------------------------------------------------- 
            ---- 值初始化
                local each_fish_cost_value_a_day = 5        --- 每条鱼每天吃多少
                local each_fish_create_value = 30           --- 每条鱼需要消耗的点数
            ---------------------------------------------------------------------- 
            -------- 第一步，计算总共有多少条鱼,以及鱼的类别
                local fish_num = 0
                local fish_prefabs = {}
                inst.components.container:ForEachItem(function(item)
                    if isFish(item) then
                        fish_prefabs[item.prefab] = true
                        fish_num = fish_num + 1
                    end
                end)
                -- print("第一步：",fish_num)
                if fish_num == 0 then
                    inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
                    return
                end
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)

            ----------------------------------------------------------------------
            -------- 第二步，每天每条鱼消耗 5 点 食物度。只有一条鱼的时候返回。
                if fish_num == 1 then
                    inst:PushEvent("add_food_value",-each_fish_cost_value_a_day)
                    return
                else
                    inst:PushEvent("add_food_value",-each_fish_cost_value_a_day*fish_num)
                end
                -- print("第二步通过")
            ----------------------------------------------------------------------
            ------- 第三步， 30 点食物度生长一条鱼                
                local food_current_value = inst.components.fwd_in_pdt_data:Add("food_value",0)
                local food_value_need = fish_num * each_fish_cost_value_a_day
                local food_cost_value = 0   --- 本次消耗掉的食物值
                if food_current_value >= food_value_need then   --- 食物充足
                    food_cost_value = food_value_need
                else
                    food_cost_value = food_current_value 
                end
                local total_cost_value = inst.components.fwd_in_pdt_data:Add("food_value_cost",food_cost_value)

                if TheWorld.state.cycles%3 ~= 0 or TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then  --- 开发者模式每天一查，其他模式3天生一次
                    -- print("第三步：天数取余数",TheWorld.state.cycles%3)
                else                    
                    -- print("第三步：不是指定天数")
                    return
                end

                if total_cost_value < each_fish_create_value then   --- 不够创建一条鱼的 value
                    -- print("第三步： 不够创建一条鱼的 value,已经消耗了",total_cost_value)

                    return
                end
                local new_fish_num = math.floor(total_cost_value/each_fish_create_value)    --- 需要生成的鱼的数量
                if new_fish_num == 0 then
                    -- print("第三步： 需要生成的鱼的数量 0")
                    return
                end
                -- print("第三步： 需要生成的鱼的数量 ",new_fish_num)

            ----------------------------------------------------------------------
            ------ 第四步，检查剩余格子容量
                local slot_empty_num = 0
                -- for k, temp_item in pairs(inst.components.container.slots) do
                --     if temp_item and temp_item.prefab then
                --         ----
                --     else
                --         slot_empty_num = slot_empty_num + 1
                --     end
                -- end
                local NumItems = inst.components.container:NumItems()
                local numslots = inst.components.container.numslots
                slot_empty_num =  numslots - NumItems
                if slot_empty_num <= 0 then --- 没空位了
                    -- print("第四步,没位置了",NumItems,numslots)
                    return
                end
                -- print("第四步 ， 剩余位置",slot_empty_num,numslots)
            ----------------------------------------------------------------------
            ---- 第五步，最终需要生成鱼的数量
                local ret_new_create_fish_num = 0
                if new_fish_num <= slot_empty_num then
                    ret_new_create_fish_num = new_fish_num
                else
                    ret_new_create_fish_num = slot_empty_num
                end
                if ret_new_create_fish_num == 0 then
                    -- print("第五步  返回，不需要生成鱼")
                    return
                end
            ----------------------------------------------------------------------
            ---- 第六步 生成鱼 并计数器减少
                local function get_random_fish_prefab(fish_prefabs)
                    --- 转置 index 并随机返回一条鱼
                    local temp_table = {}
                    for temp_fish_prefab, v in pairs(fish_prefabs) do
                        if temp_fish_prefab and v then
                            table.insert(temp_table,temp_fish_prefab)
                        end
                    end
                    return temp_table[math.random(#temp_table)] or nil
                end
                for i = 1, ret_new_create_fish_num, 1 do
                    local fish_prefab = get_random_fish_prefab(fish_prefabs) or "oceanfish_small_5_inv"
                    inst.components.container:GiveItem(SpawnPrefab(fish_prefab))
                end
                local temp_cost_value = inst.components.fwd_in_pdt_data:Add("food_value_cost",-1 * ret_new_create_fish_num *each_fish_create_value)
                if temp_cost_value <= 0 then
                    inst.components.fwd_in_pdt_data:Set("food_value_cost",0)
                    temp_cost_value = inst.components.fwd_in_pdt_data:Add("food_value_cost",0)
                end
                -- print("第六步 food_value_cost",temp_cost_value)
            ----------------------------------------------------------------------
        end)

    -------------------------------------------------------------------------------------
    ---- 被敲打拆除
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        -- inst.components.workable:SetOnWorkCallback(onhit)
        inst.components.workable:SetOnFinishCallback(function()
            local timer_inst = CreateEntity()
            local x,y,z = inst.Transform:GetWorldPosition()
            for i = 0, 4, 1 do
                timer_inst:DoTaskInTime(i*0.3,function()
                    local delta_x = math.random(15)/10
                    local delta_z = math.random(15)/10
                    if math.random(100) < 50 then
                        delta_x = -1 * delta_x
                    end
                    if math.random(100) < 50 then
                        delta_z = -1 * delta_z
                    end
                    SpawnPrefab("fwd_in_pdt_fx_splash_sink"):PushEvent("Set",{
                        pt = Vector3(x+delta_x,0,z+delta_z)
                    })
                    if i == 4 then
                        inst.components.container:DropEverything()
                        inst:Remove()
                    end
                end)              
            end
            timer_inst:DoTaskInTime(10,timer_inst.Remove)

            -- inst:Remove()
        end)
    -------------------------------------------------------------------------------------
    ---- deployable_kit 放置的时候会触发，绑定去地皮中心
        inst:ListenForEvent("onbuilt",function()
            inst.Transform:SetPosition( TheWorld.Map:GetTileCenterPoint( inst.Transform:GetWorldPosition() ) )
        end)
    -------------------------------------------------------------------------------------

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- kit 物品

    local deployable_data = ------ 放置物品的inst的创建,MakeDeployableKitItem 调用的 fn
    {
        deploymode = DEPLOYMODE.CUSTOM,
        usedeployspacingasoffset = true,    ---- 绑定去标准位置（不一定是地皮中心）
        custom_candeploy_fn = function(inst, pt, mouseover, deployer)   --- 放置时候的检查fn
            -- -- -- print("+++++++++++",inst.Transform:GetWorldPosition())
            local x,y,z = TheWorld.Map:GetTileCenterPoint( pt.x,pt.y,pt.z )
            -------------------------------------------------
                local near_land_num = 0
                local near_land_pts = { Vector3(x-4,0,z) , Vector3(x+4,0,z),Vector3(x,0,z-4),Vector3(x,0,z+4) }
                for i, temp_pt in ipairs(near_land_pts) do
                    if TheWorld.Map:IsLandTileAtPoint(temp_pt.x,0,temp_pt.z) then
                        near_land_num = near_land_num + 1
                    end
                end
                if near_land_num < 2 and TheWorld.Map:IsOceanTileAtPoint(x,0,z) and TheWorld.Map:IsDeployPointClear2(Vector3(x,0,z),nil,1.5) then
                    return true
                end
            -------------------------------------------------
            return false

        end,

        master_postinit = function(inst)

            inst.components.inventoryitem.imagename = "fwd_in_pdt_fish_farm"
            inst.components.inventoryitem.atlasname = "images/map_icons/fwd_in_pdt_fish_farm.xml"


        end,
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- placer post init
    local function placer_postinit_fn(inst)
        if inst.components.placer then
            inst.components.placer.snap_to_tile = true
            inst.components.placer.override_testfn = function(inst)
                local x,y,z = inst.Transform:GetWorldPosition()               
                -------------------------------------------------
                --- 可放置
                    local near_land_num = 0
                    local near_land_pts = { Vector3(x-4,0,z) , Vector3(x+4,0,z),Vector3(x,0,z-4),Vector3(x,0,z+4) }
                    for i, temp_pt in ipairs(near_land_pts) do
                        if TheWorld.Map:IsLandTileAtPoint(temp_pt.x,0,temp_pt.z) then
                            near_land_num = near_land_num + 1
                        end
                    end
                    if near_land_num < 2 and TheWorld.Map:IsOceanTileAtPoint(x,0,z) and TheWorld.Map:IsDeployPointClear2(Vector3(x,0,z),nil,1.5) then
                        inst.components.placer.can_build = true
                        return true
                    end
                -------------------------------------------------
                inst.components.placer.can_build = false
                return false
            end
        end
        local scale = 0.6
        inst.AnimState:SetScale(scale, scale, scale)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("fwd_in_pdt_fish_farm", fn, assets),
    MakeDeployableKitItem("fwd_in_pdt_fish_farm_kit", "fwd_in_pdt_fish_farm", "fwd_in_pdt_fish_farm", "fwd_in_pdt_fish_farm", "item", assets, {size = "med", scale = 0.77}, nil, {fuelvalue = TUNING.LARGE_FUEL}, deployable_data),
        MakePlacer("fwd_in_pdt_fish_farm_kit_placer", "fwd_in_pdt_fish_farm", "fwd_in_pdt_fish_farm", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)