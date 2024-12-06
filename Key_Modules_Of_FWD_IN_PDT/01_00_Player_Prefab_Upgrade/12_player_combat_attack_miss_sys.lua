-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    玩家打架Miss 系统
    
    挂载的函数 return true 的时候，就 跳出官方原有的 系统

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end
    if inst.components.combat == nil then
        return
    end
    ----------------------------------------------------------------------------------------------------------
    ----
        local combat = inst.components.combat

    ----------------------------------------------------------------------------------------------------------
    ----
        combat.__fwd_in_pdt_miss_fns = {}

        local remove_fn_for_index = function(index_inst)
            combat:Fwd_In_Pdt_Remove_Miss_Check(index_inst)
        end

        function combat:Fwd_In_Pdt_Add_Miss_Check(index_inst,fn)
            if not (index_inst and inst.ListenForEvent ) then
                return
            end
            self.__fwd_in_pdt_miss_fns[index_inst] = fn
            index_inst:ListenForEvent("onremove",remove_fn_for_index)
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("添加 miss fn",index_inst)
            end
        end
        function combat:Fwd_In_Pdt_Remove_Miss_Check(index_inst)
            local new_table = {}
            for temp_index, fn in pairs(self.__fwd_in_pdt_miss_fns) do
                if temp_index ~= index_inst then
                    new_table[temp_index] = fn
                end                
            end
            self.__fwd_in_pdt_miss_fns = new_table
            index_inst:RemoveEventCallback("onremove",remove_fn_for_index)
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("移除 miss fn",index_inst)
            end

        end
    ----------------------------------------------------------------------------------------------------------
    ----
        local old_combat_DoAttack_fn = combat.DoAttack
        combat.DoAttack = function(self,...)
            for index_inst, temp_fn in pairs(self.__fwd_in_pdt_miss_fns) do
                if temp_fn and temp_fn(...) then
                    return
                end
            end
            old_combat_DoAttack_fn(self,...)
        end
    ----------------------------------------------------------------------------------------------------------
end)
