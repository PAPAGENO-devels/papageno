CheckFirstTime("sm.lua")
sm = Set:create("sm.set", "sm", { sm_smpws = 0, sm_top = 1 })
sm.climb_out_stump = function(arg1) -- line 14
    START_CUT_SCENE()
    manny:head_look_at(nil)
    manny:put_in_set(sm)
    sm:switch_to_set()
    manny:default()
    manny:ignore_boxes()
    manny:setpos(-0.76896, -0.70574, 0.00038)
    manny:setrot(0, 114, 0)
    manny:set_visibility(FALSE)
    manny:push_costume(manny_jump_stump_cos)
    sm.stump:play_chore(0)
    sm.stump:wait_for_chore()
    sm.stump:set_type(OBJSTATE_STATE)
    sm.stump:complete_chore(0)
    manny:set_visibility(TRUE)
    manny:play_chore(0)
    manny:wait_for_chore()
    manny:pop_costume()
    manny:follow_boxes()
    start_script(manny.walk_and_face, manny, -1.1064, -0.600584, 0.02, 0, 17.071, 0)
    manny:say_line("/smma001/")
    manny:wait_for_actor()
    manny:head_look_at(sm.skyline)
    sleep_for(500)
    manny:head_look_at(sm.stump)
    sleep_for(700)
    manny:head_look_at(nil)
    END_CUT_SCENE()
    sm.climbed_out_stump = TRUE
end
sm.enter = function(arg1) -- line 57
    sm.sg_door:make_untouchable()
    sm.stump_hObjectState = sm:add_object_state(sm_smpws, "sm_smpws_top_open.bm", "sm_smpws_top_open.zbm", OBJSTATE_STATE, TRUE)
    sm.stump:set_object_state("sm_stump.cos")
    if sm.climbed_out_stump then
        sm.stump.interest_actor:complete_chore(1)
    end
    if not manny_jump_stump_cos then
        manny_jump_stump_cos = "ma_jump_stump.cos"
    end
    LoadCostume(manny_jump_stump_cos)
    sm:add_ambient_sfx({ "frstCrt1.wav", "frstCrt2.wav", "frstCrt3.wav", "frstCrt4.wav" }, { min_delay = 8000, max_delay = 20000 })
end
sm.exit = function(arg1) -- line 78
    sm.stump_hObjectState = nil
end
sm.skyline = Object:create(sm, "/smtx002/skyline", 2.3892701, 10.4482, 1.11456, { range = 8 })
sm.skyline.use_pnt_x = -0.354
sm.skyline.use_pnt_y = 0.68900001
sm.skyline.use_pnt_z = 0.001
sm.skyline.use_rot_x = 0
sm.skyline.use_rot_y = 1091.48
sm.skyline.use_rot_z = 0
sm.skyline.immediate = TRUE
sm.skyline.lookAt = function(arg1) -- line 96
    soft_script()
    manny:say_line("/smma003/")
    wait_for_message()
    manny:say_line("/smma004/")
end
sm.skyline.use = function(arg1) -- line 103
    manny:say_line("/smma005/")
end
sm.stump = Object:create(sm, "/smtx006/stump", 0.076495104, -0.227853, 1.21, { range = 2 })
sm.stump.use_pnt_x = 0.70499998
sm.stump.use_pnt_y = -0.259
sm.stump.use_pnt_z = 0.001
sm.stump.use_rot_x = 0
sm.stump.use_rot_y = 785.29498
sm.stump.use_rot_z = 0
sm.stump.immediate = TRUE
sm.stump.lookAt = function(arg1) -- line 118
    manny:say_line("/smma007/")
end
sm.stump.use = function(arg1) -- line 122
    START_CUT_SCENE()
    manny:say_line("/smma008/")
    wait_for_message()
    manny:say_line("/smma009/")
    wait_for_message()
    manny:say_line("/smma010/")
    END_CUT_SCENE()
end
sm.sg_door = Object:create(sm, "/smtx012/door", 0.206306, -0.98770398, 0.23, { range = 0.60000002 })
sm.sg_door.use_pnt_x = -0.043693699
sm.sg_door.use_pnt_y = -0.91770399
sm.sg_door.use_pnt_z = 0.02
sm.sg_door.use_rot_x = 0
sm.sg_door.use_rot_y = -473.703
sm.sg_door.use_rot_z = 0
sm.sg_door.out_pnt_x = 0.096015997
sm.sg_door.out_pnt_y = -0.978984
sm.sg_door.out_pnt_z = 0.02
sm.sg_door.out_rot_x = 0
sm.sg_door.out_rot_y = -473.703
sm.sg_door.out_rot_z = 0
sm.sg_box = sm.sg_door
sm.sg_door:make_untouchable()
sm.sg_door.walkOut = function(arg1) -- line 157
    sg:come_out_door(sg.sm_door)
end
