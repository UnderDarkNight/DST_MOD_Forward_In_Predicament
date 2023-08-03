if TUNING["Forward_In_Predicament.AnimStateFn"] == nil then
    TUNING["Forward_In_Predicament.AnimStateFn"] = {}
end

TUNING["Forward_In_Predicament.AnimStateFn"]["00_PlayAnim_PushAnim"] = function(theAnimState)

    if theAnimState.PlayAnimation_old_fwd_in_pdt == nil then  --- 避免重复hook
        
        ----------------------------------------------------------------------------------
        theAnimState.PlayAnimation_old_fwd_in_pdt = theAnimState.PlayAnimation
        theAnimState.PlayAnimation = function(self,anim_name,...)            
            local player = self.get_inst_by_fwd_in_pdt and self.get_inst_by_fwd_in_pdt(self,self)
            -- if player and player:HasTag("player") then
            --     print("PlayAnimation",anim_name,player)
            -- end
            self:PlayAnimation_old_fwd_in_pdt(anim_name,...)
        end
        ----------------------------------------------------------------------------------
        theAnimState.PushAnimation_old_fwd_in_pdt = theAnimState.PushAnimation
        theAnimState.PushAnimation = function(self,anim_name,...)
            local player = self.get_inst_by_fwd_in_pdt and self.get_inst_by_fwd_in_pdt(self,self)
            -- if player and player:HasTag("player") then
            --     print("PushAnimation",anim_name,player)
            -- end
            self:PushAnimation_old_fwd_in_pdt(anim_name,...)
        end
        ----------------------------------------------------------------------------------
    end

end