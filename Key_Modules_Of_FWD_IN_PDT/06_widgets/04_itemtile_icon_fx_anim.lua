------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品栏的图标上覆盖特效的组件
--- 【废弃】需要hook 的函数  StartDrag  Refresh  UpdateTooltip  SetIsEquip
--- 【笔记】不需要hook 那么多函数了，每次放入到新的地方 都是会重新创建 itemtile，在主程序直接初始化检查所有就行。
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
    return
end

local UIAnim = require "widgets/uianim"
AddClassPostConstruct("widgets/itemtile",function(self)

    ----------------------------------------------------------------------------------------------
    --- 添加基础函数,官方没封装API，坑死人
    function self:fwd_in_pdt_StartUpdating(flag)
        if next(self.updatingflags) == nil then
            self:StartUpdating()
        end
        self.updatingflags[flag] = true
    end
    function self:fwd_in_pdt_StopUpdating(flag)
        self.updatingflags[flag] = nil
        if next(self.updatingflags) == nil then
            self:StopUpdating()
        end
    end
    ----------------------------------------------------------------------------------------------
    --- 需要hook 的函数  StartDrag  Refresh  UpdateTooltip  SetIsEquip
    ----------------------------------------------------------------------------------------------
    self.__fwd_in_pdt_fx = nil    --- 动画组件
    ----------------------------------------------------------------------------------------------
                    -- - hook OnUpdate ,数据一更新能立马更新动画 【这个暂时不需要HOOK】
                    -- self.OnUpdate__fwd_in_pdt_old = self.OnUpdate
                    -- self.OnUpdate = function(self,...)     
                    --     -- print("info OnUpdate")   
                    --     self:start_fwd_in_pdt_fx_check()
                    --     return self:OnUpdate__fwd_in_pdt_old(...)
                    -- end
    -- --------------------------------------------------------------------------------------------
    -- -- - hook Refresh ,数据一更新能立马更新动画
    -- self.Refresh__fwd_in_pdt_old = self.Refresh
    -- self.Refresh = function(self,...)       
    --     -- print("info Refresh") 
    --     self:start_fwd_in_pdt_fx_check()
    --     return self:Refresh__fwd_in_pdt_old(...)
    -- end
    -- --------------------------------------------------------------------------------------------
    -- -- hook UpdateTooltip ,数据一更新能立马更新动画
    -- self.UpdateTooltip__fwd_in_pdt_old = self.UpdateTooltip
    -- self.UpdateTooltip = function(self,...)
    --     self:start_fwd_in_pdt_fx_check()
    --     return self:UpdateTooltip__fwd_in_pdt_old(...)
    -- end
    -- --------------------------------------------------------------------------------------------
    -- --- 鼠标拿起来的时候会勾起
    -- self.StartDrag__fwd_in_pdt_old = self.StartDrag
    -- self.StartDrag = function(self,...)
    --     self:start_fwd_in_pdt_fx_check()
    --     return self:StartDrag__fwd_in_pdt_old(...)
    -- end
    -- --------------------------------------------------------------------------------------------
    -- --- 装备穿戴的时候会勾起
    -- self.SetIsEquip__fwd_in_pdt_old = self.SetIsEquip
    -- self.SetIsEquip = function(self,...)
    --     self:start_fwd_in_pdt_fx_check()
    --     return self:SetIsEquip__fwd_in_pdt_old(...)
    -- end
    --------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------
    ----item_inst 触发这个事件的时候 执行
    self.inst:ListenForEvent("imagechange",
        function(invitem)
            if self.__fwd_in_pdt_fx then
                self.__fwd_in_pdt_fx:Kill()
                self.__fwd_in_pdt_fx = nil
            end
            self:start_fwd_in_pdt_fx_check()
            -- print("info imagechange")
        end, self.item)
    --------------------------------------------------------------------------------------------

    function self:start_fwd_in_pdt_fx_check()
        if self.item and self.item:HasTag("fwd_in_pdt_tag.fwd_in_pdt_func.item_tile_icon_fx") then
            local bank,build,anim,colour,shader = self.item.replica.fwd_in_pdt_func:Item_Tile_Icon_Fx_Get()
            self:fwd_in_pdt_add_icon_fx(bank,build,anim,colour,shader)                
        end
    end
    function self:fwd_in_pdt_add_icon_fx(bank,build,anim,colour,shader)
        if bank and build and anim then
            if self.__fwd_in_pdt_fx == nil then
                self.__fwd_in_pdt_fx = self.image:AddChild(UIAnim())
                self.__fwd_in_pdt_fx:GetAnimState():SetBank(bank)
                self.__fwd_in_pdt_fx:GetAnimState():SetBuild(build)
                self.__fwd_in_pdt_fx:GetAnimState():PlayAnimation(anim, true)
                self.__fwd_in_pdt_fx:GetAnimState():SetTime(math.random() * self.__fwd_in_pdt_fx:GetAnimState():GetCurrentAnimationTime())
                self.__fwd_in_pdt_fx:SetScale(.25)
                self.__fwd_in_pdt_fx:GetAnimState():AnimateWhilePaused(false)
                self.__fwd_in_pdt_fx:SetClickable(false)
                self:fwd_in_pdt_StartUpdating("fwd_in_pdt_fx")
                if type(colour) == "table" and colour[1] and colour[2] and  colour[3] then
                    colour[4] = colour[4] or 1
                    self.__fwd_in_pdt_fx:GetAnimState():SetMultColour(colour[1],colour[2],colour[3],colour[4])
                end
                if type(shader) == "string" then
                    self.__fwd_in_pdt_fx:GetAnimState():SetBloomEffectHandle(shader)
                end
            end
        else
            if self.__fwd_in_pdt_fx then
                self.__fwd_in_pdt_fx:Kill()
                self.__fwd_in_pdt_fx = nil
            end
            self:fwd_in_pdt_StopUpdating("fwd_in_pdt_fx")
        end
    end
    ----------------------------------------------------------------------------------------------
    ---- 加载的时候显示
    -- self.inst:DoTaskInTime(0,function()
        self:start_fwd_in_pdt_fx_check()
    -- end)
    ----------------------------------------------------------------------------------------------

end)