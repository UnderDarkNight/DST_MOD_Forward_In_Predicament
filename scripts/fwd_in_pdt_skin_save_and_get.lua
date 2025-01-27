

local function GetData(sheet,index,default)
    local data = {}
    TheSim:GetPersistentString(sheet, function(load_success, str_data)
        if load_success and str_data then
            local crash_flag,temp_data = pcall(json.decode,str_data)
            if crash_flag then
                data = temp_data
            end
        end
    end)
    return data[index] or default
end
local function SetData(sheet,index,value)
    local data = {}
    TheSim:GetPersistentString(sheet, function(load_success, str_data)
        if load_success and str_data then
            local crash_flag,temp_data = pcall(json.decode,str_data)
            if crash_flag then
                data = temp_data
            end
        end
    end)
    data[index] = value
    local str = json.encode(data)
    TheSim:SetPersistentString(sheet, str, false, function()
        -- print("info fwd_in_pdt. skin SAVED!")
    end)
end

local skin_data_sheet = "fwd_in_pdt_skin_data"
local function GetAllSkinDataByUserid(userid)
    return GetData(skin_data_sheet,userid,{}) or {}
end
local function SaveSkinKeyForPlayer(userid,skin_key)
    local all_skin_data = GetAllSkinDataByUserid(userid)
    all_skin_data[skin_key] = true
    SetData(skin_data_sheet,userid,all_skin_data)
end

return {
    GetAllSkinDataByUserid = GetAllSkinDataByUserid,
    SaveSkinKeyForPlayer = SaveSkinKeyForPlayer,
}