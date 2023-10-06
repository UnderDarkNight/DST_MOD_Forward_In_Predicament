------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  皮肤相关的API ，在玩家身上的

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    self.TempData.SkinAPI_Datas = {}
    local SkinAPI_Datas = self.TempData.SkinAPI_Datas
    ----------------------------- 皮肤切换后执行函数(可以用来后续切换图标等操作)
        function self:SkinAPI__Add_Skin_Changed_Fn(fn)
            if type(fn) == "function" then
                SkinAPI_Datas.__skin_changed_fn = fn
            end            
        end
    ----------------------------- 设置当前对象的皮肤为
        function self:SkinAPI__SetCurrent(skin_name)       ---- 设置为目标皮肤，或者清除皮肤
                -- print("SkinAPI__SetCurrent",skin_name)
                if skin_name and type(FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)]) == "table"  then            
                    ----------------------------------------------------------------------------------
                    local temp_data = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)]

                    self:Set("current_skin",skin_name)
                    self:Replica_Set_Simple_Data("current_skin",skin_name)
                    self.inst.skinname = skin_name  --- stackable 无法叠堆在一起使用的


                    if self.inst.AnimState then
                        self.inst.AnimState:SetBank(temp_data.bank)
                        self.inst.AnimState:SetBuild(temp_data.build)
                    end
                    
                    if self.inst.components.inventoryitem and temp_data.image then
                        self.inst.components.inventoryitem.imagename = temp_data.image
                        self.inst.components.inventoryitem.atlasname = temp_data.atlas
                    end

                    if temp_data.name and self.inst.components.named then
                        self.inst.components.named:SetName(temp_data.name)
                    end

                    if temp_data.minimap and self.inst.MiniMapEntity then
                        self.inst.MiniMapEntity:SetIcon(temp_data.minimap)
                    end

                    if SkinAPI_Datas.__skin_changed_fn then
                        SkinAPI_Datas.__skin_changed_fn(skin_name)
                    end
                else        ----------------------------------------------------------------------------------
                    self:Set("current_skin",skin_name)
                    self:Replica_Set_Simple_Data("current_skin",skin_name)
                    self.inst.skinname = skin_name  --- stackable 无法叠堆在一起使用的

                    local temp_default_data = self.inst._fwd_in_pdt_skin_default
                    if temp_default_data then
                        if self.inst.AnimState and temp_default_data.bank and temp_default_data.build then
                            self.inst.AnimState:SetBank(temp_default_data.bank)
                            self.inst.AnimState:SetBuild(temp_default_data.build)
                        end

                        if temp_default_data.minimap and self.inst.MiniMapEntity then
                            self.inst.MiniMapEntity:SetIcon(temp_default_data.minimap)
                        end
                    else
                        print("error , inst._fwd_in_pdt_skin_default table is nil",self.inst)    
                    end

                    if self.inst.components.inventoryitem then
                        self.inst.components.inventoryitem:fwd_in_pdt_reset_icon()
                    end
                    if self.inst.components.named then
                        self.inst.components.named:fwd_in_pdt_reset_name()
                    end

                    if SkinAPI_Datas.__skin_changed_fn then
                        SkinAPI_Datas.__skin_changed_fn(skin_name)
                    end
                    ----------------------------------------------------------------------------------
                end   

                -- print("SkinAPI__SetCurrent end ",self:Get("current_skin"))
        end
    ----------------------------- 获取当前对象的皮肤
        function self:SkinAPI__GetCurrent()
            return self:Get("current_skin")
        end
    ----------------------------- 获取当前皮肤的完整数据表
        function self:SkinAPI__GetCurrentData()
            local skin_name = self:SkinAPI__GetCurrent()
            if skin_name == nil then
                return nil
            end
            return FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin_name]
        end

    ----------------------------- 给种植类/围栏 等物品使用的
        function self:SkinAPI__DeployItem(target_inst)
            if target_inst.components.fwd_in_pdt_func and target_inst.components.fwd_in_pdt_func.SkinAPI__SetCurrent then
                -- local skin = self:SkinAPI__GetCurrent()
                local skin_data = self:SkinAPI__GetCurrentData()
                if skin_data and skin_data.placed_skin_name then
                    target_inst.components.fwd_in_pdt_func:SkinAPI__SetCurrent(skin_data.placed_skin_name)
                end
            end
        end
    --------------------------------------------
    --- 镜像用的API
        function self:SkinAPI_AddMirror()
            self.inst:AddTag("fwd_in_pdt_com_skins.mirror")
        end
        function self:SkinAPI__CanMirror()
            return self.inst:HasTag("fwd_in_pdt_com_skins.mirror")
        end

        function self:SkinAPI__DoMirror()
            if self:SkinAPI__CanMirror() then
                local old_flag = self:Get("skin_mirror") or false
                local new_flag = not old_flag
                -- self.DataTable.__Mirror_flag = new_flag
                self:Set("skin_mirror",new_flag)
                self:SkinAPI__Mirror_Check_For_Onload()
            end
        end

        function self:SkinAPI__Mirror_Check_For_Onload()
            if self:SkinAPI__CanMirror() then
                local current_flag = self:Get("skin_mirror") or false
                if self.inst.AnimState then
                    if current_flag == true then
                        self.inst.AnimState:SetScale(-1,1,1)
                    else
                        self.inst.AnimState:SetScale(1,1,1)
                    end
                end
            end
        end

    --------------------------------------------
    -- 执行皮肤工具切换后的特效
        function self:SkinAPI__SetReSkinToolFn(fn)
            if type(fn) == "function" then
                SkinAPI_Datas.___ReSkinToolFn = fn
            end
        end

        self.inst:ListenForEvent("fwd_in_pdt_event.next_skin",function(inst,_cmd_table)
            if SkinAPI_Datas.___ReSkinToolFn then
                SkinAPI_Datas.___ReSkinToolFn(inst,_cmd_table and _cmd_table.skin_name)
            else
                        local color = {
                            Vector3(255,0,0),
                            Vector3(0,255,0),
                            Vector3(0,0,255),
                            Vector3(255,255,0),
                            Vector3(255,0,255),
                            Vector3(0,255,255),
                        }
                        local pt = Vector3(inst.Transform:GetWorldPosition())
                        SpawnPrefab("fwd_in_pdt_fx_knowledge_flash"):PushEvent("Set",{
                            pt = Vector3(pt.x,0,pt.z),
                            color = color[math.random(#color)],
                            sound = "terraria1/skins/spectrepaintbrush"
                        })
            end
        end)
    --------------------------------------------
    -- onload
        function self:SkinAPI__Onload()
            -- local onload_skin = self:Get("current_skin")
            -- print("error ++++++++++",self:Get("current_skin"))

            self:SkinAPI__Mirror_Check_For_Onload()
            local skin_name = self:SkinAPI__GetCurrent()
            self:SkinAPI__SetCurrent(skin_name)
        end
        -- self.inst:DoTaskInTime(0,function()
        --     self:SkinAPI__Onload()            
        -- end)
        self:Add_OnLoad_Fn(function()
            self:SkinAPI__Onload()
        end)
    --------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function replica(self)
    
    function self:SkinAPI__GetCurrent()
        return self:Replica_Get_Simple_Data("current_skin")
    end

    function self:SkinAPI__GetCurrentData()
        local skin_name = self:SkinAPI__GetCurrent()
        if skin_name == nil then
            return nil
        end
        return FWD_IN_PDT_MOD_SKIN.SKINS_DATA[skin_name]
    end
    ----------------------------------------------
    --- 镜像
    function self:SkinAPI__CanMirror()
        return self.inst:HasTag("fwd_in_pdt_com_skins.mirror")
    end

end
return function(fwd_in_pdt_func)
    if fwd_in_pdt_func.inst:HasTag("player") then
        return
    end
    fwd_in_pdt_func.inst:AddTag("fwd_in_pdt_com_skins")  
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end
end
