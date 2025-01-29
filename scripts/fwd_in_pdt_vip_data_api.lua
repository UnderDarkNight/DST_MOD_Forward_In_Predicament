
------------------------------------------------------------------------------------------------------
local function GetData(index,default)
    local data = {}
    TheSim:GetPersistentString(index, function(load_success, str_data)
        if load_success and str_data then
            local crash_flag,temp_data = pcall(json.decode,str_data)
            if crash_flag then
                data = temp_data
            end
        end
    end)
    return data[index] or default
end
local function SetData(index,value)
    local data = {}
    TheSim:GetPersistentString(index, function(load_success, str_data)
        if load_success and str_data then
            local crash_flag,temp_data = pcall(json.decode,str_data)
            if crash_flag then
                data = temp_data
            end
        end
    end)
    data[index] = value
    local str = json.encode(data)
    TheSim:SetPersistentString(index, str, false, function()
        print("info fwd_in_pdt.vip SAVED!")
    end)
end
------------------------------------------------------------------------------------------------------
return {
    VIP_SetData = SetData,
    VIP_GetData = GetData
}