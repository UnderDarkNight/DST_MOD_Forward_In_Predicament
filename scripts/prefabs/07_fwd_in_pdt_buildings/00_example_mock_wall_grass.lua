----------------------------------------------------------------------------------------------------------------------------------------------
-- 说明：
-- 如果物品有图标切换，需要使用 inst.components.inventoryitem:fwd_in_pdt_icon_init("gift_large2") 进行图标初始化。
-- inst.components.inventoryitem:fwd_in_pdt_icon_init("gift_large2") 或者 inventoryitem:fwd_in_pdt_icon_init(tex,atlas)
-- 
-- 如果有名字组件的切换，则需要  inst:AddComponent("named"):SetName_fwd_in_pdt("拟态墙·草") 初始化名字
-- 
----------------------------------------------------------------------------------------------------------------------------------------------
local function GetStringsTable()
    local prefab_name = "fwd_in_pdt_building_mock_wall_grass"
    return TUNING["Forward_In_Predicament.fn"].GetStringsTable(prefab_name)
end

----------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------
---- 皮肤API 套件
    --- 建筑用的skin 数据
    local skins_data_grass = {
        ["fwd_in_pdt_building_mock_wall_grass_monkeytail"] = {             --- 皮肤名字，全局唯一。
            bank = "grass",                   --- 制作完成后切换的 bank
            build = "reeds_monkeytails",                  --- 制作完成后切换的 build
            name = "拟态墙·猴尾草",                    --- 【制作栏】皮肤的名字
            skin_link = "fwd_in_pdt_building_mock_wall_item_monkeytail",              --- 链接对象，解锁其中一个，顺便解锁另一个。为的是同步解锁。
        },

        ["fwd_in_pdt_building_mock_wall_grass_reeds"] = {                    --- 
            bank = "grass",
            build = "reeds",
            name = "拟态墙·芦苇",        --- 切名字用的
            skin_link = "fwd_in_pdt_building_mock_wall_item_reeds"               --- 链接对象，解锁其中一个，顺便解锁另一个。为的是同步解锁。                
        }

    }
    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_grass,"fwd_in_pdt_building_mock_wall_grass")     --- 往总表注册所有皮肤


    ---- 物品用的skin数据
    local skins_data_item = {
        ["fwd_in_pdt_building_mock_wall_item_monkeytail"] = {             --- 皮肤名字，全局唯一。
            bank = "grass",                   --- 制作完成后切换的 bank
            build = "reeds_monkeytails",                  --- 制作完成后切换的 build
            atlas = "images/inventoryimages1.xml",   --- 【制作栏】皮肤显示的贴图，
            image = "dug_monkeytail",      --- 【制作栏】皮肤显示的贴图， 不需要 .tex
            name = "拟态墙·猴尾草",                    --- 【制作栏】皮肤的名字
            placed_skin_name = "fwd_in_pdt_building_mock_wall_grass_monkeytail",   --  给 inst.components.deployable.ondeploy  里生成切换用的
            skin_link = "fwd_in_pdt_building_mock_wall_grass_monkeytail"               --- 链接对象，解锁其中一个，顺便解锁另一个。为的是同步解锁。                
        },
        ["fwd_in_pdt_building_mock_wall_item_reeds"] = {                    --- 
            bank = "grass",
            build = "reeds",
            atlas = "images/inventoryimages1.xml",
            image = "cutreeds",            -- 不需要 .tex
            name = "拟态墙·芦苇",        --- 切名字用的
            placed_skin_name = "fwd_in_pdt_building_mock_wall_grass_reeds",        --  给 inst.components.deployable.ondeploy  里生成切换用的
            skin_link = "fwd_in_pdt_building_mock_wall_grass_reeds"               --- 链接对象，解锁其中一个，顺便解锁另一个。为的是同步解锁。
        }

    }

    FWD_IN_PDT_MOD_SKIN.SKIN_INIT(skins_data_item,"fwd_in_pdt_building_mock_wall_grass_item")     --- 往总表注册所有皮肤

    local function Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)      -- 在 inst.AnimState:PlayAnimation() 前启用本函数
        FWD_IN_PDT_MOD_SKIN.Set_ReSkin_API_Default_Animate(inst,bank,build,minimap)
    end
          
-------------------------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------------------------------------
-------- 墙
local function wall_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState() --V2C: need this even if we are door, for mouseover sorting
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- inst.Transform:SetEightFaced()

    MakeObstaclePhysics(inst, .5)
    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("wall")
    inst:AddTag("alignwall")
    inst:AddTag("noauradamage")
    inst:AddTag("structure")

    -- inst.AnimState:SetBank("grass")
    -- inst.AnimState:SetBuild("grass1")

    Set_ReSkin_API_Default_Animate(inst,"grass","grass1")
    -- inst.AnimState:PushAnimation("idle", true)
    inst.AnimState:PlayAnimation("idle", true)
    -----------------------------------------------------------------------
    inst.entity:SetPristine()
    -----------------------------------------------------------------------
    -----------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    ---------------------------------------------------------------------------------------------------------
    inst:AddComponent("named"):SetName_fwd_in_pdt("拟态墙·草")
    ---------------------------------------------------------------------------------------------------------
    ---- 只能被玩家敲掉
    inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(_,worker)
            SpawnPrefab("fwd_in_pdt_fx_collapse"):PushEvent("Set",{
                pt = Vector3(inst.Transform:GetWorldPosition()),
                type = "small",
            })
            inst:Remove()
        end)

        inst.components.workable.WorkedBy__fwd_in_pdt_old = inst.components.workable.WorkedBy
        inst.components.workable.WorkedBy = function(self,worker,...)
            if worker and worker:HasTag("player") then
                return self:WorkedBy__fwd_in_pdt_old(worker,...)
            end
        end
    ---------------------------------------------------------------------------------------------------------
    inst:AddComponent("fwd_in_pdt_func"):Init("skin")
    inst.components.fwd_in_pdt_func:SkinAPI_AddMirror()

    ---------------------------------------------------------------------------------------------------------

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------
---- 物品

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    -- inst.AnimState:SetBank("grass")
    -- inst.AnimState:SetBuild("grass1")
    Set_ReSkin_API_Default_Animate(inst,"grass","grass1")
    inst.AnimState:PlayAnimation("idle",true)

    MakeInventoryFloatable(inst, "small", nil, 1.1)

    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("named"):SetName_fwd_in_pdt("拟态墙·草")

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)
    inst.components.inventoryitem:fwd_in_pdt_icon_init("dug_grass")
    --- 显示的名字在 添加到制作栏的时候整了，不用再加组件了

    inst:AddComponent("fwd_in_pdt_func"):Init("skin")


    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
    inst.components.deployable.ondeploy = function(inst, pt, deployer, rot )
        local wall = SpawnPrefab("fwd_in_pdt_building_mock_wall_grass")   --- 生成结果

        if wall ~= nil then
            inst.components.fwd_in_pdt_func:SkinAPI__DeployItem(wall)            

            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5

            wall.Physics:SetCollides(false)
            wall.Physics:Teleport(x, 0, z)
            wall.Physics:SetCollides(true)
            inst.components.stackable:Get():Remove()

            wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")

        end        
    end

    MakeHauntableLaunch(inst)
    return inst
end

----------------------------------------------------------------------------------------------------------------------------------------------
local function placer_postinit_fn(inst)
    
end
----------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_building_mock_wall_grass", wall_fn),
          Prefab("fwd_in_pdt_building_mock_wall_grass_item",itemfn),
            MakePlacer("fwd_in_pdt_building_mock_wall_grass_item_placer", "grass", "grass1", "idle",nil, nil, true, nil, nil, nil, placer_postinit_fn)

-- function MakePlacer(name, bank, build, anim, onground, snap, metersnap, scale, fixedcameraoffset, facing, postinit_fn, offset, onfailedplacement)
-- metersnap -- 去某个基点
