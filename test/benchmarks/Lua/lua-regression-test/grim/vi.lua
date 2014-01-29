CheckFirstTime("vi.lua")
dofile("mn_suitcase.lua")
vi = Set:create("vi.set", "vault interior", { vi_top = 0, vi_intla = 1 })
vi.additional_water_droplets = function(arg1) -- line 13
    while 1 do
        sleep_for(rndint(400, 1500))
        single_start_sfx(pick_one_of({ "swrDrop1.wav", "swrDrop2.wav", "swrDrop3.wav", "swrDrop4.wav" }), IM_LOW_PRIORITY, rndint(80, 127))
        break_here()
    end
end
vi.start_sprinkler = function() -- line 22
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    vi.sprinklers_going = TRUE
    vi.sprinkler:play_chore_looping(0)
    start_sfx("viSprink.imu")
    start_script(vi.additional_water_droplets)
    if not vi.tried_sprinklers then
        vi.tried_sprinklers = TRUE
        manny:say_line("/vima001/")
        wait_for_message()
        IrisDown(355, 245, 1000)
        sleep_for(1500)
        IrisUp(215, 280, 1000)
        vi.valve:play_chore(1)
        manny:say_line("/vima002/")
        wait_for_message()
        meche:say_line("/vimc003/")
        wait_for_message()
        music_state:set_sequence(seqSprinkler)
    else
        sleep_for(500)
        meche:say_line("/vimc004/")
        wait_for_message()
        music_state:set_sequence(seqSprinkler)
        IrisDown(355, 245, 1000)
        sleep_for(500)
        IrisUp(215, 280, 1000)
        vi.valve:play_chore(1)
    end
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.stop_sprinkler = function() -- line 58
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    vi.sprinklers_going = FALSE
    vi.sprinkler:stop_chore(0)
    vi.sprinkler:play_chore(1)
    stop_sound("viSprink.imu")
    stop_script(vi.additional_water_droplets)
    vi.valve:play_chore(2)
    meche:say_line("/vimc005/")
    StartMovie("vi.snm", nil, 40, 305)
    start_sfx("viSprnOf.wav")
    wait_for_movie()
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.bicker = function() -- line 75
    vi.bickered = TRUE
    meche_idle_ok = FALSE
    break_here()
    meche:say_line("/vimc006/")
    meche:wait_for_message()
    meche:say_line("/vimc007/")
    meche:wait_for_message()
    meche_idle_ok = TRUE
end
vi.reconcile = function() -- line 86
    START_CUT_SCENE()
    meche_idle_ok = FALSE
    manny:say_line("/vima008/")
    wait_for_message()
    meche:say_line("/vimc009/")
    wait_for_message()
    meche:say_line("/vimc010/")
    wait_for_message()
    meche:say_line("/vimc011/")
    meche_idle_ok = TRUE
    END_CUT_SCENE()
end
vi.meche_lookat_manny = function() -- line 102
    while 1 do
        meche:head_look_at_manny()
        break_here()
    end
end
vi.discover_tickets = function() -- line 109
    vi.suitcases.seen = TRUE
    meche_idle_ok = FALSE
    START_CUT_SCENE()
    MakeSectorActive("suitcase_box", TRUE)
    start_script(manny.walkto, manny, -1.09908, -0.465614, 0, 0, 31.61, 0)
    manny:say_line("/vima012/")
    wait_for_message()
    meche:say_line("/vimc013/")
    meche:play_chore_looping(meche_in_vi_walk)
    while TurnActorTo(meche.hActor, -1.09908, -0.465614, 0) do
        break_here()
    end
    meche:stop_chore(meche_in_vi_walk)
    wait_for_message()
    manny:wait_for_actor()
    manny:push_costume("mn_suitcase.cos")
    manny:play_chore(0, "mn_suitcase.cos")
    sleep_for(1500)
    music_state:set_sequence(seqDeadTix)
    suitcase3:set_visibility(FALSE)
    start_script(vi.meche_lookat_manny)
    meche:say_line("/vimc014/")
    wait_for_message()
    meche:say_line("/vimc015/")
    wait_for_message()
    meche:say_line("/vimc016/")
    wait_for_message()
    manny:say_line("/vima017/")
    manny:play_chore(mn_suitcase_close, "mn_suitcase.cos")
    wait_for_message()
    meche:say_line("/vimc018/")
    manny:wait_for_chore()
    wait_for_message()
    manny:pop_costume()
    suitcase3:set_visibility(TRUE)
    if find_script(vi.escape_safe) then
        manny:walkto(-0.904647, -0.474899, 0, 0, -440, 0)
    else
        manny:walkto(-0.727755, -0.176263, 0, 0, 33, 0)
    end
    manny:say_line("/vima019/")
    wait_for_message()
    manny:wait_for_actor()
    manny:say_line("/vima020/")
    manny:push_costume("mn_gestures.cos")
    manny:play_chore(manny_gestures_hand_gesture)
    wait_for_message()
    manny:say_line("/vima021/")
    wait_for_message()
    meche:say_line("/vimc022/")
    wait_for_message()
    manny:say_line("/vima023/")
    manny:play_chore(manny_gestures_head_nod)
    manny:wait_for_chore()
    manny:play_chore(manny_gestures_pointing)
    wait_for_message()
    manny:wait_for_chore()
    manny:say_line("/vima024/")
    manny:play_chore(manny_gestures_shrug)
    wait_for_message()
    manny:say_line("/vima025/")
    wait_for_message()
    MakeSectorActive("suitcase_box", TRUE)
    manny:pop_costume()
    vi.suitcases:lookAt()
    stop_script(vi.meche_lookat_manny)
    meche:head_look_at(nil)
    END_CUT_SCENE()
    meche_idle_ok = TRUE
end
vi.break_tile = function() -- line 182
    meche_idle_ok = FALSE
    START_CUT_SCENE()
    vi.tile_broken = TRUE
    vi.valve:play_chore(0)
    vi.valve:wait_for_chore()
    END_CUT_SCENE()
end
vi.escape_safe = function() -- line 192
    meche_freed = TRUE
    cur_puzzle_state[41] = TRUE
    START_CUT_SCENE()
    MakeSectorActive("suitcase_box", TRUE)
    manny:walkto(0.101501, -0.338144, 0, 0, -270.681, 0)
    manny:wait_for_actor()
    meche:follow_boxes()
    manny:say_line("/vima026/")
    manny:hand_gesture()
    wait_for_message()
    meche:say_line("/vimc027/")
    meche:play_chore_looping(meche_in_vi_walk)
    local local1 = start_script(meche.walkto, meche, -0.24616, -0.21772, 0, 0, 180, 0)
    wait_for_script(local1)
    meche:stop_chore(meche_in_vi_walk)
    meche:play_chore(meche_in_vi_hands_down_hold)
    wait_for_message()
    if not vi.suitcases.seen then
        vi.discover_tickets()
        wait_for_message()
        manny:say_line("/vima028/")
        manny:shrug_gesture()
        meche:play_chore_looping(meche_in_vi_walk)
        local local2 = start_script(meche.walkto, meche, -0.24616, -0.21772, 0, 0, 180, 0)
        wait_for_script(local2)
        meche:stop_chore(meche_in_vi_walk)
    else
        manny:say_line("/vima029/")
        manny:shrug_gesture()
    end
    wait_for_message()
    manny:say_line("/vima030/")
    manny:twist_head_gesture()
    wait_for_message()
    manny:say_line("/vima031/")
    wait_for_message()
    meche:play_chore(meche_in_vi_slide)
    meche:wait_for_chore()
    meche:free()
    stop_sound("viSprink.imu")
    stop_script(vi.additional_water_droplets)
    music_state:set_sequence(seqYr3Iris)
    IrisDown(355, 245, 1000)
    sleep_for(1500)
    stop_script(vo.exit_with_axe)
    vo_axe:free()
    END_CUT_SCENE()
    if raised_lamancha then
        start_script(bl.everybodys_here)
    else
        start_script(bl.passengers_before_boat)
    end
end
vi.meche_hold = function(arg1, arg2) -- line 250
    local local1 = rnd(arg1, arg2)
    if meche_idle_ok then
        repeat
            local1 = local1 - PerSecond(1)
            break_here()
            if not meche_idle_ok then
                local1 = 0
            end
        until local1 <= 0
    end
end
vi.meche_head_idle = function() -- line 263
    meche_idle_ok = TRUE
    while not vi.tile_broken do
        while meche_idle_ok do
            if manny_has_axe then
                meche:head_look_at_manny()
                while manny_has_axe do
                    break_here()
                end
            else
                meche:head_look_at_point({ x = -0.539173, y = 0.482942, z = 0.276 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.607073, y = 0.219642, z = 0.6374 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.813073, y = 0.219642, z = 0.4295 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.753373, y = 0.247742, z = 0.5051 })
                vi.meche_hold(0.5, 5)
                meche:head_look_at_point({ x = -0.994773, y = 0.288742, z = 0.244 })
                vi.meche_hold(0.5, 5)
            end
        end
        meche:head_look_at_manny()
        while not meche_idle_ok do
            break_here()
        end
    end
    meche:head_look_at(nil)
end
vi.meche_arm_idle = function() -- line 294
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
    while not vi.tile_broken do
        while meche_idle_ok do
            meche:play_chore(meche_in_vi_drop_hands)
            meche:wait_for_chore()
            vi.meche_hold(5, 9)
            meche:play_chore(meche_in_vi_xarms)
            meche:wait_for_chore()
            vi.meche_hold(5, 9)
        end
        break_here()
    end
    meche:play_chore(meche_in_vi_xarms)
    meche:wait_for_chore()
end
vi.set_up_actors = function(arg1) -- line 314
    if not suitcase1 then
        suitcase1 = Actor:create(nil, nil, nil, "case")
    end
    suitcase1:set_costume("mn_suitcase.cos")
    suitcase1:put_in_set(vi)
    suitcase1:setpos(-1.06803, -0.238608, -0.139)
    suitcase1:setrot(0, 75.6, 0)
    suitcase1:play_chore(mn_suitcase_suitcase_only)
    if not suitcase2 then
        suitcase2 = Actor:create(nil, nil, nil, "case")
    end
    suitcase2:set_costume("mn_suitcase.cos")
    suitcase2:put_in_set(vi)
    suitcase2:setpos(-1.14757, -0.4833, -0.064)
    suitcase2:setrot(0, 16.6, 0)
    suitcase2:play_chore(mn_suitcase_suitcase_only)
    if not suitcase3 then
        suitcase3 = Actor:create(nil, nil, nil, "case")
    end
    suitcase3:set_costume("mn_suitcase.cos")
    suitcase3:put_in_set(vi)
    suitcase3:setpos(-1.09908, -0.465614, 0)
    suitcase3:setrot(0, 31.61, 0)
    suitcase3:play_chore(mn_suitcase_suitcase_only)
    meche:set_costume("meche_in_vi.cos")
    meche:set_mumble_chore(meche_in_vi_mumble)
    meche:set_talk_chore(1, meche_in_vi_stop_talk)
    meche:set_talk_chore(2, meche_in_vi_a)
    meche:set_talk_chore(3, meche_in_vi_c)
    meche:set_talk_chore(4, meche_in_vi_e)
    meche:set_talk_chore(5, meche_in_vi_f)
    meche:set_talk_chore(6, meche_in_vi_l)
    meche:set_talk_chore(7, meche_in_vi_m)
    meche:set_talk_chore(8, meche_in_vi_o)
    meche:set_talk_chore(9, meche_in_vi_t)
    meche:set_talk_chore(10, meche_in_vi_u)
    meche:set_head(5, 5, 5, 165, 28, 80)
    meche:set_look_rate(200)
    meche:put_in_set(vi)
    meche:ignore_boxes()
    meche:setpos(-0.829475, 0.313889, 0)
    meche:setrot(0, 213, 0)
    meche.footsteps = footsteps.reverb
    start_script(vi.meche_head_idle)
    start_script(vi.meche_arm_idle)
end
vi.enter = function(arg1) -- line 372
    MakeSectorActive("suitcase_box", FALSE)
    vi:current_setup(vi_intla)
    vi:set_up_actors()
    if not vi.bickered and not find_script(slide_show) then
        start_script(vi.bicker)
    end
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_tile.bm")
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_water_tile.bm")
    vi.valve:set_object_state("vi_tile.cos")
    NewObjectState(vi_intla, OBJSTATE_UNDERLAY, "vi_sprinkler.bm")
    vi.sprinkler:set_object_state("vi_sprinkler.cos")
    if vi.sprinklers_going then
        vi.valve:play_chore(1)
        vi.sprinkler:play_chore_looping(0)
        start_script(vi.additional_water_droplets)
        start_sfx("viSprink.imu")
    else
        vi.valve:play_chore(2)
        vi.sprinkler:play_chore(1)
    end
    MakeSectorActive("meche_box", FALSE)
    if manny_has_axe then
        MakeSectorActive("noax1", FALSE)
        MakeSectorActive("noax2", FALSE)
        MakeSectorActive("noax3", FALSE)
    else
        MakeSectorActive("noax1", TRUE)
        MakeSectorActive("noax2", TRUE)
        MakeSectorActive("noax3", TRUE)
    end
    if vo_axe.currentSet == system.currentSet then
        vo_axe:put_in_set(vi)
        vo_axe:setpos(vo_axe.pos_x, vo_axe.pos_y, vo_axe.pos_z)
        vo_axe:setrot(vo_axe.rot_x, vo_axe.rot_y, vo_axe.rot_z)
        vo_axe:set_costume("mn_lift_ax.cos")
        vo_axe:play_chore(3)
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.7, 0.2, 3.2)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(meche.hActor, 0)
    SetActorShadowPoint(meche.hActor, -0.7, 0.2, 3.2)
    SetActorShadowPlane(meche.hActor, "shadow1")
    AddShadowPlane(meche.hActor, "shadow1")
end
vi.exit = function(arg1) -- line 429
    meche:free()
    suitcase1:free()
    suitcase2:free()
    suitcase3:free()
    stop_script(vi.meche_head_idle)
    stop_script(vi.meche_arm_idle)
    stop_script(vi.additional_water_droplets)
    stop_sound("viSprink.imu")
    KillActorShadows(manny.hActor)
    KillActorShadows(meche.hActor)
end
vi.suitcases = Object:create(vi, "/vitx032/suitcases", -1.3056901, -0.404212, 0.27000001, { range = 0.60000002 })
vi.suitcases.use_pnt_x = -1.01569
vi.suitcases.use_pnt_y = -0.53421199
vi.suitcases.use_pnt_z = 0
vi.suitcases.use_rot_x = 0
vi.suitcases.use_rot_y = -279.534
vi.suitcases.use_rot_z = 0
vi.suitcases.lookAt = function(arg1) -- line 457
    if not arg1.seen then
        start_script(vi.discover_tickets)
    else
        manny:say_line("/vima033/")
    end
end
vi.suitcases.pickUp = vi.suitcases.lookAt
vi.suitcases.use = vi.suitcases.lookAt
vi.valve = Object:create(vi, "/vitx034/valve", -0.192596, -1.20491, 0.31, { range = 0.60000002 })
vi.valve.use_pnt_x = -0.385097
vi.valve.use_pnt_y = -1.23524
vi.valve.use_pnt_z = 0
vi.valve.use_rot_x = 0
vi.valve.use_rot_y = -436.32101
vi.valve.use_rot_z = 0
vi.valve.opened = TRUE
vi.valve.lookAt = function(arg1) -- line 479
    manny:say_line("/vima035/")
end
vi.valve.open = function(arg1) -- line 483
    arg1.opened = TRUE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:set_rest_chore(nil)
    manny:play_chore(mn2_reach_med, manny.base_costume)
    start_sfx("viValve.wav", nil, 90)
    manny:wait_for_chore()
    manny:set_rest_chore(mn2_rest, manny.base_costume)
    END_CUT_SCENE()
    if vi.sprinkler_activated then
        start_script(vi.start_sprinkler)
    end
end
vi.valve.close = function(arg1) -- line 499
    arg1.opened = FALSE
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:set_rest_chore(nil)
    manny:play_chore(mn2_reach_med, manny.base_costume)
    start_sfx("viValve.wav", nil, 90)
    manny:wait_for_chore()
    manny:set_rest_chore(mn2_rest, manny.base_costume)
    END_CUT_SCENE()
    if vi.sprinkler_activated then
        start_script(vi.stop_sprinkler)
    end
end
vi.valve.use = function(arg1) -- line 515
    if arg1:is_open() then
        arg1:close()
    else
        arg1:open()
    end
end
vi.meche_obj = Object:create(vi, "/vitx036/Meche", -0.811068, 0.30837601, 0.52029997, { range = 0.69999999 })
vi.meche_obj.use_pnt_x = -0.77146798
vi.meche_obj.use_pnt_y = -0.128224
vi.meche_obj.use_pnt_z = 0
vi.meche_obj.use_rot_x = 0
vi.meche_obj.use_rot_y = 44.716599
vi.meche_obj.use_rot_z = 0
vi.meche_obj.lookAt = function(arg1) -- line 531
    if vi.sprinklers_going then
        manny:say_line("/vima037/")
    elseif not vi.reconciled then
        manny:say_line("/vima038/")
    else
        arg1:use()
    end
end
vi.meche_obj.pickUp = function(arg1) -- line 543
    START_CUT_SCENE()
    manny:say_line("/vima039/")
    wait_for_message()
    meche:say_line("/vimc040/")
    meche:wait_for_message()
    manny:say_line("/vima040b/")
    END_CUT_SCENE()
end
vi.meche_obj.use = function(arg1) -- line 553
    if not vi.reconciled then
        vi.reconciled = TRUE
        start_script(vi.reconcile)
    else
        START_CUT_SCENE()
        manny:say_line("/vima041/")
        wait_for_message()
        meche:say_line("/vimc042/")
        END_CUT_SCENE()
    end
end
vi.drain = Object:create(vi, "/vitx043/drain", -0.47740099, -0.653943, 0, { range = 0.60000002 })
vi.drain.use_pnt_x = -0.25740099
vi.drain.use_pnt_y = -0.52394301
vi.drain.use_pnt_z = 0
vi.drain.use_rot_x = 0
vi.drain.use_rot_y = -966.367
vi.drain.use_rot_z = 0
vi.drain:make_untouchable()
vi.vent = Object:create(vi, "/vitx044/vent", -0.85521197, 0.46798399, 1.21, { range = 1.5 })
vi.vent.use_pnt_x = -0.41288999
vi.vent.use_pnt_y = 0.16989399
vi.vent.use_pnt_z = 0
vi.vent.use_rot_x = 0
vi.vent.use_rot_y = -1026.98
vi.vent.use_rot_z = 0
vi.vent.lookAt = function(arg1) -- line 585
    manny:say_line("/vima045/")
end
vi.vent.use = function(arg1) -- line 589
    START_CUT_SCENE()
    manny:say_line("/vima046/")
    if not arg1.tried then
        arg1.tried = TRUE
        wait_for_message()
        meche:say_line("/vimc047/")
        wait_for_message()
        manny:say_line("/vima048/")
    end
    END_CUT_SCENE()
end
vi.vent.use_scythe = function(arg1) -- line 602
    manny:say_line("/vima049/")
end
vi.sprinkler = Object:create(vi, "/vitx050/sprinkler", -0.14229301, 0.264732, 1.02, { range = 1.3 })
vi.sprinkler.use_pnt_x = -0.246362
vi.sprinkler.use_pnt_y = -0.056466099
vi.sprinkler.use_pnt_z = 0
vi.sprinkler.use_rot_x = 0
vi.sprinkler.use_rot_y = 117.803
vi.sprinkler.use_rot_z = 0
vi.sprinkler.lookAt = function(arg1) -- line 615
    manny:say_line("/vima051/")
end
vi.sprinkler.use = function(arg1) -- line 619
    manny:say_line("/vima052/")
end
vi.sprinkler.use_chisel = vi.sprinkler.use
vi.sprinkler.use_scythe = function(arg1) -- line 625
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:push_costume("mn_scythe_sprinkler.cos")
    manny:play_chore(0)
    sleep_for(2200)
    start_sfx("viChop.wav")
    manny:wait_for_chore()
    manny:pop_costume()
    vi.sprinkler_activated = TRUE
    if vi.valve.opened then
        wait_for_message()
        start_script(vi.start_sprinkler)
    end
end
vi.broadaxe = Object:create(vi, "axe", 0, 0, 0, { range = 1 })
vi.broadaxe.use_pnt_x = 0
vi.broadaxe.use_pnt_y = 0
vi.broadaxe.use_pnt_z = 0
vi.broadaxe.use_rot_x = 0
vi.broadaxe.use_rot_y = 0
vi.broadaxe.use_rot_z = 0
vi.broadaxe:make_untouchable()
vi.broadaxe.lookAt = function(arg1) -- line 652
    manny:say_line("/voma044/")
end
vi.broadaxe.pickUp = function(arg1) -- line 657
    vo.get_axe()
end
vi.broadaxe.use = function(arg1) -- line 661
    vo.get_axe()
end
vi.broadaxe.default_response = vi.broadaxe.use
vi.vo_door = Object:create(vi, "/vitx053/secret door", 2.00371, -0.26364201, 0.47, { range = 0.69999999 })
vi.vo_door.use_pnt_x = 1.2337101
vi.vo_door.use_pnt_y = -0.26364201
vi.vo_door.use_pnt_z = 0
vi.vo_door.use_rot_x = 0
vi.vo_door.use_rot_y = -455.82001
vi.vo_door.use_rot_z = 0
vi.vo_door.out_pnt_x = 1.6
vi.vo_door.out_pnt_y = -0.30083799
vi.vo_door.out_pnt_z = 0
vi.vo_door.out_rot_x = 0
vi.vo_door.out_rot_y = -455.82001
vi.vo_door.out_rot_z = 0
vi.vo_door.walkOut = function(arg1) -- line 688
    if manny_has_axe then
        vo:switch_to_set()
        manny:setpos(-1.01436, 1.01177, 0)
        manny:setrot(0, -280, 0)
        manny:put_in_set(vo)
        vo_axe:put_in_set(vo)
        vi.broadaxe:make_untouchable()
        vo.broadaxe:make_touchable()
    else
        vo:come_out_door(vo.secret_door)
    end
end
vi.vo_door.lookAt = function(arg1) -- line 702
    manny:say_line("/vima054/")
end
