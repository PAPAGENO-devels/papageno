CheckFirstTime("te.lua")
te = Set:create("te.set", "theater sewer", { te_intws = 0, te_ovrhd = 1 })
te.enter = function(arg1) -- line 18
    start_script(sewer_drip)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -30, -40, 600)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
te.exit = function(arg1) -- line 30
    stop_script(sewer_drip)
    KillActorShadows(manny.hActor)
end
te.holes = Object:create(te, "/tetx001/grates", -0.55016202, 0.73949301, 0.15000001, { range = 0.60000002 })
te.holes.use_pnt_x = -0.48016199
te.holes.use_pnt_y = 0.45949301
te.holes.use_pnt_z = 0
te.holes.use_rot_x = 0
te.holes.use_rot_y = -1090.9
te.holes.use_rot_z = 0
te.holes.parent = lw.hole
te.hole = Object:create(te, "/tetx002/grating", -0.015843101, 0.74271798, 0.20999999, { range = 0.60000002 })
te.hole.use_pnt_x = -0.055842999
te.hole.use_pnt_y = 0.45271799
te.hole.use_pnt_z = 0
te.hole.use_rot_x = 0
te.hole.use_rot_y = -1112.52
te.hole.use_rot_z = 0
te.hole.parent = lw.hole
te.hole2 = Object:create(te, "/tetx003/grating", -0.621499, -0.79304802, 0.16, { range = 0.60000002 })
te.hole2.use_pnt_x = -0.63298303
te.hole2.use_pnt_y = -0.601632
te.hole2.use_pnt_z = 0
te.hole2.use_rot_x = 0
te.hole2.use_rot_y = -867.81299
te.hole2.use_rot_z = 0
te.hole2.parent = lw.hole
te.sh_door = Object:create(te, "/tetx004/sewer", 0.375756, -0.197089, 0.41999999, { range = 2 })
te.sh_door.use_pnt_x = -0.113849
te.sh_door.use_pnt_y = -0.195016
te.sh_door.use_pnt_z = 0
te.sh_door.use_rot_x = 0
te.sh_door.use_rot_y = 280.53699
te.sh_door.use_rot_z = 0
te.sh_door.out_pnt_x = 0.125
te.sh_door.out_pnt_y = -0.150581
te.sh_door.out_pnt_z = 0
te.sh_door.out_rot_x = 0
te.sh_door.out_rot_y = 280.53699
te.sh_door.out_rot_z = 0
te.sh_door:make_untouchable()
te.sh_door.walkOut = function(arg1) -- line 95
    START_CUT_SCENE()
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:wait_for_actor()
    single_start_script(sh.mount_ladder, sh)
    END_CUT_SCENE()
end
te.th_ladder = Ladder:create(te, "/tetx005/", 0.51663202, -0.048954699, 0.92000002, { range = 1 })
te.th_base = te.th_ladder
te.th_top = te.th_ladder
te.th_ladder.base.use_pnt_x = -6.25
te.th_ladder.base.use_pnt_y = -0.620013
te.th_ladder.base.use_pnt_z = 0
te.th_ladder.base.use_rot_x = 0
te.th_ladder.base.use_rot_y = 95
te.th_ladder.base.use_rot_z = 0
te.th_ladder.base.out_pnt_x = -5.90662
te.th_ladder.base.out_pnt_y = -0.49353999
te.th_ladder.base.out_pnt_z = 0
te.th_ladder.base.out_rot_x = 0
te.th_ladder.base.out_rot_y = 297.85901
te.th_ladder.base.out_rot_z = 0
te.th_ladder.top.use_pnt_x = -6.25
te.th_ladder.top.use_pnt_y = -0.620013
te.th_ladder.top.use_pnt_z = 2
te.th_ladder.top.use_rot_x = 0
te.th_ladder.top.use_rot_y = 95
te.th_ladder.top.use_rot_z = 0
te.th_ladder.minz = 0
te.th_ladder.maxz = 2
te.th_ladder.base.box = "th_base"
te.th_ladder.top.box = "th_top"
te.th_ladder.lookAt = function(arg1) -- line 136
    system.default_response("ladder")
end
te.th_ladder.pickUp = function(arg1) -- line 140
    system.default_response("attached")
end
te.th_ladder.walkOut = function(arg1, arg2) -- line 144
    if arg2 == arg1.top.box then
        th:climb_in()
        if not th.met_thunder_boys then
            start_script(th.meet_the_thunder_boys)
        end
    end
end
te.th_ladder.climbOut = function(arg1, arg2) -- line 153
    if manny.is_climbing and arg2 == arg1.top.box then
        stop_script(climb_actor_up)
        stop_script(climb_actor_down)
        ResetMarioControls()
        manny:stop_climb_ladder()
        arg1:walkOut(arg2)
    else
        Ladder.climbOut(arg1, arg2)
    end
end
te.ly_door = Object:create(te, "", -1.22983, 0.70003599, 0.73900002, { range = 1 })
te.ly_door.use_pnt_x = -1.27791
te.ly_door.use_pnt_y = 0.50864899
te.ly_door.use_pnt_z = 0
te.ly_door.use_rot_x = 0
te.ly_door.use_rot_y = 2.8397501
te.ly_door.use_rot_z = 0
te.ly_door.out_pnt_x = -1.12474
te.ly_door.out_pnt_y = 1.21507
te.ly_door.out_pnt_z = 0.29434901
te.ly_door.out_rot_x = 0
te.ly_door.out_rot_y = 0.650204
te.ly_door.out_rot_z = 0
te.ly_door.lookAt = function(arg1) -- line 185
    manny:say_line("/shma009/")
end
te.ly_door.walkOut = function(arg1) -- line 189
    if not manny.thunder then
        ResetMarioControls()
        manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
        manny:say_line("/shma007/")
    else
        ly.service_door:comeOut()
    end
end
