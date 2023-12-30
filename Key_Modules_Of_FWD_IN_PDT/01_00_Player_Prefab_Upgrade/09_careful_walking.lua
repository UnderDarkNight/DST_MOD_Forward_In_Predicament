-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    
    谨慎走路状态
    用于骨折形态切换

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0,function()
        
        if type(inst.IsCarefulWalking) == "function" then

            inst.IsCarefulWalking_fwd_in_pdt_old = inst.IsCarefulWalking
            inst.IsCarefulWalking = function(self,...)
                if self:HasTag("fwd_in_pdt_tag.carefulwalking") and self.sg and self.sg.statemem then
                    self.sg.statemem.goosegroggy = true
                end
                return self:IsCarefulWalking_fwd_in_pdt_old(...)
            end

        end


        -- if type(inst.IsInAnyStormOrCloud) == "function" then
        --     inst.IsInAnyStormOrCloud_fwd_in_pdt_old = inst.IsInAnyStormOrCloud
        --     inst.IsInAnyStormOrCloud = function(self,...)
        --         if self:HasTag("fwd_in_pdt_tag.carefulwalking") then
        --             return true
        --         end
        --         return self:IsInAnyStormOrCloud_fwd_in_pdt_old(...)
        --     end


        -- end

    end)    
end)
