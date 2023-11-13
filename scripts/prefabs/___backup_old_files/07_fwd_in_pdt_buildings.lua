local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/07_fwd_in_pdt_buildings/"
local Prefabs_name_list = {

    "01_banner_light",      --- 幡灯
    "02_special_shop",      --- 特殊商店
    "03_materials_shop",      --- 材料商店
    "04_cuisines_shop",      --- 美食店
    "05_hotel",             -- 旅馆

    "06_medical_check_up_machine",             -- 健康检查机

    "07_paddy_windmill",             -- 稻田风车
    "08_pawnshop",                   -- 当铺
    "09_atm",                        -- ATM
    "10_bulletin_board",             -- 公告板
    
    "11_hospital",                   -- 医院
    "12_doll_clamping_machine",      -- 娃娃机

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
