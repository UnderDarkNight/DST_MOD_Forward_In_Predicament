------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 对女武神的加强
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "spear_wathgrithr",
    function(inst)


        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "lightninggoathorn" and doer and doer.prefab == "wathgrithr" then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("dohungrybuild")     --- sg 动作
            replica_com:SetText("lightninggoathorn",STRINGS.ACTIONS.APPLYMODULE)   --- 交互显示的文本(插入)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                local succeed_flag = true
                local x,y,z = inst.Transform:GetWorldPosition()
                item:Remove()
                inst:Remove()
                if succeed_flag then
                    SpawnPrefab("spear_wathgrithr_lightning").Transform:SetPosition(x, y, z)
                end
                return succeed_flag
            end)
        end


        if not TheWorld.ismastersim then
            return
        end
    end
)