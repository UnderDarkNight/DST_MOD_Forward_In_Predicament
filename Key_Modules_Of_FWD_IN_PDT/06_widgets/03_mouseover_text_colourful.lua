------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 鼠标放上去的时候，目标显示的text 颜色
--- 需要配合组件 【scripts\components\fwd_in_pdt_func\11_mouserover_str_colourful.lua】
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddClassPostConstruct("widgets/hoverer",function(self)
	-----------------------------------------------------------------------------------------------------
	--- 有两个 child text 做一样的事情， self.text 和 self.secondarytext
		local new_SetString_fn = function(text,str)
			-- local target = TheInput:GetHUDEntityUnderMouse()
			-- if target ~= nil then
			-- 	target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
			-- else
			-- 	target = TheInput:GetWorldEntityUnderMouse()
			-- end

			local tempAction = ThePlayer.components.playercontroller:GetLeftMouseAction() or ThePlayer.components.playercontroller:GetRightMouseAction()
			local target = nil
			if tempAction then
				target = tempAction.target or tempAction.invobject
			end


			if target and  target.entity and target:IsValid() and target:HasTag("fwd_in_pdt_tag.fwd_in_pdt_func.Colourful") then
				local r,g,b,a = target.replica.fwd_in_pdt_func:Mouseover_GetColour()
				-- print(target,r,g,b,a)
				if r then
					text:SetColour(r,g,b,a)
				end
				local over_write_text = target.replica.fwd_in_pdt_func:Mouseover_GetText()
				if over_write_text then
					str = over_write_text
				end
			end

			return text.SetString__old_fwd_in_pdt(text,str)
		end
	-----------------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------------
	---- 处理鼠标放上去的文本。
		self.text.SetString__old_fwd_in_pdt = self.text.SetString
		self.text.SetString = new_SetString_fn
	-----------------------------------------------------------------------------------------------------
	---- secondarytext 是按 下 alt 等其他按键后 的辅助显示，暂时用不上
		-- self.secondarytext.SetString__old_fwd_in_pdt = self.secondarytext.SetString
		-- self.secondarytext.SetString = new_SetString_fn

		-- self.secondarytext.__Hide = self.secondarytext.Hide
		-- self.secondarytext.Hide = function(text,...)
		-- 	print("info secondarytext hide",text.string)
		-- 	text:__Hide(...)
		-- end
	-----------------------------------------------------------------------------------------------------


end)