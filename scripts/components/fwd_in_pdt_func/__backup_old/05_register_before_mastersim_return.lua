------------------------------------------------------------------------------------------------
---- 在 TheWorld.ismastersim return 前加载 fwd_in_pdt_func 组件会造成 replica 重复加载的问题。
---- 尤其是每次OnEntityWake的时候，客户端都会 重新注册replica。需要做避免阻塞崩溃的处理。
------------------------------------------------------------------------------------------------


return function(fwd_in_pdt_func)    

    ------ 阻塞崩溃处理
    ------ 在客户端， OnEntityWake 的时候会重新注册一次 组件的replica。 
    ------ 在客户端OnEntityWake的时候会重新注册一次 组件的replica。 会造成重复注册函数而阻塞崩溃。这里处理这个问题。
    if fwd_in_pdt_func.inst.ReplicateComponent__fwd_in_pdt_old == nil then
        fwd_in_pdt_func.inst.ReplicateComponent__fwd_in_pdt_old = fwd_in_pdt_func.inst.ReplicateComponent
        fwd_in_pdt_func.inst.ReplicateComponent = function(inst,name)
            if name == "fwd_in_pdt_func" and inst.replica and inst.replica.fwd_in_pdt_func ~= nil then
                -- print("error : ReplicateComponent fwd_in_pdt_func")
                return
            end
            inst:ReplicateComponent__fwd_in_pdt_old(name)
        end
    end

end