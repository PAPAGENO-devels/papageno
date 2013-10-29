CheckFirstTime("bi.lua")
dofile("bi_door.lua")
dofile("bi_olivia.lua")
dofile("mc_sna.lua")
dofile("lo_sna.lua")
dofile("nk_sna.lua")
dofile("ol_sna.lua")
dofile("olivia_idles.lua")
dofile("olivia_scripts.lua")
dofile("waiter_idles.lua")
dofile("passoutgirl.lua")
bi = Set:create("bi.set", "Blue Casket interior", { bi_clbws = 0, bi_kitdr = 1, bi_ovrhd = 2, bi_lolcu = 3, bi_olvcu = 4 })
dofile("patrons.lua")
bi.test = function() -- line 27
    olivia:default()
    dofile("dlg_olivia.lua")
    ol1:read_poem()
end
olivia.switch_to_standing = function(arg1) -- line 33
    start_script(olivia.idle_transition)
end
olivia.idle_transition = function() -- line 37
    while olivia.last_chore ~= olivia_idles_gest do
        break_here()
    end
    stop_script(olivia.new_run_idle)
    single_start_script(olivia.new_run_idle, olivia, "gest", olivia.standing_idle_table, "olivia_idles.cos")
end
bi.play_bongos = function(arg1) -- line 45
    local local1
    if arg1 and bi.commies.befriended or not arg1 then
        local1 = pick_one_of({ "bongo1.wav", "bongo2.wav", "bongo3.wav" })
        start_sfx(local1, nil, rndint(80, 127))
        set_pan(local1, 80)
    end
end
bi.waiter_collisions = function(arg1) -- line 56
    if arg1 then
        manny:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(manny.hActor, 0.35)
        beat_waiter:set_collision_mode(COLLISION_SPHERE)
        SetActorCollisionScale(beat_waiter.hActor, 0.35)
    else
        manny:set_collision_mode(COLLISION_OFF)
        if beat_waiter then
            beat_waiter:set_collision_mode(COLLISION_OFF)
        end
    end
end
bi.first_see_waiter = function() -- line 68
    START_CUT_SCENE()
    bi.seen_waiter = TRUE
    beat_waiter:default()
    beat_waiter:set_rest_chore(nil)
    beat_waiter:follow_boxes()
    beat_waiter:put_in_set(bi)
    bi.waiter_collisions(TRUE)
    beat_waiter:setpos(0.418543, -0.3463, 0)
    beat_waiter:setrot(0, 271.512, 0)
    beat_waiter:stop_chore(nil, "waiter_idles.cos")
    beat_waiter:complete_chore(waiter_idles_pre_pickup_hooka, "waiter_idles.cos")
    start_script(manny.walk_and_face, manny, -0.0720952, 1.49985, 0.15, 0, 202.688, 0)
    sleep_for(1000)
    beat_waiter:run_chore(waiter_idles_pickup_hooka, "waiter_idles.cos")
    beat_waiter:stop_chore(waiter_idles_pickup_hooka, "waiter_idles.cos")
    beat_waiter:complete_chore(waiter_idles_activate_tray, "waiter_idles.cos")
    beat_waiter:complete_chore(waiter_idles_activate_hook_on_tray, "waiter_idles.cos")
    SetActorReflection(beat_waiter.hActor, 90)
    beat_waiter:walkto(-0.0297894, -2.06096, 0.15)
    beat_waiter:wait_for_actor()
    beat_waiter:free()
    END_CUT_SCENE()
end
bi.waiter_slip_roofie = function() -- line 93
    local local1, local2, local3
    bi.roofie_trigger_set = FALSE
    skinny_girl.passed_out = TRUE
    START_CUT_SCENE()
    skinny_girl:thaw(TRUE)
    skinny_girl:set_costume(nil)
    skinny_girl:set_costume("passoutgirl.cos")
    skinny_girl:put_in_set(bi)
    skinny_girl:setpos(-0.86548001, -0.81151998, 0)
    skinny_girl:setrot(0, 250.8644, 0)
    skinny_girl:complete_chore(passoutgirl_idle, "passoutgirl.cos")
    beat_waiter:default()
    beat_waiter:set_visibility(TRUE)
    beat_waiter:set_rest_chore(waiter_idles_idle, "waiter_idles.cos")
    beat_waiter:follow_boxes()
    beat_waiter:put_in_set(bi)
    beat_waiter:setpos(-0.54861498, -0.55734098, 0)
    beat_waiter:setrot(0, 193.98399, 0)
    beat_waiter:head_look_at(bi.patrons2)
    beat_waiter:complete_chore(waiter_idles_idle_shooters, "waiter_idles.cos")
    set_override(bi.waiter_slip_roofie_override)
    manny:set_collision_mode(COLLISION_OFF)
    start_script(manny.walk_and_face, manny, -0.0140883, -0.79628903, 0, 0, 78.018997, 0)
    manny:head_look_at(bi.patrons2)
    break_here()
    skinny_girl:thaw(TRUE)
    break_here()
    skinny_girl:play_chore(passoutgirl_get_shooter, "passoutgirl.cos")
    manny:wait_for_actor()
    skinny_girl:wait_for_chore(passoutgirl_get_shooter, "passoutgirl.cos")
    skinny_girl:run_chore(passoutgirl_drink_shooter, "passoutgirl.cos")
    skinny_girl:run_chore(passoutgirl_faint, "passoutgirl.cos")
    skinny_girl:freeze()
    local1, local2, local3 = GetActorNodeLocation(beat_waiter.hActor, 4)
    manny:head_look_at_point(local1, local2, local3)
    beat_waiter:head_look_at_manny()
    sleep_for(1000)
    manny:shrug_gesture()
    sleep_for(1000)
    manny:head_look_at(bi.patrons2)
    beat_waiter:head_look_at(nil)
    bi.waiter_collisions(TRUE)
    start_script(beat_waiter.walk_and_face, beat_waiter, -0.36238399, 0.66302198, 0, 0, 104.565, 0)
    sleep_for(1000)
    manny:head_look_at(nil)
    beat_waiter:wait_for_actor()
    END_CUT_SCENE()
    beat_waiter:run_chore(waiter_idles_putdown_hooka, "waiter_idles.cos")
    beat_waiter:freeze(waiter_idles_pre_pickup_hooka, waiter_idles_pre_pickup_hooka, "waiter_idles.cos")
    beat_waiter:set_visibility(FALSE)
    bi.waiter_collisions(TRUE)
end
bi.waiter_slip_roofie_override = function() -- line 154
    kill_override()
    skinny_girl:stop_chore()
    skinny_girl:set_costume("passoutgirl.cos")
    skinny_girl:setpos(-0.86548, -0.81152, 0)
    skinny_girl:setrot(0, 250.864, 0)
    skinny_girl:put_in_set(bi)
    skinny_girl:complete_chore(passoutgirl_faint_hold, "passoutgirl.cos")
    manny:head_look_at(nil)
    beat_waiter:head_look_at(nil)
    stop_script(beat_waiter.walk_and_face)
    stop_script(manny.walk_and_face)
    manny:setpos(-0.0140883, -0.796289, 0)
    manny:setrot(0, 78.019, 0)
    beat_waiter:setpos(-0.362384, 0.663022, 0)
    beat_waiter:setrot(0, 104.565, 0)
    beat_waiter:freeze(waiter_idles_pre_pickup_hooka, waiter_idles_pre_pickup_hooka, "waiter_idles.cos")
    beat_waiter:set_visibility(FALSE)
    bi.waiter_collisions(TRUE)
end
bi.olivia_takes_stage = function() -- line 175
    if find_script(olivia.head_follow_mesh) then
        stop_script(olivia.head_follow_mesh)
    end
    olivia:head_look_at(nil)
    olivia:follow_boxes()
    olivia:put_at_object(bi.mic)
    bi:current_setup(bi_clbws)
    bi.freeze_all_beatniks()
    stop_script(olivia.new_run_idle)
    single_start_script(olivia.new_run_idle, olivia, "rest", olivia.poetry_idle_table)
end
bi.olivia_leaves_stage = function() -- line 188
    olivia:ignore_boxes()
    olivia:stop_chore(nil, "olivia_idles")
    olivia:set_collision_mode(COLLISION_OFF)
    olivia:setpos(-0.61967, -1.73342, 0.15)
    olivia:setrot(0, 207.129, 0)
    bi:current_setup(bi_olvcu)
    stop_script(olivia.new_run_idle)
    single_start_script(bi.idle_reds)
    single_start_script(bi.idle_beats)
    olivia:head_look_at_manny()
    start_script(olivia.head_follow_mesh, olivia, manny, 6)
    single_start_script(olivia.new_run_idle, olivia, "rest_pos", olivia.dialog_idle_table, "olivia_idles.cos")
end
bi.sna_event_watcher = function(arg1) -- line 203
    while 1 do
        if mc_sna_event then
            dostring(sna_events.manny[mc_sna_event])
            mc_sna_event = FALSE
        end
        if lo_sna_event then
            dostring(sna_events.lola[lo_sna_event])
            lo_sna_event = FALSE
        end
        if nk_sna_event then
            dostring(sna_events.nick[nk_sna_event])
            nk_sna_event = FALSE
        end
        if ol_sna_event then
            dostring(sna_events.olivia[ol_sna_event])
            ol_sna_event = FALSE
        end
        break_here()
    end
end
sna_events = { manny = { }, lola = { }, olivia = { }, nick = { } }
sna_events.manny[1] = "manny:say_line(\"/Snama01a/Lola?  What are you doing here?\")"
sna_events.manny[2] = "manny:say_line(\"/snama01b/This crowd doesn't go much for souvenir pictures.\")"
sna_events.manny[3] = "manny:say_line(\"/snama01c/Except, maybe of Lenin...\")"
sna_events.manny[4] = "manny:say_line(\"/snama03a/Still hung up on Max, eh?\")"
sna_events.manny[5] = "manny:say_line(\"/snama03b/Take my advice, Angel...\")"
sna_events.manny[6] = "manny:say_line(\"/snama03c/Forget about him!\")"
sna_events.manny[7] = "manny:say_line(\"/snama03d/He's a gambling racketeer.\")"
sna_events.manny[8] = "manny:say_line(\"/snama05/Oh, that hurts, baby!\")"
sna_events.lola[1] = "lola:say_line(\"/snalo02a/Shhhh! Manny, I'm on a stake-out!\")"
sna_events.lola[2] = "lola:say_line(\"/snalo02b/I'm gonna prove to Maximino once and for all that Olivia's no good for him!\")"
sna_events.lola[3] = "lola:say_line(\"/snalo04/Ha, ha. Like you?\")"
sna_events.lola[4] = "lola:say_line(\"/snalo06/Shhh! Here they come.\")"
sna_events.lola[5] = "--lola snaps photo"
sna_events.nick[1] = "virago:say_line(\"/snavi07a/Come on, sugar!\")"
sna_events.nick[2] = "virago:say_line(\"/snavi07b/How about a kiss for the road?\")"
sna_events.nick[3] = "virago:say_line(\"/snavi09/I don't, but I know a good tort when I see one.\")"
sna_events.nick[4] = "virago:say_line(\"/snavi09b/(kiss)\")"
sna_events.nick[5] = "virago:say_line(\"/snavi10/Hey!\")"
sna_events.nick[6] = "virago:say_line(\"/snavi11/If Maximino sees that, we're going to end up in matching terra cotta pots!\")"
sna_events.nick[7] = "virago:say_line(\"/hlvi170/Rrrr.\")"
sna_events.olivia[1] = "olivia:say_line(\"/snaol08a/Oh, ick. Don't let me down, Nick.\")"
sna_events.olivia[2] = "olivia:say_line(\"/snaol08b/You're a lawyer...\")"
sna_events.olivia[3] = "olivia:say_line(\"/snaol08c/You're not supposed to have feelings.\")"
sna_events.olivia[4] = "olivia:say_line(\"/snaol12/Don't be silly.\")"
sna_events.olivia[5] = "olivia:say_line(\"/snaol13/(puff) He wouldn't hurt me.\")"
sna_events.olivia[6] = "olivia:say_line(\"/snaol14/He LOVES me!\")"
sna_events.olivia[7] = "olivia:say_line(\"/snaol15a/Manny! At last we're alone.\")"
sna_events.olivia[8] = "olivia:say_line(\"/snaol15b/Tell me. How are the bourgeois?\")"
bi.snapshot = function(arg1) -- line 260
    local local1, local2, local3
    bi.seen_kiss = TRUE
    hl.nick_gone = FALSE
    bi.kiss_trigger_set = FALSE
    stop_script(bi.idle_reds)
    START_CUT_SCENE()
    bi:switch_to_set()
    bi:current_setup(bi_kitdr)
    LoadCostume("olivia_idles.cos")
    LoadCostume("nk_sna.cos")
    LoadCostume("ol_sna.cos")
    LoadCostume("lo_sna.cos")
    LoadCostume("mc_sna.cos")
    bi.office_door:play_chore(bi_olivia_closed)
    if not lola then
        lola = Actor:create(nil, nil, nil, "/bitx411/")
    end
    lola:set_costume("lo_sna.cos")
    lola:put_in_set(bi)
    lola:ignore_boxes()
    lola:set_talk_color(Aqua)
    lola:set_mumble_chore(lo_sna_mumble, "lo_sna.cos")
    lola:set_head(3, 4, 5, 165, 28, 80)
    lola:set_turn_rate(140)
    lola:set_talk_chore(1, lo_sna_stop_talk)
    lola:set_talk_chore(2, lo_sna_a)
    lola:set_talk_chore(3, lo_sna_c)
    lola:set_talk_chore(4, lo_sna_e)
    lola:set_talk_chore(5, lo_sna_f)
    lola:set_talk_chore(6, lo_sna_l)
    lola:set_talk_chore(7, lo_sna_m)
    lola:set_talk_chore(8, lo_sna_o)
    lola:set_talk_chore(9, lo_sna_t)
    lola:set_talk_chore(10, lo_sna_u)
    lola:set_softimage_pos(0.61479998, 1.5103, 19.7619)
    lola:setrot(0, 39.396999, 0)
    manny:stop_chore()
    manny:setpos(-0.0436312, -1.0274, 0)
    manny:setrot(0, 180.133, 0)
    LoadCostume("mc_sna.cos")
    set_override(bi.snapshot_override)
    break_here()
    lola:play_chore(lo_sna_intro)
    manny:walk_and_face(0.041620001, -1.24974, 0.15189999, 0, 180, 0)
    manny:clear_hands()
    manny:ignore_boxes()
    manny:push_costume("mc_sna.cos")
    manny:set_softimage_pos(0.41620001, 1.5190001, 12.4974)
    manny:setrot(0, 180, 0)
    break_here()
    manny:say_line("/snama01a/")
    manny:play_chore(mc_sna_snama01a, "mc_sna.cos")
    wait_for_message()
    manny:play_chore(mc_sna_snama01b, "mc_sna.cos")
    manny:say_line("/snama01b/")
    wait_for_message()
    manny:play_chore(mc_sna_snama01c, "mc_sna.cos")
    manny:say_line("/snama01c/")
    wait_for_message()
    bi:current_setup(bi_lolcu)
    lola:head_look_at_point({ x = 0.12342, y = -1.68214, z = 0.60780001 })
    lola:play_chore(lo_sna_snalo02a)
    lola:say_line("/snalo02a/")
    wait_for_message()
    lola:play_chore(lo_sna_snalo02b)
    lola:say_line("/snalo02b/")
    wait_for_message()
    bi:current_setup(bi_kitdr)
    lola:head_look_at(nil)
    manny:say_line("/snama03a/")
    manny:play_chore(mc_sna_snama03a, "mc_sna.cos")
    wait_for_message()
    manny:say_line("/snama03b/")
    manny:play_chore(mc_sna_snama03b, "mc_sna.cos")
    wait_for_message()
    manny:say_line("/snama03c/")
    manny:play_chore(mc_sna_snama03c, "mc_sna.cos")
    wait_for_message()
    bi:current_setup(bi_lolcu)
    manny:say_line("/snama03d/")
    manny:play_chore(mc_sna_snama03d, "mc_sna.cos")
    wait_for_message()
    lola:head_look_at_point({ x = 0.12342, y = -1.68214, z = 0.60780001 })
    lola:play_chore(lo_sna_snalo04)
    lola:say_line("/snalo04/")
    wait_for_message()
    bi:current_setup(bi_kitdr)
    manny:play_chore(mc_sna_snama05, "mc_sna.cos")
    manny:say_line("/snama05/")
    wait_for_message()
    start_sfx("biApprch.wav")
    sleep_for(1500)
    bi:current_setup(bi_lolcu)
    lola:head_look_at(nil)
    lola:play_chore(lo_sna_snalo06)
    lola:say_line("/snalo06/")
    wait_for_message()
    bi:current_setup(bi_kitdr)
    lola:stop_chore()
    lola:play_chore(lo_sna_nk_ol_enter)
    manny:stop_chore()
    manny:play_chore(mc_sna_nk_ol_enter, "mc_sna.cos")
    sleep_for(2000)
    lola:wait_for_chore(lo_sna_nk_ol_enter)
    lola:freeze()
    manny:freeze()
    olivia:put_in_set(bi)
    olivia:ignore_boxes()
    olivia:set_costume("ol_sna.cos")
    olivia:set_mumble_chore(ol_sna_mumble, "ol_sna.cos")
    olivia:set_talk_chore(1, ol_sna_stop_talk)
    olivia:set_talk_chore(2, ol_sna_a)
    olivia:set_talk_chore(3, ol_sna_c)
    olivia:set_talk_chore(4, ol_sna_e)
    olivia:set_talk_chore(5, ol_sna_f)
    olivia:set_talk_chore(6, ol_sna_l)
    olivia:set_talk_chore(7, ol_sna_m)
    olivia:set_talk_chore(8, ol_sna_o)
    olivia:set_talk_chore(9, ol_sna_t)
    olivia:set_talk_chore(10, ol_sna_u)
    olivia:set_collision_mode(COLLISION_OFF)
    olivia:setpos(-0.88085002, -1.77821, 0.15586001)
    olivia:setrot(0, 293.21201, 0)
    virago:put_in_set(bi)
    virago:ignore_boxes()
    virago:set_costume("nk_sna.cos")
    virago:set_mumble_chore(nk_sna_mumble, "nk_sna.cos")
    virago:set_talk_chore(1, nk_sna_stop_talk)
    virago:set_talk_chore(2, nk_sna_a)
    virago:set_talk_chore(3, nk_sna_c)
    virago:set_talk_chore(4, nk_sna_e)
    virago:set_talk_chore(5, nk_sna_f)
    virago:set_talk_chore(6, nk_sna_l)
    virago:set_talk_chore(7, nk_sna_m)
    virago:set_talk_chore(8, nk_sna_o)
    virago:set_talk_chore(9, nk_sna_t)
    virago:set_talk_chore(10, nk_sna_u)
    virago:setpos(-1.02335, -1.88301, 0.15586001)
    virago:setrot(0, 293.20099, 0)
    break_here()
    bi.office_door:play_chore(bi_olivia_swing_open)
    start_sfx("lovedrop.wav")
    olivia:play_chore(ol_sna_intro, "ol_sna.cos")
    virago:play_chore(nk_sna_intro, "nk_sna.cos")
    virago:wait_for_chore(nk_sna_intro, "nk_sna.cos")
    bi:current_setup(bi_olvcu)
    virago:play_chore(nk_sna_snavi07a, "nk_sna.cos")
    virago:say_line("/snavi07a/")
    wait_for_message()
    virago:play_chore(nk_sna_snavi07b, "nk_sna.cos")
    virago:say_line("/snavi07b/")
    wait_for_message()
    olivia:play_chore(ol_sna_snaol08a, "ol_sna.cos")
    olivia:say_line("/snaol08a/")
    wait_for_message()
    olivia:play_chore(ol_sna_snaol08b, "ol_sna.cos")
    olivia:say_line("/snaol08b/")
    wait_for_message()
    olivia:play_chore(ol_sna_snaol08c, "ol_sna.cos")
    olivia:say_line("/snaol08c/")
    wait_for_message()
    virago:play_chore(nk_sna_snavi09, "nk_sna.cos")
    sleep_for(100)
    virago:say_line("/snavi09/")
    virago:wait_for_chore(nk_sna_snavi09, "nk_sna.cos")
    olivia:play_chore(ol_sna_kiss, "ol_sna.cos")
    virago:run_chore(nk_sna_kiss, "nk_sna.cos")
    virago:say_line("/snavi09b/")
    lola:thaw()
    manny:thaw()
    break_here()
    TurnLightOn("flash", TRUE)
    sleep_for(150)
    TurnLightOn("flash", FALSE)
    bi:current_setup(bi_kitdr)
    lola:play_chore(lo_sna_flash_run, "lo_sna.cos")
    olivia:play_chore(ol_sna_up, "ol_sna.cos")
    virago:play_chore(nk_sna_lookup, "nk_sna.cos")
    virago:wait_for_chore(nk_sna_lookup, "nk_sna.cos")
    virago:play_chore(nk_sna_snavi10, "nk_sna.cos")
    virago:say_line("/snavi10/")
    wait_for_message()
    manny:head_look_at(bi.olivia_obj)
    olivia:play_chore(ol_sna_look_nk, "ol_sna.cos")
    virago:play_chore(nk_sna_snavi11, "nk_sna.cos")
    virago:say_line("/snavi11/")
    sleep_for(2000)
    bi:current_setup(bi_olvcu)
    manny:default()
    manny:setpos(-0.306454, -1.42422, 0.15000001)
    manny:setrot(0, 235.17599, 0)
    wait_for_message()
    olivia:say_line("/snaol12/")
    wait_for_message()
    olivia:play_chore(ol_sna_smoke, "ol_sna.cos")
    olivia:say_line("/snaol13/")
    virago:run_chore(nk_sna_look_ol, "nk_sna.cos")
    wait_for_message()
    olivia:play_chore(ol_sna_turn, "ol_sna.cos")
    olivia:say_line("/snaol14/")
    wait_for_message()
    virago:play_chore(nk_sna_hlvi170, "nk_sna.cos")
    wait_for_message()
    virago:say_line("/hlvi170/")
    wait_for_message()
    bi:current_setup(bi_kitdr)
    while virago:is_choring(nk_sna_hlvi170, TRUE, "nk_sna.cos") do
        local1, local2, local3 = GetActorNodeLocation(virago.hActor, 5)
        manny:head_look_at_point(local1, local2, local3)
        break_here()
    end
    system:lock_display()
    bi:current_setup(bi_clbws)
    bi.freeze_all_beatniks()
    lola:setpos(0.043258, 1.21296, 0.1569)
    lola:setrot(0, 98.486, 0)
    lola:stop_chore()
    virago:setpos(-0.024041999, -0.81764102, 0)
    virago:setrot(0, 349.323, 0)
    virago:stop_chore()
    break_here()
    system:unlock_display()
    lola:play_chore(lo_sna_run, "lo_sna.cos")
    virago:play_chore(nk_sna_run, "nk_sna.cos")
    olivia:say_line("/snaol15a/")
    sleep_for(200)
    manny:head_look_at(bi.olivia_obj)
    sleep_for(200)
    start_script(manny.walkto_object, manny, bi.olivia_obj)
    sleep_for(200)
    virago:wait_for_chore(nk_sna_run, "nk_sna.cos")
    system:lock_display()
    virago:free()
    lola:free()
    bi:current_setup(bi_olvcu)
    olivia:default()
    olivia:set_collision_mode(COLLISION_OFF)
    olivia:setpos(-0.61966997, -1.73342, 0.15000001)
    olivia:setrot(0, 207.129, 0)
    single_start_script(olivia.new_run_idle, olivia, "gest", olivia.dialog_idle_table, "olivia_idles.cos")
    break_here()
    system:unlock_display()
    wait_for_message()
    olivia:say_line("/snaol15b/")
    wait_for_message()
    manny:say_line("/bima222/")
    manny:tilt_head_gesture()
    wait_for_message()
    olivia:say_line("/biol223/")
    wait_for_message()
    cameraman_disabled = TRUE
    END_CUT_SCENE()
    cameraman_disabled = TRUE
    Dialog:run("ol1", "dlg_olivia.lua")
end
bi.snapshot_override = function() -- line 563
    kill_override()
    lola:free()
    virago:free()
    ForceRefresh()
    shut_up_everybody()
    manny:default()
    manny:follow_boxes()
    manny:put_at_object(bi.olivia_obj)
    manny:set_look_rate(130)
    manny:head_look_at(bi.olivia_obj)
    bi.set_up_states()
    bi.set_up_actors()
    bi:current_setup(bi_kitdr)
    if not ol1 then
        dofile("dlg_olivia.lua")
    end
    ol1.been = TRUE
end
bi.push_out_door = function(arg1) -- line 581
    if not manny:find_sector_name("bk_door") then
        soft_script()
        manny:walkto_object(bi.bk_door)
        manny:wait_for_actor()
    end
    START_CUT_SCENE()
    bi.bk_door:play_chore(bi_door_swing_open)
    manny:walkto_object(bi.bk_door, TRUE)
    manny:wait_for_actor()
    bi.bk_door:run_chore(bi_door_swing_closed)
    break_here()
    bk:push_in_door()
    END_CUT_SCENE()
end
bi.reunion = function(arg1) -- line 597
    local local1 = olivia:getpos()
    olivia.reunited = TRUE
    START_CUT_SCENE()
    bi.office_door:play_chore(4)
    start_sfx("DorTUOpn.wav")
    olivia:set_visibility(TRUE)
    manny:head_look_at_point(local1.x, local1.y, local1.z + 0.5)
    olivia:say_line("/biol396/")
    wait_for_message()
    olivia:say_line("/biol397/")
    wait_for_message()
    manny:say_line("/bima398/")
    wait_for_message()
    manny:say_line("/bima399/")
    wait_for_message()
    olivia:say_line("/biol400/")
    wait_for_message()
    olivia:say_line("/biol401/")
    wait_for_message()
    olivia:say_line("/biol402/")
    if arg1 then
        olivia:walkto(-0.310821, -1.85579, 0.15000001, 0, -348.32199, 0)
        olivia:wait_for_actor()
        olivia:ignore_boxes()
        olivia:setpos(-0.81164098, -1.61875, 0.15000001)
        olivia:setrot(0, -459.47601, 0)
        olivia:play_chore(olivia_idles_rest_pos, "olivia_idles.cos")
        olivia:set_visibility(FALSE)
    end
    wait_for_message()
    bi.office_door:play_chore(5)
    start_sfx("DorTUCls.wav")
    olivia:set_visibility(FALSE)
    manny:head_look_at(nil)
    manny:say_line("/bima403/")
    END_CUT_SCENE()
end
bi.critique_poem = function(arg1) -- line 641
    START_CUT_SCENE()
    bi.critiqued = TRUE
    bi:alexi_talking()
    set_override(bi.critique_poem_override)
    start_script(bi.manny_follow_conversation)
    manny:say_line("/bima001/")
    wait_for_message()
    slisko:say_line("/bisl002/")
    wait_for_message()
    slisko:say_line("/bisl003/")
    wait_for_message()
    alexi:say_line("/bial004/")
    wait_for_message()
    alexi:say_line("/bial005/")
    wait_for_message()
    alexi:say_line("/bial006/")
    wait_for_message()
    gunnar:say_line("/bigu007/")
    wait_for_message()
    gunnar:say_line("/bigu008/")
    wait_for_message()
    gunnar:say_line("/bigu009/")
    bi:alexi_not_talking()
    END_CUT_SCENE()
    stop_script(bi.manny_follow_conversation)
end
bi.critique_poem_override = function() -- line 669
    kill_override()
    shut_up_everybody()
    stop_script(bi.manny_follow_conversation)
    bi:alexi_not_talking()
end
bi.rusty_anchor_poem = function(arg1) -- line 676
    START_CUT_SCENE()
    if not bi.read_rusty_anchor then
        bi.read_rusty_anchor = TRUE
        olivia:say_line("/biol010/")
        wait_for_message()
        olivia:say_line("/biol011/")
        wait_for_message()
        olivia:say_line("/biol012/")
        wait_for_message()
    else
        olivia:say_line("/biol013/")
        wait_for_message()
        olivia:say_line("/biol014/")
    end
    wait_for_message()
    bi.olivia_takes_stage()
    sleep_for(1000)
    olivia:say_line("/biol015/")
    wait_for_message()
    olivia:say_line("/biol016/")
    wait_for_message()
    olivia:say_line("/biol017/")
    wait_for_message()
    olivia:say_line("/biol018/")
    wait_for_message()
    olivia:say_line("/biol019/")
    wait_for_message()
    olivia:say_line("/biol020/")
    wait_for_message()
    olivia:say_line("/biol021/")
    wait_for_message()
    olivia:say_line("/biol022/")
    wait_for_message()
    bi.olivia_leaves_stage()
    END_CUT_SCENE()
    sleep_for(500)
    manny:say_line("/bima023/")
    wait_for_message()
    olivia:say_line("/biol024/")
end
bi.bother_commies = function(arg1) -- line 732
    START_CUT_SCENE()
    bi.commies.bug_count = bi.commies.bug_count + 1
    stop_script(bi.idle_reds)
    if bi.commies.bug_count < 2 then
        alexi:thaw(TRUE)
        alexi.body:thaw(TRUE)
        alexi.body:set_visibility(FALSE)
        alexi:complete_chore(alexi_meshes_show_all, "alexi_meshes.cos")
    end
    slisko:thaw(TRUE)
    slisko.body:thaw(TRUE)
    slisko.body:set_visibility(FALSE)
    slisko:complete_chore(slisko_meshes_show_everything, "slisko_meshes.cos")
    start_script(bi.manny_follow_conversation)
    slisko:stop_chore(slisko_foot_bounce, "slisko.cos")
    slisko:play_chore(slisko_rest, "slisko.cos")
    if bi.commies.bug_count == 1 then
        manny:walkto(bi.commies)
        manny:head_look_at(nil)
        manny:wait_for_actor()
        manny:play_chore(mc_a, "mc.cos")
        manny:hand_gesture()
        sleep_for(750)
        slisko:say_line("/bisl025/")
        manny:play_chore(mc_stop_talk, "mc.cos")
        slisko:wait_for_message()
        wait_for_message()
        slisko:say_line("/bisl026/")
        wait_for_message()
        gunnar:say_line("/bigu027/")
        wait_for_message()
        alexi:say_line("/bial028/")
        wait_for_message()
        alexi:say_line("/bial029/")
        alexi:wait_for_message()
        manny:say_line("/bima030/")
        wait_for_message()
        slisko:say_line("/bisl031/")
        sleep_for(500)
        slisko:head_look_at_point(slisko.gunnar_point)
        sleep_for(2000)
        slisko:run_chore(slisko_gesture1, "slisko.cos")
        wait_for_message()
        slisko:say_line("/bisl032/")
        break_here()
        slisko:run_chore(slisko_point, "slisko.cos")
        break_here()
        sleep_for(1000)
        slisko:run_chore(slisko_gesture2, "slisko.cos")
        sleep_for(500)
        slisko:run_chore(slisko_gesture4, "slisko.cos")
        break_here()
        slisko:run_chore(slisko_gesture5, "slisko.cos")
        slisko:run_chore(slisko_gesture6, "slisko.cos")
        wait_for_message()
        slisko:play_chore(slisko_back_to_rest, "slisko.cos")
        alexi:say_line("/bial033/")
        wait_for_message()
        alexi:say_line("/bial034/")
        wait_for_message()
    elseif bi.commies.bug_count == 2 then
        manny:say_line("/bima035/")
        wait_for_message()
        gunnar:say_line("/bigu036/")
        wait_for_message()
        manny:say_line("/bima037/")
        manny:shrug_gesture()
        wait_for_message()
        slisko:say_line("/bisl038/")
        break_here()
        slisko:play_chore(slisko_gesture1, "slisko.cos")
        wait_for_message()
        slisko:play_chore(slisko_back_to_rest, "slisko.cos")
        manny:say_line("/bima039/")
        manny:tilt_head_gesture()
    elseif bi.commies.bug_count == 3 then
        manny:say_line("/bima040/")
        wait_for_message()
        gunnar:say_line("/bigu041/")
        wait_for_message()
        gunnar:say_line("/bigu042/")
        wait_for_message()
        slisko:hand_up()
        slisko:say_line("/bisl043/")
        wait_for_message()
        slisko:hand_down()
    elseif bi.commies.bug_count > 3 then
        manny:say_line("/bima044/")
        manny:head_forward_gesture()
        wait_for_message()
    end
    if bi.commies.bug_count == 4 then
        slisko:say_line("/bisl045/")
        sleep_for(1000)
        slisko:start_jivin()
        wait_for_message()
        slisko:stop_jivin()
    elseif bi.commies.bug_count == 5 then
        slisko:start_jivin()
        slisko:say_line("/bisl046/")
        wait_for_message()
        slisko:stop_jivin()
        slisko:say_line("/bisl047/")
    elseif bi.commies.bug_count == 6 then
        slisko:play_chore(slisko_look_at_gunar, "slisko.cos")
        slisko:say_line("/bisl048/")
        wait_for_message()
        slisko:play_chore(slisko_back_to_rest, "slisko.cos")
        slisko:say_line("/bisl049/")
        manny:twist_head_gesture()
        sleep_for(3000)
        slisko:start_pointing()
        wait_for_message()
        slisko:stop_pointing()
    elseif bi.commies.bug_count == 7 then
        slisko:say_line("/bisl050/")
        sleep_for(2000)
        slisko:start_jivin()
        wait_for_message()
        slisko:stop_jivin()
    elseif bi.commies.bug_count == 8 then
        slisko:say_line("/bisl051/")
        sleep_for(3000)
        slisko:hand_up()
        wait_for_message()
        slisko:hand_down()
    elseif bi.commies.bug_count > 8 then
        slisko:hand_up()
        slisko:say_line("/bisl052/")
        wait_for_message()
        sleep_for(1000)
        slisko:hand_down()
    end
    wait_for_message()
    slisko:wait_for_chore(nil, "slisko.cos")
    slisko:complete_chore(slisko_rest, "slisko.cos")
    sleep_for(1000)
    END_CUT_SCENE()
    if not alexi.frozen then
        alexi:freeze()
    end
    stop_script(bi.manny_follow_conversation)
    start_script(bi.idle_reds)
end
bi.befriend_commies = function(arg1) -- line 899
    START_CUT_SCENE("no head")
    manny:clear_hands()
    manny:point_gesture()
    manny:say_line("/bima053/")
    wait_for_message()
    manny:say_line("/bima054/")
    wait_for_message()
    if bi.commies.befriended then
        gunnar:say_line("/bigu129/")
    else
        bi.commies.befriended = TRUE
        bi:alexi_talking()
        manny:head_look_at(bi.commies)
        slisko:say_line("/bisl055/")
        wait_for_message()
        alexi:say_line("/bial056/")
        wait_for_message()
        manny:head_look_at(bi.commies2)
        alexi:say_line("/bial057/")
        wait_for_message()
        manny:walkto_object(bi.commies)
        manny:pull_out_item(cf.letters)
        manny:say_line("/bima058/")
        wait_for_message()
        music_state:set_sequence(seqBefriendCommies)
        alexi:say_line("/bial059/")
        wait_for_message()
        alexi:say_line("/bial060/")
        wait_for_message()
        gunnar:say_line("/bigu061/")
        wait_for_message()
        alexi:say_line("/bial062/")
        wait_for_message()
        alexi:say_line("/bial063/")
        wait_for_message()
        manny:head_look_at(bi.commies)
        start_script(manny.clear_hands, manny)
        gunnar:say_line("/bigu064/")
        wait_for_message()
        wait_for_script(manny.clear_hands)
        manny:twist_head_gesture()
        manny:say_line("/bima065/")
        wait_for_message()
        alexi:say_line("/bial066/")
        wait_for_message()
        slisko:say_line("/bisl067/")
        wait_for_message()
        manny:hand_gesture()
        manny:say_line("/bima068/")
        wait_for_message()
        time_to_look = FALSE
        manny:head_look_at(bi.bk_door)
        sleep_for(500)
        manny:head_look_at(bi.sign)
        sleep_for(500)
        manny:head_look_at(bi.commies2)
        sleep_for(1000)
        time_to_look = TRUE
        manny:head_forward_gesture()
        manny:say_line("/bima069/")
        wait_for_message()
        alexi:say_line("/bial070/")
        wait_for_message()
        bi:alexi_not_talking()
    end
    END_CUT_SCENE()
end
bi.set_up_states = function() -- line 973
    if in_year_four then
        bi.commies:make_untouchable()
        bi.commies2:make_untouchable()
        bi.book:make_untouchable()
        bi.patrons1:make_untouchable()
        bi.patrons2:make_untouchable()
        bi.olivia_obj:make_untouchable()
        box_off("inside_office")
        box_off("office_trigger")
        NewObjectState(bi_clbws, OBJSTATE_UNDERLAY, "bi_patron1_gone.bm", nil, TRUE)
        NewObjectState(bi_clbws, OBJSTATE_UNDERLAY, "bi_patron2_gone.bm")
        bi.sign:set_object_state("bi_yr_4.cos")
        bi.sign:play_chore(0)
    elseif bi.seen_kiss then
        bi.office_door:play_chore(bi_olivia_opened)
    end
end
bi.set_up_actors = function() -- line 994
    if in_year_four then
        bi.seen_kiss = TRUE
        bi.kiss_trigger_set = FALSE
        if not alexi then
            alexi = Actor:create()
        end
        if not slisko then
            slisko = Actor:create()
        end
        if not gunnar then
            gunnar = Actor:create()
        end
        if not cig_girl then
            cig_girl = Actor:create()
        end
        if not hooka_guy1 then
            hooka_guy1 = Actor:create()
        end
        if not hooka_guy2 then
            hooka_guy2 = Actor:create()
        end
        if not beat_waiter then
            beat_waiter = Actor:create()
        end
        if not skinny_girl then
            skinny_girl = Actor:create()
        end
        olivia:default()
        olivia:put_in_set(bi)
        olivia:set_collision_mode(COLLISION_OFF)
        olivia:setpos(-0.811641, -1.61875, 0.15)
        olivia:setrot(0, -459.476, 0)
        olivia:play_chore(olivia_idles_rest_pos, "olivia_idles.cos")
        olivia:set_visibility(FALSE)
    else
        system:lock_display()
        if bi.seen_kiss then
            olivia:default()
            olivia:put_in_set(bi)
            olivia:set_collision_mode(COLLISION_OFF)
            olivia:setpos(-0.61967, -1.73342, 0.15)
            olivia:setrot(0, 207.129, 0)
            single_start_script(olivia.new_run_idle, olivia, "rest_pos", olivia.standing_idle_table, "olivia_idles.cos")
        end
        if not skinny_girl then
            skinny_girl = Actor:create(nil, nil, nil, "patron")
        end
        skinny_girl:put_in_set(bi)
        if skinny_girl.passed_out then
            skinny_girl:set_costume("passoutgirl.cos")
            skinny_girl:setpos(-0.86548, -0.81152, 0)
            skinny_girl:setrot(0, 250.864, 0)
            skinny_girl:play_chore(passoutgirl_faint_hold, "passoutgirl.cos")
        else
            skinny_girl:set_costume("skinny_girl.cos")
            skinny_girl:setpos(-0.86548, -0.81152, 0)
            skinny_girl:setrot(0, 610.864, 0)
            skinny_girl:play_chore(0)
        end
        if not cig_girl then
            cig_girl = Actor:create(nil, nil, nil, "patron")
        end
        cig_girl:put_in_set(bi)
        cig_girl:set_costume("cig_girl.cos")
        cig_girl:setpos(0.55717, -0.09235, -0.09568)
        cig_girl:setrot(0, 159.987, 0)
        cig_girl:play_chore(cig_girl_gesture2, "cig_girl.cos")
        if not hooka_guy1 then
            hooka_guy1 = Actor:create(nil, nil, nil, "patron")
        end
        hooka_guy1:set_costume(nil)
        hooka_guy1:set_costume("hooka_guys.cos")
        hooka_guy1:push_costume("alexi_meshes.cos")
        hooka_guy1:put_in_set(bi)
        hooka_guy1:setpos(-0.35879, -1.15406, 0)
        hooka_guy1:setrot(0, 35.042, 0)
        hooka_guy1:play_chore(hooka_guys_rest, "hooka_guys.cos")
        if not hooka_guy2 then
            hooka_guy2 = Actor:create(nil, nil, nil, "patron")
        end
        hooka_guy2:set_costume(nil)
        hooka_guy2:set_costume("hooka_guys.cos")
        hooka_guy2:push_costume("alexi_meshes.cos")
        hooka_guy2:put_in_set(bi)
        hooka_guy2:setpos(0.86438, -0.19216, 0)
        hooka_guy2:setrot(0, 98.64, 0)
        hooka_guy2:play_chore(hooka_guys_rest, "hooka_guys.cos")
        alexi:default()
        gunnar:default()
        slisko:default()
        if bi.book.touchable then
            if not bi.book.act then
                bi.book.act = Actor:create()
            end
            bi.book.act:set_costume("book.cos")
            bi.book.act:put_in_set(bi)
            bi.book.act:setpos(0.6224, -1.0065, 0.2373)
            bi.book.act:setrot(0, 239.54, 0)
        else
            bi.book.act:put_in_set(nil)
        end
        break_here()
        skinny_girl:freeze()
        cig_girl:freeze()
        hooka_guy1:freeze()
        hooka_guy2:freeze()
        alexi:play_chore(alexi_rest, "alexi.cos")
        single_start_script(bi.idle_reds)
        single_start_script(bi.idle_beats)
        system:unlock_display()
        manny:set_collision_mode(COLLISION_OFF)
    end
end
bi.update_music_state = function(arg1) -- line 1123
    if in_year_four then
        if bi:current_setup() == bi_clbws then
            return stateBI_CLBYR4
        else
            return stateBI_KITYR4
        end
    else
        return stateBI
    end
end
bi.enter = function(arg1) -- line 1137
    start_script(bi.set_up_states)
    start_script(bi.set_up_actors)
    bi.bk_door.hObjectState = bi:add_object_state(bi_kitdr, "bi_door.bm", "bi_door.zbm", OBJSTATE_STATE, FALSE)
    bi.bk_door:set_object_state("bi_door.cos")
    bi.office_door.hObjectState = bi:add_object_state(bi_kitdr, "bi_olivia.bm", "bi_olivia.zbm", OBJSTATE_STATE, FALSE)
    bi.office_door:set_object_state("bi_olivia.cos")
    bi.be_door:make_untouchable()
    TurnLightOn("flash", FALSE)
    if not in_year_four then
        if bi.waiter_cue and not bi.seen_waiter then
            start_script(bi.first_see_waiter)
        end
        bi:add_ambient_sfx({ "bongHit.wav", "bongExhl.wav" }, { min_delay = 24000, max_delay = 45000, min_volume = 10, max_volume = 40 })
    end
    SetShadowColor(10, 10, 10)
    SetActiveShadow(manny.hActor, 0)
    SetActorShadowPoint(manny.hActor, -0.222365, 1.73026, 0.966)
    SetActorShadowPlane(manny.hActor, "shadow1")
    AddShadowPlane(manny.hActor, "shadow1")
    SetActiveShadow(manny.hActor, 1)
    SetActorShadowPoint(manny.hActor, -0.232125, 0.0728992, 1.272)
    SetActorShadowPlane(manny.hActor, "stage_shadow")
    AddShadowPlane(manny.hActor, "stage_shadow")
    SetActiveShadow(manny.hActor, 2)
    SetActorShadowPoint(manny.hActor, -0.232125, 0.0728992, 1.272)
    SetActorShadowPlane(manny.hActor, "stage_shadow2")
    AddShadowPlane(manny.hActor, "stage_shadow2")
    SetActiveShadow(manny.hActor, 3)
    SetActorShadowPoint(manny.hActor, -0.575718, -1.75774, 2.982)
    SetActorShadowPlane(manny.hActor, "shadow4")
    AddShadowPlane(manny.hActor, "shadow4")
    SetActiveShadow(olivia.hActor, 0)
    SetActorShadowPoint(olivia.hActor, -0.232125, 0.0728992, 1.272)
    SetActorShadowPlane(olivia.hActor, "stage_shadow")
    AddShadowPlane(olivia.hActor, "stage_shadow")
    SetActiveShadow(olivia.hActor, 1)
    SetActorShadowPoint(olivia.hActor, -0.232125, 0.0728992, 1.272)
    SetActorShadowPlane(olivia.hActor, "stage_shadow2")
    AddShadowPlane(olivia.hActor, "stage_shadow2")
    SetActiveShadow(olivia.hActor, 2)
    SetActorShadowPoint(olivia.hActor, -0.575718, -1.75774, 2.982)
    SetActorShadowPlane(olivia.hActor, "shadow4")
    AddShadowPlane(olivia.hActor, "shadow4")
end
bi.camerachange = function(arg1, arg2, arg3) -- line 1196
    if arg3 == bi_kitdr and bi.kiss_trigger_set and not bi.seen_kiss then
        start_script(cut_scene.snapshot)
    elseif arg3 == bi_clbws and bi.roofie_trigger_set then
        start_script(bi.waiter_slip_roofie)
    end
    if in_year_four then
        music_state:update(system.currentSet)
    end
end
bi.exit = function(arg1) -- line 1209
    box_on("step_access")
    stop_script(bi.idle_reds)
    stop_script(bi.idle_beats)
    if virago then
        virago:free()
    end
    if lola then
        lola:free()
    end
    bi.waiter_collisions(FALSE)
    stop_script(olivia.new_run_idle)
    olivia:free()
    KillActorShadows(manny.hActor)
    KillActorShadows(olivia.hActor)
    manny:set_collision_mode(COLLISION_OFF)
    bi.bk_door:free_object_state()
    bi.office_door:free_object_state()
    bi.book.act:free()
    if find_script(olivia.head_follow_mesh) then
        stop_script(olivia.head_follow_mesh)
    end
end
bi.commies = Object:create(bi, "/bitx412/revolutionaries", 0.74422902, -0.81004298, 0.38960001, { range = 0.60000002 })
bi.commies.use_pnt_x = 0.43022901
bi.commies.use_pnt_y = -0.64764303
bi.commies.use_pnt_z = 0
bi.commies.use_rot_x = 0
bi.commies.use_rot_y = -137.683
bi.commies.use_rot_z = 0
bi.commies.bug_count = 0
bi.commies.befriended = FALSE
bi.commies.lookAt = function(arg1) -- line 1250
    manny:say_line("/bima071/")
end
bi.commies.pickUp = function(arg1) -- line 1254
end
bi.commies.use = function(arg1) -- line 1257
    if bi.just_read_poem and not bi.critiqued then
        bi:critique_poem()
    elseif bi.commies.befriended then
        bi:befriend_commies()
    else
        bi:bother_commies()
    end
end
bi.commies.use_letters = function(arg1) -- line 1269
    bi.befriend_commies()
end
bi.commies2 = Object:create(bi, "/bitx413/revolutionaries", 0.452629, -1.04274, 0.41, { range = 0.60000002 })
bi.commies2.use_pnt_x = 0.43022901
bi.commies2.use_pnt_y = -0.64764303
bi.commies2.use_pnt_z = 0
bi.commies2.use_rot_x = 0
bi.commies2.use_rot_y = -137.683
bi.commies2.use_rot_z = 0
bi.commies2.parent = bi.commies
bi.book = Object:create(bi, "/bitx414/book", 0.61539203, -0.93146002, 0.22750001, { range = 0.60000002 })
bi.book.use_pnt_x = 0.43889201
bi.book.use_pnt_y = -0.81496
bi.book.use_pnt_z = 0
bi.book.use_rot_x = 0
bi.book.use_rot_y = 599.90601
bi.book.use_rot_z = 0
bi.book.lookAt = function(arg1) -- line 1294
    arg1.seen = TRUE
    manny:say_line("/bima072/")
    if arg1.owner == manny then
        START_CUT_SCENE()
        wait_for_message()
        manny:say_line("/bima073/")
        wait_for_message()
        manny:say_line("/bima074/")
        wait_for_message()
        manny:say_line("/bima075/")
        END_CUT_SCENE()
    end
end
bi.book.reset = function(arg1) -- line 1309
    bi.book:make_touchable()
    bi.book:free()
    manny:stop_chore()
    bi.book.act:put_in_set(bi)
end
bi.book.use = function(arg1) -- line 1316
    if arg1.owner == manny then
        if not arg1.seen then
            START_CUT_SCENE()
            arg1:lookAt()
            wait_for_message()
            END_CUT_SCENE()
        else
            manny:say_line("/bima076/")
        end
    else
        START_CUT_SCENE("no head")
        if bi.commies.befriended then
            manny:head_look_at(bi.commies2)
            preload_sfx("getBook.wav")
            preload_sfx("getBook.wav")
            manny:say_line("/bima077/")
            wait_for_message()
            gunnar:say_line("/bigu078/")
            wait_for_message()
            manny:head_look_at(nil)
            manny:walkto_object(arg1)
            manny:wait_for_actor()
            manny:set_rest_chore(nil)
            manny:stop_chore()
            manny:play_chore(mc_pickup_book, "mc.cos")
            sleep_for(375)
            start_sfx("getBook.wav")
            bi.book:make_untouchable()
            bi.book.act:put_in_set(nil)
            manny:wait_for_chore(mc_pickup_book, "mc.cos")
            manny:stop_chore(mc_pickup_book, "mc.cos")
            manny:generic_pickup(bi.book)
            manny:set_rest_chore(mc_rest, "mc.cos")
        else
            bi:alexi_talking()
            manny:say_line("/bima079/")
            manny:head_look_at(bi.commies2)
            wait_for_message()
            if not bi.commies.asked_book then
                bi.commies.asked_book = TRUE
                alexi:say_line("/bial080/")
                wait_for_message()
                manny:head_look_at(bi.commies2)
                manny:shrug_gesture()
                manny:say_line("/bima081/")
                wait_for_message()
            end
            alexi:say_line("/bial082/")
            wait_for_message()
            bi:alexi_not_talking()
            manny:head_look_at(nil)
        end
        END_CUT_SCENE()
    end
end
bi.book.pickUp = bi.book.use
bi.mic = Object:create(bi, "/bitx415/microphone", -0.77109098, 0.043096099, 0.4777, { range = 0.60000002 })
bi.mic.use_pnt_x = -0.87504399
bi.mic.use_pnt_y = 0.049089398
bi.mic.use_pnt_z = 0.11
bi.mic.use_rot_x = 0
bi.mic.use_rot_y = -112.875
bi.mic.use_rot_z = 0
bi.mic.lookAt = function(arg1) -- line 1388
    manny:say_line("/bima083/")
end
bi.mic.use = function(arg1) -- line 1393
    soft_script()
    manny:walkto_object(arg1)
    if in_year_four then
        manny:twist_head_gesture()
        manny:say_line("/bima404/")
        if not olivia.reunited then
            START_CUT_SCENE()
            manny:head_look_at(nil)
            wait_for_message()
            olivia:follow_boxes()
            olivia:set_visibility(TRUE)
            olivia:setpos(-0.310821, -1.85579, 0.15)
            olivia:setrot(0, -348.322, 0)
            olivia:say_line("/biol405/")
            olivia:walkto(-0.328694, -1.52327, 0.15, 0, -358.4, 0.15)
            olivia:wait_for_actor()
            wait_for_message()
            manny:head_look_at(olivia)
            manny:say_line("/bima406/")
            manny:wait_for_message()
            manny:turn_right(35)
            END_CUT_SCENE()
            start_script(bi.reunion, TRUE)
        end
    else
        Dialog:run("mi1", "dlg_mic.lua")
    end
end
bi.mic.pickUp = bi.mic.use
bi.patrons1 = Object:create(bi, "/bitx416/beatniks", 0.69, -0.082395501, 0.29809999, { range = 0.69999999 })
bi.patrons1.use_pnt_x = 0.28459999
bi.patrons1.use_pnt_y = -0.124195
bi.patrons1.use_pnt_z = 0
bi.patrons1.use_rot_x = 0
bi.patrons1.use_rot_y = -82.2668
bi.patrons1.use_rot_z = 0
bi.patrons1.lookAt = function(arg1) -- line 1434
    if not bi.patrons1.seen then
        bi.patrons1.seen = TRUE
        soft_script()
        manny:say_line("/bima084/")
        wait_for_message()
        manny:say_line("/bima085/")
    else
        manny:say_line("/bima086/")
    end
end
bi.patrons1.pickUp = function(arg1) -- line 1446
    manny:say_line("/bima087/")
end
bi.patrons1.use = function(arg1) -- line 1450
    manny:say_line("/bima088/")
end
bi.patrons2 = Object:create(bi, "/bitx417/beatniks", -0.72946399, -1.00793, 0.36399999, { range = 0.69999999 })
bi.patrons2.use_pnt_x = -0.49116501
bi.patrons2.use_pnt_y = -0.61832798
bi.patrons2.use_pnt_z = 0
bi.patrons2.use_rot_x = 0
bi.patrons2.use_rot_y = 157.17999
bi.patrons2.use_rot_z = 0
bi.patrons2.parent = bi.patrons1
bi.patrons2.lookAt = function(arg1) -- line 1465
    if skinny_girl.passed_out then
        manny:say_line("/sima163/")
    elseif skinny_girl.revived then
        manny:say_line("/jbma034/")
    else
        bi.patrons1:lookAt()
    end
end
bi.patrons2.wake_up = function() -- line 1477
    skinny_girl:thaw(TRUE)
    skinny_girl:set_costume("passoutgirl.cos")
    skinny_girl:play_chore(passoutgirl_faint_hold, "passoutgirl.cos")
    skinny_girl:fade_in_chore(passoutgirl_idle, "passoutgirl.cos")
    sleep_for(500)
    skinny_girl:fade_out_chore(passoutgirl_faint_hold, "passoutgirl.cos")
    skinny_girl:play_chore(passoutgirl_idle, "passoutgirl.cos")
    sleep_for(500)
    sleep_for(2000)
    skinny_girl:freeze()
    skinny_girl.passed_out = FALSE
    skinny_girl.revived = TRUE
end
bi.patrons2.use = function(arg1) -- line 1492
    if skinny_girl.passed_out then
        START_CUT_SCENE()
        manny:push_costume("mc_wave.cos")
        manny:say_line("/tdma029/")
        manny:run_chore(0, "mc_wave.cos")
        wait_for_message()
        manny:pop_costume()
        manny:say_line("/dema007/")
        manny:shrug_gesture()
        END_CUT_SCENE()
    else
        bi.patrons1:use()
    end
end
bi.office_trigger = { }
bi.office_trigger.walkOut = function(arg1) -- line 1510
    bi.office_door:use()
end
bi.office_door = Object:create(bi, "/bitx418/door", -1.2140501, -1.77389, 0.671, { range = 0.89999998 })
bi.office_door.use_pnt_x = -0.52254599
bi.office_door.use_pnt_y = -1.77479
bi.office_door.use_pnt_z = 0.15000001
bi.office_door.use_rot_x = 0
bi.office_door.use_rot_y = 97.2453
bi.office_door.use_rot_z = 0
bi.office_door.lookAt = function(arg1) -- line 1522
    if in_year_four then
        manny:say_line("/bima407/")
    else
        manny:say_line("/bima089/")
    end
end
bi.office_door.use = function(arg1) -- line 1530
    if in_year_four then
        START_CUT_SCENE()
        manny:walkto_object(arg1)
        manny:knock_on_door_anim()
        END_CUT_SCENE()
        if not olivia.reunited then
            start_script(bi.reunion)
        else
            START_CUT_SCENE()
            arg1:play_chore(4)
            olivia:set_visibility(TRUE)
            olivia:say_line("/biol408/")
            wait_for_message()
            manny:say_line("/bima409/")
            wait_for_message()
            olivia:say_line("/biol410/")
            wait_for_message()
            arg1:play_chore(5)
            olivia:set_visibility(FALSE)
            END_CUT_SCENE()
        end
    else
        START_CUT_SCENE()
        manny:wait_for_actor()
        manny:setrot(0, 86.5099, 0, TRUE)
        manny:wait_for_actor()
        manny:head_look_at(bi.olivia_obj)
        manny:say_line("/bima090/")
        wait_for_message()
        olivia:say_line("/biol091/")
        wait_for_message()
        olivia:say_line("/biol092/")
        END_CUT_SCENE()
    end
end
bi.sign = Object:create(bi, "sign", 0.606058, 2.1863599, 0.74000001, { range = 1 })
bi.sign.use_pnt_x = 0.51134902
bi.sign.use_pnt_y = 1.625
bi.sign.use_pnt_z = 0
bi.sign.use_rot_x = 0
bi.sign.use_rot_y = -1092.14
bi.sign.use_rot_z = 0
bi.sign.lookAt = function(arg1) -- line 1577
    START_CUT_SCENE()
    manny:say_line("/bima093/")
    if not arg1.seen then
        arg1.seen = TRUE
        wait_for_message()
        manny:say_line("/bima094/")
        wait_for_message()
        manny:say_line("/bima095/")
    end
    END_CUT_SCENE()
end
bi.sign.pickUp = function(arg1) -- line 1590
    manny:say_line("/bima096/")
end
bi.sign.use = function(arg1) -- line 1594
    manny:say_line("/bima097/")
end
bi.olivia_obj = Object:create(bi, "/bitx419/Olivia", -0.64359999, -1.64397, 0.64999998, { range = 0.60000002 })
bi.olivia_obj.use_pnt_x = -0.54170001
bi.olivia_obj.use_pnt_y = -1.85027
bi.olivia_obj.use_pnt_z = 0.15000001
bi.olivia_obj.use_rot_x = 0
bi.olivia_obj.use_rot_y = -320.87201
bi.olivia_obj.use_rot_z = 0
bi.olivia_obj.lookAt = function(arg1) -- line 1607
    manny:say_line("/bima098/")
end
bi.olivia_obj.pickUp = function(arg1) -- line 1611
    manny:say_line("/bima099/")
end
bi.olivia_obj.use = function(arg1) -- line 1616
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    Dialog:run("ol1", "dlg_olivia.lua")
    END_CUT_SCENE()
end
bi.olivia_obj.use_paper = function(arg1) -- line 1624
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    bi:rusty_anchor_poem()
    END_CUT_SCENE()
end
bi.olivia_obj.use_letters = function(arg1) -- line 1632
    START_CUT_SCENE()
    manny:walkto_object(arg1)
    manny:wait_for_actor()
    manny:use_default()
    olivia:head_look_at(manny)
    olivia:say_line("/biol100/")
    wait_for_message()
    manny:say_line("/bima101/")
    wait_for_message()
    olivia:head_look_at_manny()
    olivia:say_line("/biol102/")
    wait_for_message()
    olivia:say_line("/biol103/")
    END_CUT_SCENE()
end
bi.bk_door = Object:create(bi, "/bitx420/door", -0.51788002, -2.44768, 0.66000003, { range = 0.60000002 })
bi.bk_door.use_pnt_x = -0.40948001
bi.bk_door.use_pnt_y = -2.15118
bi.bk_door.use_pnt_z = 0.15000001
bi.bk_door.use_rot_x = 0
bi.bk_door.use_rot_y = 179.569
bi.bk_door.use_rot_z = 0
bi.bk_door.out_pnt_x = -0.40000001
bi.bk_door.out_pnt_y = -2.425
bi.bk_door.out_pnt_z = 0.15000001
bi.bk_door.out_rot_x = 0
bi.bk_door.out_rot_y = 192.416
bi.bk_door.out_rot_z = 0
bi.bk_door.walkOut = function(arg1) -- line 1671
    bi:push_out_door()
end
bi.bk_door.lookAt = function(arg1) -- line 1675
    manny:say_line("/bima104/")
end
bi.be_door = Object:create(bi, "/bitx421/door", -0.436095, 1.49985, 0.53399998, { range = 0.60000002 })
bi.be_box = bi.be_door
bi.be_door.use_pnt_x = -0.0720952
bi.be_door.use_pnt_y = 1.49985
bi.be_door.use_pnt_z = 0.15000001
bi.be_door.use_rot_x = 0
bi.be_door.use_rot_y = -666.36401
bi.be_door.use_rot_z = 0
bi.be_door.out_pnt_x = -0.41888201
bi.be_door.out_pnt_y = 1.48896
bi.be_door.out_pnt_z = 0.15000001
bi.be_door.out_rot_x = 0
bi.be_door.out_rot_y = 449.54999
bi.be_door.out_rot_z = 0
bi.be_door.walkOut = function(arg1) -- line 1696
    be:come_out_door(be.bi_door)
end
