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
            ["fwd_in_pdt_other_poison_frog"] = {
                ["name"] = "Poison Dart Frog",                
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
                ["DEFAULT"] = "Give",
                ["fertilize"] = "Fertilize",
                ["fwd_in_pdt_element_cores"] = "Enchantment",                
            },
            ["fwd_in_pdt_com_workable"] = { 
                ["DEFAULT"] = "Work",
            },
            ["fwd_in_pdt_com_special_workable"] = { 
                ["DEFAULT"] = "Work",
            },
            ["fwd_in_pdt_com_weapon"] = { 
                ["DEFAULT"] = "Do",
            },
        --------------------------------------------------------------------
        ---- 00_fwd_in_pdt_others
        --------------------------------------------------------------------
        ---- 01_fwd_in_pdt_items
            ["fwd_in_pdt_gift_pack"] = {
                ["name"] = "Gift Box",
                ["inspect_str"] = "A Gift Box"
            },
            ["fwd_in_pdt_item_ice_core"] = {
                ["name"] = "Ice Core Stone",
                ["inspect_str"] = "There's cold inside"
            },
            ["fwd_in_pdt_item_flame_core"] = {
                ["name"] = "Flame Core Stone",
                ["inspect_str"] = "There's flame inside"
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
            ["fwd_in_pdt_item_transport_stone"] = {
                ["name"] = "Micro Transportation Stone",
                ["inspect_str"] = "Teleport to the Mangrove Island or the Black Market",
            },
            ["fwd_in_pdt_item_insulin_syringe"] = {
                ["name"] = "Insulin Syringe",
                ["inspect_str"] = "For reducing blood glucose",
                ["recipe_desc"] = "Injectable injections for lowering blood glucose",

            },
            ["fwd_in_pdt_item_disease_treatment_book"] = {
                ["name"] = "Disease Treatment Magic Book",
                ["inspect_str"] = "Magic book to cure some disease",
                ["recipe_desc"] = "Magic book to cure some disease",
                ["action_fail"] = "I don't have any medical conditions that need to be treated right now"

            },
            ["fwd_in_pdt_item_book_of_harvest"] = {
                ["name"] = "Book Of Harvest",
                ["inspect_str"] = "A magic book to celebrate the harvest",
                ["recipe_desc"] = "A magic book to celebrate the harvest",
                ["action_fail"] = "I can't use it around here for now.",

            },
            ["fwd_in_pdt_item_medical_certificate"] = {
                ["name"] = "Medical Certificate",
                ["inspect_str"] = "Diagnosis of your own body",
                ["recipe_desc"] = "Diagnosis of your own body",
                ["item_name_format"] = "Medical Certificate For XXXX"

            },
        --------------------------------------------------------------------
        ---- 02_fwd_in_pdt_materials
            ["fwd_in_pdt_material_tree_resin"] = {
                ["name"] = "Tree Resin",
                ["inspect_str"] = "Resin from the trees.",
            },
            ["fwd_in_pdt_material_snake_skin"] = {
                ["name"] = "Snake Skin",
                ["inspect_str"] = "A snake's skin. Not the naturally molting kind.",
            },
            ["fwd_in_pdt_material_realgar"] = {
                ["name"] = "Realgar",
                ["inspect_str"] = "Snakes are most afraid of realgar",
            },
            ["fwd_in_pdt_material_atractylodes_macrocephala"] = {
                ["name"] = "Atractylodes Macrocephala",
                ["inspect_str"] = "Picked herbs",
            },
            ["fwd_in_pdt_material_pinellia_ternata"] = {
                ["name"] = "Pinellia Ternata",
                ["inspect_str"] = "Picked herbs",
            },
            ["fwd_in_pdt_material_aster_tataricus_l_f"] = {
                ["name"] = "Aster tataricus L.f.",
                ["inspect_str"] = "Picked herbs",
            },
        --------------------------------------------------------------------
        ---- 03_fwd_in_pdt_equipments
            ["fwd_in_pdt_equipment_blazing_nightmaresword"] = {
                ["name"] = "Blazing Nightmare Sword",
                ["inspect_str"] = "This sword is full of shadows and heat"
            },
            ["fwd_in_pdt_equipment_frozen_nightmaresword"] = {
                ["name"] = "Frozen Nightmare Sword",
                ["inspect_str"] = "This sword is full of shadows and cold"
            },
            ["fwd_in_pdt_equipment_blazing_hambat"] = {
                ["name"] = "Blazing Hambat",
                ["inspect_str"] = "This hambat is hot, hot, hot."
            },
            ["fwd_in_pdt_equipment_frozen_hambat"] = {
                ["name"] = "Frozen Hambat",
                ["inspect_str"] = "This hambat is frozen solid."
            },
            ["fwd_in_pdt_equipment_blazing_spear"] = {
                ["name"] = "Blazing Spear",
                ["inspect_str"] = "This spear is full of heat."
            },
            ["fwd_in_pdt_equipment_frozen_spear"] = {
                ["name"] = "Frozen Spear",
                ["inspect_str"] = "This spear is filled with frost and cold."
            },
            ["fwd_in_pdt_equipment_repair_staff"] = {
                ["name"] = "Repair Staff",
                ["inspect_str"] = "This staff can fix a lot of things."
            },
        --------------------------------------------------------------------
        ---- 04_fwd_in_pdt_foods
            ["fwd_in_pdt_food_raw_milk"] = {
                ["name"] = "Raw Milk",
                ["inspect_str"] = "From the cow"
            },
            ["fwd_in_pdt_food_andrographis_paniculata_botany"] = {
                ["name"] = "Andrographis Paniculata ( botany )",
                ["inspect_str"] = "It can be used to neutralize snake poison",
                ["recipe_desc"] = "It can be used to neutralize snake poison",
            },
            ["fwd_in_pdt_food_universal_antidote"] = {
                ["name"] = "Universal Antidote",
                ["inspect_str"] = "It can be used to neutralize all kinds of poisons",
                ["recipe_desc"] = "It can be used to neutralize all kinds of poisons",
            },
            ["fwd_in_pdt_food_rice"] = {
                ["name"] = "Rice",
                ["inspect_str"] = "It's so white it's beautiful.",
            },
            ["fwd_in_pdt_food_wheat_flour"] = {
                ["name"] = "Flour",
                ["inspect_str"] = "It's so white it's beautiful.",
            },
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
            ["fwd_in_pdt_food_mixed_potato_soup"] = {
                ["name"] = "Mix Potato Soup",
                ["inspect_str"] = "Pieces of it look like lumps."
            },
            ["fwd_in_pdt_food_steamed_orange_with_honey"] = {
                ["name"] = "Steamed Orange With Honey",
                ["inspect_str"] = "The scent of oranges is accompanied by the sweetness of honey"
            },
            ["fwd_in_pdt_food_scrambled_eggs_with_tomatoes"] = {
                ["name"] = "Screamble Eggs With Tomatoes",
                ["inspect_str"] = "The classic tomato and egg combo"
            },
            ["fwd_in_pdt_food_eggplant_casserole"] = {
                ["name"] = "Eggplant Casserole",
                ["inspect_str"] = "Classic Eggplant Cuisine"
            },
            ["fwd_in_pdt_food_gifts_of_nature"] = {
                ["name"] = "Gifts Of Nature",
                ["inspect_str"] = "Cooked with a mixture of natural ingredients"
            },
            ["fwd_in_pdt_food_snake_skin_jelly"] = {
                ["name"] = "Snake Skin Jelly",
                ["inspect_str"] = "It's very flexible, but it always feels like there's a snake living in it"
            },
            ["fwd_in_pdt_food_atractylodes_macrocephala_pills"] = {
                ["name"] = "Atractylodes Macrocephala Pills",
                ["inspect_str"] = "Raising body temperature and removing moisture"
            },
            ["fwd_in_pdt_food_pinellia_ternata_pills"] = {
                ["name"] = "Pinellia Ternata Pills",
                ["inspect_str"] = "It protects against sandstorms and lowers body temperature."
            },
            ["fwd_in_pdt_food_aster_tataricus_l_f_pills"] = {
                ["name"] = "Aster Tataricus L.F Pills",
                ["inspect_str"] = "Can treat coughs and fevers"
            },
            ["fwd_in_pdt_food_red_mushroom_soup"] = {
                ["name"] = "Red Mushroom Soup",
                ["inspect_str"] = "This soup feels dangerous.",
                ["special_action_str"] = "Feed",
            },
            ["fwd_in_pdt_food_green_mushroom_soup"] = {
                ["name"] = "Green Mushroom Soup",
                ["inspect_str"] = "This soup feels dangerous.",
                ["special_action_str"] = "Feed",
            },
            ["fwd_in_pdt_food_tofu"] = {
                ["name"] = "Tofu",
                ["inspect_str"] = "This tofu is shiny."
            },
            ["fwd_in_pdt_food_stinky_tofu"] = {
                ["name"] = "Stinky Tofu",
                ["inspect_str"] = "It's an indescribable taste."
            },
            ["fwd_in_pdt_food_cooked_milk"] = {
                ["name"] = "Cooked Milk",
                ["inspect_str"] = "Boiled milk tastes so good."
            },
            ["fwd_in_pdt_food_yogurt"] = {
                ["name"] = "Yogurt",
                ["inspect_str"] = "It's sour and tasty."
            },
            ["fwd_in_pdt_food_coffee"] = {
                ["name"] = "Coffee",
                ["inspect_str"] = "refresh and clear the mind"
            },
            ["fwd_in_pdt_food_saline_medicine"] = {
                ["name"] = "Saline Medicine",
                ["inspect_str"] = "Medical supplies"
            },
            ["fwd_in_pdt_food_yogurt_ice_cream"] = {
                ["name"] = "Yogurt Ice Cream",
                ["inspect_str"] = "sweet and savory"
            },
            ["fwd_in_pdt_food_mango_ice_drink"] = {
                ["name"] = "Mango Ice Drink",
                ["inspect_str"] = "Filled with the scent of mango"
            },
            ["fwd_in_pdt_food_cooked_rice"] = {
                ["name"] = "Cooked Rice",
                ["inspect_str"] = "tantalizing taste"
            },
            ["fwd_in_pdt_food_bread"] = {
                ["name"] = "Bread",
                ["inspect_str"] = "tantalizing taste"
            },
            ["fwd_in_pdt_food_thousand_year_old_egg"] = {
                ["name"] = "Thousand-Year-Old Egg",
                ["inspect_str"] = "It feels like the egg is still alive."
            },
            ["fwd_in_pdt_food_congee_with_meat_and_thousand_year_old_eggs"] = {
                ["name"] = "Congee With Meat & Thousand-Year-Old Eggs",
                ["inspect_str"] = "It's very fresh."
            },
            ["fwd_in_pdt_food_protein_powder"] = {
                ["name"] = "Protein Powder",
                ["inspect_str"] = "A favorite among bodybuilders"
            },
        --------------------------------------------------------------------
        ---- 06_fwd_in_pdt_containers
            ["fwd_in_pdt_fish_farm"] = {
                ["name"] = "Fish Farm",
                ["inspect_str"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "etc can be used as feeds",
                ["recipe_desc"] = STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "etc can be used as feeds",
            },
            ["fwd_in_pdt_fish_farm_kit"] = {
                ["name"] = "Fish Farm",
                ["inspect_str"] =  STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "etc can be used as feeds",
                ["recipe_desc"] =  STRINGS.NAMES[string.upper("spoiled_food")] .. "、".. STRINGS.NAMES[string.upper("chum")] .. "etc can be used as feeds",
            },
                ["fwd_in_pdt_moom_jewelry_lamp"] = {
                ["name"] = "Jewelry Lamp",
                ["inspect_str"] = "Quite useful lamp",
                ["recipe_desc"] = "Three gemstones offer three functions",
            },
            ["fwd_in_pdt_building_special_production_table"] = {
                ["name"] = "All-In-One Special Production Table",
                ["inspect_str"] = "a table for making special items",
                ["recipe_desc"] = "a table for making special items",
            },
        --------------------------------------------------------------------
        ---- 07_fwd_in_pdt_buildings
            ["fwd_in_pdt_building_mock_wall_grass"] = {
                ["name"] = "拟态墙·草",
                ["inspect_str"] = "这是一堵墙...而不是植物....",
                ["recipe_desc"] = "伪装成植物的墙",
            },
            ["fwd_in_pdt_building_banner_light"] = {
                ["name"] = "Banner Light",
                ["inspect_str"] = "banner fluttering",
            },
            ["fwd_in_pdt_building_special_shop"] = {
                ["name"] = "Special Shop",
                ["inspect_str"] = "They sell some weird stuff here.",
                ["action_str"] = "Enter",
            },
            ["fwd_in_pdt_building_materials_shop"] = {
                ["name"] = "Materials Shop",
                ["inspect_str"] = "This store sometimes gets rare materials. It's a matter of luck.",
                ["action_str"] = "Enter",
            },
            ["fwd_in_pdt_building_cuisines_shop"] = {
                ["name"] = "Cuisines Shop",
                ["inspect_str"] = "There's a lot of delicious food.",
                ["action_str"] = "Enter",
            },
            ["fwd_in_pdt_building_hotel"] = {
                ["name"] = "Hotel",
                ["inspect_str"] = "A good place to rest",
                ["action_str"] = "Enter",
            },
            ["fwd_in_pdt_building_medical_check_up_machine"] = {
                ["name"] = "Medical Check-Up Machine",
                ["inspect_str"] = "For medical checkups.",
                ["inspect_str_burnt"] = "This machine is burnt out and unusable.",
                ["recipe_desc"] = "It's used to check various indicators of the body",
            },
            ["fwd_in_pdt_building_paddy_windmill"] = {
                ["name"] = "Paddy & Windmill",
                ["inspect_str"] = "This windmill brings water so we can grow rice.",
                ["recipe_desc"] = "This windmill is used to grow rice",
            },
            ["fwd_in_pdt_building_pawnshop"] = {
                ["name"] = "Pawn Shop",
                ["inspect_str"] = "This place can sell some stuff.",
                ["action_str"] = "Enter",
            },
        --------------------------------------------------------------------
        ---- 08_fwd_in_pdt_resources
            ["fwd_in_pdt_resource_glacier_huge"] = {
                ["name"] = "Huge Glacier",
                ["inspect_str"] = "This glacier is so huge, and it doesn't melt all year round .",
            },
            ["fwd_in_pdt_resource_glacier_small"] = {
                ["name"] = "Glacier",
                ["inspect_str"] = "This glacier is so weird. It doesn't melt all year round .",
            },
        --------------------------------------------------------------------
        ---- 09_fwd_in_pdt_plants
            ["fwd_in_pdt_plant_paddy_rice"] = {
                ["name"] = "Paddy Rice",
                ["inspect_str"] = "This should only be planted in a well-watered area",
            },
            ["fwd_in_pdt_plant_paddy_rice_seed"] = {
                ["name"] = "Unhulled Rice",
                ["inspect_str"] = "Shelled and ready to eat.",
            },
            ["fwd_in_pdt_plant_wheat"] = {
                ["name"] = "Wheat",
                ["inspect_str"] = "When it matures, it will be golden",
            },
            ["fwd_in_pdt_plant_wheat_seed"] = {
                ["name"] = "Wheat",
                ["inspect_str"] = "It can be used for continued cultivation or made into flour",
            },
            ["fwd_in_pdt_plant_atractylodes_macrocephala"] = {
                ["name"] = "Atractylodes Macrocephala",
                ["inspect_str"] = "A kind of herb.",
            },
            ["fwd_in_pdt_plant_atractylodes_macrocephala_seed"] = {
                ["name"] = "Seed of Atractylodes Macrocephala",
                ["inspect_str"] = "Seed of Atractylodes Macrocephala",
            },
            ["fwd_in_pdt_plant_pinellia_ternata"] = {
                ["name"] = "Pinellia Ternata",
                ["inspect_str"] = "A kind of herb.",
            },
            ["fwd_in_pdt_plant_pinellia_ternata_seed"] = {
                ["name"] = "Seed of Pinellia Ternata",
                ["inspect_str"] = "Seed of Pinellia Ternata",
            },
            ["fwd_in_pdt_plant_aster_tataricus_l_f"] = {
                ["name"] = "Aster tataricus L.f.",
                ["inspect_str"] = "A kind of herb.",
            },
            ["fwd_in_pdt_plant_aster_tataricus_l_f_seed"] = {
                ["name"] = "Seed of Aster tataricus L.f.",
                ["inspect_str"] = "Seed of Aster tataricus L.f.",
            },
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
        ---- 20_fwd_in_pdt_events
        --------------------------------------------------------------------
        ---- 21_fwd_in_pdt_rooms
        ["fwd_in_pdt__rooms_quirky_red_tree"] = {
            ["name"] = "Quirky Red Leaf Tree",
            ["inspect_str"] = "This tree is particularly odd. It has an ominous air about it",
        },
        ["fwd_in_pdt__rooms_quirky_red_tree_special"] = {
            ["name"] = "Quirky Red Leaf Tree",
            ["inspect_str"] = "This tree is particularly odd. It has an ominous air about it",
        },
        ["fwd_in_pdt__rooms_mini_portal_door"] = {
            ["name"] = "mini portal door",
            ["inspect_str"] = "There won't be an accident with this door, will there ?",
            ["action_str"] = "use",
            ["mouse_over_text"] = "Transport to "..STRINGS.NAMES.MULTIPLAYER_PORTAL,

        },
        --------------------------------------------------------------------
        ---- 22_fwd_in_pdt_npc
        --------------------------------------------------------------------
        ---- 23_fwd_in_pdt_wellness
            ["fwd_in_pdt_wellness"] = {
                ["name"] = "Body Wellness",
                ["treatment"] = "想办法提高总体体质值",
                ["health_down_death_announce"] = "XXXX died because of lack of Wellness Value. Too bad. ",

            },
            ["fwd_in_pdt_wellness_vitamin_c"] = {
                ["name"] = "Vitamin C",
                ["treatment"] = "多吃富含维他命C的食物",
            },
            ["fwd_in_pdt_wellness_glucose"] = {
                ["name"] = "Glucose in blood",
                ["treatment"] = "多吃含糖食物",
            },
            ["fwd_in_pdt_wellness_poison"] = {
                ["name"] = "Poison",
                ["treatment"] = "使用对应的解毒药剂",
            },
        --------------------------------------------------------------------
        --------------------------------------------------------------------

}