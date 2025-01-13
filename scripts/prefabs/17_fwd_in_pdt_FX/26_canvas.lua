----------------------------------------------------------------------------------------------------------------------------------
--[[

    装饰系统，使用RPC 来回传送数据

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local assets = {
        Asset("ANIM", "anim/fwd_in_pdt_fx_canvas.zip"),
    }
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
----------------------------------------------------------------------------------------------------------------------------------
--- 
    local function GetIconDataById(id)
        return TUNING.FWD_IN_PDT_DECORATIONS_IDS and TUNING.FWD_IN_PDT_DECORATIONS_IDS[id] or nil
    end
----------------------------------------------------------------------------------------------------------------------------------
--- 
    
----------------------------------------------------------------------------------------------------------------------------------
--- 
    local function client_side_start_drawing_event(inst,save_data)
        if ThePlayer == nil then
            return
        end
        local owner = inst.replica.fwd_in_pdt_building_decoration_system:GetOwner()
        print("client_side_start_drawing_event",owner)
        local mark_fn = nil
        if owner then
            mark_fn = function(mark)
                ---- 标记基点
                TUNING.FWD_IN_PDT_DECORATION_FN:MarkBuilding(mark,owner.prefab)
            end
        end
        TUNING.FWD_IN_PDT_DECORATION_FN:Start(inst,function(inst,save_data)
            -- ThePlayer.__test_save_data = save_data
            --------------------------------------------------------------------------
            --- 通过RPC回传数据
                ThePlayer.replica.fwd_in_pdt_com_rpc_event:PushEvent("OnDrawed",save_data,inst)
            --------------------------------------------------------------------------
        end,save_data,mark_fn)
    end
----------------------------------------------------------------------------------------------------------------------------------
--- 服务端-开始绘制-Event
    local function on_draw_event(inst,save_data)
        --------------------------------------------------------------------------
        --- 移除旧的标记
            inst.marks = inst.marks or {}
            for k, v in pairs(inst.marks) do
                v:Remove()
            end
            inst.marks = {}
        --------------------------------------------------------------------------
        --- 添加新的标记
            for i,temp_icon_data in ipairs(save_data) do
                local id = temp_icon_data[1]
                local offset_x = temp_icon_data[2]
                local offset_y = temp_icon_data[3]
                -- print("info server",id,offset_x,offset_y)
                local mark = SpawnPrefab("fwd_in_pdt_fx_canvas_slot")
                local anim_data = GetIconDataById(id) or {}
                local bank = anim_data.bank
                local build = anim_data.build
                local anim = anim_data.anim
                -----------------------------------------------------------
                --- 超尺寸装饰物
                    local decoration = anim_data.decoration
                    if decoration then
                        bank = decoration.bank
                        build = decoration.build
                        anim = decoration.anim
                    end
                -----------------------------------------------------------
                mark:PushEvent("Set",{
                    link = inst,
                    bank = bank,
                    build = build,
                    anim = anim,
                    pt = Vector3(offset_x,-offset_y,0),
                })
                table.insert(inst.marks,mark)
            end
        --------------------------------------------------------------------------
        ---
            inst.components.fwd_in_pdt_building_decoration_system:SetDecorations(save_data)
        --------------------------------------------------------------------------
    end
    local function player_start_drawing_event(inst,player)
        --- 通过RPC下发数据，同时启动UI
        local save_data = inst.components.fwd_in_pdt_building_decoration_system:GetDecorations() or {}
        player.components.fwd_in_pdt_com_rpc_event:PushEvent("StartDrawClient",save_data,inst)
    end
    local function on_load_fn(inst)
        local save_data = inst.components.fwd_in_pdt_building_decoration_system:GetDecorations() or {}
        on_draw_event(inst,save_data)
    end    
----------------------------------------------------------------------------------------------------------------------------------
--- 基础FX
    local function fx()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst:AddTag("INLIMBO")
        inst:AddTag("NOCLICK")
        inst:AddTag("FX")
        inst:AddTag("fwd_in_pdt_fx_canvas")
        inst.AnimState:SetBank("fwd_in_pdt_fx_canvas")
        inst.AnimState:SetBuild("fwd_in_pdt_fx_canvas")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("idle","fwd_in_pdt_fx_canvas","empty")
        inst.AnimState:SetFinalOffset(1)
        inst.entity:SetPristine()
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("StartDrawClient",client_side_start_drawing_event)
        end
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("fwd_in_pdt_building_decoration_system")
        inst:ListenForEvent("OnDrawed",on_draw_event) --- 客户端回传
        inst:ListenForEvent("start",player_start_drawing_event)
        inst:DoTaskInTime(0,on_load_fn)
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------
--- 单个装饰物
    local function Slot_Setting(inst,_table)    
        local bank = _table.bank
        local build = _table.build
        local anim = _table.anim
        if not (bank and build and anim) then
            return
        end
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation(anim,true)        
        local link = _table.link
        if link then
            local pt = _table.pt or Vector3(0,0,0)
            inst.entity:SetParent(link.entity)
            inst.entity:AddFollower()
            inst.Follower:FollowSymbol(link.GUID,"idle",pt.x,pt.y,0,true)
        end
        inst.Ready = true
    end
    local function slot_init_checker(inst)
        if inst.Ready then
            return
        end
        inst:Remove()
    end
    local function slot_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("fwd_in_pdt_fx_canvas_slot")
        inst.AnimState:SetBank("fwd_in_pdt_fx_canvas")
        inst.AnimState:SetBuild("fwd_in_pdt_fx_canvas")
        inst.AnimState:PlayAnimation("slot")
        -- inst.AnimState:SetFinalOffset(1)
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:ListenForEvent("Set",Slot_Setting)
        inst:DoTaskInTime(0,slot_init_checker)
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------
--- debuff
    local function OnAttached(inst,target)
        inst.entity:SetParent(target.entity)
        -- inst.Network:SetClassifiedTarget(target)
        inst.Transform:SetPosition(0,0,0)
        inst:DoTaskInTime(0,function()
        --------------------------------------------------------------------------
        --- 
            -- print("debuff added",inst)
        --------------------------------------------------------------------------
        --- 创建基础FX
            local fx = nil
            local save_record = inst.components.fwd_in_pdt_data:Get("record")
            if save_record then
                fx = SpawnSaveRecord(save_record)
            else
                fx = SpawnPrefab("fwd_in_pdt_fx_canvas")
            end
            fx.entity:SetParent(target.entity)
            fx.Transform:SetPosition(0,0,0)
            inst.fx = fx
        --------------------------------------------------------------------------
        ---
            fx.components.fwd_in_pdt_building_decoration_system:SetOwner(target)
        --------------------------------------------------------------------------
        --- 储存
            inst.components.fwd_in_pdt_data:AddOnSaveFn(function()
                local save_record = fx:GetSaveRecord()
                inst.components.fwd_in_pdt_data:Set("record",save_record)
            end)
        --------------------------------------------------------------------------
        end)
    end
    local function debuff_start_draw_event(inst,player)
        if inst.fx then
            inst.fx:PushEvent("start",player)
        end
    end
    local function debuff_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst:AddTag("CLASSIFIED")
        inst:AddTag("fwd_in_pdt_debuff_canvas")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("fwd_in_pdt_data")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
        inst:ListenForEvent("start",debuff_start_draw_event)

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_fx_canvas",fx,assets),
    Prefab("fwd_in_pdt_fx_canvas_slot",slot_fn,assets),
    Prefab("fwd_in_pdt_debuff_canvas",debuff_fn,assets)