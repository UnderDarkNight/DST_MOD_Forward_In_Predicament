--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 自制的皮肤切换工具，可以切换本MOD的带皮肤的东西，可以 前后随便切换
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_reskin_tool = Class(function(self, inst)
    self.inst = inst
end)

function fwd_in_pdt_com_reskin_tool:NextSkin(target,doer)
    if target and target:HasTag("fwd_in_pdt_com_skins") and doer then
        doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(target)
    end
end
function fwd_in_pdt_com_reskin_tool:LastSkin(target,doer)
    if target and target:HasTag("fwd_in_pdt_com_skins") and doer then
        doer.components.fwd_in_pdt_func:SkinAPI__Set_Target_Next_Skin(target,true)
    end
end

return fwd_in_pdt_com_reskin_tool