-- -- AddComponentPostInit("builder_replica", function(self)
-- --     self.KnowsRecipe_old = self.KnowsRecipe
-- --     self.KnowsRecipe = 
-- -- end)

-- local com_builder_replica = _G.require "components/builder_replica"
-- com_builder_replica.KnowsRecipe_old__npc_mod = com_builder_replica.KnowsRecipe
-- com_builder_replica.KnowsRecipe = function(self,recipe, ignore_tempbonus)
--     if recipe == nil then
--         print("++++++++++++++++++++++++++ com_builder_replica error : recipe is nil")
--         return false
--     end 
--     local flag ,ret = pcall(function()
--         local ret = {self:KnowsRecipe_old__npc_mod(recipe,ignore_tempbonus)}
--         return ret
--     end)
--     if flag == true then
--         return unpack(ret)
--     else
--         return false
--     end
-- end