------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 让 刮 树 出树脂
--- event    ：   fwd_in_pdt_event.action.shave
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local trees = {
    "evergreen",
    "evergreen_normal",
    "evergreen_tall",
    "evergreen_short",
    "evergreen_sparse",
    "evergreen_sparse_normal",
    "evergreen_sparse_tall",
    "evergreen_sparse_short",
}


for k, prefab in pairs(trees) do
    AddPrefabPostInit(
        prefab,
        function(inst)
            --------------------------------------------------------------------------
            --- 添加交互组件
                inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_acceptable",function(inst,replica_com)
                    replica_com:SetTestFn(function(inst,item,doer,right_click)
                        return ( TheWorld.state.issummer or TheWorld.state.isautumn) and not inst:HasTag("burnt") and item and item.prefab == "razor" or false
                    end)
                    replica_com:SetSGAction("fwd_in_pdt_special_pick")     --- sg 动作
                    replica_com:SetText("evergreen_shave_for_resin",STRINGS.ACTIONS.SHAVE.GENERIC)   --- 交互显示的文本
                end)
                if TheWorld.ismastersim then
                    inst:AddComponent("fwd_in_pdt_com_acceptable")
                    inst.components.fwd_in_pdt_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                        item:PushEvent("fwd_in_pdt_event.action.shave",{
                            item = item,
                            target = inst,
                            doer = doer
                        })
                        -- doer.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_material_tree_resin",3)      
                        if math.random(1000) <= 800 then
                            doer.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_material_tree_resin",6)
                        else     
                            doer.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_material_tree_resin",3)
                        end              


                        return true
                    end)
                end
            --------------------------------------------------------------------------

            if not TheWorld.ismastersim then
                return
            end



        end
    )
end



