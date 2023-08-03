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
    -- RegisterInventoryItemAtlas("images/inventoryimages/fwd_in_pdt_skin_test_item_red.xml","fwd_in_pdt_skin_test_item_red.tex")
    local skins_data = {
        ["fwd_in_pdt_skin_test_item_red"] = {             --- 皮肤名字，全局唯一。
            bank = "glasscutter",                   --- 制作完成后切换的 bank
            build = "glasscutter",                  --- 制作完成后切换的 build
            atlas = "images/inventoryimages/fwd_in_pdt_skin_test_item_red.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "fwd_in_pdt_skin_test_item_red",      --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = "XXX.redgem",                    --- 【制作栏】皮肤的名字
            name_color = {255/255,0/255,0/255,1},   --- 【制作栏】皮肤名字颜色 ，{R,G,B,A} 可以为nil
            -- minimap = "",                         --- 地图上的图标，可以为nil
            -- skin_name = "fwd_in_pdt_skin_test_item_red",   --- 【不需要】皮肤名字，全局唯一，相关API会自动添加，这里可以不用
            -- prefab_name = "",                        --- 【不需要】inst.prefab ，相关API会自动添加，这里可以不用
            -- .....                                 --- 可以继续添加参额外参数表
        },
        ["fwd_in_pdt_skin_test_item_yellow"] = {                    --- 
            bank = "nightstick",
            build = "nightstick",
            atlas = "images/inventoryimages2.xml",
            image = "yellowgem",            -- 不需要 .tex
            name = "XXX.yellowgem",        --- 切名字用的
        }
    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data,"fwd_in_pdt_skin_test_item")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- inst._fwd_in_pdt_skin_default = { --- 给切默认皮肤用的
    --     bank = "tent_walter",
    --     build = "tent_walter",
    --     minimap = "",
    -- }
    -- inst.AnimState:SetBank(inst._fwd_in_pdt_skin_default.bank)
    -- inst.AnimState:SetBuild(inst._fwd_in_pdt_skin_default.build)
    -- inst.AnimState:SetBank("moonrock_seed")
    -- inst.AnimState:SetBuild("moonrock_seed")

    Set_ReSkin_API_Default_Animate(inst,"moonrock_seed","moonrock_seed")

    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    
    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")    
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("gift_large2")
    inst.components.inventoryitem:fwd_in_pdt_icon_init("gift_large2")

    inst:AddComponent("fwd_in_pdt_func"):Init("skin")



    return inst
end

return Prefab("fwd_in_pdt_skin_test_item", fn,assets)
