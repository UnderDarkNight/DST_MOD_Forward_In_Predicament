--------------------------------------------------------------------------
-- 道具
-- 《丰收之书》
--------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_book_of_harvest"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_book_of_harvest.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_book_of_harvest.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_book_of_harvest.xml" ),
}

local function BookFn(inst,reader)      -- 采摘
    local pt = Vector3(reader.Transform:GetWorldPosition())
    -- grass  sapling
    --- 5x5 地皮， 长宽 20x20 ， 对角距离 22.82 ，半径 以 12

    local prefab_names = {

        ---官方原有的作物
        ["grass"] = true,                            --- 草
        ["sapling"] = true,                          --- 树枝
        ["rock_avocado_bush"] = true,                --- 石果树
        ["berrybush"] = true,                        --- 浆果
        ["berrybush2"] = true,                       --- 浆果
        ["reeds"] = true,                            --- 芦苇
        ["bananabush"] = true,                       --- 香蕉丛
        ["monkeytail"] = true,                       --- 猴尾草
        ["flower_cave"] = true,                      --- 荧光果1
        ["flower_cave_double"] = true,               --- 荧光果2
        ["flower_cave_triple"] = true,               --- 荧光果3
        --["mushroom_farm"] = true,                    --- 蘑菇农场（不行，估计也是采收动作的原因）


        ---官方的农田作物（注意不是prefab名字）
        ["farm_plant_asparagus"] = true,             --- 芦笋植株
        ["farm_plant_carrot"] = true,                --- 胡萝卜植株
        ["farm_plant_corn"] = true,                  --- 玉米植株
        ["farm_plant_eggplant"] = true,              --- 茄子植株
        ["farm_plant_garlic"] = true,                --- 大蒜植株
        ["farm_plant_onion"] = true,                 --- 洋葱植株
        ["farm_plant_pepper"] = true,                --- 辣椒植株
        ["farm_plant_potato"] = true,                --- 土豆植株
        ["farm_plant_pumpkin"] = true,               --- 南瓜植株
        ["farm_plant_tomato"] = true,                --- 番茄植株
        ["farm_plant_dragonfruit"] = true,           --- 火龙果植株
        ["farm_plant_durian"] = true,                --- 榴莲植株
        ["farm_plant_pomegranate"] = true,           --- 石榴植株
        ["farm_plant_watermelon"] = true,            --- 西瓜植株

        ---负重作物
        ["fwd_in_pdt_plant_paddy_rice"] = true,                 --- 稻米
        ["fwd_in_pdt_plant_wheat"] = true,                      --- 小麦
        ["fwd_in_pdt_plant_atractylodes_macrocephala"] = true,  --- 苍术
        ["fwd_in_pdt_plant_pinellia_ternata"] = true,           --- 半夏
        ["fwd_in_pdt_plant_aster_tataricus_l_f"] = true,        --- 紫苑
        ["fwd_in_pdt_plant_orange"] = true,                     --- 橙子树
        ["fwd_in_pdt_plant_bean"] = true,                       --- 大豆植株
        ["fwd_in_pdt_coffeebush"] = true,                       --- 咖啡丛

        ---这里是和勋章兼容
        ["farm_plant_medal_gift_fruit"] = true,                 --- 包果植株
        ["farm_plant_immortal_fruit"] = true,                   --- 不朽果实植株

        ---这里是和棱镜兼容
        ["farm_plant_pineananas"] = true,                       --- 松萝植株
        ["lilybush"] = true,                                    --- 蹄莲花丛
        ["orchidbush"] = true,                                  --- 兰草花丛
        ["rosebush"] = true,                                    --- 蔷薇花丛

        ---这里是和山海兼容

        ---这里是和富贵兼容
        ["ndnr_coffeebush"] = true,                             --- 咖啡树

        ---这里是和海传的兼容
        ["lg_lemon_tree"] = true,                               --- 柠檬树
        ["lg_shumei_tree"] = true,                              --- 树莓树
        ["lg_litchi_tree"] = true,                              --- 荔枝树
        ["farm_plant_lg_putao"] = true,                         --- 葡萄植株
        ["farm_plant_lg_mangguo"] = true,                       --- 芒果植株
        ["lg_sunny"] = true,                                    --- 向日葵
        ["lg_xiaomai_plant"] = true,                            --- 小麦
    }
    local pick_num = 0

    local musthavetags = {"plant"}   
    -- local musthavetags = nil
    local canthavetags = {}
    local musthaveoneoftags = {}
    
    local ents = TheSim:FindEntities(pt.x, 0, pt.z, 12, musthavetags, canthavetags, musthaveoneoftags)
    for k, v in pairs(ents) do
        if v and prefab_names[v.prefab] and v.components.pickable and v.components.pickable:CanBePicked() then
            v.components.pickable:Pick(reader)
            pick_num = pick_num + 1
        end
    end  
    if pick_num > 0 then
        return true
    else
        return false
    end
end

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_book_of_harvest") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_book_of_harvest") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("bookcabinet_item") -- 能够放书架里

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    --- 图层覆盖，sg 的 fwd_in_pdt_read_book_type_cookbook 里面
        inst:ListenForEvent("reading_end",function()
            if inst.__reading_fx then
                inst.__reading_fx:Remove()
                inst.__reading_fx = nil
            end
        end)
        inst.read_book_onenter_fn = function(inst,player)
            player.AnimState:OverrideSymbol("book_cook", "fwd_in_pdt_item_book_of_harvest", "book_cook")
            player:DoTaskInTime(30*FRAMES,function()    
                local color = {
                    Vector3(255,0,0),
                    Vector3(0,255,0),
                    Vector3(0,0,255),
                    Vector3(255,255,0),
                    Vector3(255,0,255),
                    Vector3(0,255,255),
                    Vector3(255,255,255),
                }

                inst.__reading_fx =  player:SpawnChild("fwd_in_pdt_fx_knowledge_flash")
                inst.__reading_fx:PushEvent("Set",{
                    pt = Vector3(0,player.replica.rider:IsRiding() and 3 or 1,0),
                    color = color[math.random(#color)],
                })
            end)

        end
        inst.read_book_onexit_fn = function(inst,player)
            player.AnimState:ClearOverrideSymbol("book_cook")
        end
        inst.read_book_animover_fn = inst.read_book_onexit_fn
        --- 可移动打断
        inst.read_book_stopable = true

    --------------------------------------------------------------------------
    --- 失败通知组件
        -- inst:AddComponent("fwd_in_pdt_com_action_fail_reason")
    --------------------------------------------------------------------------
    -- 交互动作
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst:GetIsWet() then
                    return false
                end
                if not inst.replica.inventoryitem:IsGrandOwner(doer) then
                    return false
                end
                local sanity = doer.replica.sanity or doer.replica._.sanity
                if sanity and sanity:GetCurrent() <= 50 then
                    return false
                end
                return true
            end)
            replica_com:SetSGAction("fwd_in_pdt_read_book_type_cookbook")
            replica_com:SetText("fwd_in_pdt_item_book_of_harvest",STRINGS.ACTIONS.READ)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("fwd_in_pdt_com_workable")
            inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
                if doer then
                    if BookFn(inst, doer) then
                        if doer.components.sanity then
                            doer.components.sanity:DoDelta(-50)
                        end
                        inst.components.finiteuses:Use()
                        return true
                    end
                end
                if doer.components.fwd_in_pdt_com_action_fail_reason then
                    doer.components.fwd_in_pdt_com_action_fail_reason:Inser_Fail_Talk_Str(GetStringsTable()["action_fail"])
                end
                return false
            end)
        end
    --------------------------------------------------------------------------
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_book_of_harvest"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_book_of_harvest.xml"
    
    --------------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(50)
        inst.components.finiteuses:SetUses(50)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    --------------------------------------------------------------------------
    -- inst:AddComponent("stackable") -- 可堆叠
    -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    --------------------------------------------------------------------------
    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:Hide("SHADOW")
            else                                
                inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_item_book_of_harvest", fn, assets)