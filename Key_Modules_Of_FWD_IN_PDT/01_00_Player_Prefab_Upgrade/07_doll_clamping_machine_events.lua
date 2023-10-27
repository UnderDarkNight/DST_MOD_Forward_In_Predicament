-----------------------------------------------------------------------------------------------------------------------------------------
---- 娃娃机事件
---- 权重越高越容易概率获得
---- 场地  7x7 格子。半径 14
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_building_doll_clamping_machine"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
local events = {
    ------------------------------------------------------------------------------------------
    ------ 1 : 5s内清空饱食度
        {
            id = 1,
            weight = 1,
            fn = function(inst,player)
                if player.components.hunger then
                    local delta_num = -1*math.ceil(player.components.hunger.current/5)
                    for i = 1, 5, 1 do
                        player:DoTaskInTime(i,function()
                            player.components.hunger:DoDelta(delta_num)
                        end)
                    end
                end
            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 2 : 人物周围召唤10个桦树树精
        {
            id = 2,
            weight = 1,
            fn = function(inst,player)
                -- local x,y,z = inst.Transform:GetWorldPosition()
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 12,
                    num = 10,
                })
                for k, pt in pairs(locations) do
                    SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                    local tree = SpawnPrefab("deciduoustree_tall")
                    tree.Transform:SetPosition(pt.x,0,pt.z)
                    tree:DoTaskInTime(math.random(5),function()
                        tree:StartMonster(true)
                    end)
                end
            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 3 : 周围生成N个蜗牛粘液，并燃烧爆炸.同时生成睡眠烟雾
        {
            id = 3,
            weight = 1,
            fn = function(inst,player)
                local x,y,z = inst.Transform:GetWorldPosition()
                local locations = {}
                ------------------------------------------------------
                ---- 刷一堆睡眠烟雾
                    for i = 0, 2, 1 do                       
                        local temp_locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                            target = inst,
                            range = 5 + i*5,
                            num = 5 + i*3,
                        })                
                        for k, pt in pairs(temp_locations) do
                            table.insert(locations,pt)
                        end
                    end

                ----------------- 让附近一圈玩家睡觉
                    local function HearPanFlute(inst)   --- 抄 排箫的代码(修改了一点点)
                        if inst and not inst:HasTag("playerghost") and
                            not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) and
                            not (inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck()) and
                            not (inst.components.fossilizable ~= nil and inst.components.fossilizable:IsFossilized()) then
                            local mount = inst.components.rider ~= nil and inst.components.rider:GetMount() or nil
                            if mount ~= nil then
                                mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = TUNING.PANFLUTE_SLEEPTIME })
                            end
                            if inst.components.sleeper ~= nil then
                                inst.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME)
                            elseif inst.components.grogginess ~= nil then
                                inst.components.grogginess:AddGrogginess(10, TUNING.PANFLUTE_SLEEPTIME)
                            else
                                inst:PushEvent("knockedout")
                            end
                        end
                    end

                    local function create_item_with_fire(pt)
                        local item = SpawnPrefab("slurtleslime")
                        item.Transform:SetPosition(pt.x,0,pt.z)
                        item.components.burnable:StartWildfire()
                    end

                    local musthaveoneoftags = {"player","pig","rabbit","animal","smallcreature","epic","monster","insect"}
                    for i, pt in pairs(locations) do
                        inst:DoTaskInTime((i-1)*0.3,function()
                            create_item_with_fire(pt)
                            SpawnPrefab("sleepbomb_burst").Transform:SetPosition(pt.x,0, pt.z)
                            SpawnPrefab("sleepcloud").Transform:SetPosition(pt.x, 0, pt.z)
                            local ents = TheSim:FindEntities(pt.x, 0, pt.z, 4, nil, {"playerghost"}, musthaveoneoftags)
                            for k, target in pairs(ents) do
                                pcall(HearPanFlute,target)
                                create_item_with_fire(Vector3(target.Transform:GetWorldPosition()))
                            end
                        end)
                    end

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 4 : 生成礼物包，内含：雄黄饮剂 x2，万能解毒剂 x2，胰岛素针x2，蜂蜜膏药X2，强心针X2，治疗膏药X2
        {
            id = 4,
            weight = 1,
            fn = function(inst,player)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))

                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.medical_kit"],
                                inspect_str =  GetStringsTable()["gift_box.medical_kit"],
                                items = {
                                            {"fwd_in_pdt_item_insulin__syringe",2},
                                            {"fwd_in_pdt_food_andrographis_paniculata_botany",2},
                                            {"fwd_in_pdt_food_universal_antidote",2},
                                            {"bandage",2},
                                            {"lifeinjector",2},
                                            {"healingsalve",2},
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 5 : 各大BOSS掉落材料里，抽选 9 个进背包
        {
            id = 5,
            weight = 1,
            fn = function(inst,player)
                local boss_items = {"horrorfuel","lunarplant_husk","minotaurhorn","deerclops_eyeball","malbatross_beak","dragon_scales",
                                    "shroom_skin","steelwool","glommerfuel","honeycomb","royal_jelly","plantmeat",
                                    "mandrake","nightmarefuel","moonrocknugget","moonglass","purebrilliance","dreadstone","gnarwail_horn",
                                }
                local flag_num = 9
                local ret_item_prefab = {}
                for i = 1, 1000, 1 do
                    local temp_prefab = boss_items[math.random(#boss_items)]
                    if ret_item_prefab[temp_prefab] == nil then
                        ret_item_prefab[temp_prefab] = math.random(3)
                        flag_num = flag_num - 1
                    end
                    if flag_num <= 0 then
                        break
                    end
                end

                local items = {}
                for prefab, num in pairs(ret_item_prefab) do
                    table.insert(items,{prefab,num})
                end

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.boss"],
                                inspect_str =  GetStringsTable()["gift_box.boss"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 6 : 生成礼包，内含：玻璃x10，月岩x10，亮茄道具（武器、装备、者材料X10 中的一个）
        {
            id = 6,
            weight = 1,
            fn = function(inst,player)


                local items = {
                    {"moonglass",10},
                    {"moonrocknugget",10},
                    {"lunar_forge_kit",1},
                }
                local items_for_random = {
                    {"lunarplant_kit",1},
                    {"pickaxe_lunarplant",1},
                    {"shovel_lunarplant",1},
                    {"armor_lunarplant",1},
                    {"bomb_lunarplant",5},
                    {"lunarplanthat",1},
                    {"staff_lunarplant",1},
                    {"purebrilliance",10},
                    {"lunarplant_husk",10},
                }
                local ret = items_for_random[math.random(#items_for_random)]
                table.insert(items,ret)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.lunar"],
                                inspect_str =  GetStringsTable()["gift_box.lunar"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 7 : 生成礼包，内含：噩梦燃料X30，暗影道具（武器、装备、材料X10 中的一个）
        {
            id = 7,
            weight = 1,
            fn = function(inst,player)


                local items = {
                    {"nightmarefuel",30},
                    {"shadow_forge_kit",1},
                }
                local items_for_random = {
                    {"voidcloth",10},
                    {"voidcloth_umbrella",1},
                    {"voidcloth_scythe",1},
                    {"armor_voidcloth",1},
                    {"voidclothhat",1},
                    {"voidcloth_kit",1},
                    {"horrorfuel",10},
                }
                local ret = items_for_random[math.random(#items_for_random)]
                table.insert(items,ret)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.shadow"],
                                inspect_str =  GetStringsTable()["gift_box.shadow"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 8 : 场地内生成 X 10 只电羊，并充电。且攻击附近的玩家。
        {
            id = 3,
            weight = 1,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 9,
                    num = 10,
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab("lightninggoat")
                            monster.Transform:SetPosition(pt.x,0,pt.z)
                            monster:DoTaskInTime(0.5,function()
                                monster:PushEvent("lightningstrike")
                                monster:DoTaskInTime(0.5,function()
                                    monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                                end)
                            end)
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 9 : 生成20只蜘蛛，10只跳蛛，3只治疗蜘蛛
        {
            id = 9,
            weight = 2,
            fn = function(inst,player)
                local monsters = {}
                ------ 20 只蜘蛛
                    local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                        target = inst,
                        range = 10,
                        num = 20,
                    })
                    for i, pt in pairs(locations) do
                        table.insert(monsters,{prefab = "spider",pt = pt})
                    end
                ------ 10 只跳蛛
                    locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                        target = inst,
                        range = 10,
                        num = 10,
                    })
                    for i, pt in pairs(locations) do
                        table.insert(monsters,{prefab = "spider_warrior",pt = pt})
                    end
                ------ 3 只治疗蛛
                    locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                        target = inst,
                        range = 7,
                        num = 3,
                    })
                    for i, pt in pairs(locations) do
                        table.insert(monsters,{prefab = "spider_healer",pt = pt})
                    end
                ------ 逐个刷蜘蛛
                    for i, cmd in pairs(monsters) do
                        inst:DoTaskInTime(i-1,function()
                                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = cmd.pt,sound_off = true,type = "small"})
                                local monster = SpawnPrefab(cmd.prefab)
                                monster.Transform:SetPosition(cmd.pt.x,0,cmd.pt.z)
                                monster:DoTaskInTime(0.5,function()
                                    monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                                end)
                        end)
                    end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 10 : 场地内所有玩家被弄死。同时附近掉落玉龙币*300
        {
            id = 10,
            weight = 1,
            fn = function(inst,player)
                local x,y,z = inst.Transform:GetWorldPosition()
                local players = TheSim:FindEntities(x, y, z, 16, {"player"}, {"playerghost"}, nil)
                for k, templayer in pairs(players) do
                    if templayer and templayer.components.combat then
                            for i = 0, 10, 1 do
                                templayer:DoTaskInTime(0.5*i,function()
                                    templayer.components.combat:GetAttacked(inst,30)
                                end)
                            end
                    end
                end

                    inst:DoTaskInTime(0,function()
                                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                                    pt = Vector3(pt.x,pt.y+1,pt.z),
                                    scale = Vector3(2.5,1,2.5)
                                })
                                inst:DoTaskInTime(3,function()
                                    SpawnPrefab("fwd_in_pdt_item_jade_coin_black").Transform:SetPosition(pt.x,8,pt.z)
                                end)
                    end)
                    inst:DoTaskInTime(4,function()
                                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                                    pt = Vector3(pt.x,pt.y+1,pt.z),
                                    scale = Vector3(2.5,1,2.5)
                                })
                                inst:DoTaskInTime(3,function()
                                    SpawnPrefab("fwd_in_pdt_item_jade_coin_black").Transform:SetPosition(pt.x,8,pt.z)
                                end)
                    end)
                    inst:DoTaskInTime(8,function()
                                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                                    pt = Vector3(pt.x,pt.y+1,pt.z),
                                    scale = Vector3(2.5,1,2.5)
                                })
                                inst:DoTaskInTime(3,function()
                                    SpawnPrefab("fwd_in_pdt_item_jade_coin_black").Transform:SetPosition(pt.x,8,pt.z)
                                end)
                    end)
                


            end
        },
    ------------------------------------------------------------------------------------------
    ------ 11 : 生成礼包，内含：鸟蛋X10、高脚鸟蛋X5、皮蛋X5
        {
            id = 11,
            weight = 3,
            fn = function(inst,player)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))

                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.egg"],
                                inspect_str =  GetStringsTable()["gift_box.egg"],
                                items = {
                                            {"bird_egg",10},
                                            {"tallbirdegg",5},
                                            {"fwd_in_pdt_food_thousand_year_old_egg",5},
                                            {"tallbirdegg_cooked",math.random(5)},
                                            {"bird_egg_cooked",math.random(5)},
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 12 : 瞬间清空 San 。并得到 几个 噩梦燃料
        {
            id = 12,
            weight = 1,
            fn = function(inst,player)
                if player.components.combat then
                    player.components.combat:GetAttacked(inst,1)
                end
                if player.components.sanity then
                    player.components.sanity:DoDelta(-1000)
                end
                TheWorld.components.fwd_in_pdt_func:Throw_Out_Items({
                    target = player,
                    name = "nightmarefuel",
                    num = math.random(3,8),    -- default
                    range = 5, -- default
                    height = 3,-- default
                })
            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 13 : 生成6只大影怪
        {
            id = 13,
            weight = 1,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 9,
                    num = 6,
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab("fused_shadeling")
                            monster.Transform:SetPosition(pt.x,0,pt.z)
                            monster:DoTaskInTime(0.5,function()
                                monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                            end)
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 14 : 出现随机boss其中一只击败后掉落玉龙币*10
        {
            id = 14,
            weight = 1,
            fn = function(inst,player)
                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                local boss_list = {"bearger","deerclops","spiderqueen","warglet","warg","gingerbreadwarg","spat"}
                local ret_boss_prefab = boss_list[math.random(#boss_list)]
                local boss = SpawnPrefab(ret_boss_prefab)                
                boss.Transform:SetPosition(pt.x,0,pt.z)
                if boss.components.lootdropper then
                    local loots = boss.components.lootdropper.loot or {}
                    for i = 1, 10, 1 do
                        table.insert(loots,"fwd_in_pdt_item_jade_coin_green")
                        boss.components.lootdropper.loot = loots
                    end
                end
                boss:DoTaskInTime(0.5,function()
                    boss.components.combat:SuggestTarget(boss:GetNearestPlayer(true))
                end)
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 15 : 所有人变1血。并出现一只BOSS，击败后恢复血量。
        {
            id = 15,
            weight = 1,
            fn = function(inst,player)
                local x,y,z = inst.Transform:GetWorldPosition()
                local players = TheSim:FindEntities(x, y, z,20, {"player"}, {"playerghost"},nil)
                for k, temp_player in pairs(players) do
                    if temp_player.components.health then
                        temp_player.components.health.currenthealth = 2
                    end
                    if temp_player.components.combat then
                        temp_player.components.combat:GetAttacked(inst,1)
                    end
                end
                inst:DoTaskInTime(2,function()
                        local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                        SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                        local boss_list = {"bearger","deerclops","spiderqueen","warglet","warg","gingerbreadwarg","spat"}
                        local ret_boss_prefab = boss_list[math.random(#boss_list)]
                        local boss = SpawnPrefab(ret_boss_prefab)                
                        boss.Transform:SetPosition(pt.x,0,pt.z)
                        boss:DoTaskInTime(0.5,function()
                            boss.components.combat:SuggestTarget(boss:GetNearestPlayer(true))
                        end)
                        boss:ListenForEvent("death",function()
                            local surround_players = TheSim:FindEntities(x, y, z,20, {"player"}, {"playerghost"},nil)
                            for k, temp_player in pairs(surround_players) do
                                if temp_player.components.health then
                                    temp_player.components.health.currenthealth = 10
                                end
                                if temp_player.components.combat then
                                    temp_player.components.combat:GetAttacked(inst,1)
                                end
                                if temp_player.components.health then
                                    temp_player.components.health:SetPercent(1)
                                end
                            end
                        end)
                end)
                

            end
        },
    ------------------------------------------------------------------------------------------
    ------ 16 : 被冻住持续降低温度1min，降低温度30摄氏度
        {
            id = 16,
            weight = 1,
            fn = function(inst,player)
                if player.components.freezable and not player.components.freezable:IsFrozen() then
                    player.components.freezable:Freeze(60)
                end
                if player.components.temperature then
                    player.components.temperature:DoDelta(-30)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 17 : 天降青蛙
        {
            id = 17,
            weight = 1,
            fn = function(inst,player)
                        local function SpawnFrog(spawn_point)
                            local frog = SpawnPrefab("frog")
                            frog.persists = false
                            if math.random() < .5 then
                                frog.Transform:SetRotation(180)
                            end
                            frog.sg:GoToState("fall")
                            frog.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
                            return frog
                        end

                for i = 1, 30, 1 do
                    inst:DoTaskInTime(i-1,function()
                        local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(12))
                        local frog = SpawnFrog(pt)
                        if frog then
                            frog:DoTaskInTime(5,function()
                                frog.components.combat:SuggestTarget(frog:GetNearestPlayer(true))     
                            end)
                        end
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 18 : 生成礼包，内含：咖啡*10、糖豆*10
        {
            id = 18,
            weight = 1,
            fn = function(inst,player)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.coffee"],
                                inspect_str =  GetStringsTable()["gift_box.coffee"],
                                items = {
                                            {"fwd_in_pdt_plant_coffeebush_item",math.random(3)},
                                            {"fwd_in_pdt_food_coffee",math.random(3,8)},
                                            {"fwd_in_pdt_food_coffeebeans",math.random(15,30)},
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 19 : 疯猪 4-8 个
        {
            id = 19,
            weight = 1,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 9,
                    num = math.random(4,8),
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab("pigman")
                            monster.Transform:SetPosition(pt.x,0,pt.z)
                            monster:DoTaskInTime(0.5,function()
                                if monster.components.werebeast then
                                    monster.components.werebeast:SetWere(480)
                                end
                                monster:DoTaskInTime(2,function()
                                    monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                                end)
                            end)
                            
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 20 : 生成礼包，内含：铥矿*10、活木*10、铥矿头*1、铥矿甲*1
        {
            id = 20,
            weight = 1,
            fn = function(inst,player)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.ruins"],
                                inspect_str =  GetStringsTable()["gift_box.ruins"],
                                items = {
                                            {"thulecite",math.random(8,15)},
                                            {"thulecite_pieces",math.random(3,8)},
                                            {"ruins_bat",1},
                                            {"ruinshat",1},
                                            {"armorruins",1},
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 21 : 附近生成 3-8 个远古科技塔
        {
            id = 21,
            weight = 1,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 10,
                    num = math.random(3,8),
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab(math.random(100)<30 and "ancient_altar" or "ancient_altar_broken")
                            monster.Transform:SetPosition(pt.x,0,pt.z)                            
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 22 : 生成礼包，内含：2 - 8 个 建造护符
        {
            id = 22,
            weight = 1,
            fn = function(inst,player)
                local num = math.random(2,8)
                local  items = {}
                for i = 1, num, 1 do
                    table.insert(items,{"greenamulet",1})
                end

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.greenamulet"],
                                inspect_str =  GetStringsTable()["gift_box.greenamulet"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 23 : 生成礼包，内含：2 - 8 个 眼球塔
        {
            id = 23,
            weight = 1,
            fn = function(inst,player)
                local num = math.random(2,8)
                local  items = {}
                for i = 1, num, 1 do
                    table.insert(items,{"eyeturret_item",1})
                end

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.eyeturret_item"],
                                inspect_str =  GetStringsTable()["gift_box.eyeturret_item"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 24 : 生成礼包，内含：2 - 8 个 红宝石项链
        {
            id = 24,
            weight = 3,
            fn = function(inst,player)
                local num = math.random(2,8)
                local  items = {}
                for i = 1, num, 1 do
                    table.insert(items,{"amulet",1})
                end

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.amulet"],
                                inspect_str =  GetStringsTable()["gift_box.amulet"],
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 25 : 生成礼包，内含：各种宝石
        {
            id = 25,
            weight = 5,
            fn = function(inst,player)

                local pt = TheWorld.components.fwd_in_pdt_func:GetSpawnPoint(inst,math.random(10))
                SpawnPrefab("fwd_in_pdt_fx_sky_door"):PushEvent("Set",{
                    pt = Vector3(pt.x,pt.y+1,pt.z),
                    scale = Vector3(2.5,1,2.5)
                })
                inst:DoTaskInTime(3,function()
                    
                            local gift_pack = SpawnPrefab("fwd_in_pdt_gift_pack")
                            local skin_num = tostring(math.random(12))
                            gift_pack:PushEvent("Set",{
                                name = GetStringsTable()["gift_box.gems"],
                                inspect_str =  GetStringsTable()["gift_box.gems"],
                                items = {
                                    {"redgem",math.random(3)},
                                    {"orangegem",math.random(3)},
                                    {"yellowgem",math.random(3)},
                                    {"greengem",math.random(3)},
                                    {"bluegem",math.random(3)},
                                    {"purplegem",math.random(3)},
                                    {"opalpreciousgem",1},
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
                            gift_pack.Transform:SetPosition(pt.x,8,pt.z)
                end)

            end,
        },
    ------------------------------------------------------------------------------------------
    ------ 26 : 生成 4 - 12 只牛
        {
            id = 26,
            weight = 3,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 9,
                    num = math.random(4,12),
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab("beefalo")
                            monster.Transform:SetPosition(pt.x,0,pt.z)
                            monster:DoTaskInTime(0.5,function()
                                monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                            end)
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
    ------ 27 : 生成 4 - 12 只 大象
        {
            id = 27,
            weight = 3,
            fn = function(inst,player)
                local locations = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
                    target = inst,
                    range = 9,
                    num = math.random(4,12),
                })
                for i, pt in pairs(locations) do
                    inst:DoTaskInTime(i-1,function()
                            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt})
                            local monster = SpawnPrefab(math.random(100) < 70 and "koalefant_summer" or "koalefant_winter")
                            monster.Transform:SetPosition(pt.x,0,pt.z)
                            monster:DoTaskInTime(0.5,function()
                                monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                            end)
                    end)
                end
            end
        },
    ------------------------------------------------------------------------------------------
}


-----------------------------------------------------------------------------------------------------------------------------------------
local function machine_selected_task_start(inst,player,id)
    if id == nil then
        --- 随机事件
                local event_fns = {}
                for kk, temp in pairs(events) do
                    local weight = temp.weight or 1
                    for i = 1, weight, 1 do
                        table.insert(event_fns,temp.fn)
                    end
                end
                local ret_fn = event_fns[math.random(#event_fns)]
                if type(ret_fn) == "function" then
                    ret_fn(inst,player)
                end
    else
        --- 指定事件。给调试事件的时候留着用
        for k, temp in pairs(events) do
            if temp and temp.id == id then
                pcall(temp.fn,inst,player)
                -- temp.fn(inst,player)
                break
            end
        end

    end
end
-----------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(3,function()
        if ThePlayer and ThePlayer.HUD then
            ThePlayer:ListenForEvent("doll_clamping_machine_start",function()
                ThePlayer.HUD:fwd_in_pdt_doll_clamping_machine_open()
            end)
        end
    end)

    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("doll_clamping_machine_selected",function(_,id)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 12,{"fwd_in_pdt_building_doll_clamping_machine"})
        if #ents == 0 then
            return
        end
        local machine = ents[1]
        if machine then
            machine_selected_task_start(machine,inst,id)
        end
    end)

end)







