------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 自己试验的升级长矛 对女武神的加强
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "spear",
    function(inst)


        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "fwd_in_pdt_material_chaotic_eyeball" and doer and doer:HasTag("player") then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("dohungrybuild")     --- sg 动作
            replica_com:SetText("fwd_in_pdt_material_chaotic_eyeball",STRINGS.ACTIONS.APPLYMODULE)   --- 交互显示的文本(插入)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                local succeed_flag = true
                
                local x,y,z = inst.Transform:GetWorldPosition()
                -- SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{target = inst})  -- 想做特效也不是不行
                item:Remove()
                inst:Remove()
                if succeed_flag then
                    -- SpawnPrefab("fwd_in_pdt_building_special_cookpot").Transform:SetPosition(x, y, z)
                    SpawnPrefab("spear_wathgrithr").Transform:SetPosition(x, y, z)
                end
                return succeed_flag
            end)
        end


        if not TheWorld.ismastersim then
            return
        end


    end
)