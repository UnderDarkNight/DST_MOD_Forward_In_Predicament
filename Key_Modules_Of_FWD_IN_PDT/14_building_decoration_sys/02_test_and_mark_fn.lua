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
                local scale = 2
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
                local scale = 2
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
                local scale = 2
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
                local scale = 2
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
                local scale = 2
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
        --- researchlab 科技
            ["researchlab"] = function(mark)
                local building = mark:AddChild(UIAnim())
                building:GetAnimState():SetBank("researchlab")
                building:GetAnimState():SetBuild("researchlab")
                building:GetAnimState():PlayAnimation("idle",true)
                local scale = 2
                building:SetScale(scale,scale,scale)
                building:SetClickable(false)
            end,
        -----------------------------------------------------------
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