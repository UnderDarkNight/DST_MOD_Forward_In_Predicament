----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    钱包

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_container_wallet.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_container_wallet.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_container_wallet.xml" ),

    --- 皮肤
    Asset("ANIM", "anim/fwd_in_pdt_container_wallet_piggy.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_container_wallet_piggy.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_container_wallet_piggy.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetStringsTable(name)
        local prefab_name = name or "fwd_in_pdt_container_wallet"
        local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
        return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data = {
        ["fwd_in_pdt_container_wallet_piggy"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_container_wallet_piggy",                   --- 制作完成后切换的 bank
            build = "fwd_in_pdt_container_wallet_piggy",                  --- 制作完成后切换的 build
            name = GetStringsTable()["skin.piggy"],                    --- 【制作栏】皮肤的名字
            name_color = {255/255,182/255,193/255,255/255},
            atlas = "images/inventoryimages/fwd_in_pdt_container_wallet_piggy.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_container_wallet_piggy",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
        },

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_container_wallet")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function item_test_fn(item)
        local item_prefabs = {
            ["fwd_in_pdt_item_jade_coin_green"] = true,
            ["fwd_in_pdt_item_jade_coin_black"] = true,
            ["goldnugget"] = true,
            ["lucky_goldnugget"] = true,
        }
        if item and  item_prefabs[item.prefab] then
            return true
        else
            return false
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "fwd_in_pdt_container_wallet_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {
                        Vector3(-37.5, 32 + 4, 0),
                        Vector3(37.5, 32 + 4, 0),
                        Vector3(-37.5, -(32 + 4), 0),
                        Vector3(37.5, -(32 + 4), 0),
                    },
                    animbank = "ui_chest_2x2",
                    animbuild = "ui_chest_2x2",
                    pos = Vector3(0, -180, 0),
                    side_align_tip = 160,
                },
                type = "chest",
                acceptsstacks = true,                
            }

            -- for y = 2.5, -0.5, -1 do
            --     for x = -1, 3 do
            --         table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
            --     end
            -- end
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return item_test_fn(item)
                    -- return true
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_container_wallet")
    inst.AnimState:SetBuild("fwd_in_pdt_container_wallet")
    inst.AnimState:PlayAnimation("idle",true)
    -- local scale = 2
    -- inst.AnimState:SetScale(scale, scale, scale)

    inst:AddTag("fwd_in_pdt_container_wallet")

    inst.entity:SetPristine()

    add_container_before_not_ismastersim_return(inst)
    -------------------------------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_container_wallet","fwd_in_pdt_container_wallet")

        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_container_wallet","images/inventoryimages/fwd_in_pdt_container_wallet.xml")
            inst.components.inventoryitem.cangoincontainer = true

            inst:AddComponent("named")
            inst.components.named:SetName_fwd_in_pdt(GetStringsTable()["name"])
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

        inst:AddComponent("inspectable") --可检查组件


    -----------------------------------------------------------------------------------
        -- inst:AddComponent("inventoryitem")
        -- -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        -- inst.components.inventoryitem.imagename = "fwd_in_pdt_item_orthopedic_water"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_orthopedic_water.xml"
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    MakeHauntableLaunch(inst)

    -------------------------------------------------------------------
    return inst
end
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_container_wallet", fn,assets)