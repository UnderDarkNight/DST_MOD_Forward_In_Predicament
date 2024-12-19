-- 升级 冰柜 让里面变为无限堆叠

AddPrefabPostInit(
    "fwd_in_pdt_deep_freeze",
    function(inst)


        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if inst.replica.container:IsInfiniteStackSize() then
                    return false
                end
                if item and item.prefab == "chestupgrade_stacksize" then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("fwd_in_pdt_special_pick")     --- sg 动作
            replica_com:SetText("fwd_in_pdt_deep_freeze",STRINGS.ACTIONS.UPGRADE.GENERIC)   --- 交互显示的文本（升级）
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_acceptable")
            inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                local succeed_flag = true -- 这里通过了才能进行下面
                local x,y,z = inst.Transform:GetWorldPosition()
                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{target = inst})
                item:Remove()
                inst:AddTag("InfiniteStackSize")
                inst.components.container:EnableInfiniteStackSize(true)
                return succeed_flag
            end)
        end


        if not TheWorld.ismastersim then
            return
        end

        if inst.components.fwd_in_pdt_data == nil then
            inst:AddComponent("fwd_in_pdt_data")
        end

        inst.components.fwd_in_pdt_data:AddOnLoadFn(function()
            if inst.components.fwd_in_pdt_data:Get("InfiniteStackSize") then
                inst:AddTag("InfiniteStackSize")
                inst.components.container:EnableInfiniteStackSize(true)
            end
        end)
        inst.components.fwd_in_pdt_data:AddOnSaveFn(function()
            if inst:HasTag("InfiniteStackSize") then
                inst.components.fwd_in_pdt_data:Set("InfiniteStackSize",true)
            end
        end)

    end
)