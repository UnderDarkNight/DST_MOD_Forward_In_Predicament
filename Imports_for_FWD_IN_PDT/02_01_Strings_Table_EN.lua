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
                ["succeed_announce"] = "There was a loud bang in the sky, and VIP member [ XXXXXXX ] made a shiny appearance",
                ["talker"] = "【Fwd ind Predicament】",
                ["bad_key.str"] = "The same CD-KEY as other players is detected, please pay attention to privacy protection ! ! ! !",
                ["check_start"] = "Start checking the CD-KEY entered by the player :  ",
                ["check_fail"] = "Invalid CD-KEY entered by player",
                ["check_server_fail"] = "Failed to connect to the CD-KEY server",
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
                ["inspect_str"] = "A Gift Box",
                ["name.opening_gift_box"] = "Newbie Survival Gift Box",
                ["name.vip"] = "VIP Gift Box",
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
            ["fwd_in_pdt_item_insulin__syringe"] = {
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
            ["fwd_in_pdt_item_locked_book"] = {
                ["name"] = "Locked Book",
                ["inspect_str"] = "It takes some skill to unlock it.",
            },
            ["fwd_in_pdt_item_cursed_pig_skin"] = {
                ["name"] = "Cursed Pig Skin",
                ["inspect_str"] = "Cursed Spreading Pigskin",
            },
            ["fwd_in_pdt_item_book_of_gardening"] = {
                ["name"] = "Book Of Gardening",
                ["inspect_str"] = "A book of gardening",
            },
            ["fwd_in_pdt_item_book_of_newmoon"] = {
                ["name"] = "Magic Book Of New Moon",
                ["inspect_str"] = "It's filled with new moon related content and magic",
            },
            ["fwd_in_pdt_item_formulated_crystal"] = {
                ["name"] = "Formulated Crystals",
                ["inspect_str"] = "Recipes of Production Table",
            },
            ["fwd_in_pdt_item_glass_pig_skin"] = {
                ["name"] = "Glass Pig Skin",
                ["inspect_str"] = "Glass Pig Skin",
            },
            ["fwd_in_pdt_item_glass_horn"] = {
                ["name"] = "Glass Horn",
                ["inspect_str"] = "Glass Horn",
            },
            ["fwd_in_pdt_item_mod_synopsis"] = {
                ["name"] = "Synopsis",
                ["inspect_str"] = "Synopsis of Forward In Predicament",
            },
            ["fwd_in_pdt_item_advertising_leaflet"] = {
                ["name"] = "Advertising Leaflet",
                ["inspect_str"] = "An Advertising Leaflet",
                ["name2"] = " ( Read )"

            },
            ["fwd_in_pdt_item_adrenaline_injection"] = {
                ["name"] = "Adrenaline Injection",
                ["inspect_str"] = "Respond with a small amount of Wellness, the more you use it in the short term the less effective it will be",
                ["recipe_desc"] = "Respond with a small amount of Wellness, the more you use it in the short term the less effective it will be",
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
            ["fwd_in_pdt_material_chaotic_eyeball"] = {
                ["name"] = "Chaotic Eyeball",
                ["inspect_str"] = "This eyeball is filled with chaotic energy.",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_1"] = {
                ["name"] = "Chaotic Cookpot Puzzle I",
                ["inspect_str"] = "A fragment of a blueprint",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_2"] = {
                ["name"] = "Chaotic Cookpot Puzzle II",
                ["inspect_str"] = "A fragment of a blueprint",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_3"] = {
                ["name"] = "Chaotic Cookpot Puzzle III",
                ["inspect_str"] = "A fragment of a blueprint",
            },
            ["fwd_in_pdt_material_chaotic_cookpot_puzzle_4"] = {
                ["name"] = "Chaotic Cookpot Puzzle IV",
                ["inspect_str"] = "A fragment of a blueprint",
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
            ["fwd_in_pdt_equipment_glass_pig"] = {
                ["name"] = "Glass Pig Statue",
                ["inspect_str"] = "The statue is so lifelike, and you can dedicate bonestews on the full moon"
            },
            ["fwd_in_pdt_equipment_cursed_pig"] = {
                ["name"] = "Cursed Pig Statue",
                ["inspect_str"] = "The statue is so lifelike, and you can dedicate bonestews on the new moon"
            },
            ["fwd_in_pdt_equipment_glass_beefalo"] = {
                ["name"] = "Glass Beefalo Statue",
                ["inspect_str"] = "The statue is so lifelike .",
                ["gift_box"] = "Beefalo Gift Pack"
            },
            ["fwd_in_pdt_equipment_huge_soybean"] = {
                ["name"] = "Huge Soybean Pods",
                ["inspect_str"] = "Very Huge"
            },
            ["fwd_in_pdt_equipment_huge_orange"] = {
                ["name"] = "Huge Orange",
                ["inspect_str"] = "Very Huge"
            },
            ["fwd_in_pdt_equipment_mole_backpack"] = {
                ["name"] = "Mole Backpack",
                ["inspect_str"] = "Backpack",
                ["name.panda"] = "Panda Backpack",
                ["name.cat"] = "Cat Backpack",
                ["name.rabbit"] = "Rabbit Backpack",
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
            ["fwd_in_pdt_food_mango"] = {
                ["name"] = "Mango",
                ["inspect_str"] = "Ripe mango",
            },
            ["fwd_in_pdt_food_mango_green"] = {
                ["name"] = "Green Mango",
                ["inspect_str"] = "Unripe mango",
            },
            ["fwd_in_pdt_food_orange"] = {
                ["name"] = "Orange",
                ["inspect_str"] = "yellowish-orange",
            },
            ["fwd_in_pdt_food_soybeans"] = {
                ["name"] = "Soybeans",
                ["inspect_str"] = "One by one, they're quite full.",
            },
            ["fwd_in_pdt_food_coffeebeans"] = {
                ["name"] = "Coffee Beans",
                ["inspect_str"] = "One by one, they're quite full.",
            },
        --------------------------------------------------------------------
        ---- 05_fwd_in_pdt_foods_cooked
            ["fwd_in_pdt_food_mixed_potato_soup"] = {
                ["name"] = "Mix Potato Soup",
                ["inspect_str"] = "Pieces of it look like lumps.",
                ["oneat_desc"] = "Relieves fever and raises body temperature",

            },
            ["fwd_in_pdt_food_steamed_orange_with_honey"] = {
                ["name"] = "Steamed Orange With Honey",
                ["inspect_str"] = "The scent of oranges is accompanied by the sweetness of honey",
                ["oneat_desc"] = "cough treatment",
            },
            ["fwd_in_pdt_food_scrambled_eggs_with_tomatoes"] = {
                ["name"] = "Screamble Eggs With Tomatoes",
                ["inspect_str"] = "The classic tomato and egg combo",
                ["oneat_desc"] = "VC does not decrease in one day",
            },
            ["fwd_in_pdt_food_eggplant_casserole"] = {
                ["name"] = "Eggplant Casserole",
                ["inspect_str"] = "Classic Eggplant Cuisine",
                ["oneat_desc"] = "Lower blood glucose levels",
            },
            ["fwd_in_pdt_food_gifts_of_nature"] = {
                ["name"] = "Gifts Of Nature",
                ["inspect_str"] = "Cooked with a mixture of natural ingredients",
                ["oneat_desc"] = "Increased blood glucose levels",
            },
            ["fwd_in_pdt_food_snake_skin_jelly"] = {
                ["name"] = "Snake Skin Jelly",
                ["inspect_str"] = "It's very flexible, but it always feels like there's a snake living in it",
                ["oneat_desc"] = "detoxify snake venom",
            },
            ["fwd_in_pdt_food_atractylodes_macrocephala_pills"] = {
                ["name"] = "Atractylodes Macrocephala Pills",
                ["inspect_str"] = "Raising body temperature and removing moisture",
                ["oneat_desc"] = "Removes moisture and stabilizes body temperature",
            },
            ["fwd_in_pdt_food_pinellia_ternata_pills"] = {
                ["name"] = "Pinellia Ternata Pills",
                ["inspect_str"] = "It protects against sandstorms and lowers body temperature.",
                ["oneat_desc"] = "Lower your body temperature. Immunize yourself against dust storms for a little while.",
            },
            ["fwd_in_pdt_food_aster_tataricus_l_f_pills"] = {
                ["name"] = "Aster Tataricus L.F Pills",
                ["inspect_str"] = "Can treat coughs and fevers",
                ["oneat_desc"] = "Treat coughs and fevers",
            },
            ["fwd_in_pdt_food_red_mushroom_soup"] = {
                ["name"] = "Red Mushroom Soup",
                ["inspect_str"] = "This soup feels dangerous.",
                ["special_action_str"] = "Feed",
                ["oneat_desc"] = "Do Not Feed Pigman !!",
            },
            ["fwd_in_pdt_food_green_mushroom_soup"] = {
                ["name"] = "Green Mushroom Soup",
                ["inspect_str"] = "This soup feels dangerous.",
                ["special_action_str"] = "Feed",
                ["oneat_desc"] = "You'll hallucinate.",
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
                ["inspect_str"] = "Boiled milk tastes so good.",
                ["oneat_desc"] = "cough treatment",
            },
            ["fwd_in_pdt_food_yogurt"] = {
                ["name"] = "Yogurt",
                ["inspect_str"] = "It's sour and tasty."
            },
            ["fwd_in_pdt_food_coffee"] = {
                ["name"] = "Coffee",
                ["inspect_str"] = "refresh and clear the mind",
                ["oneat_desc"] = "Increase walking speed for a little while",
            },
            ["fwd_in_pdt_food_saline_medicine"] = {
                ["name"] = "Saline Medicine",
                ["inspect_str"] = "Medical supplies",
                ["oneat_desc"] = "Increase VC",
            },
            ["fwd_in_pdt_food_yogurt_ice_cream"] = {
                ["name"] = "Yogurt Ice Cream",
                ["inspect_str"] = "sweet and savory",
                ["oneat_desc"] = "lower body temperature",
            },
            ["fwd_in_pdt_food_mango_ice_drink"] = {
                ["name"] = "Mango Ice Drink",
                ["inspect_str"] = "Filled with the scent of mango",
                ["oneat_desc"] = "Increased attack power",
            },
            ["fwd_in_pdt_food_cooked_rice"] = {
                ["name"] = "Cooked Rice",
                ["inspect_str"] = "tantalizing taste",
                -- ["oneat_desc"] = "可快速采集",
            },
            ["fwd_in_pdt_food_bread"] = {
                ["name"] = "Bread",
                ["inspect_str"] = "tantalizing taste",
                ["oneat_desc"] = "Slowly restores hunger levels",
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
                ["inspect_str"] = "A favorite among bodybuilders",
                ["oneat_desc"] = "No muscle atrophy",
            },
            ["fwd_in_pdt_food_stinky_tofu_salad"] = {
                ["name"] = "Stinky Tofu Salad",
                ["inspect_str"] = "It tastes awful, but it's delicious",
            },
            ["fwd_in_pdt_food_stinky_tofu_bolognese"] = {
                ["name"] = "Stinky Tofu Bolognese",
                ["inspect_str"] = "It tastes awful, but it's delicious",
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
            ["fwd_in_pdt_building_fermenter"] = {
                ["name"] = "Fermenter",
                ["inspect_str"] = "It can be used to ferment some foods",
                ["recipe_desc"] = "It can be used to ferment some foods",
                ["inspect_str_burnt"] = "It's burned.",
                ["action_str"] = "Fester"
            },
            ["fwd_in_pdt_building_special_cookpot"] = {
                ["name"] = "混沌万能锅",
                ["inspect_str"] = "能烹饪出不少食物",
                ["recipe_desc"] = "能烹饪出不少食物",
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
            ["fwd_in_pdt_building_atm"] = {
                ["name"] = "ATM",
                ["inspect_str"] = "It is possible to save and withdraw money",
            },
            ["fwd_in_pdt_building_bulletin_board"] = {
                ["name"] = "Bulletin Board",
                ["inspect_str"] = "There are advertisements posted, and tasks",
            },
            ["fwd_in_pdt_building_hospital"] = {
                ["name"] = "Hospital",
                ["inspect_str"] = "There's actually a hospital here.",
                ["action_str"] = "Enter",
            },
            ["fwd_in_pdt_building_doll_clamping_machine"] = {
                ["name"] = "Doll Clamping Machine",
                ["inspect_str"] = "Try your luck.",
                ["action_str"] = "Invest in",
                ["gift_box.medical_kit"] = "Medical kit",
                ["gift_box.boss"] = "Boss Drop Supply Pack",
                ["gift_box.lunar"] = "Lunar Supply Pack",
                ["gift_box.shadow"] = "Shadow Supply Pack",
                ["gift_box.egg"] = "Eggs Supply Pack",
                ["gift_box.coffee"] = "Coffee Supply Pack",
                ["gift_box.ruins"] = "Ruins Supply Pack",
                ["gift_box.greenamulet"] = "Green Light Supply Pack",
                ["gift_box.eyeturret_item"] = "Eyeturret Supply Pack",
                ["gift_box.amulet"] = "Red Amulet Supply Pack",
                ["gift_box.gems"] = "Gems Supply Pack",
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
            ["fwd_in_pdt_plant_coffeebush"] = {
                ["name"] = "Coffee Bush",
                ["inspect_str"] = "Strange coffee bush.",
            },
            ["fwd_in_pdt_plant_coffeebush_item"] = {
                ["name"] = "Coffee Bush",
                ["inspect_str"] = "Strange coffee bush.",
            },
            ["fwd_in_pdt_plant_mango_tree"] = {
                ["name"] = "Mango Tree",
                ["inspect_str"] = "Strange Mango Tree",
            },
            ["fwd_in_pdt_plant_mango_tree_item"] = {
                ["name"] = "Mango Tree Sprout",
                ["inspect_str"] = "Can be used to grow mango trees",
            },
            ["fwd_in_pdt_plant_bean"] = {
                ["name"] = "Soybean Plant",
                ["inspect_str"] = "Rich in vegetable protein",
            },
            ["fwd_in_pdt_plant_bean_seed"] = {
                ["name"] = "Bean Seeds",
                ["inspect_str"] = "It can be used for planting.",
            },
            ["fwd_in_pdt_plant_orange"] = {
                ["name"] = "Orange Tree",
                ["inspect_str"] = "You can get yellow oranges",
            },
            ["fwd_in_pdt_plant_orange_seed"] = {
                ["name"] = "Orange Tree Seed",
                ["inspect_str"] = "It can be used for planting.",
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
            ["turf_fwd_in_pdt_turf_snakeskin"] = {
                ["name"] = "Snake Skin Turf",
                ["inspect_str"] = "Rugs made of snake skin",
            },
            ["turf_fwd_in_pdt_turf_cobbleroad"] = {
                ["name"] = "Cobble Road",
                ["inspect_str"] = "Ground made of stone and brick piles",
            },
            ["turf_fwd_in_pdt_turf_grasslawn"] = {
                ["name"] = "Grass Lawn",
                ["inspect_str"] = "Trimmed out of grass, one grid at a time",
            },
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
            ["wisper_str"] = "There is a very strange tree nearby",

        },
        ["fwd_in_pdt__rooms_quirky_red_tree_special"] = {
            ["name"] = "Quirky Red Leaf Tree",
            ["inspect_str"] = "This tree is particularly odd. It has an ominous air about it",
            ["wisper_str"] = "There is a very strange tree nearby",
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
                ["treatment"] = "Find ways to increase overall body wellness values",
                ["health_down_death_announce"] = "XXXX 死于体质不够高，太惨了 ~ ",
            },
            ["fwd_in_pdt_wellness_vitamin_c"] = {
                ["name"] = "Vitamin C",
                ["treatment"] = "Eat more foods rich in vitamin C",
            },
            ["fwd_in_pdt_wellness_glucose"] = {
                ["name"] = "Blood Glucose",
                ["treatment"] = "Eating sugary foods increases. A rapid decrease requires insulin shots.",
            },
            ["fwd_in_pdt_wellness_poison"] = {
                ["name"] = "Poison",
                ["treatment"] = {"Emptying requires a Universal Antidote","To stop the growth, you need to use the corresponding detoxification methods"},
            },
            ["fwd_in_pdt_welness_snake_poison"] = {
                ["name"] = "Snake Poison",
                ["treatment"] = "Andrographis Paniculata ( botany )",
            },
            ["fwd_in_pdt_welness_frog_poison"] = {
                ["name"] = "Frog Poison",
                ["treatment"] = "Universal Antidote or "..STRINGS.NAMES[string.upper("frogglebunwich")],
            },
            ["fwd_in_pdt_welness_spider_poison"] = {
                ["name"] = "Spider Poison",
                ["treatment"] = { STRINGS.NAMES[string.upper("spidergland")] ,STRINGS.NAMES[string.upper("healingsalve")] , "Universal Antidote" },
            },
            ["fwd_in_pdt_welness_bee_poison"] = {
                ["name"] = "Bee Poison",
                ["treatment"] = { STRINGS.NAMES[string.upper("taffy")] , "Universal Antidote" },
            },
            ["fwd_in_pdt_welness_cough"] = {
                ["name"] = "Cough",
                ["treatment"] = { "Disease Treatment Magic Book","Aster Tataricus L.F Pills","Cooked Milk , Mix Potato Soup , Steamed Orange With Honey"},
            },
            ["fwd_in_pdt_welness_fever"] = {
                ["name"] = "Fever",
                ["treatment"] = { "Disease Treatment Magic Book","Aster Tataricus L.F Pills","Cooked Milk , Mix Potato Soup , Steamed Orange With Honey"},
            },
        --------------------------------------------------------------------
        --------------------------------------------------------------------

}