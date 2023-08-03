--------------------------------------------------------------------------------------------------------------------------------------------
---- 给物品组件添加个 方便自用的 API
---- 切皮肤重置名字
--------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("named", function(self)


    function self:SetName_fwd_in_pdt(name)
        if name == nil then
            return
        end
        self.fwd_in_pdt_default_name = name
        self:SetName(name)
    end
    function self:fwd_in_pdt_reset_name()
        if self.fwd_in_pdt_default_name then
            self:SetName(self.fwd_in_pdt_default_name)
        end
    end

end)