----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 本模块用来给特定物品添加独特的拾取声音
--- 只在 client 端进行声音替换
--- 角色独有的指定声音在 replica 组件里添加修改。
--- 玩家载入的时候再修改。ThePlayer._PICKUPSOUNDS[]    player_common.lua 里
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local PICKUPSOUNDS = {}     --- inst.pickupsound 为 index
local PICKUPSOUNDS_FWD_IN_PDT_OLD = nil    ---  ThePlayer._PICKUPSOUNDS 会一直保留，换角色也会一直保留，需要个table 用来重新初始化。

rawset(_G,"fwd_in_pdt_set_pick_sound",function(inst,index,sound_addr)         ----- 2 参数或者 3 参数 都行 , fwd_in_pdt_set_pick_sound(index,addr) 或者 fwd_in_pdt_set_pick_sound(inst,index,addr)
    if type(index) == "string" then
        -- local _inst = inst
        local _index = index
        local _sound_addr = sound_addr

        if type(inst) == "string" and sound_addr == nil then    --- 参数前移
            _index = inst
            _sound_addr = index
        elseif type(inst) == "table" then
            inst.picksound = index
        end
        ------------------------------------------

        PICKUPSOUNDS[_index] = _sound_addr
        PICKUPSOUNDS_FWD_IN_PDT_OLD[_index] = _sound_addr

        ---- 检查 是否有客制化的声音
        if not TheNet:IsDedicated() and ThePlayer and TheFocalPoint and ThePlayer._PICKUPSOUNDS and ThePlayer.replica.fwd_in_pdt_func and ThePlayer.replica.fwd_in_pdt_func.GetPickSound then
            ThePlayer._PICKUPSOUNDS[_index] =  ThePlayer.replica.fwd_in_pdt_func:GetPickSound(_index) or _sound_addr
        end

    else
        print("error : fwd_in_pdt_add_pick_sound",inst,index,sound_addr)    
    end
end)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    if TheNet:IsDedicated() then    --- 服务端不执行这段代码
        return
    end

    inst:DoTaskInTime(0,function()
        if inst._PICKUPSOUNDS then
                ----------- 重新初始化 数据，避免上一个角色的数据一直留存
                if PICKUPSOUNDS_FWD_IN_PDT_OLD == nil then
                    PICKUPSOUNDS_FWD_IN_PDT_OLD = deepcopy(inst._PICKUPSOUNDS)
                else
                    inst._PICKUPSOUNDS = deepcopy(PICKUPSOUNDS_FWD_IN_PDT_OLD)
                end

                for index, sound_addr in pairs(PICKUPSOUNDS) do
                    if index and sound_addr then
                        inst._PICKUPSOUNDS[index] = sound_addr
                    end
                end
        end
    end)

end)