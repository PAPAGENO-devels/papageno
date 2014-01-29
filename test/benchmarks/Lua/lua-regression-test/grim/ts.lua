CheckFirstTime("ts.lua")
ts = Set:create("ts.set", "track stairs", { ts_crdws = 0, ts_overhead = 1 })
ts.fade_crowd = function() -- line 18
    fade_sfx("tkCrowd.IMU", 1000, 50)
end
ts.enter = function(arg1) -- line 22
    start_script(play_movie_looping, "ts_crowd.snm", 88, 0)
    start_script(tb.off_screen_kittys)
    start_sfx("tkCrowd.IMU", IM_LOW_PRIORITY, 0)
    start_script(ts.fade_crowd)
    ts:add_ambient_sfx({ "tkCheer1.wav", "tkCheer2.wav", "tkCheer3.wav", "tkCheer4.wav" }, { min_delay = 6000, max_delay = 10000, min_volume = 80, max_volume = 127 })
end
ts.exit = function(arg1) -- line 31
    StopMovie()
    stop_script(ts.fade_crowd)
    stop_script(tb.off_screen_kittys)
    stop_sound("tkCrowd.IMU")
end
ts.crowd1 = Object:create(ts, "/tstx001/crowd", 3.12817, -0.0023149999, 0.12, { range = 1.75 })
ts.crowd1.use_pnt_x = 1.3667001
ts.crowd1.use_pnt_y = 0.20277999
ts.crowd1.use_pnt_z = 0
ts.crowd1.use_rot_x = 0
ts.crowd1.use_rot_y = -98.857399
ts.crowd1.use_rot_z = 0
ts.crowd1.lookAt = function(arg1) -- line 51
    soft_script()
    manny:say_line("/tsma002/")
    if not ts.grossed then
        manny:wait_for_message()
        manny:say_line("/tsma003/")
        manny:wait_for_message()
        manny:say_line("/tsma004/")
        manny:shrug_gesture()
    end
end
ts.crowd1.run_from = function(arg1) -- line 63
    START_CUT_SCENE()
    manny:head_look_at(nil)
    start_script(manny.walkto, manny, arg1)
    arg1:lookAt()
    manny:wait_for_message()
    END_CUT_SCENE()
    if not ts.grossed then
        ts.grossed = TRUE
        manny:say_line("/tsma005/")
        manny:twist_head_gesture()
    end
end
ts.crowd1.walkOut = function(arg1) -- line 77
    arg1:run_from()
end
ts.crowd2 = Object:create(ts, "/tstx006/crowd", 3.12817, -0.0023149999, 0.12, { range = 1.75 })
ts.crowd2.use_pnt_x = 1.34399
ts.crowd2.use_pnt_y = -0.224216
ts.crowd2.use_pnt_z = 0
ts.crowd2.use_rot_x = 0
ts.crowd2.use_rot_y = -84.819099
ts.crowd2.use_rot_z = 0
ts.crowd2.parent = ts.crowd1
ts.tb_door = Object:create(ts, "/tstx007/door", -0.41182801, -0.0023149999, 0.89999998, { range = 0 })
ts.tb_door.use_pnt_x = 0.0879535
ts.tb_door.use_pnt_y = -0.18852299
ts.tb_door.use_pnt_z = 0.39476901
ts.tb_door.use_rot_x = 0
ts.tb_door.use_rot_y = 95.641197
ts.tb_door.use_rot_z = 0
ts.tb_door.out_pnt_x = -0.30000001
ts.tb_door.out_pnt_y = -0.235337
ts.tb_door.out_pnt_z = 0.54900002
ts.tb_door.out_rot_x = 0
ts.tb_door.out_rot_y = 96.262001
ts.tb_door.out_rot_z = 0
ts.tb_door.walkOut = function(arg1) -- line 112
    if not tb.seen_intro then
        tb.needs_intro = TRUE
    end
    tb:come_out_door(tb.ts_door)
end
ts.tx_door = Object:create(ts, "/tstx008/stairs", 1.12817, 1.29769, 0.12, { range = 0.84792501 })
ts.tx_door.use_pnt_x = 1.12906
ts.tx_door.use_pnt_y = 0.56028402
ts.tx_door.use_pnt_z = 0
ts.tx_door.use_rot_x = 0
ts.tx_door.use_rot_y = -8.9064798
ts.tx_door.use_rot_z = 0
ts.tx_door.lookAt = function(arg1) -- line 127
    manny:say_line("/tsma009/")
end
ts.tx_door.walkOut = function(arg1) -- line 131
    tx:come_out_door(ts.tx_door)
end
ts.kh_door = Object:create(ts, "/tstx010/hallway", 0.87589401, -1.41167, 0.40000001, { range = 0.62 })
ts.kh_door.use_pnt_x = 1.02468
ts.kh_door.use_pnt_y = -1.0228601
ts.kh_door.use_pnt_z = 0
ts.kh_door.use_rot_x = 0
ts.kh_door.use_rot_y = -195.175
ts.kh_door.use_rot_z = 0
ts.kh_door.out_pnt_x = 0.94876403
ts.kh_door.out_pnt_y = -1.30316
ts.kh_door.out_pnt_z = 0
ts.kh_door.out_rot_x = 0
ts.kh_door.out_rot_y = -195.175
ts.kh_door.out_rot_z = 0
ts.kh_door.walkOut = function(arg1) -- line 151
    kh:come_out_door(kh.ts_door)
end
ts.kh_door.lookAt = function(arg1) -- line 155
    manny:say_line("/tsma011/")
end
