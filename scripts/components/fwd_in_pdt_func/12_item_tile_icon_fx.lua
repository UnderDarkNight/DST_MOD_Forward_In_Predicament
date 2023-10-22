------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品栏的图标上覆盖特效的组件

--- Item_Tile_Icon_Fx_Set_Anim({bank = "", build = "" , anim = "", color = {} , shader = "shaders/anim.ksh" }) -- colour / color 都行
--- Item_Tile_Icon_Fx_Clear() 清除动画。
--- Item_Tile_Icon_Fx_SetDisplay(true)  开启/关闭动画。默认情况是 开启。

--- 对应的动画需要在250x250 pix 范围内制作。
--- 【Key_Modules_Of_FWD_IN_PDT\06_widgets\04_itemtile_icon_fx_anim.lua】
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function main_com(fwd_in_pdt_func)
    function fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim(cmd_table)
        -- cmd_table = {
        --     bank = "",
        --     build = "",
        --     anim = "",
        --     shader = "",
        --     colour = {r,g,b,a},    -- 同时兼容命名 color
        --     hide_image = true,  -- 隐藏图标
        --     MoveToBack = true,  -- 动画特效移动到图标底层
        --     MoveToFront = true, -- 动画特效移动到图标顶层
        --     text = {            -- 叠堆数字/百分比数字相关参数操作
        --         pt = Vector3(0,0,0), -- 坐标偏移，默认 （2,16,0）
        --         color = {r,g,b,a},  --  颜色，同时支持 colour
        --         size = 42,           -- 字体大小(默认42)
        --     }
        -- }
        if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
            return
        end
        if type(cmd_table) == "table" then
                cmd_table.display = true
                self.tempData.__Item_Tile_Icon_Fx_CMD = cmd_table
                self:Replica_Set_Simple_Data("ItemTileFX",cmd_table)
                -- self.inst:PushEvent("imagechange")   -- 刷新图标和特效动画 （这个event只能client有效）
                self:Replica_Simple_PushEvent("imagechange")  -- 下发事件刷新图标和特效动画

        end
    end
    function fwd_in_pdt_func:Item_Tile_Icon_Fx_Clear()
        if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
            return
        end
        self:Replica_Set_Simple_Data("ItemTileFX",{})    
        self:Replica_Simple_PushEvent("imagechange")  -- 下发事件刷新图标和特效动画
    end

    function fwd_in_pdt_func:Item_Tile_Icon_Fx_SetDisplay(flag)  ---- 封装一个开关切换，外部代码就不用那么复杂了。
        if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
            return
        end
        flag = flag or false
        local cmd_table = self.tempData.__Item_Tile_Icon_Fx_CMD or {}
        cmd_table.display = flag
        self.tempData.__Item_Tile_Icon_Fx_CMD = cmd_table
        self:Replica_Set_Simple_Data("ItemTileFX",cmd_table)
        self:Replica_Simple_PushEvent("imagechange")  -- 下发事件刷新图标和特效动画
        
    end

    function fwd_in_pdt_func:Item_Tile_Icon_Fx_Display_Refresh()
        if TUNING["Forward_In_Predicament.Config"].UI_FX ~= true then
            return
        end
        if self.tempData.__Item_Tile_Icon_Fx_CMD and self.tempData.__Item_Tile_Icon_Fx_CMD.display then
            self:Item_Tile_Icon_Fx_SetDisplay(true)
        else
            self:Item_Tile_Icon_Fx_SetDisplay(false)
        end
    end

    ------- 在widget 那边使用了 DoTaskInTime 0 了，没必要再使用这些
    -- fwd_in_pdt_func.inst:ListenForEvent("onputininventory",function(inst) --- 外部拾取到背包的时候刷新一下图标播放
    --     if inst and inst.components.fwd_in_pdt_func and inst.components.fwd_in_pdt_func.Item_Tile_Icon_Fx_Display_Refresh then
    --         inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Display_Refresh()
    --     end
    -- end)

end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function replica(fwd_in_pdt_func)
    function fwd_in_pdt_func:Item_Tile_Icon_Fx_Get()
        local cmd_table = self:Replica_Get_Simple_Data("ItemTileFX") or {}
        if cmd_table.display then
            return cmd_table
            -- return cmd_table.bank , cmd_table.build ,cmd_table.anim,cmd_table.color or cmd_table.colour,cmd_table.shader,cmd_table.hide_image
        else
            -- return nil,nil,nil,nil,nil
            return nil
        end    
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(fwd_in_pdt_func)
    fwd_in_pdt_func.inst:AddTag("fwd_in_pdt_tag.fwd_in_pdt_func.item_tile_icon_fx")    --- 添加tag 方便外部扫描到拥有该模块的inst。
    if fwd_in_pdt_func.is_replica ~= true then        --- 不是replica
        main_com(fwd_in_pdt_func)
    else               
        replica(fwd_in_pdt_func)
    end

end