-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 初始化添加特定组件
---- 添加一些Event
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "world",
    function(inst)


        ---------------------------------------------------------------------------------------------
        ---- 物品创建完毕， DoTaskInTime 0 之前，回环个 event 。
        ---- OnLoad 函数在没存档的时候好像不运行。
            inst:ListenForEvent("entity_spawned",function(_,spawned_inst)
                if spawned_inst and spawned_inst.PushEvent then
                    spawned_inst:PushEvent("fwd_in_pdt_event.entity_spawned")
                end
            end)
        ---------------------------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return
        end
        ---------------------------------------------------------------------------------------------

            if inst.components.fwd_in_pdt_data == nil then
                inst:AddComponent("fwd_in_pdt_data")
            end
            if inst.components.fwd_in_pdt_func == nil then
                inst:AddComponent("fwd_in_pdt_func"):Init(TUNING["Forward_In_Predicament.World_Com_Func"])  
            end       

        ---------------------------------------------------------------------------------------------
        
    end
)


