---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    填海叉
]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_ocean_fork.zip"),
    Asset("ANIM", "anim/fwd_in_pdt_equipment_ocean_fork_swap.zip"),
}
------------------------------------------------------------------------------------------------------------------------
----- 
    local function onequip(inst, owner)
        -- owner.AnimState:OverrideSymbol("swap_object", "moonlightcoda_equipment_debate_swap", "swap_object")
        owner.AnimState:OverrideSymbol("swap_object", "fwd_in_pdt_equipment_ocean_fork_swap", "swap_pitchfork")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end

------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_equipment_ocean_fork")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_ocean_fork")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------------------------------------------------------------------
    ----- 施法组件  prefab tile_outline  地皮的框框
        --[[
                        self.inst.Transform:SetPosition(TheWorld.Map:GetTileCenterPoint(ThePlayer.entity:LocalToWorldSpace(0, 0, 0)))

        ]]--
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_point_and_target_spell_caster",function(_,replica_com)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if not right_click then
                    return false
                end

                local crash_flag,ret = pcall(function()
                    if pt then
                        -------------------------------------------------------------------
                        --- 地皮中心点坐标 等参数
                            local tile_x,tile_y,tile_z = TheWorld.Map:GetTileCenterPoint(pt.x,0,pt.z)
                            local tile_map_x,tile_map_y = TheWorld.Map:GetTileXYAtPoint(tile_x,0,tile_z)
    
    
                        -------------------------------------------------------------------
                        --- 创建 虚线方框 指示器
                            if not TheNet:IsDedicated() then --- 只在 client 端执行
                                if inst.tile_outline == nil or not inst.tile_outline:IsValid() then
                                    inst.tile_outline = SpawnPrefab("fwd_in_pdt_fx_tile_outline")
                                    inst.tile_outline.Ready = true
                                    inst.tile_outline:DoPeriodicTask(1,function()   ---- 创建循环任务，叉子脱下或者被删了  ，就把框框删掉
                                        if not inst:IsValid() or not inst.replica.equippable:IsEquipped() then
                                            inst.tile_outline:Remove()
                                            inst.tile_outline = nil
                                        end
                                    end)
                                end
                                if inst.tile_outline then
                                    -- inst.tile_outline.Transform:SetPosition(tile_x,tile_y,tile_z)
                                    inst.tile_outline:PushEvent("Set",{
                                        pt = Vector3(tile_x,tile_y,tile_z),
                                        color = Vector3(0,255,0),
                                        MultColour_Flag = true,
                                    })
                                end
                            end
                        -------------------------------------------------------------------
                        ---- 超出地图尺寸
                            local map_width,map_height = TheWorld.Map:GetSize()
                            if tile_map_x > map_width or tile_map_x <= 0 then
                                return false
                            end
                            if tile_map_y > map_height or tile_map_y <=0 then
                                return false
                            end
                        -------------------------------------------------------------------
                        --- 地皮上有玩家
                            local ents = TheSim:FindEntities(tile_x, 0, tile_z, 2.2, {"player"}, {"playerghost"}, nil)
                            if #ents > 0 then
                                if inst.tile_outline then
                                    inst.tile_outline:PushEvent("Set",{
                                        color = Vector3(255,0,0),
                                        MultColour_Flag = true,
                                    })
                                end
                                return false
                            end
                        -------------------------------------------------------------------
                        ---- 码头地皮
                            if TheWorld.Map:IsDockAtPoint(tile_x,0,tile_z) then
                                if inst.tile_outline then
                                    inst.tile_outline:PushEvent("Set",{
                                        color = Vector3(255,0,0),
                                        MultColour_Flag = true,
                                    })
                                end
                                return false
                            end
                        -------------------------------------------------------------------
                        ---- 有船在那个位置
                            local outside_pts = {
                                Vector3(tile_x,0,tile_z),   --- 中心点
                                Vector3(tile_x+2,0,tile_z+2),   --- 四角
                                Vector3(tile_x+2,0,tile_z-2),   --- 四角
                                Vector3(tile_x-2,0,tile_z+2),   --- 四角
                                Vector3(tile_x-2,0,tile_z-2),   --- 四角
                                Vector3(tile_x,0,tile_z+2),   --- 边线
                                Vector3(tile_x,0,tile_z-2),   --- 边线
                                Vector3(tile_x+2,0,tile_z),   --- 边线
                                Vector3(tile_x-2,0,tile_z),   --- 边线
                            }
                            for k, temp_pt in pairs(outside_pts) do
                                if TheWorld.Map:GetPlatformAtPoint(temp_pt.x, temp_pt.z) ~= nil then
                                    if inst.tile_outline then
                                        inst.tile_outline:PushEvent("Set",{
                                            color = Vector3(255,0,0),
                                            MultColour_Flag = true,
                                        })
                                    end
                                    return false
                                end
                            end
                            
                        -------------------------------------------------------------------
                            return true
                        -------------------------------------------------------------------
                    end
                end)
                if crash_flag then
                    return ret or false
                end
                return false
            end)
            replica_com:SetDistance(5.5)
            replica_com:SetSGAction("dig_start")
            replica_com:SetText("fwd_in_pdt_equipment_ocean_fork",STRINGS.ACTIONS.DIG)
            replica_com:SetAllowCanCastOnImpassable(true)
            -- replica_com:SetPreActionFn(function(inst,doer,target,pt)
            --     if pt then
            --         print(pt.x,pt.y,pt.z)
            --     end
            -- end)
            replica_com:SetTextUpdateFn(function(inst,doer,target,pt)
                if target == nil and pt then
                    replica_com:SetText("fwd_in_pdt_equipment_ocean_fork","开挖")
                    return
                end
                replica_com:SetText("fwd_in_pdt_equipment_ocean_fork","挖掉")
            end)
            replica_com:SetPriority(10)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_point_and_target_spell_caster")
            inst.components.fwd_in_pdt_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                if not pt then
                    return false
                end
                ------------------------------------------------------------------------------------------------------------------------
                --[[
                    空白陆地 tile : 4
                    海洋： 201 202
                    洞穴里的虚空tile 为 1
                ]]--
                ------------------------------------------------------------------------------------------------------------------------
                    inst.components.finiteuses:Use()
                ------------------------------------------------------------------------------------------------------------------------
                ---- 地皮中心点
                    local tile_x,tile_y,tile_z = TheWorld.Map:GetTileCenterPoint(pt.x,0,pt.z)
                    local current_tile = TheWorld.Map:GetTileAtPoint(tile_x, 0, tile_z)
                    local tile_map_x,tile_map_y = TheWorld.Map:GetTileXYAtPoint(tile_x,0,tile_z)
                ------------------------------------------------------------------------------------------------------------------------
                ---- 打印当前 tile
                    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                        local tile = TheWorld.Map:GetTileAtPoint(tile_x, 0, tile_z)
                        print("current tile",tile)
                    end
                ------------------------------------------------------------------------------------------------------------------------
                ---- 目标位置是地面，改成 海洋/虚空   TheWorld.Map:SetTile(the_x,the_y, temp_tile)
                    if TheWorld.Map:IsLandTileAtPoint(tile_x,0,tile_z) then
                        if TheWorld:HasTag("cave") then
                            TheWorld.Map:SetTile(tile_map_x,tile_map_y,1)
                        else
                            TheWorld.Map:SetTile(tile_map_x,tile_map_y,202)
                        end
                        return true
                    end
                ------------------------------------------------------------------------------------------------------------------------
                    ---- 目标位置是 虚空。切成陆地
                    if current_tile == 1 or TheWorld.Map:IsValidTileAtPoint(tile_x, 0, tile_z) then
                        TheWorld.Map:SetTile(tile_map_x,tile_map_y,4)
                        return true
                    end
                ------------------------------------------------------------------------------------------------------------------------
                ---- 目标位置是 海洋。切成陆地
                    if TheWorld.Map:IsOceanAtPoint(tile_x, 0, tile_z) then
                        TheWorld.Map:SetTile(tile_map_x,tile_map_y,4)
                        return true
                    end
                ------------------------------------------------------------------------------------------------------------------------
                
                return true
            end)
        end
    -----------------------------------------------------------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("cane")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_equipment_ocean_fork"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_equipment_ocean_fork.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	-- inst.components.equippable.restrictedtag = "moonlightcoda"   --- 角色专属武器


    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(2000)
        inst.components.finiteuses:SetUses(2000)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_equipment_ocean_fork", fn, assets)
