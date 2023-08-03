-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 初始化刷角色创建位置

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- AddPlayerPostInit(function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end

--     if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE ~= true or inst.prefab ~= "woodie" then
--         return
--     end


--     inst.components.fwd_in_pdt_func:Get_Or_Set_New_Spawn_Pt_Fn(function()
--         local pigking = TheSim:FindFirstEntityWithTag("king")
--         if pigking and pigking.prefab == "pigking" then
--             local temp_pt = Vector3(pigking.Transform:GetWorldPosition())
--             local range = 5
--             local offset = FindWalkableOffset(temp_pt,0,range,false,false) or Vector3(0,0,0)
--             local pt = Vector3(temp_pt.x + offset.x,0,temp_pt.z+offset.z)
--             return pt
--         end
--         return nil
--     end)


-- end)


