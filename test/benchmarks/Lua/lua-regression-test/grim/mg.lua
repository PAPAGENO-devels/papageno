CheckFirstTime("mg.lua")
mg = Set:create("mg.set", "morgue", { mg_morws = 0, mg_tblms = 1, mg_ovrhd = 2 })
mg.shrinkable = 0.01
mg.search_volume = 30
dofile("membrillo.lua")
dofile("mem_detect.lua")
dofile("mc_dogtags.lua")
membrillo.default = function(arg1) -- line 20
    membrillo:set_costume(nil)
    membrillo:set_costume("membrillo.cos")
    membrillo:set_colormap("membrill.cmp")
    membrillo:set_walk_rate(0.12)
    membrillo:set_turn_rate(20)
    membrillo:set_mumble_chore(membrillo_mumble)
    membrillo:set_talk_chore(1, membrillo_stop_talk)
    membrillo:set_talk_chore(2, membrillo_a)
    membrillo:set_talk_chore(3, membrillo_c)
    membrillo:set_talk_chore(4, membrillo_e)
    membrillo:set_talk_chore(5, membrillo_f)
    membrillo:set_talk_chore(6, membrillo_l)
    membrillo:set_talk_chore(7, membrillo_m)
    membrillo:set_talk_chore(8, membrillo_o)
    membrillo:set_talk_chore(9, membrillo_t)
    membrillo:set_talk_chore(10, membrillo_u)
    membrillo:set_turn_chores(-1, -1)
    membrillo:set_walk_chore(-1)
    membrillo:play_chore(membrillo_stop_talk)
    membrillo:follow_boxes()
    membrillo.stop_searching = FALSE
    membrillo.stop_walking = FALSE
    if membrillo.detecting then
        membrillo:complete_chore(membrillo_hide_tool, "membrillo.cos")
        membrillo:push_costume("mem_detect.cos")
    else
        membrillo:complete_chore(membrillo_show_tool, "membrillo.cos")
    end
end
membrillo.walkto_corpse = function(arg1, arg2) -- line 53
    local local1, local2
    if not arg1.detecting then
        local2 = rndint(0, 2)
        local2 = arg2.mem_pnt[local2]
        arg1:set_turn_chores(-1, -1)
        arg1:set_walk_chore(-1)
        local1 = GetActorYawToPoint(arg1.hActor, local2.x, local2.y, local2.z)
        arg1:blend(membrillo_swivel_lf, membrillo_wkend_to_rest, 500)
        arg1:setrot(0, local1, 0, TRUE)
        while arg1:is_turning() do
            break_here()
        end
        arg1.examining = nil
        arg1:blend(membrillo_walk, membrillo_swivel_lf, 1000)
        arg1:walkto(local2.x, local2.y, local2.z)
        arg1:wait_for_actor()
        mg.membrillo_obj:follow_actor()
        if not arg1.stop_walking then
            arg1:blend(membrillo_swivel_lf, membrillo_walk, 500)
            arg1:setrot(local2.pitch, local2.yaw, local2.roll, TRUE)
            while arg1:is_turning() do
                break_here()
            end
        end
        arg1:wait_for_chore(membrillo_swivel_lf, "membrillo.cos")
        arg1:stop_chore(membrillo_swivel_lf, "membrillo.cos")
        mg.membrillo_obj:follow_actor()
        arg1.examining = arg2
    else
        local2 = arg2.mem_pnt[0]
        arg1:turn_to_rot(local2.pitch, local2.yaw, local2.roll)
        mg.membrillo_obj:follow_actor()
        arg1.examining = arg2
    end
end
membrillo.turn_to_rot = function(arg1, arg2, arg3, arg4) -- line 93
    arg1:fade_in_chore(membrillo_swivel_lf, "membrillo.cos", 2000)
    arg1:setrot(arg2, arg3, arg4, TRUE)
    arg1:wait_for_actor()
    arg1:fade_out_chore(membrillo_swivel_lf, "membrillo.cos", 500)
    sleep_for(500)
end
membrillo.search_corpse = function(arg1) -- line 101
    if arg1:is_choring(membrillo_lookat_manny, FALSE, "membrillo.cos") then
        arg1:stop_chore(membrillo_lookat_manny, "membrillo.cos")
        arg1:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
    end
    arg1:stop_chore(membrillo_lkma_to_rest, "membrillo.cos")
    if not arg1.detecting then
        arg1:run_chore(membrillo_rest_to_work, "membrillo.cos")
        sleep_for(500)
        arg1:stop_chore(membrillo_rest_to_work, "membrillo.cos")
        start_sfx("plntSrch.IMU", IM_HIGH_PRIORITY, mg.search_volume)
        arg1:run_chore(membrillo_work_start_to_end, "membrillo.cos")
        arg1:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
        fade_sfx("plntSrch.IMU", 300)
        if rnd(8) and not arg1.stop_searching then
            arg1:run_chore(membrillo_wk_to_lk_tool, "membrillo.cos")
            sleep_for(rndint(1000, 2000))
            arg1:stop_chore(membrillo_wk_to_lk_tool, "membrillo.cos")
            arg1:run_chore(membrillo_lk_tool_to_wkst, "membrillo.cos")
            arg1:stop_chore(membrillo_lk_tool_to_wkst, "membrillo.cos")
            arg1:run_chore(membrillo_work_start_to_end, "membrillo.cos")
            arg1:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
        end
        arg1:run_chore(membrillo_wkend_to_rest, "membrillo.cos")
        arg1:stop_chore(membrillo_wkend_to_rest, "membrillo.cos")
    else
        arg1:run_chore(mem_detect_scan, "mem_detect.cos")
    end
end
mg.membrillo_idle = function(arg1) -- line 132
    while system.currentSet == mg and not membrillo.stop_searching do
        if not membrillo.stop_searching then
            if membrillo.examining.tagged == 0 or not membrillo.detecting then
                membrillo:search_corpse()
            else
                membrillo.stop_searching = TRUE
                start_script(mg.find_tags, mg)
            end
        end
        if not membrillo.stop_searching then
            if not membrillo.stop_walking then
                membrillo:walkto_corpse(mg.corpse_1)
            end
            if not membrillo.stop_searching then
                if membrillo.examining.tagged == 0 or not membrillo.detecting then
                    membrillo:search_corpse()
                else
                    membrillo.stop_searching = TRUE
                    start_script(mg.find_tags)
                end
            end
        end
        if not membrillo.stop_walking and not membrillo.stop_searching then
            membrillo:walkto_corpse(mg.corpse_2)
        end
    end
end
mg.membrillo_stop_idle = function(arg1, arg2) -- line 164
    if find_script(mg.membrillo_idle) then
        membrillo.stop_searching = TRUE
        while find_script(mg.membrillo_idle) do
            break_here()
        end
        if arg2 then
            membrillo:turn_to_rot(0, 10, 0)
        end
    end
end
mg.membrillo_stop_at_corpse_2 = function(arg1) -- line 176
    if not membrillo.detecting then
        membrillo.stop_walking = TRUE
        if find_script(membrillo.walkto_corpse) then
            wait_for_script(membrillo.walkto_corpse)
        end
        if membrillo.examining ~= mg.corpse_2 then
            stop_script(mg.membrillo_idle)
            if find_script(membrillo.search_corpse) then
                wait_for_script(membrillo.search_corpse)
            end
            membrillo:walkto_corpse(mg.corpse_2)
        end
        membrillo:setrot(0, 124, 0, TRUE)
        while membrillo:is_turning() do
            break_here()
        end
    end
    membrillo.facing_manny = FALSE
    start_script(mg.membrillo_face_manny, mg)
end
mg.membrillo_face_manny = function(arg1) -- line 199
    local local1, local2
    if not membrillo.facing_manny then
        if find_script(mg.membrillo_idle) then
            membrillo.stop_searching = TRUE
            while find_script(mg.membrillo_idle) do
                break_here()
            end
        end
        if membrillo.detecting or membrillo.examining ~= mg.corpse_2 then
            local2 = manny:getpos()
            local1 = GetActorYawToPoint(membrillo.hActor, local2)
            membrillo:turn_to_rot(0, local1, 0)
        else
            membrillo:run_chore(membrillo_rest_to_lkma, "membrillo.cos")
            membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
            membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
        end
        membrillo.facing_manny = TRUE
    end
end
mg.membrillo_stop_face_manny = function(arg1) -- line 222
    if membrillo.facing_manny then
        if membrillo:is_choring(membrillo_lookat_manny, FALSE, "membrillo.cos") then
            membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
            membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
        end
        membrillo.stop_walking = FALSE
        membrillo.stop_searching = FALSE
        membrillo.facing_manny = FALSE
        start_script(mg.membrillo_idle, mg)
    end
end
mg.find_tags = function() -- line 235
    START_CUT_SCENE("no head")
    manny:head_look_at(mg.membrillo_obj)
    membrillo:wait_for_chore(mem_detect_scan, "mem_detect.cos")
    membrillo:play_chore(mem_detect_scan, "mem_detect.cos")
    sleep_for(300)
    start_sfx("mdBeep.IMU")
    sleep_for(1200)
    stop_sound("mdBeep.IMU")
    membrillo:stop_chore(mem_detect_scan, "mem_detect.cos")
    membrillo:run_chore(mem_detect_pickup_dogtags, "mem_detect.cos")
    manny:say_line("/mgma043/")
    manny:wait_for_message()
    END_CUT_SCENE()
    start_script(cut_scene.idcorpse, cut_scene)
end
mg.set_up_actors = function(arg1) -- line 255
    local local1
    membrillo.examining = mg.corpse_2
    local1 = membrillo.examining.mem_pnt[0]
    membrillo:default()
    membrillo:put_in_set(mg)
    membrillo:setpos(local1.x, local1.y, local1.z)
    membrillo:setrot(local1.pitch, local1.yaw, local1.roll)
    if not membrillo.detecting then
        membrillo:complete_chore(membrillo_show_tool, "membrillo.cos")
    else
        membrillo:complete_chore(membrillo_hide_tool, "membrillo.cos")
    end
    if mg.met_membrillo then
        start_script(mg.membrillo_idle)
    else
        membrillo:play_chore(membrillo_work_start_to_end, "membrillo.cos")
    end
end
mg.intro = function(arg1) -- line 277
    mg.met_membrillo = TRUE
    START_CUT_SCENE("no head")
    set_override(mg.skip_intro, mg)
    start_sfx("plntSrch.IMU", IM_HIGH_PRIORITY, 10)
    manny:head_look_at(mg.membrillo_obj)
    manny:wait_for_actor()
    manny:say_line("/mgma044/")
    membrillo:wait_for_chore(membrillo_work_start_to_end, "membrillo.cos")
    membrillo:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
    fade_sfx("plntSrch.IMU", 200)
    membrillo:play_chore(membrillo_wkst_to_rest, "membrillo.cos")
    membrillo:wait_for_chore(membrillo_wkst_to_rest, "membrillo.cos")
    membrillo:stop_chore(membrillo_wkst_to_rest, "membrillo.cos")
    membrillo:play_chore(membrillo_rest_to_lkma, "membrillo.cos")
    manny:wait_for_message()
    membrillo:say_line("/mgme045/")
    membrillo:wait_for_chore(membrillo_rest_to_lkma, "membrillo.cos")
    membrillo:stop_chore(membrillo_rest_to_lkma, "membrillo.cos")
    membrillo:play_chore_looping(membrillo_lookat_manny, "membrillo.cos")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme046/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme047/")
    membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
    membrillo:run_chore(membrillo_lkma_to_rest, "membrillo.cos")
    membrillo:stop_chore(membrillo_lkma_to_rest, "membrillo.cos")
    END_CUT_SCENE()
    hot_object = nil
    manny:head_look_at(nil)
    membrillo.examining = mg.corpse_2
    start_script(mg.membrillo_idle)
end
mg.skip_intro = function(arg1) -- line 311
    kill_override()
    membrillo:setpos(mg.corpse_2.mem_pnt[0].x, mg.corpse_2.mem_pnt[0].y, mg.corpse_2.mem_pnt[0].z)
    membrillo:setrot(mg.corpse_2.mem_pnt[0].pitch, mg.corpse_2.mem_pnt[0].yaw, mg.corpse_2.mem_pnt[0].roll)
    membrillo:stop_chore(membrillo_work_start_to_end, "membrillo.cos")
    membrillo:stop_chore(membrillo_lookat_manny, "membrillo.cos")
    membrillo:stop_chore(membrillo_lkma_to_rest, "membrillo.cos")
    membrillo.examining = mg.corpse_2
    start_script(mg.membrillo_idle)
end
mg.enter = function(arg1) -- line 331
    if not find_script(cut_scene.idcorpse) then
        mg:set_up_actors()
        if system.lastSet == pc and not mg.met_membrillo then
            start_script(mg.intro, mg)
        end
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(membrillo.hActor, 0)
    SetActorShadowPoint(membrillo.hActor, 0, 0, 1.4)
    SetActorShadowPlane(membrillo.hActor, "shadow1")
    AddShadowPlane(membrillo.hActor, "shadow1")
end
mg.exit = function(arg1) -- line 348
    if not find_script(cut_scene.idcorpse) then
        stop_script(mg.membrillo_obj.follow_actor)
        membrillo:free()
    end
    stop_sound("plntSrch.IMU")
    KillActorShadows(membrillo.hActor)
end
mg.corpse_1 = Object:create(mg, "/mgtx048/corpse 1", 0.406636, 0.059806, 0.69999999, { range = 0.60000002 })
mg.corpse_1.use_pnt_x = 0.075628698
mg.corpse_1.use_pnt_y = 0.450905
mg.corpse_1.use_pnt_z = 0.46214801
mg.corpse_1.use_rot_x = 0
mg.corpse_1.use_rot_y = -1249.99
mg.corpse_1.use_rot_z = 0
mg.corpse_1.mem_pnt = { }
mg.corpse_1.mem_pnt[0] = { x = 0.0260686, y = -0.50379997, z = 0.55000001, pitch = 0, yaw = 260.03601, roll = 0 }
mg.corpse_1.mem_pnt[1] = { x = 0.036243599, y = -0.098999999, z = 0.55000001, pitch = 0, yaw = 260.03601, roll = 0 }
mg.corpse_1.mem_pnt[2] = { x = 0.072743602, y = -0.0154999, z = 0.55000001, pitch = 0, yaw = 260.03601, roll = 0 }
mg.corpse_1.lookat_leaf_pt = { x = 0.30793899, y = -0.50279999, z = 0.94700003 }
mg.corpse_1.tagged = 0
mg.corpse_1.lookAt = function(arg1) -- line 382
    if not mg.corpse_1.seen then
        mg.corpse_1.seen = TRUE
        START_CUT_SCENE("no head")
        manny:head_look_at(mg.membrillo_obj)
        manny:say_line("/mgma049/")
        wait_for_message()
        membrillo:say_line("/mgme050/")
        wait_for_message()
        membrillo:say_line("/mgme051/")
        wait_for_message()
        manny:say_line("/mgma052/")
        wait_for_message()
        manny:say_line("/mgma053/")
        END_CUT_SCENE()
    else
        START_CUT_SCENE("no head")
        manny:head_look_at(arg1)
        manny:say_line("/mgma054/")
        wait_for_message()
        membrillo:say_line("/mgme055/")
        sleep_for(250)
        manny:head_look_at(mg.membrillo_obj)
        wait_for_message()
        manny:twist_head_gesture()
        manny:say_line("/mgma056/")
        END_CUT_SCENE()
    end
end
mg.corpse_1.pickUp = function(arg1) -- line 412
    manny:say_line("/mgma057/")
end
mg.corpse_1.use = function(arg1) -- line 416
    manny:say_line("/mgma058/")
end
mg.corpse_1.use_dog_tags = function(arg1) -- line 420
    PrintDebug("use_dog_tags with " .. arg1.name .. "\n")
    if membrillo.examining == arg1 then
        system.default_response("hes watching")
    else
        arg1.tagged = 1
        cur_puzzle_state[25] = TRUE
        START_CUT_SCENE()
        if arg1 == mg.corpse_1 then
            manny:walk_and_face(0.0400002, 0.26, 0.55, 0, 203.209, 0)
            manny:push_costume("mc_dogtags.cos")
            manny:stop_chore(mc_hold, "mc.cos")
            manny:stop_chore(mc_activate_dogtags, "mc.cos")
            manny:head_look_at(nil)
            manny:play_chore(mc_dogtags_toss_left, "mc_dogtags.cos")
            manny:wait_for_chore(mc_dogtags_toss_left, "mc_dogtags.cos")
        else
            manny:walk_and_face(0.0400002, 0.26, 0.55, 0, 143.636, 0)
            manny:push_costume("mc_dogtags.cos")
            manny:stop_chore(mc_hold, "mc.cos")
            manny:stop_chore(mc_activate_dogtags, "mc.cos")
            manny:head_look_at(nil)
            manny:play_chore(mc_dogtags_toss_right, "mc_dogtags.cos")
            manny:wait_for_chore(mc_dogtags_toss_right, "mc_dogtags.cos")
        end
        manny:pop_costume()
        manny.is_holding = nil
        si.dog_tags:put_in_limbo()
        END_CUT_SCENE()
        if not membrillo.detecting then
            START_CUT_SCENE("no head")
            manny:head_look_at(mg.membrillo_obj)
            manny:say_line("/mgma059/")
            wait_for_message()
            membrillo:say_line("/mgme060/")
            wait_for_message()
            membrillo:say_line("/mgme061/")
            END_CUT_SCENE()
        end
    end
end
mg.corpse_2 = Object:create(mg, "/mgtx062/corpse 2", -0.233364, 0.019805999, 0.69999999, { range = 0.60000002 })
mg.corpse_2.use_pnt_x = 0.075628698
mg.corpse_2.use_pnt_y = 0.450905
mg.corpse_2.use_pnt_z = 0.46214801
mg.corpse_2.use_rot_x = 0
mg.corpse_2.use_rot_y = -1249.99
mg.corpse_2.use_rot_z = 0
mg.corpse_2.mem_pnt = { }
mg.corpse_2.mem_pnt[0] = { x = -0.031099999, y = -0.19490001, z = 0.55000001, pitch = 0, yaw = 124.176, roll = 0 }
mg.corpse_2.mem_pnt[1] = { x = -0.0266564, y = -0.34259999, z = 0.55000001, pitch = 0, yaw = 124.182, roll = 0 }
mg.corpse_2.mem_pnt[2] = { x = 0.0052435598, y = -0.24339999, z = 0.55000001, pitch = 0, yaw = 124.182, roll = 0 }
mg.corpse_2.lookat_leaf_pt = { x = -0.30636099, y = -0.1833, z = 0.90600002 }
mg.corpse_2.parent = mg.corpse_1
mg.corpse_2.tagged = 0
mg.membrillo_obj = Object:create(mg, "/mgtx063/Coroner", 0.066636004, 0.019805999, 0.89999998, { range = 1.2 })
mg.membrillo_obj.use_pnt_x = -0.0161709
mg.membrillo_obj.use_pnt_y = 0.260189
mg.membrillo_obj.use_pnt_z = 0.55000001
mg.membrillo_obj.use_rot_x = 0
mg.membrillo_obj.use_rot_y = 187.688
mg.membrillo_obj.use_rot_z = 0
mg.membrillo_obj.lookAt = function(arg1) -- line 490
    manny:say_line("/mgma064/")
end
mg.membrillo_obj.use = function(arg1) -- line 494
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    END_CUT_SCENE()
    Dialog:run("mb1", "dlg_membrillo.lua")
end
mg.membrillo_obj.use_detector = function(arg1) -- line 501
    local local1, local2
    START_CUT_SCENE("no head")
    local2 = membrillo.examining
    membrillo.stop_searching = TRUE
    membrillo.stop_walking = TRUE
    manny:walkto_object(arg1)
    manny:say_line("/mgma065/")
    manny:head_look_at(mg.membrillo_obj)
    mg:membrillo_stop_idle(TRUE)
    manny:wait_for_message()
    membrillo:say_line("/mgme066/")
    membrillo:turn_to_rot(0, 10, 0)
    membrillo:play_chore(membrillo_start_walk)
    membrillo:walkto(0.00762909, -0.019210899, 0.55000001)
    membrillo:wait_for_chore(membrillo_start_walk)
    membrillo:play_chore_looping(membrillo_walk)
    while membrillo:is_moving() do
        break_here()
    end
    membrillo:setrot(0, 30, 0, TRUE)
    membrillo:stop_chore(membrillo_walk)
    membrillo:run_chore(membrillo_end_walk)
    membrillo:stop_chore(membrillo_end_walk, "membrillo.cos")
    membrillo:run_chore(membrillo_take_detector)
    membrillo:wait_for_message()
    membrillo:stop_chore(membrillo_take_detector, "membrillo.cos")
    mg:current_setup(mg_morws)
    sl.detector:put_in_limbo()
    manny:stop_chore(mc_hold, "mc.cos")
    manny:stop_chore(mc_activate_detector, "mc.cos")
    manny.is_holding = nil
    membrillo.detecting = TRUE
    membrillo.examining = mg.corpse_2
    membrillo:setpos(mg.corpse_2.mem_pnt[0].x, mg.corpse_2.mem_pnt[0].y, mg.corpse_2.mem_pnt[0].z)
    membrillo:setrot(mg.corpse_2.mem_pnt[0].pitch, mg.corpse_2.mem_pnt[0].yaw, mg.corpse_2.mem_pnt[0].roll)
    membrillo:push_costume("mem_detect.cos")
    membrillo:play_chore(mem_detect_scan, "mem_detect.cos")
    membrillo:say_line("/mgme067/")
    membrillo:wait_for_message()
    membrillo:say_line("/mgme068/")
    membrillo:wait_for_message()
    mg:current_setup(mg_tblms)
    arg1:force_lookat()
    membrillo:play_chore(mem_detect_scan, "mem_detect.cos")
    manny:say_line("/mgma069/")
    membrillo:wait_for_chore(mem_detect_scan, "mem_detect.cos")
    manny:wait_for_message()
    membrillo:turn_to_rot(0, 10, 0)
    local1 = membrillo:getpos()
    manny:head_look_at_point(local1.x, local1.y, local1.z + 0.2)
    sleep_for(1000)
    manny:head_look_at(mg.membrillo_obj)
    manny:say_line("/mgma070/")
    manny:wait_for_message()
    membrillo:turn_to_rot(mg.corpse_2.mem_pnt[0].pitch, mg.corpse_2.mem_pnt[0].yaw, mg.corpse_2.mem_pnt[0].roll)
    END_CUT_SCENE()
    membrillo.stop_searching = FALSE
    membrillo.stop_walking = FALSE
    start_script(mg.membrillo_idle)
end
mg.membrillo_obj.follow_actor = function(arg1) -- line 574
    local local1, local2, local3
    local1, local2, local3 = GetActorNodeLocation(membrillo.hActor, 40)
    arg1.obj_x = local1
    arg1.obj_y = local2
    arg1.obj_z = local3
    arg1.interest_actor:put_in_set(mg)
    arg1.interest_actor:setpos(arg1.obj_x, arg1.obj_y, arg1.obj_z)
    if hot_object == mg.membrillo_obj then
        system.currentActor:head_look_at(arg1)
    end
end
mg.membrillo_obj.force_lookat = function(arg1) -- line 590
    local local1, local2, local3
    local1, local2, local3 = GetActorNodeLocation(membrillo.hActor, 40)
    manny:head_look_at_point(local1, local2, local3)
end
mg.open_vault_1 = Object:create(mg, "/mgtx071/slab", 1.3095, -1.0041, 0.66000003, { range = 0.70999998 })
mg.open_vault_1.use_pnt_x = 1.18475
mg.open_vault_1.use_pnt_y = -0.94498003
mg.open_vault_1.use_pnt_z = 0.2
mg.open_vault_1.use_rot_x = 0
mg.open_vault_1.use_rot_y = -1194.45
mg.open_vault_1.use_rot_z = 0
mg.open_vault_1.lookAt = function(arg1) -- line 605
    soft_script()
    system.default_response("empty")
    wait_for_message()
    membrillo:say_line("/mgme072/")
end
mg.open_vault_1.use = function(arg1) -- line 612
    soft_script()
    manny:head_look_at(mg.membrillo_obj)
    manny:say_line("/mgma073/")
    wait_for_message()
    membrillo:say_line("/mgme074/")
end
mg.open_vault_2 = Object:create(mg, "/mgtx075/slab", -0.89050001, -1.3041, 0.66000003, { range = 0.70999998 })
mg.open_vault_2.use_pnt_x = -0.80896801
mg.open_vault_2.use_pnt_y = -1.23271
mg.open_vault_2.use_pnt_z = 0.2
mg.open_vault_2.use_rot_x = 0
mg.open_vault_2.use_rot_y = -1297.46
mg.open_vault_2.use_rot_z = 0
mg.open_vault_2.parent = mg.open_vault_1
mg.pc_door = Object:create(mg, "/mgtx076/door", -0.043364, 2.26981, 0.63, { range = 0.60000002 })
mg.pc_door.use_pnt_x = 0.0135086
mg.pc_door.use_pnt_y = 1.66761
mg.pc_door.use_pnt_z = 0.2
mg.pc_door.use_rot_x = 0
mg.pc_door.use_rot_y = -718.51202
mg.pc_door.use_rot_z = 0
mg.pc_door.out_pnt_x = 0.0061704698
mg.pc_door.out_pnt_y = 1.95
mg.pc_door.out_pnt_z = 0.2
mg.pc_door.out_rot_x = 0
mg.pc_door.out_rot_y = -718.51202
mg.pc_door.out_rot_z = 0
mg.pc_box = mg.pc_door
mg.pc_door.walkOut = function(arg1) -- line 654
    pc:come_out_door(pc.mg_door)
end
