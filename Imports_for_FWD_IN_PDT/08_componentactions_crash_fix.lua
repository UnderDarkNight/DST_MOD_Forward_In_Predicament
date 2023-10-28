




-- local old_UnregisterComponentActions = EntityScript.UnregisterComponentActions
-- EntityScript.UnregisterComponentActions = function(...)
--     -- print("fwd_in_pdt_test UnregisterComponentActions",...)
--     local crash_flg = pcall(old_UnregisterComponentActions,...)
--     if not crash_flg then
--         print("fwd_in_pdt error : UnregisterComponentActions",...)
--     end
-- end

if GLOBAL.EntityScript.UnregisterComponentActions_fwd_in_pdt_old == nil then
    rawset(GLOBAL.EntityScript,"UnregisterComponentActions_fwd_in_pdt_old",rawget(GLOBAL.EntityScript,"UnregisterComponentActions"))
    rawset(GLOBAL.EntityScript, "UnregisterComponentActions", function(self,...)
            -- print("fwd_in_pdt_test UnregisterComponentActions",self,...)
        local crash_flg = pcall(self.UnregisterComponentActions_fwd_in_pdt_old,...)
        if not crash_flg then
            print("fwd_in_pdt error : UnregisterComponentActions",self,...)
        end
    end)
end