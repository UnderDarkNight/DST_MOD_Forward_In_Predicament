----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    测试解密


    local public_key = {e = 5, n = 2291}      -- 可公开给MOD


    
]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- local json = require("modules.dkjson")

-- 最大公约数
local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

-- 扩展欧几里得算法，用于计算模逆元
local function extended_gcd(a, b)
    if a == 0 then
        return b, 0, 1
    else
        local g, y, x = extended_gcd(b % a, a)
        return g, x - math.floor(b / a) * y, y
    end
end

-- 计算模逆元
local function mod_inverse(e, phi)
    local g, x, _ = extended_gcd(e, phi)
    if g ~= 1 then
        error("Modular inverse does not exist")
    else
        return (x % phi + phi) % phi
    end
end

-- 快速幂取模
local function pow_mod(base, exp, mod)
    local result = 1
    base = base % mod
    while exp > 0 do
        if exp % 2 == 1 then
            result = (result * base) % mod
        end
        exp = math.floor(exp / 2)
        base = (base * base) % mod
    end
    return result
end

-- 生成 RSA 密钥对
local function generate_keypair(p, q)
    local n = p * q
    local phi = (p - 1) * (q - 1)
    local e = 3
    while gcd(e, phi) ~= 1 do
        e = e + 1
    end
    local d = mod_inverse(e, phi)
    return {e = e, n = n}, {d = d, n = n}
end

-- 私钥加密单个字符
local function private_encrypt_char(char, private_key)
    local d, n = private_key.d, private_key.n
    local char_num = string.byte(char)
    local encrypted_num = pow_mod(char_num, d, n)
    return encrypted_num
end

-- 私钥加密消息
local function private_encrypt_message(message, private_key)
    local encrypted_message = {}
    for i = 1, #message do
        local char = string.sub(message, i, i)
        local encrypted_char = private_encrypt_char(char, private_key)
        table.insert(encrypted_message, encrypted_char)
    end
    return encrypted_message
end

-- 公钥解密单个字符
local function public_decrypt_char(num, public_key)
    local e, n = public_key.e, public_key.n
    local decrypted_num = pow_mod(num, e, n)
    return string.char(decrypted_num)
end

-- 公钥解密消息
local function public_decrypt_message(encrypted_message, public_key)
    local decrypted_message = ""
    for _, num in ipairs(encrypted_message) do
        local decrypted_char = public_decrypt_char(num, public_key)
        decrypted_message = decrypted_message .. decrypted_char
    end
    return decrypted_message
end

-- 判断一个数是否为质数
local function is_prime(num)
    if num < 2 then
        return false
    end
    for i = 2, math.sqrt(num) do
        if num % i == 0 then
            return false
        end
    end
    return true
end

-- 生成一个指定范围内的随机质数
local function generate_random_prime(min, max)
    local num
    repeat
        num = math.random(min, max)
    until is_prime(num)
    return num
end

-- 生成 p 和 q
local function generate_pq()
    -- 设定一个合适的范围，这里选择 10 到 100 之间
    local min = 10
    local max = 100
    local p, q
    repeat
        p = generate_random_prime(min, max)
        q = generate_random_prime(min, max)
    until p ~= q
    return p, q
end


-- -- 维吉尼亚加密函数
-- local function vigenere_encrypt(plaintext, key)
--     local encrypted = ""
--     local key_length = #key
--     for i = 1, #plaintext do
--         local plain_char = string.byte(plaintext, i)
--         local key_char = string.byte(key, ((i - 1) % key_length) + 1)
--         local encrypted_char = (plain_char + key_char) % 256
--         encrypted = encrypted .. string.char(encrypted_char)
--     end
--     return encrypted
-- end

-- 维吉尼亚解密函数
local function vigenere_decrypt(ciphertext, key)
    local decrypted = ""
    local key_length = #key
    for i = 1, #ciphertext do
        local cipher_char = string.byte(ciphertext, i)
        local key_char = string.byte(key, ((i - 1) % key_length) + 1)
        local decrypted_char = (cipher_char - key_char + 256) % 256
        decrypted = decrypted .. string.char(decrypted_char)
    end
    return decrypted
end


local public_key = {e = 5, n = 2291}      -- 可公开给MOD
local real_decrypted_fn = function(userid,str_data)
    local encrypted_message = json.decode(str_data)
    --- 先用RSA解密
    local temp_data = public_decrypt_message(encrypted_message, public_key)
    --- 再用维吉尼亚解密
    local decrypted_message = vigenere_decrypt(temp_data, userid)
    return decrypted_message
end

local function reald_decryption(userid,cd_key)
    
    userid = tostring(userid)
    cd_key = tostring(cd_key)
    -- print("reald_decryption enter key",cd_key)

    local crash_flag,decrypted_message = pcall(real_decrypted_fn,userid,cd_key)
    if not crash_flag then
        print("cdk error")
        print(decrypted_message)
        return {}
    end

    local crash_flag,data = pcall(json.decode,decrypted_message)
    if not crash_flag then
        print("json error")
        return {}
    end
    data = data or {}

    -- print(userid.." Is VIP :",data.vip or false)
    -- for k, v in pairs(data.skins or {}) do
    --     print(k,v)
    -- end
    return data
end

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
    reald_decryption = reald_decryption,
    VIP_SetData = SetData,
    VIP_GetData = GetData
}