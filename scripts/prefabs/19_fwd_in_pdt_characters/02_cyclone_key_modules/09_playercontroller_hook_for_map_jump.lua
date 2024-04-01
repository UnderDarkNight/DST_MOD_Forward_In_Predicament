--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        


        if inst.components.playercontroller == nil then
            return
        end



        local old_GetMapActions_fn = inst.components.playercontroller.GetMapActions
        inst.components.playercontroller.GetMapActions = function(self,position)
            local LMBaction, RMBaction = old_GetMapActions_fn(self, position)

            ----------------------------------------------------------------------------------------
                    -- local inventory = self.inst.components.inventory or self.inst.replica.inventory
                    -- if inventory and inventory:EquipHasTag("mms_scroll_blink_map") then
                    --     local equipments = self.inst.replica.inventory and self.inst.replica.inventory:GetEquips() or {}
    
                    --     -------- 获取装备，用于放到 act.invobject 里
                    --         local invobject = nil
                    --         for e_slot, e_item in pairs(equipments) do
                    --             if e_item and e_item:HasTag("mms_scroll_blink_map") then
                    --                 invobject = e_item
                    --                 break
                    --             end
                    --         end
    
                        
                    -- end
            ----------------------------------------------------------------------------------------
                        local act = BufferedAction(self.inst, nil, ACTIONS.FWD_IN_PDT_BLINK_MAP)
                        RMBaction = self:RemapMapAction(act, position)
            ----------------------------------------------------------------------------------------
    
    
            return LMBaction, RMBaction    
        end







        local old_OnMapAction_fn = inst.components.playercontroller.OnMapAction
        inst.components.playercontroller.OnMapAction = function(self,actioncode, position)
            old_OnMapAction_fn(self,actioncode, position)

            if self.inst.replica.fwd_in_pdt_com_map_jumper and self.inst.replica.fwd_in_pdt_com_map_jumper:Test(position) then

                local act = MOD_ACTIONS_BY_ACTION_CODE[STRINGS.FWD_IN_PDT_BLINK_MAP][actioncode]
                if act == nil or not act.map_action then
                    return
                end
                if self.ismastersim then

                            local LMBaction, RMBaction = self:GetMapActions(position)
                            if act.rmb and RMBaction then ---- 右键
                                -- print("error rmb",position)
                                -- for k, v in pairs(act) do
                                --     print(k,v)
                                -- end
                                -- print("error rmb ++++++ ",position)
                                -- for k, v in pairs(RMBaction or {}) do
                                --     print(k,v)
                                -- end
                                -- self:DoAction(BufferedAction(self.inst, nil, ACTIONS.MMS_SCROLL_BLINK_MAP))
                                -- self:DoAction(BufferedAction(self.inst,nil, RMBaction))
                                -- self:DoAction(RMBaction)
                                -- self.locomotor:PushAction(RMBaction, true)
                                RMBaction:Do()
                            end

                else
                    SendRPCToServer(RPC.DoActionOnMap, actioncode, position.x, position.z)                
                end
                
            end

        end












    end)
end