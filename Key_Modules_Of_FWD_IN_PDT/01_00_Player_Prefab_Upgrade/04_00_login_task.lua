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
    inst:DoTaskInTime(0,function()  --- userid 在最开始的时候不存在，需要延时一下。
        
        ----------------------------------------------------------------------------------------------------
        -- 开局礼盒
            if inst.userid and not TheWorld:HasTag("cave") then
                local flag_str = inst.userid..".opening_gift_box"
                if not TheWorld.components.fwd_in_pdt_data:Get(flag_str) then
                    TheWorld.components.fwd_in_pdt_data:Set(flag_str,true)
                    inst:DoTaskInTime(3,function()
                        -- inst.components.fwd_in_pdt_func:GiveItemByName("fwd_in_pdt_item_mod_synopsis",1)
                        local gift_box = SpawnPrefab("fwd_in_pdt_gift_pack")
                        local skin_num = tostring(math.random(12))
                        gift_box:PushEvent("Set",{
                                items = {
                                        {"fwd_in_pdt_item_mod_synopsis",1},
                                        {"fwd_in_pdt_food_aster_tataricus_l_f_pills",2},
                                        {"fwd_in_pdt_food_gifts_of_nature",1},
                                        {"fwd_in_pdt_item_transport_stone",1},
                                },
                                name = GetStringsTable("fwd_in_pdt_gift_pack")["name.opening_gift_box"],
                                inspect_str = GetStringsTable("fwd_in_pdt_gift_pack")["inspect_str"],
                                --      skin_num = 1,   -- 1~6
                                    new_anim = {               ----- 其他皮肤数据
                                        bank = "fwd_in_pdt_gift_pack",
                                        build = "fwd_in_pdt_gift_pack",
                                        anim = "fwd_in_pdt_gift_pack_"..skin_num,
                                        scale = 2,
                                        imagename = "fwd_in_pdt_gift_pack_"..skin_num,
                                        atlasname = "images/inventoryimages/fwd_in_pdt_gift_pack.xml",
                                    },
                        })
                        -- inst.components.inventory:GiveItem(gift_box)
                        local camera_down_vector = inst.components.fwd_in_pdt_func:TheCamera_GetDownVec() or Vector3(0,0,0)
                        local x,y,z = inst.Transform:GetWorldPosition()
                        local dis = 2.5
                        local x_fix = math.random(15)/10
                        local z_fix = math.random(15)/10
                        if math.random(100)<50 then
                            x_fix = x_fix * -1
                        end
                        if math.random(100)<50 then
                            z_fix = z_fix * -1
                        end
                        x = camera_down_vector.x*dis + x + x_fix
                        y = 20
                        z = camera_down_vector.z*dis + z + z_fix
                        gift_box.Transform:SetPosition(x, y, z)
                    end)
                end
            end
        ----------------------------------------------------------------------------------------------------
    end)


end)