----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
----------------------------------------------------------------------------------------------------------------------------------
---
    local function create_info_for_player(inst)
        local replica_com = inst.replica.fwd_in_pdt_com_inspectacle_searcher_game_catch_item
        if replica_com.hud and replica_com.hud.inst:IsValid() then
            return
        end
        ----------------------------------------------------------
        --- 前置准备
            local front_root = ThePlayer.HUD
            local radius = replica_com:GetOffset()
            local dis_sq = radius*radius
        ----------------------------------------------------------
        --- 根节点+参数
            local root = ThePlayer.HUD:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        ----------------------------------------------------------
        ---
            root.inst:ListenForEvent("onremove",function()
                root:Kill()
            end,inst)
        ----------------------------------------------------------
        ---
            local txt_box = root:AddChild(Text(CODEFONT,30,"100/100",{  0/255 , 255/255 ,255/255 , 1}))
            txt_box:Hide()
        ----------------------------------------------------------
        ---
            local offset_y = 200
            TheInput:FWD_IN_PDT_Add_Update_Modify_Fn(root.inst,function()
                --------------------------------------------------
                --- 坐标控制
                    local x,y,z = inst.Transform:GetWorldPosition()
                    local s_pt_x,s_pt_y= TheSim:GetScreenPos(x,y,z) -- 左下角为原点。
                    -- print("player in screen",s_pt_x,s_pt_y)
                    root:SetPosition(s_pt_x,s_pt_y+offset_y,0)
                --------------------------------------------------
                --- 显示、隐藏
                    if ThePlayer.replica.inventory:EquipHasTag("fwd_in_pdt_com_inspectacle_searcher") then
                        txt_box:Show()
                    else
                        txt_box:Hide()
                    end
                --------------------------------------------------
                --- 配置显示内容
                    local line = string.format("%d/%d",replica_com:GetCurrent(),replica_com:GetMax()) .."\n"
                    local time = string.format("%d",replica_com:GetTime()) .."s\n"
                    txt_box:SetString(line..time)
                --------------------------------------------------
                ---
                    if ThePlayer:GetDistanceSqToInst(inst) > dis_sq then
                        root:Kill()
                    end
                --------------------------------------------------
            end)
        ----------------------------------------------------------
        ---
            replica_com.hud = root
        ----------------------------------------------------------
    end
    local function create_info_for_player_task(inst)
        local replica_com = inst.replica.fwd_in_pdt_com_inspectacle_searcher_game_catch_item
        if replica_com == nil or not (ThePlayer and ThePlayer.HUD) or TheInput == nil or TheInput.FWD_IN_PDT_Add_Update_Modify_Fn == nil then
            print("error : fwd_in_pdt_com_inspectacle_searcher_game_catch_item create_info_for_player_task fail")
            return
        end
        create_info_for_player(inst)
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_inspectacle_searcher_game_catch_item = Class(function(self, inst)
    self.inst = inst
    
    self.current = 0
    self.max = 10
    self.time = 0
    self.offset = 30
    --------------------------------------------------------------------------------
    -- net vars
        self.__current = net_uint(inst.GUID, "game_catch_item.current","net_update")
        self.__max = net_uint(inst.GUID, "game_catch_item.max","net_update")
        self.__time = net_uint(inst.GUID, "game_catch_item.time","net_update")
        self.__offset = net_uint(inst.GUID, "game_catch_item.offset","net_update")
        if not TheNet:IsDedicated() then
            self.inst:ListenForEvent("net_update",function()
                self.current = self.__current:value()
                self.max = self.__max:value()
                self.time = self.__time:value()
                self.offset = self.__offset:value()
            end)
        end
    --------------------------------------------------------------------------------
    --- 创建info的task
        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(0.5,create_info_for_player_task)
        end
    --------------------------------------------------------------------------------
end)

------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetCurrent(num)
        self.current = num
        if TheWorld.ismastersim then
            self.__current:set(num)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:GetCurrent()
        return self.current
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetMax(num)
        self.max = num
        if TheWorld.ismastersim then
            self.__max:set(num)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:GetMax()
        return self.max
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetTime(num)
        self.time = num
        if TheWorld.ismastersim then
            self.__time:set(num)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:GetTime()
        return self.time
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:SetOffset(num)
        self.offset = num
        if TheWorld.ismastersim then
            self.__offset:set(num)
        end
    end
    function fwd_in_pdt_com_inspectacle_searcher_game_catch_item:GetOffset()
        return self.offset + 8
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_inspectacle_searcher_game_catch_item







