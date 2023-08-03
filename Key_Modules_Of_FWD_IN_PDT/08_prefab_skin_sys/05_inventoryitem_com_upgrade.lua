--------------------------------------------------------------------------------------------------------------------------------------------
---- 给物品组件添加个 方便自用的 API
---- 切皮肤重置图标就方便很多，添加图片参数也很方便
--------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("inventoryitem", function(self)

    function self:fwd_in_pdt_icon_init(image,atlas)
        --- image : 没 .tex 的后缀
        self.fwd_in_pdt_icon_data_image = image
        self.fwd_in_pdt_icon_data_atlas = atlas

        if atlas then
            self.imagename = image 
            self.atlasname = atlas
        else
            self:ChangeImageName(image)
        end
    end

    function self:fwd_in_pdt_reset_icon()
        if self.fwd_in_pdt_icon_data_image == nil then
            return
        end
        if self.fwd_in_pdt_icon_data_atlas then
            self.imagename = self.fwd_in_pdt_icon_data_image 
            self.atlasname = self.fwd_in_pdt_icon_data_atlas
        else
            self.atlasname = nil
            self.imagename = nil
            self:ChangeImageName(self.fwd_in_pdt_icon_data_image)
        end
    end

end)