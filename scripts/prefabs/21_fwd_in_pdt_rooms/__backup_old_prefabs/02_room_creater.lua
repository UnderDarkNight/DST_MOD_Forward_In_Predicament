local assets = {
}


local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("fwd_in_pdt_room_creater")

    if not TheWorld.ismastersim then
        return inst
    end

    local function exchange_tile_map(_table)
        -------- 坐标信息数据转换，方便代码阅读  由原来的一维数组转换成二维数组
        -------- 坐标数据会有时候产生Y轴镜像，留API自由处理
        -------- tile_map[y][x]
        local tile_map = {}
        if _table.y_mirror == true then

                    local temp_x ,temp_y= 1,1
                    for i, the_ground in ipairs(_table.data) do
                        tile_map[temp_y] = tile_map[temp_y] or {}
                        tile_map[temp_y][temp_x] = the_ground
                        if i % _table.width == 0 then
                            temp_y = temp_y + 1
                            temp_x = 1
                        else
                            temp_x = temp_x + 1
                        end
                    end

        else                               
                    local temp_x ,temp_y= _table.width,1    --- 反向处理
                    for i, the_ground in ipairs(_table.data) do
                        tile_map[temp_y] = tile_map[temp_y] or {}
                        tile_map[temp_y][temp_x] = the_ground
                        if i % _table.width == 0 then
                            temp_y = temp_y + 1
                            temp_x = _table.width --- 反向处理
                        else
                            temp_x = temp_x - 1  --- 反向处理
                        end
                    end
        end
        return tile_map
    end

    ----------------------------------------------------------------------------
    ----- 使用event Set 进入命令表，生成 地形和删除本inst
    inst:ListenForEvent("Set",function(inst,_table)
        ------ 1个地皮为 4X4距离，  （0,0,0）坐标为  田字中心
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     width = 15,
        --     height = 15,
        --     data = {},                      --- data 来自 tiled.exe 生成的字符串（导出）。-- tiled软件里，单个地块用 64x64 pix，然后载入饥荒地皮资源 ground.tsx。导出后直接复制字符串过来
        --     y_mirror = nil or true,         --- Y轴镜像
        -- }

        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then   ------ 往地皮中心点放
            local mid_tile_x , mid_tile_z = TheWorld.Map:GetTileCoordsAtPoint(_table.pt.x,0,_table.pt.z)
            inst.Transform:SetPosition(mid_tile_x,0,mid_tile_z)
        end

        local pt = Vector3(inst.Transform:GetWorldPosition())
        local tile_map = exchange_tile_map(_table)
        for z = 1, _table.height, 1 do
            for x = 1, _table.width, 1 do
                local target_tile = tile_map[z][x]
                if target_tile ~= 0 then
                    local target_location_x = pt.x + 4*x
                    local target_location_z = pt.z + 4*z
                    local tile_x ,tile_z = TheWorld.Map:GetTileCoordsAtPoint(target_location_x,0,target_location_z)
                    TheWorld.Map:SetTile(tile_x ,tile_z,target_tile)
                end
            end
        end


        if _table.ents then
            for k, temp_cmd_table in pairs(_table.ents) do
               if temp_cmd_table and temp_cmd_table.data then
                    ----- 内部生成
                            temp_cmd_table.width = _table.width
                            temp_cmd_table.height = _table.height
                            temp_cmd_table.y_mirror = temp_cmd_table.y_mirror
                            local temp_tile_table = exchange_tile_map(temp_cmd_table)

                            for z = 1, _table.height, 1 do
                                for x = 1, _table.width, 1 do
                                    local temp_target_tile = temp_tile_table[z][x]
                                    local temp_target_location_x = pt.x + 4*x
                                    local temp_target_location_z = pt.z + 4*z
                                    if temp_cmd_table.fns and temp_cmd_table.fns[temp_target_tile] then
                                        temp_cmd_table.fns[temp_target_tile]( Vector3(temp_target_location_x,temp_target_location_z)  )  
                                    end
                                end
                            end
                    ------------------------
               end
            end
        end

        if _table.mind_fn then
            local midx = ( (_table.width - 1) * 4 )/2
            local midz = ( (_table.height -1) * 4 )/2 
            _table.mind_fn(Vector3(midx,0,midz))
        end

        inst:Remove()
    end)



    inst:DoTaskInTime(0,inst.Remove)
    return inst
end

return Prefab("fwd_in_pdt_room_creater",fx,assets)


-------- 使用示例：
