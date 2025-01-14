--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local TheCamera = require("cameras/followcamera")


TheCamera.__fwd_in_pdt_zoom_block_modifiers = {}

TheCamera.__fwd_in_pdt_zoom_block_modifier_on_remove_event = function(temp_inst)
    TheCamera:FWD_IN_PDT_Remove_Zoom_Block_Modifier(temp_inst)
end

function TheCamera:FWD_IN_PDT_Add_Zoom_Block_Modifier(temp_inst)
    self.__fwd_in_pdt_zoom_block_modifiers[temp_inst] = true
    temp_inst:ListenForEvent("onremove",self.__fwd_in_pdt_zoom_block_modifier_on_remove_event)
end

function TheCamera:FWD_IN_PDT_Remove_Zoom_Block_Modifier(temp_inst)
    local new_table = {}
    for k, v in pairs(self.__fwd_in_pdt_zoom_block_modifiers) do
        if k ~= temp_inst then
            new_table[k] = v
        end
    end
    temp_inst:RemoveEventCallback("onremove",self.__fwd_in_pdt_zoom_block_modifier_on_remove_event)
    self.__fwd_in_pdt_zoom_block_modifiers = new_table
end

function TheCamera:FWD_IN_PDT_Is_Zoom_Blocking()
    for temp_inst, flag in pairs(self.__fwd_in_pdt_zoom_block_modifiers) do
        if temp_inst and temp_inst:IsValid() and flag then
            return true
        end
    end
    return false
end

local old_ZoomIn = TheCamera.ZoomIn
TheCamera.ZoomIn = function(self, ...)
    if self:FWD_IN_PDT_Is_Zoom_Blocking() then
        return
    end
    old_ZoomIn(self, ...)
end
local old_ZoomOut = TheCamera.ZoomOut
TheCamera.ZoomOut = function(self, ...)
    if self:FWD_IN_PDT_Is_Zoom_Blocking() then
        return
    end
    old_ZoomOut(self, ...)
end