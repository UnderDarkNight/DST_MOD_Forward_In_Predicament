------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    气球

    四面体：
        running_down  --- 玩家向下走的时候
        running_side  --- 玩家向右走的时候
        running_up    --- 玩家向上走的时候
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_balloon_bobble_loong.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong.xml" ),

    Asset("ANIM", "anim/fwd_in_pdt_equipment_balloon_bobble_loong_green.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong_green.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong_green.xml" ),

}

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_equipment_balloon_bobble_loong_green"] = {             --- 皮肤名字，全局唯一。
            bank = "fwd_in_pdt_equipment_balloon_bobble_loong_green",                               --- 制作完成后切换的 bank
            build = "fwd_in_pdt_equipment_balloon_bobble_loong_green",                              --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong_green.xml",                                        --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_equipment_balloon_bobble_loong_green",                              --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = "green",                                                                         --- 【制作栏】皮肤的名字
            name_color = {0/255,255/255,255/255,255/255},
            onequip_bank = "fwd_in_pdt_equipment_balloon_bobble_loong_green"
        },
    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_equipment_balloon_bobble_loong")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------


local function onequip(inst, owner)
    -- if not (owner and owner:HasTag("player") ) then
    --     return
    -- end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    -----------------------------------------------------------------------------
        local skinname = tostring(inst.skinname)
        local bank_build = skins_data_item[skinname] and skins_data_item[skinname].onequip_bank
    -----------------------------------------------------------------------------
    --- 气球特效
        local fx = SpawnPrefab("fwd_in_pdt_equipment_balloon_fx")
        inst.fx = fx
        fx.AnimState:SetBank( bank_build or "fwd_in_pdt_equipment_balloon_bobble_loong")
        fx.AnimState:SetBuild( bank_build or "fwd_in_pdt_equipment_balloon_bobble_loong")
        fx.AnimState:PlayAnimation("idle",true)

        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object",6.5, 0, -1)
    -----------------------------------------------------------------------------
    ---- 切换动作
        inst.player_sg_state_fn = inst.player_sg_state_fn or function()
            -- moving
            if owner.sg and owner.sg:HasStateTag("moving") then
                if not fx.AnimState:IsCurrentAnimation("running") then
                    fx.AnimState:PlayAnimation("running",true)
                    fx.AnimState:PushAnimation("running",true)
                else
                    -- fx.AnimState:PlayAnimation("running",true)
                    fx.AnimState:PushAnimation("running",true)
                end
                return
            end

            if not fx.AnimState:IsCurrentAnimation("idle") then                
                fx.AnimState:PlayAnimation("idle",true)
                fx.AnimState:PushAnimation("idle",true)
            else
                fx.AnimState:PushAnimation("idle",true)
            end
        end
        owner:ListenForEvent("newstate",inst.player_sg_state_fn)
    -----------------------------------------------------------------------------    
end

local function onunequip(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    -----------------------------------------------------------------------------
    --- 删除特效（气球）
        if inst.fx then
            inst.fx:Remove()
            inst.fx = nil
        end
    -----------------------------------------------------------------------------
    --- 移除sg监听
        if inst.player_sg_state_fn then
            owner:RemoveEventCallback("newstate",inst.player_sg_state_fn)
        end
    -----------------------------------------------------------------------------

end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst.AnimState:SetBank("fwd_in_pdt_equipment_balloon_bobble_loong")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_balloon_bobble_loong")
    inst.AnimState:PlayAnimation("item_idle", true)

    inst.DynamicShadow:SetSize(1, .5)

    inst:AddTag("nopunch")
    inst:AddTag("cattoyairborne")
    inst:AddTag("balloon")
    inst:AddTag("noepicmusic")

    inst:AddTag("show_spoilage")


    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 皮肤API
        Set_ReSkin_API_Default_Animate(inst,"fwd_in_pdt_equipment_balloon_bobble_loong","fwd_in_pdt_equipment_balloon_bobble_loong")

        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_func"):Init("skin")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem:fwd_in_pdt_icon_init("fwd_in_pdt_equipment_balloon_bobble_loong","images/inventoryimages/fwd_in_pdt_equipment_balloon_bobble_loong.xml")
            inst.components.inventoryitem.cangoincontainer = true

        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end





    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.2


    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED*1.5)
    inst.components.perishable:StartPerishing()

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("fwd_in_pdt_equipment_balloon_bobble_loong", fn, assets)
