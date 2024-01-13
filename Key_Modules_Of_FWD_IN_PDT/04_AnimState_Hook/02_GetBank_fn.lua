--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    插入一条函数，方便后续继续调用。
    AnimState:GetBank 
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local tempInst = CreateEntity()
tempInst.entity:AddTransform()
tempInst.entity:AddAnimState()


local theAnimState = getmetatable(tempInst.AnimState).__index  ------ 侵入userdata 修改函数

if type(theAnimState) == "table" and theAnimState.GetBank == nil then

    local old_set_bank = theAnimState.SetBank
    theAnimState.temp_banks = theAnimState.temp_banks or {}
    theAnimState.SetBank = function(self,bank)
        old_set_bank(self,bank)
        self.temp_banks[self] = bank
    end

    theAnimState.GetBank = function(self)
        local temp_banks = self.temp_banks or {}
        return temp_banks[self]
    end

end

tempInst:Remove()