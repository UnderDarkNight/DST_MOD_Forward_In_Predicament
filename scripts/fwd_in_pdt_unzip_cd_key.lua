-- local json = require("modules.dkjson")

local dict_str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$^&()_+-=<>"
local dict = {}
for i = 1, #dict_str do
    dict[i-1] = dict_str:sub(i, i)
end
local dict_len = #dict

local dict_index = {}
for k, v in pairs(dict) do
    dict_index[v] = k
end



local function use_dict_zip(input)
    --[[
        得到一串文本 ，例如"2079168401020279208115962174055021071490090316841684045916410506189920671485108914671566164106790459217314850281027513511351167922342173"
        以 cursor_index = 1 开始，获取后一个字符数字，拼合后，如果小于字典长度，则直接转换，如果大于，则直接使用当前指示的数字。
        如果当前 指示的数字是 文本0，则不拼合后一个字符。
    ]]--
    local ret_str = ""
    local cursor_index = 1
    while cursor_index <= #input do
        local current_number_str = string.sub(input, cursor_index, cursor_index)
        local current_number = tonumber(current_number_str)
        if current_number == 0 then
            cursor_index = cursor_index + 1
            ret_str = ret_str .. dict[current_number]
        else
            local cursor_next = cursor_index + 1
            if cursor_next <= #input then
                local next_number_str = string.sub(input, cursor_next, cursor_next)
                local next_number = tonumber(next_number_str)
                local ret_number = current_number * 10 + next_number
                if ret_number < dict_len then
                    ret_str = ret_str .. dict[ret_number]
                    cursor_index = cursor_next + 1
                else
                    ret_str = ret_str .. dict[current_number]
                    cursor_index = cursor_next
                end
            else
                ret_str = ret_str .. dict[current_number]
                cursor_index = cursor_next
            end
        end

    end
    return ret_str
end

local function use_dict_unzip(input)
    --[[
        根据上面的规则逆向解压。        
    ]]--
    local ret_str = ""
    for i = 1, #input, 1 do
        local temp_str = string.sub(input, i, i)
        local temp_number_str = dict_index[temp_str]
        ret_str = ret_str .. temp_number_str
    end
    return ret_str
end

local function zip_cdkey(cd_key_str)
    ------------------------------
    --- 输入的CDK绝对是可用经过json解码的。得到内部数字组。
    local cd_key_numbers = json.decode(cd_key_str)
    ------------------------------
    --- 
    local ret_number_str = {}
    -- 取4位数，不够就前置补充0
    for i = 1, #cd_key_numbers do
        local number = cd_key_numbers[i]
        local number_str = string.format("%04d", number)
        table.insert(ret_number_str, number_str)
    end
    local ret_key = table.concat(ret_number_str)
    ------------------------------
    --- 
    local ret_key_str = use_dict_zip(ret_key)
    -- print(ret_key_str)
    ------------------------------
    return "CDK:" .. ret_key_str
end

local function unzip_cdkey(cd_key_str)
    --- 先判断开头是不是"CDK:"
    if string.sub(cd_key_str, 1, 4) == "CDK:" then
        -- 进入解压缩操作。
        local temp_str = string.sub(cd_key_str, 5)
        --------------------------------------------------
        --- 根据得到的长串文本，根据字典逆向数字拼合成一长串数字文本
        temp_str = use_dict_unzip(temp_str)
        --------------------------------------------------
        ---
        local cd_key_numbers = {}
        for i = 1, #temp_str, 4 do
            local number_str = string.sub(temp_str, i, i + 3)
            local number = tonumber(number_str)
            table.insert(cd_key_numbers, number)
        end
        return json.encode(cd_key_numbers)
        --------------------------------------------------
    else
        return cd_key_str
    end
end

return function(input)
    local crash_flag ,ret = pcall(unzip_cdkey, input)
    if crash_flag then
        return ret
    else
        return input
    end
end