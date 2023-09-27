------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 升级 青蛙，可变异组件
--- 青蛙雨有 20%的概率 变异
--- 池塘的青蛙 有 20%的概率变异
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		local function GetStringsTable(name)
		    local prefab_name = name or "fwd_in_pdt_other_poison_frog"
		    local LANGUAGE = type(TUNING["Forward_In_Predicament.Language"]) == "function" and TUNING["Forward_In_Predicament.Language"]() or TUNING["Forward_In_Predicament.Language"]
		    return TUNING["Forward_In_Predicament.Strings"][LANGUAGE][prefab_name] or {}
		end

AddPrefabPostInit(
    "frog",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        

        inst:AddComponent("fwd_in_pdt_data")
        inst:ListenForEvent("fwd_in_pdt_event.start_mutant",function()
            inst.components.fwd_in_pdt_data:Set("mutant_frog",true)
            -- inst.AnimState:SetMultColour(255/255,0/255,0/255,255/255)
            inst.AnimState:OverrideSymbol("frogback","fwd_in_pdt_mutant_frog","frogback")
            inst.AnimState:OverrideSymbol("frogeye","fwd_in_pdt_mutant_frog","frogeye")
            inst.AnimState:OverrideSymbol("frogfoot","fwd_in_pdt_mutant_frog","frogfoot")
            inst.AnimState:OverrideSymbol("froghead","fwd_in_pdt_mutant_frog","froghead")
            inst.AnimState:OverrideSymbol("frogmouth","fwd_in_pdt_mutant_frog","frogmouth")
            inst.AnimState:OverrideSymbol("frogsack","fwd_in_pdt_mutant_frog","frogsack")
            inst.AnimState:OverrideSymbol("frogtongue","fwd_in_pdt_mutant_frog","frogtongue")


            inst:AddTag("fwd_in_pdt_tag.mutant_frog")
            if inst.components.named == nil then
                inst:AddComponent("named")
            end
            inst.components.named:SetName(GetStringsTable().name)
        end)
        inst:DoTaskInTime(0,function()
            if inst.components.fwd_in_pdt_data:Get("mutant_frog") then
                inst:PushEvent("fwd_in_pdt_event.start_mutant")
            end
        end)

        inst:ListenForEvent("newstate",function(_,_table)
            if _table and _table.statename and _table.statename == "fall" then
                if math.random(1000) < 200 then
                    inst:PushEvent("fwd_in_pdt_event.start_mutant")
                end
            end
        end)

    end
)

-------------------------------------------------------
-- 池塘
AddPrefabPostInit(
    "pond",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.childspawner then
            inst.components.childspawner.DoSpawnChild_old_fwd_in_pdt_mutant = inst.components.childspawner.DoSpawnChild
            inst.components.childspawner.DoSpawnChild = function(self,...)
                local child = self:DoSpawnChild_old_fwd_in_pdt_mutant(...)
                if child and math.random(1000) < 200 then
                    child:PushEvent("fwd_in_pdt_event.start_mutant")
                end
                return child
            end
        end
    end
)



