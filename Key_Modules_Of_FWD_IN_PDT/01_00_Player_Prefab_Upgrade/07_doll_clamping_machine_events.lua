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
    ------ 5s内清空饱食度
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
    ------ 人物周围召唤10个桦树树精
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
    ------ 周围生成N个蜗牛粘液，并燃烧爆炸.同时生成睡眠烟雾
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
    ------ 生成礼物包，内含：雄黄饮剂 x2，万能解毒剂 x2，胰岛素针x2，蜂蜜膏药X2，强心针X2，治疗膏药X2
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
    ------ 各大BOSS掉落材料里，抽选 9 个进背包
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
    ------ 生成礼包，内含：玻璃x10，月岩x10，亮茄道具（武器、装备、者材料X10 中的一个）
        {
            id = 5,
            weight = 1,
            fn = function(inst,player)


                local items = {
                    {"moonglass",10},
                    {"moonrocknugget",10},
                }
                

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
                temp.fn(inst,player)
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
        local ents = TheSim:FindEntities(x, y, z, 10,{"fwd_in_pdt_building_doll_clamping_machine"})
        if #ents == 0 then
            return
        end
        local machine = ents[1]
        if machine then
            machine_selected_task_start(machine,inst,id)
        end
    end)

end)







