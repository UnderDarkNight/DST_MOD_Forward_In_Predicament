
if Assets == nil then
    Assets = {}
end

local temp_assets = {

	---------------------------------------------------------------------------
	Asset("ANIM", "anim/fwd_in_pdt_drawing_test.zip"),	--- 变异青蛙贴图包

	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

