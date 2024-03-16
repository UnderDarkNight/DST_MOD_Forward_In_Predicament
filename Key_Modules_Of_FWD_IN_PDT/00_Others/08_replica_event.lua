--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    注册 OnEntityReplicated 事件

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- AddClassPostConstruct("entityreplica", function(self)
    


-- end)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 方案 1 ，只在 client side 有效.没洞穴 就失效
    -- local function hook_EntityScript(self)
    --     if self.fwd_in_pdt_old_ReplicateEntity == nil then
    --         self.fwd_in_pdt_old_ReplicateEntity = self.ReplicateEntity
    --         self.ReplicateEntity = function(self,...)
    --             self.fwd_in_pdt_old_ReplicateEntity(self,...)
    --             self:PushEvent("fwd_in_pdt_event.OnEntityReplicated")

    --             self:DoTaskInTime(0,function()
    --                 print("info OnEntityReplicated",self)                
    --             end)

    --         end
    --     end
    --     -- local tempInst = CreateEntity()
    --     -- tempInst:DoTaskInTime(0,function()
    --     --     print("fake error OnEntityReplicated")
    --     --     print("fake error OnEntityReplicated")
    --     --     print("fake error OnEntityReplicated")
    --     --     print("fake error OnEntityReplicated")
    --     --     print("fake error OnEntityReplicated")
    --     --     tempInst:Remove()
    --     -- end)
    -- end


    -- hook_EntityScript(EntityScript)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 方案 2
    -- if rawget(_G,"_fwd_in_pdt_old_ReplicateEntity") == nil then
    --         local _fwd_in_pdt_old_ReplicateEntity = rawget(_G,"ReplicateEntity")
    --         rawset(_G,"_fwd_in_pdt_old_ReplicateEntity",_fwd_in_pdt_old_ReplicateEntity)
    --         rawset(_G, "ReplicateEntity", function(guid)
    --             _fwd_in_pdt_old_ReplicateEntity(guid)
    --             local inst = Ents[guid]
    --             inst:PushEvent("fwd_in_pdt_event.OnEntityReplicated")
    --             inst:DoTaskInTime(0,function()
    --                 print("info OnEntityReplicated",inst)                
    --             end)
    --         end)
    -- end

    if EntityScript.ReplicateComponent_fwd_in_pdt_old_fn == nil then

        -- EntityScript.ReplicateComponent
        EntityScript.ReplicateComponent_fwd_in_pdt_old_fn = EntityScript.ReplicateComponent
        EntityScript.ReplicateComponent = function(self,name)
            self.ReplicateComponent_fwd_in_pdt_old_fn(self,name)
            local replica_com = self.replica[name] or self.replica._[name]
            if replica_com then
                self:PushEvent("fwd_in_pdt_event.OnEntityReplicated."..tostring(name),replica_com)
                self.replica[name] = replica_com
            end
        end

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------