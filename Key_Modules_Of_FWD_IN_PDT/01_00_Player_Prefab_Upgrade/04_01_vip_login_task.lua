--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 测试用的 VIP 玩家每天 进出存档通报一次。
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

    inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()

        ----- 每天（真实时间）在新的存档都会VIP通报
            local current_time = inst.components.fwd_in_pdt_func:Get_OS_Time_Num()
            local flag_time = inst.components.fwd_in_pdt_func:Get("vip_daily_annouce_flag_time")
            if flag_time ~= current_time then
                ------------------------------------------------------------------------------------------
                    -- -- print("info daily vip announce task start")
                    -- local display_name = inst:GetDisplayName()
                    -- local base_str = GetStringsTable()["succeed_announce"]
                    -- local ret_str = string.gsub(base_str, "XXXXXX", tostring(display_name))                        
                    -- for k, temp_player in pairs(AllPlayers) do
                    --     if temp_player and temp_player:HasTag("player") and temp_player.components.fwd_in_pdt_func and temp_player.components.fwd_in_pdt_func.Wisper then
                    --             temp_player.components.fwd_in_pdt_func:Wisper({
                    --                 m_colour = {0,255,255} ,                          ---- 内容颜色
                    --                 s_colour = {255,255,0},                         ---- 发送者颜色
                    --                 icondata = "profileflair_shadowhand",        ---- 图标
                    --                 message = ret_str,                                 ---- 文字内容
                    --                 sender_name = GetStringsTable()["bad_key.talker"],                               ---- 发送者名字
                    --             })
                    --     end
                    -- end
                ------------------------------------------------------------------------------------------
                inst.components.fwd_in_pdt_func:VIP_Announce()
                ------------------------------------------------------------------------------------------
                inst.components.fwd_in_pdt_func:Set("vip_daily_annouce_flag_time",current_time)

            end

        ------------------------------------------------------------------------------------------
        
    end)

    inst:ListenForEvent("fwd_in_pdt_event.atm_enter_cd_key",function(_,cd_key)
        if type(cd_key) == "string" then
            inst.components.fwd_in_pdt_func:VIP_Player_Input_Key(cd_key)
        end
    end)

    inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()
        inst:AddTag("fwd_in_pdt_tag.vip")
    end)

    -------------------------- vip 解锁皮肤
        inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()

            if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then  --- 靠版本记忆新增皮肤
                local version_flag = inst.components.fwd_in_pdt_func:Get("vip_unlock_by_mod_version")
                local current_version = TUNING["Forward_In_Predicament.mod_info"].version
                if current_version and version_flag == current_version then
                    return
                end
                inst.components.fwd_in_pdt_func:Set("vip_unlock_by_mod_version",current_version)
            end

            inst:DoTaskInTime(1,function()
                local list = {
                    ---- 天体珠宝灯（月亮）
                        ["fwd_in_pdt_moom_jewelry_lamp"] = {
                            "fwd_in_pdt_moom_jewelry_lamp_moon",
                        },
                    ---- 炽热暗影剑
                        ["fwd_in_pdt_equipment_blazing_nightmaresword"] = {
                            "fwd_in_pdt_equipment_blazing_nightmaresword_sharp",
                        },
                    ---- 极寒暗影剑
                        ["fwd_in_pdt_equipment_frozen_nightmaresword"] = {
                            "fwd_in_pdt_equipment_frozen_nightmaresword_sharp",
                        },
                    ---- 炽热火腿
                        ["fwd_in_pdt_equipment_blazing_hambat"] = {
                            "fwd_in_pdt_equipment_blazing_hambat_drumstick",
                        },
                    ---- 极寒火腿
                        ["fwd_in_pdt_equipment_frozen_hambat"] = {
                            "fwd_in_pdt_equipment_frozen_hambat_drumstick",
                        },
                    ---- 炽热长矛
                        ["fwd_in_pdt_equipment_blazing_spear"] = {
                            "fwd_in_pdt_equipment_blazing_spear_sharp",
                        },
                    ---- 极寒长矛
                        ["fwd_in_pdt_equipment_frozen_spear"] = {
                            "fwd_in_pdt_equipment_frozen_spear_sharp",
                        },
                    ---- 修复法杖
                        ["fwd_in_pdt_equipment_repair_staff"] = {
                            "fwd_in_pdt_equipment_repair_staff_glass_short",
                            "fwd_in_pdt_equipment_repair_staff_glass_long",
                        },
                    ---- 吸血鬼之剑
                        ["fwd_in_pdt_equipment_vampire_sword"] = {
                            "fwd_in_pdt_equipment_vampire_sword_laser",
                        },
                    ---- 虚空钓竿
                        ["fwd_in_pdt_void_fishingrod"] = {
                            "fwd_in_pdt_void_fishingrod_flower",
                        },
                    ---- 特殊工作台
                        ["fwd_in_pdt_building_special_production_table"] = {
                            "fwd_in_pdt_building_special_production_table_punk",
                        },
                    ---- 发酵缸
                        -- ["fwd_in_pdt_building_fermenter"] = {
                        --     "fwd_in_pdt_building_fermenter_honey",
                        -- },
                    ---- 混沌万能锅
                        ["fwd_in_pdt_building_special_cookpot"] = {
                            "fwd_in_pdt_building_special_cookpot_lantern",
                        },
                    ---- 电视机
                        ["fwd_in_pdt_container_tv_box"] = {
                            "fwd_in_pdt_container_tv_box_laser",
                        },
                    ---- 钱袋
                        ["fwd_in_pdt_container_wallet"] = {
                            "fwd_in_pdt_container_wallet_piggy",
                        },
                    ---- 健康检查机
                        ["fwd_in_pdt_building_medical_check_up_machine"] = {
                            "fwd_in_pdt_building_medical_check_up_machine_punk",
                        },
                    ---- 水稻风车
                        ["fwd_in_pdt_building_paddy_windmill"] = {
                            "fwd_in_pdt_building_paddy_windmill_pink",
                        },
                    ---- 灯笼（月亮皮肤）
                        ["fwd_in_pdt_building_lantern"] = {
                            "fwd_in_pdt_building_lantern_moon",
                        },
                     ---- 花围栏
                        ["fwd_in_pdt_building_flower_fence_item"] = {
                            "fwd_in_pdt_building_flower_fence_item_purple",
                            "fwd_in_pdt_building_flower_fence_item_vines",
                            "fwd_in_pdt_building_flower_fence_item_mushroom",
                        },
                    ---- 鼹鼠背包
                        ["fwd_in_pdt_equipment_mole_backpack"] = {
                            -- "fwd_in_pdt_equipment_mole_backpack_panda",  --- 免费送
                            -- "fwd_in_pdt_equipment_mole_backpack_cat",    --- 单独发送
                            -- "fwd_in_pdt_equipment_mole_backpack_snowman",    --- 单独发送
                            "fwd_in_pdt_equipment_mole_backpack_rabbit",    --- VIP
                        },

                }
                inst.components.fwd_in_pdt_func:SkinAPI__Unlock_Skin(list)

            end)
        end)

end)

---------------------------------------------------
--- VIP 礼物盒
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim or TheWorld:HasTag("cave") then
        return
    end

    inst.components.fwd_in_pdt_func:VIP_Add_Fn(function()
        inst:DoTaskInTime(3,function()
                            
                        local flag = "vip_gift." .. tostring(inst.userid)
                        if TheWorld.components.fwd_in_pdt_data:Get(flag) then
                            return
                        end
                        TheWorld.components.fwd_in_pdt_data:Set(flag,true)

                        local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                        local skin_num = tostring(math.random(12))
                        gift_pack:PushEvent("Set",{
                            name = GetStringsTable("fwd_in_pdt_gift_pack")["name.vip"],
                            inspect_str = "VIP Gift Pack",
                            -- skin_num = math.random(6),   -- 1~6
                            items = {
                                        {"log",1},
                                        {"goldnugget",2},
                                        {"fwd_in_pdt_item_jade_coin_green",20},
                                        {"fwd_in_pdt_item_transport_stone",1},
                                        {"nightstick",1},
                                        {"fwd_in_pdt_food_bread",2},
                                    },
                                new_anim = {               ----- 其他皮肤数据
                                    bank = "fwd_in_pdt_gift_pack",
                                    build = "fwd_in_pdt_gift_pack",
                                    anim = "fwd_in_pdt_gift_pack_"..skin_num,
                                    scale = 2,
                                    imagename = "fwd_in_pdt_gift_pack_"..skin_num,
                                    atlasname = "images/inventoryimages/fwd_in_pdt_gift_pack.xml",
                                 },
                        })
                        -- inst.components.inventory:GiveItem(gift_pack)
                        local camera_down_vector = inst.components.fwd_in_pdt_func:TheCamera_GetDownVec() or Vector3(0,0,0)
                        local x,y,z = inst.Transform:GetWorldPosition()
                        local dis = 3.5
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
                        gift_pack.Transform:SetPosition(x, y, z)


        end)

    end)

end)