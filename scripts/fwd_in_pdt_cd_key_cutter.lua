----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    本文件用来处理 饥荒 RPC 传送信道 不能传送过长的 CDK内容的问题。

    以50个数字为 一组，把长CDK 切割，并合并。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local CUT_NUM = 50
local function cut_cdk(cd_key_str)
    local cd_key_table = json.decode(cd_key_str)
    local cut_table = {}
    local table_num = math.ceil(#cd_key_table / CUT_NUM)
    for i = 1, table_num do
        local start = (i - 1) * CUT_NUM + 1
        local end_ = i * CUT_NUM
        local cut = {}
        for j = start, end_ do
            cut[#cut + 1] = cd_key_table[j]
        end
        cut_table[#cut_table + 1] = cut
    end
    return cut_table
end

local function merge_cdk(cut_table)
    local cd_key_table = {}
    for i, cut in ipairs(cut_table) do
        for j, num in ipairs(cut) do
            cd_key_table[#cd_key_table + 1] = num
        end
    end
    return json.encode(cd_key_table)
end

return {
    cut_cdk = cut_cdk,
    merge_cdk = merge_cdk
}