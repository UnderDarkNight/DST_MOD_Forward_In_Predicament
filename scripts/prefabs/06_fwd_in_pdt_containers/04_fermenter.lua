--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 发酵缸
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_fermenter"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_fermenter.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_building_fermenter_honey.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_building_fermenter_honey"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_building_fermenter_honey",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_building_fermenter_honey",                  --- 制作完成后切换的 build
            name = "Honey",                    --- 【制作栏】皮肤的名字
            name_color = {255/255,185/255,15/255,255/255},
            minimap = "fwd_in_pdt_building_fermenter_honey.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_building_fermenter_honey.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_building_fermenter_honey",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_building_fermenter")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 读取配方
local recipes = require("prefabs/06_fwd_in_pdt_containers/04_fermenter_recipes") or {}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面安装组件
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_building_fermenter_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {  
                widget =
                {
                    slotpos = {},
                    animbank = "ui_woby_3x3",
                    animbuild = "ui_woby_3x3",
                    pos = Vector3(0, 200, 0),
                    side_align_tip = 160,
                    buttoninfo =
                    {
                        text = GetStringsTable()["action_str"],
                        position = Vector3(110, -130, 0),
                    }
                },
            type = "chest",
            acceptsstacks = true,              ---- 是否允许叠堆
            }
            --- 插入格子
            for y = 2, 0, -1 do
                for x = 0, 2 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
                end
            end
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    -- print("test fn",item)
                    if item and item.prefab then
                        if recipes[item.prefab] then
                            return true
                        end
                        ---- 让生成的产品也能放进缸里
                        for index_prefab, cmd_table in pairs(recipes) do
                            if cmd_table and cmd_table.product == item.prefab then
                                return true
                            end
                        end
                    end
                    
                    return false
                end
            ------------------------------------------------------------------------------------------
            ---- 按钮激活和操作
                params[container_widget_name].widget.buttoninfo.fn = function(inst,doer)
                    if inst.components.container ~= nil then
                        -- BufferedAction(doer, inst, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION):Do()  --- 太直接了，没任何动画直接生成物品
                        doer.components.playercontroller:DoAction(BufferedAction(doer, inst, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION))
                    elseif inst.replica.container ~= nil then
                        ---- 带洞穴直接用这句就正常
                        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION.code, inst, ACTIONS.FWD_IN_PDT_COM_WORKABLE_ACTION.mod_name)
                    end
                end
                params[container_widget_name].widget.buttoninfo.validfn = function(inst)
                    return inst.components.fwd_in_pdt_com_workable and inst.components.fwd_in_pdt_com_workable:GetCanWorlk()
                    -- return true
                end
            ------------------------------------------------------------------------------------------
        end
    
        theContainer:WidgetSetup(container_widget_name)

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

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 发酵系统安装
    local function fermenter_sys_setup(inst)
        -----------------------------------------------------------------------------
        ----- 添加辅助组件
            -- inst:AddComponent("fwd_in_pdt_func"):Init("normal_api")

        -----------------------------------------------------------------------------
        ---------- 放进去的东西停止保鲜度
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
                        -- tempItem.components.perishable:SetPercent(1)
                    end
                end
            end)
        -----------------------------------------------------------------------------
        ----- can work check
            local function check_can_work(inst)
                for index_prefab, v in pairs(recipes) do
                    if inst.components.container:Has(index_prefab,1) then
                        inst.components.fwd_in_pdt_com_workable:SetCanWorlk(true)
                        return true
                    end
                end
                inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
                return false
            end
            inst:ListenForEvent("itemget",check_can_work)
            inst:ListenForEvent("itemlose",check_can_work)
        -----------------------------------------------------------------------------
        ----- 旗子
            inst:ListenForEvent("HideFlag",function()
                inst.AnimState:Hide("FLAG")
            end)
            inst:ListenForEvent("ShowFlag",function()
                inst.AnimState:Show("FLAG")
            end)
            inst:ListenForEvent("fermenter_sys_start",function()    --- 开始发酵的时候隐藏旗子
                inst:PushEvent("HideFlag")
            end)
            inst:ListenForEvent("fermenter_sys_end",function()      --- 完成发酵的时候显示旗子
                inst:PushEvent("ShowFlag")
                inst.components.fwd_in_pdt_data:Set("flag",true)    --- 记录一下，给存档重载的时候
            end)
            inst:ListenForEvent("onopen",function()     --- 玩家打开查看过，不再需要显示旗子
                inst:PushEvent("HideFlag")
                inst.components.fwd_in_pdt_data:Set("flag",false)    --- 记录一下，给存档重载的时候
            end)
            inst:DoTaskInTime(0,function()  --- 存档重载的时候，检查是否需要显示旗子
                if inst.components.fwd_in_pdt_data:Get("flag") then
                    inst:PushEvent("ShowFlag")
                else
                    inst:PushEvent("HideFlag")
                end
            end)

        -----------------------------------------------------------------------------
        ----- 开始执行任务
            inst:ListenForEvent("fermenter_sys_start",function()
                inst.components.fwd_in_pdt_data:Set("start",true)   --- 上锁
                inst.components.fwd_in_pdt_data:Set("days",0)       --- 清空天数
                inst.components.container.canbeopened = false       --- 不允许继续打开

                ----- 清空物品，并生成列表
                local function get_stack_num(item)
                    if item.components.stackable then
                        return item.components.stackable.stacksize
                    else
                        return 1
                    end
                end
                local productions_list = {}   --- 最终产品表
                ----- 遍历每个物品，添加对应数据进表格并删除item_inst
                    inst.components.container:ForEachItem(function(item)
                        if item and item.prefab then
                            if recipes[item.prefab] then
                                local num = get_stack_num(item)
                                local product_num = recipes[item.prefab].num * num
                                local product_prefab = recipes[item.prefab].product
                                productions_list[product_prefab] = productions_list[product_prefab] or 0    --- 初始化计数器
                                productions_list[product_prefab] = productions_list[product_prefab] + product_num   -- 产品总个数
                            else
                                productions_list[item.prefab] = productions_list[item.prefab] or 0
                                productions_list[item.prefab] = productions_list[item.prefab] + get_stack_num(item) 
                            end
                            item:Remove()
                        end
                    end)

                inst.components.fwd_in_pdt_data:Set("productions_list",productions_list)    --- 储存表格

            end)
            inst:ListenForEvent("fermenter_sys_end",function()
                inst.components.fwd_in_pdt_data:Set("start",false)  --- 解锁
                inst.components.container.canbeopened = true       --- 允许打开

                local productions_list = inst.components.fwd_in_pdt_data:Get("productions_list") or {}
                for prefab_name, num in pairs(productions_list) do
                    if prefab_name and num then
                        inst.components.fwd_in_pdt_func:GiveItemByName(prefab_name,num)
                    end
                end
                inst.components.fwd_in_pdt_data:Set("productions_list",nil) --- 清空记录
            end)
            inst:DoTaskInTime(0,function()  --- 加载的时候检查，避免意外启动
                if inst.components.fwd_in_pdt_data:Get("start") or inst:HasTag("burnt") then
                    --- 禁止重复执行开始动作
                        inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
                    --- 发酵期间禁止打开
                        if inst.components.container then   
                            inst.components.container.canbeopened = false
                        end
                end
            end)

        -----------------------------------------------------------------------------
        --- 发酵天数
            local days = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 2 or 15
            inst.components.fwd_in_pdt_data:Set("cycle_days",days)  --- 储存一下 发酵总时间，方便外部调用
            inst:WatchWorldState("cycles", function()
                if inst:HasTag("burnt") then
                    return
                end
                if not inst.components.fwd_in_pdt_data:Get("start") then
                    return
                end
                if inst.components.fwd_in_pdt_data:Add("days",1) >= days then -- 天数达到
                    inst:PushEvent("fermenter_sys_end")
                end
            end)
        -----------------------------------------------------------------------------
        --- 发酵期间拆除(给腐烂的食物，里面全损失)
            inst:ListenForEvent("_building_remove",function()
                if inst:HasTag("burnt") then
                    return
                end
                if not inst.components.fwd_in_pdt_data:Get("start") then
                    return
                end
                local productions_list = inst.components.fwd_in_pdt_data:Get("productions_list") or {}
                local num = 0
                for index_prefab, temp_num in pairs(productions_list) do
                    if index_prefab and temp_num then
                        num = num + temp_num
                    end
                end
                inst.components.fwd_in_pdt_func:Throw_Out_Items({
                        --     target = Vector3() or Inst , or nil
                        name = "spoiled_food",
                        num = math.random(num),    -- default
                        range = 3,
                })
            end)
        -----------------------------------------------------------------------------
        
    end
    local function fermenter_workable_com_setup(inst)
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
            return right_click
        end)
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
            -----------------------------
            inst.components.container:Close()
            inst:PushEvent("fermenter_sys_start")
            -----------------------------
            return true
        end)
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_building_fermenter",GetStringsTable()["action_str"])
        
        inst.components.fwd_in_pdt_com_workable:SetPreActionFn(function(inst,doer)
            inst.replica.container:Close()
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

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_fermenter.tex")


    inst.AnimState:SetBank("fwd_in_pdt_building_fermenter")
    inst.AnimState:SetBuild("fwd_in_pdt_building_fermenter")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")


    inst.entity:SetPristine()
    ----------------------------------------------------------------
    --- 添加容器界面
        add_container_before_not_ismastersim_return(inst)
    ----------------------------------------------------------------
    --- 添加交互动作
        fermenter_workable_com_setup(inst)
    ----------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_building_fermenter","fwd_in_pdt_building_fermenter","fwd_in_pdt_building_fermenter.tex")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin","normal_api")
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fwd_in_pdt_data")
    ----------------------------------------------------------------
    ---- 玩家检查说的话
        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = function()
            if inst:HasTag("burnt") then
                return GetStringsTable()["inspect_str_burnt"]
            else
                return GetStringsTable()["inspect_str"]
            end
        end
    ----------------------------------------------------------------
    ----- 玩家靠近
        
    ----------------------------------------------------------------
    --- 敲打拆除
        inst:ListenForEvent("_building_remove",function()
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst:Remove()
        end)
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(function()
            if inst.components.container then
                inst.components.container:DropEverything()
            end
            inst:PushEvent("_building_remove")
        end)
        inst.components.workable:SetOnWorkCallback(function()
            if not inst:HasTag("burnt") then
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("idle",true)
            else
                inst:PushEvent("_building_remove")
            end
        end)    
    --------------------------------------------------------
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
            end
        end)
        inst:ListenForEvent("onburnt",function()
            inst:RemoveComponent("container")
        end)
    --------------------------------------------------------
    ---- 玩家刚刚完成建造
        inst:ListenForEvent("onbuilt", function()
            inst.AnimState:PlayAnimation("place")
            inst.AnimState:PushAnimation("idle",true)
        end)

    --------------------------------------------------------
        fermenter_sys_setup(inst)
    --------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_building_fermenter", fn, assets),
        MakePlacer("fwd_in_pdt_building_fermenter_placer", "fwd_in_pdt_building_fermenter", "fwd_in_pdt_building_fermenter", "idle")