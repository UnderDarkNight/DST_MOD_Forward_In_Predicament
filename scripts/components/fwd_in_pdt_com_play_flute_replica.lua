----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local fwd_in_pdt_com_play_flute = Class(function(self, inst)
    self.inst = inst
    self.build = "pan_flute"
    self.layer = "pan_flute01"
end)
---------------------------------------------------------------------------------
---- test 函数
    function fwd_in_pdt_com_play_flute:SetTestFn(fn)
        self._test_fn = fn
    end

    function fwd_in_pdt_com_play_flute:Test(doer)
        if self._test_fn ~= nil then
            return self._test_fn(self.inst, doer)
        end
        return false
    end
---------------------------------------------------------------------------------
---- PreAction
    function fwd_in_pdt_com_play_flute:SetPreActionFn(fn)
        self._pre_action_fn = fn
    end
    function fwd_in_pdt_com_play_flute:ActivePreAction(doer)
        if self._pre_action_fn then
            self._pre_action_fn(self.inst,doer)
        end
    end
---------------------------------------------------------------------------------
----- build layer
    function fwd_in_pdt_com_play_flute:SetBuild(build)
        self.build = build
    end
    function fwd_in_pdt_com_play_flute:GetBuild()
        return self.build
    end

    function fwd_in_pdt_com_play_flute:SetLayer(layer)
        self.layer = layer
    end
    function fwd_in_pdt_com_play_flute:GetLayer()
        return self.layer
    end
---------------------------------------------------------------------------------
------ sound
    function fwd_in_pdt_com_play_flute:SetSound(sound_addr)
        self._sound = sound_addr
    end
    function fwd_in_pdt_com_play_flute:GetSound()
        return self._sound or "dontstarve/wilson/flute_LP"
    end
---------------------------------------------------------------------------------
return fwd_in_pdt_com_play_flute
