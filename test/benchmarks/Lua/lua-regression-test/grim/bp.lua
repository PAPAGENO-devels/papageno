CheckFirstTime("bp.lua")
bp = Set:create("bp.set", "bridge police side", { bp_extws = 0, bp_overhead = 1 })
bp.enter = function(arg1) -- line 20
    single_start_script(foghorn_sfx)
    bp:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    single_start_sfx("blimp.imu")
    set_vol("blimp.imu", bb.blimp_vol_far)
    set_pan("blimp.imu", 127)
    single_start_script(blimp_sound_killer)
    manny:set_collision_mode(COLLISION_SPHERE)
    SetActorCollisionScale(manny.hActor, 0.34999999)
    local local1 = 0
    repeat
        local1 = local1 + 1
        if not table_actor[local1] then
            table_actor[local1] = Actor:create(nil, nil, nil, "table" .. local1)
        end
        table_actor[local1]:set_costume("x_spot.cos")
        table_actor[local1]:set_visibility(FALSE)
        table_actor[local1]:put_in_set(bp)
        table_actor[local1]:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(table_actor[local1].hActor, 0.30000001)
        if local1 == 1 then
            table_actor[local1]:setpos({ x = 3.3933699, y = -1.68363, z = 12.168 })
        elseif local1 == 2 then
            table_actor[local1]:setpos({ x = 3.3933699, y = -5.4116302, z = 12.168 })
        end
    until local1 == 2
    SetShadowColor(10, 10, 18)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 3.2925, -1.9617, 13.55)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 3.2100201, -5.55652, 13.001)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 0.745157, 0.79060501, 14.14)
    SetActorShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow3")
end
bp.exit = function(arg1) -- line 66
    stop_script(foghorn_sfx)
    manny:set_collision_mode(COLLISION_OFF)
    local local1 = 0
    repeat
        local1 = local1 + 1
        table_actor[local1]:free()
    until local1 == 2
    KillActorShadows(manny.hActor)
end
bp.statue = Object:create(bp, "/bptx003/statue", 0.00035762801, 0.801211, 16.139999, { range = 6 })
bp.statue.use_pnt_x = 2.7003601
bp.statue.use_pnt_y = 0.35121
bp.statue.use_pnt_z = 11.8
bp.statue.use_rot_x = 0
bp.statue.use_rot_y = 56.3293
bp.statue.use_rot_z = 0
bp.statue.count = 0
bp.statue.lookAt = function(arg1) -- line 95
    bp.statue.count = bp.statue.count + 1
    if bp.statue.count == 1 then
        manny:say_line("/bpma004/")
    elseif bp.statue.count == 2 then
        manny:say_line("/bpma005/")
    elseif bp.statue.count == 3 then
        manny:say_line("/bpma006/")
    elseif bp.statue.count == 4 then
        manny:say_line("/bpma007/")
    elseif bp.statue.count == 5 then
        manny:say_line("/bpma008/")
    else
        manny:say_line("/bpma009/")
    end
end
bp.statue.use = bp.statue.lookAt
bp.bb_door = Object:create(bp, "/bptx001/bridge", 3.06215, -5.5877399, 12.294, { range = 0.60000002 })
bp.bb_door.use_pnt_x = 3.1201501
bp.bb_door.use_pnt_y = -4.6877398
bp.bb_door.use_pnt_z = 11.8
bp.bb_door.use_rot_x = 0
bp.bb_door.use_rot_y = -175.24899
bp.bb_door.use_rot_z = 0
bp.bb_door.out_pnt_x = 3.1254699
bp.bb_door.out_pnt_y = -5.5417299
bp.bb_door.out_pnt_z = 11.8
bp.bb_door.out_rot_x = 0
bp.bb_door.out_rot_y = -174.673
bp.bb_door.out_rot_z = 0
bp.bb_box = bp.bb_door
bp.bb_door.touchable = FALSE
bp.bb_door.walkOut = function(arg1) -- line 143
    bb:come_out_door(bb.bp_door)
end
bp.pc_door = Object:create(bp, "/bptx002/tunnel", 1.35739, 1.27108, 12.2, { range = 0.60000002 })
bp.pc_door.use_pnt_x = 1.55739
bp.pc_door.use_pnt_y = 1.27108
bp.pc_door.use_pnt_z = 11.8
bp.pc_door.use_rot_x = 0
bp.pc_door.use_rot_y = 815.22101
bp.pc_door.use_rot_z = 0
bp.pc_door.out_pnt_x = 1.3490601
bp.pc_door.out_pnt_y = 1.25204
bp.pc_door.out_pnt_z = 11.8
bp.pc_door.out_rot_x = 0
bp.pc_door.out_rot_y = 815.22101
bp.pc_door.out_rot_z = 0
bp.pc_box = bp.pc_door
bp.pc_door.touchable = FALSE
bp.pc_door.walkOut = function(arg1) -- line 165
    pc:come_out_door(pc.bp_door)
end
