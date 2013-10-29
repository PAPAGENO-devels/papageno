CheckFirstTime("bb.lua")
bb = Set:create("bb.set", "blimp bridge", { bb_bmpla = 0, bb_bmpla = 1 })
blimp_sound_killer = function() -- line 12
    while sound_playing("blimp.imu") and (system.currentSet == gt or system.currentSet == bp or system.currentSet == bb or inInventorySet()) do
        break_here()
    end
    stop_sound("blimp.imu")
end
bb.blimp_vol_close = 15
bb.blimp_vol_med = 7
bb.blimp_vol_far = 3
bb.enter = function(arg1) -- line 32
    single_start_script(foghorn_sfx)
    bb:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    bb.blimp.hObjectState = bb:add_object_state(bb_bmpla, "bb_props.bm", nil, OBJSTATE_UNDERLAY, FALSE)
    bb.blimp:set_object_state("bb_props.cos")
    bb.blimp:play_chore_looping(0)
    single_start_sfx("blimp.imu")
    set_vol("blimp.imu", bb.blimp_vol_close)
    set_pan("blimp.imu", 100)
    single_start_script(blimp_sound_killer)
end
bb.exit = function(arg1) -- line 44
    stop_script(foghorn_sfx)
    bb.blimp:free_object_state()
end
bb.blimp = Object:create(bb, "/bbtx003/blimp", -5.0626798, -19.3022, 26.608, { range = 15 })
bb.blimp.use_pnt_x = 0.36732501
bb.blimp.use_pnt_y = -29.2432
bb.blimp.use_pnt_z = 19.6
bb.blimp.use_rot_x = 0
bb.blimp.use_rot_y = 25.3396
bb.blimp.use_rot_z = 0
bb.blimp.lookAt = function(arg1) -- line 63
    manny:say_line("/bbma004/")
    wait_for_message()
    manny:say_line("/bbma005/")
end
bb.blimp.use = function(arg1) -- line 69
    manny:say_line("/bbma006/")
end
bb.gt_door = Object:create(bb, "/bbtx001/bridge", 0.43203801, -22.972799, 19.958, { range = 0.60000002 })
bb.gt_door.use_pnt_x = 0.36203799
bb.gt_door.use_pnt_y = -23.407801
bb.gt_door.use_pnt_z = 19.6
bb.gt_door.use_rot_x = 0
bb.gt_door.use_rot_y = -359.76901
bb.gt_door.use_rot_z = 0
bb.gt_door.out_pnt_x = 0.360199
bb.gt_door.out_pnt_y = -22.9911
bb.gt_door.out_pnt_z = 19.6
bb.gt_door.out_rot_x = 0
bb.gt_door.out_rot_y = -359.76901
bb.gt_door.out_rot_z = 0
bb.gt_door.touchable = FALSE
bb.gt_door.walkOut = function(arg1) -- line 95
    gt:come_out_door(gt.bb_door)
end
bb.bp_door = Object:create(bb, "/bbtx002/bridge", 0.37345499, -36.2756, 20.011, { range = 0.60000002 })
bb.bp_door.use_pnt_x = 0.37345499
bb.bp_door.use_pnt_y = -36.029598
bb.bp_door.use_pnt_z = 19.6
bb.bp_door.use_rot_x = 0
bb.bp_door.use_rot_y = -180.12801
bb.bp_door.use_rot_z = 0
bb.bp_door.out_pnt_x = 0.37305701
bb.bp_door.out_pnt_y = -36.208099
bb.bp_door.out_pnt_z = 19.6
bb.bp_door.out_rot_x = 0
bb.bp_door.out_rot_y = -180.12801
bb.bp_door.out_rot_z = 0
bb.bp_door.touchable = FALSE
bb.bp_door.walkOut = function(arg1) -- line 118
    bp:come_out_door(bp.bb_door)
end
