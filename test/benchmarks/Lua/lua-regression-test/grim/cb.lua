CheckFirstTime("cb.lua")
cb = Set:create("cb.set", "cafe balcony", { cb_intha = 0 })
dofile("cb_blimp.lua")
dofile("cb_boat.lua")
cb.look_away_point = { x = 0.311325, y = 4.10521, z = 1.911 }
cb.meche_path = function() -- line 17
    meche:walkto(4.08787, -1.92565, -0.659681)
    meche:wait_for_actor()
    meche:walkto(6.17326, 2.69197, -1.9)
    meche:wait_for_actor()
end
cb.alex_derek_and_steves_idea = function() -- line 30
    START_CUT_SCENE()
    manny:head_look_at(nil)
    manny:setpos(-0.154667, -0.453814, 1.77)
    manny:setrot(0, 251.954, 0)
    meche:put_in_set(cb)
    meche:set_costume("meche_ruba.cos")
    meche:set_walk_chore(meche_ruba_walk, "meche_ruba.cos")
    meche:setpos(-0.606845, -0.863569, -0.340007)
    meche:setrot(0, 271.087, 0)
    meche:follow_boxes()
    meche:set_time_scale(1.5)
    meche:set_walk_rate(0.5)
    break_here()
    start_script(manny.walk_and_face, manny, -0.381325, 0.825213, 1.77, 0, 356.986, 0)
    sleep_for(1000)
    manny:say_line("/clma002/")
    break_here()
    start_script(cb.meche_path)
    break_here()
    wait_for_script(manny.walk_and_face)
    END_CUT_SCENE()
end
cb.meche = cb.alex_derek_and_steves_idea
cb.enter = function(arg1) -- line 78
    single_start_script(foghorn_sfx)
    cb:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -10, 10, 20)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    cb.blimp.hObjectState = cb:add_object_state(cb_intha, "cb_blimp.bm", nil, OBJSTATE_UNDERLAY, FALSE)
    cb.blimp:set_object_state("cb_blimp.cos")
    cb.boat.hObjectState = cb:add_object_state(cb_intha, "cb_boat.bm", nil, OBJSTATE_OVERLAY, TRUE)
    cb.boat:set_object_state("cb_boat.cos")
    play_movie_looping("cb_water.snm", 0, 52)
    if meche.shanghaid then
        cb.blimp:play_chore(cb_blimp_here)
        cb.boat:play_chore(cb_boat_gone)
    else
        cb.blimp:play_chore(cb_blimp_gone)
        cb.boat:play_chore(cb_boat_here)
    end
end
cb.exit = function(arg1) -- line 100
    StopMovie()
    KillActorShadows(manny.hActor)
    stop_script(foghorn_sfx)
    meche:free()
    stop_script(cb.alex_derek_and_steves_idea)
    stop_script(cb.meche_path)
end
cb.boat = Object:create(cb, "", 0, 0, 0, { range = 0 })
cb.blimp = Object:create(cb, "", 0, 0, 0, { range = 0 })
cb.cf_door = Object:create(cb, "/cbtx044/door", -0.59602702, -0.89752799, 2.27, { range = 0.60000002 })
cb.cf_door.use_pnt_x = -0.59602702
cb.cf_door.use_pnt_y = -0.99252802
cb.cf_door.use_pnt_z = 1.77
cb.cf_door.use_rot_x = 0
cb.cf_door.use_rot_y = -1041.4301
cb.cf_door.use_rot_z = 0
cb.cf_door.out_pnt_x = -0.81307399
cb.cf_door.out_pnt_y = -0.56632
cb.cf_door.out_pnt_z = 1.77
cb.cf_door.out_rot_x = 0
cb.cf_door.out_rot_y = 21.619101
cb.cf_door.out_rot_z = 0
cb.cf_door.touchable = FALSE
cb.co_box = cb.cf_door
cb.cf_door.walkOut = function(arg1) -- line 143
    cf:come_out_door(cf.cb_door)
end
cb.backside_door = Object:create(cb, "/cbtx045/door", -1.11347, 1.14579, 2.168, { range = 0.60000002 })
cb.backside_door.use_pnt_x = -0.70747101
cb.backside_door.use_pnt_y = 1.14579
cb.backside_door.use_pnt_z = 1.77
cb.backside_door.use_rot_x = 0
cb.backside_door.use_rot_y = 69.372398
cb.backside_door.use_rot_z = 0
cb.backside_door.out_pnt_x = -1.07701
cb.backside_door.out_pnt_y = 1.28476
cb.backside_door.out_pnt_z = 1.77
cb.backside_door.out_rot_x = 0
cb.backside_door.out_rot_y = 69.372398
cb.backside_door.out_rot_z = 0
cb.backside_door.touchable = FALSE
cb.backside_door.walkOut = function(arg1) -- line 167
    START_CUT_SCENE()
    manny:play_chore_looping(mc_walk)
    sleep_for(2000)
    END_CUT_SCENE()
    cb:come_out_door(cb.frontside_door)
end
cb.frontside_door = Object:create(cb, "/cbtx046/door", -1.21359, -1.50973, 2.1689999, { range = 0.60000002 })
cb.frontside_door.use_pnt_x = -0.95459503
cb.frontside_door.use_pnt_y = -1.32573
cb.frontside_door.use_pnt_z = 1.77
cb.frontside_door.use_rot_x = 0
cb.frontside_door.use_rot_y = -244.119
cb.frontside_door.use_rot_z = 0
cb.frontside_door.out_pnt_x = -1.30296
cb.frontside_door.out_pnt_y = -1.44486
cb.frontside_door.out_pnt_z = 1.77
cb.frontside_door.out_rot_x = 0
cb.frontside_door.out_rot_y = -254.759
cb.frontside_door.out_rot_z = 0
cb.frontside_door.touchable = FALSE
cb.frontside_door.walkOut = function(arg1) -- line 194
    START_CUT_SCENE()
    manny:play_chore_looping(mc_walk)
    sleep_for(2000)
    END_CUT_SCENE()
    cb:come_out_door(cb.backside_door)
end
