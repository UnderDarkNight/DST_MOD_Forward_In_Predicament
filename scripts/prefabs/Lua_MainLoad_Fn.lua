-- The code for this lua was written by 幕夜之下
-- Please use without any restrictions




local function Fn()
    local Fx = Class()
    local function Load_lua_file_2_prefabs_table(tempAddr)
        local function self_load_file_to_prefabs_by_pcall(pcall_retFlag,...)
            local ret_prefabs_table = {}
            local arg = {...}
            if pcall_retFlag == true then
                for i, v in ipairs(arg) do
                    if v then
                        table.insert(ret_prefabs_table,v)
                    end
                end
            else
                print("Error : Load lua file error : ")
                print("Error:  "..tostring(tempAddr))
                for k, v in pairs(arg) do
                    if v then
                        print("Error:  "..v)
                    end
                end
            end
            return ret_prefabs_table
        end


        local lua_file = loadfile(tempAddr)   ---- load lua file
        local temp_prefabs = self_load_file_to_prefabs_by_pcall(pcall(lua_file))


        return temp_prefabs
    end

    function Fx:MainFn(lua_addr_list)
        local All_prefabs = {}
        for i, tempAddr in pairs(lua_addr_list) do
            local temp_ret_prefabs = Load_lua_file_2_prefabs_table(tempAddr)
            for k, v in pairs(temp_ret_prefabs) do
                table.insert(All_prefabs,v)
            end
        end
        return All_prefabs
    end



    return Fx
end


return Fn