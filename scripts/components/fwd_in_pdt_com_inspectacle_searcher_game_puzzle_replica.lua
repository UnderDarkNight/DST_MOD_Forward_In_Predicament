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
    local TEMPLATES = require "widgets/redux/templates"
----------------------------------------------------------------------------------------------------------------------------------
---
    local function CreateGameWidget(self)
        ----------------------------------------------------
        --- 前置准备
            if self.game_widget and self.game_widget.inst:IsValid() then
                return
            end
        ----------------------------------------------------
        --- 前置根节点、素材库
            local front_root = ThePlayer.HUD:AddChild(Widget())
            local atlas = "images/fwd_in_pdt_inspectaclesbox/game_widget_1.xml"
            front_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            front_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            front_root:SetPosition(0,0)
            front_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            front_root:MoveToBack()
        ----------------------------------------------------
        --- 前置根节点绑定相关
            self.game_widget = front_root
            front_root.inst:ListenForEvent("onremove",function()
                front_root:Kill()
            end,self.inst)
            front_root.inst:DoPeriodicTask(0.5,function()
                if ThePlayer and self.inst and self.inst:GetDistanceSqToInst(ThePlayer) < 25 then
                    return
                else
                    front_root:Kill()
                end                    
            end)
        ----------------------------------------------------
        --- 根节点
            local root = front_root:AddChild(Widget())
            local scale = 0.6
            root:SetScale(scale,scale,scale)
        ----------------------------------------------------
        ---
            local bg = root:AddChild(Image(atlas,"background.tex"))
        ----------------------------------------------------
        --- 关闭按钮
            local button_close = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_close:SetPosition(630,370)
            button_close:SetOnClick(function()
                front_root:Kill()
                self.game_widget = nil
            end)
            button_close.image:AddChild(Image(atlas,"icon_close.tex"))
            root.button_close = button_close
        ----------------------------------------------------
        --- 刷新按钮
            local button_refresh = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_refresh:SetPosition(440,-380)
            button_refresh:SetOnClick(function()
                -- print("refresh")
                self:RefreshClick()
            end)
            button_refresh.image:AddChild(Image(atlas,"icon_refresh.tex"))
            root.button_refresh = button_refresh
        ----------------------------------------------------
        --- 星星按钮
            local button_star = bg:AddChild(ImageButton(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex"))
            button_star:SetPosition(570,-380)
            button_star:SetOnClick(function()
                -- print("star")
                self:Submit()
                self.game_widget:Kill()
                self.game_widget = nil
            end)
            local star_icon = button_star.image:AddChild(Image(atlas,"icon_star.tex"))
            root.button_star = button_star
            button_star.img_show = true
            function button_star:SetActive(flag)
                if flag then
                    self:SetTextures(atlas,"button_active.tex","button_active.tex","button_active.tex","button_active.tex","button_active.tex")
                    self:SetClickable(true)
                    if self.aciving_task then
                        self.aciving_task:Cancel()
                    end
                    self.aciving_task = self.inst:DoPeriodicTask(0.3,function()
                        if self.img_show then
                            star_icon:Show()
                        else
                            star_icon:Hide()
                        end
                        self.img_show = not self.img_show
                    end)
                else
                    self:SetTextures(atlas,"button_deacitve.tex","button_deacitve.tex","button_deacitve.tex","button_deacitve.tex","button_deacitve.tex")
                    self:SetClickable(false)
                    if self.aciving_task then
                        self.aciving_task:Cancel()
                        self.aciving_task = nil
                    end
                end
            end
            button_star:SetActive(false)
        ----------------------------------------------------
        --- box
            local box = bg:AddChild(Image(atlas,"box_frame.tex"))
            box:SetScale(1.2,1.2,1.2)
        ----------------------------------------------------
        --- 基于XY的坐标系。 X-9 .Y-5
            local SLOTS_MAX_X = 9
            local SLOTS_MAX_Y = 5
            local slots_pos = {}
            local all_pos = {}
            local start_x,start_y = -400,200
            for y = 1, SLOTS_MAX_Y, 1 do
                for x = 1, SLOTS_MAX_X, 1 do
                    slots_pos[y] = slots_pos[y] or {}
                        slots_pos[y][x] = Vector3(start_x + (x-1)*100,start_y - (y-1)*100,0)
                        table.insert(all_pos,slots_pos[y][x])
                end
            end
            -- print("pos",#all_pos)
        ----------------------------------------------------
        --- 单个格子
            -- local mini_game_atlas = "images/fwd_in_pdt_inspectaclesbox/loramia_inspectaclesbox_game_tex_"..math.random(12)..".xml"
            -- local mini_game_atlas = "images/fwd_in_pdt_inspectaclesbox/test_puzzle.xml"
            local puzzle_num = math.random(25)
            -- if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            --     TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM = TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM or 1
            --     puzzle_num = TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM
            --     TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM = TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM + 1
            --     if TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM > 25 then
            --         TUNING.FWD_IN_PDT_MOD___DEBUGGING_PUZZLE_NUM = 1
            --     end
            -- end
            local mini_game_atlas = "images/fwd_in_pdt_inspectaclesbox/game_puzzle_"..puzzle_num..".xml"
            local function create_slot(num)                
                -- local temp_slot = box:AddChild(Image(mini_game_atlas,num..".tex"))
                local image_name = tostring(num)..".tex"
                local temp_slot = box:AddChild(ImageButton(mini_game_atlas,image_name,image_name,image_name,image_name,image_name))
                temp_slot.focus_scale = {1,1,1}
                local slot_scale = 1.015
                temp_slot:SetScale(slot_scale,slot_scale,slot_scale)
                temp_slot.num = num
                if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                    temp_slot.image:AddChild(Text(CODEFONT,40,tostring(num),{0/255,255/255,0/255,1}))
                end
                function temp_slot:GetSlottXY()
                    return self.s_x,self.s_y
                end
                function temp_slot:SetSlotXY(s_x,s_y)
                    self.s_x = s_x
                    self.s_y = s_y
                    self:SetPosition(slots_pos[s_y][s_x])
                end
                temp_slot:SetOnClick(function()
                    -- print("click",temp_slot.num)
                    box.inst:PushEvent("slot_click",temp_slot)
                end)
                return temp_slot
            end
        ----------------------------------------------------
        --- 获取不重复的数字 1-44
            local spawned_list = {}
            for i = 1, 44, 1 do
                table.insert(spawned_list,i)
            end
            local function get_random_slot_png_num()
                local index = math.random(#spawned_list)
                local num = spawned_list[index]
                table.remove(spawned_list,index)
                return num
            end
        ----------------------------------------------------
        --- 格子
            local slots = {}
            local temp_num = 1
            for SY = 1,SLOTS_MAX_Y,1 do
                slots[SY] = slots[SY] or {}
                for SX = 1,SLOTS_MAX_X,1 do
                    if temp_num <= 44 then
                        local temp_slot = create_slot(get_random_slot_png_num())
                        temp_slot:SetSlotXY(SX,SY)
                        slots[SY][SX] = temp_slot
                    end
                    temp_num = temp_num + 1
                end
            end
        ----------------------------------------------------
        --- 转换逻辑
            -- local function findEmptySlot(slots, s_x, s_y, maxDistance)
            --     local directions = {
            --         {dx = -1, dy = 0}, -- left
            --         {dx = 1, dy = 0},  -- right
            --         {dx = 0, dy = -1}, -- up
            --         {dx = 0, dy = 1},  -- down
            --         {dx = -1, dy = -1},-- left-up
            --         {dx = 1, dy = -1}, -- right-up
            --         {dx = -1, dy = 1},-- left-down
            --         {dx = 1, dy = 1}  -- right-down
            --     }
            
            --     for distance = 1, maxDistance do
            --         for _, dir in ipairs(directions) do
            --             local check_x = s_x + dir.dx * distance
            --             local check_y = s_y + dir.dy * distance
            
            --             if check_x >= 1 and check_x <= SLOTS_MAX_X and check_y >= 1 and check_y <= SLOTS_MAX_Y then
            --                 local slot = slots[check_y][check_x]
            --                 if not slot then
            --                     return check_x, check_y
            --                 end
            --             end
            --         end
            --     end
            -- end            
            -- box.inst:ListenForEvent("slot_click", function(_, selected_slot)
            --     local s_x, s_y = selected_slot:GetSlottXY()
            --     local ret_slot_x, ret_slot_y = findEmptySlot(slots, s_x, s_y, 9) -- 支持最多5格距离
            
            --     if ret_slot_x and ret_slot_y then
            --         slots[s_y][s_x] = nil
            --         slots[ret_slot_y][ret_slot_x] = selected_slot
            --         selected_slot:SetSlotXY(ret_slot_x, ret_slot_y)
            --         box.inst:PushEvent("check_succeed")
            --     end
            -- end)
        ----------------------------------------------------
        --- 交换逻辑
            local function GetEmptySlot()
                for SY = 1,SLOTS_MAX_Y,1 do
                    for SX = 1,SLOTS_MAX_X,1 do
                        if slots[SY][SX] == nil then
                            return SX,SY
                        end
                    end
                end
            end
            box.inst:ListenForEvent("slot_click", function(_, selected_slot)
                local s_x, s_y = selected_slot:GetSlottXY()
                local empty_x, empty_y = GetEmptySlot()
                if empty_x and empty_y then
                    slots[s_y][s_x] = nil
                    slots[empty_y][empty_x] = selected_slot
                    selected_slot:SetSlotXY(empty_x, empty_y)
                    box.inst:PushEvent("check_succeed")
                end
            end)
        ----------------------------------------------------
        --- 拼图助手
            local puzzle_helper_acitve_num = 0
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                puzzle_helper_acitve_num = 40
            end
            if puzzle_helper_acitve_num > 0 then
                puzzle_helper_acitve_num = math.min(puzzle_helper_acitve_num, 40)
                local function find_slot_by_num(num)
                    for SY = 1,SLOTS_MAX_Y,1 do
                        for SX = 1,SLOTS_MAX_X,1 do
                            local temp_slot = slots[SY][SX]
                            if temp_slot and temp_slot.num == num then
                                return temp_slot
                            end
                        end
                    end
                    return nil
                end
                local slots_index = {}
                local function refresh_slot_index()
                    local new_table = {}
                    local num = 1
                    for SY = 1,SLOTS_MAX_Y,1 do
                        for SX = 1,SLOTS_MAX_X,1 do
                            local temp_slot = slots[SY][SX]
                            new_table[num] = temp_slot
                            num = num + 1
                        end
                    end
                    slots_index = new_table
                end
                refresh_slot_index()
                local function exchange_slot(slot1, slot2)
                    local slot1_x, slot1_y = slot1:GetSlottXY()
                    local slot2_x, slot2_y = slot2:GetSlottXY()
                    slots[slot1_y][slot1_x] = slot2
                    slots[slot2_y][slot2_x] = slot1
                    slot1:SetSlotXY(slot2_x, slot2_y)
                    slot2:SetSlotXY(slot1_x, slot1_y)
                    refresh_slot_index()
                end                
                for current = 1,puzzle_helper_acitve_num,1 do
                   local current_slot = slots_index[current]
                   if current_slot.num ~= current then
                       local target_slot = find_slot_by_num(current)
                       exchange_slot(current_slot, target_slot)
                   end
                end
            end
        ----------------------------------------------------
        --- 检查通过
            local function check_succeed()
                local temp_num = 1
                for SY = 1,SLOTS_MAX_Y,1 do
                    for SX = 1,SLOTS_MAX_X,1 do
                        if temp_num <= 44 then
                            local temp_slot = slots[SY][SX]
                            if temp_slot == nil or temp_slot.num ~= temp_num then
                                return false
                            end
                        end
                        temp_num = temp_num + 1
                    end
                end
                return true
            end
            box.inst:ListenForEvent("check_succeed",function()
                if check_succeed() then
                    button_star:SetActive(true)
                else
                    button_star:SetActive(false)
                end
            end)
        ----------------------------------------------------
        --- 网格            
            for k, pos in pairs(all_pos) do
                local frame = box:AddChild(Image(atlas,"slot_frame.tex"))
                frame:SetPosition(pos.x,pos.y)
                -- frame:SetTint(1,0,1,1)
                frame:SetClickable(false)
                local frame2 = box:AddChild(Image(atlas,"slot_frame.tex"))
                frame2:SetPosition(pos.x,pos.y)
                -- frame:SetTint(1,0,1,1)
                frame2:SetClickable(false)
                frame2:SetRotation(90)
            end            
        ----------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher_game_puzzle = Class(function(self, inst)
    self.inst = inst    
end)
------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher_game_puzzle:RefreshClick()
        if self.game_widget then
            self.game_widget:Kill()
        end
        CreateGameWidget(self)
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_puzzle:Submit()
        if self.submit_fn then
            self.submit_fn(self.inst)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_puzzle:SetSubmitFn(fn)
        self.submit_fn = fn
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_puzzle:StartGame()
        if self.game_widget then
            self.game_widget:Kill()
            self.game_widget = nil
        end
        if ThePlayer and ThePlayer.HUD then
            CreateGameWidget(self)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_puzzle:IsGamePlaying()
        if self.game_widget and self.game_widget.inst and self.game_widget.inst:IsValid() then
            return true
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher_game_puzzle







