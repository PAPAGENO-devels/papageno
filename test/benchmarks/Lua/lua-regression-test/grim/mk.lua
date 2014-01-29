CheckFirstTime("mk.lua")
dofile("mug_hook.lua")
dofile("msb_rag_cup.lua")
dofile("mm_extinguish.lua")
dofile("mug_rack.lua")
dofile("mk_drawer.lua")
dofile("msb_open_drawer.lua")
mk = Set:create("mk.set", "mechanics kitchen", { mk_intws = 0, mk_ovrhd = 1 })
mk.shrinkable = 0.03
mk.fire_actor = Actor:create(nil, nil, nil, "toaster fire")
mk.fire_actor.default = function(arg1) -- line 45
    arg1:set_costume("toaster_fire.cos")
    arg1:put_in_set(mk)
    arg1:setpos(0.265, -0.015, 0.3)
    arg1:setrot(0, 33.2316, 0)
end
mk.fire_actor.start = function(arg1) -- line 52
    local local1 = 0.5
    local local2 = 0.0099999998
    arg1:default()
    arg1:play_chore_looping(0)
    while local1 < 1 do
        SetActorScale(arg1.hActor, local1)
        break_here()
        local1 = local1 + local2
        local2 = local2 + 0.02
    end
    SetActorScale(arg1.hActor, 1)
end
mk.fire_actor.stop = function(arg1) -- line 67
    local local1 = 1
    local local2 = 0.0099999998
    while local1 > 0.5 do
        SetActorScale(arg1.hActor, local1)
        break_here()
        local1 = local1 - local2
        local2 = local2 + 0.02
    end
    arg1:stop_chore(0)
    arg1:play_chore(1)
    arg1:put_in_set(nil)
end
mk.mug_actor = Actor:create(nil, nil, nil, "mug")
mk.mug_actor.default = function(arg1) -- line 85
    arg1:set_costume("mug_hook.cos")
    arg1:put_in_set(mk)
    arg1:setpos(0.48191, 0.00755, 0.39793)
    arg1:setrot(0, 180, 0)
    arg1:show(FALSE)
end
mk.mug_actor.show = function(arg1, arg2) -- line 93
    if arg2 then
        arg1:complete_chore(mug_hook_mug_hold)
    else
        arg1:complete_chore(mug_hook_mug_hide)
    end
end
mk.mug_actor.hook = function(arg1) -- line 101
    arg1:play_chore(mug_hook_mug_hooked)
    arg1:wait_for_chore(mug_hook_mug_hooked)
    arg1:play_chore(mug_hook_mug_hold)
end
mk.mug_rack_actor = Actor:create(nil, nil, nil, "mug rack")
mk.mug_rack_actor.default = function(arg1) -- line 110
    arg1:set_costume("mug_rack.cos")
    arg1:put_in_set(mk)
    arg1:setpos(0.493555, 0.00638961, 0.3067)
    arg1:setrot(0, 180, 0)
    if mk.mug_rack.is_upright then
        arg1:play_chore(mug_rack_upright)
    else
        arg1:play_chore(mug_rack_down)
    end
end
mk.toast = function(arg1, arg2) -- line 124
    if manny:walkto_object(mk.toaster) then
        START_CUT_SCENE()
        manny:clear_hands()
        manny:play_chore(msb_hand_on_obj, "msb.cos")
        sleep_for(500)
        start_sfx("mkTostDn.wav")
        manny:wait_for_chore(msb_hand_on_obj, "msb.cos")
        manny:play_chore(msb_hand_off_obj, "msb.cos")
        manny:wait_for_chore(msb_hand_off_obj, "msb.cos")
        if arg2 then
            manny.is_holding = arg2
            shrinkBoxesEnabled = FALSE
            close_inventory(FALSE)
            manny:walkto(0.38545, -0.30193, 0, 0, 69.8924, 0)
            manny:wait_for_actor()
            manny:stop_chore(msb_hold, "msb.cos")
            manny:push_costume("msb_rag_cup.cos")
            manny:play_chore(msb_rag_cup_stuff_rag, "msb_rag_cup.cos")
            sleep_for(1000)
            start_sfx("mkRagStf.WAV")
            sleep_for(900)
            manny:stop_chore(msb_activate_rag, "msb.cos")
            manny:stop_chore(msb_activate_oily_rag, "msb.cos")
            manny:wait_for_chore(msb_rag_cup_stuff_rag, "msb_rag_cup.cos")
            if arg2 == mk.rag then
                manny:setpos(0.458224, -0.348155, 0)
                manny:setrot(0, 69.8924, 0)
                manny:pop_costume()
                sleep_for(2000)
                start_sfx("mkTostUp.wav")
                wait_for_sound("mkTostUp.wav")
                manny:walkto(0.38545, -0.30193, 0, 0, 69.8924, 0)
                manny:wait_for_actor()
                manny:push_costume("msb_rag_cup.cos")
                manny:play_chore(msb_rag_cup_take_rag, "msb_rag_cup.cos")
                sleep_for(1800)
                manny:play_chore(msb_activate_rag, "msb.cos")
                manny:wait_for_chore(msb_rag_cup_take_rag, "msb_rag_cup.cos")
                manny:pop_costume()
                manny:play_chore(msb_hold, "msb.cos")
                manny:say_line("/mkma027/")
            else
                arg2:free()
                manny:head_look_at(nil)
                manny:play_chore(msb_rag_cup_watch_tstr_fire, "msb_rag_cup.cos")
                sleep_for(2000)
                mk:put_out_fire()
            end
        else
            sleep_for(1000)
            start_sfx("mkTostUp.wav")
        end
        END_CUT_SCENE()
    end
end
mk.put_out_fire = function(arg1) -- line 183
    cur_puzzle_state[47] = TRUE
    START_CUT_SCENE()
    start_sfx("mkFire.WAV")
    start_sfx("brFire.IMU", IM_HIGH_PRIORITY, 0)
    fade_sfx("brFire.IMU", 2500, 127)
    mk.fire_actor:start()
    sleep_for(1000)
    mechanic1:default()
    mechanic1:push_costume("mm_extinguish.cos")
    mechanic1:put_in_set(mk)
    mechanic1:setpos(1.14691, -0.64678, 0)
    mechanic1:setrot(0, 90, 0)
    mechanic1:play_chore(mm_extinguish_extinguish, "mm_extinguish.cos")
    manny:play_chore(msb_rag_cup_watch_mech_run, "msb_rag_cup.cos")
    sleep_for(2000)
    start_sfx("extingsh.IMU")
    if mk.mug_rack.has_mug then
        mechanic2:default()
        mechanic2:push_costume("mm_extinguish.cos")
        mechanic2:put_in_set(mk)
        mechanic2:setpos(1.56366, -0.124631, 0)
        mechanic2:setrot(0, 120, 0)
        mechanic2:play_chore(mm_extinguish_run_in, "mm_extinguish.cos")
    end
    sleep_for(1500)
    fade_sfx("brFire.IMU", 500, 0)
    mk.fire_actor:stop()
    fade_sfx("extingsh.IMU", 500, 0)
    mechanic1:wait_for_chore(mm_extinguish_extinguish, "mm_extinguish.cos")
    manny:play_chore(msb_rag_cup_watch_mechanic, "msb_rag_cup.cos")
    END_CUT_SCENE()
    if mk.mug_rack.has_mug then
        cur_puzzle_state[48] = TRUE
        START_CUT_SCENE()
        start_sfx("mugRattl.WAV")
        sleep_for(500)
        start_sfx("mugJet.IMU")
        mk.mug_actor:play_chore(mug_hook_mug_rocket)
        mk.mug_rack:play_chore(0)
        manny:play_chore(msb_rag_cup_dodge_cup, "msb_rag_cup.cos")
        mechanic1:play_chore(mm_extinguish_watch_cup, "mm_extinguish.cos")
        sleep_for(2000)
        fade_pan_sfx("mugJet.IMU", 3000, 127)
        sleep_for(2000)
        fade_sfx("mugJet.IMU", 1000, 0)
        mechanic1:wait_for_chore(mm_extinguish_watch_cup, "mm_extinguish.cos")
        mechanic1:play_chore(mm_extinguish_2point, "mm_extinguish.cos")
        mk.mug_actor:wait_for_chore(mug_hook_mug_rocket)
        mk.mug_actor:show(FALSE)
        mechanic1:say_line("/mkm1028/")
        mechanic1:wait_for_chore(mm_extinguish_2point, "mm_extinguish.cos")
        manny:wait_for_chore(msb_rag_cup_dodge_cup, "msb_rag_cup.cos")
        manny:play_chore(msb_rag_cup_2lk_mm_point, "msb_rag_cup.cos")
        mechanic1:play_chore(mm_extinguish_point2cup, "mm_extinguish.cos")
        mechanic1:wait_for_message()
        mechanic2:say_line("/mkm2029/")
        mechanic2:wait_for_message()
        mechanic1:play_chore(mm_extinguish_stop_point, "mm_extinguish.cos")
        mechanic1:set_speech_mode(MODE_BACKGROUND)
        music_state:set_sequence(seqSproutAha)
        mechanic1:say_line("/mkm1030/")
        mechanic2:say_line("/mkm2031/")
        mechanic2:wait_for_message()
        mechanic1:say_line("/mkm1032/")
        mechanic1:wait_for_message()
        manny:play_chore(msb_rag_cup_comment, "msb_rag_cup.cos")
        manny:say_line("/mkma033/")
        manny:wait_for_message()
        manny:setpos(0.458224, -0.348155, 0)
        manny:setrot(0, 69.8924, 0)
        manny:pop_costume()
        END_CUT_SCENE()
        start_script(cut_scene.coffrock)
    else
        START_CUT_SCENE()
        start_sfx("mkSmoldr.WAV")
        mechanic1:say_line("/mkm1034/")
        mechanic1:play_chore(mm_extinguish_2bitch, "mm_extinguish.cos")
        mechanic1:wait_for_chore(mm_extinguish_2bitch, "mm_extinguish.cos")
        mechanic1:play_chore_looping(mm_extinguish_bitch_manny, "mm_extinguish.cos")
        mechanic1:wait_for_message()
        mechanic1:set_chore_looping(mm_extinguish_bitch_manny, FALSE, "mm_extinguish.cos")
        mechanic1:wait_for_chore(mm_extinguish_bitch_manny, "mm_extinguish.cos")
        manny:say_line("/mkma035/")
        manny:wait_for_message()
        mechanic1:play_chore(mm_extinguish_leave_mk, "mm_extinguish.cos")
        mechanic1:say_line("/mkm1036/")
        mechanic1:wait_for_chore(mm_extinguish_leave_mk, "mm_extinguish.cos")
        mechanic1:wait_for_message()
        mechanic1:put_in_set(nil)
        manny:setpos(0.458224, -0.348155, 0)
        manny:setrot(0, 69.8924, 0)
        manny:pop_costume()
        END_CUT_SCENE()
    end
end
mayan_mechanic.costume_marker_handler = function(arg1, arg2) -- line 289
    if arg2 == Actor.MARKER_LEFT_RUN then
        arg1:play_footstep_sfx(pick_one_of({ "fsDemRL1.WAV", "fsDemRL2.WAV" }), 60, 90)
    elseif arg2 == Actor.MARKER_RIGHT_RUN then
        arg1:play_footstep_sfx(pick_one_of({ "fsDemRR1.WAV", "fsDemRR2.WAV" }), 60, 90)
    end
end
mk.enter = function(arg1) -- line 303
    mk:add_object_state(mk_intws, "mk_drawer.bm", nil, OBJSTATE_UNDERLAY)
    mk:add_object_state(mk_intws, "mk_rocket.bm", nil, OBJSTATE_UNDERLAY)
    mk.mug_rack_actor:default()
    mk.mug_rack:set_object_state("mk_rocket_flash.cos")
    mk.mug_actor:default()
    if mk.mug_rack.has_mug then
        mk.mug_actor:show(TRUE)
    else
        mk.mug_actor:show(FALSE)
    end
    mk.drawers:set_object_state("mk_drawer.cos")
    if mk.drawers:is_open() then
        mk.drawers:play_chore(mk_drawer_set_open)
    else
        mk.drawers:play_chore(mk_drawer_set_closed)
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 1000, 4000, 6000)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
mk.exit = function(arg1) -- line 332
    KillActorShadows(manny.hActor)
end
mk.rag = Object:create(mk, "/mktx037/rag", 0, 0, 0, { range = 0 })
mk.rag.wav = "getrag.wav"
mk.rag.lookAt = function(arg1) -- line 343
    manny:say_line("/mkma038/")
end
mk.rag.use = function(arg1) -- line 347
    START_CUT_SCENE()
    look_at_item_in_hand(TRUE)
    manny:say_line("/mkma039/")
    manny:wait_for_message()
    manny:set_talk_chore(1, msb_stop_talk)
    manny:set_talk_chore(2, msb_stop_talk)
    manny:set_talk_chore(3, msb_c)
    manny:set_talk_chore(4, msb_stop_talk)
    manny:set_talk_chore(5, msb_stop_talk)
    manny:set_talk_chore(6, msb_stop_talk)
    manny:set_talk_chore(7, msb_stop_talk)
    manny:set_talk_chore(8, msb_stop_talk)
    manny:set_talk_chore(9, msb_c)
    manny:set_talk_chore(10, msb_stop_talk)
    break_here()
    manny:head_look_at(nil)
    manny:play_chore(msb_use_obj, "msb.cos")
    manny:say_line("/mkma040/")
    manny:wait_for_chore(msb_use_obj, "msb.cos")
    manny:wait_for_message()
    manny:set_talk_chore(1, msb_stop_talk)
    manny:set_talk_chore(2, msb_a)
    manny:set_talk_chore(3, msb_c)
    manny:set_talk_chore(4, msb_e)
    manny:set_talk_chore(5, msb_f)
    manny:set_talk_chore(6, msb_l)
    manny:set_talk_chore(7, msb_m)
    manny:set_talk_chore(8, msb_o)
    manny:set_talk_chore(9, msb_t)
    manny:set_talk_chore(10, msb_u)
    END_CUT_SCENE()
end
mk.rag.default_response = function(arg1) -- line 385
    manny:say_line("/mkma041/")
end
mk.drawers = Object:create(mk, "/mktx001/drawers", 0.56939101, -0.110329, 0.206, { range = 0.60000002 })
mk.drawers.use_pnt_x = 0.47756699
mk.drawers.use_pnt_y = -0.34999999
mk.drawers.use_pnt_z = 0
mk.drawers.use_rot_x = 0
mk.drawers.use_rot_y = 3.3110001
mk.drawers.use_rot_z = 0
mk.drawers.open = function(arg1) -- line 397
    if manny:walkto_object(arg1) then
        START_CUT_SCENE()
        manny:push_costume("msb_open_drawer.cos")
        manny:play_chore(msb_open_drawer_open_drawer, "msb_open_drawer.cos")
        sleep_for(1000)
        mk.drawers:play_chore(mk_drawer_open)
        manny:wait_for_chore(msb_open_drawer_open_drawer, "msb_open_drawer.cos")
        manny:pop_costume()
        END_CUT_SCENE()
        arg1.opened = TRUE
        arg1:lookAt()
    end
end
mk.drawers.use = function(arg1) -- line 412
    if arg1:is_open() then
        if mk.rag.owner == manny or my.oily_rag.owner == manny then
            manny:say_line("/mkma002/")
        elseif manny:walkto_object(arg1) then
            START_CUT_SCENE()
            manny:play_chore(msb_reach_med, "msb.cos")
            sleep_for(1000)
            manny:stop_chore(msb_reach_med, "msb.cos")
            start_sfx("getRag.WAV")
            manny:generic_pickup(mk.rag)
            manny:say_line("/mkma003/")
            END_CUT_SCENE()
        end
    else
        arg1:open()
    end
end
mk.drawers.pickUp = mk.drawers.use
mk.drawers.lookAt = function(arg1) -- line 435
    if arg1:is_open() then
        arg1.seen = TRUE
        hot_object = arg1
        manny:head_look_at(arg1)
        manny.been_gazin = 0
        manny:say_line("/mkma004/")
    else
        system.default_response("closed")
    end
end
mk.toaster = Object:create(mk, "/mktx005/toaster", 0.258459, 0.0088414699, 0.38999999, { range = 0.60000002 })
mk.toaster.use_pnt_x = 0.31466401
mk.toaster.use_pnt_y = -0.30548301
mk.toaster.use_pnt_z = 0
mk.toaster.use_rot_x = 0
mk.toaster.use_rot_y = 27.4863
mk.toaster.use_rot_z = 0
mk.toaster.lookAt = function(arg1) -- line 456
    soft_script()
    manny:say_line("/mkma042/")
    manny:wait_for_message()
    manny:say_line("/mkma043/")
end
mk.toaster.pickUp = function(arg1) -- line 463
    manny:say_line("/mkma007/")
end
mk.toaster.use = function(arg1) -- line 467
    mk:toast(nil)
end
mk.toaster.use_rag = function(arg1) -- line 471
    mk:toast(mk.rag)
end
mk.toaster.use_oily_rag = function(arg1) -- line 475
    mk:toast(my.oily_rag)
end
mk.mug_rack = Object:create(mk, "/mktx008/mug rack", 0.480102, -0.0308, 0.42179999, { range = 0.60000002 })
mk.mug_rack.use_pnt_x = 0.46845999
mk.mug_rack.use_pnt_y = -0.34437001
mk.mug_rack.use_pnt_z = 0
mk.mug_rack.use_rot_x = 0
mk.mug_rack.use_rot_y = 69.892403
mk.mug_rack.use_rot_z = 0
mk.mug_rack.is_upright = TRUE
mk.mug_rack.lookAt = function(arg1) -- line 489
    if mk.mug_rack.has_mug then
        manny:say_line("/mkma009/")
    else
        manny:say_line("/mkma010/")
    end
end
mk.mug_rack.use = function(arg1) -- line 497
    if td.mug.owner == manny then
        manny:pull_out_item(td.mug)
        arg1:use_mug()
    else
        manny:say_line("/mkma011/")
    end
end
mk.mug_rack.pickUp = function(arg1) -- line 506
    if arg1.has_mug then
        if manny:walkto_object(arg1) then
            START_CUT_SCENE()
            manny:push_costume("msb_rag_cup.cos")
            manny:play_chore(msb_rag_cup_unhook_cup, "msb_rag_cup.cos")
            sleep_for(667)
            mk.mug_actor:show(FALSE)
            start_sfx("mkMugOff.WAV")
            manny:wait_for_chore(msb_rag_cup_unhook_cup, "msb_rag_cup.cos")
            manny:generic_pickup(td.mug)
            manny:pop_costume()
            manny.been_gazin = 0
            hot_object = arg1
            END_CUT_SCENE()
            arg1.has_mug = FALSE
        end
    elseif td.mug.owner == manny then
        manny:say_line("/mkma012/")
        manny:wait_for_message()
        manny:say_line("/mkma013/")
    else
        manny:say_line("/mkma014/")
        manny:wait_for_message()
        manny:say_line("/mkma015/")
    end
end
mk.mug_rack.use_mug = function(arg1) -- line 537
    if manny:walkto_object(arg1) then
        arg1.has_mug = TRUE
        td.mug:free()
        START_CUT_SCENE()
        manny:head_look_at(nil)
        manny:push_costume("msb_rag_cup.cos")
        manny:stop_chore(msb_hold, "msb.cos")
        manny:stop_chore(msb_activate_mug, "msb.cos")
        manny:play_chore(msb_rag_cup_hook_cup, "msb_rag_cup.cos")
        start_script(mk.mug_actor.hook, mk.mug_actor)
        sleep_for(800)
        start_sfx("mkMugOn.WAV")
        manny:wait_for_chore(msb_rag_cup_hook_cup, "msb_rag_cup.cos")
        manny:setpos(0.50266, -0.35277, 0)
        manny:setrot(0, 85.6874, 0)
        manny:pop_costume()
        manny:say_line("/mkma044/")
        hot_object = arg1
        manny.been_gazin = 0
        END_CUT_SCENE()
    end
end
mk.fridge = Object:create(mk, "/mktx020/fridge", -0.324067, -0.76779997, 0.41999999, { range = 0.60000002 })
mk.fridge.use_pnt_x = -0.17406701
mk.fridge.use_pnt_y = -0.72780001
mk.fridge.use_pnt_z = 0
mk.fridge.use_rot_x = 0
mk.fridge.use_rot_y = 454.25201
mk.fridge.use_rot_z = 0
mk.fridge.lookAt = function(arg1) -- line 572
    START_CUT_SCENE()
    manny:say_line("/mkma021/")
    manny:wait_for_message()
    manny:say_line("/mkma022/")
    manny:wait_for_message()
    END_CUT_SCENE()
    soft_script()
    manny:say_line("/mkma023/")
    manny:wait_for_message()
    manny:say_line("/mkma024/")
end
mk.fridge.pickUp = function(arg1) -- line 585
    manny:say_line("/mkma025/")
end
mk.fridge.use = function(arg1) -- line 589
    if not arg1.seen then
        arg1:lookAt()
    else
        manny:say_line("/mkma045/")
    end
end
mk.my_door = Object:create(mk, "/mktx026/door", 0.949265, -0.54975599, 0.41, { range = 0.60000002 })
mk.my_door.use_pnt_x = 0.66926497
mk.my_door.use_pnt_y = -0.54975599
mk.my_door.use_pnt_z = 0
mk.my_door.use_rot_x = 0
mk.my_door.use_rot_y = -436.202
mk.my_door.use_rot_z = 0
mk.my_door.out_pnt_x = 0.85000002
mk.my_door.out_pnt_y = -0.50536299
mk.my_door.out_pnt_z = 0
mk.my_door.out_rot_x = 0
mk.my_door.out_rot_y = -436.202
mk.my_door.out_rot_z = 0
mk.my_door.touchable = FALSE
mk.my_box = mk.my_door
mk.my_door.walkOut = function(arg1) -- line 620
    my:come_out_door(my.mk_door)
end
