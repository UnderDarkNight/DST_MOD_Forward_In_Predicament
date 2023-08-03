
local assets =
{
    Asset("ANIM", "anim/fwd_in_pdt_room_background.zip"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("INLIMBO")

    inst:AddTag("blocker")
    inst:AddTag("antlion_sinkhole_blocker")     --- 没蚁狮洞穴
    inst:AddTag("birdblocker")                  ---- 不生成鸟
    inst:AddTag("shelter")                      ---- 常青树用来挡雨的
    

    inst:AddTag("fwd_in_pdt_room_background")


    inst.AnimState:SetBank("fwd_in_pdt_room_background")
    inst.AnimState:SetBuild("fwd_in_pdt_room_background")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)  
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetScale(500,500,500)
    inst.AnimState:SetLayer(LAYER_BELOW_GROUND)

    -- ANIM_ORIENTATION =
    -- {
    --     BillBoard = 0,
    --     OnGround = 1,
    --     OnGroundFixed = 2,
    -- }

    -- LAYER_BACKDROP = 0
    -- LAYER_BELOW_OCEAN = 1
    -- LAYER_BELOW_GROUND = 2
    -- LAYER_GROUND = 3
    -- LAYER_BACKGROUND = 4
    -- LAYER_WORLD_BACKGROUND = 5
    -- LAYER_WORLD = 6
    -- -- client-only layers go below here --
    -- LAYER_WORLD_DEBUG = 7
    -- LAYER_FRONTEND = 8
    -- LAYER_FRONTEND_DEBUG = 9

    -- LAYER_WIP_BELOW_OCEAN = 2 --1


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:ListenForEvent("Set",function(_,_table)
    --     if _table == nil then
    --         return
    --     end

    --     if _table.pt and _table.pt.x then
    --         inst.Transform:SetPosition(_table.pt.x,0, _table.pt.z)
    --     end

    --     if _table.orientation then
    --         inst.AnimState:SetOrientation(_table.orientation)  
    --     end

    --     if _table.layer then
    --         inst.AnimState:SetLayer(_table.layer)
    --     end

    --     if _table.offset then
    --         inst.AnimState:SetFinalOffset(_table.offset)
    --     end
        
    -- end)

    return inst
end


return Prefab("fwd_in_pdt_room_background", fn, assets)