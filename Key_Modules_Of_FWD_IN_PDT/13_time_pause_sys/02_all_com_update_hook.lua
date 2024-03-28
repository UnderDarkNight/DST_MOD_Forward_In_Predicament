----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    侵入修改所有com 的 OnUpdate 函数

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local skip_components_list = {
    ["container"] = true, --- 跳过container
}
AddGlobalClassPostConstruct("entityscript","EntityScript",function(self)
    local old_AddComponent = self.AddComponent
    self.AddComponent = function(self,name, ...)
        local origin_rets = {old_AddComponent(self, name, ...)}
        if not skip_components_list[name] and self.components[name].OnUpdate then 
                local temp_component = self.components[name]
                local old_OnUpdate_fn = temp_component.OnUpdate
                temp_component.OnUpdate = function(self, ...)
                    if self.inst:HasTag("fwd_in_pdt_tag.time_pause") then 
                        return 
                    else
                        return old_OnUpdate_fn(self, ...)
                    end
                end
        end
        return unpack(origin_rets)
    end
end)
