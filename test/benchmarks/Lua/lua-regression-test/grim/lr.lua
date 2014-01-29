CheckFirstTime("lr.lua")
lr = Set:create("lr.set", "Diner", { lr_dinws = 0 })
lr.look_count = 0
lr.scare_count = 0
dofile("bruno_cocoon.lua")
dofile("bruno_skel.lua")
dofile("md.lua")
lr.walk_in = function(arg1) -- line 17
    START_CUT_SCENE()
    EngineDisplay(FALSE)
    lr:switch_to_set()
    manny:put_in_set(lr)
    manny:setpos(1.327, 0.576, 0)
    manny:setrot(0, 327.105, 0)
    break_here()
    EngineDisplay(TRUE)
    start_script(manny.walk_and_face, manny, 0.868998, 0.733956, 0, 0, 142.288, 0)
    manny:setrot(0, 127.17, 0)
    END_CUT_SCENE()
    manny:say_line("/lrma002/")
    lr.lr_return_box = lr.door
end
lr.lookAt_citizen = function() -- line 40
    lr.look_count = lr.look_count + 1
    if lr.look_count == 1 then
        manny:say_line("/lrma003/")
    elseif lr.look_count == 2 then
        manny:say_line("/lrma004/")
    elseif lr.look_count == 3 then
        manny:say_line("/lrma005/")
    else
        manny:say_line("/lrma006/")
    end
end
lr.scare_citizen = function(arg1) -- line 54
    lr.scare_count = lr.scare_count + 1
    arg1:play_chore(LR_SCARED)
    start_sfx("tbd.wav")
    wait_for_sound("tbd.wav")
    if lr.scare_count == 1 then
        manny:say_line("/lrma007/")
    elseif lr.scare_count == 2 then
        manny:say_line("/lrma008/")
    elseif lr.scare_count == 3 then
        manny:say_line("/lrma009/")
    elseif lr.scare_count == 4 then
        manny:say_line("/lrma010/")
    elseif lr.scare_count == 5 then
        manny:say_line("/lrma011/")
    elseif lr.scare_count == 6 then
        START_CUT_SCENE()
        manny:say_line("/lrma012/")
        wait_for_message()
        manny:say_line("/lrma013/")
        END_CUT_SCENE()
    else
        manny:say_line("/lrma014/")
    end
    manny:wait_for_message()
    arg1:play_chore(LR_NORMAL)
end
LR_NORMAL = 0
LR_SCARED = 1
LR_CLEAR = 2
lr.bruno_squeak = function() -- line 87
    local local1
    while system.currentSet == lr do
        local1 = pick_one_of({ "brWiggl1.wav", "brWiggl2.wav", "brWiggl3.wav", "brWiggl4.wav" })
        start_sfx(local1)
        lr.cocoon:play_chore(bruno_cocoon_wiggle)
        wait_for_sound(local1)
        lr.cocoon:wait_for_chore()
        sleep_for(rnd(1000, 4000))
    end
end
lr.enter = function(arg1) -- line 99
    inventory_disabled = TRUE
    bruno = Actor:create(nil, nil, nil, "/lrtx001/")
    bruno:set_talk_color(Blue)
    bruno:put_in_set(lr)
    bruno:set_costume("bruno_skel.cos")
    bruno:set_mumble_chore(bruno_skel_mumble)
    bruno:set_talk_chore(1, bruno_skel_stop_talk)
    bruno:set_talk_chore(2, bruno_skel_a)
    bruno:set_talk_chore(3, bruno_skel_c)
    bruno:set_talk_chore(4, bruno_skel_e)
    bruno:set_talk_chore(5, bruno_skel_f)
    bruno:set_talk_chore(6, bruno_skel_l)
    bruno:set_talk_chore(7, bruno_skel_m)
    bruno:set_talk_chore(8, bruno_skel_o)
    bruno:set_talk_chore(9, bruno_skel_t)
    bruno:set_talk_chore(10, bruno_skel_u)
    bruno:setpos(0.416993, -0.0956955, -0.043)
    bruno:setrot(0, 210, 0)
    bruno:set_visibility(FALSE)
    NewObjectState(lr_dinws, 3, "lr_man.bm")
    NewObjectState(lr_dinws, 3, "lr_women.bm")
    NewObjectState(lr_dinws, 3, "lr_women2.bm")
    lr.big_head_lady:set_object_state("lr_head_woman.cos")
    lr.big_hand_lady:set_object_state("lr_hand_woman.cos")
    lr.cop:set_object_state("lr_man.cos")
    lr.big_head_lady:play_chore(LR_NORMAL)
    lr.big_hand_lady:play_chore(LR_NORMAL)
    lr.cop:play_chore(LR_NORMAL)
    NewObjectState(lr_dinws, 3, "lr_cocoon_states.bm", "lr_cocoon_states.zbm", 1)
    lr.cocoon:set_object_state("bruno_cocoon.cos")
    preload_sfx("brWiggl1.wav")
    preload_sfx("brWiggl2.wav")
    preload_sfx("brWiggl3.wav")
    preload_sfx("brWiggl4.wav")
    start_script(lr.bruno_squeak)
    manny.idles_allowed = FALSE
    stop_script(manny.idle_timer)
    stop_script(manny.idle)
end
lr.exit = function(arg1) -- line 149
    bruno:free()
    lr.cocoon:free_object_state()
    lr.big_head_lady:free_object_state()
    lr.big_hand_lady:free_object_state()
    lr.cop:free_object_state()
    manny:default("suit")
    inventory_disabled = FALSE
    manny.idles_allowed = TRUE
end
lr.cocoon = Object:create(lr, "/lrtx015/body", 0.272156, -0.027146799, 0, { range = 0.5 })
lr.cocoon.use_pnt_x = 0.025
lr.cocoon.use_pnt_y = 0.0089999996
lr.cocoon.use_pnt_z = 0
lr.cocoon.use_rot_x = 0
lr.cocoon.use_rot_y = 578.34003
lr.cocoon.use_rot_z = 0
lr.cocoon.lookAt = function(arg1) -- line 170
    START_CUT_SCENE()
    manny:say_line("/lrma016/")
    wait_for_message()
    manny:say_line("/lrma017/")
    END_CUT_SCENE()
end
lr.cocoon.pickUp = function(arg1) -- line 178
    START_CUT_SCENE()
    manny:say_line("/lrma018/")
    wait_for_message()
    manny:say_line("/lrma019/")
    END_CUT_SCENE()
end
lr.cocoon.use = function(arg1) -- line 186
    manny:say_line("/lrma020/")
end
lr.cocoon.use_scythe = function(arg1) -- line 190
    cur_puzzle_state[3] = TRUE
    START_CUT_SCENE()
    stop_script(lr.bruno_squeak)
    manny:walkto(0.614666, 0.365, 0, 0, 129.859, 0)
    manny:wait_for_actor()
    lr.cocoon:wait_for_chore()
    manny:set_rest_chore(nil)
    manny:stop_chore(md_hold_scythe, "md.cos")
    manny:push_costume("ma_reap_bruno.cos")
    manny:play_chore(0)
    sleep_for(1072)
    lr.cocoon.interest_actor:stop_chore(bruno_cocoon_wiggle)
    lr.cocoon.interest_actor:play_chore(bruno_cocoon_burst)
    music_state:set_sequence(seqReapBruno)
    bruno:setpos(0.416993, -0.0956955, -0.043)
    bruno:setrot(0, 210, 0)
    bruno:set_visibility(TRUE)
    bruno:play_chore(bruno_skel_reaped)
    manny:wait_for_chore(0)
    manny:pop_costume()
    manny:set_rest_chore(md_rest, "md.cos")
    manny:play_chore(md_hold_scythe, "md.cos")
    mo.scythe:put_away()
    bruno:wait_for_chore(bruno_skel_reaped)
    bruno:say_line("/lrbr021/")
    bruno:wait_for_message()
    END_CUT_SCENE()
    start_script(cut_scene.brunopk, cut_scene)
end
lr.big_head_lady = Object:create(lr, "/lrtx022/woman", -0.63784403, 0.15285499, 0.74000001, { range = 0.80000001 })
lr.big_head_lady.use_pnt_x = -0.491
lr.big_head_lady.use_pnt_y = 0.14
lr.big_head_lady.use_pnt_z = 0
lr.big_head_lady.use_rot_x = 0
lr.big_head_lady.use_rot_y = 1144.8
lr.big_head_lady.use_rot_z = 0
lr.big_head_lady.lookAt = function(arg1) -- line 231
    lr.lookAt_citizen()
end
lr.big_head_lady.pickUp = function(arg1) -- line 235
    manny:say_line("/lrma023/")
end
lr.big_head_lady.use_scythe = lr.big_head_lady.pickUp
lr.big_head_lady.use = function(arg1) -- line 241
    lr.scare_citizen(arg1)
end
lr.cop = Object:create(lr, "/lrtx024/police officer", 0.32222101, 1.89385, 0.62, { range = 1.5 })
lr.cop.use_pnt_x = 0.391
lr.cop.use_pnt_y = 0.49599999
lr.cop.use_pnt_z = 0
lr.cop.use_rot_x = 0
lr.cop.use_rot_y = 1082.97
lr.cop.use_rot_z = 0
lr.cop.parent = lr.big_head_lady
lr.big_hand_lady = Object:create(lr, "/lrtx025/woman", -0.33777899, 2.93385, 0.62, { range = 3 })
lr.big_hand_lady.use_pnt_x = -0.032000002
lr.big_hand_lady.use_pnt_y = 0.38600001
lr.big_hand_lady.use_pnt_z = 0
lr.big_hand_lady.use_rot_x = 0
lr.big_hand_lady.use_rot_y = 1445.99
lr.big_hand_lady.use_rot_z = 0
lr.big_hand_lady.parent = lr.big_head_lady
lr.food = Object:create(lr, "/lrtx026/food", -0.33784401, -0.58714497, 0.41999999, { range = 0.75 })
lr.food.use_pnt_x = -0.45500001
lr.food.use_pnt_y = -0.17200001
lr.food.use_pnt_z = 0
lr.food.use_rot_x = 0
lr.food.use_rot_y = 1626.76
lr.food.use_rot_z = 0
lr.food.lookAt = function(arg1) -- line 280
    manny:say_line("/lrma027/")
end
lr.food.pickUp = function(arg1) -- line 284
    manny:say_line("/lrma028/")
end
lr.food.use = function(arg1) -- line 288
    START_CUT_SCENE()
    manny:say_line("/lrma029/")
    wait_for_message()
    manny:say_line("/lrma030/")
    END_CUT_SCENE()
end
lr.brown_cow = Object:create(lr, "/lrtx031/milkshake", 0.41215599, -0.84714502, 0.36000001, { range = 0.69999999 })
lr.brown_cow.use_pnt_x = 0.45899999
lr.brown_cow.use_pnt_y = -0.43799999
lr.brown_cow.use_pnt_z = 0
lr.brown_cow.use_rot_x = 0
lr.brown_cow.use_rot_y = 1263.74
lr.brown_cow.use_rot_z = 0
lr.brown_cow.lookAt = function(arg1) -- line 306
    manny:say_line("/lrma032/")
end
lr.brown_cow.pickUp = function(arg1) -- line 310
    manny:say_line("/lrma033/")
end
lr.brown_cow.use = function(arg1) -- line 314
    START_CUT_SCENE()
    manny:say_line("/lrma034/")
    wait_for_message()
    manny:say_line("/lrma035/")
    END_CUT_SCENE()
end
lr.door = Object:create(lr, "/lrtx036/door", 0, 0, 0, { range = 0 })
lr.door.walkOut = function(arg1) -- line 326
    if reaped_bruno then
        start_script(cut_scene.brunopk)
    else
        START_CUT_SCENE()
        manny:say_line("/lrma037/")
        manny:walkto(0.750573, 0.274314, 0, 0, 114, 0)
        manny:wait_for_message()
        manny:say_line("/lrma038/")
        END_CUT_SCENE()
    end
end
