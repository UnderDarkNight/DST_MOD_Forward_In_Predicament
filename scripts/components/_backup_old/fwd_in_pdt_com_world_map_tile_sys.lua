----------------------------------------------------------------------------------------------------------------------------------
--[[

     笔记：
        获取地图WH ：local map_width,map_height = TheWorld.Map:GetSize()
        获取地皮XY : local tx, ty = TheWorld.Map:GetTileXYAtPoint(px, py, pz)  --   tx : 1 ~ map_width     ty : 1 ~ map_height

        

]]--
----------------------------------------------------------------------------------------------------------------------------------
local fwd_in_pdt_com_world_map_tile_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function fwd_in_pdt_com_world_map_tile_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function fwd_in_pdt_com_world_map_tile_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function fwd_in_pdt_com_world_map_tile_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function fwd_in_pdt_com_world_map_tile_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function fwd_in_pdt_com_world_map_tile_sys:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function fwd_in_pdt_com_world_map_tile_sys:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function fwd_in_pdt_com_world_map_tile_sys:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
----- 一些基础的API
    ---- 根据世界坐标得到地皮坐标
        function fwd_in_pdt_com_world_map_tile_sys:Get_World_Point_By_Tile_XY(tx,ty)
            local map_width,map_height = self:GetMapTileSize()
            local ret_x = tx - map_width/2
            local ret_z = ty - map_height/2
            return Vector3(ret_x*TILE_SCALE,0,ret_z*TILE_SCALE),self:Is_Tile_XY_OverSize(tx,ty)
        end
    ---- 根据世界坐标得到地皮坐标
        function fwd_in_pdt_com_world_map_tile_sys:Get_Tile_XY_By_World_Point(vec_3_or_x,yy,zz)
            local x,y,z
            if type(vec_3_or_x) == type(Vector3(0,0,0)) then
                x,y,z = vec_3_or_x.x,vec_3_or_x.y,vec_3_or_x.z
            else
                x,y,z = vec_3_or_x,yy,zz
            end
            local tx, ty = TheWorld.Map:GetTileXYAtPoint(x,y,z)
            return tx,ty,self:Is_Tile_XY_OverSize(tx,ty)
        end
    ---- 获取地图尺寸
        function fwd_in_pdt_com_world_map_tile_sys:GetMapTileSize()
            local map_width,map_height = TheWorld.Map:GetSize()
            return map_width,map_height
        end
    --- 判断地皮坐标是否超出地图
        function fwd_in_pdt_com_world_map_tile_sys:Is_Tile_XY_OverSize(tx,ty)
            local map_width,map_height = self:GetMapTileSize()
            local oversize = false --- 超出地图区域
            if tx < 1 or tx > map_width or ty < 1 or ty > map_height then
                oversize = true
            end
            return oversize
        end
    ---- addtag 给指定地块 添加 tag
        function fwd_in_pdt_com_world_map_tile_sys:Add_Tag_To_Tile_XY(tx,ty,tag)
            if type(tag) ~= "string" then
                return
            end
            local pt,oversize = self:Get_World_Point_By_Tile_XY(tx,ty)
            if oversize then --- 超出尺寸
                return
            end
            local node_index = TheWorld.Map:GetNodeIdAtPoint(pt.x, 0, pt.z) or 0
            local node = TheWorld.topology.nodes[node_index]
            if type(node) ~= "table" then
                return
            end
            if type(node.tags) ~= "table" then
                return
            end
            if table.contains(node.tags,tag) then
                return
            end
            table.insert(node.tags,tag)
        end
    ---- 给指定坐标的地皮添加 tag
        function fwd_in_pdt_com_world_map_tile_sys:Add_Tag_To_Tile_By_Point(vec3_or_x,y_or_tag,zz,temp_tag)  -- 做自适应
            local tag = nil
            local x,y,z
            if type(vec3_or_x) == type(Vector3(0,0,0)) then
                x,y,z = vec3_or_x.x,vec3_or_x.y,vec3_or_x.z
                tag = y_or_tag
            else
                x,y,z = vec3_or_x,y_or_tag,zz
                tag = temp_tag
            end
            if not (x and y and z and type(tag) == "string" ) then
                return
            end

            local node_index = TheWorld.Map:GetNodeIdAtPoint(x, 0, z) or 0
            local node = TheWorld.topology.nodes[node_index]
            if type(node) ~= "table" then
                return
            end
            if type(node.tags) ~= "table" then
                return
            end
            if table.contains(node.tags,tag) then
                return
            end
            table.insert(node.tags,tag)
        end
    ---- 移除tag 靠地块xy
        function fwd_in_pdt_com_world_map_tile_sys:Remove_Tag_From_Tile_XY(tx,ty,tag)
            if type(tag) ~= "string" then
                return
            end
            local pt,oversize = self:Get_World_Point_By_Tile_XY(tx,ty)
            if oversize then --- 超出尺寸
                return
            end
            local node_index = TheWorld.Map:GetNodeIdAtPoint(pt.x, 0, pt.z) or 0
            local node = TheWorld.topology.nodes[node_index]
            if type(node) ~= "table" then
                return
            end
            if type(node.tags) ~= "table" then
                return
            end
            if not table.contains(node.tags,tag) then -- 当前地块 没这个 tag
                return
            end
            local new_table = {}
            for k,v in pairs(node.tags) do
                if v ~= tag then
                    table.insert(new_table,v)                    
                end
            end
            node.tags = new_table
        end
    ---- 移除tag 、靠坐标
        function fwd_in_pdt_com_world_map_tile_sys:Remove_Tag_From_Tile_By_Point(vec3_or_x,y_or_tag,zz,temp_tag)  -- 做自适应
            local tag = nil
            local x,y,z
            if type(vec3_or_x) == type(Vector3(0,0,0)) then
                x,y,z = vec3_or_x.x,vec3_or_x.y,vec3_or_x.z
                tag = y_or_tag
            else
                x,y,z = vec3_or_x,y_or_tag,zz
                tag = temp_tag
            end
            local node_index = TheWorld.Map:GetNodeIdAtPoint(x, 0, z) or 0
            local node = TheWorld.topology.nodes[node_index]
            if type(node) ~= "table" then
                return
            end
            if type(node.tags) ~= "table" then
                return
            end
            if not table.contains(node.tags,tag) then
                return
            end
            local new_table = {}
            for k,v in pairs(node.tags) do
                if v ~= tag then
                    table.insert(new_table,v)
                end
            end
            node.tags = new_table
        end
------------------------------------------------------------------------------------------------------------------------------
----- 
------------------------------------------------------------------------------------------------------------------------------
----- 数据的储存
    function fwd_in_pdt_com_world_map_tile_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function fwd_in_pdt_com_world_map_tile_sys:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
-----

------------------------------------------------------------------------------------------------------------------------------
return fwd_in_pdt_com_world_map_tile_sys

