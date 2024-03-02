-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    虚空钓鱼 生成prefab 用
]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_cd_key_sys"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local item_list = {
        "cutgrass","twigs","log",    "driftwood_log",    "livinglog",    "charcoal",    "ash",    "cutreeds",    "lunarplant_husk",    "horrorfuel",
        "nightmarefuel",    "succulent_picked",    "lightbulb",    "rope",    "boards",    "flint",    "nitre",    "rocks",    "goldnugget",    "marble",    "moonrocknugget",
        "thulecite_pieces",    "townportaltalisman",    "gears",    "saltrock",    "palmcone_scale",    "moonglass",    "transistor",    "cutstone",    "marblebean",    "thulecite",
        "dreadstone",    "purebrilliance",    "voidcloth",    "walrus_tusk",    "malbatross_beak",    "boneshard",    "fossil_piece",    "horn",    "lightninggoathorn",
        "gnarwail_horn",    "minotaurhorn",    "deerclops_eyeball",    "pigskin",    "tentaclespots",    "slurper_pelt",    "dragon_scales",    "shroom_skin",    "manrabbit_tail",
        "beefalowool",    "steelwool",    "beardhair",    "honeycomb",    "silk",    "spidergland",    "mosquitosack",    "phlegm",    "slurtleslime",    "coontail",    "poop",
        "guano",    "glommerfuel",    "treegrowthsolution",    "krampus_sack",    "icepack",    "piggyback",    "backpack",    "armorskeleton",    "armordragonfly",    "armorsnurtleshell",
        "armormarble",    "armor_sanity",    "armorruins",    "armorwood",    "armor_bramble",    "armorgrass",    "armorwagpunk",    "armor_voidcloth",    "armordreadstone",    "armor_lunarplant",
        "eyemaskhat",    "balloonhat",    "skeletonhat",    "hivehat",    "slurtlehat",    "ruinshat",    "beehat",    "wathgrithrhat",    "footballhat",    "alterguardianhat",    "cookiecutterhat",
        "redgem",    "orangegem",    "yellowgem",    "greengem",    "bluegem",    "purplegem",    "opalpreciousgem",    "panflute",    "firestaff",    "orangestaff",    "yellowstaff",    "greenstaff",
            "icestaff",    "telestaff",    "opalstaff",    "amulet",    "orangeamulet",    "yellowamulet",    "greenamulet",    "blueamulet",    "purpleamulet"
        }
    local monster_list = {
        "penguin","beefalo","koalefant_summer","koalefant_winter","lightninggoat","carrat_ghostracer","fruitdragon","molebat","monkey","slurtle",
        "snurtle","rocky","slurper","krampus","mossling","moonpig","pigman","bunnyman","merm","little_walrus","walrus","knight","bishop","rook","knight_nightmare",
        "bishop_nightmare","rook_nightmare","spider","spider_warrior","spider_hider","spider_spitter","spider_dropper","spider_moon","spider_healer","spider_water","hound",
        "firehound","icehound","rabbit","frog","frog","perd"
    }
    local boss_list = {
        "bearger",        "mutatedbearger",        "deerclops",        "mutateddeerclops",        "beequeen",        "minotaur",        "leif",
        "leif_sparse",        "spiderqueen",        "warglet",        "warg",        "mutatedwarg",        "spat",
        "shadowthrall_hands",        "shadowthrall_wings",        "shadowthrall_horns",
    }
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.fwd_in_pdt_events = inst.fwd_in_pdt_events or {}
        inst.fwd_in_pdt_events.get_fishing_time = function()    ---- 钓鱼时间
            local time = 5
            local percentage = math.random(1000)/1000
            if percentage < 0.1 then
                time = math.random(30,50)
            elseif percentage < 0.2 then
                time = math.random(20,30)
            else
                time = math.random(5,20)
            end
            return time
        end
        inst.fwd_in_pdt_events.void_fishing_hook = function(time)   --- 根据时间进行概率计算
            -- 5-20    20-30   30-50
            if time <= 20 then
                            ----------------------------------------------------------
                            ---- 时间太短,单个物品
                            ----------------------------------------------------------
                                if math.random(100) < 70 then
                                    local ret_item_prefab = item_list[math.random(#item_list)]
                                    local target = SpawnPrefab(ret_item_prefab)
                                    return target
                                else
                                    return nil
                                end
                            ----------------------------------------------------------
            elseif time <= 30 then
                            ----------------------------------------------------------
                            --- 礼包
                            ----------------------------------------------------------
                                local temp_num = math.random(1000)/1000
                                if temp_num < 0.6 then
                                    local item_type_num = math.random(2,5)
                                    local items = {}
                                    for i = 1, item_type_num, 1 do
                                        local temp_item_prefab = item_list[math.random(#item_list)]
                                        table.insert(items,{temp_item_prefab,math.random(1,3)})
                                    end
                                    local gift_box = SpawnPrefab("fwd_in_pdt_gift_pack")
                                    local skin_num = tostring(math.random(12))
                                    gift_box:PushEvent("Set",{
                                            items = items,
                                            name = GetStringsTable("fwd_in_pdt_gift_pack")["name.void_box"],
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
                                    return gift_box
                                
                                elseif temp_num < 0.8 then
                                    return nil
                                else
                                    local monster = monster_list[math.random(#monster_list)]
                                    return SpawnPrefab(monster)
                                end
                            ----------------------------------------------------------

            else
                            ----------------------------------------------------------
                            --- 大礼包、BOSS
                            ----------------------------------------------------------
                                local temp_num = math.random(1000)/1000
                                if temp_num <= 0.4 then
                                    local item_type_num = math.random(3,7)
                                    local items = {}
                                    for i = 1, item_type_num, 1 do
                                        local temp_item_prefab = item_list[math.random(#item_list)]
                                        table.insert(items,{temp_item_prefab,math.random(1,10)})
                                    end
                                    local gift_box = SpawnPrefab("fwd_in_pdt_gift_pack")
                                    local skin_num = tostring(math.random(12))
                                    gift_box:PushEvent("Set",{
                                            items = items,
                                            name = GetStringsTable("fwd_in_pdt_gift_pack")["name.void_box"],
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
                                    return gift_box
                                elseif temp_num <= 0.8 then
                                    local monster = monster_list[math.random(#monster_list)]
                                    return SpawnPrefab(monster)
                                else
                                    local boss = boss_list[math.random(#boss_list)]
                                    return SpawnPrefab(boss)
                                end
                            ----------------------------------------------------------
            end

        end


    end)