------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 使特定玩家对某些特定的物品拾取有独立的拾取声音。
---- 使用rpc 上下传输数据

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function main_com(fwd_in_pdt_func)
    ----------------------------------------------------------------------------------------------
    function fwd_in_pdt_func:SetPickSound(index,sound_addr) --- 使用 DoTaskInTime 0 进行数据同时下发，避免RPC阻塞
        self.TempData.___pick_sounds.RPC_PUSH_DATA = self.TempData.___pick_sounds.RPC_PUSH_DATA or {}
        self.TempData.___pick_sounds.RPC_PUSH_DATA[index] = sound_addr

        if self.TempData.___pick_sounds.__push_task then        --- 取消任务
            self.TempData.___pick_sounds.__push_task:Cancel()
            self.TempData.___pick_sounds.__push_task = nil
        end

        self.TempData.___pick_sounds.__push_task = self.inst:DoTaskInTime(0,function()
            self:RPC_PushEvent("fwd_in_pdt_func.pick_sound_customization",self.TempData.___pick_sounds.RPC_PUSH_DATA)
            self.TempData.___pick_sounds.RPC_PUSH_DATA = {} --- 清空数据
        end)
    end

    ----------------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------- client replica
local function replica(fwd_in_pdt_func)
    fwd_in_pdt_func.inst:ListenForEvent("fwd_in_pdt_func.pick_sound_customization",function(_,_table)
        if type(_table) ~= "table" then
            return
        end

        fwd_in_pdt_func.inst:DoTaskInTime(0.2,function()  --- 延迟一下下，等待 初始声音参数重置，再做角色专属替换。
            -- print("info  pick sound set")
            for index, sound_addr in pairs(_table) do
                if index and sound_addr then
                        fwd_in_pdt_func.TempData.___pick_sounds[index] = sound_addr
                        if ThePlayer and TheFocalPoint and ThePlayer._PICKUPSOUNDS then
                            ThePlayer._PICKUPSOUNDS[index] = sound_addr
                        end
                end
            end

        end)


        
    end)


    function fwd_in_pdt_func:GetPickSound(index)
        return self.TempData.___pick_sounds[tostring(index)]
    end

    

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    fwd_in_pdt_func:Init("rpc")   --- 避免个万一，在这加载一下模块。
    fwd_in_pdt_func.TempData.___pick_sounds = {}
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end

end