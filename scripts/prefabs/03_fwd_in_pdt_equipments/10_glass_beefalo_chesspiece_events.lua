----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 玻璃牛的事件注册
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_equipment_glass_beefalo"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local prize_pools = {
    -------------------------------------------------------------------
    ---- 奖池 1
        {
            probability = 10/100 ,  --- 概率
            list = {
                { prefab = "lunarplanthat",num = 1,special = false},
                { prefab = "fwd_in_pdt_item_book_of_gardening",num = 1,special = false},
                { prefab = "krampus_sack",num = 1,special = false},
                { prefab = "fwd_in_pdt_item_book_of_harvest",num = 1,special = false},
                { prefab = "orangestaff",num = 1,special = false},
                { prefab = "fwd_in_pdt_item_disease_treatment_book",num = 1,special = false},
                { prefab = "skeletonhat",num = 1,special = false},
                { prefab = "armorskeleton",num = 1,special = false},
                { prefab = "sword_lunarplant",num = 1,special = false},
                { prefab = "armor_lunarplant",num = 1,special = false},

            }
        },
    -------------------------------------------------------------------
    ---- 奖池 2
        {
            probability = 20/100 ,  --- 概率
            list = {
                { prefab = "ruins_bat",num = 1,special = false},
                { prefab = "armorruins",num = 1,special = false},
                { prefab = "ruinshat",num = 1,special = false},
                { prefab = "nightsword",num = 1,special = false},
                { prefab = "armor_sanity",num = 1,special = false},
                { prefab = "dreadstone",num = 5,special = false},
                { prefab = "marble",num = 5,special = false},
                { prefab = "purpleamulet",num = 1,special = false},
                { prefab = "pumpkin_oversized",num = 1,special = true},
                { prefab = "deerclops_eyeball",num = 1,special = false},
                { prefab = "lavae_egg",num = 1,special = false},
                { prefab = "turf_dragonfly",num = 1,special = false},
                { prefab = "yellowstaff",num = 1,special = false},
                { prefab = "shadowheart",num = 1,special = false},
                { prefab = "minotaurhorn",num = 1,special = false},
                { prefab = "gears",num = 1,special = false},
            }
        },
    -------------------------------------------------------------------
    ---- 奖池 3
        {
            probability = 70/100 ,  --- 概率
            list = {
                    { prefab = "nightmarefuel",num = 1,special = false},
                    { prefab = "fwd_in_pdt_food_universal_antidote",num = 1,special = false},
                    { prefab = "bundlewrap",num = 1,special = false},
                    { prefab = "ice",num = 1,special = false},
                    { prefab = "cave_banana",num = 1,special = false},
                    { prefab = "moonrocknugget",num = 1,special = false},
                    { prefab = "spidergland",num = 1,special = false},
                    { prefab = "fwd_in_pdt_material_tree_resin",num = 1,special = false},
                    { prefab = "dug_rock_avocado_bush",num = 1,special = false},
                    { prefab = "spice_salt",num = 1,special = false},
                    { prefab = "stinger",num = 1,special = false},
                    { prefab = "mosquitosack",num = 1,special = false},
                    { prefab = "glommerfuel",num = 1,special = false},
                    { prefab = "saltrock",num = 1,special = false},
                    { prefab = "froglegs",num = 5,special = false},
                    { prefab = "fwd_in_pdt_item_insulin__syringe",num = 1,special = false},
                    { prefab = "papyrus",num = 1,special = false},
                    { prefab = "fwd_in_pdt_food_coffee",num = 1,special = false},
                    { prefab = "fwd_in_pdt_material_snake_skin",num = 1,special = false},
                    { prefab = "cutgrass",num = 1,special = false},
                    { prefab = "twigs",num = 1,special = false},
                    { prefab = "cutreeds",num = 1,special = false},
                    { prefab = "spider",num = 1,special = false},
                    { prefab = "pigskin",num = 1,special = false},
                    { prefab = "boards",num = 1,special = false},
                    { prefab = "log",num = 1,special = false},
                    { prefab = "pinecone",num = 1,special = false},
                    { prefab = "ash",num = 1,special = false},
                    { prefab = "rocks",num = 1,special = false},
                    { prefab = "goldnugget",num = 1,special = false},
                    { prefab = "thulecite_pieces",num = 1,special = false},
                    { prefab = "flint",num = 1,special = false},
                    { prefab = "nitre",num = 1,special = false},
                    { prefab = "pepper_oversized",num = 1,special = true},
                    { prefab = "potato_oversized",num = 1,special = true},
            }
        },
    -------------------------------------------------------------------

}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    inst:ListenForEvent("item_accepted",function(inst,player)
        --------------------------------------------------------------------------
        ----- 丢一个东西出来
            TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                pt = Vector3(inst.Transform:GetWorldPosition()) ,--- 缺省为自身
                prefab = "fwd_in_pdt_food_raw_milk",     --- 要丢的物品
                num = 1,            --- 丢的数量
                player = player,       --- 玩家inst
            })
        --------------------------------------------------------------------------
        -----
            local ret_num  = player.components.fwd_in_pdt_data:Add("fwd_in_pdt_equipment_glass_beefalo.trade_times",1)

            if ret_num == 1 then    --- 第一次兑换
                TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                    pt = Vector3(inst.Transform:GetWorldPosition()) ,--- 缺省为自身
                    prefab = "fwd_in_pdt_gift_pack",     --- 要丢的物品
                    num = 1,            --- 丢的数量
                    player = player,       --- 玩家inst
                    item_fn = function(inst)
                        local skin_num = math.random(12)
                        inst:PushEvent("Set",{
                            name = GetStringsTable()["gift_box"],
                            inspect_str = GetStringsTable()["gift_box"],
                            items = {
                                {"saltrock",5},
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
                    end
                })
                return
            end

            if ret_num%5 ~= 0 then  --- 5 次一出
                return
            end

            local items = {
            }
            ----------------------------------------------------------------------------
            --- 奖池计算和插入表
                local current_priority = math.random(1000)/1000
                for k, single_pool in pairs(prize_pools) do
                    if current_priority <= single_pool.probability then -- 当前概率踩中该表概率
                        local temp_item_list = single_pool.list
                        local ret_item_cmd = temp_item_list[math.random(#temp_item_list)] --- 从表中选一个
                        if ret_item_cmd.special == true then
                            --- 不能放进容器的东西
                            for i = 1, ret_item_cmd.num , 1 do
                                table.insert(items,{ret_item_cmd.prefab,1})
                            end
                        else
                            --- 能放到容器的东西
                            table.insert(items,{ret_item_cmd.prefab,ret_item_cmd.num or 1})
                        end
                    end
                end
            ----------------------------------------------------------------------------
                if ret_num%500 == 0 then
                    table.insert(items,{"fwd_in_pdt_food_universal_antidote",1})
                end
                if ret_num%1000 == 0 then
                    table.insert(items,{"fwd_in_pdt_item_book_of_newmoon",1})
                end
            ----------------------------------------------------------------------------
                if #items == 0 then                
                    table.insert(items,{"beefalowool",1})   --- 低保 包裹里一个牛毛
                end
                TheWorld.components.fwd_in_pdt_func:Trow_Item_2_Player({
                    pt = Vector3(inst.Transform:GetWorldPosition()) ,--- 缺省为自身
                    prefab = "fwd_in_pdt_gift_pack",     --- 要丢的物品
                    num = 1,            --- 丢的数量
                    player = player,       --- 玩家inst
                    item_fn = function(inst)
                        local skin_num = math.random(12)
                        inst:PushEvent("Set",{
                            name = GetStringsTable()["gift_box"],
                            inspect_str = GetStringsTable()["gift_box"],
                            items = items,
                            new_anim = {               ----- 其他皮肤数据
                                bank = "fwd_in_pdt_gift_pack",
                                build = "fwd_in_pdt_gift_pack",
                                anim = "fwd_in_pdt_gift_pack_"..skin_num,
                                scale = 2,
                                imagename = "fwd_in_pdt_gift_pack_"..skin_num,
                                atlasname = "images/inventoryimages/fwd_in_pdt_gift_pack.xml",
                            },
                        })
                    end
                })
        --------------------------------------------------------------------------
        ---- 惩罚.刷 10-20头牛。雕像炸掉
            local punish_flag = false
            if ret_num%100 == 0 or ( TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE and ret_num%10 == 0 ) then
                punish_flag = true
            end
            if punish_flag then
                    local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                        target = inst,
                        range = 9,
                        num = math.random(10,20),
                    })
                    local base_pt = Vector3(inst.Transform:GetWorldPosition())
                    for i, pt in pairs(locations) do
                        TheWorld:DoTaskInTime(i-1,function()
                                if TheWorld.Map:IsOceanAtPoint(pt.x, 0, pt.z, false) then   -- 在海里
                                    pt = base_pt
                                end
                                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                                local monster = SpawnPrefab("beefalo")
                                monster.Transform:SetPosition(pt.x,0,pt.z)
                                monster:DoTaskInTime(0.5,function()
                                    monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                                end)
                        end)
                    end

                    ---- 雕像炸掉
                    SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{target = inst})
                    TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                            target = inst,
                            name = "moonglass",
                            num = math.random(4),    -- default
                            range = 5, -- default
                            height = 3,-- default
                    })
                    inst:Remove()
            end
        --------------------------------------------------------------------------
    end)

end