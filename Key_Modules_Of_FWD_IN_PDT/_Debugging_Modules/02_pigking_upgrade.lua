

AddPrefabPostInit(
    "pigking",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("fwd_in_pdt_func"):Init()

        inst.components.fwd_in_pdt_func:Add_TheWorld_OnPostInit_Fn(function()
            print("error : pigking PostInit fn")
        end)
        
    end
)