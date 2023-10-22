------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 本文件主要是做一些辅助事件注册，方便一些界面的HOOK修改

---- 给  ThePlayer.HUD 里挂载一些 event ，触发特殊界面hookk

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------- 容器界面的开关,往 inst 发送事件和  widget。方便修改
        AddClassPostConstruct("screens/playerhud",function(self)


            self.OpenContainer_old__fwd_in_pdt = self.OpenContainer
            function self:OpenContainer(container_inst,side,...)
                self:OpenContainer_old__fwd_in_pdt(container_inst,side,...)  
                if container_inst and container_inst.PushEvent and self.controls and self.controls.containers and self.controls.containers[container_inst] then
                    container_inst:PushEvent("fwd_in_pdt_event.container_widget_open",self.controls.containers[container_inst])
                end
            end


            self.CloseContainer_old__fwd_in_pdt = self.CloseContainer
            function self:CloseContainer(container_inst,side,...)
                self:CloseContainer_old__fwd_in_pdt(container_inst,side,...)
                if container_inst and container_inst.PushEvent then
                    container_inst:PushEvent("fwd_in_pdt_event.container_widget_close")
                end
            end


        end)