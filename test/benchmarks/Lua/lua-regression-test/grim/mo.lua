CheckFirstTime("mo.lua")
dofile("ma_note_type.lua")
dofile("mo_tube.lua")
dofile("meche_sit.lua")
dofile("meche_idle_table.lua")
dofile("ma_scythe.lua")
dofile("mo_computer.lua")
dofile("mo_tube_balloon.lua")
mo = Set:create("mo.set", "Manny's Office", { mo_ddtws = 0, mo_ddtws2 = 0, mo_winws = 1, mo_winws2 = 1, mo_comin = 2, mo_cornr = 3, overhead = 4, mo_mcecu = 5, mo_mnycu = 6 })
mo.shrinkable = 0.02
tb = function() -- line 25
    mo.tube.contains = nil
    gb()
    pk:fill_balloon(fe.balloons.balloon1, 1)
    pk:fill_balloon(fe.balloons.balloon2, 1)
    pk:fill_balloon(fe.balloons.balloon3, 1)
    pk:fill_balloon(fe.balloons.balloon4, 2)
    pk:fill_balloon(fe.balloons.balloon5, 2)
end
mo.set_up_meche = function(arg1) -- line 35
    meche:put_in_set(mo)
    meche:set_costume("meche_sit.cos")
    meche:set_mumble_chore(meche_sit_mumble)
    meche:set_talk_chore(1, meche_sit_no_talk)
    meche:set_talk_chore(2, meche_sit_a)
    meche:set_talk_chore(3, meche_sit_c)
    meche:set_talk_chore(4, meche_sit_e)
    meche:set_talk_chore(5, meche_sit_f)
    meche:set_talk_chore(6, meche_sit_l)
    meche:set_talk_chore(7, meche_sit_m)
    meche:set_talk_chore(8, meche_sit_o)
    meche:set_talk_chore(9, meche_sit_t)
    meche:set_talk_chore(10, meche_sit_u)
    meche:setpos(1.09676, 1.50683, 0.01594)
    meche:setrot(0, 47.074, 0)
    meche:set_head(3, 4, 5, 165, 28, 80)
    meche:set_look_rate(200)
    single_start_script(meche.new_run_idle, meche, "base")
    single_start_script(mo.meche_looks_at_manny_when_he_talks)
end
mo.meche_looks_at_manny_when_he_talks = function(arg1) -- line 57
    local local1 = { }
    while system.currentSet == mo do
        while manny:is_speaking() do
            local1 = manny:getpos()
            local1.z = local1.z + 0.40000001
            meche:head_look_at_point(local1)
            break_here()
        end
        while not manny:is_speaking() do
            meche:head_look_at(nil)
            break_here()
        end
    end
end
tm = function() -- line 78
    mo:set_up_meche()
    mo:current_setup(mo_mcecu)
end
mo.manny_two_shot_mark = function(arg1) -- line 83
    manny:setpos(0.607, 2.041, 0)
    manny:setrot(0, 222.21, 0)
end
mo.manny_meche_dialog = function(arg1) -- line 88
    mo:switch_to_set()
    mo:set_up_meche()
    meche:play_chore(meche_sit_in_hold)
    manny:put_in_set(mo)
    mo.meche_obj:make_touchable()
    Dialog:run("me1", "dlg_meche.lua")
end
mo.enter = function(arg1) -- line 104
    if mo.tube.contains then
        NewObjectState(mo_ddtws, OBJSTATE_STATE, "mo_tube_can_comp.bm", "mo_tube_can_comp.zbm", TRUE)
        NewObjectState(mo_ddtws, OBJSTATE_STATE, "mo_can_exit.bm", "mo_can_exit.zbm", TRUE)
        NewObjectState(mo_ddtws, OBJSTATE_OVERLAY, "mo_tube_wo_canister.bm", nil, TRUE)
        mo.tube:set_object_state("mo_tube.cos")
        if not canister_actor then
            canister_actor = Actor:create(nil, nil, nil, "canister")
        end
        canister_actor:put_in_set(mo)
        canister_actor:set_costume("canister.cos")
        canister_actor:setrot(99, 270, 0)
        canister_actor:setpos({ x = 0.725, y = 2.27, z = 0.226 })
        canister_actor:set_visibility(FALSE)
        SendObjectToFront(exit_can)
    else
        mo:add_object_state(mo_ddtws, "mo_tube_balloon.bm", "mo_tube_balloon.zbm", OBJSTATE_STATE, TRUE)
        mo:add_object_state(mo_ddtws, "mo_tube_wo_canister.bm", nil, OBJSTATE_OVERLAY, TRUE)
        mo.tube:set_object_state("mo_tube_balloon.cos")
    end
    if mo.tube.contains then
        mo.tube.interest_actor:complete_chore(mo_tube_set_closed_w_can)
    elseif mo.tube:is_open() then
        mo.tube.interest_actor:complete_chore(mo_tube_open_wo_can)
    else
        mo.tube.interest_actor:complete_chore(mo_tube_close_wo_can)
    end
    mo:add_object_state(mo_comin, "mo_monitor_topview.bm", nil, OBJSTATE_UNDERLAY, TRUE)
    mo.computer:set_object_state("mo_computer.cos")
    mo:add_object_state(mo_ddtws, "mo_door_open_comp.bm", nil, OBJSTATE_UNDERLAY, TRUE)
    mo.ha_door:set_object_state("mo_ha_door.cos")
    if mo.cards.owner == IN_THE_ROOM then
        mo.cards:set_object_state("deck_o_cards.cos")
        mo.cards:play_chore(0)
        mo.cards.interest_actor:setrot(0, 0, 90)
    end
    LoadCostume("ma_note_type.cos")
    if time_to_run_intro then
        time_to_run_intro = FALSE
        start_script(cut_scene.intro)
    end
    SetShadowColor(10, 10, 18)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 1000, 4000, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow2")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -100, -1400, 6000)
    SetActorShadowPlane(manny.hActor, "shadow3")
    AddShadowPlane(manny.hActor, "shadow3")
    if reaped_meche then
        mo:set_up_meche()
    end
end
mo.camerachange = function(arg1, arg2, arg3) -- line 170
    if arg3 == mo_mcecu then
        mo.hiding_manny = TRUE
        manny:set_visibility(FALSE)
    elseif mo.hiding_manny then
        manny:set_visibility(TRUE)
    end
end
mo.exit = function(arg1) -- line 185
    stop_script(mo.meche_looks_at_manny_when_he_talks)
    meche:free()
    KillActorShadows(manny.hActor)
end
mo.scythe = Object:create(mo, "/motx068/scythe", 0, 0, 0, { range = 0 })
mo.scythe.in = inventory_scythe_in
mo.scythe.out = inventory_scythe_out
mo.scythe.shrink_radius = 0.2
mo.scythe.free = function(arg1) -- line 205
    arg1.owner = IN_LIMBO
    if manny.is_holding == mo.scythe then
        manny.is_holding = nil
    end
end
mo.scythe.get = function(arg1) -- line 212
    if not Inventory.unordered_inventory_table[arg1] then
        Inventory:add_item_to_inventory(mo.scythe)
    else
        arg1.owner = manny
    end
end
mo.scythe.put_in_limbo = mo.scythe.free
mo.scythe.lookAt = function(arg1) -- line 222
    manny:examine_scythe()
end
mo.scythe.use = mo.scythe.lookAt
mo.scythe.default_response = function(arg1, arg2) -- line 228
    manny:default_scythe_response(arg2)
end
mo.memo = Object:create(mo, "/motx071/memo", 0, 0, 0, { range = 0 })
mo.memo.wav = "getWrkOr.wav"
mo.memo.lookAt = function(arg1) -- line 236
    START_CUT_SCENE()
    manny:say_line("/moma072/")
    wait_for_message()
    END_CUT_SCENE()
    if not arg1.used then
        arg1:use()
    end
end
mo.memo.use = function(arg1) -- line 244
    arg1.used = TRUE
    START_CUT_SCENE("no head")
    manny:head_look_at(nil)
    set_override(mo.memo.use_override)
    eva:say_line("/moev073/")
    eva:wait_for_message()
    copal:say_line("/moco074/")
    copal:wait_for_message()
    copal:say_line("/moco075/")
    copal:wait_for_message()
    copal:say_line("/moco076/")
    copal:wait_for_message()
    copal:say_line("/moco078/")
    copal:wait_for_message()
    manny:play_chore(ma_note_type_hide_note, "ma_note_type.cos")
    manny:play_chore_looping(ms_activate_memo, "ms.cos")
    FadeInChore(manny.hActor, "ms.cos", ms_hold, 700)
    sleep_for(700)
    kill_override()
    manny:pop_costume()
    manny.hold_chore = ms_activate_memo
    manny.is_holding = mo.memo
    put_away_held_item()
    END_CUT_SCENE()
    manny:say_line("/moma080/")
end
mo.memo.use_override = function(arg1) -- line 279
    kill_override()
    shut_up_everybody()
    manny:pop_costume()
end
mo.memo.default_response = function(arg1) -- line 286
    manny:say_line("/moma082/")
end
mo.tube = Object:create(mo, "/motx083/tube", 0.72940397, 2.2678001, 0.25999999, { range = 0.64032501 })
mo.tube.contains = mo.memo
mo.tube.use_pnt_x = 0.70168
mo.tube.use_pnt_y = 2.1670899
mo.tube.use_pnt_z = 0
mo.tube.use_rot_x = 0
mo.tube.use_rot_y = 371.3446
mo.tube.use_rot_z = 0
mo.tube.lookAt = function(arg1) -- line 304
    if arg1.contains then
        manny:say_line("/moma084/")
    elseif tu.chem_state == "both chem" then
        arg1:no_pressure()
    else
        manny:say_line("/moma085/")
    end
end
mo.tube.use = function(arg1) -- line 316
    manny:walkto_object(arg1)
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
mo.tube.pickUp = mo.tube.use
mo.tube.open = function(arg1) -- line 327
    START_CUT_SCENE("no head")
    manny:walkto_object(arg1)
    if not arg1.contains then
        manny:play_chore(ms_reach_med, "ms.cos")
        sleep_for(300)
        arg1:play_chore(mo_tube_open_wo_can)
        start_sfx("tubOpen.wav")
        arg1:wait_for_chore()
        Object.open(arg1)
    else
        manny:walkto(0.74168, 2.09709, 0, 0, 11.3446, 0)
        manny:wait_for_actor()
        manny:push_costume("ma_note_type.cos")
        arg1:play_chore(mo_tube_open_w_can)
        canister_actor:set_visibility(TRUE)
        manny:play_chore(ma_note_type_get_note, "ma_note_type.cos")
        ma_note_type_event = FALSE
        repeat
            break_here()
        until ma_note_type_event
        canister_actor:set_visibility(FALSE)
        sleep_for(500)
        ma_note_type_event = FALSE
        repeat
            break_here()
        until ma_note_type_event
        canister_actor:set_visibility(TRUE)
        sleep_for(200)
        arg1:play_chore(mo_tube_close_can_exit)
        manny:wait_for_chore()
        arg1:wait_for_chore()
        arg1.interest_actor:complete_chore(mo_tube_close_wo_can)
        canister_actor:set_visibility(FALSE)
        Object.close(arg1)
        mo:add_object_state(mo_ddtws, "mo_tube_balloon.bm", "mo_tube_balloon.zbm", OBJSTATE_STATE, TRUE)
        mo:add_object_state(mo_ddtws, "mo_tube_wo_canister.bm", nil, OBJSTATE_OVERLAY, TRUE)
        mo.tube.interest_actor:set_costume("mo_tube_balloon.cos")
        arg1.interest_actor:complete_chore(mo_tube_close_wo_can)
        arg1.contains:get()
        arg1.contains = nil
        mo.memo:lookAt()
    end
    END_CUT_SCENE()
end
mo.tube.close = function(arg1) -- line 385
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:play_chore(ms_reach_med, "ms.cos")
    sleep_for(300)
    Object.close(arg1)
    arg1:play_chore(mo_tube_close_wo_can)
    start_sfx("tubClose.wav")
    arg1:wait_for_chore()
    END_CUT_SCENE()
end
mo.tube.no_pressure = function(arg1) -- line 397
    START_CUT_SCENE()
    manny:say_line("/moma086/")
    wait_for_message()
    manny:say_line("/moma087/")
    END_CUT_SCENE()
end
mo.tube.use_full_balloon = function(arg1, arg2) -- line 405
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if arg1.contains then
        manny:say_line("/moma088/")
    else
        if not arg1:is_open() then
            arg1:open()
            wait_for_message()
        end
        if arg1:is_open() then
            if tu.chem_state == "both chem" then
                arg1:no_pressure()
            else
                manny:walkto(0.748033, 2.08715, 0, 0, 19.2964, 0)
                manny:wait_for_actor()
                manny.is_holding = nil
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny.hold_chore = nil
                manny:stop_chore(ms_hold, "ms.cos")
                manny:push_costume("ma_stuff_balloon.cos")
                if arg2.chem == 1 then
                    manny:play_chore(1)
                else
                    manny:play_chore(0)
                end
                mo.tube:play_chore(mo_tube_balloon_open_waiting)
                manny:wait_for_chore()
                manny:pop_costume()
                arg1.interest_actor:complete_chore(mo_tube_open_wo_can)
                if not mo.tube.stuffed then
                    mo.tube.stuffed = TRUE
                    manny:say_line("/moma089/")
                    wait_for_message()
                end
                tu:send_balloon(arg2)
            end
        end
    end
    END_CUT_SCENE()
end
mo.tube.use_bread = function(arg1, arg2) -- line 450
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    if arg1.contains then
        manny:say_line("/moma088/")
    else
        if not arg1:is_open() then
            arg1:open()
            wait_for_message()
        end
        if arg1:is_open() then
            if tu.chem_state == "both chem" then
                arg1:no_pressure()
            else
                arg2:free()
                arg2.owner = fe.basket
                manny:walkto(0.748033, 2.08715, 0, 0, 19.2964, 0)
                manny:wait_for_actor()
                manny.is_holding = nil
                manny:stop_chore(manny.hold_chore, "ms.cos")
                manny.hold_chore = nil
                manny:stop_chore(ms_hold, "ms.cos")
                manny:push_costume("ma_stuff_balloon.cos")
                manny:play_chore(2)
                mo.tube:play_chore(mo_tube_balloon_open_waiting)
                manny:wait_for_chore()
                manny:pop_costume()
                arg1.interest_actor:complete_chore(mo_tube_open_wo_can)
                if not mo.tube.stuffed then
                    mo.tube.stuffed = TRUE
                    manny:say_line("/moma089/")
                    wait_for_message()
                end
                tu:send_bread(which)
            end
        end
    end
    END_CUT_SCENE()
end
mo.books = Object:create(mo, "/motx090/books", 0.26280001, 1.015, 0.30000001, { range = 0.5 })
mo.books.use_pnt_x = 0.40799999
mo.books.use_pnt_y = 0.79699999
mo.books.use_pnt_z = 0
mo.books.use_rot_x = 0
mo.books.use_rot_y = -349.31201
mo.books.use_rot_z = 0
mo.books.lookAt = function(arg1) -- line 501
    START_CUT_SCENE()
    manny:say_line("/moma091/")
    wait_for_message()
    manny:say_line("/moma092/")
    END_CUT_SCENE()
end
mo.books.use = function(arg1) -- line 512
    manny:say_line("/moma093/")
end
mo.books.pickUp = mo.books.use
mo.cards = Object:create(mo, "/motx094/deck of playing cards", 0.24644201, 0.65860498, 0.25999999, { range = 0.5 })
mo.cards.string_name = "cards"
mo.cards.use_pnt_x = 0.426442
mo.cards.use_pnt_y = 0.578605
mo.cards.use_pnt_z = 0
mo.cards.use_rot_x = 0
mo.cards.use_rot_y = 92.764397
mo.cards.use_rot_z = 0
mo.cards.lookAt = function(arg1) -- line 530
    if arg1.owner == manny then
        START_CUT_SCENE()
        manny:say_line("/moma095/")
        wait_for_message()
        manny:say_line("/moma096/")
        END_CUT_SCENE()
    else
        manny:say_line("/moma097/")
    end
end
mo.cards.pickUp = function(arg1) -- line 542
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:default("suit")
    manny:push_costume("ma_grab_deck.cos")
    manny:play_chore(0)
    sleep_for(737)
    mo.cards:free_object_state()
    manny:wait_for_chore(0, "ma_grab_deck.cos")
    manny:pop_costume()
    arg1:get()
    manny.is_holding = arg1
    manny:play_chore_looping(ms_hold_deck, "ms.cos")
    manny:say_line("/moma098/")
    manny:wait_for_message()
    END_CUT_SCENE()
end
mo.cards.switch_to_one = function(arg1) -- line 561
    if mo.one_card.owner == manny then
        START_CUT_SCENE()
        shrinkBoxesEnabled = FALSE
        open_inventory(TRUE, TRUE)
        manny.is_holding = mo.one_card
        close_inventory()
        if GlobalShrinkEnabled then
            shrinkBoxesEnabled = TRUE
            shrink_box_toggle()
        end
        END_CUT_SCENE()
    else
        mo.cards:use()
    end
    wait_for_message()
end
mo.cards.use = function(arg1) -- line 579
    if arg1.owner == manny then
        manny:wait_for_message()
        if mo.one_card.owner == manny then
            manny:say_line("/moma099/")
        else
            START_CUT_SCENE()
            shrinkBoxesEnabled = FALSE
            open_inventory(TRUE, TRUE)
            mo.one_card:get()
            manny.is_holding = mo.one_card
            close_inventory()
            if GlobalShrinkEnabled then
                shrinkBoxesEnabled = TRUE
                shrink_box_toggle()
            end
            END_CUT_SCENE()
        end
    else
        arg1:pickUp()
    end
end
mo.cards.default_response = function(arg1) -- line 602
    manny:say_line("/moma100/")
end
mo.one_card = Object:create(mo, "/motx101/card", 0, 0, 0, { range = 0 })
mo.one_card.string_name = "card"
mo.one_card.wav = "getCard.wav"
mo.one_card.deal_count = 0
mo.one_card.get = function(arg1) -- line 613
    arg1.punched = FALSE
    arg1.parent.get(arg1)
    mo.one_card.deal_count = mo.one_card.deal_count + 1
    if mo.one_card.deal_count == 53 then
        manny:say_line("/moma128/")
    end
end
mo.one_card.picklock = function(arg1) -- line 623
    manny:say_line("/moma102/")
end
mo.one_card.lookAt = function(arg1) -- line 627
    if arg1.punched then
        manny:say_line("/moma103/")
    else
        manny:say_line("/moma104/")
    end
end
mo.one_card.use = function(arg1) -- line 635
    manny:say_line("/moma105/")
end
mo.one_card.default_response = function(arg1) -- line 639
    manny:say_line("/moma106/")
end
mo.computer = Object:create(mo, "/motx107/computer", 0.205, 1.8784, 0.34, { range = 0.69999999 })
mo.computer.use_pnt_x = 0.5
mo.computer.use_pnt_y = 1.975
mo.computer.use_pnt_z = 0
mo.computer.use_rot_x = 0
mo.computer.use_rot_y = 120.761
mo.computer.use_rot_z = 0
mo.computer.lookAt = function(arg1) -- line 659
    manny:say_line("/moma108/")
end
mo.computer.use = function(arg1) -- line 663
    enable_head_control(FALSE)
    START_CUT_SCENE()
    set_override(mo.computer.override_use, mo.computer)
    cameraman_disabled = TRUE
    manny:walkto_object(arg1)
    manny:ignore_boxes()
    manny:setpos(0.45, 1.875, 0)
    manny:setrot(0, 87.7538, 0)
    mo.computer:play_chore(mo_computer_static)
    mo:current_setup(2)
    manny:push_costume("ma_note_type.cos")
    manny:play_chore(ma_note_type_to_type, "ma_note_type.cos")
    manny:head_look_at(arg1)
    manny:wait_for_chore()
    manny:play_chore(ma_note_type_type_loop, "ma_note_type.cos")
    start_sfx("keyboard.imu")
    sleep_for(100)
    mo.computer:play_chore(mo_computer_scroll)
    start_sfx("txtScrl3.WAV")
    wait_for_sound("txtScrl3.WAV")
    start_sfx("txtScrl2.WAV")
    manny:wait_for_chore()
    stop_sound("keyboard.imu")
    start_sfx("compbeep.wav")
    manny:head_look_at_point(0.2, 1.875, 0.47, 90)
    sleep_for(750)
    if reaped_bruno then
        if reaped_meche then
            manny:say_line("/moma109/")
            manny:wait_for_message()
            manny:say_line("/moma110/")
        else
            manny:say_line("/moma111/")
        end
    else
        manny:say_line("/moma112/")
        manny:wait_for_message()
        manny:head_look_at(arg1)
        manny:say_line("/moma113/")
    end
    manny:play_chore(ma_note_type_type_loop, "ma_note_type.cos")
    start_sfx("keyboard.imu")
    mo.computer:play_chore(mo_computer_scroll)
    start_sfx("txtScrl3.WAV")
    wait_for_sound("txtScrl3.WAV")
    start_sfx("txtScrl2.WAV")
    manny:wait_for_chore()
    stop_sound("keyboard.imu")
    if reaped_bruno then
        manny:head_look_at(arg1)
    end
    manny:play_chore(ma_note_type_type_to_home, "ma_note_type.cos")
    manny:wait_for_chore()
    cameraman_disabled = FALSE
    manny:follow_boxes()
    manny:setpos(0.5, 1.975, 0)
    manny:setrot(0, 120.761, 0)
    manny:set_look_rate(Actor.default_look_rate)
    manny:pop_costume()
    mo:current_setup(mo_ddtws)
    END_CUT_SCENE()
    enable_head_control(TRUE)
end
mo.computer.override_use = function(arg1, arg2) -- line 737
    kill_override()
    manny:default()
    manny:set_look_rate(Actor.default_look_rate)
    cameraman_disabled = FALSE
    enable_head_control(TRUE)
    manny:follow_boxes()
    manny:setpos(mo.computer.use_pnt_x, mo.computer.use_pnt_y, mo.computer_use_pnt_z)
    manny:setrot(mo.computer.use_rot_x, mo.computer.use_rot_y, mo.computer_use_rot_z)
    mo:current_setup(mo_ddtws)
    stop_sound("keyboard.imu")
    stop_sound("txtScrl3.WAV")
    stop_sound("txtScrl2.WAV")
    stop_sound("compbeep.wav")
end
mo.computer.pickUp = function(arg1) -- line 755
    system.default_response("not portable")
end
mo.file_cabinet = Object:create(mo, "/motx114/file cabinet", 1.5994, 1.7278, 0.43000001, { range = 0.5 })
mo.file_cabinet.use_pnt_x = 1.49
mo.file_cabinet.use_pnt_y = 1.72781
mo.file_cabinet.use_pnt_z = 0
mo.file_cabinet.use_rot_x = 0
mo.file_cabinet.use_rot_y = 1350.91
mo.file_cabinet.use_rot_z = 0
mo.file_cabinet.lookAt = function(arg1) -- line 769
    START_CUT_SCENE()
    manny:say_line("/moma115/")
    wait_for_message()
    manny:say_line("/moma116/")
    END_CUT_SCENE()
end
mo.file_cabinet.use = function(arg1) -- line 777
    manny:say_line("/moma117/")
end
mo.file_closet = Object:create(mo, "/motx118/closet", 1.5994, 1.3378, 0.43000001, { range = 0.5 })
mo.file_closet.use_pnt_x = 1.49
mo.file_closet.use_pnt_y = 1.35
mo.file_closet.use_pnt_z = 0
mo.file_closet.use_rot_x = 0
mo.file_closet.use_rot_y = 990.60199
mo.file_closet.use_rot_z = 0
mo.file_closet.lookAt = function(arg1) -- line 790
    manny:say_line("/moma119/")
end
mo.file_closet.use = function(arg1) -- line 794
    START_CUT_SCENE()
    manny:say_line("/moma120/")
    wait_for_message()
    manny:say_line("/moma121/")
    END_CUT_SCENE()
end
mo.meche_obj = Object:create(mo, "/motx122/Meche", 1.09294, 1.53775, 0.391, { range = 0.69999999 })
mo.meche_obj.use_pnt_x = 0.60699999
mo.meche_obj.use_pnt_y = 2.0409999
mo.meche_obj.use_pnt_z = 0
mo.meche_obj.use_rot_x = 0
mo.meche_obj.use_rot_y = 222.21001
mo.meche_obj.use_rot_z = 0
mo.meche_obj.lookAt = function(arg1) -- line 812
    manny:say_line("/moma123/")
end
mo.meche_obj.pickUp = function(arg1) -- line 816
    manny:say_line("/moma124/")
end
mo.meche_obj.use = function(arg1) -- line 820
    if me1.talked_out then
        START_CUT_SCENE()
        manny:say_line("/moma013/")
        sleep_for(1550)
        manny:twist_head_gesture()
        wait_for_message()
        meche:say_line("/momc014/")
        END_CUT_SCENE()
    else
        mo:manny_meche_dialog()
    end
end
mo.meche_obj:make_untouchable()
mo.ha_door = Object:create(mo, "/motx125/door", 1.4694, -0.00220397, 0.51999998, { range = 1.05431 })
mo.mo_ha_box = mo.ha_door
mo.ha_door.use_pnt_x = 1.399
mo.ha_door.use_pnt_y = 0.28099999
mo.ha_door.use_pnt_z = 0
mo.ha_door.use_rot_x = 0
mo.ha_door.use_rot_y = -179.80099
mo.ha_door.use_rot_z = 0
mo.ha_door.out_pnt_x = 1.40488
mo.ha_door.out_pnt_y = 0.035943899
mo.ha_door.out_pnt_z = 0
mo.ha_door.out_rot_x = 0
mo.ha_door.out_rot_y = 185.092
mo.ha_door.out_rot_z = 0
mo.ha_door.walkOut = function(arg1) -- line 860
    START_CUT_SCENE()
    if not ha.mo_door:is_open() then
        ha.mo_door:open(TRUE)
    end
    manny:walkto_object(arg1)
    if manny.is_holding then
        put_away_held_item()
    end
    manny:play_chore(ms_reach_med, "ms.cos")
    sleep_for(500)
    start_sfx("DorOfOp.WAV")
    arg1:play_chore(0)
    sleep_for(500)
    manny:walkto_object(arg1, TRUE)
    END_CUT_SCENE()
    if reaped_meche and not mo.meche_sad then
        START_CUT_SCENE()
        mo.meche_sad = TRUE
        manny:put_in_set(nil)
        sleep_for(1000)
        meche:say_line("/momc126/")
        END_CUT_SCENE()
    end
    ha:come_out_door(ha.mo_door)
    ha:current_setup(ha_intls)
end
mo.ha_door.lookAt = function(arg1) -- line 890
    manny:say_line("/hama160/")
end
