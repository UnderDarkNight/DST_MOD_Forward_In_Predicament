--------------------------------------------------------------------------
--- 道具
--- 压缩气旋
--------------------------------------------------------------------------



local assets = {
    Asset("ANIM", "anim/fwd_in_pdt_item_compressed_cyclone.zip"), 
    Asset( "IMAGE", "images/inventoryimages/fwd_in_pdt_item_compressed_cyclone.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/fwd_in_pdt_item_compressed_cyclone.xml" ),
}

local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_item_compressed_cyclone") -- 地上动画
    inst.AnimState:SetBuild("fwd_in_pdt_item_compressed_cyclone") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "fwd_in_pdt_item_compressed_cyclone"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_compressed_cyclone.xml"

    --------------------------------------------------------------------------




        inst:AddComponent("stackable") -- 可堆叠
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
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
    --- 物品栏图标
        inst:AddComponent("fwd_in_pdt_func"):Init("item_tile_fx")
        -- local r,g,b,a = 157/255 , 86/255 ,126/255 , 200/255
        -- local r,g,b,a = 209/255 , 127/255 ,170/255 , 200/255
        inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
            bank = "fwd_in_pdt_item_compressed_cyclone",
            build = "fwd_in_pdt_item_compressed_cyclone",
            anim = "icon",
            hide_image = true,
            -- text = {
            --     -- color = {r,g,b,1},
            --     pt = Vector3(-14,16,0),
            --     -- size = 35,
            -- }
        })
    -------------------------------------------------------------------
    ---- 
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(0)
    -------------------------------------------------------------------
    --- 制造范围伤害
        local function get_aoe_damage_targets(pt,range)
            range = range or 5
            local musthavetags = { "_combat" }
            local canthavetags = { "INLIMBO", "notarget", "noattack", "invisible", "wall", "player", "companion" }
            local musthaveoneoftags = {}
            local ents = TheSim:FindEntities(pt.x, 0, pt.z, range, musthavetags, canthavetags, musthaveoneoftags)
            local ret_aoe_target = {}
            for k, temp in pairs(ents) do
                if temp and temp:IsValid() and temp.components.combat and temp.components.health then
                    table.insert(ret_aoe_target, temp)
                end
            end
            return ret_aoe_target
        end
    -------------------------------------------------------------------
    ---- 计时器引爆
        inst:ListenForEvent("fwd_in_pdt_com_time_stopper_end",function(inst)
            print("info fwd_in_pdt_com_time_stopper_end",inst)
            inst:DoTaskInTime(1,function()  --- 延时一下

                if inst.components.inventoryitem:IsHeld() then  ---- 在容器里，或者玩家身上，则不引爆
                    return
                end
                local pt = Vector3(inst.Transform:GetWorldPosition())

                SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                    pt = pt,
                })
                local aoe_targets = get_aoe_damage_targets(pt,6)
                if #aoe_targets == 0 then
                    return
                end


                local stack_num = inst.components.stackable:StackSize()
                local damage = stack_num*1000
                inst.components.planardamage:SetBaseDamage(damage)

                for k,temp_monster in pairs(aoe_targets) do
                    pcall(function()
                        temp_monster.components.combat:GetAttacked(temp_monster:GetNearestPlayer(),damage,inst)
                    end)
                end
                inst:Remove()
            end)
        end)
    -------------------------------------------------------------------
    ---- 特效
        inst:ListenForEvent("fwd_in_pdt_com_time_stopper_start",function(inst)
            if inst.components.inventoryitem:IsHeld() then  ---- 在容器里，或者玩家身上，则不引爆
                return
            end
            if inst.fx then
                inst.fx:Remove()                
            end
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.fx = SpawnPrefab("fwd_in_pdt_fx_dotted_circle")
            inst.fx:PushEvent("Set",{
                pt = Vector3(x,0,z),
                range = 6,
            })
            inst.fx:ListenForEvent("onremove",function()
                inst.fx:Remove()
            end,inst)
        end)
        inst:ListenForEvent("onputininventory",function(inst)
            if inst.fx then
                inst.fx:Remove()
                inst.fx = nil
            end
        end)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("fwd_in_pdt_item_compressed_cyclone", fn, assets)