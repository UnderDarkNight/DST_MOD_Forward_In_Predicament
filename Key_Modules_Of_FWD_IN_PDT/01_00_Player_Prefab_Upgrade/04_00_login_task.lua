--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 登录广告/通报
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_cd_key_sys"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------------------
    -- 开局礼盒
        if inst.userid and not TheWorld:HasTag("cave") then
            local flag_str = inst.userid..".opening_gift_box"
            if not TheWorld.components.fwd_in_pdt_data:Get(flag_str) then
                TheWorld.components.fwd_in_pdt_data:Set(flag_str,true)
                inst:DoTaskInTime(1,function()
                    -- inst.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_item_mod_synopsis",1)
                    local gift_box = SpawnPrefab("fwd_in_pdt_gift_pack")
                    gift_box:PushEvent("Set",{
                            items = {
                                    {"fwd_in_pdt_item_mod_synopsis",1},
                                    {"fwd_in_pdt_food_aster_tataricus_l_f_pills",1},
                                    {"fwd_in_pdt_food_gifts_of_nature",1},
                            },
                            name = GetStringsTable("fwd_in_pdt_gift_pack")["name.opening_gift_box"],
                            inspect_str = GetStringsTable("fwd_in_pdt_gift_pack")["inspect_str"],
                            --      skin_num = 1,   -- 1~6
                            --      new_anim = {               ----- 其他皮肤数据
                            --         bank = "",
                            --         build = "",
                            --         anim = "",
                            --         imagename = "",
                            --         atlasname = "",
                            --      },
                    })
                    inst.components.inventory:GiveItem(gift_box)
                end)
            end
        end
    ----------------------------------------------------------------------------------------------------


end)