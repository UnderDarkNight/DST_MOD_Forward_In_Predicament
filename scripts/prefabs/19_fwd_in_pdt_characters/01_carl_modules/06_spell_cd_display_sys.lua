--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    技能CD显示系统等

    直接走RPC信道

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        ------------------------------------------------------------------------------------
        ---- 强制在 replica 加个模块
            local replica_func = inst.replica.fwd_in_pdt_func or inst.replica._.fwd_in_pdt_func
            replica_func.TempData.spells_data = {}
            function replica_func:Spell_Get(index)
                if index ~= nil then
                    return self.TempData.spells_data[index]
                else
                    return nil
                end    
            end
            function replica_func:Spell_Set(index,value)
                if index then
                    self.TempData.spells_data[index] = value
                end
            end
        ------------------------------------------------------------------------------------
        ---- 展示 指示条
            if ThePlayer and ThePlayer == inst and ThePlayer.HUD then
                ThePlayer.HUD:fwd_in_pdt_carl_spell_bar()
            end
        ------------------------------------------------------------------------------------

        if not TheWorld.ismastersim then
            return
        end

        ------------------------------------------------------------------------------------
        --- 直接通过RPC下发
            function inst.components.fwd_in_pdt_func:Spell_Set(index,value)
                if type(index) == "string" then
                    SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["spell"],self.inst.userid,index,value)
                end
            end
        ------------------------------------------------------------------------------------
    end)
end