------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    修改选角色的时候的 三维显示图标
    
    widgets/redux/characterselect



]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AddClassPostConstruct("widgets/redux/characterselect", function(self, owner, character_widget_ctor, character_widget_size, character_description_getter_fn, default_character, cbPortraitHighlighted, cbPortraitSelected, additionalCharacters, scrollbar_offset, custom_character_details_widget)
    
--     TUNING.test_widget = self.selectedportrait

-- end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function change_widget(status,character,status_name)
        if character == "fwd_in_pdt_cyclone" then
            if status_name == "health" then
                status.status_icon:SetTexture("images/widget/fwd_in_pdt_widget_cyclone_hud.xml", "fwd_in_pdt_widget_hud_cyclone_health.tex")
            elseif status_name == "hunger" then
                status.status_icon:SetTexture("images/widget/fwd_in_pdt_widget_cyclone_hud.xml", "fwd_in_pdt_widget_hud_cyclone_hunger.tex")
            end
        end

        -- if status_name == "health" and character == "moonlightcoda" then
        --     -- status:Hide()
        --     --[[
        --         status.status_icon = status:AddChild(Image())
        --         status.status_icon    --- 三维的图标

        --     ]]---
        --     -- status.status_icon:Hide()
        --     -- status.status_icon:SetTexture("images/global_redux.xml", "status_".."hunger"..".tex")

        -- else
        --     -- status:Show()
        --     -- status.status_icon:SetTexture("images/global_redux.xml", "status_"..status_name..".tex")
        --     -- status.status_icon:Show()
        -- end
    end

    local TEMPLATES = require("widgets/redux/templates")

    local old_MakeUIStatusBadge = TEMPLATES.MakeUIStatusBadge
    TEMPLATES.MakeUIStatusBadge = function(_status_name, c)
        local status = old_MakeUIStatusBadge(_status_name, c)
        local old_status_ChangeCharacter = status.ChangeCharacter
        status.ChangeCharacter = function(self, character)
            local status_name = TUNING.CHARACTER_DETAILS_OVERRIDE[character.."_".._status_name] or _status_name
            old_status_ChangeCharacter(self, character)
            change_widget(status,character,status_name) 
        end
        return status
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

