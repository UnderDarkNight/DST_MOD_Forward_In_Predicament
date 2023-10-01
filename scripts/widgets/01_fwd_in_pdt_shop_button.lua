local Widget = require "widgets/widget"
local Button = require "widgets/button"
local UIAnim = require "widgets/uianim"
local Image = require "widgets/image" -- 引入image控件
local Text = require "widgets/text"


local AnimButton = Class(Button, function(self, cmd_table,trade_back_flag)
    Button._ctor(self, "AnimButton")
    self.anim = self:AddChild(UIAnim())
    self.anim:MoveToBack()
    self.anim:GetAnimState():SetBuild("fwd_in_pdt_hud_shop_widget")
    self.anim:GetAnimState():SetBank("fwd_in_pdt_hud_shop_widget")



    self.anim:GetAnimState():PlayAnimation("button_idle")
    self.anim:GetAnimState():SetRayTestOnBB(true);	---- 暂时不知道干嘛用的


	self.image_widget = self:AddChild(Image())
	self.image_widget:SetPosition(0,20)

	
	self.num2give_text = self:AddChild(Text(TALKINGFONT,35,"x10",{ 255/255 , 255/255 ,255/255 , 1}))
	self.num2give_text:SetPosition(30,-20)
	self.num2give_text:MoveToFront()

	local cost_color = { 150/255 , 255/255 ,150/255 , 1}
	if trade_back_flag then
		 cost_color = { 255/255 , 200/255 ,0/255 , 1}
	end
	self.cost_text = self:AddChild(Text(TALKINGFONT,35,"500",cost_color))
	self.cost_text:SetPosition(0,-75)


	local num2give = cmd_table.num2give or 1
	local cost = cmd_table.cost or 1
	local image = cmd_table.image
	local atlas = cmd_table.atlas
	local prefab = cmd_table.prefab

	if ( image == nil or image == "" ) and type(prefab) == "string" then
		image = prefab .. ".tex"
	else
		image = nil
	end

	if ( atlas == nil or atlas == "" )and image then
		atlas = GetInventoryItemAtlas(image)
	end



	if image == nil then
		self:Hide()
		self:Disable()		
	else
		self.image_widget:SetTexture(atlas,image)
		self.cost_text:SetString(tostring(cost))
		self.num2give_text:SetString("x"..tostring(num2give))
	end

end)

function AnimButton:OnGainFocus()
	AnimButton._base.OnGainFocus(self)

    if self:IsEnabled() then
		self.anim:GetAnimState():PlayAnimation("button_mouseover")
	end
end

function AnimButton:OnLoseFocus()
	AnimButton._base.OnLoseFocus(self)

	if self:IsEnabled() then
		self.anim:GetAnimState():PlayAnimation("button_idle")
    end
end


function AnimButton:Enable()
	AnimButton._base.Enable(self)
	--self.text:SetColour(1,1,1,1)
end

function AnimButton:Disable()
	AnimButton._base.Disable(self)
	--self.text:SetColour(.7,.7,.7,1)
end

return AnimButton