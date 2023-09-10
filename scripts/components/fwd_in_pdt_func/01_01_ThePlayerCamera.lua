------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 给玩家添加 TheCamera 事件监听。
---- 使服务器可以控制玩家视角
---- 服务器可以获取玩家镜头相关的一些参数。
---- 使用rpc 上下传输数据

--[[
    使用说明：

    服务端：
            · self:TheCamera_GetRightVec()                       --- 获取镜头右边矢量坐标
            · self:TheCamera_GetDownVec()                        --- 获取镜头下边矢量坐标
            · self:TheCamera_GetHeadingTarget()                  ---- 获取镜头角度
            · self:TheCamera_GetLastHeadingTarget()              ---- 获取之前的镜头角度
            · self:TheCamera_GetFov()                            ---- 获取镜头 FOV  缩放参数

            · self:TheCamera_SetDefault()                        ---- 重置镜头所有参数
            · self:TheCamera_SetHeadingTarget(r)                 ---- 服务器下发设置玩家镜头旋转角度，
            · self:TheCamera_SetFov(t)                           ---- 下发俯视角角度。
            · self:TheCamera_SetTarget(inst)                     ---- 绑定玩家摄像机给 指定 inst            
            · self:TheCamera_ClearTarget()                       ---- 清除视角绑定

]]--


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(self)
    self.inst:ListenForEvent("fwd_in_pdt_event.camera_data_synchronization",function(_,_table)
        if type(_table) ~= "table" then
            return
        end

        for k, v in pairs(_table) do
            if k and v then
                self.TempData.___CameraData[k] = v
            end
        end

    end)

    ----------------------------------------------------------------------------------------------
        function self:TheCamera_GetRightVec()      --- 获取镜头右边矢量坐标
            return self.TempData.___CameraData.right_vec or Vector3(0,0,0)
        end
        function self:TheCamera_GetDownVec()       --- 获取镜头下边矢量坐标
            return self.TempData.___CameraData.down_vec or Vector3(0,0,0)
        end

        function self:TheCamera_GetHeadingTarget() ---- 获取镜头角度
            return self.TempData.___CameraData.current_deg or 0
        end
        function self:TheCamera_GetLastHeadingTarget() ---- 获取之前的镜头角度
            return self.TempData.___CameraData.last_deg or self:TheCamera_GetHeadingTarget()
        end

        function self:TheCamera_GetFov()
            return self.TempData.___CameraData.fov or 35
        end

    ----------------------------------------------------------------------------------------------
        function self:TheCamera_SetData(name,data) --- 使用 DoTaskInTime 0 进行数据同时下发，避免RPC阻塞
            self.TempData.___CameraData.RPC_PUSH_DATA = self.TempData.___CameraData.RPC_PUSH_DATA or {}
            self.TempData.___CameraData.RPC_PUSH_DATA[name] = data

            if self.TempData.___CameraData.__push_task then        --- 取消任务
                self.TempData.___CameraData.__push_task:Cancel()
                self.TempData.___CameraData.__push_task = nil
            end

            self.TempData.___CameraData.__push_task = self.inst:DoTaskInTime(0,function()
                self:RPC_PushEvent2("fwd_in_pdt_func.camera_cmd",self.TempData.___CameraData.RPC_PUSH_DATA)
                self.TempData.___CameraData.RPC_PUSH_DATA = {} --- 清空数据
            end)

        end

        function self:TheCamera_SetDefault()       ---- 重置镜头
            self:TheCamera_SetData("SetDefault",true)
        end

        function self:TheCamera_SetHeadingTarget(r)  --- 服务器下发设置玩家镜头旋转角度，
            if type(r) == "number" then
                -- self:RPC_PushEvent("fwd_in_pdt_func.camera_cmd",{
                --     SetHeadingTarget = r
                -- })
                self:TheCamera_SetData("SetHeadingTarget",r)
            end
        end

        function self:TheCamera_SetFov(t)  ---- 下发俯视角角度。
            if type(t) == "number" then
                self:TheCamera_SetData("fov",t)
            else
                self:TheCamera_SetData("fov",35)    --- 默认35度俯视视角
            end
        end

    ----------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- client replica
    local function Add_Camera_Listener(self)   --- 添加监控event

        -- fwd_in_pdt_func.TempData.___CameraData.headingtarget_old = TheCamera.headingtarget
        TheCamera:AddListener("fwd_in_pdt_camera_event",function()    ----- 这个 监听会大量执行，估计有 30FPS
            local temp_data = {}
            local data_needs_to_be_synchronized_flag = false
            -------------------------------------------------------------------------------------------------------
            --- 同步镜头旋转角度
                if self.TempData.___CameraData.headingtarget_old ~= TheCamera.headingtarget then

                    temp_data["last_deg"] = self.TempData.___CameraData.headingtarget_old
                    temp_data["current_deg"] = TheCamera.headingtarget

                    data_needs_to_be_synchronized_flag = true
                    self.TempData.___CameraData.headingtarget_old = TheCamera.headingtarget 
                end
            -------------------------------------------------------------------------------------------------------
            --- 同步镜头缩放角度
                if self.TempData.___CameraData.fov_old ~= TheCamera.fov then
                    temp_data["fov"] = TheCamera.fov
                    data_needs_to_be_synchronized_flag = true
                    self.TempData.___CameraData.fov_old = TheCamera.fov 
                end
            -------------------------------------------------------------------------------------------------------
            --- 
            -------------------------------------------------------------------------------------------------------
            --- 上传数据
                if data_needs_to_be_synchronized_flag then
                    temp_data["right_vec"] = TheCamera:GetRightVec()    --- 顺便同步镜头矢量坐标
                    temp_data["down_vec"] = TheCamera:GetDownVec()      --- 顺便同步镜头矢量坐标
                    self:RPC_PushEvent2("fwd_in_pdt_event.camera_data_synchronization",temp_data)
                end
            -------------------------------------------------------------------------------------------------------

        end)
        
    end
    local function Add_Server2Client_Controller(self)
        self.inst:ListenForEvent("fwd_in_pdt_func.camera_cmd",function(_,_table)
            -- print("fwd_in_pdt_func.camera_cmd")
            if type(_table)~= "table" then
                return
            end
            ---------------------------------------------------------------------------
            if _table.SetDefault then
                TheCamera:SetDefault()
            end
            ---------------------------------------------------------------------------
            if _table.SetHeadingTarget then
                TheCamera:SetHeadingTarget(_table.SetHeadingTarget)
            end
            ---------------------------------------------------------------------------
            if _table.fov then
                TheCamera.fov = _table.fov
            end
            ---------------------------------------------------------------------------

            ---------------------------------------------------------------------------


        end)
    end

    local function replica(self)
        if TheCamera then
            Add_Camera_Listener(self)  --- 添加监控event，用 rpc 上传常用数据
            Add_Server2Client_Controller(self)     --- 服务器下发来数据，监听并执行
        end
    end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 以 net_entity 下发数据，让摄像机视角锁定给指定inst
    local function Add_Focus_Fns(self)
        self.TempData.___CameraData.__camera_focus_target = net_entity(self.inst.GUID,"fwd_in_pdt_func_camera_focus_target","fwd_in_pdt_func_camera_focus_target")
        self.inst:ListenForEvent("fwd_in_pdt_func_camera_focus_target",function()
            if TheCamera then
                local target = self.TempData.___CameraData.__camera_focus_target:value()
                TheCamera:SetTarget(target)
            end
        end)

        if self.is_replica ~= true then
            function self:TheCamera_SetTarget(inst)                                 --- 绑定目标
                if inst and inst.IsValid and inst:IsValid() then
                    self.TempData.___CameraData.__camera_focus_target:set(inst)
                else
                    self.TempData.___CameraData.__camera_focus_target:set(self.inst)
                end
            end
            function self:TheCamera_ClearTarget()
                self:TheCamera_SetTarget(self.inst)
            end
        end

    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(self)
    self:Init("rpc")   --- 避免个万一，在这加载一下模块。
    self.TempData.___CameraData = {}
    Add_Focus_Fns(self)
    if self.is_replica ~= true then        --- 不是replica
        main_com(self)
    else               
        replica(self)
    end

end