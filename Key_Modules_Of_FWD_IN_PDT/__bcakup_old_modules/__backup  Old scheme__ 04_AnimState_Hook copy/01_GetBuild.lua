if TUNING.NPC_UPGRADE_ANIMSTATE_FN == nil then
    TUNING.NPC_UPGRADE_ANIMSTATE_FN = {}
end

TUNING.NPC_UPGRADE_ANIMSTATE_FN["01_GetBuild"] = function(theAnimState)

    -- if theAnimState.GetBuild___old_npc == nil then
    --     theAnimState.GetBuild___old_npc = theAnimState.GetBuild
    --     theAnimState.GetBuild = function(self,...)
    --         local ret = {self:GetBuild___old_npc()}
    --         -- local inst = self.get_inst_4_npc(self,self)
    --         -- if inst and inst.Change_Item_Skin_Build_name then
    --         --     print("info:GetBuild__test",inst.Change_Item_Skin_Build_name)
    --         --     return inst.Change_Item_Skin_Build_name
    --         -- end
    --         print("info:GetBuild",unpack(ret))
    --         return unpack(ret)
    --     end
    -- end

    -- if theAnimState.GetSkinBuild___old_npc == nil then
    --     theAnimState.GetSkinBuild___old_npc = theAnimState.GetSkinBuild
    --     theAnimState.GetSkinBuild = function(self,...)
    --         local ret = {self:GetSkinBuild___old_npc()}
    --         local inst = self.get_inst_4_npc(self,self)
    --         if inst and inst.Change_Item_Skin_Build_name then
    --             print("info:GetSkinBuild and retrun",inst.Change_Item_Skin_Build_name)
    --             return inst.Change_Item_Skin_Build_name
    --         end
    --         return unpack(ret)
    --     end
    -- end


    -- if theAnimState.OverrideSymbol__old_test == nil then
    --     theAnimState.OverrideSymbol__old_test = theAnimState.OverrideSymbol
    --     theAnimState.OverrideSymbol = function(self,layer,build,layer2)
    --         if layer and build and layer2 then
    --             print(layer,build,layer2)
    --             self:OverrideSymbol__old_test(layer,build,layer2)
    --         else
    --             print("error : ",layer,build,layer2)
    --         end
    --     end
    -- end

end