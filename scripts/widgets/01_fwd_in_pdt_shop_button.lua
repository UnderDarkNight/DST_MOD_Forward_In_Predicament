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

	-- local txt_font = TALKINGFONT
	local txt_font = CODEFONT
	self.num2give_text = self:AddChild(Text(txt_font,35,"x10",{ 255/255 , 255/255 ,255/255 , 1}))
	self.num2give_text:SetPosition(30,-20)
	self.num2give_text:MoveToFront()

	local cost_color = { 150/255 , 255/255 ,150/255 , 1}
	if trade_back_flag then
		 cost_color = { 255/255 , 200/255 ,0/255 , 1}
	end
	self.cost_text = self:AddChild(Text(txt_font,35,"500",cost_color))
	self.cost_text:SetPosition(0,-75)

	local name_str = STRINGS.NAMES[string.upper(tostring(cmd_table.prefab))]
	self.name_text = self:AddChild(Text(TALKINGFONT,50,name_str,{ 255/255 , 255/255 ,255/255 , 1}))
	self.name_text:SetPosition(0,100)
	self.name_text:MoveToFront()
	self.name_text:Hide()

	local num2give = cmd_table.num2give or 1
	local cost = cmd_table.cost or 1
	local image = cmd_table.image
	local atlas = cmd_table.atlas
	local prefab = cmd_table.prefab

	--- VIP 购买打折 8折
	if not trade_back_flag and ThePlayer and ThePlayer:HasTag("fwd_in_pdt_tag.vip") then
		cost = math.ceil(cost * 0.8)
	end

	if trade_back_flag then		---- 卖出去的时候，数字是相反的
		num2give = cmd_table.cost or 1
		cost = cmd_table.num2give or 1
	end

	if image == "" then
		image = nil
	end
	if image == nil and type(prefab) == "string" then
		image = prefab .. ".tex"
	end

	if ( atlas == nil or atlas == "" )and image then
		atlas = GetInventoryItemAtlas(image)
	end



	if image == nil then
		print("shop widget button error",prefab,image,atlas)
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
		self.name_text:Show()
		self.anim:GetAnimState():PlayAnimation("button_mouseover")
	end
end

function AnimButton:OnLoseFocus()
	AnimButton._base.OnLoseFocus(self)

	if self:IsEnabled() then
		self.name_text:Hide()
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