-------------------------------------------------------------------------------------------------------------------------------
-- 说明：
-- 如果物品有图标切换，需要使用 inst.components.inventoryitem:fwd_in_pdt_icon_init("gift_large2") 进行图标初始化。
-- inst.components.inventoryitem:fwd_in_pdt_icon_init("gift_large2") 或者 inventoryitem:fwd_in_pdt_icon_init(tex,atlas)
-- 
-- 如果有名字组件的切换，则需要  inst:AddComponent("named"):SetName_fwd_in_pdt("拟态墙·草") 初始化名字
-- 
-------------------------------------------------------------------------------------------------------------------------------


local assets =
{
    -- Asset("ANIM", "anim/panda_fisherman_supply_pack.zip"),
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_skin_test_item_red.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_skin_test_item_red.xml" ),    
}
RegisterInventoryItemAtlas("images/inventoryimages/fwd_in_pdt_skin_test_item_red.xml","fwd_in_pdt_skin_test_item_red.tex")

-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
local skins_data = {
     ["fwd_in_pdt_skin_test_building_glass"] = {                    --- 
        bank = "glasscutter",
        build = "glasscutter",
        atlas = "images/inventoryimages/fwd_in_pdt_skin_test_item_red.xml",
        image = "fwd_in_pdt_skin_test_item_red",  -- 不需要 .tex
        name = "XXX.redgem",        --- 切名字用的
        name_color = {255/255,0/255,0/255,1},
    },
     ["fwd_in_pdt_skin_test_building_night"] = {                    --- 
        bank = "nightstick",
        build = "nightstick",
        atlas = "images/inventoryimages2.xml",
        image = "yellowgem",
        name = "XXX.yellowgem",        --- 切名字用的
    }
}

FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_skin_test_building")
-------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst._fwd_in_pdt_skin_default = {
        bank = "tent_walter",
        build = "tent_walter",
        minimap = "",
    }


    inst.AnimState:SetBank(inst._fwd_in_pdt_skin_default.bank)
    inst.AnimState:SetBuild(inst._fwd_in_pdt_skin_default.build)
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fwd_in_pdt_func"):Init("skin")
    inst.components.fwd_in_pdt_func:SkinAPI_AddMirror()

    return inst
end

return Prefab("fwd_in_pdt_skin_test_building", fn,assets),
        MakePlacer("fwd_in_pdt_skin_test_building_placer", "tent_walter", "tent_walter", "idle")
