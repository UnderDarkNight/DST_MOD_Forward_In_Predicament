if TUNING["Forward_In_Predicament.AnimStateFn"] == nil then
    TUNING["Forward_In_Predicament.AnimStateFn"] = {}
end

TUNING["Forward_In_Predicament.AnimStateFn"]["00_PlayAnim_PushAnim"] = function(theAnimState)

    ------ 
    if theAnimState.PlayAnimation_old_fwd_in_pdt == nil then  --- 避免重复hook        
        ----------------------------------------------------------------------------------
        theAnimState.PlayAnimation_old_fwd_in_pdt = theAnimState.PlayAnimation
        theAnimState.PlayAnimation = function(self,anim_name,...)         
            if self.inst and self.inst:HasTag("player") then   
                -- print("PlayAnimation",self.inst,anim_name)
            end
            self:PlayAnimation_old_fwd_in_pdt(anim_name,...)
        end
        ----------------------------------------------------------------------------------
        theAnimState.PushAnimation_old_fwd_in_pdt = theAnimState.PushAnimation
        theAnimState.PushAnimation = function(self,anim_name,...)
            if self.inst and self.inst:HasTag("player") then   
                -- print("PushAnimation",self.inst,anim_name)
            end
            self:PushAnimation_old_fwd_in_pdt(anim_name,...)
        end
        ----------------------------------------------------------------------------------
    end

end