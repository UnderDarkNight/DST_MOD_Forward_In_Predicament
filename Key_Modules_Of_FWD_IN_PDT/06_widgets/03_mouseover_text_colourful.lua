------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 鼠标放上去的时候，目标显示的text 颜色
--- 需要配合组件 【scripts\components\fwd_in_pdt_func\11_mouserover_str_colourful.lua】
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddClassPostConstruct("widgets/hoverer",function(self)
	self.text.SetString__old_fwd_in_pdt = self.text.SetString
	self.text.SetString = function(text,str)
		local target = TheInput:GetHUDEntityUnderMouse()
		if target ~= nil then
			target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
		else
			target = TheInput:GetWorldEntityUnderMouse()
		end


		if target and  target.entity and target:IsValid() and target:HasTag("fwd_in_pdt_tag.fwd_in_pdt_func.Colourful") then
            -- print("fwd_in_pdt_com_mouseover_colourful")
            local r,g,b,a = target.replica.fwd_in_pdt_func:Mouseover_GetColour()
            -- print(r,g,b,a)
            if r then
                text:SetColour(r,g,b,a)
            end
		end

		return text.SetString__old_fwd_in_pdt(text,str)
	end
end)