------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让猪人房子可以接收2种皮并转换成雕像
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPrefabPostInit(
    "pighouse",
    function(inst)
        ---------------------------------------------------------------------------------------------------
        ---- 物品接受
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetTestFn(function(inst,item,doer,right_click)
                if inst:HasTag("fwd_in_pdt_tag.has_pig") and item 
                and ( item.prefab == "fwd_in_pdt_item_cursed_pig_skin" or item.prefab == "fwd_in_pdt_item_glass_pig_skin" ) then
                    return true
                else
                    return false
                end
            end)

            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                if not TheWorld.ismastersim then
                    return
                end
                if item then
                    local ret_prefab = nil
                    if item.prefab == "fwd_in_pdt_item_cursed_pig_skin" then
                        ret_prefab = "fwd_in_pdt_equipment_cursed_pig"
                    elseif item.prefab == "fwd_in_pdt_item_glass_pig_skin" then
                        ret_prefab = "fwd_in_pdt_equipment_glass_pig"
                    end
                    if ret_prefab then
                        local x,y,z = inst.Transform:GetWorldPosition()
                        SpawnPrefab(ret_prefab).Transform:SetPosition(x,y,z)
                        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                            pt = Vector3(x,y,z)
                        })
                        item:Remove()
                        inst:Remove()
                    end
                end
                return true
            end)
            inst.components.fwd_in_pdt_com_acceptable:SetActionDisplayStr("pighouse",STRINGS.SKILLTREE.PANELS.CURSE)
        ---------------------------------------------------------------------------------------------------


        if not TheWorld.ismastersim then
            return
        end


        if inst.components.spawner then
            ----- 猪人进了房子后
                if inst.components.spawner.onoccupied then
                    local old_onoccupied =  inst.components.spawner.onoccupied
                    inst.components.spawner.onoccupied = function(...)
                        inst:AddTag("fwd_in_pdt_tag.has_pig")
                        return old_onoccupied(...)
                    end
                end
            ----- 猪人离开房子
                if inst.components.spawner.onvacate then
                    local old_onvacate = inst.components.spawner.onvacate
                    inst.components.spawner.onvacate = function(...)
                        inst:RemoveTag("fwd_in_pdt_tag.has_pig")
                        return old_onvacate(...)
                    end
                end

        end

    end
)