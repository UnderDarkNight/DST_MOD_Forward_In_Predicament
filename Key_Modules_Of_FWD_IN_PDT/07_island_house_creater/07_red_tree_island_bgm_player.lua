------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    小岛上的bgm播放事件安装给玩家

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPlayerPostInit(function(inst)

    inst:DoTaskInTime(0,function()
        ------------------------------------------------------------------------------------------
        ---- 服务端挂载事件监听
            if TheWorld.ismastersim then 
                inst:ListenForEvent("fwd_in_pdt_event.enter_red_tree_island",function()
                    inst.components.fwd_in_pdt_com_rpc_event:PushEvent("fwd_in_pdt_event.red_tree_island_bgm.start")
                end)
                inst:ListenForEvent("fwd_in_pdt_event.leave_red_tree_island",function()
                    inst.components.fwd_in_pdt_com_rpc_event:PushEvent("fwd_in_pdt_event.red_tree_island_bgm.stop")
                end)
            end
        ------------------------------------------------------------------------------------------

        if (not TheNet:IsDedicated() ) and inst == ThePlayer then   ---- 只在客户端创建event,由服务端通过RPC下发
            ------------------------------------------------------------------------------------------
            --- 客户端添加播放音乐的inst
                local bgm_music_inst = nil
                inst:ListenForEvent("fwd_in_pdt_event.red_tree_island_bgm.start",function()
                    if bgm_music_inst ~= nil then
                        return
                    end
                    bgm_music_inst = CreateEntity()
                    bgm_music_inst.entity:AddTransform()
                    bgm_music_inst.entity:AddSoundEmitter()         --- 声音播放组件
                    bgm_music_inst.entity:SetParent(inst.entity)    --- 挂到玩家身上
                    bgm_music_inst.SoundEmitter:PlaySound("dontstarve/music/gramaphone_ragtime","red_tree_island_bgm_flag")
                    -- print("music start ++ ")

                end)
                inst:ListenForEvent("fwd_in_pdt_event.red_tree_island_bgm.stop",function()
                    if bgm_music_inst then
                        bgm_music_inst.SoundEmitter:KillSound("red_tree_island_bgm_flag")
                        bgm_music_inst:Remove()
                        bgm_music_inst = nil
                        -- print("music stop ++")
                    end
                end)
            ------------------------------------------------------------------------------------------
        end 
    end)
end)