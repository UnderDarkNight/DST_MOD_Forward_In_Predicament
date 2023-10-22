----------------------------------------------------------------------
---- 更新 TheWorld.Map 相关函数
----------------------------------------------------------------------


AddPrefabPostInit(
    "world",
    function(inst)

        if not TheWorld.ismastersim then
            return
        end
        if inst.components.fwd_in_pdt_data == nil then
            inst:AddComponent("fwd_in_pdt_data")
        end
        if inst.components.fwd_in_pdt_func == nil then
            inst:AddComponent("fwd_in_pdt_func"):Init(TUNING["Forward_In_Predicament.World_Com_Func"])  
        end
    end
)

-- local Room_Radius = 15
-- require "components/map"

-- local function Check_In_The_Room(x,y,z)
--     if #TheSim:FindEntities(x, 0, z, Room_Radius, {"fwd_in_pdt_room_background"}, nil, nil) > 0 then
--         return true
--     else
--         return false
--     end
-- end
-- ------------------------------------------------------------------------------------------------------------------------
-- ------ 种植
-- Map.CanPlantAtPoint_old_fwd_in_pdt = Map.CanPlantAtPoint
-- Map.CanPlantAtPoint = function(self,x,y,z,...)
--     if Check_In_The_Room(x,y,z) then
--         return false
--     else
--         return self:CanPlantAtPoint_old_fwd_in_pdt(x,y,z,...)
--     end
-- end

-- ------------------------------------------------------------------------------------------------------------------------
-- ---- 挖田地
-- Map.CanTillSoilAtPoint__old_fwd_in_pdt = Map.CanTillSoilAtPoint
-- Map.CanTillSoilAtPoint = function(self,x,y,z,...)
--     if Check_In_The_Room(x,y,z) then
--         return false
--     else
--         return self:CanTillSoilAtPoint__old_fwd_in_pdt(x,y,z,...)
--     end
-- end
-- ------------------------------------------------------------------------------------------------------------------------
-- ---- 挖地皮
-- Map.CanTerraformAtPoint__old_fwd_in_pdt = Map.CanTerraformAtPoint
-- Map.CanTerraformAtPoint = function(self,x,y,z,...)
--     if Check_In_The_Room(x,y,z) then
--         return false
--     else
--         return self:CanTerraformAtPoint__old_fwd_in_pdt(x,y,z,...)
--     end
-- end
-- ------------------------------------------------------------------------------------------------------------------------
-- ---- 种地皮
-- Map.CanPlaceTurfAtPoint__old_fwd_in_pdt = Map.CanPlaceTurfAtPoint
-- Map.CanPlaceTurfAtPoint = function(self,x,y,z,...)
--     if Check_In_The_Room(x,y,z) then
--         return false
--     else
--         return self:CanPlaceTurfAtPoint__old_fwd_in_pdt(x,y,z,...)
--     end
-- end
-- ------------------------------------------------------------------------------------------------------------------------
-- ---- 种地皮
-- Map.IsFarmableSoilAtPoint__old_fwd_in_pdt = Map.IsFarmableSoilAtPoint
-- Map.IsFarmableSoilAtPoint = function(self,x,y,z,...)
--     if Check_In_The_Room(x,y,z) then
--         return false
--     else
--         return self:IsFarmableSoilAtPoint__old_fwd_in_pdt(x,y,z,...)
--     end
-- end