-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 根据制作的物品放置特效
--- 调用组件 fwd_in_pdt_com_builder_fx_for_recipe_making
--- 外部配合 【_Key_Modules_Of_FWD_IN_PDT\02_Original_Components_Upgrade\01_builder_fx_for_recipe_making.lua】


-- Add_Fx_Fn 给对应的prefab 加 fn，
--  fn 参数：self.fns[recname](self.inst,pt,rotation, skin)
--  【重要】如果想要特效inst 在动作中断后消失，fn 里return 所有 fx_inst
--- pt :placer 的目标位置坐标，Vector3
--- 如果想得到完整的 AddRecipe2 里的参数表，使用 GetValidRecipe(inst.bufferedaction.recipe)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------- 监听 GoToState
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("newstate",function(inst,_table)
        -- if _table == nil or _table.statename == nil then
        --     return
        -- end
            inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Kill_All_Fx()
            if inst.bufferedaction and inst.bufferedaction.recipe and inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making and GetValidRecipe(inst.bufferedaction.recipe) then
                local recname = inst.bufferedaction.recipe
                local pt = nil
                if inst.bufferedaction.pos then
                    pt = inst.bufferedaction.pos:GetPosition()
                end 
                local rotation = inst.bufferedaction.rotation
                local skin = inst.bufferedaction.skin
                -- print("info buffer action ",inst.bufferedaction.recipe)
                -- for k, v in pairs(inst.bufferedaction) do
                --     print(k,v)
                -- end
                -- print(skin)
                inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:DoBuild(recname,pt and pt.x and pt,rotation,skin)            
            end
    end)
end)
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("fwd_in_pdt_com_builder_fx_for_recipe_making")


    ---------------------------------------------------------------------------------------------------
    --- 示例（物品）
        inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn("fwd_in_pdt_building_mock_wall_grass_item",function(player,pt,rotation, skin)
            local x,y,z = player.Transform:GetWorldPosition()
            local fx = SpawnPrefab("fwd_in_pdt_fx_knowledge_flash")
            fx:PushEvent("Set",{
                pt = Vector3(x,y,z)
            })
            return fx
        end)
    ---------------------------------------------------------------------------------------------------
    --- 示例，冰箱（建筑）
        inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn("icebox",function(player,pt,rotation, skin)
            local x,y,z = player.Transform:GetWorldPosition()
            local fx_1 = SpawnPrefab("fwd_in_pdt_fx_collapse")
            fx_1:PushEvent("Set",{
                pt = Vector3(x,y,z)
            })
            local fx_2 = SpawnPrefab("fwd_in_pdt_fx_knowledge_flash")
            fx_2:PushEvent("Set",{
                pt = pt
            })
            return fx_1,fx_2
        end)
    ---------------------------------------------------------------------------------------------------    
    --- 唤星者魔杖
        inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn("yellowstaff",function(player,pt,rotation, skin)
            local x,y,z = player.Transform:GetWorldPosition()
            local fx = SpawnPrefab("fwd_in_pdt_fx_recipe_star")
            fx:PushEvent("Set",{
                pt = Vector3(x,0.5,z)
            })
            return fx
        end)
    ---------------------------------------------------------------------------------------------------
    --- 科学机器，炼金引擎
        inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn({"researchlab","researchlab2","researchlab3","researchlab4"},function(player,pt,rotation, skin)
            local x,y,z = player.Transform:GetWorldPosition()
            SpawnPrefab("fwd_in_pdt_fx_recipe_function"):PushEvent("Set",{
                pt = Vector3(x,2.7,z),
                speed = 0.8
            })
        end)
    ---------------------------------------------------------------------------------------------------
    --- 电子元件
        inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn({"transistor"},function(player,pt,rotation, skin)
            local x,y,z = player.Transform:GetWorldPosition()
            SpawnPrefab("fwd_in_pdt_fx_recipe_function"):PushEvent("Set",{
                pt = Vector3(x,2.7,z),
                -- speed = 0.7
            })
        end)
    ---------------------------------------------------------------------------------------------------

end)
