----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- API:
-- fwd_in_pdt_func:Block_Client_Sound(sound) -------- sound 可以是 string，也可以是table，table 两种形式都行。
-- fwd_in_pdt_func:Wisper(cmd_table)    --- 密语系统
-- fwd_in_pdt_func:Add_Death_Announce(_cmd_table,timeout)    ---- 添加死亡通告,还有是否超时清除通告，_cmd_table 可以为 string ，如果是 table 则按照格式
-- fwd_in_pdt_func:Get_Or_Set_New_Spawn_Pt_Fn(fn)    --- 设置新创建玩家的出生点。 ， fn return 个 Vector3(0.0.0)
-- fwd_in_pdt_func:Set_Block_Charlie_Attack(flag)    --- 屏蔽查理攻击 flag: true or false
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function main_com(fwd_in_pdt_func)
    local inst = fwd_in_pdt_func.inst
    --------------------------------------------------------------------------------------------------------------------------------------------
    ----------- 检查是玩家控制的角色的func，避免刷的人偶造成崩溃问题
        function fwd_in_pdt_func:IsPlayer()
            if self.inst:HasTag("player") and self.inst.components.playercontroller and self.userid then
                return true
            end
            return false
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ----------- 屏蔽声音用的组件
        function fwd_in_pdt_func:Block_Client_Sound(sound) -------- sound 可以是 string，也可以是table，table 两种形式都行。
            if sound == nil then
                return
            end
            if type(sound) == "string" then
                self.DataTable[sound] = true
            elseif type(sound) == "table" then
                for k, v in pairs(sound) do
                    if type(k) == "string" then
                        self.DataTable[k] = true
                    elseif type(v) == "string" then
                        self.DataTable[v] = true 
                    end
                end
            end
            
            --- 下发任务计时器。避免大量RPC阻塞信道
            if self.tempData.sound_block_task then
                self.tempData.sound_block_task:Cancel()
                self.tempData.sound_block_task = nil
            end
        
            self.tempData.sound_block_task = self.inst:DoTaskInTime(1,function()
                self.tempData.sound_block_task  = nil
                -- local data_json = json.encode(self.DataTable)
                SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["fwd_in_pdt_sound_sys"],self.inst.userid,self.inst,json.encode(self.DataTable))
            end)
        
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ----------- 密语系统
    ----------- 完整内容前往 02_Chat_Wisper_Event.lua 查看
        function fwd_in_pdt_func:Wisper(cmd_table)
            -- local cmd_table = {
            --     -- ChatType = ChatTypes.Message ,                  ---- 文本类型
            --     m_colour = {0,0,255} ,                          ---- 内容颜色
            --     s_colour = {255,255,0},                         ---- 发送者颜色
            --     icondata = "profileflair_food_crabroll",        ---- 图标
            --     message = "ABCDEFG",                            ---- 文字内容
            --     sender_name = "HHHH555",                        ---- 发送者名字
            -- }
            self.inst.components.fwd_in_pdt_func:RPC_PushEvent2("fwd_in_pdt_event.whisper",cmd_table)
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    --- 死亡/复活通告相关 
        function fwd_in_pdt_func:Add_Death_Announce(_cmd_table,timeout)    ---- 添加死亡通告,还有是否超时清除通告
            -- local _cmd_table = {
            --     source = "",
            --     announce = "",
            -- }
            ---  _cmd_table 可以为 string ，如果是 table 则按照上面格式
            self.inst.components.fwd_in_pdt_data:Set("death_announce",_cmd_table)
            if timeout and type(timeout) == "number" then
                self.inst:DoTaskInTime(timeout,function()
                    if self.inst.components.fwd_in_pdt_data:Get("death_announce") == _cmd_table then
                        self.inst.components.fwd_in_pdt_data:Set("death_announce",nil)   
                    end
                end)
            end
        end
        function fwd_in_pdt_func:Add_Resurrection_Announce(_cmd_table,timeout)    ---- 添加复活通告,还有是否超时清除通告
            -- local _cmd_table = {
            --     source = "",
            --     announce = "",
            -- }
            ---  _cmd_table 可以为 string ，如果是 table 则按照上面格式
            self.inst.components.fwd_in_pdt_data:Set("resurrection_announce",_cmd_table)
            if timeout and type(timeout) == "number" then
                self.inst:DoTaskInTime(timeout,function()
                    if self.inst.components.fwd_in_pdt_data:Get("resurrection_announce") == _cmd_table then
                        self.inst.components.fwd_in_pdt_data:Set("resurrection_announce",nil)        
                    end        
                end)
            end
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    --- 设置新创建玩家的出生点。
        --- 配合 【Key_Modules_Of_FWD_IN_PDT\01_Original_Prefabs_Upgrade\01_01_theworld_player_spawner.lua】 实现
        --- fn 为nil 的时候 return fn
        --- fn 需要 return Vector3
        function fwd_in_pdt_func:Get_Or_Set_New_Spawn_Pt_Fn(fn)
            if fn == nil then                
                return self.tempData.______Player_New_Spawn_Pt_Fn
            end
            if fn and type(fn) == "function" then
                self.tempData.______Player_New_Spawn_Pt_Fn = fn
            end
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ---- 屏蔽查理攻击 ，hook inst.components.grue ,或者使用 AddImmunity/RemoveImmunity
        function fwd_in_pdt_func:Set_Block_Charlie_Attack(flag)
            if self.inst.components.grue == nil then
                return
            end
            if flag == true then
                self.inst.components.grue:AddImmunity("fwd_in_pdt_func.block")
            else
                self.inst.components.grue:RemoveImmunity("fwd_in_pdt_func.block")
            end
        end    
    --------------------------------------------------------------------------------------------------------------------------------------------
    ---- 管理员权限检查
        function fwd_in_pdt_func:IsAdmin()        ---- 管理员 权限
            --- 参考函数 userlevel() in usercommand.lua
            if self.inst.userid == nil then
                return false
            else
                local client = TheNet:GetClientTableForUser(tostring(self.inst.userid))
                if type(client) == "table" then
                    return  client.admin or false
                else
                    return false
                end
            end            
        end
        function fwd_in_pdt_func:IsModerator()    ---- 版主 权限
            --- 参考函数 userlevel() in usercommand.lua
            if self.inst.userid == nil then
                return false
            else
                local client = TheNet:GetClientTableForUser(tostring(self.inst.userid))
                if type(client) == "table" then
                    return  client.admin or client.moderator or false
                else
                    return false
                end
            end            
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ---- 传送去指定位置并检查,避免洞穴存档的时候传送出错.支持缺省为 Vector3(...)
        function fwd_in_pdt_func:Transform2PT(Vector3_or_x,yy,zz)
            local x,y,z = Vector3_or_x,yy,zz
            if type(Vector3_or_x) == "table" and Vector3_or_x.x and Vector3_or_x.y and Vector3_or_x.z then
                x,y,z = Vector3_or_x.x,Vector3_or_x.y,Vector3_or_x.z
            elseif type(Vector3_or_x) == "number" and type(yy) == "number" and type(zz) == "number" then
                x,y,z = Vector3_or_x,yy,zz
            else
                return
            end
            self.inst.Transform:SetPosition(x,y,z)
            self.TempData.________Transform2PT__task = self.inst:DoPeriodicTask(0.2,function()
                if self.inst:GetDistanceSqToPoint(x,y,z) < 1 then
                    self.TempData.________Transform2PT__task:Cancel()
                    self.TempData.________Transform2PT__task = nil
                else
                    self.inst.Transform:SetPosition(x,y,z)
                end
            end)
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ---- 传送去指定位置并检查,避免洞穴存档的时候传送出错.支持缺省为 Vector3(...)
        function fwd_in_pdt_func:Transform2PT2(Vector3_or_x,yy,zz)
            if self.inst:HasTag("playerghost") then
                return
            end
            local x,y,z = Vector3_or_x,yy,zz
            if type(Vector3_or_x) == "table" and Vector3_or_x.x and Vector3_or_x.y and Vector3_or_x.z then
                x,y,z = Vector3_or_x.x,Vector3_or_x.y,Vector3_or_x.z
            elseif type(Vector3_or_x) == "number" and type(yy) == "number" and type(zz) == "number" then
                x,y,z = Vector3_or_x,yy,zz
            else
                return
            end
            if self.inst.sg then
                self.inst.sg:GoToState("forcetele")
            end
            local function trans2pt(inst,pt)
                if inst.Physics then
                    inst.Physics:Teleport(pt.x,pt.y,pt.z)
                else
                    inst.Transform:SetPosition(pt.x,pt.y,pt.z)
                end
            end
            trans2pt(self.inst,Vector3(x,1,z))
            self.inst:ScreenFade(true, 2)

            self.TempData.________Transform2PT__task = self.inst:DoPeriodicTask(0.2,function()
                if self.inst:GetDistanceSqToPoint(x,y,z) < 1 then
                    self.TempData.________Transform2PT__task:Cancel()
                    self.TempData.________Transform2PT__task = nil
                    if self.inst.sg then
                        self.inst.sg:GoToState("idle")
                    end
                    trans2pt(self.inst,Vector3(x,0,z))
                else
                    trans2pt(self.inst,Vector3(x,1,z))
                end
            end)
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
    ---- 给指定数量的物品（用来减少卡顿）
        function fwd_in_pdt_func:GiveItemByPrefab(prefab,num)
            -- print("main info fwd_in_pdt_func:GiveItemByPrefab",prefab,num)
            if type(prefab) ~= "string" or not PrefabExists(prefab) then
                return {}
            end

            num = num or 1
            if num == 1 then
                local item = SpawnPrefab(prefab)
                self.inst.components.inventory:GiveItem(item)
                return {item}
            end

            local base_item_inst = SpawnPrefab(prefab)
            if not base_item_inst.components.stackable then --- 不可叠堆的物品
                local ret_items_table = {}
                for i = 2, num, 1 do
                    local item = SpawnPrefab(prefab)
                    self.inst.components.inventory:GiveItem(item)
                    table.insert(ret_items_table,item)
                end
                table.insert(ret_items_table,base_item_inst)
                self.inst.components.inventory:GiveItem(base_item_inst)
                return ret_items_table
            end
            ---------------------------------- 
            -- 叠堆计算
            local ret_items_table = {}
            local max_stack_num = base_item_inst.components.stackable.maxsize
            local rest_num = math.floor( num % max_stack_num )      --- 不够一组的个数
            local stack_groups = math.floor(   (num - rest_num)/max_stack_num    )  --- 够一组的个数
            if rest_num > 0 then
                base_item_inst.components.stackable.stacksize = rest_num
                self.inst.components.inventory:GiveItem(base_item_inst)
                table.insert(ret_items_table,base_item_inst)
            else
                base_item_inst:Remove()
            end
            if stack_groups > 0 then
                for i = 1, stack_groups, 1 do
                    local items = SpawnPrefab(prefab)
                    items.components.stackable.stacksize = max_stack_num
                    self.inst.components.inventory:GiveItem(items)
                    table.insert(ret_items_table,items)
                end
            end
            return ret_items_table
        end
    --------------------------------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(fwd_in_pdt_func)
    function fwd_in_pdt_func:IsPlayer()
        if self.inst:HasTag("player") and self.inst.components.playercontroller and self.userid then
            return true
        end
        return false
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(fwd_in_pdt_func)
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func) 
    else      
        replica(fwd_in_pdt_func)
    end    
end