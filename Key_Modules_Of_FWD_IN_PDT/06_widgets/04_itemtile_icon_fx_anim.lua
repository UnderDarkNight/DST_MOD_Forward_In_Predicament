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
    function self:FWD_IN_PDT__Get_Tile_Fx_CMD()
        if self.item and self.item:HasTag("fwd_in_pdt_tag.fwd_in_pdt_func.item_tile_icon_fx") then
            local cmd_table = self.item.replica.fwd_in_pdt_func:Item_Tile_Icon_Fx_Get()
            return cmd_table
        else
            return nil
        end
    end
    function self:start_fwd_in_pdt_fx_check()
        local cmd_table = self:FWD_IN_PDT__Get_Tile_Fx_CMD()
        if type(cmd_table) == "table" then
            self:fwd_in_pdt_add_icon_fx(cmd_table)
        end
    end
    function self:fwd_in_pdt_add_icon_fx(cmd_table)
        -----------------------------------------------------------------------------
        -- 常规参数表
        -- cmd_table = {
        --     bank = "",
        --     build = "",
        --     anim = "",
        --     shader = "",
        --     colour = {r,g,b,a},    -- 同时兼容命名 color
        --     hide_image = true,  -- 隐藏图标
        --     MoveToBack = true,  -- 动画特效移动到图标底层
        --     MoveToFront = true, -- 动画特效移动到图标顶层
        --     text = {            -- 叠堆数字/百分比数字相关参数操作
        --         pt = Vector3(0,0,0), -- 坐标偏移，默认 （2,16,0）
        --         color = {r,g,b,a},  --  颜色，同时支持 colour
        --         size = 42,           -- 字体大小(默认42)
        --     }
        -- }
        local bank,build,anim = cmd_table.bank,cmd_table.build,cmd_table.anim
        local colour = cmd_table.color or cmd_table.colour
        local shader = cmd_table.shader
        -----------------------------------------------------------------------------
        if bank and build and anim then
            if self.__fwd_in_pdt_fx == nil then
                -- self.__fwd_in_pdt_fx = self.image:AddChild(UIAnim())
                self.__fwd_in_pdt_fx = self:AddChild(UIAnim())
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

                if cmd_table.hide_image then    --- 隐藏旧图标
                    self.image:Hide()
                    self.__fwd_in_pdt_fx:MoveToBack()
                end
                if cmd_table.MoveToBack then    --- 移动特效图层
                    self.__fwd_in_pdt_fx:MoveToBack()
                end
                if cmd_table.MoveToFront then   --- 移动特效图层
                    self.__fwd_in_pdt_fx:MoveToFront()
                    if self.quantity then
                        self.quantity:MoveToFront() --- 叠堆数字前置
                    end
                    if self.percent then
                        self.percent:MoveToFront()  --- 百分比数字前置
                    end
                end

            end
        else
            if self.__fwd_in_pdt_fx then
                self.__fwd_in_pdt_fx:Kill()
                self.__fwd_in_pdt_fx = nil
            end
            self:fwd_in_pdt_StopUpdating("fwd_in_pdt_fx")
        end

        -----------------------------------------------------------------------------
        -- 叠堆数字修改，和百分比数字修改（不拆分了，同时用 text 为参数）
            if type(cmd_table.text) == "table" then
                local text_child = self.quantity or self.percent or nil   --- 叠堆数字或者百分比数字
                if text_child then   
                        -------------------------------------------------------------------------
                        -- 坐标偏移
                            if cmd_table.text.pt and cmd_table.text.pt.x then       
                                text_child:SetPosition(cmd_table.text.pt.x, cmd_table.text.pt.y, 0)
                            end     
                        -------------------------------------------------------------------------
                        -- 颜色切换
                            local color = cmd_table.text.color or cmd_table.text.colour or {}                    
                            if color[1] and color[2] and color[3] then
                                local r,g,b,a = color[1],color[2],color[3],color[4] or 1
                                text_child:SetColour(r,g,b,a)
                            end   
                        -------------------------------------------------------------------------
                        -- 字体大小，默认 42
                            if cmd_table.text.size then
                                text_child:SetSize(cmd_table.text.size)
                            end
                        -------------------------------------------------------------------------

                end

            end
        -----------------------------------------------------------------------------


    end
    ----------------------------------------------------------------------------------------------
    ---- 加载的时候显示
    -- self.inst:DoTaskInTime(0,function()
        self:start_fwd_in_pdt_fx_check()
    -- end)
    ----------------------------------------------------------------------------------------------

end)