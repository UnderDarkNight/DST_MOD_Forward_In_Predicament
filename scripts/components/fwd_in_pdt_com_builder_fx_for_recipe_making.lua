--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 制作物品的时候播放的特效
-- 挂载去 builder:DoBuild   【Key_Modules_Of_FWD_IN_PDT\02_Original_Components_Upgrade\01_builder_fx_for_recipe_making.lua】

-- Add_Fx_Fn 给对应的prefab 加 fn，  
--  可以单个添加 Add_Fx_Fn("yellowstaff",fn)
--  可以多个添加 Add_Fx_Fn({"yellowstaff"，"glasscutter"},fn)
--  fn 参数：self.fns[recname](self.inst,pt,rotation, skin)
--  【重要】如果需要移动终止特效，则 fn 需要return 所有 特效 inst
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_builder_fx_for_recipe_making = Class(function(self, inst)
    self.inst = inst
    self.fns = {}
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------
---- 制作期间移动终止
function fwd_in_pdt_com_builder_fx_for_recipe_making:Save_Fx_Inst(...)
    self.fx = self.fx or {}
    local args = {...}
    for k, v in pairs(args) do
        if v and v.Remove then
            self.fx[v] = true
        end
    end
end

function fwd_in_pdt_com_builder_fx_for_recipe_making:Kill_All_Fx()
    if self.fx then
        for fx, v in pairs(self.fx) do
            if fx and fx.IsValid then
                fx:Remove()
            end
        end
    end
    self.fx = nil
end

------------------------------------------------------------------------------------------------------------
---- 制作物品的时候外部直接调用这个
function fwd_in_pdt_com_builder_fx_for_recipe_making:DoBuild(recname, pt, rotation, skin)
    if type(recname) ~= "string" then
        return
    end
    local rec = GetValidRecipe(recname)
    if rec == nil then
        return
    end
    -- print("info : fx for recipe making",recname)
    if self.fns[recname] then
        self:Save_Fx_Inst( self.fns[recname](self.inst,pt,rotation, skin)  )
    end
end
------------------------------------------------------------------------------------------------------------
---- 添加特效，根据制作的目标prefab
function fwd_in_pdt_com_builder_fx_for_recipe_making:Add_Fx_Fn(fx_prefab,fn)
    if type(fx_prefab) == "string" and type(fn) == "function" then
        self.fns[fx_prefab] = fn
    elseif type(fx_prefab) == "table" and type(fn) == "function" then
        for k, v in pairs(fx_prefab) do
            if type(v) == "string" then
                self:Add_Fx_Fn(v,fn)
            end
        end
    end
end
------------------------------------------------------------------------------------------------------------

return fwd_in_pdt_com_builder_fx_for_recipe_making




