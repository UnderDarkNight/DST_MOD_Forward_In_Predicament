--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 工作台
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_building_special_production_table"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_building_special_production_table.zip"),

    Asset( "IMAGE", "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.tex" ),    
    Asset( "ATLAS", "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml" ),

    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_building_special_production_table_punk.zip"),
    ---- 小地图图标 在 地图图标总表里注册

}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_building_special_production_table_punk"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_building_special_production_table_punk",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_building_special_production_table_punk",                  --- 制作完成后切换的 build
            name = "朋克火炉",                    --- 【制作栏】皮肤的名字
            minimap = "fwd_in_pdt_building_special_production_table_punk.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_building_special_production_table_punk.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_building_special_production_table_punk",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_building_special_production_table")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function Container_Widget_Setup(theContainer)
            -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_building_special_production_table_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    animbank = "fwd_in_pdt_building_special_production_table",
                    animbuild = "fwd_in_pdt_building_special_production_table",
                    animloop = true,
                    pos = Vector3(0, 170, 0),
                    side_align_tip = 160,
                    slotpos =
                    {
                        Vector3(30, 80, 0), Vector3(110, 80, 0), Vector3(190, 80, 0),
                        Vector3(30, 0, 0), Vector3(110, 0, 0), Vector3(190, 0, 0),
                        Vector3(30, -80, 0), Vector3(110, -80, 0), Vector3(190, -80, 0),
                        
                    },
                    slotbg =    --- 格子背景贴图
                    {
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                        { image = "fwd_in_pdt_building_special_production_table_widget_slot.tex" ,atlas = "images/widget/fwd_in_pdt_building_special_production_table_widget_slot.xml"},
                    },
                    buttoninfo =
                    {
                        text = STRINGS.ACTIONS.CRAFT,
                        position = Vector3(170, -150, 0),
                    }
                },

                type = "chest",
                acceptsstacks = true,                
            }

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
                return inst.replica.fwd_in_pdt_com_workable and inst.replica.fwd_in_pdt_com_workable:GetCanWorlk()
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
            Container_Widget_Setup(inst.components.container)

        else
            inst.OnEntityReplicated = function(inst)
                Container_Widget_Setup(inst.replica.container)
            end
        end
        -------------------------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 添加配方逻辑
    local function add_recipe_logic(inst)
        local tempfn = require("prefabs/06_fwd_in_pdt_containers/03_special_production_table_recipe_logic")
        if type(tempfn) == "function" then
            tempfn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 容器界面 hook
    local function HookContainerWidget(inst)
        inst:ListenForEvent("fwd_in_pdt_event.container_widget_open",function(_,container_widget)
            if container_widget then
                inst.___container_widget = container_widget
                local target_item_widget = container_widget:AddChild(UIAnim())
                target_item_widget:GetAnimState():SetBuild("fwd_in_pdt_building_special_production_table")
                target_item_widget:GetAnimState():SetBank("fwd_in_pdt_building_special_production_table")
                target_item_widget:GetAnimState():PlayAnimation("big_slot")
                target_item_widget:SetPosition(-180,0)
                
                inst.___target_item_widget = target_item_widget
            end
        end)
        inst:ListenForEvent("fwd_in_pdt_event.container_widget_close",function()
            if inst.___target_item_widget then
                inst.___target_item_widget:Kill()
                inst.___target_item_widget = nil
            end
        end)
        inst:ListenForEvent("target_widget_image",function(_,cmd_table)
            -- cmd_table = {
            --     num = 1,  --- 
            --     image = "",
            --     atlas = "",
            --     prefab = "",
            --     overwrite_str = "",
            -- }
            if inst.___target_item_widget then

                if inst.___target_item_widget.inside_icon ~= nil then
                    inst.___target_item_widget.inside_icon:Kill()
                end

                if type(cmd_table) == "table" and cmd_table.atlas and cmd_table.image then

                    inst.___target_item_widget.inside_icon = inst.___target_item_widget:AddChild(Image())
                    inst.___target_item_widget.inside_icon:SetTexture(cmd_table.atlas,cmd_table.image)
                    inst.___target_item_widget.inside_icon:SetScale(1.8,1.8,1.8)

                    local num = cmd_table.num or 1
                    local text_widget = inst.___target_item_widget.inside_icon:AddChild( Text(DEFAULTFONT,40,"100.42",{ 255/255 , 255/255 ,255/255 , 1}) )
                    text_widget:SetPosition(0,-60)
                    if cmd_table.overwrite_str then
                        text_widget:SetString(cmd_table.overwrite_str)
                    else
                        text_widget:SetString("= "..tostring(num).." x N")
                    end
                    if cmd_table.prefab then
                        local name_widget = inst.___target_item_widget.inside_icon:AddChild( Text(DEFAULTFONT,40,"100.42",{ 255/255 , 255/255 ,255/255 , 1}) )
                        name_widget:SetPosition(0,60)
                        name_widget:SetString(STRINGS.NAMES[string.upper(cmd_table.prefab)])
                    end

                end

            end

        end)

                    -- inst:ListenForEvent("itemget",function()
                    --     inst:PushEvent("target_widget_image",{
                    --         atlas = "images/map_icons/fwd_in_pdt_moom_jewelry_lamp.xml",
                    --         image = "fwd_in_pdt_moom_jewelry_lamp.tex",
                    --     })
                    -- end)
                    -- inst:ListenForEvent("itemlose",function()
                    --     inst:PushEvent("target_widget_image",{})
                    -- end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 工作组件
    local function Add_Workable(inst)

        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                return right_click                
            end)
            -- replica_com:SetSGAction("give")
            replica_com:SetText("fwd_in_pdt_building_special_production_table",STRINGS.ACTIONS.COMBINESTACK)
            replica_com:SetPreActionFn(function(inst,doer)
                inst.replica.container:Close()
                if doer then
                    local y = 2.7
                    if doer.replica.rider and doer.replica.rider:IsRiding() then
                        y = y + 2.5
                    end
                    doer:SpawnChild("fwd_in_pdt_fx_recipe_function"):PushEvent("Set",{
                        pt = Vector3(0,y,0),
                        speed = 0.8
                    })
                end
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                inst:PushEvent("recipe_work",doer)
                return true
            end)
            inst.components.fwd_in_pdt_com_workable:SetCanWorlk(false)

        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    -------------------------------------------------------------------------------------
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()

        inst.entity:AddSoundEmitter()

        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("fwd_in_pdt_building_special_production_table.tex")

        MakeObstaclePhysics(inst, .5)


        inst.AnimState:SetBank("fwd_in_pdt_building_special_production_table")
        inst.AnimState:SetBuild("fwd_in_pdt_building_special_production_table")
        inst.AnimState:PlayAnimation("idle",true)
        -- inst.AnimState:SetTime(math.random(800)/10)
        -- local scale = 0.6
        -- inst.AnimState:SetScale(scale, scale, scale)
        inst.DynamicShadow:SetSize(2, 2)


        inst:AddTag("structure")

        inst:AddTag("fwd_in_pdt_building_special_production_table")
        
        inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
        add_container_before_not_ismastersim_return(inst)   --- 添加容器组件和界面
        HookContainerWidget(inst)                           --- hook 界面 添加对应的贴图
        add_recipe_logic(inst)                              --- 配方扫描逻辑
    -------------------------------------------------------------------------------------
    ---- 批量采摘的动作
        Add_Workable(inst)
    -------------------------------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_building_special_production_table","fwd_in_pdt_building_special_production_table","fwd_in_pdt_building_special_production_table.tex")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")

        end
    -------------------------------------------------------------------------------------


    if not TheWorld.ismastersim then
        return inst
    end
   

    inst:AddComponent("inspectable")

    -------------------------------------------------------------------------------------
    ---- 东西放进去、拿出来
        
        -- inst:ListenForEvent("itemget",function(_,_table)
        --     inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")

        --         if _table and _table.item then      ---- 停止腐烂计算
        --             local tempItem = _table.item
        --             if tempItem.components.perishable then
        --                 tempItem.components.perishable:StopPerishing()
        --             end
        --         end

        -- end)
        -- inst:ListenForEvent("itemlose",function(inst,_table)    
        --     inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")

        --             if _table and _table.prev_item then  --- 恢复腐烂计算
        --                 local tempItem = _table.prev_item
        --                 if tempItem.components.perishable then
        --                     tempItem.components.perishable:StartPerishing()
        --                 end
        --             end
                    
        -- end)
    -------------------------------------------------------------------------------------
    
    -------------------------------------------------------------------------------------
    ---- 被敲打拆除
        inst:AddComponent("lootdropper")---这个才能让官方的敲击实现掉落一半
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        -- inst.components.workable:SetOnWorkCallback(onhit)
        inst.components.workable:SetOnFinishCallback(function()
            inst.components.lootdropper:DropLoot()----这个才能让官方的敲击实现掉落一半
            if inst.components.container then
                inst.components.container:DropEverything()
            end
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst:Remove()
        end)
    -------------------------------------------------------------------------------------
    ---- 玩家建造后给一本说明书
        inst.OnBuiltFn = function(self,builder)
            if builder and builder.components.fwd_in_pdt_func then
                builder.components.fwd_in_pdt_func:GiveItemByPrefab("fwd_in_pdt_item_formulated_crystal")
            end
        end
    -------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------

    return inst
end

return Prefab("fwd_in_pdt_building_special_production_table", fn, assets),
        MakePlacer("fwd_in_pdt_building_special_production_table_placer", "fwd_in_pdt_building_special_production_table", "fwd_in_pdt_building_special_production_table", "idle")