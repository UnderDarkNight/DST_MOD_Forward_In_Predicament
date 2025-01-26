--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
    local ScrollableList = require "widgets/scrollablelist"

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
    ----
        
    ----------------------------------------------------------------------------------------------------------------
    ----
        -- local inst = TheSim:FindFirstEntityWithTag("fwd_in_pdt_com_inspectacle_searcher_target")
        -- ThePlayer.Transform:SetPosition(inst.Transform:GetWorldPosition())

        -- inst.Submit = function()            
        -- end
        -- inst.RefreshClick = function(self)
        --     self.game_widget:Kill()
        --     self.game_widget = nil
        --     CreateGameWidget(self)
        -- end
        -- inst.inst = inst

        -- CreateGameWidget(inst)

        -- ThePlayer.AnimState:SetClientSideBuildOverrideFlag("fwd_in_pdt_building_inspectaclesbox_searching", true)

    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local item_list = {
        --     "fossil_piece","feather_canary","dreadstone","thulecite","marblebean",
        --     "cutstone","transistor","moonstorm_static_item","lavae_egg_cracked",
        --     "beeswax","slurtleslime","shroom_skin","dragon_scales","spidergland","beefalowool"
        -- }
        -- local prefab = item_list[math.random(#item_list)]
        -- local fx = SpawnPrefab("fwd_in_pdt_fx_catch_game_mark")
        -- fx.AnimState:PlayAnimation("idle2")
        -- fx.Transform:SetPosition(x,y,z)
        -- fx:DoTaskInTime(10,fx.Remove)

        -- local image_name = prefab..".tex"
        -- local atlas_name = GetInventoryItemAtlas(image_name)
        -- fx.AnimState:OverrideSymbol("SWAP_SIGN",atlas_name,image_name)
    ----------------------------------------------------------------------------------------------------------------
    --- 测试寻宝
        local inst = SpawnPrefab("fwd_in_pdt_building_inspectaclesbox_look_for_the_unique")
        inst.Transform:SetPosition(x,y,z)

        inst:DoTaskInTime(2,function()
            inst.components.fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetImageIndex(17)
        end)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))