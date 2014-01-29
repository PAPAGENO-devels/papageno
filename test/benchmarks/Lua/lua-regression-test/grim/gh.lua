CheckFirstTime("gh.lua")
gh = Set:create("gh.set", "Glottis hanging on the Lamancha", { gh_top = 0, gh_lamha = 1 })
dofile("gl_work_idles.lua")
gh.run_props = function() -- line 14
    start_sfx("gh_prop.wav")
    gh.prop:run_chore(0)
    wait_for_sound("gh_prop.wav")
    start_sfx("gh_prop.wav")
    gh.prop:run_chore(0)
    wait_for_sound("gh_prop.wav")
    if rnd() then
        start_sfx("gh_prop.wav")
        gh.prop:run_chore(0)
    end
    gh.prop:complete_chore(2)
end
gh.prop_watch = function() -- line 28
    while 1 do
        while not prop_trigger do
            break_here()
        end
        prop_trigger = FALSE
        if gh.reunited then
            if rnd() then
                gh.run_props()
            end
        end
    end
end
gh.tinker_sound_watcher = function() -- line 42
    local local1, local2, local3
    local3 = ""
    while 1 do
        local2 = pick_one_of({ "tinker1.wav", "tinker3.wav", "tinker4.wav", "tinker5.wav", "tinker6.wav", "tinker7.wav", "tinker8.wav", "tinker9.wav" })
        if glottis.last_chore == gl_work_idles_work2_loop or glottis.last_chore == gl_work_idles_work_cycle then
            if cutSceneLevel == 0 then
                start_sfx(local2)
                wait_for_sound(local2)
                sleep_for(rndint(500, 3000))
            end
        end
        break_here()
    end
end
gh.reunion = function() -- line 62
    gh.reunited = TRUE
    START_CUT_SCENE()
    manny:set_run(TRUE)
    set_override(gh.reunion_override)
    wait_for_message()
    manny:say_line("/ghma001/")
    gh.glot_look_manny()
    wait_for_message()
    manny:say_line("/ghma002/")
    wait_for_message()
    glottis:say_line("/ghgl003/")
    sleep_for(3500)
    glottis:play_chore(gl_work_idles_gesture, "gl_work_idles.cos")
    wait_for_message()
    manny:say_line("/ghma004/")
    wait_for_message()
    glottis:say_line("/ghgl005/")
    glottis:run_chore(gl_work_idles_look_back_work, "gl_work_idles.cos")
    glottis:run_chore(gl_work_idles_start_work, "gl_work_idles.cos")
    glottis:play_chore(gl_work_idles_see_spin, "gl_work_idles.cos")
    sleep_for(1000)
    gh.run_props()
    glottis:wait_for_chore(gl_work_idles_see_spin, "gl_work_idles.cos")
    glottis:say_line("/ghgl006/")
    glottis:run_chore(gl_work_idles_look_at_manny, "gl_work_idles.cos")
    gh.glot_return_work()
    wait_for_message()
    manny:say_line("/ghma007/")
    END_CUT_SCENE()
    manny:set_run(FALSE)
end
gh.reunion_override = function() -- line 97
    kill_override()
    manny:put_at_object(gh.glottis_obj)
    glottis:stop_chore()
    single_start_script(glottis.new_run_idle, glottis, "work_cycle", gh.work_table, "gl_work_idles.cos")
end
gh.glot_look_manny = function() -- line 104
    glottis.working = FALSE
    stop_script(glottis.new_run_idle)
    glottis:wait_for_chore(nil, "gl_work_idles.cos")
    if glottis.last_chore == gl_work_idles_work2_loop or glottis.last_chore == gl_work_idles_work_to_work2 then
        glottis:run_chore(gl_work_idles_work2_to_work, "gl_work_idles.cos")
    end
    if glottis.last_chore == gl_work_idles_working_up then
        glottis:run_chore(gl_work_idles_look_at_manny, "gl_work_idles.cos")
    else
        glottis:run_chore(gl_work_idles_work_to_manny, "gl_work_idles.cos")
    end
end
gh.glot_return_work = function() -- line 118
    glottis.working = TRUE
    glottis:run_chore(gl_work_idles_look_back_work, "gl_work_idles.cos")
    glottis:run_chore(gl_work_idles_start_work, "gl_work_idles.cos")
    single_start_script(glottis.new_run_idle, glottis, "work_cycle", gh.work_table, "gl_work_idles.cos")
end
gh.glot_tinker_sfx = function() -- line 125
    start_sfx(pick_one_of({ "tinker1.wav", "tinker3.wav", "tinker4.wav", "tinker5.wav", "tinker6.wav", "tinker7.wav", "tinker8.wav", "tinker9.wav" }))
end
gh.work_table = Idle:create("gl_work_idles")
idt = gh.work_table
idt:add_state("work_cycle", { work_cycle = 0.69999999, working_up = 0.1, work_to_work2 = 0.1, see_spin = 0.1 })
idt:add_state("see_spin", { start_work = 1 })
idt:add_state("start_work", { work_cycle = 1 })
idt:add_state("working_up", { pause = 1 })
idt:add_state("pause", { pause = 0.69999999, working_down = 0.30000001 })
idt:add_state("working_down", { work_cycle = 1 })
idt:add_state("work_to_work2", { work2_loop = 1 })
idt:add_state("work2_loop", { work2_loop = 0.80000001, work2_to_work = 0.2 })
idt:add_state("work2_to_work", { work_cycle = 1 })
gh.set_up_actors = function(arg1) -- line 147
    if dr.reunited then
        glottis:default("sailor")
        glottis:ignore_boxes()
        glottis:put_in_set(gh)
        glottis:push_costume("gl_work_idles.cos")
        glottis:setpos(1.70973, 0.24421, 0.927887)
        glottis:setrot(0, 151.875, 0)
        single_start_script(glottis.new_run_idle, glottis, "work_cycle", gh.work_table, "gl_work_idles.cos")
        glottis.working = TRUE
        gh.prop:complete_chore(2)
    end
end
gh.come_out_door = function(arg1, arg2) -- line 162
    START_CUT_SCENE()
    manny:default()
    gh:switch_to_set()
    box_off("ac_door")
    doorman_in_hot_box = TRUE
    manny:put_in_set(gh)
    box_off("ac_door")
    manny:put_at_object(gh.ac_door)
    manny:push_costume("mn2_ladder_jump.cos")
    manny:run_chore(0)
    box_off("ac_door")
    manny:pop_costume()
    manny:walkto(-2.94464, -4.61542, 2.62035)
    sleep_for(500)
    while manny:find_sector_name("ac_door") do
        break_here()
    end
    sleep_for(500)
    box_on("ac_door")
    END_CUT_SCENE()
end
gh.enter = function(arg1) -- line 192
    inventory_disabled = FALSE
    if not dr.reunited then
        gh.glottis_obj:make_untouchable()
    else
        gh.glottis_obj:make_touchable()
    end
    gh:current_setup(gh_lamha)
    gh.seen_lamancha = TRUE
    gh:set_up_actors()
    gh.prop.hObjectState = gh:add_object_state(gh_lamha, "gh_prop.bm", nil, OBJSTATE_UNDERLAY, FALSE)
    gh.prop:set_object_state("gh_prop.cos")
    start_script(gh.prop_watch)
    start_script(gh.tinker_sound_watcher)
    start_sfx("eiCreak.imu", IM_HIGH_PRIORITY, 64)
end
gh.exit = function(arg1) -- line 211
    stop_script(gh.prop_watch)
    stop_script(gh.tinker_sound_watcher)
    glottis:free()
    stop_sound("eiCreak.imu")
end
gh.prop = Object:create(gh, "", 0, 0, 0, { range = 0 })
gh.prop.touchable = FALSE
gh.edge_trigger = { }
gh.edge_trig1 = gh.edge_trigger
gh.edge_trig2 = gh.edge_trigger
gh.edge_trigger.walkOut = function(arg1) -- line 233
    manny:say_line("/ghma008/")
end
gh.glottis_obj = Object:create(gh, "/ghtx009/Glottis", 1.37207, 0.030761199, 1.66072, { range = 0.75 })
gh.glottis_obj.use_pnt_x = 0.73766702
gh.glottis_obj.use_pnt_y = -0.24983899
gh.glottis_obj.use_pnt_z = 1.45872
gh.glottis_obj.use_rot_x = 0
gh.glottis_obj.use_rot_y = -67.615097
gh.glottis_obj.use_rot_z = 0
gh.glottis_obj.lookAt = function(arg1) -- line 247
    if gh.reunited then
        manny:say_line("/ghma010/")
    else
        start_script(gh.reunion)
    end
end
gh.glottis_obj.use = function(arg1) -- line 255
    if gh.reunited then
        START_CUT_SCENE()
        manny:say_line("/ghma011/")
        gh.glot_look_manny()
        wait_for_message()
        glottis:play_chore(gl_work_idles_look_back_work, "gl_work_idles.cos")
        glottis:say_line("/ghgl012/")
        wait_for_message()
        glottis:play_chore(gl_work_idles_look_at_manny, "gl_work_idles.cos")
        glottis:say_line("/ghgl013/")
        gh.glot_return_work()
        END_CUT_SCENE()
    else
        start_script(gh.reunion)
    end
end
gh.glottis_obj.use_scythe = function(arg1) -- line 273
    if gh.reunited then
        START_CUT_SCENE()
        manny:say_line("/ghma014/")
        wait_for_message()
        glottis:say_line("/ghgl015/")
        END_CUT_SCENE()
    else
        start_script(gh.reunion)
    end
end
gh.glottis_obj.use_hammer = function(arg1) -- line 285
    if gh.reunited then
        START_CUT_SCENE()
        manny:say_line("/ghma016/")
        wait_for_message()
        glottis:say_line("/ghgl017/")
        wait_for_message()
        glottis:say_line("/ghgl018/")
        END_CUT_SCENE()
    else
        start_script(gh.reunion)
    end
end
gh.glottis_obj.use_gun = function(arg1) -- line 299
    if gh.reunited then
        START_CUT_SCENE()
        manny:say_line("/ghma019/")
        wait_for_message()
        manny:say_line("/ghma020/")
        gh.glot_look_manny()
        wait_for_message()
        glottis:say_line("/ghgl021/")
        wait_for_message()
        manny:say_line("/ghma022/")
        wait_for_message()
        glottis:say_line("/ghgl023/")
        gh.glot_return_work()
        END_CUT_SCENE()
    else
        start_script(gh.reunion)
    end
end
gh.glottis_obj.use_chisel = function(arg1) -- line 319
    if gh.reunited then
        START_CUT_SCENE()
        manny:say_line("/ghma024/")
        gh.glot_look_manny()
        wait_for_message()
        glottis:say_line("/ghgl025/")
        wait_for_message()
        glottis:say_line("/ghgl026/")
        gh.glot_return_work()
        END_CUT_SCENE()
    else
        start_script(gh.reunion)
    end
end
gh.ac_door = Object:create(gh, "/ghtx027/chain", -3.1500001, -5.5324001, 3.4844999, { range = 2 })
gh.ac_door.use_pnt_x = -3.1500001
gh.ac_door.use_pnt_y = -5.0999899
gh.ac_door.use_pnt_z = 2.6099999
gh.ac_door.use_rot_x = 0
gh.ac_door.use_rot_y = -177.633
gh.ac_door.use_rot_z = 0
gh.ac_door.out_pnt_x = -3.1500001
gh.ac_door.out_pnt_y = -5.0999899
gh.ac_door.out_pnt_z = 2.6099999
gh.ac_door.out_rot_x = 0
gh.ac_door.out_rot_y = -177.633
gh.ac_door.out_rot_z = 0
gh.ac_door.walkOut = function(arg1) -- line 356
    if dr.reunited and not gh.reunited then
        START_CUT_SCENE()
        glottis:say_line("/ghgl028/")
        start_script(manny.walkto, manny, gh.glottis_obj)
        break_here()
        manny:set_run(TRUE)
        END_CUT_SCENE()
        start_script(gh.reunion)
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:wait_for_actor()
        manny:clear_hands()
        manny:push_costume("mn2_ladder_jump.cos")
        manny:run_chore(1)
        manny:pop_costume()
        system:lock_display()
        ac:switch_to_set()
        manny:put_in_set(ac)
        manny:follow_boxes()
        break_here()
        manny:ignore_boxes()
        manny:push_costume("mn_conveyor.cos")
        manny:setpos(8.38527, -1.78484, 0.3333)
        manny:setrot(0, 95.7788, 0)
        system:unlock_display()
        manny:stop_chore(mn_conveyor_loop_current, "mn_conveyor.cos")
        manny:play_chore_looping(mn_conveyor_drift, "mn_conveyor.cos")
        ac.prev_button_handler = system.buttonHandler
        system.buttonHandler = drift_button_handler
        ac.drifting = TRUE
        END_CUT_SCENE()
    end
end
gh.ac_door.lookAt = function(arg1) -- line 395
    manny:say_line("/ghma029/")
end
gh.ac_door.use = gh.ac_door.walkOut
