CheckFirstTime("cc.lua")
cc = Set:create("cc.set", "coat check", { cc_intws = 0, cc_ovrhd = 1 })
cc.shrinkable = 0.014
dofile("lupe_idles.lua")
dofile("lupe_coat.lua")
dofile("ma_check_coat.lua")
lupe.idle_table = Idle:create("lupe_idles")
lupe.idle_table:add_state("behind_desk", { behind_desk = 0.99, jumps_greeting = 0.01 })
lupe.idle_table:add_state("main_pose", { forward_to_talk = 0.2, jump_back = 0.8 })
lupe.idle_table:add_state("head_return_pose", { head_right = 0.1, main_pose = 0.9 })
lupe.idle_table:add_state("head_right", { head_return_pose = 1 })
lupe.idle_table:add_state("forward_to_talk", { head_right = 0.8, main_pose = 0.2 })
lupe.idle_table:add_state("jumps_greeting", { jump_back = 1 })
lupe.idle_table:add_state("jump_back", { behind_desk = 1 })
lupe.stop_table = { }
lupe.stop_table[lupe_idles_behind_desk] = lupe_idles_jumps_greeting
lupe.stop_table[lupe_idles_main_pose] = lupe_idles_forward_to_talk
lupe.stop_table[lupe_idles_head_return_pose] = lupe_idles_main_pose
lupe.stop_table[lupe_idles_head_right] = lupe_idles_head_return_pose
lupe.stop_table[lupe_idles_jumps_greeting] = lupe_idles_forward_to_talk
lupe.stop_table[lupe_idles_jump_back] = lupe_idles_jumps_greeting
cc.lupe_music = FALSE
cc.get_paper = function(arg1) -- line 39
    cur_puzzle_state[30] = TRUE
    START_CUT_SCENE()
    manny:walkto_object(cc.lupe_obj)
    cc.jacket:get()
    lupe:kill_idle(lupe_idles_forward_to_talk)
    lx.lengua:put_in_limbo()
    lupe:say_line("/cclu001/")
    wait_for_message()
    lupe:say_line("/cclu002/")
    lupe:push_chore(lupe_idles_clapping)
    lupe:push_chore()
    cc.lupe_music = TRUE
    music_state:update()
    wait_for_message()
    manny:say_line("/ccma003/")
    wait_for_message()
    lupe:say_line("/cclu004/")
    lupe:push_chore(lupe_idles_forward_shake_hands)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_forward_to_talk)
    lupe:push_chore()
    lupe:push_chore(lupe_idles_main_pose)
    lupe:push_chore()
    wait_for_message()
    lupe:say_line("/cclu005/")
    wait_for_message()
    lupe:say_line("/cclu006/")
    wait_for_message()
    lupe:wait_for_chore()
    lupe:fade_out_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
    sleep_for(500)
    lupe:play_chore(lupe_coat_get_lengua, "lupe_coat.cos")
    manny:stop_chore(mc_activate_lengua, manny.base_costume)
    manny:stop_chore(ms_hold, manny.base_costume)
    manny:play_chore(ma_hand_on_obj, manny.base_costume)
    lupe:say_line("/cclu007/")
    manny:wait_for_chore()
    manny:stop_chore(ma_hand_on_obj, manny.base_costume)
    manny:play_chore(ma_hand_off_obj, manny.base_costume)
    lupe:wait_for_chore()
    lupe:stop_chore(lupe_coat_get_lengua, "lupe_coat.cos")
    lupe:fade_in_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
    sleep_for(500)
    lupe:print_costumes()
    lupe:wait_for_chore()
    lupe:play_chore(lupe_idles_jump_back, "lupe_idles.cos", 500)
    lupe:wait_for_chore()
    lupe:play_chore_looping(lupe_idles_behind_desk, "lupe_idles.cos")
    start_sfx("cabSrch.IMU", IM_HIGH_PRIORITY, 100)
    lupe:say_line("/cclu008/")
    wait_for_message()
    lupe:say_line("/cclu009/")
    wait_for_message()
    lupe:say_line("/cclu010/")
    sleep_for(1000)
    lupe:set_chore_looping(lupe_idles_behind_desk, FALSE)
    fade_sfx("cabSrch.IMU", 250, 0)
    wait_for_message()
    lupe:say_line("/cclu011/")
    lupe:wait_for_message()
    cc.lupe_music = FALSE
    music_state:update()
    lupe:say_line("/cclu012/")
    wait_for_message()
    manny:say_line("/ccma013/")
    wait_for_message()
    lupe:say_line("/cclu014/")
    wait_for_message()
    manny:say_line("/ccma015/")
    wait_for_message()
    lupe:say_line("/cclu016/")
    lupe:play_chore(lupe_coat_hold_coat, "lupe_coat.cos")
    lupe:play_chore(lupe_idles_jumps_greeting, "lupe_idles.cos")
    lupe:wait_for_chore()
    manny:say_line("/ccma017/")
    lupe:fade_out_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
    sleep_for(500)
    wait_for_message()
    lupe:stop_chore(lupe_coat_hold_coat, "lupe_coat.cos")
    lupe:play_chore(lupe_coat_give_coat, "lupe_coat.cos")
    manny:push_costume("ma_check_coat.cos")
    manny:play_chore(ma_check_coat_coat_putaway)
    lupe:say_line("/cclu018/")
    sleep_for(1000)
    manny:blend(mc_hold_coat, ma_check_coat_coat_putaway, 500, "mc.cos", "ma_check_coat.cos")
    sleep_for(500)
    manny:pop_costume()
    manny:play_chore_looping(mc_hold_coat, "mc.cos")
    manny:play_chore_looping(mc_hold, "mc.cos")
    manny.hold_chore = mc_hold_coat
    manny.is_holding = cc.jacket
    wait_for_message()
    lupe:wait_for_chore()
    lupe:print_costumes()
    lupe:stop_chore(lupe_coat_give_coat, "lupe_coat.cos")
    lupe:fade_in_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
    sleep_for(500)
    lupe:play_chore(lupe_idles_jump_back)
    manny:say_line("/ccma019/")
    manny:wait_for_message()
    lupe:say_line("/cclu020/")
    lupe:wait_for_message()
    lupe:wait_for_chore()
    start_script(lupe.new_run_idle, lupe, "behind_desk")
    manny:say_line("/ccma021/")
    wait_for_message()
    lupe:head_look_at(manny)
    lupe:say_line("/cclu022/")
    wait_for_message()
    manny:say_line("/ccma023/")
    manny:wait_for_message()
    lupe:head_look_at(nil)
    END_CUT_SCENE()
end
cc.talk_note = function(arg1) -- line 168
    START_CUT_SCENE()
    lupe:kill_idle(lupe_idles_jumps_greeting)
    manny:walkto_object(cc.lupe_obj)
    cc.talked_note = TRUE
    lupe:head_look_at_manny()
    lupe:say_line("/cclu024/")
    wait_for_message()
    manny:say_line("/ccma025/")
    wait_for_message()
    lupe:say_line("/cclu026/")
    lupe:play_chore(lupe_idles_jump_back)
    wait_for_message()
    cc.lupe_music = TRUE
    music_state:update()
    lupe:wait_for_chore()
    lupe:head_look_at(nil)
    start_sfx("cabSrch.IMU", IM_HIGH_PRIORITY, 100)
    lupe:play_chore_looping(lupe_idles_behind_desk)
    lupe:say_line("/cclu027/")
    wait_for_message()
    lupe:say_line("/cclu028/")
    wait_for_message()
    lupe:say_line("/cclu029/")
    wait_for_message()
    lupe:say_line("/cclu030/")
    wait_for_message()
    lupe:say_line("/cclu031/")
    wait_for_message()
    lupe:say_line("/cclu032/")
    wait_for_message()
    lupe:say_line("/cclu033/")
    wait_for_message()
    lupe:say_line("/cclu034/")
    wait_for_message()
    lupe:say_line("/cclu035/")
    wait_for_message()
    lupe:say_line("/cclu036/")
    wait_for_message()
    lupe:say_line("/cclu037/")
    lupe:set_chore_looping(lupe_idles_behind_desk, FALSE)
    wait_for_message()
    lupe:say_line("/cclu038/")
    wait_for_message()
    lupe:wait_for_chore()
    fade_sfx("cabSrch.IMU", 500, 0)
    lupe:play_chore(lupe_idles_jumps_greeting)
    lupe:say_line("/cclu039/")
    lupe:head_look_at_manny()
    wait_for_message()
    cc.lupe_music = FALSE
    music_state:update()
    lupe:wait_for_chore()
    lupe:head_look_at(nil)
    lupe:say_line("/cclu040/")
    lupe:head_look_at_point({ x = -2.3075, y = 0.489651, z = 0.284 })
    manny:head_look_at_point({ x = -2.3075, y = 0.489651, z = 0.284 })
    wait_for_message()
    lupe:wait_for_chore()
    lupe:say_line("/cclu041/")
    wait_for_message()
    manny:say_line("/ccma042/")
    wait_for_message()
    lupe:say_line("/cclu043/")
    lupe:head_look_at_manny()
    lupe:play_chore(lupe_idles_jump_back, "lupe_idles.cos")
    wait_for_message()
    start_script(lupe.new_run_idle, lupe, "behind_desk")
    lupe:head_look_at(nil)
    lupe:say_line("/cclu044/")
    wait_for_message()
    lupe:say_line("/cclu045/")
    manny:head_look_at(nil)
    END_CUT_SCENE()
end
cc.grab_manny = function(arg1) -- line 245
    cc.lupe_waiting = FALSE
    START_CUT_SCENE()
    local local1 = start_script(lupe.kill_idle, lupe, lupe_idles_forward_to_talk)
    lupe:say_line("/cclu132/")
    manny:turn_toward_entity(lupe)
    sleep_for(500)
    manny:walkto(cc.lupe_obj)
    manny:head_look_at(cc.lupe_obj)
    wait_for_message()
    END_CUT_SCENE()
    if not cc.met_lupe then
        Dialog:run("lu1", "dlg_lupe.lua", "grabbed")
    elseif bi.seen_kiss and not cc.talked_note then
        cc:talk_note()
    end
end
cc.set_up_actors = function() -- line 277
    lupe:default()
    lupe:put_in_set(cc)
    lupe:setpos(-2.5755, 0.4747, 0)
    lupe:setrot(0, 272.91, 0)
    lupe:set_costume("lupe_coat.cos")
    lupe:set_mumble_chore(lupe_coat_mumble)
    lupe:set_talk_chore(1, lupe_coat_stop_talk)
    lupe:set_talk_chore(2, lupe_coat_a)
    lupe:set_talk_chore(3, lupe_coat_c)
    lupe:set_talk_chore(4, lupe_coat_e)
    lupe:set_talk_chore(5, lupe_coat_f)
    lupe:set_talk_chore(6, lupe_coat_l)
    lupe:set_talk_chore(7, lupe_coat_m)
    lupe:set_talk_chore(8, lupe_coat_o)
    lupe:set_talk_chore(9, lupe_coat_t)
    lupe:set_talk_chore(10, lupe_coat_u)
    lupe:set_head(4, 5, 6, 165, 28, 80)
    lupe:set_walk_rate(0.4)
    lupe:set_turn_rate(25)
    lupe.up = FALSE
    lupe:push_costume("lupe_idles.cos")
    start_script(lupe.new_run_idle, lupe, "behind_desk")
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.7344, 3.9176, 2.405)
    SetActorShadowPlane(manny.hActor, "s_shadow")
    AddShadowPlane(manny.hActor, "s_shadow")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -0.7344, 3.9176, 2.405)
    SetActorShadowPlane(manny.hActor, "shadow_wall")
    AddShadowPlane(manny.hActor, "shadow_wall")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, 2.3344, -3.9176, 6.405)
    SetActorShadowPlane(manny.hActor, "shadow10")
    AddShadowPlane(manny.hActor, "shadow10")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, 2.3344, -3.9176, 6.405)
    SetActorShadowPlane(manny.hActor, "shadow11")
    AddShadowPlane(manny.hActor, "shadow11")
end
al1s = function() -- line 326
    remove_all_items()
    mo.scythe:get()
    mo.cards:get()
    mo.memo:get()
    mo.one_card:get()
    dom.coral:get()
    dom.mouthpiece:get()
    fe.balloon_cat:get()
    fe.balloon_dingo:get()
    fe.balloon_frost:get()
    fe.breads.bread1:get()
    tu.extinguisher:get()
    fe.balloons.balloon1:get()
    pk.balloons.balloon1:get()
    rf.eggs:get()
    ga.work_order:get()
end
al1a = function() -- line 345
    remove_all_items()
    mo.scythe:get()
    sg.heart:get()
    sp.bones.bone1:get()
    tu.extinguisher:get()
    ri.photo:get()
    re.logbook:get()
end
al2 = function() -- line 356
    remove_all_items()
    mo.scythe:get()
    cf.letters:get()
    hk.turkey_baster:get()
    si.dog_tags:get()
    ci.liqueur:get()
    sl.detector:get()
    hl.case:get()
    bi.book:get()
    ks.opener:get()
    cc.anchor_paper:get()
    cc.jacket:get()
    lx.lengua:get()
    si.photofinish:get()
    sl.key:get()
    tb.blackmail_photo:get()
    cn.ticket:get()
    cn.printer:get()
    cn.pass:get()
    dh.suitcase:get()
    hh.union_card:get()
end
al3 = function() -- line 380
    remove_all_items()
    mo.scythe:get()
    fo.hammer:get()
    mn.gun:get()
    ar.stockings:get()
    mn.chisel:get()
end
al4s = function() -- line 390
    remove_all_items()
    mo.scythe:get()
    tg.note:get()
    mk.rag:get()
    my.oily_rag:get()
    td.mug:get()
    tg.note:get()
    si.nitrogen:get()
    lm.bottle:get()
    nq.photo:get()
    nq.arm:get()
    th.coffee_pot:get()
    th.grinder:get()
    sh.remote:get()
    fi.gun:get()
    fi.sproutella:get()
end
al4d = function() -- line 409
    remove_all_items()
    mo.scythe:get()
    si.nitrogen:get()
    th.grinder:get()
    me.ticket:get()
    me.key:get()
    me.gun:get()
end
al4c = function() -- line 419
    remove_all_items()
    mo.scythe:get()
    nq.photo:get()
    nq.arm:get()
    th.coffee_pot:get()
    th.grinder:get()
    sh.remote:get()
    fi.gun:get()
    fi.sproutella:get()
    si.nitrogen:get()
end
cc.update_music_state = function(arg1) -- line 437
    if cc.lupe_music then
        return stateCC_LUPE
    elseif hl.glottis_gambling then
        return stateCF
    else
        return stateCC
    end
end
cc.enter = function(arg1) -- line 451
    cc.set_up_actors()
    if not cc.met_lupe or (bi.seen_kiss and not cc.talked_note) then
        cc.lupe_waiting = TRUE
    end
end
cc.exit = function(arg1) -- line 460
    KillActorShadows(manny.hActor)
    lupe:free()
end
cc.lupe_obj = Object:create(cc, "/cctx049/Lupe", -2.37763, 0.53503799, 0.40000001, { range = 0.80000001 })
cc.lupe_obj.use_pnt_x = -1.9974999
cc.lupe_obj.use_pnt_y = 0.287651
cc.lupe_obj.use_pnt_z = 0
cc.lupe_obj.use_rot_x = 0
cc.lupe_obj.use_rot_y = 66.624802
cc.lupe_obj.use_rot_z = 0
cc.lupe_obj.lookAt = function(arg1) -- line 480
    manny:say_line("/ccma050/")
end
cc.lupe_obj.pickUp = function(arg1) -- line 484
    manny:say_line("/ccma051/")
end
cc.lupe_obj.use = function(arg1) -- line 488
    cc.lupe_waiting = FALSE
    Dialog:run("lu1", "dlg_lupe.lua", nil)
end
cc.lupe_obj.use_key = function(arg1) -- line 493
    lupe:kill_idle(lupe_idles_forward_to_talk)
    if cc.talked_note then
        lupe:say_line("/cclu052/")
    else
        START_CUT_SCENE()
        lupe:say_line("/cclu053/")
        wait_for_message()
        lupe:say_line("/cclu054/")
        END_CUT_SCENE()
    end
    start_script(lupe.new_run_idle, lupe, "main_pose")
end
cc.lupe_obj.use_lengua = function(arg1) -- line 507
    cc:get_paper()
end
cc.lupe_obj.use_paper = function(arg1) -- line 511
    START_CUT_SCENE()
    lupe:kill_idle(lupe_idles_forward_to_talk)
    lupe:say_line("/cclu055/")
    wait_for_message()
    lupe:say_line("/cclu056/")
    END_CUT_SCENE()
    start_script(lupe.new_run_idle, lupe, "main_pose")
end
cc.lupe_obj.use_jacket = function(arg1) -- line 522
    if cc.jacket.searched then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        lupe:kill_idle(lupe_idles_forward_to_talk)
        manny:say_line("/ccma057/")
        wait_for_message()
        lupe:say_line("/cclu058/")
        lupe:wait_for_chore()
        lupe:fade_out_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
        sleep_for(500)
        lupe:wait_for_message()
        lupe:play_chore(lupe_coat_get_coat, "lupe_coat.cos")
        manny:push_costume("ma_check_coat.cos")
        manny:stop_chore(mc_hold_coat, manny.base_costume)
        manny.is_holding = nil
        manny.hold_chore = nil
        manny:play_chore(ma_check_coat_give_coat)
        sleep_for(750)
        lupe:say_line("/cclu059/")
        lupe:wait_for_chore()
        lupe:wait_for_message()
        lupe:stop_chore(lupe_coat_get_coat, "lupe_coat.cos")
        lupe:fade_in_chore(lupe_idles_main_pose, "lupe_idles.cos", 500)
        sleep_for(500)
        lupe:play_chore(lupe_idles_jump_back, "lupe_idles.cos")
        manny:say_line("/ccma060/")
        manny:wait_for_chore()
        manny:pop_costume()
        wait_for_message()
        lupe:say_line("/cclu061/")
        wait_for_message()
        manny:say_line("/ccma062/")
        wait_for_message()
        lupe:say_line("/cclu063/")
        lupe:wait_for_message()
        lupe:say_line("/cclu064/")
        wait_for_message()
        manny:say_line("/ccma065/")
        END_CUT_SCENE()
        cc.jacket:put_in_limbo()
        start_script(lupe.new_run_idle, lupe, "behind_desk")
    else
        manny:say_line("/ccma066/")
    end
end
cc.jacket = Object:create(cc, "/cctx067/jacket", 0, 0, 0, { range = 0 })
cc.jacket.folded = FALSE
cc.jacket.wav = "getrag.wav"
cc.jacket.lookAt = function(arg1) -- line 578
    manny:say_line("/ccma068/")
    wait_for_message()
    if not arg1.searched then
        START_CUT_SCENE()
        manny:say_line("/ccma069/")
        wait_for_message()
        manny:say_line("/ccma070/")
        END_CUT_SCENE()
        arg1:use()
    end
end
cc.jacket.default_response = function(arg1) -- line 591
    manny:say_line("/ccma071/")
end
cc.jacket.use = function(arg1) -- line 595
    local local1 = { x = 0, y = -0.043000001, z = 0 }
    local local2 = { }
    local local3 = { }
    local local4 = { }
    if not arg1.searched then
        arg1.searched = TRUE
        START_CUT_SCENE()
        if system.currentSet == cafe_inv then
            close_inventory()
        end
        cc.anchor_paper:get()
        manny:stop_chore(mc_hold, "mc.cos")
        manny:stop_chore(manny.hold_chore, "mc.cos")
        manny:push_costume("ma_check_coat.cos")
        manny:play_chore(ma_check_coat_2nd_search)
        sleep_for(5500)
        manny:wait_for_message()
        manny:say_line("/ccma072/")
        manny:wait_for_chore()
        manny:pop_costume()
        manny:play_chore_looping(manny.hold_chore, "mc.cos")
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = cc.anchor_paper
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
        cc.anchor_paper:lookAt()
    else
        manny:say_line("/ccma073/")
    end
end
cc.anchor_paper = Object:create(cc, "/cctx074/slip of paper", 0, 0, 0, { range = 0 })
cc.anchor_paper.string_name = "paper"
cc.anchor_paper.wav = "getWrkOr.wav"
cc.anchor_paper.lookAt = function(arg1) -- line 637
    manny:say_line("/ccma075/")
    wait_for_message()
    manny:say_line("/ccma076/")
end
cc.anchor_paper.use = function(arg1) -- line 643
    manny:say_line("/ccma077/")
end
cc.anchor_paper.use = cc.anchor_paper.lookAt
cc.anchor_paper.default_response = function(arg1) -- line 649
    system.default_response("shed light")
end
cc.distraction1 = Object:create(cc, "/cctx078/distraction", -1.90763, 0.405038, 0.60000002, { range = 0 })
cc.distraction2 = Object:create(cc, "/cctx079/distraction", -2.3076301, 0.105038, 0.60000002, { range = 0 })
cc.ce_door = Object:create(cc, "/cctx080/door", -1.55898, -0.098755002, 0.40000001, { range = 0 })
cc.ce_door.use_pnt_x = -1.4007
cc.ce_door.use_pnt_y = 0.065954097
cc.ce_door.use_pnt_z = 0
cc.ce_door.use_rot_x = 0
cc.ce_door.use_rot_y = 169.70599
cc.ce_door.use_rot_z = 0
cc.ce_door.out_pnt_x = -1.44437
cc.ce_door.out_pnt_y = -0.174512
cc.ce_door.out_pnt_z = 0
cc.ce_door.out_rot_x = 0
cc.ce_door.out_rot_y = 169.70599
cc.ce_door.out_rot_z = 0
cc.ce_box = cc.ce_door
cc.ce_door.walkOut = function(arg1) -- line 680
    if cc.lupe_waiting then
        cc.grab_manny()
    else
        ce:come_out_door(ce.cc_door)
    end
end
cc.ci_door = Object:create(cc, "/cctx081/door", -0.15898301, 0.50124502, 0.40000001, { range = 0 })
cc.ci_door.use_pnt_x = -0.502253
cc.ci_door.use_pnt_y = 0.61703002
cc.ci_door.use_pnt_z = 0
cc.ci_door.use_rot_x = 0
cc.ci_door.use_rot_y = -95.008003
cc.ci_door.use_rot_z = 0
cc.ci_door.out_pnt_x = -0.175
cc.ci_door.out_pnt_y = 0.588359
cc.ci_door.out_pnt_z = 0
cc.ci_door.out_rot_x = 0
cc.ci_door.out_rot_y = -95.008003
cc.ci_door.out_rot_z = 0
cc.ci_box = cc.ci_door
cc.ci_door.walkOut = function(arg1) -- line 706
    ci:come_out_door(ci.cc_door)
end
cc.cf_door = Object:create(cc, "/cctx148/door", -1.925, 1.19311, 0.69999999, { range = 0 })
cc.cf_door.use_pnt_x = -1.80618
cc.cf_door.use_pnt_y = 1.1937701
cc.cf_door.use_pnt_z = 0.69024402
cc.cf_door.use_rot_x = 0
cc.cf_door.use_rot_y = 90.603996
cc.cf_door.use_rot_z = 0
cc.cf_door.out_pnt_x = -1.925
cc.cf_door.out_pnt_y = 1.1924
cc.cf_door.out_pnt_z = 0.69999999
cc.cf_door.out_rot_x = 0
cc.cf_door.out_rot_y = 90.603996
cc.cf_door.out_rot_z = 0
cc.cf_box = cc.cf_door
cc.cf_door.lookAt = function(arg1) -- line 728
    manny:say_line("/ccma083/")
end
cc.cf_door.walkOut = function(arg1) -- line 732
    cf:come_out_door(cf.cc_door)
end
