CheckFirstTime("ev.lua")
dofile("ev_door.lua")
ev = Set:create("ev.set", "Elevator Station", { ev_elvms = 0, ev_ovrhd = 1 })
ev.watch_manny = function() -- line 15
    while 1 do
        while manny:find_sector_name("force_manny") do
            manny:walk_forward()
            break_here()
        end
        break_here()
    end
end
ev.enter = function(arg1) -- line 31
    start_script(ev.watch_manny)
    start_script(foghorn_sfx)
    ev.be_door.hObjectState = ev:add_object_state(ev_elvms, "ev_door.bm", "ev_door.zbm", OBJSTATE_STATE)
    ev.be_door:set_object_state("ev_door.cos")
    ev.be_door:complete_chore(ev_door_set_closed)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0.5, -0.8, 2)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    ev:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
end
ev.exit = function(arg1) -- line 48
    stop_script(ev.watch_manny)
    stop_script(foghorn_sfx)
    KillActorShadows(manny.hActor)
end
ev.ce_door = Object:create(ev, "/evtx001/stairs", 1.01702, 0.97369301, 1.6, { range = 0.60000002 })
ev.ce_door.use_pnt_x = 0.79443401
ev.ce_door.use_pnt_y = 1.00498
ev.ce_door.use_pnt_z = 1.19376
ev.ce_door.use_rot_x = 0
ev.ce_door.use_rot_y = 296.72299
ev.ce_door.use_rot_z = 0
ev.ce_door.out_pnt_x = 1.14597
ev.ce_door.out_pnt_y = 1.07464
ev.ce_door.out_pnt_z = 1.25
ev.ce_door.out_rot_x = 0
ev.ce_door.out_rot_y = 269.89001
ev.ce_door.out_rot_z = 0
ev.ce_door.touchable = FALSE
ev.ce_box = ev.ce_door
ev.ce_door.walkOut = function(arg1) -- line 85
    ce:come_out_door(ce.ev_door)
end
ev.be_door = Object:create(ev, "/evtx002/elevator", 0.111536, -0.16264699, 0.41, { range = 0.80000001 })
ev.be_door.use_pnt_x = -0.015126
ev.be_door.use_pnt_y = -0.77272499
ev.be_door.use_pnt_z = 0.050000001
ev.be_door.use_rot_x = 0
ev.be_door.use_rot_y = 7.98352
ev.be_door.use_rot_z = 0
ev.be_door.out_pnt_x = -0.108002
ev.be_door.out_pnt_y = -0.0225458
ev.be_door.out_pnt_z = 0.050000001
ev.be_door.out_rot_x = 0
ev.be_door.out_rot_y = 11.3366
ev.be_door.out_rot_z = 0
ev.be_box = ev.be_door
ev.be_door.passage = { "ev_be_psg" }
ev.be_door.walkOut = function(arg1) -- line 109
    START_CUT_SCENE()
    set_override(ev.be_door.skipWalkOut, ev.be_door)
    manny:clear_hands()
    manny:walkto(-0.081, -0.675, 0.05, 0, 315.391, 0)
    manny:wait_for_actor()
    manny:start_open_door_anim()
    sleep_for(800)
    start_sfx("evdoorop.WAV", nil, 80)
    arg1:play_chore(ev_door_open)
    manny:finish_open_door_anim()
    arg1:wait_for_chore(ev_door_open)
    arg1:open()
    manny:walkto(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z, arg1.out_rot_x, arg1.out_rot_y, arg1.out_rot_z)
    manny:wait_for_actor()
    arg1:play_chore(ev_door_close)
    sleep_for(500)
    start_sfx("evdoorcl.wav", nil, 80)
    arg1:wait_for_chore(ev_door_close)
    arg1:close()
    arg1:play_chore(ev_door_set_closed)
    manny:set_visibility(FALSE)
    play_movie("ev_up.snm", 243, 153)
    wait_for_movie()
    manny:set_visibility(TRUE)
    arg1:play_chore(ev_door_set_gone)
    END_CUT_SCENE()
    bw:come_out_door(bw.ev_door)
end
ev.be_door.skipWalkOut = function(arg1) -- line 142
    kill_override()
    manny:set_visibility(TRUE)
    ev.be_door:close()
    ev.be_door:stop_chore()
    ev.be_door:play_chore(ev_door_set_closed)
    manny:default("cafe")
    bw:come_out_door(bw.ev_door)
end
ev.be_door.comeOut = function(arg1) -- line 152
    START_CUT_SCENE()
    set_override(ev.be_door.skipComeOut, ev.be_door)
    manny:clear_hands()
    manny:set_visibility(FALSE)
    arg1:play_chore(ev_door_set_closed)
    play_movie("ev.snm", 243, 153)
    wait_for_movie()
    manny:setpos(arg1.out_pnt_x, arg1.out_pnt_y, arg1.out_pnt_z)
    manny:setrot(arg1.out_rot_x, arg1.out_rot_y + 180, arg1.out_rot_z)
    start_sfx("evdoorop.wav", nil, 80)
    arg1:play_chore(ev_door_open)
    arg1:wait_for_chore(ev_door_open)
    arg1:open()
    manny:set_visibility(TRUE)
    manny:walkto(-0.0619582, -0.669169, 0.05, 0, 309.503, 0)
    manny:wait_for_actor()
    manny:start_open_door_anim(TRUE)
    sleep_for(500)
    arg1:play_chore(ev_door_close)
    sleep_for(500)
    start_sfx("evdoorcl.wav", nil, 80)
    arg1:wait_for_chore(ev_door_close)
    manny:finish_open_door_anim(TRUE)
    arg1:close()
    manny:walkto(arg1.use_pnt_x, arg1.use_pnt_y, arg1.use_pnt_z)
    END_CUT_SCENE()
end
ev.be_door.skipComeOut = function(arg1) -- line 186
    kill_override()
    ev:switch_to_set()
    manny:set_visibility(TRUE)
    manny:setpos(ev.be_door.use_pnt_x, ev.be_door.use_pnt_y, ev.be_door.use_pnt_z)
    manny:setrot(ev.be_door.use_rot_x, ev.be_door.use_rot_y + 180, ev.be_door.use_rot_z)
    ev.be_door:close()
    ev.be_door:stop_chore()
    ev.be_door:play_chore(ev_door_set_closed)
    manny:default("cafe")
end
ev.be_door.lookAt = function(arg1) -- line 198
    if arg1.opened then
        system.default_response("open")
    else
        system.default_response("closed")
    end
end
ev.be_door.use = ev.be_door.walkOut
ev.pc_door = Object:create(ev, "door", 0.181108, -1.7453001, 0.050000001, { range = 0.60000002 })
ev.pc_door.use_pnt_x = 0.181108
ev.pc_door.use_pnt_y = -1.1153001
ev.pc_door.use_pnt_z = 0.050000001
ev.pc_door.use_rot_x = 0
ev.pc_door.use_rot_y = -540.71997
ev.pc_door.use_rot_z = 0
ev.pc_door.out_pnt_x = 0.175212
ev.pc_door.out_pnt_y = -1.56317
ev.pc_door.out_pnt_z = -0.067439497
ev.pc_door.out_rot_x = 0
ev.pc_door.out_rot_y = -540.71997
ev.pc_door.out_rot_z = 0
ev.pc_door.touchable = FALSE
ev.pc_box = ev.pc_door
ev.pc_door.walkOut = function(arg1) -- line 228
    pc:come_out_door(pc.ev_door)
end
