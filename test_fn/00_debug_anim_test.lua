
-- local tempInst = CreateEntity()
-- tempInst.entity:AddTransform()
-- tempInst.entity:AddAnimState()


-- local theAnimState = getmetatable(tempInst.AnimState).__index  ------ 侵入userdata 修改函数


-- --     -- theAnimState.save_inst = function(self,inst)
-- --     --     -- self is userdata
-- --     --     if getmetatable(self).__index.save_inst_data == nil then
-- --     --         getmetatable(self).__index.save_inst_data = {}
-- --     --     end
-- --     --     getmetatable(self).__index.save_inst_data[self] = inst
-- --     -- end
-- --     -- theAnimState.get_inst = function(self)
-- --     --     -- self is userdata
-- --     --     if getmetatable(self).__index.save_inst_data then
-- --     --         return getmetatable(self).__index.save_inst_data[self]
-- --     --     end
-- --     -- end


-- --     -- theAnimState.PlayAnimation_old = theAnimState.PlayAnimation
-- --     -- theAnimState.PlayAnimation = function(self,anim,...)
-- --     --     if self.get_inst and self.get_inst(self,self) then
-- --     --         local inst = self.get_inst(self,self)
-- --     --         if inst then
-- --     --             print("PlayAnimation:",anim)
-- --     --         end
-- --     --     end
-- --     --     theAnimState.PlayAnimation_old(self,anim,...)
-- --     -- end

-- --     -- theAnimState.PushAnimation_old = theAnimState.PushAnimation
-- --     -- theAnimState.PushAnimation = function(self,anim,...)
-- --     --     if self.get_inst and self.get_inst(self,self) then
-- --     --         local inst = self.get_inst(self,self)
-- --     --         if inst then
-- --     --             print("PushAnimation:",anim)
-- --     --         end
-- --     --     end
-- --     --     theAnimState.PushAnimation_old(self,anim,...)
-- --     -- end

-- --     -- local SetBank = theAnimState

-- local old_set_bank = theAnimState.SetBank
-- theAnimState.temp_banks = theAnimState.temp_banks or {}
-- theAnimState.SetBank = function(self,bank)
--     old_set_bank(self,bank)
--     self.temp_banks[self] = bank
-- end

-- theAnimState.GetBank = function(self)
--     local temp_banks = self.temp_banks or {}
--     return temp_banks[self]
-- end

-- tempInst:Remove()


-- -- -- AddPlayerPostInit(function(inst) 
-- -- --     inst.AnimState:save_inst(inst)
-- -- -- end)