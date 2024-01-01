------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    烹饪锅组件

    添加个事件，实现烹饪锅瞬间完成
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddComponentPostInit("stewer", function(stewer_com)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------
    -- 烹饪锅的代码直接复制，可能会随着科雷更新造成bug
    ----------------------------------------------------------------------------------
        -- local function dostew(inst, self)
        --     self.task = nil
        --     self.targettime = nil
        --     self.spoiltime = nil
        
        --     if self.ondonecooking ~= nil then
        --         self.ondonecooking(inst)
        --     end
        
        --     if self.product == self.spoiledproduct then
        --         if self.onspoil ~= nil then
        --             self.onspoil(inst)
        --         end
        --     elseif self.product ~= nil then
        --         local recipe = cooking.GetRecipe(inst.prefab, self.product)
        --         local prep_perishtime = (recipe ~= nil and (recipe.cookpot_perishtime or recipe.perishtime)) or 0
        --         if prep_perishtime > 0 then
        --             local prod_spoil = self.product_spoilage or 1
        --             self.spoiltime = prep_perishtime * prod_spoil
        --             self.targettime =  GetTime() + self.spoiltime
        --             self.task = self.inst:DoTaskInTime(self.spoiltime, dospoil, self)
        --         end
        --     end
        
        --     self.done = true
        -- end
    ----------------------------------------------------------------------------------
    
    stewer_com.inst:ListenForEvent("fwd_in_pdt_event.stewer_finish",function(inst)
        if stewer_com:IsCooking() and not stewer_com:IsDone() then
            if type(stewer_com.targettime) == "number" then 
                -- dostew(inst,stewer_com)
                -- stewer_com:LongUpdate(10000)    ---- 找到个更快捷的方法

                    --- self.targettime - dt - GetTime() = 0
                    local dt = stewer_com.targettime - GetTime()
                    if dt > 0 then
                        stewer_com:LongUpdate( dt )    ---- 找到个更快捷的方法
                    end
            end
        end
    end)

end)