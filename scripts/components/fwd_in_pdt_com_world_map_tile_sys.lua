----------------------------------------------------------------------------------------------------------------------------------
--[[

    独立的地块tag系统
    配合独立的地块 event 系统

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

    self.tile_data = {}
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
------------------------------------------------------------------------------------------------------------------------------
-----
    ---- 初始化和获取地块数据
        function fwd_in_pdt_com_world_map_tile_sys:Get_Data_By_Tile_XY(tx,ty)
            self.tile_data[tx] = self.tile_data[tx] or {}
            self.tile_data[tx][ty] = self.tile_data[tx][ty] or {
                tags = {},
            }
            return self.tile_data[tx][ty]
        end
    ---- addtag 给指定地块 添加 tag
        function fwd_in_pdt_com_world_map_tile_sys:Add_Tag_To_Tile_XY(tx,ty,tag)
            if type(tag) ~= "string" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end

            local tags = self:Get_Data_By_Tile_XY(tx,ty).tags

            if type(tags) ~= "table" then
                return
            end
            if table.contains(tags,tag) then
                return
            end
            table.insert(tags,tag)
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

            local tx, ty, oversize = self:Get_Tile_XY_By_World_Point(x,y,z)
            if oversize then --- 超出尺寸
                return
            end
            self:Add_Tag_To_Tile_XY(tx,ty,tag)
        end
    ---- 移除tag 靠地块xy
        function fwd_in_pdt_com_world_map_tile_sys:Remove_Tag_From_Tile_XY(tx,ty,tag)
            if type(tag) ~= "string" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end

            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)

            if type(tile_data.tags) ~= "table" then
                return
            end
            if not table.contains(tile_data.tags,tag) then
                return
            end
            local new_table = {}
            for k,v in pairs(tile_data.tags) do
                if v ~= tag then
                    table.insert(new_table,v)
                end
            end
            tile_data.tags = new_table
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
            if not (x and y and z and type(tag) == "string" ) then
                return
            end
            local tx, ty, oversize = self:Get_Tile_XY_By_World_Point(x,y,z)
            if oversize then --- 超出尺寸
                return
            end
            self:Remove_Tag_From_Tile_XY(tx,ty,tag)

        end
    ----- HasTag
        function fwd_in_pdt_com_world_map_tile_sys:Has_Tag_In_Tile_XY(tx,ty,tag)
            if type(tag) ~= "string" then
                return false
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return false 
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            if type(tile_data.tags) ~= "table" then
                return false
            end
            return table.contains(tile_data.tags,tag)
        end
        function fwd_in_pdt_com_world_map_tile_sys:Has_Tag_In_Point(vec3_or_x,y_or_tag,zz,temp_tag)  -- 做自适应
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
                return false
            end
            local tx, ty, oversize = self:Get_Tile_XY_By_World_Point(x,y,z)
            if oversize then --- 超出尺寸
                return false
            end
            return self:Has_Tag_In_Tile_XY(tx,ty,tag)
        end
------------------------------------------------------------------------------------------------------------------------------
----- join/leave event 地块进出相关的 event
    ---- 给地块添加 join event
        function fwd_in_pdt_com_world_map_tile_sys:Add_Join_Event_Fn_To_Tile_XY(tx,ty,fn)
            if type(fn) ~= "function" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.join_events = tile_data.join_events or {}
            tile_data.join_events[fn] = true
        end
    ---- 移除地块 join event
        function fwd_in_pdt_com_world_map_tile_sys:Remove_Join_Event_Fn_From_Tile_XY(tx,ty,fn)
            if type(fn) ~= "function" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.join_events = tile_data.join_events or {}
            tile_data.join_events[fn] = false
        end
    ---- 清空地块 join event
        function fwd_in_pdt_com_world_map_tile_sys:Clear_All_Join_Event_Fns_From_Tile_XY(tx,ty)
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.join_events = {}
        end
    ---- 激活地块的 join event
        function fwd_in_pdt_com_world_map_tile_sys:Active_Join_Fns_By_Tile_XY(player,tx,ty)
            if not (player and player:HasTag("player")) then
                return
            end
            -- print("Active_Join_Fns_By_Tile_XY",player,tx,ty)
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.join_events = tile_data.join_events or {}
            for temp_fn,flag in pairs(tile_data.join_events) do
                if temp_fn and flag then
                    temp_fn(player,tx,ty)
                end
            end
        end
    ---- 给地块添加 leave event
        function fwd_in_pdt_com_world_map_tile_sys:Add_Leave_Event_Fn_To_Tile_XY(tx,ty,fn)
            if type(fn) ~= "function" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.leave_events = tile_data.leave_events or {}
            tile_data.leave_events[fn] = true
        end
    ---- 移除地块 leave event
        function fwd_in_pdt_com_world_map_tile_sys:Remove_Leave_Event_Fn_From_Tile_XY(tx,ty,fn)
            if type(fn) ~= "function" then
                return
            end
            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.leave_events = tile_data.leave_events or {}
            tile_data.leave_events[fn] = false
        end
    ---- 清空地块 leave event
        function fwd_in_pdt_com_world_map_tile_sys:Clear_All_Leave_Event_Fns_From_Tile_XY(tx,ty)
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.leave_events = {}
        end
    ---- 激活地块的 leave event
        function fwd_in_pdt_com_world_map_tile_sys:Active_Leave_Fns_By_Tile_XY(player,tx,ty)
            if not (player and player:HasTag("player")) then
                return
            end
            -- print("Active_Leave_Fns_By_Tile_XY",player,tx,ty)

            if self:Is_Tile_XY_OverSize(tx,ty) then --- 超出尺寸
                return
            end
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.leave_events = tile_data.leave_events or {}
            for temp_fn,flag in pairs(tile_data.leave_events) do
                if temp_fn and flag then
                    temp_fn(player,tx,ty)                   
                end
            end
        end
    ---- 清空所有地块 event
        function fwd_in_pdt_com_world_map_tile_sys:Clear_All_Events(tx,ty)
            local tile_data = self:Get_Data_By_Tile_XY(tx,ty)
            tile_data.join_events = {}
            tile_data.leave_events = {}
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

