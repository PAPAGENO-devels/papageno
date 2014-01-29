CheckFirstTime("gs.lua")
gs = Set:create("gs.set", "Glottis' Shop", { gs_ofcha = 0, gs_ovrhd = 1 })
dofile("sv_helps.lua")
dofile("gs_ga_door.lua")
dofile("copal_yell.lua")
dofile("ma_fill_bondo.lua")
gs.update_states = function(arg1) -- line 17
    if gs.is_jail then
        gs.ga_door:close()
        gs.ga_door:lock()
        gs.ga_door:play_chore(gs_ga_door_set_closed, "gs_ga_door.cos")
        MakeSectorActive("door_box1", FALSE)
        MakeSectorActive("door_box2", FALSE)
        gs.window:make_touchable()
    else
        gs.ga_door:unlock()
        gs.ga_door:open()
        gs.ga_door:make_untouchable()
        gs.open_out_door:play_chore(0)
        MakeSectorActive("door_box1", TRUE)
        MakeSectorActive("door_box2", TRUE)
        gs.window:make_untouchable()
    end
end
gs.set_up_prison = function(arg1) -- line 36
    local local1
    START_CUT_SCENE()
    gs.is_jail = TRUE
    manny:put_in_set(nil)
    gs:switch_to_set()
    local1 = NewObjectState(gs_ofcha, OBJSTATE_STATE, "gs_copal.bm", "gs_copal.zbm")
    SendObjectToFront(local1)
    gs:update_states()
    copal:set_costume("copal_yell.cos")
    copal:put_in_set(gs)
    copal:set_visibility(TRUE)
    copal:setpos(0.7899, 9.9869003, 0)
    copal:setrot(0, 28.74, 0)
    copal:play_chore(copal_yell_talk_hold)
    copal:set_mumble_chore(copal_yell_mumble)
    copal:set_talk_chore(1, copal_yell_no_talk)
    copal:set_talk_chore(2, copal_yell_a)
    copal:set_talk_chore(3, copal_yell_c)
    copal:set_talk_chore(4, copal_yell_e)
    copal:set_talk_chore(5, copal_yell_f)
    copal:set_talk_chore(6, copal_yell_l)
    copal:set_talk_chore(7, copal_yell_m)
    copal:set_talk_chore(8, copal_yell_o)
    copal:set_talk_chore(9, copal_yell_t)
    copal:set_talk_chore(10, copal_yell_u)
    manny:put_in_set(gs)
    manny:setpos(0.55629998, 10.4237, 0)
    manny:setrot(0, 205.494, 0)
    manny:head_look_at(nil)
    break_here()
    copal:say_line("/gsco078/")
    copal:wait_for_message()
    copal:say_line("/gsco079/")
    copal:wait_for_message()
    copal:play_chore(copal_yell_close_door, "copal_yell.cos")
    copal:wait_for_chore()
    copal:put_in_set(nil)
    copal:free()
    gs.ga_door:play_chore(gs_ga_door_set_closed)
    FreeObjectState(local1)
    ForceRefresh()
    salvador:put_in_set(gs)
    salvador:set_costume("sv_helps.cos")
    salvador:set_colormap("black.cmp")
    salvador:set_visibility(TRUE)
    salvador:set_mumble_chore(sv_helps_mumble, "sv_helps.cos")
    salvador:set_talk_chore(1, sv_helps_stop_talk)
    salvador:set_talk_chore(2, sv_helps_a)
    salvador:set_talk_chore(3, sv_helps_c)
    salvador:set_talk_chore(4, sv_helps_e)
    salvador:set_talk_chore(5, sv_helps_f)
    salvador:set_talk_chore(6, sv_helps_l)
    salvador:set_talk_chore(7, sv_helps_m)
    salvador:set_talk_chore(8, sv_helps_o)
    salvador:set_talk_chore(9, sv_helps_t)
    salvador:set_talk_chore(10, sv_helps_u)
    salvador:ignore_boxes()
    salvador:setpos(0.81453401, 9.5706797, 0)
    salvador:setrot(0, 6.2112999, 0)
    salvador:play_chore(sv_helps_hidden, "sv_helps.cos")
    gs.ga_door:make_touchable()
    gs.window:make_touchable()
    END_CUT_SCENE()
end
gs.update_music_state = function(arg1) -- line 119
    if gs.is_jail then
        return stateGS_JAIL
    else
        return stateGS
    end
end
gs.enter = function(arg1) -- line 128
    local local1
    NewObjectState(gs_ofcha, OBJSTATE_STATE, "gs_bondo.bm", "gs_bondo.zbm", TRUE)
    gs.bondo_machine:set_object_state("gs_bondo.cos")
    gs.bondo_machine:play_chore(1)
    NewObjectState(gs_ofcha, OBJSTATE_STATE, "gs_sal_door.bm", "gs_sal_door.zbm", TRUE)
    gs.ga_door:set_object_state("gs_ga_door.cos")
    gs.open_out_door.hObjectState = gs:add_object_state(gs_ofcha, "gs_door_open.bm", "gs_door_open.zbm", OBJSTATE_STATE, FALSE)
    gs.open_out_door:set_object_state("gs_door_open.cos")
    gs:update_states()
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0, 60)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
end
gs.exit = function(arg1) -- line 152
    KillActorShadows(manny.hActor)
    salvador:free()
end
gs.open_out_door = Object:create(gs, "", 0, 0, 0, { range = 0 })
gs.open_out_door:make_untouchable()
gs.bondo_machine = Object:create(gs, "/gstx081/dispenser", 0.354534, 10.4907, 0.47999999, { range = 0.69999999 })
gs.bondo_machine.use_pnt_x = 0.53600001
gs.bondo_machine.use_pnt_y = 10.48
gs.bondo_machine.use_pnt_z = 0
gs.bondo_machine.use_rot_x = 0
gs.bondo_machine.use_rot_y = -269.73001
gs.bondo_machine.use_rot_z = 0
gs.bondo_machine.lookAt = function(arg1) -- line 173
    manny:say_line("/gsma082/")
end
gs.bondo_machine.pickUp = function(arg1) -- line 177
    manny:say_line("/gsma083/")
end
gs.bondo_machine.use = function(arg1) -- line 181
    START_CUT_SCENE()
    manny:walkto(0.55047, 10.4217, 0, 0, 90, 0)
    manny:wait_for_actor()
    manny:play_chore(ms_hand_on_obj, "ms.cos")
    manny:wait_for_chore()
    arg1:play_chore(0)
    arg1:wait_for_chore()
    manny:say_line("/slma058/")
    manny:wait_for_message()
    manny:play_chore(ms_hand_off_obj, "ms.cos")
    SetActorTimeScale(manny.hActor, 3.5)
    arg1:play_chore(1)
    start_sfx("dropdent.wav")
    manny:wait_for_chore()
    SetActorTimeScale(manny.hActor, 1)
    manny:say_line("/gsma084/")
    END_CUT_SCENE()
end
gs.bondo_machine.use_mouthpiece = function(arg1) -- line 202
    if dom.mouthpiece.bonded then
        manny:say_line("/gsma085/")
    else
        dom.mouthpiece.bonded = TRUE
        START_CUT_SCENE()
        manny:walkto(0.55047, 10.4867, 0, 0, 90, 0)
        manny:wait_for_actor()
        manny:push_costume("ma_fill_bondo.cos")
        manny:stop_chore(manny.hold_chore, "ms.cos")
        manny:stop_chore(ms_hold, "ms.cos")
        manny:play_chore(ma_fill_bondo_fill_mp)
        sleep_for(804)
        arg1:play_chore(0)
        arg1:wait_for_chore()
        arg1:play_chore(1)
        manny:wait_for_chore()
        manny:play_chore(ma_fill_bondo_fill_mp_done)
        manny:wait_for_chore()
        FadeOutChore(manny.hActor, "ma_fill_bondo.cos", ma_fill_bondo_fill_mp_done, 700)
        manny:pop_costume()
        manny:play_chore_looping(manny.hold_chore, "ms.cos")
        manny:play_chore_looping(ms_hold, "ms.cos")
        manny:say_line("/gsma086/")
        END_CUT_SCENE()
    end
end
gs.window = Object:create(gs, "/gstx087/window", 0.42199999, 9.7799997, 0.53399998, { range = 0.69999999 })
gs.window.use_pnt_x = 0.44100001
gs.window.use_pnt_y = 10.1
gs.window.use_pnt_z = 0
gs.window.use_rot_x = 0
gs.window.use_rot_y = -196.944
gs.window.use_rot_z = 0
gs.window.lookAt = function(arg1) -- line 239
    manny:say_line("/gsma088/")
end
gs.window.use = function(arg1) -- line 243
    manny:say_line("/gsma089/")
end
gs.window.use_scythe = function(arg1) -- line 247
    manny:say_line("/gsma090/")
end
gs.ga_door = Object:create(gs, "/gstx092/door", 0.85453397, 9.8106804, 0.46000001, { range = 1.05 })
gs.gs_ga_box = gs.ga_door
gs.ga_door.use_pnt_x = 0.83553201
gs.ga_door.use_pnt_y = 10.0325
gs.ga_door.use_pnt_z = 0
gs.ga_door.use_rot_x = 0
gs.ga_door.use_rot_y = 186.80701
gs.ga_door.use_rot_z = 0
gs.ga_door.out_pnt_x = 0.85000002
gs.ga_door.out_pnt_y = 9.6750002
gs.ga_door.out_pnt_z = 0
gs.ga_door.out_rot_x = 0
gs.ga_door.out_rot_y = 177.036
gs.ga_door.out_rot_z = 0
gs.ga_door.locked_out = function(arg1) -- line 302
    START_CUT_SCENE()
    manny:walkto_object(gs.ga_door)
    manny:knock_on_door_anim()
    END_CUT_SCENE()
    Dialog:run("sa1", "dlg_salvador.lua")
end
gs.ga_door.walkOut = function(arg1) -- line 310
    if not arg1:is_locked() then
        ga:come_out_door(ga.gs_door)
    end
end
gs.ga_door.comeOut = function(arg1) -- line 316
    Object.come_out_door(arg1)
    if hq.been_there and not glottis.missed then
        glottis.missed = TRUE
        manny:say_line("/gsma080/")
    end
end
