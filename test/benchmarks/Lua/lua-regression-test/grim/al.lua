CheckFirstTime("al.lua")
dofile("manny_scales.lua")
dofile("ma_up_rope.lua")
dofile("manny_wave.lua")
dofile("rope_climb.lua")
dofile("al_elevator.lua")
al = Set:create("al.set", "Alley", { al_allls = 0, al_allls2 = 0, al_allls3 = 0, al_ropla = 1, al_ovrhd = 2 })
al.camera_adjusts = { 350, 0 }
al.cheat_boxes = { al_cheat_1 = 1 }
al.use_elevator = function(arg1) -- line 28
    START_CUT_SCENE()
    set_override(al.use_elevator_override, al)
    manny:head_look_at(nil)
    manny:walkto(0.467088, 1.52067, 0, 0, 39, 0)
    manny:wait_for_actor()
    al.ga_door_obj:play_chore(1)
    SendObjectToBack(al.hDoorObj)
    ForceRefresh()
    ImSetState(STATE_NULL)
    StartMovie("al_open.snm", nil, 0, 64)
    wait_for_movie()
    al.ga_door_obj:play_chore(0)
    al.hq_door:open()
    SendObjectToBack(al.hDoorObj)
    ForceRefresh()
    manny:walkto(0.45573, 2.02417, 0)
    manny:wait_for_actor()
    manny:head_look_at_point(0.442081, 1.96215, 0)
    manny:walkto(0.075089, 2.08581, 0)
    manny:wait_for_actor()
    manny:head_look_at(nil)
    hq:switch_to_set()
    manny:put_in_set(hq)
    manny:setpos(2, 0, 0)
    StartMovie("hq_open.snm", nil, 193, 173)
    wait_for_movie()
    hq:come_out_door(hq.al_door)
    END_CUT_SCENE()
end
al.use_elevator_override = function(arg1) -- line 66
    kill_override()
    hq:switch_to_set()
    manny:put_in_set(hq)
    manny:setpos(0.894616, -0.0153875, 0)
    manny:setrot(0, 90, 0)
end
al.cheat_tie_rope = function(arg1, arg2) -- line 85
    if arg2 == nil then
        arg2 = arg1:current_setup()
    end
    if arg2 == al_ropla then
        tie_rope:setpos(-0.187208, 7.68642, 0)
        tie_rope:setrot(0, 134.411, 0)
        tie_rope:play_chore(rope_climb_show)
    else
        tie_rope:play_chore(rope_climb_hide)
    end
end
al.camerachange = function(arg1, arg2, arg3) -- line 99
    al:cheat_tie_rope(arg3)
end
al.setup_actors = function(arg1) -- line 103
    tie_rope:default()
    tie_rope:put_in_set(arg1)
    tie_rope:play_chore(rope_climb_show)
    al:cheat_tie_rope()
    SetShadowColor(25, 15, 15)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, -4000, 2000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    al.hElevDoorObj = NewObjectState(0, OBJSTATE_STATE, "al_open_still.bm", "al_open_still.zbm")
    al.hq_door:set_object_state("al_elevator.cos")
end
manny.alley_footstep_handler = function(arg1, arg2) -- line 120
    local local1, local2, local3
    if arg2 == Actor.MARKER_LEFT_WALK or arg2 == Actor.MARKER_LEFT_RUN or arg2 == Actor.MARKER_LEFT_TURN then
        local1, local2, local3 = GetActorNodeLocation(arg1.hActor, 42)
    else
        local1, local2, local3 = GetActorNodeLocation(arg1.hActor, 38)
    end
    if IsPointInSector(local1, local2, local3, "elevator_box") and not manny:is_resting() then
        arg1:play_default_footstep(arg2, footsteps.trapdoor)
    else
        arg1:play_default_footstep(arg2, footsteps.concrete)
    end
end
al.enter = function(arg1) -- line 137
    LoadCostume("manny_wave.cos")
    LoadCostume("manny_scales.cos")
    LoadCostume("rope.cos")
    manny.costume_marker_handler = manny.alley_footstep_handler
    SetShadowColor(25, 15, 15)
    al:setup_actors()
    if reaped_meche and not DEMO then
        al.hDoorObj = NewObjectState(0, OBJSTATE_STATE, "al_ga_open.bm", nil)
        al:add_object_state(1, "al_ropla_open.bm", nil, OBJSTATE_UNDERLAY, TRUE)
        al.ga_door_obj:set_object_state("al_ga_door.cos")
        al.ga_door_obj:make_untouchable()
        al.ga_door_obj.interest_actor:put_in_set(al)
        al.ga_door_obj:play_chore(0)
        al.ga_door:unlock()
        al.ga_door:open()
    else
        al.ga_door:close()
        al.ga_door:lock()
    end
end
al.exit = function(arg1) -- line 162
    KillActorShadows(manny.hActor)
    al.hq_door:free_object_state()
    tie_rope:free()
    manny.costume_marker_handler = nil
end
al.rope = Object:create(al, "/altx001/rope", -0.54491103, 7.34583, 0.63999999, { range = 0.80000001 })
al.rope.use_pnt_x = -0.361698
al.rope.use_pnt_y = 7.58637
al.rope.use_pnt_z = 0
al.rope.use_rot_x = 0
al.rope.use_rot_y = 142.813
al.rope.use_rot_z = 0
al.rope.lookAt = function(arg1) -- line 186
    START_CUT_SCENE()
    manny:say_line("/alma002/")
    wait_for_message()
    END_CUT_SCENE()
    manny:say_line("/alma003/")
end
al.rope.use = function(arg1) -- line 194
    local local1
    START_CUT_SCENE()
    music_state:set_sequence(seqClimbRope)
    manny:walkto(arg1)
    manny:wait_for_actor()
    manny:ignore_boxes()
    manny.move_in_reverse = TRUE
    start_script(move_actor_backward, manny.hActor)
    sleep_for(500)
    stop_script(move_actor_backward)
    manny:set_walk_backwards(FALSE)
    manny.move_in_reverse = FALSE
    manny:set_walk_backwards(FALSE)
    manny:setpos(-0.242881, 7.7162299, 0)
    manny:setrot(0, 240.813, 0)
    manny:push_costume("ma_up_rope.cos")
    manny:play_chore(0, "ma_up_rope.cos")
    tie_rope:play_chore(rope_climb_climb)
    manny:wait_for_chore()
    manny:put_in_set(le)
    tie_rope:stop_chore(rope_climb_climb)
    tie_rope:put_in_set(le)
    tie_rope:setpos(2.4367599, 0.33766401, -34.959999)
    tie_rope:setrot(0, 64.847198, 0)
    tie_rope:play_chore(rope_climb_show)
    le:switch_to_set()
    le:current_setup(le_ladws)
    manny:setpos(0.39857, 1.3200001, -0.059999999)
    manny:setrot(0, 15.2617, 0)
    manny:stop_chore(0, "ma_up_rope.cos")
    manny:pop_costume()
    manny:push_costume("manny_scales.cos")
    manny:play_chore(manny_scales_pull_ledge, "manny_scales.cos")
    manny:wait_for_chore()
    manny:follow_boxes()
    manny:stop_chore(manny_scales_pull_ledge, "manny_scales.cos")
    manny:pop_costume()
    END_CUT_SCENE()
end
al.rope.pickUp = al.rope.use
al.rope.climbDown = function(arg1) -- line 246
    START_CUT_SCENE()
    enable_head_control(FALSE)
    al:switch_to_set()
    al:current_setup(al_ropla)
    preload_sfx("mannyJmp.wav")
    tie_rope:default()
    tie_rope:setpos(-0.187208, 7.68642, 0)
    tie_rope:setrot(0, 134.411, 0)
    tie_rope:play_chore(rope_climb_hide, "rope_climb.cos")
    manny:put_in_set(al)
    manny:ignore_boxes()
    manny:head_look_at(nil)
    manny:setpos(-0.219592, 7.66707, 0)
    manny:setrot(0, 135.813, 0)
    manny:push_costume("ma_up_rope.cos")
    manny:play_chore(ma_up_rope_drop_off, "ma_up_rope.cos")
    sleep_for(1300)
    start_sfx("mannyJmp.wav")
    manny:wait_for_chore()
    tie_rope:play_chore(rope_climb_show, "rope_climb.cos")
    manny:pop_costume()
    while not manny:find_sector_name("rope_box") do
        WalkActorForward(manny.hActor)
        break_here()
    end
    manny:follow_boxes()
    manny:setrot(0, 195, 0, TRUE)
    enable_head_control(TRUE)
    END_CUT_SCENE()
end
al.lens = Object:create(al, "/altx004/eye", -0.56491101, 2.08584, 0.60000002, { range = 0.89999998 })
al.lens.use_pnt_x = -0.25592899
al.lens.use_pnt_y = 2.2321401
al.lens.use_pnt_z = 0
al.lens.use_rot_x = 0
al.lens.use_rot_y = -198.82201
al.lens.use_rot_z = 0
al.lens.lookAt = function(arg1) -- line 291
    if reaped_meche then
        manny:say_line("/alma005/")
    else
        manny:say_line("/alma006/")
    end
end
al.lens.use = function(arg1) -- line 299
    START_CUT_SCENE()
    while TurnActorTo(manny.hActor, al.lens.obj_x, al.lens.obj_y, 0) do
        break_here()
    end
    PrintDebug("what?")
    if reaped_meche then
        if rf.eggs.owner == manny then
            manny:say_line("/alma007/")
        else
            manny:say_line("/alma008/")
        end
    else
        manny:say_line("/alma009/")
    end
    if rf.eggs.owner == manny then
        if not system.currentActor.is_holding then
            manny:play_chore(ms_takeout_get, "ms.cos")
            manny:wait_for_chore(ms_takeout_get, "ms.cos")
            manny:stop_chore(ms_takeout_get, "ms.cos")
            manny:play_chore_looping(ms_activate_eggs, "ms.cos")
            manny:play_chore(ms_takeout_small, "ms.cos")
            manny:wait_for_chore(ms_takeout_small, "ms.cos")
            manny:stop_chore(ms_takeout_small, "ms.cos")
        end
        manny:push_costume("manny_wave.cos")
        manny:play_chore(manny_wave_wave_eggs, "manny_wave.cos")
        manny:wait_for_chore(manny_wave_wave_eggs, "manny_wave.cos")
        manny:stop_chore(manny_wave_wave_eggs, "manny_wave.cos")
        manny:pop_costume()
        manny.hold_chore = ms_activate_eggs
        manny.is_holding = rf.eggs
        manny:play_chore_looping(ms_hold, "ms.cos")
    else
        manny:push_costume("manny_wave.cos")
        manny:play_chore(manny_wave_wave, "manny_wave.cos")
        manny:wait_for_chore(manny_wave_wave, "manny_wave.cos")
        manny:stop_chore(manny_wave_wave, "manny_wave.cos")
        manny:pop_costume()
    end
    wait_for_message()
    END_CUT_SCENE()
    if reaped_meche then
        al:use_elevator()
    end
end
al.lens.use_eggs = function(arg1) -- line 349
    START_CUT_SCENE()
    manny:say_line("/alma010/")
    wait_for_message()
    arg1.use()
    END_CUT_SCENE()
end
al.lens.use_mouthpiece = function(arg1) -- line 357
    START_CUT_SCENE()
    manny:say_line("/alma011/")
    wait_for_message()
    al:use_elevator()
    END_CUT_SCENE()
end
al.st_door = Object:create(al, "/altx012/door", 0.175089, 0.85580897, 0.5, { range = 0.5 })
al.al_sf_box = al.st_door
al.st_door.use_pnt_x = 0.0758304
al.st_door.use_pnt_y = 1.43951
al.st_door.use_pnt_z = 0
al.st_door.use_rot_x = 0
al.st_door.use_rot_y = 189.45
al.st_door.use_rot_z = 0
al.st_door.out_pnt_x = 0.179546
al.st_door.out_pnt_y = 0.83695501
al.st_door.out_pnt_z = 0
al.st_door.out_rot_x = 0
al.st_door.out_rot_y = 189.746
al.st_door.out_rot_z = 0
al.st_door.walkOut = function(arg1) -- line 389
    st:come_out_door(st.al_door)
end
al.hq_door = Object:create(al, "/altx013/trap door", 0.075089, 2.03581, 0, { range = 0.5 })
al.hq_door.use_pnt_x = -0.161
al.hq_door.use_pnt_y = 2.03
al.hq_door.use_pnt_z = 0
al.hq_door.use_rot_x = 0
al.hq_door.use_rot_y = -97.695
al.hq_door.use_rot_z = 0
al.hq_door.out_pnt_x = 0.077
al.hq_door.out_pnt_y = 1.998
al.hq_door.out_pnt_z = 0
al.hq_door.out_rot_x = 0
al.hq_door.out_rot_y = -97.695
al.hq_door.out_rot_z = 0
al.hq_door.touchable = FALSE
al.hq_door.walkOut = function(arg1) -- line 412
end
al.hq_door.open = function(arg1) -- line 415
    al.hq_door:play_chore(al_elevator_open)
    SendObjectToBack(al.hDoorObj)
    al.hq_door.opened = TRUE
end
al.hq_door.close = function(arg1) -- line 421
    al.hq_door:play_chore(al_elevator_closed)
    SendObjectToBack(al.hDoorObj)
    al.hq_door.opened = FALSE
end
al.ga_door = Object:create(al, "/altx014/big door", -0.60491103, 5.5058298, 0.46000001, { range = 0.80000001 })
al.ga_door.use_pnt_x = -0.32699999
al.ga_door.use_pnt_y = 5.5359998
al.ga_door.use_pnt_z = 0
al.ga_door.use_rot_x = 0
al.ga_door.use_rot_y = 112.99
al.ga_door.use_rot_z = 0
al.ga_door.out_pnt_x = -0.74000299
al.ga_door.out_pnt_y = 5.5847502
al.ga_door.out_pnt_z = 0
al.ga_door.out_rot_x = 0
al.ga_door.out_rot_y = -631.26001
al.ga_door.out_rot_z = 0
al.al_ga_box = al.ga_door
al.ga_door.passage = { "door_box", "door_box2" }
al.ga_door:close()
al.ga_door:lock()
al.ga_door:make_untouchable()
al.ga_door.walkOut = function(arg1) -- line 451
    ga:come_out_door(ga.al_door)
end
al.ga_door_obj = Object:create(al, "/altx014/big door", -0.60491103, 5.5058298, 0.46000001, { range = 0.80000001 })
al.ga_door_obj.use_pnt_x = -0.32699999
al.ga_door_obj.use_pnt_y = 5.5359998
al.ga_door_obj.use_pnt_z = 0
al.ga_door_obj.use_rot_x = 0
al.ga_door_obj.use_rot_y = 112.99
al.ga_door_obj.use_rot_z = 0
al.ga_door_obj.use = function(arg1) -- line 464
    manny:say_line("/alma015/")
end
al.ga_door_obj.lookAt = function(arg1) -- line 468
    manny:say_line("/alma016/")
end
al.ga_door_obj.pickUp = al.ga_door_obj.use
