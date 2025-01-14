---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    寻宝帽子

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local MAX_COOL_DOWN_TIME = TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and 30 or 3*8*60
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/cane.zip"),
        Asset("ANIM", "anim/swap_cane.zip"),

        Asset("IMAGE", "images/widget/fwd_in_pdt_spell_ring_buttons.tex"),
        Asset("ATLAS", "images/widget/fwd_in_pdt_spell_ring_buttons.xml"),

        Asset("IMAGE", "images/fwd_in_pdt_inspectaclesbox/search_button_icon.tex"),
        Asset("ATLAS", "images/fwd_in_pdt_inspectaclesbox/search_button_icon.xml"),

    }
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 穿戴
    local function onequip(inst, owner)
        inst.components.fwd_in_pdt_com_inspectacle_searcher:Active(owner)        
    end
    local function onunequip(inst, owner)
        inst.components.fwd_in_pdt_com_inspectacle_searcher:Deactive()        
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- wiget
    local function hud_install(inst,root)
        ---------------------------------------------------------------
        --- 按钮
            local deep_search_btn = root:AddChild(ImageButton("images/widget/fwd_in_pdt_spell_ring_buttons.xml","empty.tex","empty.tex","empty.tex","empty.tex","empty.tex"))
            -- deep_search_btn:SetScale(.5,.5)
            -- deep_search_btn:SetPosition(500,-200)
            deep_search_btn:SetScale(.7,.7)
            deep_search_btn:SetPosition(200,200)
            deep_search_btn.inst:ListenForEvent("close",function()
                deep_search_btn:Hide()
            end,root.inst)
            deep_search_btn:SetOnClick(function()
                -- print("666666666 click")
                ThePlayer.replica.fwd_in_pdt_com_rpc_event:PushEvent("create_marker",{},inst)
                deep_search_btn:Hide()
            end)
            deep_search_btn:Hide()

            deep_search_btn.image:AddChild(Image("images/fwd_in_pdt_inspectaclesbox/search_button_icon.xml","search_button_icon.tex"))
        ---------------------------------------------------------------
        --- pinger 的检查激活
            root.inst:DoPeriodicTask(1,function()
                if inst.replica.fwd_in_pdt_com_inspectacle_searcher:GetPingerTarget() == nil and inst:HasTag("ready") then
                    inst.replica.fwd_in_pdt_com_inspectacle_searcher:SetPingerTarget(TheSim:FindFirstEntityWithTag("fwd_in_pdt_building_inspectaclesbox"))
                end
                if inst.replica.fwd_in_pdt_com_inspectacle_searcher:GetPingerTarget() == nil 
                    and inst.replica.fwd_in_pdt_com_inspectacle_searcher:GetPingerTargetPos() == nil
                    and inst:HasTag("ready") then
                    deep_search_btn:Show()
                else
                    deep_search_btn:Hide()
                end
            end)
        ---------------------------------------------------------------
        --- 服务器RPC 来的坐标数据
            root.inst:ListenForEvent("pinger_pos_set",function(_,pos)
                inst.replica.fwd_in_pdt_com_inspectacle_searcher:SetPingerTargetPos(pos)
            end,inst)
        ---------------------------------------------------------------
        --- 激活视野，看见目标
            if ThePlayer then
                ThePlayer.AnimState:SetClientSideBuildOverrideFlag("fwd_in_pdt_building_inspectaclesbox_searching", true)
            end
            root.inst:ListenForEvent("close",function()
                if ThePlayer then
                    ThePlayer.AnimState:SetClientSideBuildOverrideFlag("fwd_in_pdt_building_inspectaclesbox_searching", false)
                end
            end)
        ---------------------------------------------------------------
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 随机坐标（复制自 传送法杖）
    local function GetRandomPosition(caster, teleportee, target_in_ocean)
        if teleportee == nil then
            teleportee = caster
        end

        if target_in_ocean then
            local pt = TheWorld.Map:FindRandomPointInOcean(20)
            if pt ~= nil then
                return pt
            end
            local from_pt = teleportee:GetPosition()
            local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
            if offset ~= nil then
                return from_pt + offset
            end
            return teleportee:GetPosition()
        else
            local centers = {}
            for i, node in ipairs(TheWorld.topology.nodes) do
                if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
                    table.insert(centers, {x = node.x, z = node.y})
                end
            end
            if #centers > 0 then
                local pos = centers[math.random(#centers)]
                return Vector3(pos.x, 0, pos.z)
            else
                return caster:GetPosition()
            end
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 创建标记
    local function CreateMarker(inst)
        print("CreateMarker")
        local marker = TheSim:FindFirstEntityWithTag("fwd_in_pdt_building_inspectaclesbox")
        if marker and marker:IsValid() then
            -- print("marker is valid")
            -- inst.components.fwd_in_pdt_com_inspectacle_searcher:SetPingerTarget(marker)
            return
        end
        if not inst.components.rechargeable:IsCharged() then
            -- print("not charged")
            return
        end
        local player = inst.components.fwd_in_pdt_com_inspectacle_searcher:GetOwner() or TheSim:FindFirstEntityWithTag("player")
        if player == nil then
            -- print("player is nil")
            return
        end
        local pos = GetRandomPosition(player)
        SpawnPrefab("fwd_in_pdt_building_inspectaclesbox").Transform:SetPosition(pos.x,0,pos.z)
        inst.components.rechargeable:Discharge(MAX_COOL_DOWN_TIME)
    end
    --- 服务器定期扫描下发坐标给客户端，通过RPC。用来解决 目标物品 在加载范围外无法在客户端扫描到的bug
    local function Marker_Searching_Task(inst)
        local marker = TheSim:FindFirstEntityWithTag("fwd_in_pdt_building_inspectaclesbox")
        local owner = inst.components.fwd_in_pdt_com_inspectacle_searcher:GetOwner()
        if owner == nil then
            return
        end
        if marker and marker:IsValid() then
            owner.components.fwd_in_pdt_com_rpc_event:PushEvent("pinger_pos_set",Vector3(marker.Transform:GetWorldPosition()),inst)
        else
            owner.components.fwd_in_pdt_com_rpc_event:PushEvent("pinger_pos_set",nil,inst)
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ready_checker(inst)
        if inst.components.rechargeable:IsCharged() then
            inst:AddTag("ready")
        else
            inst:RemoveTag("ready")
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("cane")
        inst.AnimState:SetBuild("swap_cane")
        inst.AnimState:PlayAnimation("idle")
        inst:AddTag("fwd_in_pdt_item_inspectable_searcher_hat")
        inst.entity:SetPristine()
        ---------------------------------------------------------------------
        ---
            inst:ListenForEvent("hud_created",hud_install)
        ---------------------------------------------------------------------

        if not TheWorld.ismastersim then
            return inst
        end
        ---------------------------------------------------------------------
        --- 
            inst:ListenForEvent("create_marker",CreateMarker)
            inst:DoPeriodicTask(5,Marker_Searching_Task)
        ---------------------------------------------------------------------
        --- 基础组件
            inst:AddComponent("inspectable")
            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:ChangeImageName("bluegem")
            -- inst.components.inventoryitem.imagename = "_item_luminescent_crystal"
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/_item_luminescent_crystal.xml"
            inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(onequip)
            inst.components.equippable:SetOnUnequip(onunequip)
            inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

            MakeHauntableLaunch(inst)
        ---------------------------------------------------------------------
        --- 核心寻宝组件
            inst:AddComponent("fwd_in_pdt_com_inspectacle_searcher")
        ---------------------------------------------------------------------
        --- 冷却
            inst:AddComponent("rechargeable")
            inst.components.rechargeable:SetMaxCharge(MAX_COOL_DOWN_TIME)
            inst:DoPeriodicTask(1,ready_checker)
        ---------------------------------------------------------------------
        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_item_inspectable_searcher_hat", fn, assets)
