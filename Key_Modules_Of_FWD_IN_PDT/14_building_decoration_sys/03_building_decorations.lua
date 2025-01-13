----------------------------------------------------------------------------------------------------------------------------------
--[[

    建筑装饰物 素材

]]--
----------------------------------------------------------------------------------------------------------------------------------

TUNING.FWD_IN_PDT_DECORATION_FN = TUNING.FWD_IN_PDT_DECORATION_FN or {}

local function GetIconDataById(id)
    return TUNING.FWD_IN_PDT_DECORATIONS_IDS and TUNING.FWD_IN_PDT_DECORATIONS_IDS[id] or nil
end
local function GetAllIconData()
    return TUNING.FWD_IN_PDT_DECORATIONS_IDS or {}
end
local function GetAllIconData2()
    return TUNING.FWD_IN_PDT_DECORATIONS or {}
end
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
--[[


    submit_fn = function(inst,save_data)
        --- 坐标数据
    end
    mark_fn = function(mark)
        
    end

]]--
----------------------------------------------------------------------------------------------------------------------------------
function TUNING.FWD_IN_PDT_DECORATION_FN:Start(inst,submit_fn,old_saved_data,mark_fn)
    ---------------------------------------------------------------------------------------------
    -- 前置准备
        local ui_atlas = "images/widget/fwd_in_pdt_decoration_ui.xml"
        local mark_bank = "fwd_in_pdt_fx_canvas"
        local mark_build = "fwd_in_pdt_fx_canvas"
        local mark_anim = "mark"
    ---------------------------------------------------------------------------------------------
    -- 前置根节点
        local front_root = ThePlayer.HUD:AddChild(Widget())
        front_root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        front_root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        front_root:SetPosition(0,0)
        -- front_root:MoveToBack()
        front_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        local screen_width,screen_height = TheSim:GetScreenSize()
        local mid_pos = Vector3(screen_width/2,screen_height/2,0)
        front_root:SetPosition(mid_pos.x,mid_pos.y)
    ---------------------------------------------------------------------------------------------
    --- 根节点-关闭
        front_root.inst:DoPeriodicTask(1,function()
            if ThePlayer:GetDistanceSqToInst(inst) > 20 then
                front_root:Kill()
            end
        end)
        front_root.inst:ListenForEvent("onremove",function()
            front_root:Kill()
        end,inst)
    ---------------------------------------------------------------------------------------------
    --- 根节点
            local SCALE = 0.6
            local root = front_root:AddChild(Widget())
            root:SetScale(SCALE, SCALE, SCALE)
    ---------------------------------------------------------------------------------------------
    --- 背景
            local bg = root:AddChild(Image(ui_atlas,"background.tex"))
    ---------------------------------------------------------------------------------------------
    --- 关闭按钮
        local button_close = root:AddChild(ImageButton(ui_atlas,"icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex"))
        button_close.image:AddChild(Image(ui_atlas,"icon_close.tex"))
        button_close:SetPosition(750,450)
        button_close:SetOnClick(function()
            front_root.inst:PushEvent("close")
            -- front_root:Kill()
        end)
    ---------------------------------------------------------------------------------------------
    --- canvas button
        local button_canvas = root:AddChild(ImageButton(ui_atlas,"canvas.tex","canvas.tex","canvas.tex","canvas.tex","canvas.tex"))
        button_canvas.focus_scale = {1,1,1}
        button_canvas:SetOnClick(function()
            local mouse_x, mouse_y = TheSim:GetPosition()
            front_root.inst:PushEvent("on_draw",Vector3(mouse_x, mouse_y,0))
        end)
        button_canvas.clickoffset = Vector3(0,0,0)
        button_canvas:SetScale(3,3,3)
    ---------------------------------------------------------------------------------------------
    --- 标记图层
            local mark_layer = root:AddChild(Widget())
            mark_layer:SetPosition(0,0)
            mark_layer:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            mark_layer:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            -- mark_layer:SetClickable(false)
            -- mark_layer:SetScale(0.5,0.5,0.5)
    ---------------------------------------------------------------------------------------------
    --- 基点标记
        local mark_scale = 0.5
        local mark_pos = Vector3(640,200,0)
        local mark = mark_layer:AddChild(UIAnim())
        mark:GetAnimState():SetBank(mark_bank)
        mark:GetAnimState():SetBuild(mark_build)
        mark:GetAnimState():PlayAnimation(mark_anim, true)
        mark:SetPosition(mark_pos.x,mark_pos.y)
        mark:SetScale(mark_scale,mark_scale,mark_scale)
        -- mark:FollowMouse()
        front_root.mark = mark
        if mark_fn then
            mark_fn(mark)
        end
        mark:SetClickable(false)
    ---------------------------------------------------------------------------------------------
    --- slot box
            local slot_box = root:AddChild(Image(ui_atlas,"box.tex"))
            slot_box:SetPosition(400,0)
    ---------------------------------------------------------------------------------------------
    --- selectting_box
            local selectting_box = root:AddChild(ImageButton(ui_atlas,"icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex"))
            selectting_box:SetPosition(30,350)
            selectting_box.icon = selectting_box.image:AddChild(UIAnim())
            selectting_box.icon:GetAnimState():SetBank(mark_bank)
            selectting_box.icon:GetAnimState():SetBuild(mark_build)
            selectting_box.icon:GetAnimState():PlayAnimation(mark_anim, true)
            selectting_box.icon:SetScale(0.7,0.7,0.7)
            function selectting_box:SetImage(bank,build,anim)
                self.icon:GetAnimState():SetBank(bank)
                self.icon:GetAnimState():SetBuild(build)
                self.icon:GetAnimState():PlayAnimation(anim, true)                        
            end
            function selectting_box:SetData(id,bank,build,anim)
                if id and bank and build and anim then
                    self.id = id
                    self:SetImage(bank,build,anim)
                else
                    self.id = nil
                    self.icon:GetAnimState():SetBank(mark_bank)
                    self.icon:GetAnimState():SetBuild(mark_build)
                    self.icon:GetAnimState():PlayAnimation(mark_anim, true)
                end
            end
            function selectting_box:GetID()
                return self.id
            end
            selectting_box.focus_scale = {1,1,1}
            front_root.inst:ListenForEvent("slot_selected",function(_,id)
                local icon_data = GetIconDataById(id)
                if icon_data then
                    selectting_box:SetData(id,icon_data.bank,icon_data.build,icon_data.anim)
                else
                    selectting_box:SetData(nil,nil,nil,nil)
                end
            end)
            selectting_box:SetOnClick(function()
                selectting_box:SetData(nil,nil,nil,nil)
            end)
    ---------------------------------------------------------------------------------------------
    --- 关闭和提交
            front_root.inst:ListenForEvent("close",function()
                front_root.inst:PushEvent("submit")
                front_root:Kill()
            end)
            button_close:MoveToFront()
    ---------------------------------------------------------------------------------------------
    ---- 单个选项框体
            local function CreateSlot(id)
                -- local icon_data = GetIconDataById(id)
                local temp_button = ImageButton(ui_atlas,"icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex","icon_slot.tex")
                temp_button.id = id
                temp_button:SetOnClick(function()
                    front_root.inst:PushEvent("slot_selected",temp_button.id)
                    -- print("slot selected",temp_button.id)
                end)
                function temp_button:SetID(id)
                    self.id = id
                    local icon_data = GetIconDataById(id)
                    if icon_data then
                        self.icon = self.icon or self.image:AddChild(UIAnim())
                        self.icon:SetScale(0.7,0.7,0.7)
                        self.icon:GetAnimState():SetBank(icon_data.bank)
                        self.icon:GetAnimState():SetBuild(icon_data.build)
                        self.icon:GetAnimState():PlayAnimation(icon_data.anim,true)
                    end
                end
                temp_button:SetID(id)
                temp_button.focus_scale = {1,1,1}
                return temp_button
            end
            -- slot_box:AddChild(CreateSlot("yellow_alphabet_a"))
    ---------------------------------------------------------------------------------------------
    ---- 滚动条区域
            local function create_scroll_box(all_slot_num)
                -------------------------------------------------------------------------------
                -------------------------------------------------------------------------------
                --- 单行 6 格子一行
                    local lines_num = math.ceil(all_slot_num/6)                        
                    local slot_width = 90
                    local slot_height = 90
                    local lines = {}
                    local all_slots = {}
                    local line_temp_num = 1
                    local function CreateLine()
                        local line = Widget()
                        for i = 1, 6, 1 do
                            local temp_slot = line:AddChild(CreateSlot("yellow_alphabet_a"))
                            temp_slot:SetPosition((i-3)*slot_width-45,0)
                            table.insert(all_slots,temp_slot)                               
                        end
                        line_temp_num = line_temp_num + 1
                        table.insert(lines,line)
                        return line
                    end
                    -- slot_box:AddChild(CreateLine())
                -------------------------------------------------------------------------------
                --- 滚动条区域
                    local line_items_box = {}
                    for i = 1, lines_num, 1 do
                        table.insert(line_items_box,CreateLine())
                    end
                    local listwidth = 600
                    local listheight = 700
                    local itemheight = 5
                    local itempadding = 90
                    local updatefn = function() end
                    local widgetstoupdate = nil
                    local scroll_bar_area = ScrollableList(line_items_box,listwidth, listheight, itemheight, itempadding,updatefn,widgetstoupdate)
                    scroll_bar_area:SetPosition(0,0) -- 设置滚动区域位置
                    scroll_bar_area.scroll_bar_container:SetPosition(-305,0)  --- 设置滚动条位置
                    ---- 设置滚动条样式
                    -- scroll_bar_area.up_button:SetTextures(atlas,"arrow_scrollbar_up.tex")
                    -- scroll_bar_area.down_button:SetTextures(atlas,"arrow_scrollbar_down.tex")
                    -- scroll_bar_area.scroll_bar_line:SetTexture(atlas,"scrollbarline.tex")
                    -- scroll_bar_area.position_marker:SetTextures(atlas,"scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex")
                    -- scroll_bar_area.position_marker:OnGainFocus() --- 不知道为什么，贴图替换失败。只能用这种方式刷一下。
                    -- scroll_bar_area.position_marker:OnLoseFocus()
                -------------------------------------------------------------------------------
                ---
                    scroll_bar_area.all_slots = all_slots
                    return scroll_bar_area
                -------------------------------------------------------------------------------
            end
            local all_icon_data = GetAllIconData2() or {}
            local scroll_box = slot_box:AddChild(create_scroll_box(#all_icon_data))
            scroll_box:SetPosition(280,0)
            for i, temp_slot in ipairs(scroll_box.all_slots) do
                local temp_id = all_icon_data[i] and all_icon_data[i].id
                if temp_id then
                    temp_slot:SetID(temp_id)
                else
                    temp_slot:Hide()
                end
            end
    ---------------------------------------------------------------------------------------------
    --- 画出来的图标
        local function CreateDrawedIcon(id)
            local icon_data = GetIconDataById(id)
            if icon_data == nil then
                return
            end
            local bank = icon_data.bank
            local build = icon_data.build
            local anim = icon_data.anim
            -----------------------------------------------------------
            -- 超尺寸装饰物
                local decoration = icon_data.decoration
                if decoration then
                    bank = decoration.bank
                    build = decoration.build
                    anim = decoration.anim
                end
            -----------------------------------------------------------
            local temp_button = AnimButton(bank,{ idle = anim,over = anim,disabled = anim})
            temp_button.anim:GetAnimState():SetBuild(build)
            temp_button.anim:GetAnimState():SetBank(bank)
            temp_button.anim:GetAnimState():PlayAnimation(anim,true)
            temp_button.clickoffset = Vector3(0,0,0)
            temp_button.focus_scale = {1,1,1}
            temp_button:SetOnClick(function()
                -- temp_button:Kill()
            end)
            temp_button._old_OnMouseButton = temp_button.OnMouseButton
            temp_button.OnMouseButton = function(self,button,down,...)
                if down then
                    if button == MOUSEBUTTON_RIGHT then
                        self:Kill()
                        return
                    elseif button == MOUSEBUTTON_LEFT then
                        local mouse_x, mouse_y = TheSim:GetPosition()
                        front_root.inst:PushEvent("on_draw",Vector3(mouse_x, mouse_y,0))
                    end
                end
                return self._old_OnMouseButton(self,button,down,...)
            end
            temp_button.id = id
            temp_button.inst.id = id
            return temp_button
        end
    ---------------------------------------------------------------------------------------------
    --- 作画逻辑
        local drawed_icons = {} --- 保存画出来的图标                
        front_root.inst:ListenForEvent("on_draw",function(_,pt)
            local current_seleted_id = selectting_box:GetID()
            if current_seleted_id == nil then
                local old_mark_pos = mark:GetPosition()
                local move_vec = pt - old_mark_pos
                mark:SetPosition(pt.x,pt.y)
                ----------------------------------------------
                -- 刷新已经存在的图标
                    local new_drawed_icons = {}
                    for index, temp_icon in pairs(drawed_icons) do
                        if temp_icon and temp_icon.inst and temp_icon.inst:IsValid() then
                            local new_pos = temp_icon:GetPosition() + move_vec
                            temp_icon:SetPosition(new_pos.x,new_pos.y)
                            table.insert(new_drawed_icons,temp_icon)
                        end
                    end
                    drawed_icons = new_drawed_icons
                ----------------------------------------------
            else
                local temp_icon = mark_layer:AddChild(CreateDrawedIcon(current_seleted_id))
                temp_icon:SetPosition(pt.x,pt.y)                
                table.insert(drawed_icons,temp_icon)
            end
        end)
    ---------------------------------------------------------------------------------------------
    --- 数据转换并保存。只储存 和 mark 坐标相对应的 偏移量
        local function GetIconSaveData()
            local all_data = {}
            local mark_pos = mark:GetPosition()
            for index, temp_icon in ipairs(drawed_icons) do
                if temp_icon.inst and temp_icon.inst:IsValid() then
                    local offset = temp_icon:GetPosition() - mark_pos
                    local id = temp_icon.id
                    table.insert(all_data,{id,offset.x,offset.y})
                    -- print(id,offset.x,offset.y)
                end
            end
            return all_data
        end
        front_root.inst:ListenForEvent("submit",function()
            local save_data = GetIconSaveData()
            if submit_fn then
                submit_fn(inst,save_data)
            end
        end)
    ---------------------------------------------------------------------------------------------
    --- 加载数据
        if type(old_saved_data) == "table" and #old_saved_data > 0 then
            for i, temp_icon_data in ipairs(old_saved_data) do
                local mark_pos = mark:GetPosition()
                local id = temp_icon_data[1]
                local offset_x = temp_icon_data[2]
                local offset_y = temp_icon_data[3]
                local drawed_icon = CreateDrawedIcon(id)
                if drawed_icon then
                    local temp_icon = mark_layer:AddChild(drawed_icon)
                    temp_icon:SetPosition(mark_pos.x + offset_x,mark_pos.y + offset_y)                    
                    table.insert(drawed_icons,temp_icon)
                end
            end
        end
    ---------------------------------------------------------------------------------------------
end