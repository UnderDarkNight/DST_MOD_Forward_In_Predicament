----------------------------------------------------------------------------------------------------------------------------------
--[[

    TEST 函数和 建筑 标记

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 模块基础
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
----------------------------------------------------------------------------------------------------------------------------------

TUNING.FWD_IN_PDT_DECORATION_FN = TUNING.FWD_IN_PDT_DECORATION_FN or {}
----------------------------------------------------------------------------------------------------------------------------------
---
    local mark_fn_list = {
        -----------------------------------------------------------
        --- 猪屋
            ["pighouse"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("pig_house")
                building:GetAnimState():SetBuild("pig_house")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 兔子房
            ["rabbithouse"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("rabbithouse")
                building:GetAnimState():SetBuild("rabbit_house")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 帐篷
            ["tent"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("tent")
                building:GetAnimState():SetBuild("tent")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 遮阳帐篷
            ["siestahut"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("siesta_canopy")
                building:GetAnimState():SetBuild("siesta_canopy")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 沃尔特帐篷
            ["portabletent"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("tent_walter")
                building:GetAnimState():SetBuild("tent_walter")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 一本科技
            ["researchlab"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("researchlab")
                building:GetAnimState():SetBuild("researchlab")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 二本
            ["researchlab2"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("researchlab2")
                building:GetAnimState():SetBuild("researchlab2")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- 锯马
            ["carpentry_station"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("carpentry_station")
                building:GetAnimState():SetBuild("carpentry_station")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 假人
            ["sewing_mannequin"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("sewing_mannequin")
                building:GetAnimState():SetBuild("sewing_mannequin")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 绚丽之门
            ["multiplayer_portal"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("portal_dst")
                building:GetAnimState():SetBuild("portal_stone")
                building:GetAnimState():PlayAnimation("idle_loop",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 天体传送门
            ["multiplayer_portal_moonrock"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("portal_moonrock_dst")
                building:GetAnimState():SetBuild("portal_moonrock")
                building:GetAnimState():PlayAnimation("idle_loop",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 蘑菇灯
            ["mushroom_light"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("mushroom_light")
                building:GetAnimState():SetBuild("mushroom_light")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 三本
            ["researchlab4"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("researchlab4")
                building:GetAnimState():SetBuild("researchlab4")
                building:GetAnimState():PlayAnimation("proximity_loop",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 健身房
            ["mighty_gym"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("mighty_gym")
                building:GetAnimState():SetBuild("mighty_gym")
                building:GetAnimState():PlayAnimation("idle_empty",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 蜘蛛巢
            ["spiderden"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("spider_cocoon")
                building:GetAnimState():SetBuild("spider_cocoon")
                building:GetAnimState():PlayAnimation("cocoon_small",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
            --- 四本
            ["researchlab3"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("researchlab3")
                building:GetAnimState():SetBuild("researchlab3")
                building:GetAnimState():PlayAnimation("proximity_loop",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
             --- 避雷针
             ["lightning_rod"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("lightning_rod")
                building:GetAnimState():SetBuild("lightning_rod")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 1
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --     --- 雪人
        --     ["snowman"] = function(mark)
        --         local building = mark:AddChild(UIAnim())
        --         building:GetAnimState():SetBank("snowball")
        --         building:GetAnimState():SetBuild("snowball")
        --         building:GetAnimState():PlayAnimation("idle",true)
        --         local scale = 1
        --         building:SetScale(scale,scale,scale)
        --         building:SetClickable(false)
        --     end,
        -- -----------------------------------------------------------
                    
    }

----------------------------------------------------------------------------------------------------------------------------------
function TUNING.FWD_IN_PDT_DECORATION_FN:Test(prefab)
    return mark_fn_list[prefab] ~= nil
end
function TUNING.FWD_IN_PDT_DECORATION_FN:MarkBuilding(mark,prefab)
    if mark_fn_list[prefab] ~= nil then
        mark_fn_list[prefab](mark)
    end
end