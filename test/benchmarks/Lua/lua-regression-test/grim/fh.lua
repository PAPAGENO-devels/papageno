CheckFirstTime("fh.lua")
fh = Set:create("fh.set", "temp factory hub", { fh_top = 0, fh_elvha = 1 })
dofile("fh_propellor.lua")
fh.cheat_boxes = { cheat_box1 = 0 }
fh.step_in_elevator = function(arg1) -- line 16
    fh.propellor:stop_chore()
    fh.propellor:play_chore(fh_propellor_still)
    play_movie("fh_wi.snm", 512, 96)
    wait_for_movie()
    play_movie("fh_ed.snm", 432, 32)
    wait_for_movie()
end
fh.step_outta_elevator = function(arg1) -- line 25
    START_CUT_SCENE()
    set_override(fh.step_outta_elevator_override)
    fh.propellor:stop_chore()
    fh.propellor:play_chore(fh_propellor_still)
    manny:put_in_set(fh)
    manny:setpos(fh.ea_door.out_pnt_x, fh.ea_door.out_pnt_y, fh.ea_door.out_pnt_z)
    manny:setrot(fh.ea_door.out_rot_x, 180 + fh.ea_door.out_rot_y, fh.ea_door.out_rot_z)
    play_movie("fh_eu.snm", 432, 32)
    wait_for_movie()
    fh.propellor:play_chore_looping(fh_propellor_spinning)
    single_start_sfx("fh_prop.IMU", IM_MED_PRIORITY, 100)
    set_pan("fh_prop.IMU", 90)
    manny:walkto(fh.ea_door.use_pnt_x, fh.ea_door.use_pnt_y, fh.ea_door.use_pnt_z)
    END_CUT_SCENE()
end
fh.step_outta_elevator_override = function() -- line 42
    kill_override()
    manny:setpos(fh.ea_door.use_pnt_x, fh.ea_door.use_pnt_y, fh.ea_door.use_pnt_z)
    manny:setrot(fh.ea_door.use_rot_x, 180 + fh.ea_door.use_rot_y, fh.ea_door.use_rot_z)
    fh.propellor:play_chore_looping(fh_propellor_spinning)
    single_start_sfx("fh_prop.IMU", IM_MED_PRIORITY, 100)
    set_pan("fh_prop.IMU", 90)
end
fh.enter = function(arg1) -- line 58
    fh:current_setup(fh_elvha)
    fh.fo_door.hObjectState = fh:add_object_state(fh_elvha, "fh_door.bm", nil, OBJSTATE_STATE, FALSE)
    fh.fo_door:set_object_state("fh_door.cos")
    fh.propellor.hObjectState = fh:add_object_state(fh_elvha, "fh_propellor.bm", nil, OBJSTATE_OVERLAY, FALSE)
    fh.propellor:set_object_state("fh_propellor.cos")
    fh.propellor.touchable = nil
    if fh.fo_door.opened then
        fh.fo_door:make_untouchable()
        fh.fo_door:play_chore(0)
        fh.fo_door:set_new_out_point()
    else
        fh.fo_door:make_touchable()
        fh.fo_door:play_chore(1)
    end
    if system.lastSet ~= ea then
        fh.propellor:play_chore_looping(fh_propellor_spinning)
        start_sfx("fh_prop.IMU", IM_MED_PRIORITY, 100)
        set_pan("fh_prop.IMU", 90)
    end
end
fh.exit = function(arg1) -- line 80
    stop_sound("fh_prop.IMU")
end
fh.propellor = Object:create(fh, "", 0, 0, 0, { range = 0 })
fh.fo_door = Object:create(fh, "/fhtx001/door", -0.86454803, -3.0660501, -0.83710003, { range = 0.60000002 })
fh.fo_door.use_pnt_x = -1.09732
fh.fo_door.use_pnt_y = -2.76824
fh.fo_door.use_pnt_z = -1.28
fh.fo_door.use_rot_x = 0
fh.fo_door.use_rot_y = -122.648
fh.fo_door.use_rot_z = 0
fh.fo_door.out_pnt_x = -0.90325898
fh.fo_door.out_pnt_y = -2.86462
fh.fo_door.out_pnt_z = -1.3
fh.fo_door.out_rot_x = 0
fh.fo_door.out_rot_y = 194.508
fh.fo_door.out_rot_z = 0
fh.fo_door.opened = TRUE
fh.fo_door.set_new_out_point = function(arg1) -- line 120
    arg1.out_pnt_x = -0.788647
    arg1.out_pnt_y = -3.26008
    arg1.out_pnt_z = -1.3
    arg1.out_rot_x = 0
    arg1.out_rot_y = 194.51
    arg1.out_rot_z = 0
end
fh.fo_door.walkOut = function(arg1) -- line 129
    if dr.reunited then
        fo:come_out_door(fo.fh_door)
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1, TRUE)
        manny:play_chore(mn2_reach_med, "mn2.cos")
        manny:say_line("/fhma002/")
        sleep_for(500)
        manny:wait_for_chore(mn2_reach_med, "mn2.cos")
        manny:stop_chore(mn2_reach_med, "mn2.cos")
        ResetMarioControls()
        manny:walkto(-1.2911, -2.6914, -1.28, 0, 10.457, 0)
        END_CUT_SCENE()
    end
end
fh.ea_door = Object:create(fh, "/fhtx003/elevator", -0.50551897, -0.00125456, -0.82999998, { range = 1 })
fh.ea_door.use_pnt_x = -1.16362
fh.ea_door.use_pnt_y = -0.041154601
fh.ea_door.use_pnt_z = -1.3
fh.ea_door.use_rot_x = 0
fh.ea_door.use_rot_y = 283.51901
fh.ea_door.use_rot_z = 0
fh.ea_door.out_pnt_x = -0.52647197
fh.ea_door.out_pnt_y = 0.0197767
fh.ea_door.out_pnt_z = -1.3
fh.ea_door.out_rot_x = 0
fh.ea_door.out_rot_y = 280.55099
fh.ea_door.out_rot_z = 0
fh.ea_door.lookAt = function(arg1) -- line 162
    manny:say_line("/fhma004/")
end
fh.ea_door.opened = TRUE
fh.ea_door.walkOut = function(arg1) -- line 168
    manny:clear_hands()
    if manny:walkto_object(arg1, TRUE) then
        START_CUT_SCENE()
        fh:step_in_elevator()
        END_CUT_SCENE()
        ea:come_out_door(ea.fh_door)
    end
end
fh.ea_door.comeOut = function(arg1) -- line 178
    start_script(fh.step_outta_elevator, fh)
end
fh.vd_door = Object:create(fh, "/fhtx005/walkway", 1.7792799, 8.3426905, 0.44999999, { range = 0 })
fh.vd_door.use_pnt_x = -3.4500501
fh.vd_door.use_pnt_y = 0.50798398
fh.vd_door.use_pnt_z = -1.3
fh.vd_door.use_rot_x = 0
fh.vd_door.use_rot_y = -366.263
fh.vd_door.use_rot_z = 0
fh.vd_door.out_pnt_x = -3.4184799
fh.vd_door.out_pnt_y = 0.79666197
fh.vd_door.out_pnt_z = -1.3
fh.vd_door.out_rot_x = 0
fh.vd_door.out_rot_y = -366.263
fh.vd_door.out_rot_z = 0
fh.vd_door.walkOut = function(arg1) -- line 197
    vd:come_out_door(vd.fh_door)
end
fh.vd_door.lookAt = function(arg1) -- line 201
    manny:say_line("/fhma006/")
end
