------------------------------------------------------------------------------------------
---- 先 hook worldmigrator 组件
------------------------------------------------------------------------------------------

AddComponentPostInit("worldmigrator", function(self)   ------ hook 
    if not TheWorld.ismastersim then
        return
    end
    self.inst:AddTag("fwd_in_pdt_tag.worldmigrator")
end)

------------------------------------------------------------------------------------------
----- 延迟创建洞口
AddPrefabPostInit(
    "world",
    function(inst)

        if not TheWorld.ismastersim then
            return
        end

        if inst.components.fwd_in_pdt_data == nil then
            inst:AddComponent("fwd_in_pdt_data")
        end


        inst:DoTaskInTime(0,function()
            local fwd_in_pdt_cave_hole = TheSim:FindFirstEntityWithTag("fwd_in_pdt_test_cave_door")
            if fwd_in_pdt_cave_hole ~= nil then
                print("自制洞口已经存在，不需要再创建。")
                return  ------ 已经创建有了，不用再创建了                
            end


            local cave_hole = TheSim:FindFirstEntityWithTag("fwd_in_pdt_tag.worldmigrator")
            print("info : fwd_in_pdt_tag.worldmigrator" ,cave_hole)
            if cave_hole then          --------- 判断是否存在洞穴出入口      
                local door= TheSim:FindFirstEntityWithTag("multiplayer_portal")
                if door then
                    local x,y,z = door.Transform:GetWorldPosition()
                    SpawnPrefab("fwd_in_pdt_test_cave_door").Transform:SetPosition(x+10, 0, z+10)
                end
            end

            

        end)
    end
)
------------------------------------------------------------------------------------------