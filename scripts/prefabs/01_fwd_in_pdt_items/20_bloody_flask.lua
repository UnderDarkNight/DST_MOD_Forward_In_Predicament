--------------------------------------------------------------------------
-- 道具
-- 卡尔收藏的血瓶
--------------------------------------------------------------------------

-- local function GetStringsTable(name)
--     local prefab_name = name or "fwd_in_pdt_item_glass_horn"
--     local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
--     return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
-- end

local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_bloody_flask.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_bloody_flask.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_bloody_flask.xml" ),
}


local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.AnimState:SetBank("fwd_in_pdt_item_bloody_flask") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_bloody_flask") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    local scale = 1.5
    inst.Transform:SetScale(scale,scale,scale)
    
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst:AddTag("fwd_in_pdt_item_bloody_flask")

    inst.entity:SetPristine()
    -- ------------------------------------------------------------------------
    -- --- 动作（这个会导致排队论失效，没办法所以 我用eater）
    --     inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_workable",function(inst,replica_com)
    --         replica_com:SetTestFn(function(inst,doer,right_click)
    --             return doer and doer.prefab == "fwd_in_pdt_carl" and inst.replica.inventoryitem:IsGrandOwner(doer)                
    --         end)
    --         -- replica_com:SetSGAction("fwd_in_pdt_special_eat")
    --         replica_com:SetSGAction("fwd_in_pdt_special_quick_eat")
    --         replica_com:SetText("fwd_in_pdt_item_bloody_flask",STRINGS.ACTIONS.EAT)
    --     end)
    --     if TheWorld.ismastersim then
    --         inst:AddComponent("fwd_in_pdt_com_workable")
    --         inst.components.fwd_in_pdt_com_workable:SetActiveFn(function(inst,doer)
    --             if inst.components.stackable then
    --                 inst.components.stackable:Get():Remove()
    --             else
    --                 inst:Remove()
    --             end
    
    --             if doer.components.health then
    --                 doer.components.health:DoDelta(50,nil,inst.prefab)
    --             end
    
    --             return true
    --         end)
    --     end
    ------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible") -- 可食物组件
    -- inst.components.edible.foodtype = FOODTYPE.ROUGHAGE  -- 牛食物
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if eater and eater:HasTag("fwd_in_pdt_carl") then
            if eater.components.health then
                eater.components.health:DoDelta(50,nil,inst.prefab)
            end
        end
    end)
    -- inst.components.edible.hungervalue = 0
    -- inst.components.edible.sanityvalue = 0
    -- inst.components.edible.healthvalue = 0
    --------------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_data")
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_bloody_flask"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_bloody_flask.xml"
    inst:AddComponent("stackable") -- 可堆叠
    -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst.components.stackable:SetIgnoreMaxSize(true)
    
    MakeHauntableLaunch(inst)

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
    ---- 血瓶爆炸
        inst:ListenForEvent("explode",function()
            ------------------------------------------------------------------
                    local stack_num = inst.components.stackable.stacksize
                    local x,y,z = inst.Transform:GetWorldPosition()
            ------------------------------------------------------------------
            ---- 造成伤害
                local canthavetags = { "companion","isdead","player","INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" ,"chester","hutch","wall","structure"}
                local musthavetags = nil
                local musthaveoneoftags = {"pig","rabbit","animal","smallcreature","epic","monster","insect"}
                local ents = TheSim:FindEntities(x, y, z, 3, musthavetags, canthavetags, musthaveoneoftags)
                for k, temp_target in pairs(ents) do
                    if temp_target and temp_target:IsValid() and temp_target.components.health then
                        temp_target.components.health:DoDelta(-30*stack_num)  --- 伤害
                    end
                end
            ------------------------------------------------------------------
            ---- 造成回血
                local around_players = TheSim:FindEntities(x, y, z, 4, nil, {"playerghost","isdead","INLIMBO"}, {"player","companion"})
                for k, temp_target in pairs(around_players) do
                    if temp_target and temp_target:IsValid() and temp_target.components.health then
                        if temp_target.prefab == "fwd_in_pdt_carl" then
                            temp_target.components.health:DoDelta(20*stack_num)  --- 回复
                        else
                            temp_target.components.health:DoDelta(10*stack_num)  --- 回复
                        end
                    end
                end
            ------------------------------------------------------------------
            ---- 特效和移除
                local fx = SpawnPrefab("fwd_in_pdt_fx_explode")
                fx:PushEvent("Set",{
                    pt = Vector3(x,y,z),
                    color = Vector3(255,0,0),
                    MultColour_Flag = true,
                    sound = "dontstarve/common/together/fire_cracker",
                })
                inst:Remove()
            ------------------------------------------------------------------
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("picked") ~= true then
                inst.__explode_task = inst:DoTaskInTime(math.random(8,15),function()
                    inst:PushEvent("explode")                    
                end)
            end
        end)
        inst:ListenForEvent("onpickup",function()
            inst.components.fwd_in_pdt_data:Set("picked",true)
            if inst.__explode_task then
                inst.__explode_task:Cancel()
            end
        end)
        inst:ListenForEvent("ondropped",function()
            inst.components.fwd_in_pdt_data:Set("picked",false)
            if inst.__explode_task then
                inst.__explode_task:Cancel()
            end
            inst.__explode_task = inst:DoTaskInTime(math.random(8,15),function()
                inst:PushEvent("explode")                    
            end)
        end)
    -------------------------------------------------------------------

    return inst
end

--- 设置可以放烹饪锅里，1单位不可食用度
AddIngredientValues({"fwd_in_pdt_item_bloody_flask"}, { 
    inedible = 1,
})
return Prefab("fwd_in_pdt_item_bloody_flask", fn, assets)