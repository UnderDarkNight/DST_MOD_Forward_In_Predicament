--- --- hook  掉 inst.AnimState  不依赖mod加载优先级，方便和其他MOD兼容

TUNING["Forward_In_Predicament.AnimStateFn"]= {}

----------------------------------------------------------------------------------------------------------------------------------------
------ 正在开发的模块
if TUNING.FWD_IN_PDT_MOD___DEBUGGING_MODE == true then
    -- modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/00_PlayAnim_PushAnim.lua")    --- 更新 PlayAnimation 和 PushAnimation 
    -- modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/01_GetBuild.lua")    --- build fn    
end
---------------------------------------------------------------------------------------------------------------
------ 可以上线使用的模块
modimport("Key_Modules_Of_FWD_IN_PDT/04_AnimState_Hook/00_PlayAnim_PushAnim.lua")    --- 更新 PlayAnimation 和 PushAnimation 


---------------------------------------------------------------------------------------------------------------
local function theAnimState_fn_Upgrade(theAnimState)
    for fn_name, fn in pairs(TUNING["Forward_In_Predicament.AnimStateFn"]) do
        if fn and type(fn) == "function" then
            fn(theAnimState)
        end
    end
end

local function hook_player_animstate(inst)      ----- DoTaskInTime 0 时候使用， 数据进入 形式不一样  
    local tempInst = inst
    -----------------------------------------------------------------------------------------------------------------------------
    ------ 添加关键储存API
    ------ inst.AnimState:save_inst_4_fwd_in_pdt(inst.AnimState,inst)
    ------ inst.AnimState:get_inst_by_fwd_in_pdt(inst.AnimState)
    ------ 在theAnimState的func里，用 self.get_inst_by_fwd_in_pdt(self,self) 得到inst
    -----------------------------------------------------------------------------------------------------------------------------

    --------- 避免重复hook,其他角色进入则参数进入即可
    if tempInst.AnimState.save_inst_4_fwd_in_pdt then
        if type(tempInst.AnimState) == "userdata" then
            inst.AnimState:save_inst_4_fwd_in_pdt(inst.AnimState,inst) --- 注入方式不一样
        elseif type(tempInst.AnimState) == "table" then
            inst.AnimState:save_inst_4_fwd_in_pdt(inst)    ----- 注入方式不一样                
        end
        print("info FWD_IN_PDT mod: already hook animstate ,data join and func return")
        return
    end
    --------------------------------------------------------------------------------------------------------


    if type(tempInst.AnimState) =="userdata" then
    --- 部分mod 会 hook 掉 inst.AnimState ，例如 棱镜，把userdata 转为 table，在这里 分开处理这部分
        print("FWD_IN_PDT mod hook player AnimState   userdata")
        local theAnimState = getmetatable(tempInst.AnimState).__index
        theAnimState.save_inst_4_fwd_in_pdt = function(self,inst_animstate,inst)
            if getmetatable(self).__index.save_inst_data_4_fwd_in_pdt == nil then
                getmetatable(self).__index.save_inst_data_4_fwd_in_pdt = {}
            end
            getmetatable(self).__index.save_inst_data_4_fwd_in_pdt[inst_animstate] = inst
        end

        theAnimState.get_inst_by_fwd_in_pdt = function(self,the_animstate)
            -- self is userdata
            if getmetatable(self).__index.save_inst_data_4_fwd_in_pdt then
                return getmetatable(self).__index.save_inst_data_4_fwd_in_pdt[the_animstate]
            end
            return nil
        end        

        inst.AnimState:save_inst_4_fwd_in_pdt(inst.AnimState,inst) --- 注入方式不一样
        theAnimState_fn_Upgrade(theAnimState)

    elseif type(tempInst.AnimState) == "table" then
    --- 部分mod 会 hook 掉 inst.AnimState ，例如 棱镜，把userdata 转为 table，在这里 分开处理这部分
        print("FWD_IN_PDT mod hook player AnimState   table")
        local theAnimState = tempInst.AnimState
        function theAnimState:save_inst_4_fwd_in_pdt(inst)
            if self.save_inst_data_4_fwd_in_pdt == nil then
                self.save_inst_data_4_fwd_in_pdt = {}
            end
            self.save_inst_data_4_fwd_in_pdt[self] = inst
        end

        function theAnimState:get_inst_by_fwd_in_pdt(the_animstate)
            if self.save_inst_data_4_fwd_in_pdt then
                return self.save_inst_data_4_fwd_in_pdt[the_animstate]
            end
            return nil
        end

        inst.AnimState:save_inst_4_fwd_in_pdt(inst)    ----- 注入方式不一样
        theAnimState_fn_Upgrade(theAnimState)

    end

    -----------------------------------------------------------------------------------------------------------------------------
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
		return
	end

    inst:DoTaskInTime(0,function()  --- 玩家完全进入游戏后。再侵入。不然遭遇棱镜会失效        
        hook_player_animstate(inst)
    end)
end)