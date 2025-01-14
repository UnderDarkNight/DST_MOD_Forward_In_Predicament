----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
----------------------------------------------------------------------------------------------------------------------------------
---
    local function CreateWidget(self,player)
        -----------------------------------------------------------------
        --- 前置根节点
            local front_root = player.HUD
        -----------------------------------------------------------------
        ---
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(ANCHOR_MIDDLE)
            root:SetVAnchor(ANCHOR_MIDDLE)
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
            root:MoveToBack()
        -----------------------------------------------------------------
        --- 关闭检查
            local closing_flag = false
            root.inst:DoPeriodicTask(FRAMES*3,function()
                if (not self:Is_HUD_Activing() or self:GetOwner() == nil or not self.inst:IsValid()) and not closing_flag then
                    self:HUD_Deactive()
                    closing_flag = true
                end
            end)
        -----------------------------------------------------------------
        ---
            local old_root_Kill = root.Kill
            root.Kill = function(self)
                root.mask:GetAnimState():PlayAnimation("over_pst")
                TheFrontEnd:GetSound():PlaySound("meta4/wires_minigame/inspectacles/overlay_deactivate")
                root.mask.inst:ListenForEvent("animover",function()
                    old_root_Kill(self)
                end)
                root.pinger:Hide()
                root.inst:PushEvent("close")
            end
        -----------------------------------------------------------------
        -----------------------------------------------------------------
        ---
            local bg = root:AddChild(Widget())
            bg:SetClickable(false)
        -----------------------------------------------------------------
        --- 半透明遮罩层
            local mask = bg:AddChild(UIAnim())
            root.mask = mask
            mask:GetAnimState():SetBank("inspectacles_over")
            mask:GetAnimState():SetBuild("inspectacles_over")
            mask:GetAnimState():PlayAnimation("over_pre")
            mask:GetAnimState():PushAnimation("over_idle",false)
            TheFrontEnd:GetSound():PlaySound("meta4/wires_minigame/inspectacles/overlay_activate")
        -----------------------------------------------------------------
        --- 遮罩层显示完成后，推送事件给装备
            local mask_displayed = false
            mask.inst:ListenForEvent("animqueueover",function()
                if not mask_displayed then
                    mask_displayed = true
                    self.inst:PushEvent("hud_created",root)
                    mask:GetAnimState():PlayAnimation("over_idle",true)
                end
            end)
        -----------------------------------------------------------------
        --- 物品指示器。
            local pinger = bg:AddChild(UIAnim())
            root.pinger = pinger
            pinger:SetHAnchor(ANCHOR_LEFT)
            pinger:SetVAnchor(ANCHOR_BOTTOM)
            pinger:GetAnimState():SetBank("winona_inspectacles_fx")
            pinger:GetAnimState():SetBuild("winona_inspectacles_fx")
            pinger:GetAnimState():AnimateWhilePaused(false)
            pinger:GetAnimState():PlayAnimation("radar",true)
            pinger:Hide()
        -----------------------------------------------------------------
        --- 测试pinger
            pinger.inst:DoPeriodicTask(FRAMES*3,function()
                local target = self:GetPingerTarget()
                local target_pos = self:GetPingerTargetPos()
                -- print("target",target)
                if target == nil and target_pos == nil or closing_flag then
                    pinger:Hide()
                    return
                end
                local player = ThePlayer
                local tx,ty,tz = 0,0,0
                if target then
                    tx,ty,tz = target.Transform:GetWorldPosition()
                elseif target_pos then
                    tx,ty,tz = target_pos.x,target_pos.y,target_pos.z
                end
                if tx+ty+tz == 0 then
                    pinger:Hide()
                    return
                end

                local px,py,pz = player.Transform:GetWorldPosition()

                ---------------------------------------------------------------
                --- 目标在屏幕内，则隐藏pinger
                    local screen_target_x,screen_target_y = TheSim:GetScreenPos(tx,ty,tz) -- 左下角为原点。
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if screen_target_x > 0 and screen_target_y > 0 and screen_target_x < scrnw and screen_target_y < scrnh then
                        pinger:Hide()
                        return
                    end
                ---------------------------------------------------------------

                local x, y, angle = GetIndicatorLocationAndAngle(player, tx, tz, 0, 0, false)
                local sw, sh = TheSim:GetScreenSize()
                local angletocenter = math.atan2(y - sh * .5, x - sw * .5)
                local scale = pinger:GetScale()
                local r = 150
                x, y = x + r * math.cos(angletocenter) * scale.x, y + r * math.sin(angletocenter) * scale.y
                pinger:SetRotation(angle - 45)
                pinger:SetPosition(x, y)
                pinger:Show()
            end)
        -----------------------------------------------------------------
        ---
            -- self.inst:PushEvent("hud_created",root)
        -----------------------------------------------------------------
        ---
            return root
        -----------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher = Class(function(self, inst)
    self.inst = inst
    ----------------------------------------------------------------
    --- 
        self.hud = nil
        self.owner = nil
    ----------------------------------------------------------------
    --- 激活event
        inst:ListenForEvent("inspectacle_searcher_active",function(inst,_table)
            -- print("acitve with userid :" ,_table and _table.userid)
            if _table and _table.userid and ThePlayer and ThePlayer.userid == _table.userid then
                self.owner = ThePlayer
                self:HUD_Active(ThePlayer)
            end
        end)
        inst:ListenForEvent("inspectacle_searcher_deactive",function()
            self:HUD_Deactive()
            self.owner = nil
        end)
    ----------------------------------------------------------------
    ---
        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(1,function()
                if self:GetOwner() == nil then
                    self:SetPingerTargetPos(nil)
                end                
            end)
        end
    ----------------------------------------------------------------
end)
------------------------------------------------------------------------------------------------------------------------------
-- RPC信道
    function fwd_in_pdt_com_inspectacle_searcher:GetRPC()
        if ThePlayer and ThePlayer.replica.fwd_in_pdt_com_rpc_event then
            return ThePlayer.replica.fwd_in_pdt_com_rpc_event
        end
        return nil
    end
------------------------------------------------------------------------------------------------------------------------------
-- owner
    function fwd_in_pdt_com_inspectacle_searcher:GetOwner()
        if self.owner and self.owner:IsValid() then
            return self.owner
        end
        return nil
    end
------------------------------------------------------------------------------------------------------------------------------
--- HUD 激活
    function fwd_in_pdt_com_inspectacle_searcher:HUD_Active(doer)
        self:HUD_Deactive()
        self.__active_task = self.inst:DoPeriodicTask(0.1,function()
            if doer and doer.HUD and doer:HasTag("player") then            
                self.hud = CreateWidget(self,doer)
                self.HUD_Activing = true
                -- print("fake error : fwd_in_pdt_com_inspectacle_searcher created")
                -- ThePlayer.__test_hud = self.hud
            end
            if self.hud and self.hud.inst:IsValid() then
                self.__active_task:Cancel()
                self.__active_task = nil
            end
        end)

        
    end
    function fwd_in_pdt_com_inspectacle_searcher:HUD_Deactive()
        if self.__active_task then
            self.__active_task:Cancel()
            self.__active_task = nil
        end
        if self.hud then
            self.hud:Kill()
            self.hud = nil
        end
        self.HUD_Activing = false
    end
    function fwd_in_pdt_com_inspectacle_searcher:Is_HUD_Activing()
        return self.HUD_Activing
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher:SetPingerTarget(target)
        self.pinger_target = target
    end
    function fwd_in_pdt_com_inspectacle_searcher:GetPingerTarget()
        if self.pinger_target and self.pinger_target:IsValid() then
            return self.pinger_target
        end
        return nil
    end
    function fwd_in_pdt_com_inspectacle_searcher:SetPingerTargetPos(x_or_vect,y,z)
        if type(x_or_vect) == "table" and x_or_vect.x then
            self.pinger_target_pos = x_or_vect
        elseif x_or_vect and y and z then
            self.pinger_target_pos = Vector3(x_or_vect,y,z)
        else
            self.pinger_target_pos = nil
        end                
    end
    function fwd_in_pdt_com_inspectacle_searcher:GetPingerTargetPos()
        return self.pinger_target_pos
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher







