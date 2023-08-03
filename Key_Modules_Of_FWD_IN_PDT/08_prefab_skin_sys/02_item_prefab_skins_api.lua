-----------------------------------------------------------------------------------------------
-- 和皮肤相关的两个官方table，index 转置而已。
-- index 转置了
-- （client）recipepopup.lua 制作栏相关的 列表调用 api ： GetSkinsList   GetSkinOptions   
--  重要函数 ：（ client 端） TheInventory:CheckOwnershipGetLatest(item_type)  
--  TheInventory 是个 userdata
-- PREFAB_SKINS PREFAB_SKINS_IDS 里面只会列出已拥有的，未解锁的不会进入这两个列表里

--- 制作栏里的相关文本和贴图
--  RecipePopup:GetSkinOptions()  可以改制作栏 里显示的 贴图/文本/文本颜色等 
--  local colour = GetColorForItem(item)    ，文本颜色相关的预设 在 skinsutils.lua， 格式{R/255,G/255,B/255,A/255}
-- local text_name = GetSkinName(item)
-- local image_name = GetSkinInvIconName(item)
-- 贴图需要使用 函数 RegisterInventoryItemAtlas("images/inventoryimages/"..tex_name.. ".xml", tex_name..".tex") 注册过


-- 建筑类准备放置的时候，皮肤切换需要hook  PlayerController:StartBuildPlacementMode ，在 client 上
-- server 上监听(builder 里 push 出来的) 
--              player:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
--              prod:PushEvent("onbuilt", { builder = self.inst, pos = pt })
-- 非建筑类制作的时候 builder 里 push 出来  (server)
--              player:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper })

-----------------------------------------------------------------------------------------------

-- print("PREFAB_SKINS",PREFAB_SKINS["researchlab"])
-- for k, v in pairs(PREFAB_SKINS["researchlab"]) do
--     print(k,v)
--     -- [01:10:44]: 1	researchlab_gothic	
--     -- [01:10:44]: 2	researchlab_green	
--     -- [01:10:44]: 3	researchlab_party	
--     -- [01:10:44]: 4	researchlab_retro
-- end
-- print("PREFAB_SKINS_IDS",PREFAB_SKINS_IDS["researchlab"])
-- for k, v in pairs(PREFAB_SKINS_IDS["researchlab"]) do
--     print(k,v)
--     -- [01:12:19]: researchlab_gothic	1	
--     -- [01:12:19]: researchlab_retro	4	
--     -- [01:12:19]: researchlab_green	2	
--     -- [01:12:19]: researchlab_party	3	
-- end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 注册所有皮肤，不管有没有解锁
-- _G.FWD_IN_PDT_MOD_SKIN = {}
rawset(_G,"FWD_IN_PDT_MOD_SKIN",{})       --- 往_G 上挂载，使用 rawset 稳妥保险
FWD_IN_PDT_MOD_SKIN.SKINS_DATA = {}       --- index 为 skin_name
FWD_IN_PDT_MOD_SKIN.SKINS_DATA_PREFABS = {}   --- index 为 prefab_name
FWD_IN_PDT_MOD_SKIN.CURRENT_UNLOCK_SKINS = {}                     ---- 给其他系统的API验证皮肤已经解锁用的，hook 进去，然后检测这个表
FWD_IN_PDT_MOD_SKIN.Add_Skin_Data_For_HUD = function(cmd_table)   ---- 【废弃函数】留在这做笔记
    -- cmd_table = {
    --     prefab_name = "",
    --     skin_name = "skin_name",
    --     bank = "bank",
    --     build = "build",
    --     atlas = "images/inventoryimages/npng_item_no_discounts_amulet.xml",
    --     image = "npng_item_no_discounts_amulet.tex",
    --     name = "XXX",        --- 切名字用的
    --     name_color = {r/255,g/255,b/255,a/255},
    --     minimap = "",
    --     OverrideSymbol = {   --- 给武器类手持切换用的
    --         tar_layer = "",
    --         build = "",
    --         src_layer = "",
    --     }，
    --     skin_link = "",    ---连携解锁用的,一起解锁这个皮肤。
    -- }    
end
FWD_IN_PDT_MOD_SKIN.GET_ALL_SKINS_DATA = function()
    -- FWD_IN_PDT_MOD_SKIN.SKINS_DATA      --- index 为 skin_name
    -- FWD_IN_PDT_MOD_SKIN.SKINS_DATA_PREFABS   --- index 为 prefab_name
    return FWD_IN_PDT_MOD_SKIN.SKINS_DATA,FWD_IN_PDT_MOD_SKIN.SKINS_DATA_PREFABS
end
FWD_IN_PDT_MOD_SKIN.SKIN_INIT = function(skins_data,prefab_name) ---- 用来初始化所有皮肤数据,不管有没有解锁

    ------------------------------------------
    ---- 转置一下参数表，避免重复添加
    if tostring(prefab_name) == "nil" or type(skins_data) ~= "table" then
        print("FWD_IN_PDT_MOD_SKIN.SKIN_INIT  Error",prefab_name,skins_data)
        return
    end
    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
        print("info FWD_IN_PDT_MOD_SKIN.SKIN_INIT",prefab_name,skins_data)
    end

    for skin_name, cmd_table in pairs(skins_data) do
        skins_data[skin_name].prefab_name = prefab_name
        skins_data[skin_name].skin_name = skin_name
        FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(cmd_table.skin_name)] = cmd_table
    end
    FWD_IN_PDT_MOD_SKIN.SKINS_DATA_PREFABS[tostring(prefab_name)] = skins_data


    ----------------------------------------------------------------------
    --- 往 PREFAB_SKINS 和 PREFAB_SKINS_IDS 里添加表，避免UI在极端情况下（PlayerController:RemoteMakeRecipeFromMenu）
    PREFAB_SKINS[prefab_name] = PREFAB_SKINS[prefab_name] or {}
    PREFAB_SKINS_IDS[prefab_name] = PREFAB_SKINS_IDS[prefab_name] or {}
    ----------------------------------------------------------------------
end

FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate = function(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
    inst._fwd_in_pdt_skin_default = { --- 给切默认皮肤用的
        bank = bank,
        build = build,
        minimap = minimap,
    }
    if inst.AnimState == nil then
        inst.entity:AddAnimState()
    end
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    if minimap then
        if inst.MiniMapEntity == nil then
            inst.entity:AddMiniMapEntity()
        end
        inst.MiniMapEntity:SetIcon(minimap)
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- hook api 方便名字，贴图切换
--- 获取 text 的颜色
require("skinsutils")
--- 【注意事项】科雷个哈比，重定义了 _G 的index ，只能用 rawget / rawset 来修改 全局函数
local _fwd_in_pdt_old_GetColorForItem = rawget(_G,"GetColorForItem")
rawset(_G,"GetColorForItem", function(item,...)
    -- print("GetColorForItem55555",item,type(item))
    if FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)] then
        return FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)].name_color or _fwd_in_pdt_old_GetColorForItem(item,...)
    else
        return _fwd_in_pdt_old_GetColorForItem(item,...)
    end
end)

---- 获取 text
local _fwd_in_pdt_old_GetSkinName = rawget(_G,"GetSkinName")
rawset(_G,"GetSkinName", function(item,...)
    -- print("GetSkinName",item,type(item))
    if FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)] then
        return FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)].name or _fwd_in_pdt_old_GetSkinName(item,...)
    else
        return  _fwd_in_pdt_old_GetSkinName(item,...)
    end
end)
---- 获取贴图，贴图只能放 inventoryimages ，而且必须使用函数 RegisterInventoryItemAtlas("images/inventoryimages/"..tex_name.. ".xml", tex_name..".tex") 注册过
local _fwd_in_pdt_old_GetSkinInvIconName = rawget(_G,"GetSkinInvIconName")
rawset(_G,"GetSkinInvIconName", function(item,...)
    if FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)] then
        return FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(item)].image or _fwd_in_pdt_old_GetSkinInvIconName(item,...)
    else
        return  _fwd_in_pdt_old_GetSkinInvIconName(item,...)
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ValidateRecipeSkinRequest func 在 Builder:MakeRecipeFromMenu 影响参数
local ValidateRecipeSkinRequest__fwd_in_pdt_old = rawget(_G,"ValidateRecipeSkinRequest")
rawset(_G,"ValidateRecipeSkinRequest",function(user_id, prefab_name, skin)
    local playerInst = UserToPlayer(user_id)
    if playerInst and playerInst.replica.fwd_in_pdt_func and playerInst.replica.fwd_in_pdt_func.SkinAPI__Has_Skin and playerInst.replica.fwd_in_pdt_func:SkinAPI__Has_Skin(skin,prefab_name) then
        return skin
    else
        return ValidateRecipeSkinRequest__fwd_in_pdt_old(user_id, prefab_name, skin)
    end    
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 这里是检查皮肤拥有权的官方接口。貌似只在 client 端执行，UI上检查
if TheInventory then
    if type(TheInventory) == "userdata" then

                    local temp_TheInventory = getmetatable(TheInventory).__index
                    -- CheckOwnershipGetLatest
                    temp_TheInventory.__fwd_in_pdt_old_CheckOwnershipGetLatest = temp_TheInventory.CheckOwnershipGetLatest
                    temp_TheInventory.CheckOwnershipGetLatest = function(self,skin_name,...)
                        -- print("info TheInventory.CheckOwnershipGetLatest",skin_name)
                        if skin_name and ThePlayer and ThePlayer.replica.fwd_in_pdt_func and ThePlayer.replica.fwd_in_pdt_func.SkinAPI__Has_Skin and ThePlayer.replica.fwd_in_pdt_func:SkinAPI__Has_Skin(skin_name) then
                            return true ,0
                        end
                        return self:__fwd_in_pdt_old_CheckOwnershipGetLatest(skin_name,...)
                    end

    elseif type(TheInventory) == "table" then


                    local temp_TheInventory = TheInventory
                    -- CheckOwnershipGetLatest
                    temp_TheInventory.__fwd_in_pdt_old_CheckOwnershipGetLatest = temp_TheInventory.CheckOwnershipGetLatest
                    temp_TheInventory.CheckOwnershipGetLatest = function(self,skin_name,...)
                        if skin_name and ThePlayer and ThePlayer.replica.fwd_in_pdt_func and ThePlayer.replica.fwd_in_pdt_func.SkinAPI__Has_Skin and ThePlayer.replica.fwd_in_pdt_func:SkinAPI__Has_Skin(skin_name) then
                            return true ,0
                        end
                        return self:__fwd_in_pdt_old_CheckOwnershipGetLatest(skin_name,...)
                    end
        

    end

end


