-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    inventory_classified 添加event ,用来对 物品 pushevent

    物品 带 tag  fwd_in_pdt_tag.cursor_sight 就能激活

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local cursor_sight = nil
    local inventorybar = nil
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 指示器
    local function CreateCursorSight()
        local front_root = ThePlayer and ThePlayer.HUD
        if front_root == nil then
            return
        end
        local root = front_root:AddChild(Widget())
        root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        root:SetPosition(0,0)
        root:SetScaleMode(SCALEMODE_NONE)   --- 缩放模式
        root:Disable()

        local cursor_sight = root:AddChild(UIAnim())
        cursor_sight:GetAnimState():SetBank("fwd_in_pdt_active_item_cursor_sight")
        cursor_sight:GetAnimState():SetBuild("fwd_in_pdt_active_item_cursor_sight")
        cursor_sight:GetAnimState():PlayAnimation("idle_"..math.random(1,2),true)

        -- root.inst:DoPeriodicTask(FRAMES,function()
            
        -- end)
        cursor_sight:FollowMouse()
        return cursor_sight
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- inventorybar
    local task_inst = CreateEntity()
    local function StartIconHiddingTask(self)
        if task_inst._____cursor_sight_hidding_task == nil then
            task_inst._____cursor_sight_hidding_task = self.inst:DoPeriodicTask(0.5, function()
                -- if self.hovertile then
                --     self.hovertile:Hide()
                -- end
                if self.hovertile.image and self.hovertile.image.SetTint then
                    self.hovertile.image:SetTint(1,1,1,0.2)
                end
            end)
        end
    end
    local function StopHiddingTask(self)
        if task_inst._____cursor_sight_hidding_task ~= nil then
            task_inst._____cursor_sight_hidding_task:Cancel()
            task_inst._____cursor_sight_hidding_task = nil
            -- if self.hovertile then
            --     self.hovertile:Show()
            -- end
            if self.hovertile.image and self.hovertile.image.SetTint then
                self.hovertile.image:SetTint(1,1,1,1)
            end
        end
    end
    AddClassPostConstruct("widgets/inventorybar",function(self)
        inventorybar = self

        local old_OnNewActiveItem = self.OnNewActiveItem
        self.OnNewActiveItem = function(self,item,...)
            if item == nil or not item:HasTag("fwd_in_pdt_tag.cursor_sight") then
                if cursor_sight then
                    cursor_sight:Kill()
                    cursor_sight = nil
                end
                StopHiddingTask(self)
            elseif item and item:HasTag("fwd_in_pdt_tag.cursor_sight") and cursor_sight == nil then
                cursor_sight = CreateCursorSight()
                StartIconHiddingTask(self)
            end
            return old_OnNewActiveItem(self,item,...)
        end
    end)

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --- inventory_classified
--     local function Kill_Cursor_Sight()
--         if cursor_sight then
--             cursor_sight:Kill()
--             cursor_sight = nil
--         end
--         ShowActiveItemIcon()
--     end
--     local function Active_Cursor_Sight()
--         if cursor_sight then
--             cursor_sight:Kill()
--         end
--         cursor_sight = CreateCursorSight()
--         HideActiveItemIcon()
--     end
--     AddPrefabPostInit(
--         "inventory_classified",
--         function(inst)
--             if TheNet:IsDedicated() then
--                 return
--             end
--             local last_acitve_item = nil
--             inst:ListenForEvent("activedirty",function()
--                 local current_item = inst._active:value()
--                 --- 如果当前物品为空，则销毁光标
--                 if current_item == nil then
--                     Kill_Cursor_Sight()
--                     last_acitve_item = nil
--                     return
--                 end
--                 --- 如果当前物品不为空，则创建光标
--                 if current_item and current_item ~= last_acitve_item then
--                     --- 如果上一个物品不为空，则销毁上一个物品的event
--                     if last_acitve_item ~= nil then
--                         -- last_acitve_item:PushEvent("hoshino_event.inventory_classified_deactive_item")
--                         if not last_acitve_item:HasTag("fwd_in_pdt_tag.cursor_sight") then
--                             Kill_Cursor_Sight()
--                         end
--                     end

--                     -- current_item:PushEvent("hoshino_event.inventory_classified_active_item")
--                     if current_item:HasTag("fwd_in_pdt_tag.cursor_sight") then
--                         Active_Cursor_Sight()
--                     end
--                     --- 记忆上一个物品
--                     last_acitve_item = current_item
--                 end
                
--             end)
--         end
--     )
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
