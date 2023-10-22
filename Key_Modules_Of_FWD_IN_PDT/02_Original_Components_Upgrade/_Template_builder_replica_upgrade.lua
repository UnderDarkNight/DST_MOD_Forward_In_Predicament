----------------- 用这个api 修改 replica 单纯是为了兼容其他MOD 
AddClassPostConstruct("components/builder_replica", function(self)
    
    -- self.KnowsRecipe_old__npc_mod__2 = self.KnowsRecipe
    -- function self:KnowsRecipe(recipe,ignore_tempbonus)
    --     if recipe == nil then
    --         return false
    --     end
    --     local crash_flag,ret = pcall(function()
    --         return {self:KnowsRecipe_old__npc_mod__2(recipe,ignore_tempbonus)}
    --     end)
    --     if crash_flag == false then
    --         return false
    --     else
    --         return unpack(ret)
    --     end
    -- end

end)