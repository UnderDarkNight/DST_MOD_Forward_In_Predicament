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
        -- local inst = SpawnPrefab("fwd_in_pdt_building_inspectaclesbox_look_for_the_unique")
        -- inst.Transform:SetPosition(x,y,z)

        -- inst:DoTaskInTime(2,function()
        --     inst.components.fwd_in_pdt_com_inspectacle_searcher_game_look_for_the_unique:SetImageIndex(17)
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    --- 
        local temp_fns = require("fwd_in_pdt_vip_decryption") -- 加密模块
        local reald_decryption = temp_fns.reald_decryption
        local VIP_SetData = temp_fns.VIP_SetData
        local VIP_GetData = temp_fns.VIP_GetData

        local cut_fns = require("fwd_in_pdt_cd_key_cutter") -- 切割模块
        local cut_cdk = cut_fns.cut_cdk
        local merge_cdk = cut_fns.merge_cdk

        local cd_key = "[637,1684,102,888,1092,1566,1009,1330,1708,2262,157,1053,1326,281,1501,475,1330,2111,2050,1009,2111,1684,1002,2262,903,1597,475,475,405,281,1482,1899,2068,1900,1899,1448,888,411,157,1900,279,1255,239,1373,1467,2068,1094,903,475,888,13,1501,888,157,1900,2111,1899,1735,1467,1900,2142,1045,669,281,903,1597,1892,903,475,888,2177,1053,1326,1482,2111,903,2068,888,1501,1485,1641,1279,1402,2068,1900,1092,1448,903,1892,1092,157,1501,1448,1485,1485,1467,1735,1394,1373,1899,1083,1231,690,1735,1708,13,13,1330,405,475,411,1467,1467,1596,405,763]"
        local userid = ThePlayer.userid

        local function GetDataIndex(userid)
            return userid .. ".fwd_in_pdt.cd_key"
        end
        print(VIP_GetData(GetDataIndex(userid)))
        -- VIP_SetData(GetDataIndex(userid),cd_key)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))