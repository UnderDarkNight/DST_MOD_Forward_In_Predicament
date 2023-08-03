-----------------------------------------------------------------------------------------------------------------------------------------
--- hook 进 playercontroller 的 StartBuildPlacementMode ，让 皮肤参数进入 placer.SetBuilder 里面
--- playercontroller.StartBuildPlacementMode 是放置建筑的时候SpawnPrefab( XXX_placer ) 的 官方API
-----------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------
----- 叠堆的带皮肤的物品进行皮肤参数继承
AddComponentPostInit("stackable",function(self) 
    self.Get_fwd_in_pdt_skin_old = self.Get
    self.Get = function(self,...)
        if self.inst and self.inst.components.fwd_in_pdt_func and self.inst.components.fwd_in_pdt_func.SkinAPI__SetCurrent then
            local skin_name = self.inst.components.fwd_in_pdt_func:SkinAPI__GetCurrent() or nil
            local ret_inst = self:Get_fwd_in_pdt_skin_old(...)
            
            if ret_inst == self.inst then
                return ret_inst
            elseif skin_name and ret_inst.components.fwd_in_pdt_func and ret_inst.components.fwd_in_pdt_func.SkinAPI__SetCurrent then
                ret_inst.components.fwd_in_pdt_func:SkinAPI__SetCurrent(skin_name)
            end
            return ret_inst
        else
            return self:Get_fwd_in_pdt_skin_old(...)
        end        
    end


    -- self.Put_fwd_in_pdt_skin_old = self.Put
    -- self.Put = function(self,item,...)
    --     if item then
    --         print("put",self.inst.skinname,item.skinname)
    --     end
    --     return self:Put_fwd_in_pdt_skin_old(item,...)
    -- end


end)
-----------------------------------------------------------------------------------------------------------------------------------------
