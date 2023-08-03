

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, .5)



    inst.AnimState:SetBank("chesspiece")
    inst.AnimState:SetBuild("swap_chesspiece_deerclops_stone")   -- zip
    inst.AnimState:PlayAnimation("idle")
    ---                                         display flag                    old build                           new build
    -- inst.AnimState:SetClientsideBuildOverride("test_display_npc_flag", "swap_chesspiece_deerclops_stone", "swap_chesspiece_deerclops_moonglass")
    -- inst.AnimState:SetClientsideBuildOverride("test_display_npc_flag", "swap_chesspiece_deerclops_stone", "swap_chesspiece_antlion_marble")
   
    ---- 玩家使用  ThePlayer.AnimState:SetClientSideBuildOverrideFlag("test_display_npc_flag",true)  进行外观切换 ,只能有一组 build 可切换。

    inst.entity:SetPristine()
    --------------------------------------------------------------------------------------------------------------------   
    ----------- 
    inst.__net_bool = net_bool(inst.GUID, "fwd_in_pdt_special_npc_test", "fwd_in_pdt_special_npc_test")
    inst:ListenForEvent("fwd_in_pdt_special_npc_test",function()
        inst:PushEvent("player_spwan")
    end)

    local function display_for_player(player)
        if ThePlayer then
            if TheWorld.ismastersim then
                    ----- 没洞穴的存档,使用 override 可以避免覆盖其非房主玩家看见的外观。
                    ThePlayer:DoTaskInTime(0,function()
                        if ThePlayer.prefab == "woodie" then
                            inst.AnimState:SetClientsideBuildOverride("test_display_npc_flag", "swap_chesspiece_deerclops_stone", "swap_chesspiece_deerclops_moonglass")
                            ThePlayer.AnimState:SetClientSideBuildOverrideFlag("test_display_npc_flag",true)
                        elseif ThePlayer.prefab == "wilson" then
                            inst.AnimState:SetClientsideBuildOverride("test_display_npc_flag", "swap_chesspiece_deerclops_stone", "swap_chesspiece_antlion_marble")
                            ThePlayer.AnimState:SetClientSideBuildOverrideFlag("test_display_npc_flag",true)
                        else
                            ThePlayer.AnimState:SetClientSideBuildOverrideFlag("test_display_npc_flag",false)
                        end
                    end)
            
            else
                    ---- 客机，不管有没有洞穴
                    ThePlayer:DoTaskInTime(0,function()
                        if ThePlayer.prefab == "woodie" then
                            inst.AnimState:SetBuild("swap_chesspiece_deerclops_moonglass")
                        elseif ThePlayer.prefab == "wilson" then
                            inst.AnimState:SetBuild("swap_chesspiece_antlion_marble")
                        else
                            inst.AnimState:SetBuild("swap_chesspiece_deerclops_stone")
                        end
                    end)    
            end
        end
    end

    inst:ListenForEvent("player_spwan",function()   ---- server and client
        for k, temp_player in pairs(AllPlayers) do
            display_for_player(temp_player)
        end
    end)


    inst:ListenForEvent("ms_playerspawn",function(_TheWorld,player) --- server only
        inst:DoTaskInTime(0,function()
            inst.__net_bool:set(true)
        end)
        inst:DoTaskInTime(0.5,function()
            inst.__net_bool:set(false)
        end)

    end,TheWorld)
    --------------------------------------------------------------------------------------------------------------------
    --- 根据玩家不同显示不同名字(鼠标放上去显示的名字)
    inst.displaynamefn = function()
        if ThePlayer and ThePlayer.prefab == "woodie" then
            return "特殊的NPC"
        else
            return "普通的NPC"
        end
    end
    --------------------------------------------------------------------------------------------------------------------   
   
    if not TheWorld.ismastersim then
        return inst
    end    
    -----------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")
    -- inst.components.inspectable:SetDescription(GetStringsTable().inspect_str)   ---- 设置角色检查时候的内容
    ---- 根据不同玩家显示不同的检查文本
    inst.components.inspectable.getspecialdescription = function(inst,viewer)
        if viewer and viewer.prefab == "woodie" then
            return "这是一个特殊的NPC"
        else
            return "这是一个普通的NPC"
        end    
    end


    -------------------------------------------------------------------------------------------------
    ----- 这个函数给 羽毛笔 一类的绘画用的，给 com drawingtool 里调用的。
        -- inst.drawimageoverride = function(inst,viewer)
        --     print("error : drawimageoverride",viewer)
        --     if viewer then
        --         if viewer.prefab == "woodie" then
        --             return "swap_chesspiece_deerclops_moonglass"
        --         end
        --     end
        --     return "swap_chesspiece_deerclops_stone"
        -- end
    -------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("fwd_in_pdt_special_npc_test", fn)