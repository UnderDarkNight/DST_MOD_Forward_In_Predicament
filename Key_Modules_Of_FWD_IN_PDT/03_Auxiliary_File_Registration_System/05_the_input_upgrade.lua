--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local TheInput = require("input")
--------------------------------------------------------------------------------------
    TheInput.__fwd_in_pdt_modify_fns = {}
    TheInput.__fwd_in_pdt_remove_fn = function(inst)
        TheInput:FWD_IN_PDT_Remove_Update_Modify_Fn(inst)
    end
    function TheInput:FWD_IN_PDT_Add_Update_Modify_Fn(inst,fn)
        if inst and type(fn) == "function" then
            self.__fwd_in_pdt_modify_fns[inst] = fn
        end
        inst:ListenForEvent("onremove",self.__fwd_in_pdt_remove_fn)
        -- print("TheInput add update modify fn",inst)
    end
    function TheInput:FWD_IN_PDT_Remove_Update_Modify_Fn(inst)
        local new_table = {}
        for k,v in pairs(self.__fwd_in_pdt_modify_fns) do
            if k ~= inst then
                new_table[k] = v
            end
        end
        self.__fwd_in_pdt_modify_fns = new_table
        inst:RemoveEventCallback("onremove",self.__fwd_in_pdt_remove_fn)
        -- print("TheInput remove update modify fn",inst)
    end

--------------------------------------------------------------------------------------
---
    local old_OnUpdate = TheInput.OnUpdate
    function TheInput:OnUpdate(...)
        if ThePlayer then
            for k,v in pairs(self.__fwd_in_pdt_modify_fns) do
                if k and k:IsValid() and ( k.Transform == nil or ThePlayer:GetDistanceSqToInst(k) < 2500 ) then
                    v()
                end
            end
        end
        return old_OnUpdate(self,...)
    end
--------------------------------------------------------------------------------------