-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 让空格键适配自己做的组件，实现自动动作
-- ---- PlayerController:GetActionButtonAction(force_target)
-- ---- GetPickupAction()
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AddComponentPostInit("playercontroller", function(self)

--     local old_GetActionButtonAction = self.GetActionButtonAction
--     function self:GetActionButtonAction(force_target)
--         local old_ret = old_GetActionButtonAction(self,force_target)
--         print("test GetActionButtonAction",force_target)
--         if old_ret then
--             return old_ret
--         end




--         return nil
--     end


-- end)