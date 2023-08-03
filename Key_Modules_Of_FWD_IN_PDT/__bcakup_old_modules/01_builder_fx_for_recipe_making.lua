--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 制作物品的时候播放特效
---- fx 的 inst
---- 相应的参数和和执行在 玩家组件 fwd_in_pdt_com_builder_fx_for_recipe_making 里
---- 在【Key_Modules_Of_FWD_IN_PDT\01_00_Player_Prefab_Upgrade\03_recipes_making_fx.lua】 添加 针对prefab 的特效
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- 旧方案，没什么用了，留着做笔记
    -- AddComponentPostInit("builder", function(self)    
    --         -- ------------------------
    --         -- --- 建筑直接走这个（placer）--- DoBuild 太迟了，得往前HOOK
    --         -- self.DoBuild_for_recipe_fx__old_fwd_in_pdt = self.DoBuild
    --         -- self.DoBuild = function(self,recname, pt, rotation, skin)
    --         --     local rets = {self:DoBuild_for_recipe_fx__old_fwd_in_pdt(recname, pt, rotation, skin)}
    --         --     if rets[1] == true then
    --         --         -- local rec =  GetValidRecipe(recname)
    --         --         -- print("info DoBuild_for_recipe_fx__old",recname)
    --         --         if  GetValidRecipe(recname) and self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making then
    --         --             self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:DoBuild(recname, pt, rotation, skin)
    --         --         end
    --         --     end
    --         --     return unpack(rets)
    --         -- end
    --         ----------------------------
    --         --- 建筑放置走这个 placer , 太早了，远处放的时候没走到位置就执行了。 得处理  PushAction ,或者
    --         --- 利用 AddSuccessAction 则会太迟了。
    --         -- self.MakeRecipe_for_recipe_fx__old_fwd_in_pdt = self.MakeRecipe
    --         -- self.MakeRecipe = function(self,recipe, pt, rot, skin , onsuccess)
    --         --     ------- 
    --         --     local old_onsuccess_fn = nil
    --         --     if onsuccess and type(onsuccess) == "function" then
    --         --         old_onsuccess_fn = onsuccess
    --         --     end
    --         --     local new_onsuccess_fn = function(...)
    --         --         if type(recipe) == "table" and recipe.name and GetValidRecipe(recipe.name) and self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making then
    --         --             self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:DoBuild(recipe.name, Vector3(self.inst.Transform:GetWorldPosition()), nil, skin)
    --         --         end
    --         --         if old_onsuccess_fn then
    --         --             return old_onsuccess_fn(...)
    --         --         end
    --         --     end
    --         --     local rets = {self:MakeRecipe_for_recipe_fx__old_fwd_in_pdt(recipe, pt, rot, skin,new_onsuccess_fn)}
    --         --     -- print("MakeRecipe_for_recipe_fx__old_fwd_in_pdt",recipe,type(recipe))
    --         --     return unpack(rets)
    --         -- end
        
    --     ----------------------------
        


    --     -- ----------------------------
    --     -- --- 其他东西，技能、物品
    --     -- self.MakeRecipeFromMenu_for_recipe_fx__old_fwd_in_pdt = self.MakeRecipeFromMenu
    --     -- self.MakeRecipeFromMenu = function(self,recipe, skin)
    --     --     local rets = {self:MakeRecipeFromMenu_for_recipe_fx__old_fwd_in_pdt(recipe,skin)}
    --     --     if type(recipe) == "table" and recipe.name and GetValidRecipe(recipe.name) and self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making then
    --     --         self.inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making:DoBuild(recipe.name, Vector3(self.inst.Transform:GetWorldPosition()), nil, skin)
    --     --     end
    --     --     return unpack(rets)
    --     -- end

    -- end)


-----------------------------------------------------------------------------------------------------------
-------------- 监听 GoToState
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("newstate",function(inst,_table)
        -- if _table == nil or _table.statename == nil then
        --     return
        -- end

        if inst.components.fwd_in_pdt_com_builder_fx_for_recipe_making and inst.bufferedaction and inst.bufferedaction.recipe and GetValidRecipe(inst.bufferedaction.recipe) then
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