AddPrefabPostInit(
    "amulet",
    function(inst)
        inst:AddTag("fwd_in_pdt_test_amulet")

        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("fwd_in_pdt_func"):Init("mouserover_colourful","item_tile_fx")
        inst.components.fwd_in_pdt_func:Mouseover_SetColour(255,0,0)

        inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
            bank = "inventory_fx_shadow",
            build = "inventory_fx_shadow",
            anim = "idle",
            text = {
                color = {255/255,0/255,0/255},
                -- pt = Vector3(-14,16,0),
                size = 30
            }
        })

        -- inst:AddComponent("fwd_in_pdt_com_itemtile_anim")
        -- inst.components.fwd_in_pdt_com_itemtile_anim:SetAnim({
        --     bank = "inventory_fx_shadow",
        --     build = "inventory_fx_shadow",
        --     anim = "idle"
        -- })

        inst:ListenForEvent("equipped",function()
            inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                bank = "archive_lockbox_player_fx",
                build = "archive_lockbox_player_fx",
                anim = "activation",
                color = {255/255,0,0}
            })
        end)

        inst:ListenForEvent("unequipped",function()
            inst.components.fwd_in_pdt_func:Item_Tile_Icon_Fx_Set_Anim({
                bank = "inventory_fx_shadow",
                build = "inventory_fx_shadow",
                anim = "idle",
            })
        end)
        
    end
)