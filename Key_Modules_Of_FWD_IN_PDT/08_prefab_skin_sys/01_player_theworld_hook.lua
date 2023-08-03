-----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------


AddPlayerPostInit(function(inst)


    if not TheWorld.ismastersim then
        return
    end

    if inst.components.fwd_in_pdt_func == nil then
        inst:AddComponent("fwd_in_pdt_func")
    end
    inst.components.fwd_in_pdt_func:Init("skin_player")

    
    -- inst:ListenForEvent("makerecipe",function(_,_table)
    --     if _table and _table.recipe then
    --         print("makerecipe",_table.recipe)
    --     end
    -- end)
    
    inst:ListenForEvent("builditem",function(_,_table)
        if _table and _table.item then
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("FWD_IN_PDT SKIN API builditem evet",_table.item,_table.skin)
            end
            if  _table.item.components.fwd_in_pdt_func and _table.item.components.fwd_in_pdt_func.SkinAPI__SetCurrent then
                if _table.skin == nil then                                    
                    local rpc_prefab,rpc_skin = inst.components.fwd_in_pdt_func:SkinAPI__Get_RPC_Data() 
                    if rpc_prefab and rpc_prefab == _table.item.prefab and rpc_skin and inst.components.fwd_in_pdt_func:SkinAPI__Has_Skin(rpc_skin,rpc_prefab) then
                        _table.skin = rpc_skin
                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            print("FWD_IN_PDT SKIN API builditem evet RPC",rpc_prefab,rpc_skin)
                        end
                    end
                end
                _table.item.components.fwd_in_pdt_func:SkinAPI__SetCurrent(_table.skin)
            end
            _table.item:PushEvent("fwd_in_pdt_event.player_build",inst)  --- 触发玩家制作事件
        end
    end)
    inst:ListenForEvent("buildstructure",function(_,_table)
        if _table and _table.item then
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("FWD_IN_PDT SKIN API buildstructure event",_table.item,_table.skin)
            end
            if  _table.item.components.fwd_in_pdt_func and _table.item.components.fwd_in_pdt_func.SkinAPI__SetCurrent then
                if _table.skin == nil then                                    
                    local rpc_prefab,rpc_skin = inst.components.fwd_in_pdt_func:SkinAPI__Get_RPC_Data() 
                    if rpc_prefab and rpc_prefab == _table.item.prefab and rpc_skin and inst.components.fwd_in_pdt_func:SkinAPI__Has_Skin(rpc_skin,rpc_prefab) then
                        _table.skin = rpc_skin
                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            print("FWD_IN_PDT SKIN API builditem evet RPC",rpc_prefab,rpc_skin)
                        end
                    end
                end
                _table.item.components.fwd_in_pdt_func:SkinAPI__SetCurrent(_table.skin)
            end
            _table.item:PushEvent("fwd_in_pdt_event.player_build",inst)  --- 触发玩家制作事件
        end
    end)

    

end)








-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         inst:AddComponent("fwd_in_pdt_com_skins"):TheWorld_api_init()
--     end
-- )