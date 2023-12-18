local Widget = require "widgets/widget"
-- local Image = require "widgets/image" -- 引入image控件
local UIAnim = require "widgets/uianim"


-- local Screen = require "widgets/screen"
-- local AnimButton = require "widgets/animbutton"
-- local ImageButton = require "widgets/imagebutton"
-- local Menu = require "widgets/menu"
-- local Text = require "widgets/text"
-- local TEMPLATES = require "widgets/redux/templates"

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0,function()
        inst:ListenForEvent("fwd_in_pdt.drawing.display",function(_,cmd_table)
            if inst.HUD then
                inst.HUD:fwd_in_pdt_drawing_display(cmd_table)
            else
                SendModRPCToClient(CLIENT_MOD_RPC[TUNING["Forward_In_Predicament.RPC_NAMESPACE"]]["drawing"],inst.userid,json.encode(cmd_table))
            end
        end)
    end)
end)


AddClassPostConstruct("screens/playerhud",function(self)
    local hud = self

    self.fwd_in_pdt_drawing_display__widget_children_by_id = {} --- 储存 界面。index 为 id

    function self:fwd_in_pdt_drawing_display(cmd_table)
        -- cmd_table = {
        --     bank = "",
        --     build = "",
        --     anim = "",
        --     loop = false,   ---- 循环播放。 -- false 的时候播放完就关闭。
        --     push = {},                      -- -- PushAnim
        --     time = 5 ,      --- 默认3秒后删除
        --     speed = 1,      --- 默认播放速度
        --     scale = 1,      --- 默认缩放
        --     a = 1 ,         --- 透明度
        --     location = 1,   --[[
        --                         以左上角为1开始。右下角为9。屏幕锚点为9个
        --                         1   2    3
        --                         4   5    6
        --                         7   8    9
        --                     ]]----
        --     ---
        --     pt = vector3(0,0,0),
        --     id = "",        --- 用来外部控制强制关闭。可以为 nil
        --     kill = false,   --- 配合id 用来强制关闭
        -- }

        ----------------------------------
        ---- kill 掉界面
            if cmd_table.kill == true and cmd_table.id ~= nil then
                if hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] then
                    hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id]:Kill()
                    hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] = nil                    
                end
                return
            end
        ----------------------------------
            local root = hud:AddChild(Widget())
            root:SetClickable(false)
            if cmd_table.id ~= nil then
                hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] = root
            end
            ------- 定时关闭
                if cmd_table.time then
                    ThePlayer:DoTaskInTime(cmd_table.time,function()  --- 注销关闭界面
                        root:Kill()
                        if cmd_table.id ~= nil and hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] then
                            hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id]:Kill()
                            hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] = nil
                        end
                    end)
                end
            -------- 位置
                local location = cmd_table.location or 5
                local base_points = {
                    { H = 1 , V = 1 }  ,  { H = 0 , V = 1 } , { H = 2 , V = 1 } ,
                    { H = 1 , V = 0 }  ,  { H = 0 , V = 0 } , { H = 2 , V = 0 } ,
                    { H = 1 , V = 2 }  ,  { H = 0 , V = 2 } , { H = 2 , V = 2 } ,
                }
                local pt = base_points[location] or { H = 0 , V = 0 }
                root:SetHAnchor(pt.H)
                root:SetVAnchor(pt.V)
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
                root:SetPosition(0,0)
            ---------
                local ui_anim = root:AddChild(UIAnim())
            --------- 设置缩放
                local scale = cmd_table.scale or 1
                ui_anim:SetScale(scale,scale,scale)
            --------- 坐标偏移
                if type(cmd_table.pt) == "table" and cmd_table.pt.x and cmd_table.pt.y then
                    ui_anim:SetPosition(cmd_table.pt.x,cmd_table.pt.y)
                end
            --------- 添加动画函数、时间监听函数 animqueueover  animover 事件 
                ---- 先添加函数
                    function ui_anim:PlayAnimation(anim,loop_flag)
                        self.inst.AnimState:PlayAnimation(anim,loop_flag)
                    end
                    function ui_anim:PushAnimation(anim,loop_flag)
                        self.inst.AnimState:PushAnimation(anim,loop_flag)                        
                    end
                    function ui_anim:SetBank(bank)
                        self.inst.AnimState:SetBank(bank)
                    end
                    function ui_anim:SetBuild(build)
                        self.inst.AnimState:SetBuild(build)
                    end
                    function ui_anim:SetSpeed(num)
                        self.inst.AnimState:SetDeltaTimeMultiplier(num)
                    end
                    function ui_anim:Add_Animqueueover_Fn(fn)
                        self.inst:ListenForEvent("animqueueover",fn)
                    end
                    function ui_anim:Add_Animover_Fn(fn)
                        self.inst:ListenForEvent("animover",fn)                        
                    end
            ------------- 播放动画
                ui_anim:SetBank(cmd_table.bank)
                ui_anim:SetBuild(cmd_table.build)
                ui_anim:PlayAnimation(cmd_table.anim, cmd_table.loop)
                    if type(cmd_table.push) == "table" then
                        for k, v in pairs(cmd_table.push) do
                            ui_anim:PushAnimation(v,cmd_table.loop)
                        end
                    else
                        ui_anim:Add_Animover_Fn(function()
                            -- print(" drawing display  animqueueover")
                            root:Kill()
                            if cmd_table.id ~= nil then
                                hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] = nil
                            end
                        end)
                    end
                if cmd_table.speed then
                    ui_anim:SetSpeed(cmd_table.speed)
                end
                if type(cmd_table.a) == "number" then
                    ui_anim:GetAnimState():SetMultColour(1,1,1,cmd_table.a)
                end

                ui_anim:Add_Animqueueover_Fn(function()
                    -- print(" drawing display  animqueueover")
                    root:Kill()
                    if cmd_table.id ~= nil then
                        hud.fwd_in_pdt_drawing_display__widget_children_by_id[cmd_table.id] = nil
                    end
                end)


    end


end)