if TUNING["Forward_In_Predicament.Strings"] == nil then
    TUNING["Forward_In_Predicament.Strings"] = {}
end

local this_language = "en"
if TUNING["Forward_In_Predicament.Language"] then
    if type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() ~= this_language then
        return
    elseif type(TUNING["Forward_In_Predicament.Language"]) == "string" and TUNING["Forward_In_Predicament.Language"] ~= this_language then
        return
    end
end

TUNING["Forward_In_Predicament.Strings"][this_language] = TUNING["Forward_In_Predicament.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            -- ["fwd_in_pdt_skin_test_item"] = {
            --     ["name"] = "en皮肤测试物品",
            --     ["inspect_str"] = "en inspect单纯的测试皮肤",
            --     ["recipe_desc"] = " en 测试描述666",
            -- },
        --------------------------------------------------------------------
        --- 其他无法归类的
            ["fwd_in_pdt_with_blocked_mods"] = {
                ["mods_ban"] = "A conflicting mod is detected :",
                ["prefab_block"] = "Conflicting mods are detected and the game will be terminated to maintain a smooth experience of this mod.",
                ["maxsize_block"] = "The number of item stacks is too high. This mod has poor compatibility with such mods. The game will be closed to ensure a smooth experience with this mod. Reason : existence of ",                
                ["has_not_cave"]  = "No cave archive loading detected, this mod is missing functionality and will terminate the game.",                
            },
            ["fwd_in_pdt_cd_key_sys"] = {
                ["succeed_announce"] = "天空一声巨响，VIP会员【XXXXXX】闪亮登场",
                ["bad_key.talker"] = "【Fwd ind Predicament】",
                ["bad_key.str"] = "The same CD-KEY as other players is detected, please pay attention to privacy protection ! ! ! !",
            },
        --------------------------------------------------------------------
            ---- UI
            ["fwd_in_pdt_ui_craftingmenu"] = {        ---- 制作栏
                ["FWD_IN_PDT_BUILDINGS"] = "黑夜建筑"
            },
        --------------------------------------------------------------------
        ---- actions
            ---- actions
            ["sleeping_tent_action"] = { 
                ["join"] = "睡觉"
            },
            ["fwd_in_pdt_com_whip_action"] = { 
                ["DEFAULT"] = "抽",
                ["MIRROR"] = "镜像"
            },
            ["fwd_in_pdt_com_acceptable"] = { 
                ["DEFAULT"] = "给",
                ["fertilize"] = "施肥"
            },
            ["fwd_in_pdt_com_special_acceptable"] = { 
                ["DEFAULT"] = "给",
                ["fertilize"] = "施肥"
            },
            ["fwd_in_pdt_com_workable"] = { 
                ["DEFAULT"] = "工作",
            },
            ["fwd_in_pdt_com_special_workable"] = { 
                ["DEFAULT"] = "工作",
            },
            ["fwd_in_pdt_com_weapon"] = { 
                ["DEFAULT"] = "执行",
            },
        --------------------------------------------------------------------
        ---- 00_fwd_in_pdt_others
        --------------------------------------------------------------------
        ---- 01_fwd_in_pdt_items
            ["fwd_in_pdt_gift_pack"] = {
                ["name"] = "Gift Box",
                ["inspect_str"] = "A Gift Box"
            },
            ["fwd_in_pdt_item_jade_coin_green"] = {
                ["name"] = "Green Jade Coin Of Loong",
                ["inspect_str"] = "A kind of currency made of jade, emerald green and vibrant",
                ["action_str"]  = "ExChange",
            },
            ["fwd_in_pdt_item_jade_coin_black"] = {
                ["name"] = "Black Jade Coin Of Loong",
                ["inspect_str"] = "A kind of currency made of jade, black and deep",
                ["action_str"]  = "ExChange",
            },
        --------------------------------------------------------------------
        ---- 02_fwd_in_pdt_materials
        --------------------------------------------------------------------
        ---- 03_fwd_in_pdt_equipments
        --------------------------------------------------------------------
        ---- 04_fwd_in_pdt_foods
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
        --------------------------------------------------------------------
        ---- 06_fwd_in_pdt_containers
        --------------------------------------------------------------------
        ---- 09_fwd_in_pdt_plants
        --------------------------------------------------------------------
        ---- 10_fwd_in_pdt_minerals
        --------------------------------------------------------------------
        ---- 11_fwd_in_pdt_animals
        --------------------------------------------------------------------
        ---- 12_fwd_in_pdt_boss
        --------------------------------------------------------------------
        ---- 13_fwd_in_pdt_pets
        --------------------------------------------------------------------
        ---- 14_fwd_in_pdt_turfs
        --------------------------------------------------------------------
        ---- 15_fwd_in_pdt_debuffs
        --------------------------------------------------------------------
        ---- 16_fwd_in_pdt_spells
        --------------------------------------------------------------------
        ---- 17_fwd_in_pdt_FX
        --------------------------------------------------------------------
        ---- 18_fwd_in_pdt_projectiles
        --------------------------------------------------------------------
        ---- 19_fwd_in_pdt_characters

        --------------------------------------------------------------------
}