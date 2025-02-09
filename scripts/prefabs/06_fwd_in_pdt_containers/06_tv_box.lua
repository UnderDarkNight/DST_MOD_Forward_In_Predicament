----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    电视机

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_container_tv_box.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_container_tv_box_laser.zip"),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_container_tv_box"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_container_tv_box_laser"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_container_tv_box_laser",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_container_tv_box_laser",                  --- 制作完成后切换的 build
            name = "投影仪",                    --- 【制作栏】皮肤的名字
            name_color = {0/255,250/255,250/255,255/255},
            minimap = "fwd_in_pdt_container_tv_box_laser.tex",                --- 小地图图标
            atlas = "images/map_icons/fwd_in_pdt_container_tv_box_laser.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_container_tv_box_laser",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_container_tv_box")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_container_tv_box_widget"

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
            -- inst.components.container.openlimit = 1  ---- 限制1个人打开
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
--- 显示图标 event
local function pic_display_event(inst)
    inst:ListenForEvent("pic_display",function()

        ---- 暂时没法 给MOD 物品用
        local tar_atlas = nil
        local tar_image = nil
        for num, temp_item in pairs(inst.components.container.slots) do
            if temp_item and temp_item:IsValid() then
                    local imagename = temp_item.nameoverride or temp_item.components.inventoryitem.imagename or temp_item.prefab
                    imagename  = string.gsub(imagename,".tex", "") .. ".tex"
                    local atlasname = temp_item.components.inventoryitem.atlasname or GetInventoryItemAtlas(imagename)
                    if TheSim:AtlasContains(atlasname, imagename) then
                        --- 官方物品
                        tar_atlas = atlasname
                        tar_image = imagename
                        -- break
                    else
                        --- 自定义MOD物品
                        atlasname = GetInventoryItemAtlas(imagename)
                        atlasname = resolvefilepath_soft(atlasname) --为了兼容mod物品，不然是没有这道工序的
                        tar_atlas = atlasname
                        tar_image = imagename
                        -- break
                    end
                    if tar_atlas and tar_image and TheSim:AtlasContains(tar_atlas, tar_image) then
                        break
                    end
                    
            end
        end

        -- print("tar_atlas",tar_atlas)
        -- print("tar_image",tar_image)

        if tar_image and tar_atlas then
            inst.AnimState:OverrideSymbol("SWAP_SIGN",tar_atlas,tar_image)
        else
            inst.AnimState:ClearOverrideSymbol("SWAP_SIGN")
        end

    end)

    inst:DoTaskInTime(0,function()
        inst:PushEvent("pic_display")
    end)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()


    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("fwd_in_pdt_container_tv_box.tex")
    
    inst.AnimState:SetBank("fwd_in_pdt_container_tv_box")
    inst.AnimState:SetBuild("fwd_in_pdt_container_tv_box")
    inst.AnimState:PlayAnimation("idle",true)

    -- local scale = 1.5
    -- inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("structure")
    inst:AddTag("chest")
    inst:AddTag("fwd_in_pdt_container_tv_box")

    -- inst:AddComponent("container")
    -- inst.components.container:EnableInfiniteStackSize(true) -- 无限堆叠

    inst.entity:SetPristine()

    add_container_before_not_ismastersim_return(inst)
    -------------------------------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_container_tv_box","fwd_in_pdt_container_tv_box","fwd_in_pdt_container_tv_box.tex")
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable") --可检查组件
    -----------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------
        pic_display_event(inst)
    -----------------------------------------------------------------------------------
    -- inst.components.container
    local function onopen(inst)

        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    local function onclose(inst)

        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        inst:PushEvent("pic_display")

    end
    -----------------------------------------------------------------------------------
    local function onbuilt(inst)

        inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
        
    end
    -----------------------------------------------------------------------------------

    local function onhit(inst, worker)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end

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
        inst.components.workable:SetOnWorkCallback(onhit)
        
        inst.components.workable:SetOnFinishCallback(function()
            inst.components.lootdropper:DropLoot()
            inst.components.container:DropEverything()
            SpawnPrefab("fwd_in_pdt_fx_explode"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition())
            })
            inst:Remove()
        end)
        -- container组件 官方的写法是在  TheWorld.ismastersim then 的后面

        inst:AddComponent("container")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container:EnableInfiniteStackSize(true) -- 无限堆叠
    -----------------------------------------------------------------------------------
        inst:ListenForEvent("onbuilt", onbuilt) -- 建立回调
    -----------------------------------------------------------------------------------
    return inst
end
-----------------------------------------------------------------------------------------------
    local function placer_postinit_fn(inst)
        -- local scale = 1.5
        -- inst.AnimState:SetScale(scale,scale,scale)
        inst.AnimState:Hide("SNOW")
    end
-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_container_tv_box", fn,assets),
        MakePlacer("fwd_in_pdt_container_tv_box_placer", "fwd_in_pdt_container_tv_box", "fwd_in_pdt_container_tv_box", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)