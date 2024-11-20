local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_item_book_of_life_and_death.zip"),
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- item use to 模块
    local function item_use_2_com_install(inst)
        inst:ListenForEvent("fwd_in_pdt_event.OnEntityReplicated.fwd_in_pdt_com_item_use_to",function(inst,replica_com)

            replica_com:SetTestFn(function(inst,target,doer,right_click)
                if right_click and target ~= doer and target:HasTag("_combat") then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("fwd_in_pdt_read_book")
            replica_com:SetDistance(20)
            replica_com:SetText("fwd_in_pdt_item_book_of_life_and_death","审判")
        end)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fwd_in_pdt_com_item_use_to")
        inst.components.fwd_in_pdt_com_item_use_to:SetActiveFn(function(inst,target,doer)
            doer.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
            if target and target:IsValid() then
                --- 如果是玩家，则复活玩家
                if target:HasTag("player") and target:HasTag("playerghost") then
                    target:PushEvent("respawnfromghost", { source = inst })
                    return true
                end
                --- 如果不是玩家，则直接想办法弄死。
                if target.components.combat and target.components.health then
                    -- 创建个任务实体，检测到 最小血量之前，一直造成伤害
                    local task_inst = CreateEntity()
                    task_inst:ListenForEvent("minhealth",function()
                        task_inst:Remove()
                    end,target)
                    task_inst._task = task_inst:DoPeriodicTask(0.2,function()
                        target.components.combat:GetAttacked(doer,5000000)
                        ---- 为了避免某些极端情况下 无法 造成击杀 永远死循环导致游戏卡顿，做上限处理。
                        task_inst.__task_num = (task_inst.__task_num or 0) + 1
                        if task_inst.__task_num >= 100 then
                            task_inst:Remove()
                        end
                    end)
                    return true
                end
            end
            return false
        end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 书本相关模块
    local function read_book_onenter_fn(inst,player) -- sg 里调取的


        player.AnimState:OverrideSymbol("book_open", "fwd_in_pdt_item_book_of_life_and_death", "book_open")
        player.AnimState:OverrideSymbol("book_closed", "fwd_in_pdt_item_book_of_life_and_death", "book_closed")

        -------------------------------------------------------------
        -- 围绕书本的特效圈圈
            local reading_fx_prefab = "book_fx"
            if player.components.rider:IsRiding() then
                reading_fx_prefab = "book_fx_mount"
            end
            local book_fx = SpawnPrefab(reading_fx_prefab)
            book_fx.entity:SetParent(player.entity)
            player.sg.statemem.book_fx = book_fx
        -------------------------------------------------------------
        local t = player.AnimState:GetCurrentAnimationNumFrames()
        player.sg.statemem.book_fx.AnimState:SetFrame(t + 6)

        player.SoundEmitter:PlaySound("dontstarve/common/use_book_light") -- 翻书声音


    end
    local function book_module_install(inst)
        -- inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
        -- inst.sound = "dontstarve/common/together/celestial_orb/active"
        inst.read_book_onenter_fn = read_book_onenter_fn
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fwd_in_pdt_item_book_of_life_and_death")
    inst.AnimState:SetBuild("fwd_in_pdt_item_book_of_life_and_death")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("fwd_in_pdt_tag.cursor_sight")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    item_use_2_com_install(inst)
    book_module_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("alterguardianhatshard")
    inst.components.inventoryitem.imagename = "fwd_in_pdt_item_book_of_life_and_death"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fwd_in_pdt_item_book_of_life_and_death.xml"


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
    return inst
end
---------------------------------------------------------------------------------------------------------------
return Prefab("fwd_in_pdt_item_book_of_life_and_death", fn, assets)