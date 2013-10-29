CheckFirstTime("se.lua")
se = Set:create("se.set", "scrimshaw exterior", { se_estws = 0, se_overhead = 1 })
se.set_up_water = function() -- line 12
    local local1 = ReadRegistryValue("GrimDeveloper")
    if local1 then
        EngineDisplay(FALSE)
        break_here()
        EngineDisplay(TRUE)
    end
    start_script(play_movie_looping, "se_water.snm")
end
se.jump_off = function() -- line 22
    START_CUT_SCENE()
    se:switch_to_set()
    manny:put_in_set(se)
    manny:setpos(47.2102, -15.5179, -0)
    manny:setrot(0, -172.071, 0)
    if in_year_four then
        manny:push_costume("msb_ladder_generic.cos")
    else
        manny:push_costume("mc_ladder_generic.cos")
    end
    manny:play_chore(4)
    manny:wait_for_chore()
    manny:pop_costume()
    END_CUT_SCENE()
end
se.enter = function(arg1) -- line 49
    NewObjectState(se_estws, OBJSTATE_OVERLAY, "se_hatch.bm", nil, TRUE)
    se.si_door:set_object_state("se_hatch.cos")
    se.si_door:play_chore(1)
    start_script(se.set_up_water)
    start_script(foghorn_sfx)
    se:add_ambient_sfx(harbor_ambience_list, harbor_ambience_parm_list)
end
se.exit = function(arg1) -- line 58
    StopMovie()
    stop_script(foghorn_sfx)
end
se.sd_door = Object:create(se, "/setx001/door", 40.9561, -12.6999, 0.57370597, { range = 0.60000002 })
se.sd_door.use_pnt_x = 42.281799
se.sd_door.use_pnt_y = -12.7303
se.sd_door.use_pnt_z = 0
se.sd_door.use_rot_x = 0
se.sd_door.use_rot_y = 104.189
se.sd_door.use_rot_z = 0
se.sd_door.out_pnt_x = 41.586399
se.sd_door.out_pnt_y = -12.7505
se.sd_door.out_pnt_z = 0.35771301
se.sd_door.out_rot_x = 0
se.sd_door.out_rot_y = 83.776901
se.sd_door.out_rot_z = 0
se.sd_door:make_untouchable()
se.sd_box = se.sd_door
se.sd_door.walkOut = function(arg1) -- line 94
    START_CUT_SCENE()
    if manny.is_backward then
        manny:set_walk_backwards(FALSE)
        manny:turn_right(180)
    end
    END_CUT_SCENE()
    xb:come_out_door(xb.se_door)
end
se.si_door = Object:create(se, "/setx002/hatch", 47.284401, -16.0672, 0.80000001, { range = 2.5 })
se.si_door.use_pnt_x = 46.5373
se.si_door.use_pnt_y = -14.5703
se.si_door.use_pnt_z = 0
se.si_door.use_rot_x = 0
se.si_door.use_rot_y = 923.09698
se.si_door.use_rot_z = 0
se.si_door.out_pnt_x = 47.0923
se.si_door.out_pnt_y = -15.6921
se.si_door.out_pnt_z = 0
se.si_door.out_rot_x = 0
se.si_door.out_rot_y = -509.58401
se.si_door.out_rot_z = 0
se.si_box = se.si_door
se.si_door.lookAt = function(arg1) -- line 120
    manny:say_line("/sema003/")
end
se.si_door.walkOut = function(arg1) -- line 124
    local local1 = { }
    START_CUT_SCENE()
    manny:ignore_boxes()
    manny:walkto(47.0042, -15.5869, -0.040999901, 0, -154.69701, 0)
    manny:wait_for_actor()
    if manny.is_holding then
        put_away_held_item()
    end
    manny:set_visibility(FALSE)
    manny:push_costume("mc_ladder_generic.cos")
    manny:play_chore_looping(5)
    manny:setpos({ x = 47.211201, y = -15.9199, z = -0.048999999 })
    manny:setrot(0, -154.69701, 0)
    if in_year_four then
        manny:push_costume("msb_enter_sc.cos")
        manny:blend(0, 5, 500, "msb_enter_sc.cos", "mc_ladder_generic.cos")
    else
        manny:push_costume("ma_enter_sc.cos")
        manny:blend(0, 5, 500, "ma_enter_sc.cos", "mc_ladder_generic.cos")
    end
    manny:set_visibility(TRUE)
    sleep_for(1000)
    se.si_door:play_chore(0)
    if in_year_four then
        manny:wait_for_chore(0, "msb_enter_sc.cos")
    else
        manny:wait_for_chore(0, "ma_enter_sc.cos")
    end
    manny:pop_costume()
    manny:pop_costume()
    END_CUT_SCENE()
    manny:follow_boxes()
    si:come_out_door(si.ladder)
end
se.si_door.comeOut = function(arg1) -- line 163
    manny:setpos(47.0913, -15.3242, 0)
    manny:setrot(0, -681.6, 0)
end
