-- GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --
--     -- local ServerCreationScreen = require "screens/servercreationscreen"
--     -- if ServerCreationScreen.__test_old_Create == nil then
--     --     ServerCreationScreen.__test_old_Create = ServerCreationScreen.Create
--     --     ServerCreationScreen.Create = function(self, ...)
--     --         print("INFO ############ CREATE")
--     --         return self.__test_old_Create(self, ...)
--     --     end
--     -- end
--     -- AddGlobalClassPostConstruct("screens/servercreationscreen", "ServerCreationScreen", function(self)
--     --     print("INFO ############ CREATE")
--     --     local old_Create = self.Create
--     --     self.Create = function(self, ...)
--     --         print("fake error  ############ CREATE")
--     --         return old_Create(self, ...)
--     --     end
--     -- end)
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")
-- -- print(TheFrontEnd)
-- -- for k, v in pairs(TheFrontEnd) do
-- --     print(k, v)
-- -- end
-- -- local inst = CreateEntity()
-- -- inst:DoTaskInTime(10,function()
-- --     inst:Remove()
-- --     print(TheFrontEnd)
-- -- end)
-- -- print(TheFrontEnd.screenroot)

-- local inst = CreateEntity()
-- inst:DoPeriodicTask(2,function()
--     inst.num = inst.num or 0
--     inst.num = inst.num + 1


--     local ServerCreationScreen = require "screens/servercreationscreen" or {}
--     print(ServerCreationScreen.saveslot)

--     if inst.num >= 10 then
--         inst:Remove()
--     end
-- end)



-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")
-- print("fake error +++++++++++++")