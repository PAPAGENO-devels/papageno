CheckFirstTime("lo.lua")
dofile("br_talk_idles.lua")
lo = Set:create("lo.set", "lobby", { lo_tubws = 0, lo_tubws1 = 0, lo_pckws = 1, lo_elews = 2, lo_ovrhd = 3 })
lo.shrinkable = 0.022
lo.examine_statuary = function(arg1, arg2) -- line 15
    soft_script()
    if not arg2.is_pres and not arg2.is_nobody then
        if not lo.seen_statue then
            lo.seen_statue = TRUE
            arg2.is_pres = TRUE
        else
            arg2.is_nobody = TRUE
        end
    end
    if arg2.is_pres then
        manny:say_line("/loma017/")
        wait_for_message()
        manny:say_line("/loma018/")
        wait_for_message()
        manny:say_line("/gtcma13/")
    else
        manny:say_line("/loma020/")
        wait_for_message()
        manny:say_line("/loma021/")
        wait_for_message()
        manny:say_line("/loma022/")
    end
end
lo.meet_brennis = function(arg1) -- line 41
    START_CUT_SCENE()
    brennis.opened_tube_room = TRUE
    brennis:put_in_set(lo)
    brennis:set_costume("brennis_fix_idle.cos")
    brennis:set_mumble_chore(brennis_fix_idle_mumble)
    brennis:set_talk_chore(1, brennis_fix_idle_stop_talk)
    brennis:set_talk_chore(2, brennis_fix_idle_a)
    brennis:set_talk_chore(3, brennis_fix_idle_c)
    brennis:set_talk_chore(4, brennis_fix_idle_e)
    brennis:set_talk_chore(5, brennis_fix_idle_f)
    brennis:set_talk_chore(6, brennis_fix_idle_l)
    brennis:set_talk_chore(7, brennis_fix_idle_m)
    brennis:set_talk_chore(8, brennis_fix_idle_o)
    brennis:set_talk_chore(9, brennis_fix_idle_t)
    brennis:set_talk_chore(10, brennis_fix_idle_u)
    brennis:setpos(-0.997259, -1.46296, 0.00104892)
    brennis:setrot(0, 283.243, 0)
    brennis:say_line("/lobs001/")
    manny:walkto(-0.00263746, -1.56528, 0, 0, 182.298, 0)
    manny:wait_for_actor()
    lo:current_setup(lo_tubws)
    manny:head_look_at_point(-0.772703, -2.58918, 0.431)
    brennis:play_chore(brennis_fix_idle_walk, "brennis_fix_idle.cos")
    brennis:wait_for_message()
    brennis:stop_chore(brennis_fix_idle_walk, "brennis_fix_idle.cos")
    lo:current_setup(lo_elews)
    manny:head_look_at_point(-0.0757035, -2.13618, 0.62)
    brennis:setpos(-0.236814, -2.42412, 0)
    brennis:setrot(0, 275.074, 0)
    brennis:push_costume("br_talk_idles.cos")
    brennis:say_line("/lobs002/")
    brennis:play_chore(br_talk_idles_idle2talk, "br_talk_idles.cos")
    brennis:wait_for_message()
    brennis:say_line("/lobs003/")
    brennis:wait_for_chore(br_talk_idles_idle2talk, "br_talk_idles.cos")
    brennis:play_chore(br_talk_idles_talk1, "br_talk_idles.cos")
    sleep_for(50)
    manny:backup(250)
    manny:clear_hands()
    brennis:wait_for_message()
    manny:hand_gesture(TRUE)
    manny:tilt_head_gesture(TRUE)
    brennis:say_line("/lobs004/")
    brennis:wait_for_chore(br_talk_idles_talk1, "br_talk_idles.cos")
    brennis:play_chore(br_talk_idles_talk2, "br_talk_idles.cos")
    brennis:wait_for_chore(br_talk_idles_talk2, "br_talk_idles.cos")
    brennis:play_chore(br_talk_idles_talk3, "br_talk_idles.cos")
    brennis:wait_for_message()
    manny:head_forward_gesture()
    manny:say_line("/loma005/")
    manny:wait_for_message()
    brennis:wait_for_chore(br_talk_idles_talk3, "br_talk_idles.cos")
    brennis:say_line("/lobs006/")
    brennis:play_chore(br_talk_idles_talk4, "br_talk_idles.cos")
    brennis:wait_for_chore(br_talk_idles_talk4, "br_talk_idles.cos")
    brennis:wait_for_message()
    manny:twist_head_gesture()
    manny:say_line("/loma007/")
    manny:wait_for_message()
    brennis:say_line("/lobs008/")
    brennis:play_chore(br_talk_idles_walkout, "br_talk_idles.cos")
    brennis:wait_for_chore(br_talk_idles_walkout, "br_talk_idles.cos")
    brennis:wait_for_message()
    lo:current_setup(lo_pckws)
    brennis:pop_costume()
    brennis:setpos(-0.445773, -2.37887, 0)
    brennis:setrot(0, 340.591, 0)
    manny:set_look_rate(120)
    manny:head_look_at_point(0.852075, -2.12674, 0.4725)
    brennis:play_chore(brennis_fix_idle_walk, "brennis_fix_idle.cos")
    sleep_for(1700)
    brennis:stop_chore(brennis_fix_idle_walk)
    brennis:put_in_set(nil)
    brennis:free()
    lo:current_setup(lo_elews)
    sleep_for(200)
    manny:set_look_rate(200)
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
lo.enter = function(arg1) -- line 138
    lo:add_object_state(lo_elews, "lo_elevopen.bm", "lo_elevopen.zbm")
    lo.ha_door:set_object_state("lo_elev.cos")
    lo:add_object_state(lo_elews, "lo_door_to_os_comp.bm")
    lo:add_object_state(lo_elews, "lo_door_to_os_bottom.bm")
    lo:add_object_state(lo_elews, "lo_door_to_os_top.bm")
    lo.os_door:set_object_state("lo_os_door.cos")
    MakeSectorActive("elev_1", FALSE)
    MakeSectorActive("elev_2", FALSE)
    if reaped_bruno then
        lo:add_object_state(lo_pckws, "lo_door_to_pk.bm", "lo_door_to_pk.zbm")
        lo.pk_door:set_object_state("lo_pk_door.cos")
        lo.pk_door:play_chore(0)
        lo:add_object_state(lo_tubws, "lo_door_to_tu.bm", "lo_door_to_tu.zbm")
        lo.tu_door:set_object_state("lo_tu_door.cos")
        lo.tu_door:play_chore(0)
        MakeSectorActive("pk_off", FALSE)
        MakeSectorActive("tu_off", FALSE)
        lo.pk_door:unlock()
        lo.pk_door:open(TRUE)
        lo.tu_door:unlock()
        lo.tu_door:open(TRUE)
    else
        lo.pk_door:close(TRUE)
        lo.pk_door:lock()
        lo.tu_door:close(TRUE)
        lo.tu_door:lock()
    end
    SetShadowColor(20, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.0528794, -1.63393, 12.0612)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
end
lo.exit = function() -- line 184
    KillActorShadows(manny.hActor)
end
lo.train_poster = Object:create(lo, "/lotx023/poster", -1.71795, -1.20274, 0.77999997, { range = 1.5 })
lo.train_poster.use_pnt_x = -1.61795
lo.train_poster.use_pnt_y = -1.62274
lo.train_poster.use_pnt_z = 0
lo.train_poster.use_rot_x = 0
lo.train_poster.use_rot_y = 3.86446
lo.train_poster.use_rot_z = 0
lo.train_poster.lookAt = function(arg1) -- line 201
    soft_script()
    manny:say_line("/loma024/")
    wait_for_message()
    manny:say_line("/loma025/")
end
lo.train_poster.pickUp = function(arg1) -- line 208
    system.default_response("think")
end
lo.train_poster.use = lo.train_poster.lookAt
lo.left_statue = Object:create(lo, "/lotx026/statue", -1.835, -2.6519201, 0.83999997, { range = 1 })
lo.left_statue.use_pnt_x = -1.625
lo.left_statue.use_pnt_y = -2.49192
lo.left_statue.use_pnt_z = 0
lo.left_statue.use_rot_x = 0
lo.left_statue.use_rot_y = -233.967
lo.left_statue.use_rot_z = 0
lo.left_statue.is_pres = FALSE
lo.left_statue.is_nobody = FALSE
lo.left_statue.lookAt = function(arg1) -- line 225
    lo:examine_statuary(lo.left_statue)
end
lo.left_statue.pickUp = function(arg1) -- line 229
    system.default_response("right")
end
lo.left_statue.use = function(arg1) -- line 233
    manny:say_line("/loma027/")
end
lo.right_statue = Object:create(lo, "/lotx028/statue", 1.88481, -2.59693, 0.94, { range = 1 })
lo.right_statue.use_pnt_x = 1.6648099
lo.right_statue.use_pnt_y = -2.4369299
lo.right_statue.use_pnt_z = 0
lo.right_statue.use_rot_x = 0
lo.right_statue.use_rot_y = 269.14099
lo.right_statue.use_rot_z = 0
lo.right_statue.is_pres = FALSE
lo.right_statue.is_nobody = FALSE
lo.right_statue.lookAt = function(arg1) -- line 248
    lo:examine_statuary(lo.right_statue)
end
lo.right_statue.pickUp = function(arg1) -- line 252
    system.default_response("right")
end
lo.right_statue.use = function(arg1) -- line 256
    manny:say_line("/loma029/")
end
lo.ship_poster = Object:create(lo, "/lotx030/poster", 1.6538, -1.1900001, 0.76999998, { range = 1 })
lo.ship_poster.use_pnt_x = 1.6938
lo.ship_poster.use_pnt_y = -1.4400001
lo.ship_poster.use_pnt_z = 0
lo.ship_poster.use_rot_x = 0
lo.ship_poster.use_rot_y = 359.70401
lo.ship_poster.use_rot_z = 0
lo.ship_poster.lookAt = function(arg1) -- line 268
    soft_script()
    manny:say_line("/loma031/")
    wait_for_message()
    manny:say_line("/loma032/")
end
lo.ship_poster.pickUp = function(arg1) -- line 275
    system.default_response("right")
end
lo.ship_poster.use = lo.ship_poster.lookAt
lo.directory = Object:create(lo, "/lotx033/directory", -0.82372701, -2.0003099, 0.56, { range = 1 })
lo.directory.use_pnt_x = -1.05
lo.directory.use_pnt_y = -2.25
lo.directory.use_pnt_z = 0
lo.directory.use_rot_x = 0
lo.directory.use_rot_y = 322.435
lo.directory.use_rot_z = 0
lo.directory.lookAt = function(arg1) -- line 290
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:say_line("/loma034/")
        wait_for_message()
        manny:say_line("/loma035/")
        END_CUT_SCENE()
    end
end
lo.directory.pickUp = function(arg1) -- line 300
    if manny:walkto_object(arg1) then
        system.default_response("attached")
    end
end
lo.directory.use = lo.directory.lookAt
lo.tu_door = Object:create(lo, "/lotx009/door", -2.07604, -1.79489, 0.47999999, { range = 0.80000001 })
lo.lo_tu_box = lo.tu_door
lo.tu_door.passage = { "tu_pass1", "tu_pass2", "tu_pass3", "tu_pass4" }
lo.tu_door.use_pnt_x = -1.862
lo.tu_door.use_pnt_y = -1.904
lo.tu_door.use_pnt_z = 0
lo.tu_door.use_rot_x = 0
lo.tu_door.use_rot_y = 85.015701
lo.tu_door.use_rot_z = 0
lo.tu_door.out_pnt_x = -2.3150001
lo.tu_door.out_pnt_y = -1.86
lo.tu_door.out_pnt_z = 0
lo.tu_door.out_rot_x = 0
lo.tu_door.out_rot_y = 85.015701
lo.tu_door.out_rot_z = 0
lo.tu_door.lookAt = function(arg1) -- line 333
    manny:say_line("/loma010/")
end
lo.tu_door.walkOut = function(arg1) -- line 337
    tu:come_out_door(tu.lo_door)
end
lo.elev_trigger = { }
lo.elev_trigger.walkOut = function(arg1) -- line 346
    lo.ha_door:open()
    while manny:find_sector_name("elev_trigger") and not manny:find_sector_name("lo_ha_box") do
        break_here()
    end
    if manny:find_sector_name("lo_ha_box") then
        lo.ha_door:walkOut()
    else
        lo.ha_door:close()
    end
end
lo.elev_walk_out = function(arg1) -- line 359
    START_CUT_SCENE()
    lo:current_setup(lo_elews)
    MakeSectorActive("lo_ha_box", FALSE)
    lo.ha_door:open()
    manny:walkto(lo.ha_door.use_pnt_x, lo.ha_door.use_pnt_y, lo.ha_door.use_pnt_z)
    manny:wait_for_actor()
    lo.ha_door:close()
    MakeSectorActive("lo_ha_box", TRUE)
    END_CUT_SCENE()
end
lo.ha_door = Object:create(lo, "/lotx011/elevator", 0.46806601, -0.68151999, 0.47999999, { range = 0.80000001 })
lo.lo_ha_box = lo.ha_door
lo.ha_door.passage = { "elev_1", "elev_2" }
lo.ha_door.use_pnt_x = 0.018274
lo.ha_door.use_pnt_y = -0.63093299
lo.ha_door.use_pnt_z = 0
lo.ha_door.use_rot_x = 0
lo.ha_door.use_rot_y = 273.75
lo.ha_door.use_rot_z = 0
lo.ha_door.out_pnt_x = 0.77249801
lo.ha_door.out_pnt_y = -0.72679502
lo.ha_door.out_pnt_z = 0
lo.ha_door.out_rot_x = 0
lo.ha_door.out_rot_y = 260.30099
lo.ha_door.out_rot_z = 0
lo.ha_door.lookAt = function(arg1) -- line 393
    manny:say_line("/loma012/")
end
lo.ha_door.use = function(arg1) -- line 397
    START_CUT_SCENE()
    if not arg1:is_open() then
        arg1:open()
    end
    arg1:walkOut()
    END_CUT_SCENE()
end
lo.ha_door.walkOut = function(arg1) -- line 406
    START_CUT_SCENE()
    manny:clear_hands()
    box_off("lo_ha_box")
    manny:walkto(lo.ha_door.out_pnt_x, lo.ha_door.out_pnt_y, lo.ha_door.out_pnt_z, lo.ha_door.out_rot_x, lo.ha_door.out_rot_y + 180, lo.ha_door.out_rot_z)
    lo.ha_door:close()
    box_on("lo_ha_box")
    ha:switch_to_set()
    manny:put_in_set(ha)
    manny:setpos(ha.lo_door.out_pnt_x, ha.lo_door.out_pnt_y, ha.lo_door.out_pnt_z)
    manny:setrot(ha.lo_door.out_rot_x, ha.lo_door.out_rot_y + 180, ha.lo_door.out_rot_z)
    ha.lo_door:open()
    manny:walkto(ha.lo_door.use_pnt_x, ha.lo_door.use_pnt_y, ha.lo_door.use_pnt_z)
    manny:wait_for_actor()
    ha.lo_door:close()
    END_CUT_SCENE()
end
lo.ha_door.open = function(arg1) -- line 425
    if not arg1:is_open() then
        arg1:wait_for_chore(1)
        arg1:play_chore(0)
        arg1:wait_for_chore()
        Object.open(arg1)
    end
    return TRUE
end
lo.ha_door.close = function(arg1) -- line 436
    if arg1:is_open() then
        Object.close(arg1)
        arg1:wait_for_chore(0)
        arg1:play_chore(1)
        arg1:wait_for_chore()
    end
    return TRUE
end
lo.pk_door = Object:create(lo, "/lotx013/door", 2.07671, -1.81213, 0.5, { range = 0.80000001 })
lo.lo_pk_box = lo.pk_door
lo.pk_door.passage = { "pk_pass1", "pk_pass2", "pk_pass3" }
lo.pk_door.use_pnt_x = 1.908
lo.pk_door.use_pnt_y = -1.8940001
lo.pk_door.use_pnt_z = 0
lo.pk_door.use_rot_x = 0
lo.pk_door.use_rot_y = 984.28497
lo.pk_door.use_rot_z = 0
lo.pk_door.out_pnt_x = 2.1800001
lo.pk_door.out_pnt_y = -1.858
lo.pk_door.out_pnt_z = 0
lo.pk_door.out_rot_x = 0
lo.pk_door.out_rot_y = 1020.33
lo.pk_door.out_rot_z = 0
lo.pk_door.lookAt = function(arg1) -- line 468
    manny:say_line("/loma014/")
end
lo.pk_door.walkOut = function(arg1) -- line 472
    pk:come_out_door(pk.lo_door)
end
lo.os_door = Object:create(lo, "/lotx015/door", -0.0119341, -3.7815199, 0.54000002, { range = 0.69999999 })
lo.os_door.use_pnt_x = -0.075821199
lo.os_door.use_pnt_y = -3.44048
lo.os_door.use_pnt_z = 0
lo.os_door.use_rot_x = 0
lo.os_door.use_rot_y = 224.946
lo.os_door.use_rot_z = 0
lo.os_door.out_pnt_x = -0.140606
lo.os_door.out_pnt_y = -3.675
lo.os_door.out_pnt_z = 0
lo.os_door.out_rot_x = 0
lo.os_door.out_rot_y = 16.7577
lo.os_door.out_rot_z = 0
lo.os_door.lookAt = function(arg1) -- line 494
    manny:say_line("/loma016/")
end
lo.os_door.use = function(arg1) -- line 498
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:clear_hands()
    manny:play_chore(ms_reach_med, "ms.cos")
    sleep_for(500)
    arg1:play_chore(0)
    arg1:wait_for_chore()
    manny:wait_for_chore(ms_reach_med, "ms.cos")
    manny:stop_chore(ms_reach_med, "ms.cos")
    os:switch_to_set()
    manny:put_in_set(os)
    manny:setpos(os.lo_door.out_pnt_x, os.lo_door.out_pnt_y, os.lo_door.out_pnt_z)
    manny:setrot(os.lo_door.out_rot_x, os.lo_door.out_rot_y + 180, os.lo_door.out_rot_z)
    manny:walkto(os.lo_door.use_pnt_x, os.lo_door.use_pnt_y, os.lo_door.use_pnt_z)
    manny:wait_for_actor()
    os.lo_door:play_chore(1)
    os.lo_door.interest_actor:wait_for_chore(1)
    END_CUT_SCENE()
end
lo.brennis_trigger = { }
lo.brennis_trigger.walkOut = function(arg1) -- line 524
    if reaped_bruno and not brennis.opened_tube_room then
        lo:meet_brennis()
    end
end
