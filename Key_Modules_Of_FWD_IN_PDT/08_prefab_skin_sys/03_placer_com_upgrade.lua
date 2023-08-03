-----------------------------------------------------------------------------------------------------------------------------------------
--- hook 进 playercontroller 的 StartBuildPlacementMode ，让 皮肤参数进入 placer.SetBuilder 里面
--- playercontroller.StartBuildPlacementMode 是放置建筑的时候SpawnPrefab( XXX_placer ) 的 官方API
-----------------------------------------------------------------------------------------------------------------------------------------

AddComponentPostInit("playercontroller", function(self)
    self.StartBuildPlacementMode__skins_fwd_in_pdt_old = self.StartBuildPlacementMode
    self.StartBuildPlacementMode = function(self,recipe,skin,...)       --- client
        --- skin 参数来自 HUD那边，是个 string
        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("08_prefab_skin_sys  playercontroller",skin)
        end
        if recipe and type(recipe) == "table" and skin and FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin] then
            recipe.fwd_in_pdt_skin_data = skin
        end
        -- if skin and FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin] then -- 是模组的皮肤      --- 注销于2023.07.17 ，官方稍微修改了API，走了PREFAB_SKINS 和 PREFAB_SKINS_IDS 形式传递参数(rpc)。
        --     skin = nil
        -- end
        return self:StartBuildPlacementMode__skins_fwd_in_pdt_old(recipe,skin,...)
    end

end)

AddComponentPostInit("placer",function(self)
    self.SetBuilder__skins_fwd_in_pdt_old = self.SetBuilder
    self.SetBuilder = function(self,builder,recipe,deployable_item,...)                ---- client

        ------------------------------------------------------------------------------------------------------------------
        --- 普通的从制作栏生成的 placer
        if type(recipe) == "table" and recipe.fwd_in_pdt_skin_data then   
                -- print("SetBuilder_fwd_in_pdt_old",recipe.fwd_in_pdt_skin_data)
                ---------------------------------------------------------
                --- 修改placer_inst的皮肤。
                local skin_name = recipe.fwd_in_pdt_skin_data
                if skin_name and builder and builder.replica.fwd_in_pdt_func and builder.replica.fwd_in_pdt_func.SkinAPI__Has_Skin then
                    if self.inst.AnimState and builder.replica.fwd_in_pdt_func:SkinAPI__Has_Skin(skin_name) then
                        local skin_data = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)] or {}
                        if skin_data.bank and skin_data.build then
                            self.inst.AnimState:SetBank(skin_data.bank)
                            self.inst.AnimState:SetBuild(skin_data.build)
                        end    
                        if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                            print("placer.SetBuilder",skin_data.prefab_name,skin_name) 
                        end                        
                        builder.replica.fwd_in_pdt_func:SkinAPI__Set_RPC_Data(skin_data.prefab_name,skin_name)
                    end
                end
        end
        ------------------------------------------------------------------------------------------------------------------
        ---- 如果是放置物品类放置出来的
        ----  deployable_item.components.deployable.ondeploy = function(inst, pt, deployer, rot )
        ---- 如果是放置物放出来的，没法在这里进行皮肤切换，用放置物里的放置函数（上面这条）做相关处理
        if type(deployable_item) == "table" and deployable_item.replica.fwd_in_pdt_func and deployable_item.replica.fwd_in_pdt_func.SkinAPI__GetCurrent then 
            local skin_name = deployable_item.replica.fwd_in_pdt_func:SkinAPI__GetCurrent()
            if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
                print("deployable_item",deployable_item,skin_name)
            end
            if skin_name and self.inst.AnimState then
                local skin_data = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)] or {}
                if skin_data.bank and skin_data.build then
                    self.inst.AnimState:SetBank(skin_data.bank)
                    self.inst.AnimState:SetBuild(skin_data.build)
                end
            end
        end
        ------------------------------------------------------------------------------------------------------------------
        return self:SetBuilder__skins_fwd_in_pdt_old(builder,recipe,deployable_item,...)
    end

end)

--------------------------------------------------------------------------------------------------------------
---- 以下为调试追踪数据用的代码

AddComponentPostInit("builder",function(self)
    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE ~= true then
        return
    end
    -------------------------------------------------------------------------------------------
    self.DoBuild_skin_debug_fwd_in_pdt_old = self.DoBuild
    self.DoBuild = function(self,recname, pt, rotation, skin)
        print("08_prefab_skin_sys  DoBuild",recname,skin)   --- skin 得到nil ，往前hook func MakeRecipe 
        return self:DoBuild_skin_debug_fwd_in_pdt_old(recname,pt, rotation, skin)
    end
    -------------------------------------------------------------------------------------------

    self.MakeRecipe_skin_debug_fwd_in_pdt_old = self.MakeRecipe
    self.MakeRecipe = function(self,recipe, pt, rot, skin, onsuccess)
        print("08_prefab_skin_sys  MakeRecipe",recipe,skin) --- skin 还是得到nil ，继续往前 hook func MakeRecipeFromMenu/MakeRecipeAtPoint
        return self:MakeRecipe_skin_debug_fwd_in_pdt_old(recipe, pt, rot, skin, onsuccess)
    end
    -------------------------------------------------------------------------------------------
    ---- 【警告】疑似MakeRecipeFromMenu 函数被官方废弃，placer 的建筑 放置后不执行。在2023.07.17 发现官方改掉了API
    self.MakeRecipeFromMenu_skin_debug_fwd_in_pdt_old = self.MakeRecipeFromMenu
    self.MakeRecipeFromMenu = function(self,recipe,skin)
        print("08_prefab_skin_sys MakeRecipeFromMenu",skin)    --- 确认有 skin 参数，  ValidateRecipeSkinRequest 函数造成问题
        return self:MakeRecipeFromMenu_skin_debug_fwd_in_pdt_old(recipe,skin)
    end
    -------------------------------------------------------------------------------------------
    self.MakeRecipeAtPoint_skin_debug_fwd_in_pdt_old = self.MakeRecipeAtPoint    
    self.MakeRecipeAtPoint = function(self,recipe, pt, rot, skin)   
        print("08_prefab_skin_sys  MakeRecipeAtPoint",skin)         ---- 没有得到参数，往上追踪到 networkclientrpc.lua 的 MakeRecipeAtPoint
        return self:MakeRecipeAtPoint_skin_debug_fwd_in_pdt_old(recipe, pt, rot, skin)
    end

    -------------------------------------------------------------------------------------------
end)

----------------- 用这个api 修改 replica 单纯是为了兼容其他MOD 
AddClassPostConstruct("components/builder_replica", function(self)
    if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE ~= true then
        return
    end

    self.MakeRecipeAtPoint_skin_debug_fwd_in_pdt_old = self.MakeRecipeAtPoint
    function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
        print("08_prefab_skin_sys  MakeRecipeAtPoint replica",skin)
        return self:MakeRecipeAtPoint_skin_debug_fwd_in_pdt_old(recipe, pt, rot, skin)
    end

end)




-- ----------
-- --- 客户端 回传 RPC数据
AddComponentPostInit("playercontroller", function(self)

    self.RemoteMakeRecipeFromMenu__fwd_in_pdt_old = self.RemoteMakeRecipeFromMenu
    self.RemoteMakeRecipeFromMenu = function(self,recipe, skin,...) --- client 那边，进入这个 func 的时候参数正常，RPC上传没数据
        if not TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE then
            print("08_prefab_skin_sys RemoteMakeRecipeFromMenu",recipe.product,skin)            
        end
        self.inst.replica.fwd_in_pdt_func:SkinAPI__Set_RPC_Data(recipe.product,skin)
        return self:RemoteMakeRecipeFromMenu__fwd_in_pdt_old(recipe, skin,...)
    end
end)