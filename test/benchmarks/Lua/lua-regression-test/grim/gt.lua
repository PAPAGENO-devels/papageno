CheckFirstTime("gt.lua")
gt = Set:create("gt.set", "lol gate", { gt_estws = 0, gt_estws1 = 0, gt_extst = 1, gt_overhead = 2 })
gt.enter = function(arg1) -- line 18
    single_start_sfx("blimp.imu")
    if system.lastSet == bb then
        set_vol("blimp.imu", bb.blimp_vol_close)
    else
        set_vol("blimp.imu", bb.blimp_vol_med)
    end
    set_pan("blimp.imu", 1)
    single_start_script(blimp_sound_killer)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.84, -0.08, 21)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -0.4, 6.32, 24)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
end
gt.exit = function(arg1) -- line 44
    KillActorShadows(manny.hActor)
end
gt.camerachange = function(arg1, arg2, arg3) -- line 48
    if arg3 == gt_estws then
        set_vol("blimp.imu", bb.blimp_vol_close)
        set_pan("blimp.imu", 1)
    else
        set_vol("blimp.imu", bb.blimp_vol_med)
        set_pan("blimp.imu", 1)
    end
end
gt.exit_pt = Object:create(gt, "/gttx001/exit", -0.795771, 6.0345802, 19.51, { range = 0 })
gt.exit_pt.use_pnt_x = -0.795771
gt.exit_pt.use_pnt_y = 6.0345802
gt.exit_pt.use_pnt_z = 19.51
gt.exit_pt.use_rot_x = 0
gt.exit_pt.use_rot_y = -451.47699
gt.exit_pt.use_rot_z = 0
gt.exit_pt.touchable = FALSE
gt.bb_door = Object:create(gt, "/gttx002/door", -0.31331101, -1.66922, 19.7229, { range = 0 })
gt.bb_door.use_pnt_x = -0.31331101
gt.bb_door.use_pnt_y = -1.1992199
gt.bb_door.use_pnt_z = 19.502899
gt.bb_door.use_rot_x = 0
gt.bb_door.use_rot_y = 179.25301
gt.bb_door.use_rot_z = 0
gt.bb_door.out_pnt_x = -0.31725499
gt.bb_door.out_pnt_y = -1.51079
gt.bb_door.out_pnt_z = 19.501101
gt.bb_door.out_rot_x = 0
gt.bb_door.out_rot_y = 179.25301
gt.bb_door.out_rot_z = 0
gt.bb_box = gt.bb_door
gt.bb_door.walkOut = function(arg1) -- line 96
    bb:come_out_door(bb.gt_door)
end
gt.tb_door = Object:create(gt, "/gttx003/door", -0.427156, 7.0579801, 19.51, { range = 0 })
gt.tb_door.use_pnt_x = -0.55780602
gt.tb_door.use_pnt_y = 6.31182
gt.tb_door.use_pnt_z = 19.51
gt.tb_door.use_rot_x = 0
gt.tb_door.use_rot_y = -7.7581201
gt.tb_door.use_rot_z = 0
gt.tb_door.out_pnt_x = -0.532242
gt.tb_door.out_pnt_y = 6.5
gt.tb_door.out_pnt_z = 19.51
gt.tb_door.out_rot_x = 0
gt.tb_door.out_rot_y = -7.7581201
gt.tb_door.out_rot_z = 0
gt.tb_box = gt.tb_door
gt.tb_door.walkOut = function(arg1) -- line 117
    if not tb.seen_intro then
        tb.needs_intro = TRUE
    end
    tb:come_out_door(tb.gt_door)
end
gt.sl_door = Object:create(gt, "/gttx004/door", -0.16857301, 4.89534, 22.200001, { range = 0.60000002 })
gt.sl_door.use_pnt_x = -1.5320899
gt.sl_door.use_pnt_y = 4.9860201
gt.sl_door.use_pnt_z = 22.200001
gt.sl_door.use_rot_x = 0
gt.sl_door.use_rot_y = 622.61102
gt.sl_door.use_rot_z = 0
gt.sl_door.out_pnt_x = -1.2524199
gt.sl_door.out_pnt_y = 4.9498701
gt.sl_door.out_pnt_z = 22.200001
gt.sl_door.out_rot_x = 0
gt.sl_door.out_rot_y = 622.61102
gt.sl_door.out_rot_z = 0
gt.stair_box = gt.sl_door
gt.camera_script = function() -- line 141
    local local1, local2, local3
    repeat
        local1, local2, local3 = GetActorPos(system.currentActor.hActor)
        break_here()
    until local3 > 21
    system.currentSet:current_setup(gt_estws)
end
gt.sl_door.walkOut = function(arg1) -- line 150
    sl:come_out_door(sl.gt_door)
end
gt.sl_door.skipWalkOut = function(arg1) -- line 154
    kill_override()
    sl:come_out_door(sl.gt_door)
end
