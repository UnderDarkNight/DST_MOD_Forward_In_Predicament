




-- local old_UnregisterComponentActions = EntityScript.UnregisterComponentActions
-- EntityScript.UnregisterComponentActions = function(...)
--     -- print("fwd_in_pdt_test UnregisterComponentActions",...)
--     local crash_flg = pcall(old_UnregisterComponentActions,...)
--     if not crash_flg then
--         print("fwd_in_pdt error : UnregisterComponentActions",...)
--     end
-- end

local old_UnregisterComponentActions = rawget(EntityScript,"UnregisterComponentActions")
rawset(EntityScript, "UnregisterComponentActions", function(...)
        -- print("fwd_in_pdt_test UnregisterComponentActions",...)
    local crash_flg = pcall(old_UnregisterComponentActions,...)
    if not crash_flg then
        print("fwd_in_pdt error : UnregisterComponentActions",...)
    end
end)