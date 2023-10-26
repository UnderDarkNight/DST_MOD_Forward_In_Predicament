local Prefabs_addr = {}
local Prefabs_addr_base = "scripts/prefabs/02_fwd_in_pdt_materials/"
local Prefabs_name_list = {

    "01_tree_resin",            -- 树脂
    "02_snake_skin",            -- 蛇皮
    "03_realgar",               -- 雄黄矿石
    "04_atractylodes_macrocephala",      -- 苍术
    "05_pinellia_ternata",               -- 半夏
    "06_aster_tataricus_l_f",            -- 紫苑

}


for k, v in pairs(Prefabs_name_list) do
    local ret_add = Prefabs_addr_base..v..".lua"
    table.insert(Prefabs_addr,ret_add)
end


local test = require("prefabs/Lua_MainLoad_Fn")
local Fx = test()
local ret_Prefabs = Fx:MainFn(Prefabs_addr)

return unpack(ret_Prefabs)		---- unpack for the modmian.lua
