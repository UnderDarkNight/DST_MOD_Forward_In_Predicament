local assets = {

	Asset("ANIM", "anim/fwd_in_pdt_fx_catch_game_mark.zip"),
}
---------------------------------------------------------------------------------------------------------------------------------------------
--- 物品贴图
    local item_list = {
        "fossil_piece","feather_canary","dreadstone","thulecite","marblebean",
        "cutstone","transistor","moonstorm_static_item","lavae_egg_cracked",
        "beeswax","slurtleslime","shroom_skin","dragon_scales","spidergland","beefalowool",
        "voidcloth_scythe","staff_lunarplant","sword_lunarplant","houndstooth_blowpipe",
        "houndstooth_blowpipe","fence_rotator","oar_monkey","nightstick","glasscutter",
        "nightsword","ruins_bat","hambat","tentaclespike","trident","batbat","shadow_battleaxe",
        "voidcloth_boomerang","rabbitkinghorn","rabbitkingspear","dumbbell_gem","dumbbell_bluegem",
        "dumbbell_redgem","lunarplanthat","dreadstonehat","voidclothhat","wagpunkhat","scraphat",
        "cookiecutterhat","alterguardianhat","eyemaskhat","skeletonhat","hivehat","armorwagpunk",        
        "armor_voidcloth","armorsnurtleshell","armordragonfly","piggyback","krampus_sack","armor_sanity",
        "armormarble","armorwood","armor_bramble","spicepack","seedpouch","reflectivevest",
        "hawaiianshirt","monkey_mediumhat","carnival_vest_c","carnival_vest_b","carnival_vest_a",
        "armorslurper","antlionhat","rabbithat","mask_dollhat","mask_dollbrokenhat","mask_kinghat",
        "nightcaphat","mask_foolhat","costume_tree_body","mask_treehat","bodypillow_beefalowool",
        "shroomcake","shroombait","vegstinger","bananajuice","bunnystew","bonestew","meatballs",
        "kabobs","ceviche","fishtacos","californiaroll","fishsticks","seafoodgumbo","lobsterbisque",
        "hotchili","potatotornado","mashedpotatoes","sweettea","stuffedeggplant","salsa","guacamole",
        "monsterlasagna","jammypreserves","powcake","butterflymuffin","waffles","frozenbananadaiquiri",
        "frognewton","figkabab",
    }
    local image_data = {}
    local function GetImageData(prefab)
        if image_data[prefab] then
            return image_data[prefab][1],image_data[prefab][2]
        else
            local image_name = prefab..".tex"
            local atlas_name = GetInventoryItemAtlas(image_name)
            image_data[prefab] = {atlas_name,image_name}
            return atlas_name,image_name
        end
    end
    local function SetRandomImage(fx)
        local prefab = item_list[math.random(#item_list)]
        local atlas_name,image_name = GetImageData(prefab)
        if atlas_name and image_name and TheSim:AtlasContains(atlas_name,image_name) then
            fx.AnimState:OverrideSymbol("SWAP_SIGN",atlas_name,image_name)
        else
            fx.AnimState:OverrideSymbol("SWAP_SIGN","fwd_in_pdt_fx_catch_game_mark","red")
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------
---
    local function IsPlayerInspectacleSearching()
        return ThePlayer and ThePlayer.replica.inventory:EquipHasTag("fwd_in_pdt_com_inspectacle_searcher") or false
    end
    local function CreateGroundFx(parent)
        if not IsPlayerInspectacleSearching() then
            return
        end
        SetRandomImage(parent)

        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        parent:AddChild(inst)
        inst.AnimState:SetBank("fwd_in_pdt_fx_catch_game_mark")
        inst.AnimState:SetBuild("fwd_in_pdt_fx_catch_game_mark")
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:PlayAnimation("mark", false)
        inst.AnimState:SetFinalOffset(10)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.Transform:SetPosition(0,0.2,0)

        parent:DoPeriodicTask(FRAMES*2,function()
            if not IsPlayerInspectacleSearching() then
                inst:Hide()
                parent.AnimState:ClearOverrideSymbol("SWAP_SIGN")
            end
        end)

    end
---------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Setting(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     delay = 10,      --- seconds
        --     mult = 1,        --- 动画播放速度
        --     animover_fn = function(inst) end,
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        ---            
            inst:DoTaskInTime(_table.delay or 0,function()
                inst.AnimState:PlayAnimation("idle", false)
                inst.AnimState:SetDeltaTimeMultiplier(_table.mult or 1)
                if _table.animover_fn then
                    inst:ListenForEvent("animover",_table.animover_fn)
                end
            end)
        ------------------------------------------------------------------------------------------------------------------------------------
        inst.Ready = true
    end
    local function onload_checker(inst)
        if inst.Ready ~= true then
            inst:Remove()
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------
local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("fwd_in_pdt_fx_catch_game_mark")
    inst.AnimState:SetBuild("fwd_in_pdt_fx_catch_game_mark")
    -- inst.AnimState:PlayAnimation("puff_1", false)
    inst.AnimState:SetFinalOffset(10)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst:ListenForEvent("animover",inst.Remove)
    inst.entity:SetPristine()

    if not TheNet:IsDedicated() then
        CreateGroundFx(inst)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",Setting)

    inst:DoTaskInTime(0,onload_checker)

    return inst
end

return Prefab("fwd_in_pdt_fx_catch_game_mark",fx,assets)