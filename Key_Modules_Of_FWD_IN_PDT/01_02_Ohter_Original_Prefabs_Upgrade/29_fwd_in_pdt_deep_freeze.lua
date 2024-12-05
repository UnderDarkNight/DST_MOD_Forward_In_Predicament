-- 升级 冰柜 让里面变为无限堆叠

AddPrefabPostInit(
    "fwd_in_pdt_deep_freeze",
    function(inst)


        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "chestupgrade_stacksize" then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("fwd_in_pdt_special_pick")     --- sg 动作
            replica_com:SetText("chestupgrade_stacksize",STRINGS.ACTIONS.APPLYMODULE)   --- 交互显示的文本
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                local succeed_flag = true
                local x,y,z = inst.Transform:GetWorldPosition()
                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{target = inst})
                item:Remove()
                inst:Remove()
                if succeed_flag then
                    SpawnPrefab("fwd_in_pdt_deep_freeze_new").Transform:SetPosition(x, y, z)
                    local fx = SpawnPrefab("chestupgrade_stacksize_fx") -- 烟雾小的那个
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                return succeed_flag
            end)
        end


        if not TheWorld.ismastersim then
            return
        end


    end
)