----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetImageData(index)
        if TUNING.FWD_IN_PDT_DECORATIONS and TUNING.FWD_IN_PDT_DECORATIONS[index] then
            local temp = TUNING.FWD_IN_PDT_DECORATIONS[index]
            local atlas = temp.atlas
            local image = temp.image
            return atlas, image
        end
        return nil, nil
    end
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_building_decoration_system = Class(function(self, inst)
    self.inst = inst
    ------------------------------------------------------------------------------------------------------------
    ---- 初始化
        self.decorations = {}
    ------------------------------------------------------------------------------------------------------------
    ---- net 传送数据
        -- self.__net_string_decorations_josn = net_string(inst.GUID, "decorations_json", "decorations_json_update")
        -- inst:ListenForEvent("decorations_json_update", function(inst)
        --     local str = self.__net_string_decorations_josn:value()
        --     local crash_flag,ret_table = pcall(json.decode, str)
        --     if crash_flag and type(ret_table) == "table" then
        --         self.decorations = ret_table
        --         self:DoUpdate()
        --     end
        -- end)
    ------------------------------------------------------------------------------------------------------------
    ---- owner
        self.owner = nil
        self.__owner = net_entity(inst.GUID, "owner", "owner_update")
        inst:ListenForEvent("owner_update", function(inst)
            self.owner = self.__owner:value()
        end)
    ------------------------------------------------------------------------------------------------------------
    ---- update
        self.___update_fns = {}
    ------------------------------------------------------------------------------------------------------------
end)
------------------------------------------------------------------------------------------------------------------------------
---
    function fwd_in_pdt_building_decoration_system:SetDecorations(data)
        -- local str = json.encode(data)
        -- self.__net_string_decorations_josn:set(str)
        self.decorations = data
    end
    function fwd_in_pdt_building_decoration_system:GetDecorations()
        return self.decorations
    end
    function fwd_in_pdt_building_decoration_system:SetOwner(owner)
        self.__owner:set(owner)
        self.owner = owner        
    end
    function fwd_in_pdt_building_decoration_system:GetOwner()
        return self.owner
    end
------------------------------------------------------------------------------------------------------------------------------
---- 更新函数
    function fwd_in_pdt_building_decoration_system:AddUpdateFn(fn)
        if type(fn) == "function" then
            table.insert(self.___update_fns,fn)
        end
    end
    function fwd_in_pdt_building_decoration_system:DoUpdate()
        for k, v in pairs(self.___update_fns) do
            v(self.inst,self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_building_decoration_system







