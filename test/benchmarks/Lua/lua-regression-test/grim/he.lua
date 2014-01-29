CheckFirstTime("he.lua")
he = Set:create("he.set", "high roller elevator", { he_dorws = 0, he_ovrhd = 1 })
he.shrinkable = 0.07
he.aitor_snore_idles = function(arg1) -- line 14
    aitor:play_chore(aitor_idles_eyes_shut, "aitor_idles.cos")
    while 1 do
        aitor:say_line(pick_one_of({ "/heai043/", "/heai044/", "/heai045/", "/heai046/" }), { background = TRUE, skip_log = TRUE })
        sleep_for(rndint(5000, 10000))
    end
end
prop_forklift = Actor:create(nil, nil, nil, "prop forklift")
prop_forklift.he_pt = { x = 0.201511, y = 2.3064201, z = 0 }
prop_forklift.default_he = function(arg1) -- line 32
    local local1
    arg1:free()
    arg1:set_costume("forklift.cos")
    arg1:put_in_set(he)
    arg1:ignore_boxes()
    arg1:setpos(arg1.he_pt.x, arg1.he_pt.y, arg1.he_pt.z)
    local1 = de.forklift_actor:getrot()
    arg1:setrot(local1.x, local1.y + 90, local1.z)
    if de.forklift_actor.blades_up then
        arg1:play_chore(forklift_up_hold)
    else
        arg1:play_chore(forklift_down_hold)
    end
end
he.aitor_downstairs = TRUE
he.enter = function(arg1) -- line 55
    MakeSectorActive("elevator_box", FALSE)
    NewObjectState(he_dorws, OBJSTATE_STATE, "he_door.bm", "he_door.zbm")
    he.elevator:set_object_state("he_door.cos")
    if not he.elevator.locked then
        he.de_box = he.de_door
        he.aitor_obj:make_untouchable()
    elseif not he.aitor_downstairs and not hk.raoul_quit then
        aitor:default()
        aitor:pop_costume()
        aitor:set_mumble_chore(aitor_idles_mumble)
        aitor:set_talk_chore(1, aitor_idles_stop_talk)
        aitor:set_talk_chore(2, aitor_idles_a)
        aitor:set_talk_chore(3, aitor_idles_c)
        aitor:set_talk_chore(4, aitor_idles_e)
        aitor:set_talk_chore(5, aitor_idles_f)
        aitor:set_talk_chore(6, aitor_idles_l)
        aitor:set_talk_chore(7, aitor_idles_m)
        aitor:set_talk_chore(8, aitor_idles_o)
        aitor:set_talk_chore(9, aitor_idles_t)
        aitor:set_talk_chore(10, aitor_idles_u)
        aitor:push_costume("aitor_cask.cos")
        aitor:put_in_set(he)
        aitor:setpos(-1.25632, -0.752019, 0)
        aitor:setrot(0, 142.005, 0)
        aitor:play_chore(aitor_idles_sit_pos, "aitor_idles.cos")
        aitor:play_chore(aitor_idles_head_down, "aitor_idles.cos")
        aitor:play_chore(aitor_idles_eyes_shut, "aitor_idles.cos")
        he.aitor_obj:make_touchable()
        start_script(he.aitor_snore_idles, he)
    else
        he.aitor_obj:make_untouchable()
    end
    if he.aitor_obj.touchable then
        box_on("aitor1")
        box_on("aitor2")
        box_on("aitor3")
        box_off("no_aitor1")
        box_off("no_aitor2")
    else
        box_off("aitor1")
        box_off("aitor2")
        box_off("aitor3")
        box_on("no_aitor1")
        box_on("no_aitor2")
    end
    if de.forklift_actor.currentSet == de then
        prop_forklift:default_he()
    end
    start_sfx("he_hk_hp.imu", nil, 90)
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, 0, 0.4, 4)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(aitor.hActor, 0)
    SetActorShadowPoint(aitor.hActor, 0, 0.4, 4)
    SetActorShadowPlane(aitor.hActor, "shadow1")
    AddShadowPlane(aitor.hActor, "shadow1")
end
he.exit = function(arg1) -- line 128
    if sound_playing("wcDoor.wav") then
        wait_for_sound("wcDoor.wav")
    end
    if find_script(he.aitor_snore_idles) then
        stop_script(he.aitor_snore_idles)
    end
    stop_sound("hkCaskRl.imu")
    KillActorShadows(manny.hActor)
    KillActorShadows(aitor.hActor)
    prop_forklift:free()
    stop_sound("he_hk_hp.imu")
end
he.elevator = Object:create(he, "/hetx047/elevator", -0.0145502, 1.1127501, 0.47999999, { range = 0.85000002 })
he.elevator.use_pnt_x = 0.20545
he.elevator.use_pnt_y = 0.60275197
he.elevator.use_pnt_z = 0
he.elevator.use_rot_x = 0
he.elevator.use_rot_y = 36.550999
he.elevator.use_rot_z = 0
he.elevator:lock()
he.elevator.lookAt = function(arg1) -- line 161
    manny:say_line("/hema048/")
end
he.elevator.use = function(arg1) -- line 165
    if arg1:is_open() then
        manny:walkto(he.de_door, TRUE)
    else
        he.button:use()
    end
end
he.elevator.open = function(arg1) -- line 173
    if not arg1:is_open() then
        arg1:play_chore(0)
        arg1:wait_for_chore(0)
        MakeSectorActive("elevator_box", TRUE)
        Object.open(arg1)
    end
end
he.elevator.close = function(arg1) -- line 182
    if arg1:is_open() then
        arg1:play_chore(1)
        arg1:wait_for_chore(1)
        MakeSectorActive("elevator_box", FALSE)
        Object.close(arg1)
    end
end
he.elevator.comeOut = function(arg1) -- line 191
    START_CUT_SCENE()
    manny:ignore_boxes()
    manny:setpos(-0.0151523, 1.57243, 0)
    manny:setrot(0, 176.285, 0)
    arg1:open()
    manny:follow_boxes()
    manny:walkto(-0.0843952, 0.505871, 0, 0, 176.285, 0)
    arg1:close()
    END_CUT_SCENE()
end
he.button = Object:create(he, "/hetx049/button", 0.49544999, 0.87275201, 0.36000001, { range = 0.60000002 })
he.button.use_pnt_x = 0.41064799
he.button.use_pnt_y = 0.48445401
he.button.use_pnt_z = 0
he.button.use_rot_x = 0
he.button.use_rot_y = 20.780001
he.button.use_rot_z = 0
he.button.lookAt = function(arg1) -- line 212
    manny:say_line("/hema050/")
end
he.button.pickUp = function(arg1) -- line 216
    arg1:use()
end
he.button.use = function(arg1) -- line 220
    if hh.union_card.owner == manny then
        system.default_response("already")
    else
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:wait_for_chore()
        manny:play_chore(mc_hand_on_obj, "mc.cos")
        sleep_for(400)
        start_sfx("deBtn.wav")
        manny:wait_for_chore(mc_hand_on_obj, "mc.cos")
        manny:play_chore(mc_hand_off_obj, "mc.cos")
        manny:wait_for_chore(mc_hand_off_obj, "mc.cos")
        manny:head_look_at(he.elevator)
        END_CUT_SCENE()
        if he.elevator.locked then
            if not he.aitor_downstairs then
                Dialog:run("ai1", "dlg_aitor.lua")
            else
                START_CUT_SCENE()
                sleep_for(1000)
                manny:head_look_at(arg1)
                manny:play_chore(mc_hand_on_obj, "mc.cos")
                sleep_for(400)
                start_sfx("deBtn.wav")
                manny:wait_for_chore(mc_hand_on_obj, "mc.cos")
                manny:play_chore(mc_hand_off_obj, "mc.cos")
                manny:wait_for_chore(mc_hand_off_obj, "mc.cos")
                manny:head_look_at(he.elevator)
                Object.lookAt(arg1)
                END_CUT_SCENE()
            end
        else
            START_CUT_SCENE()
            manny:walkto_object(he.elevator)
            manny:wait_for_actor()
            END_CUT_SCENE()
            he.elevator:open()
        end
    end
end
he.aitor_obj = Object:create(he, "/hetx051/Aitor", -0.357155, 0.34619799, 0.60000002, { range = 0.89999998 })
he.aitor_obj.use_pnt_x = -0.037489299
he.aitor_obj.use_pnt_y = 0.0236906
he.aitor_obj.use_pnt_z = 0
he.aitor_obj.use_rot_x = 0
he.aitor_obj.use_rot_y = 45.862598
he.aitor_obj.use_rot_z = 0
he.aitor_obj.lookAt = function(arg1) -- line 270
    manny:say_line("/hema052/")
end
he.aitor_obj.pickUp = function(arg1) -- line 274
    system.default_response("something")
end
he.aitor_obj.use = function(arg1) -- line 278
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:head_forward_gesture()
    manny:say_line("/hema053/")
    manny:wait_for_message()
    stop_script(he.aitor_snore_idles, he)
    aitor:shut_up()
    sleep_for(500)
    aitor:play_chore(aitor_idles_eyes_open, "aitor_idles.cos")
    END_CUT_SCENE()
    Dialog:run("ai1", "dlg_aitor.lua")
end
he.hk_door = Object:create(he, "/hetx054/door", -0.050000001, -1.4311301, 0.43000001, { range = 0.60000002 })
he.hk_door.use_pnt_x = 0.0763264
he.hk_door.use_pnt_y = -0.33903199
he.hk_door.use_pnt_z = 0
he.hk_door.use_rot_x = 0
he.hk_door.use_rot_y = 172.12199
he.hk_door.use_rot_z = 0
he.hk_door.out_pnt_x = -0.071795098
he.hk_door.out_pnt_y = -0.85998303
he.hk_door.out_pnt_z = 0
he.hk_door.out_rot_x = 0
he.hk_door.out_rot_y = 171.071
he.hk_door.out_rot_z = 0
he.hk_box = he.hk_door
he.hk_door.walkOut = function(arg1) -- line 314
    hk:come_out_door(hk.he_door)
end
he.de_door = Object:create(he, "/hetx055/elevator", 0.040658701, 1.19301, 0.47999999, { range = 0 })
he.de_door.use_pnt_x = 0.040658701
he.de_door.use_pnt_y = 0.71301299
he.de_door.use_pnt_z = 0
he.de_door.use_rot_x = 0
he.de_door.use_rot_y = 5.58289
he.de_door.use_rot_z = 0
he.de_door.out_pnt_x = 0.0115489
he.de_door.out_pnt_y = 1.01079
he.de_door.out_pnt_z = 0
he.de_door.out_rot_x = 0
he.de_door.out_rot_y = 5.58289
he.de_door.out_rot_z = 0
he.de_door.touchable = FALSE
he.de_door.walkOut = function(arg1) -- line 337
    START_CUT_SCENE()
    manny:wait_for_actor()
    he.elevator:close()
    de:come_out_door(de.grating)
    END_CUT_SCENE()
end
