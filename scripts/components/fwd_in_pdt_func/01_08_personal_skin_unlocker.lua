------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 根据本地数据注册皮肤给玩家使用
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    function self:Personal_Skin_Unlocker_Save_Data(skins)
        if type(skins) == "table" then
            self:Set_Cross_Archived_Data("skins",skins)
        end
    end
    function self:Personal_Skin_Unlocker_Refresh()
        local skins = self:Get_Cross_Archived_Data("skins") or {}
        local unlock_commands = {}
        local need_2_start_unlock = false
        for k, skin_name in pairs(skins) do
            local skin_cmd_table = FWD_IN_PDT_MOD_SKIN.SKINS_DATA[tostring(skin_name)] or {}
            local prefab_name = skin_cmd_table.prefab_name
            if skin_name and prefab_name and not self:SkinAPI__Has_Skin(skin_name,prefab_name) then
                need_2_start_unlock = true
                unlock_commands[prefab_name] = unlock_commands[prefab_name] or {}
                table.insert(unlock_commands[prefab_name],skin_name)
            end
        end
        if need_2_start_unlock then
            self:SkinAPI__Unlock_Skin(unlock_commands)
        end
    end

    self:Add_Cross_Archived_Data_Special_Onload_Fn(function()
        self:Personal_Skin_Unlocker_Refresh()
    end)

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(self)
    
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(self)
    if self.inst == nil or not self.inst:HasTag("player") then    --- 本系统只注册给玩家。 不能在这检查 userid ，不然初始化失败
        return
    end
    self:Init("cross_archived_data_sys")
    if self.is_replica ~= true then        --- 不是replica
        main_com(self)
    else      
        replica(self)
    end
end