CheckFirstTime("rp.lua")
rp = Set:create("rp.set", "ramp", { rp_rmpws = 0, rp_overhead = 1 })
rp.camera_adjusts = { 350 }
rp.enter = function(arg1) -- line 20
    start_sfx("traffic1.imu")
    manny.footsteps = footsteps.pavement
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -6000, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -6000, 4000, 5000.5)
    SetActorShadowPlane(manny.hActor, "shadow2")
    AddShadowPlane(manny.hActor, "shadow2")
end
rp.exit = function(arg1) -- line 37
    stop_sound("traffic1.imu")
    KillActorShadows(manny.hActor)
end
rp.freeway_sign = Object:create(rp, "/rptx003/sign", 1.0418299, 0.180627, 1.52, { range = 2 })
rp.freeway_sign.use_pnt_x = 1.0418299
rp.freeway_sign.use_pnt_y = -0.69937301
rp.freeway_sign.use_pnt_z = 0
rp.freeway_sign.use_rot_x = 0
rp.freeway_sign.use_rot_y = -719.96899
rp.freeway_sign.use_rot_z = 0
rp.freeway_sign.lookAt = function(arg1) -- line 55
    soft_script()
    manny:say_line("/rpma004/")
    wait_for_message()
    manny:say_line("/rpma005/")
end
rp.freeway_sign.use = rp.freeway_sign.lookAt
rp.on_ramp = Object:create(rp, "/rptx006/on-ramp", -2.19894, 3.9306099, 0.62341702, { range = 2 })
rp.on_ramp.use_pnt_x = -1.53894
rp.on_ramp.use_pnt_y = 3.38061
rp.on_ramp.use_pnt_z = 0.163417
rp.on_ramp.use_rot_x = 0
rp.on_ramp.use_rot_y = -688.50299
rp.on_ramp.use_rot_z = 0
rp.freeway_box = rp.on_ramp
rp.on_ramp.lookAt = function(arg1) -- line 74
    manny:say_line("/rpma007/")
end
rp.on_ramp.walkOut = function(arg1) -- line 78
    manny:say_line("/rpma008/")
    wait_for_message()
    manny:say_line("/rpma009/")
end
rp.os_door = Object:create(rp, "/rptx001/door", 1.51652, -2.76369, 0.5, { range = 0 })
rp.os_door.use_pnt_x = 1.5719301
rp.os_door.use_pnt_y = -2.22347
rp.os_door.use_pnt_z = 0.059999999
rp.os_door.use_rot_x = 0
rp.os_door.use_rot_y = -181.162
rp.os_door.use_rot_z = 0
rp.os_door.out_pnt_x = 1.56629
rp.os_door.out_pnt_y = -2.50701
rp.os_door.out_pnt_z = 0.059999999
rp.os_door.out_rot_x = 0
rp.os_door.out_rot_y = -181.162
rp.os_door.out_rot_z = 0
rp.os_door:make_untouchable()
rp.os_box = rp.os_door
rp.os_door.walkOut = function(arg1) -- line 107
    os:come_out_door(os.rp_door)
end
rp.st_door = Object:create(rp, "/rptx010/door", -0.50419199, -2.8151901, 0, { range = 0 })
rp.st_door.use_pnt_x = -0.50419199
rp.st_door.use_pnt_y = -2.8151901
rp.st_door.use_pnt_z = 0
rp.st_door.use_rot_x = 0
rp.st_door.use_rot_y = -172.105
rp.st_door.use_rot_z = 0
rp.st_door.out_pnt_x = -0.64355302
rp.st_door.out_pnt_y = -3.2307301
rp.st_door.out_pnt_z = 0
rp.st_door.out_rot_x = 0
rp.st_door.out_rot_y = -164.021
rp.st_door.out_rot_z = 0
rp.st_door:make_untouchable()
rp.st_box = rp.st_door
rp.st_door.walkOut = function(arg1) -- line 131
    st:come_out_door(st.rp_door)
end
rp.st_sidwk_door = Object:create(rp, "/rptx011/door", -1.8547601, -2.4714799, 0.059999999, { range = 0 })
rp.st_sidwk_door.use_pnt_x = -1.8547601
rp.st_sidwk_door.use_pnt_y = -1.74148
rp.st_sidwk_door.use_pnt_z = 0.059999999
rp.st_sidwk_door.use_rot_x = 0
rp.st_sidwk_door.use_rot_y = 187.996
rp.st_sidwk_door.use_rot_z = 0
rp.st_sidwk_door.out_pnt_x = -1.80278
rp.st_sidwk_door.out_pnt_y = -2.11064
rp.st_sidwk_door.out_pnt_z = 0.059999999
rp.st_sidwk_door.out_rot_x = 0
rp.st_sidwk_door.out_rot_y = 187.996
rp.st_sidwk_door.out_rot_z = 0
rp.st_sidwk_door:make_untouchable()
rp.st_sidbox = rp.st_sidwk_door
rp.st_sidwk_door.walkOut = function(arg1) -- line 154
    st:come_out_door(st.rp_sidwk_door)
end
rp.os_st_door = Object:create(rp, "/rptx012/door", 0.39129701, -2.73349, 0, { range = 0 })
rp.os_st_door.use_pnt_x = 0.39129701
rp.os_st_door.use_pnt_y = -2.73349
rp.os_st_door.use_pnt_z = 0
rp.os_st_door.use_rot_x = 0
rp.os_st_door.use_rot_y = -172.129
rp.os_st_door.use_rot_z = 0
rp.os_st_door.out_pnt_x = 0.38170001
rp.os_st_door.out_pnt_y = -3.26548
rp.os_st_door.out_pnt_z = 0
rp.os_st_door.out_rot_x = 0
rp.os_st_door.out_rot_y = -176.996
rp.os_st_door.out_rot_z = 0
rp.os_st_door:make_untouchable()
rp.os_stbox = rp.os_st_door
rp.os_st_door.walkOut = function(arg1) -- line 176
    os:come_out_door(os.rp_st_door)
end
