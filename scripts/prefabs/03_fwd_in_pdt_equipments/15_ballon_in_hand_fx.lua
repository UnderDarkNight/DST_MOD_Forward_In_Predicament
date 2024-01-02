------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    气球

    四面体：
        down  --- 玩家向下走的时候
        side  --- 玩家向右走的时候
        up    --- 玩家向上走的时候
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_equipment_loong_balloon.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_equipment_loong_balloon.xml" ),

}
--------------------------------------------------------------------------------------------------


local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()


    inst.Transform:SetFourFaced()   --- 配置四面体    
    inst.AnimState:SetBank("fwd_in_pdt_equipment_loong_balloon")
    inst.AnimState:SetBuild("fwd_in_pdt_equipment_loong_balloon")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("fx")
    inst:AddTag("FX")
    inst.entity:SetPristine()

    return inst
end

return Prefab("fwd_in_pdt_equipment_balloon_fx", fx, assets)
