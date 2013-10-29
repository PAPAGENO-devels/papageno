CheckFirstTime("os.lua")
os = Set:create("os.set", "office steps", { os_stpha = 0, os_top = 1 })
os.camera_adjusts = { 330 }
os.enter = function(arg1) -- line 19
    start_sfx("traffic1.imu")
    set_vol("traffic1.imu", 40)
    manny.footsteps = footsteps.concrete
    NewObjectState(os_stpha, 3, "os_door_to_lo_comp.bm")
    os.lo_door:set_object_state("os_lo_door.cos")
    if reaped_meche then
        os.lo_door:make_touchable()
        os.lo_door.use_pnt_x = -0.0604761
        os.lo_door.use_pnt_y = 0.507589
        os.lo_door.use_pnt_z = 0.01
        MakeSectorActive("lo_box1", FALSE)
        os.lo_door.interest_actor:complete_chore(1)
    end
    SetShadowColor(45, 40, 40)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 3000, -4000, 4000.5)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow7")
    AddShadowPlane(manny.hActor, "shadow9")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, 3000, -4000, 4000.5)
    SetActorShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow4")
    SetActorShadowValid(manny.hActor, -1)
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 3000, -4000, 4000.5)
    SetActorShadowPlane(manny.hActor, "shadow6")
    AddShadowPlane(manny.hActor, "shadow5")
    AddShadowPlane(manny.hActor, "shadow6")
    AddShadowPlane(manny.hActor, "sideshadow3")
    AddShadowPlane(manny.hActor, "sideshadow14")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, 3000, -4000, 4000.5)
    SetActorShadowPlane(manny.hActor, "shadow_door")
    AddShadowPlane(manny.hActor, "shadow_door")
    SetActiveShadow(manny.hActor, 4)
    SetActorShadowPoint(manny.hActor, 3000, -4000, 4000.5)
    SetActorShadowPlane(manny.hActor, "sideshadow1")
    AddShadowPlane(manny.hActor, "sideshadow1")
    AddShadowPlane(manny.hActor, "sideshadow2")
end
os.exit = function() -- line 74
    KillActorShadows(manny.hActor)
    stop_sound("traffic1.imu")
end
os.car = Object:create(os, "/ostx006/car", -1.425, -2.79619, -0.45199999, { range = 0.89999998 })
os.car.use_pnt_x = -1.395
os.car.use_pnt_y = -2.1561899
os.car.use_pnt_z = -0.84200001
os.car.use_rot_x = 0
os.car.use_rot_y = -150.46899
os.car.use_rot_z = 0
os.car.lookAt = function(arg1) -- line 92
    soft_script()
    manny:say_line("/osma007/")
    wait_for_message()
    manny:say_line("/osma008/")
end
os.car.pickUp = function(arg1) -- line 99
    system.default_response("tow")
end
os.car.use = function(arg1) -- line 103
    manny:say_line("/osma009/")
end
os.sign = Object:create(os, "/ostx010/sign", -0.69499499, -2.4061899, -0.152, { range = 1 })
os.sign.use_pnt_x = -0.36097699
os.sign.use_pnt_y = -2.175
os.sign.use_pnt_z = -0.84200001
os.sign.use_rot_x = 0
os.sign.use_rot_y = -209.22701
os.sign.use_rot_z = 0
os.sign.lookAt = function(arg1) -- line 116
    manny:say_line("/osma011/")
end
os.sign.pickUp = function(arg1) -- line 120
    system.default_response("bolted")
end
os.sign.use = os.sign.lookAt
os.facade = Object:create(os, "/ostx012/facade", 0.0053950702, -1.20488, 2.0179999, { range = 4 })
os.facade.use_pnt_x = 0.70539498
os.facade.use_pnt_y = -2.17488
os.facade.use_pnt_z = -0.84200001
os.facade.use_rot_x = 0
os.facade.use_rot_y = 24.8806
os.facade.use_rot_z = 0
os.facade.lookAt = function(arg1) -- line 134
    soft_script()
    manny:say_line("/osma013/")
    wait_for_message()
    manny:say_line("/osma014/")
end
os.facade.pickUp = function(arg1) -- line 141
    system.default_response("right")
end
os.facade.use = os.facade.lookAt
os.lo_door = Object:create(os, "/ostx001/door", 0.034118999, 0.80067801, 0.70999998, { range = 1 })
os.lo_door.use_pnt_x = 0.31706801
os.lo_door.use_pnt_y = 0.39784199
os.lo_door.use_pnt_z = 0.0099999998
os.lo_door.use_rot_x = 0
os.lo_door.use_rot_y = 393.504
os.lo_door.use_rot_z = 0
os.lo_door.out_pnt_x = 0.16371199
os.lo_door.out_pnt_y = 0.629291
os.lo_door.out_pnt_z = 0.0099999998
os.lo_door.out_rot_x = 0
os.lo_door.out_rot_y = 393.50201
os.lo_door.out_rot_z = 0
os.lo_door.touchable = TRUE
os.lo_door.use = function(arg1) -- line 170
    if reaped_meche then
        START_CUT_SCENE()
        manny:say_line("/osma002/")
        wait_for_message()
        manny:say_line("/osma003/")
        END_CUT_SCENE()
    else
        START_CUT_SCENE()
        manny:walkto(os.lo_door.out_pnt_x, os.lo_door.out_pnt_y, os.lo_door.out_pnt_z)
        manny:wait_for_actor()
        manny:setrot(0, -705, 0, TRUE)
        manny:start_open_door_anim()
        sleep_for(1000)
        arg1:play_chore(0)
        manny:finish_open_door_anim()
        lo:switch_to_set()
        lo.os_door.interest_actor:complete_chore(0)
        manny:put_in_set(lo)
        manny:setpos(lo.os_door.out_pnt_x, lo.os_door.out_pnt_y, lo.os_door.out_pnt_z)
        manny:setrot(lo.os_door.out_rot_x, lo.os_door.out_rot_y + 180, lo.os_door.out_rot_z)
        lo:force_camerachange()
        manny:walkto(lo.os_door.use_pnt_x, lo.os_door.use_pnt_y, lo.os_door.use_pnt_z)
        manny:wait_for_actor()
        lo.os_door:play_chore(1)
        lo.os_door.interest_actor:wait_for_chore(1)
        END_CUT_SCENE()
    end
end
os.lo_door.lookAt = function(arg1) -- line 201
    system.default_response("closed")
end
os.st_door = Object:create(os, "/ostx004/door", 4.7241201, -1.60932, -0.33000001, { range = 0 })
os.st_box = os.st_door
os.st_door.use_pnt_x = 2.80828
os.st_door.use_pnt_y = -1.35203
os.st_door.use_pnt_z = -0.84200001
os.st_door.use_rot_x = 0
os.st_door.use_rot_y = -794.52301
os.st_door.use_rot_z = 0
os.st_door.out_pnt_x = 3.1367099
os.st_door.out_pnt_y = -1.26107
os.st_door.out_pnt_z = -0.84200001
os.st_door.out_rot_x = 0
os.st_door.out_rot_y = -794.52301
os.st_door.out_rot_z = 0
os.st_door:make_untouchable()
os.st_door.walkOut = function(arg1) -- line 225
    st:come_out_door(st.os_door)
end
os.rp_door = Object:create(os, "/ostx005/door", -3.4669099, -1.88081, -0.40000001, { range = 0 })
os.rp_door.use_pnt_x = -3.0926399
os.rp_door.use_pnt_y = -1.76768
os.rp_door.use_pnt_z = -0.84200102
os.rp_door.use_rot_x = 0
os.rp_door.use_rot_y = -645.66101
os.rp_door.use_rot_z = 0
os.rp_door.out_pnt_x = -3.5720301
os.rp_door.out_pnt_y = -1.63578
os.rp_door.out_pnt_z = -0.84200102
os.rp_door.out_rot_x = 0
os.rp_door.out_rot_y = -645.66101
os.rp_door.out_rot_z = 0
os.rp_door:make_untouchable()
os.rp_box = os.rp_door
os.rp_door.walkOut = function(arg1) -- line 247
    rp:come_out_door(rp.os_door)
end
os.st_st_door = Object:create(os, "/ostx015/door", 0.206909, -2.9842701, -0.89999998, { range = 0 })
os.st_st_door.use_pnt_x = 0.206909
os.st_st_door.use_pnt_y = -2.9842701
os.st_st_door.use_pnt_z = -0.89999998
os.st_st_door.use_rot_x = 0
os.st_st_door.use_rot_y = -828.91498
os.st_st_door.use_rot_z = 0
os.st_st_door.out_pnt_x = 0.82586199
os.st_st_door.out_pnt_y = -3.03512
os.st_st_door.out_pnt_z = -0.89999998
os.st_st_door.out_rot_x = 0
os.st_st_door.out_rot_y = -812.13898
os.st_st_door.out_rot_z = 0
os.st_st_door:make_untouchable()
os.st_box = os.st_st_door
os.st1_box = os.st_st_door
os.st2_box = os.st_st_door
os.st_st_door.walkOut = function(arg1) -- line 271
    st:come_out_door(st.os_st_door)
end
os.rp_st_door = Object:create(os, "/ostx016/door", -1.0897501, -3.3119299, -0.89999998, { range = 0 })
os.rp_st_door.use_pnt_x = -1.0897501
os.rp_st_door.use_pnt_y = -3.3119299
os.rp_st_door.use_pnt_z = -0.89999998
os.rp_st_door.use_rot_x = 0
os.rp_st_door.use_rot_y = -981.88898
os.rp_st_door.use_rot_z = 0
os.rp_st_door.out_pnt_x = -1.4841599
os.rp_st_door.out_pnt_y = -3.36815
os.rp_st_door.out_pnt_z = -0.89999998
os.rp_st_door.out_rot_x = 0
os.rp_st_door.out_rot_y = -981.88898
os.rp_st_door.out_rot_z = 0
os.rp_st_door:make_untouchable()
os.rp_st_box = os.rp_st_door
os.rp_st_door.walkOut = function(arg1) -- line 292
    rp:come_out_door(rp.os_st_door)
end
