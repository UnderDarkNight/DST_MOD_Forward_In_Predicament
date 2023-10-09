--------------------------------------------------------------------------
-- 道具
-- 《园艺之书》
--------------------------------------------------------------------------

local function GetStringsTable(name)
    local prefab_name = name or "fwd_in_pdt_item_book_of_gardening"
    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_book_of_gardening.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_book_of_gardening.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_book_of_gardening.xml" ),
}

local function spawn_flows(mid_pt,range,num)
    -- local flowers = {"flower","flower_rose","flower_evil"}
    local flower = "flower"
    local temp_propery = math.random(100)
    if temp_propery < 30 then
        flower = "flower_rose"
    end
    if temp_propery < 10 then
        flower = "flower_evil"
    end

    local points = TheWorld.components.fwd_in_pdt_func:GetSurroundPoints({
        target = mid_pt,
        range = range or 1,
        num = num or 3
    })
    for k, pt in pairs(points) do
        if pt and TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z,false) then
            SpawnPrefab(flower).Transform:SetPosition(pt.x,0, pt.z)
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{pt = pt , scale =  Vector3(0.3,0.3,0.3)})
        end
    end

end

local function BookFn(inst,reader)      -- 采摘
    local mid_pt = Vector3(reader.Transform:GetWorldPosition())

    local cmd_table = {
        {
            time = 0,
            range = 1,
            num = 3
        },
        {
            time = 1,
            range = 2.5,
            num = 6
        },
        {
            time = 2,
            range = 4,
            num = 10
        },
        {
            time = 3,
            range = 5.5,
            num = 15
        },
    }
    for k, temp_table in pairs(cmd_table) do
        reader:DoTaskInTime(temp_table.time or 0,function()
            spawn_flows(mid_pt, temp_table.range, temp_table.num)
        end)
    end





    return true
end

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_book_of_gardening") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_book_of_gardening") -- 材质包，就是anim里的zip包
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
            player.AnimState:OverrideSymbol("book_cook", "fwd_in_pdt_item_book_of_gardening", "book_cook")
            player:DoTaskInTime(30*FRAMES,function()               
                inst.__reading_fx =  player:SpawnChild("fwd_in_pdt_fx_knowledge_flash")
                inst.__reading_fx:PushEvent("Set",{
                    pt = Vector3(0,player.replica.rider:IsRiding() and 3 or 1,0),
                    color = Vector3(255,0,0)
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
        inst:AddComponent("fwd_in_pdt_com_workable")
        inst.components.fwd_in_pdt_com_workable:SetTestFn(function(inst,doer,right_click)
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
        inst.components.fwd_in_pdt_com_workable:SetOnWorkFn(function(inst,doer)
            if not TheWorld.ismastersim then
                return
            end
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
        inst.components.fwd_in_pdt_com_workable:SetSGAction("fwd_in_pdt_read_book_type_cookbook")
        inst.components.fwd_in_pdt_com_workable:SetActionDisplayStr("fwd_in_pdt_item_book_of_gardening",STRINGS.ACTIONS.READ)
    --------------------------------------------------------------------------
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_book_of_gardening"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_book_of_gardening.xml"
    
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

return Prefab("fwd_in_pdt_item_book_of_gardening", fn, assets)