CheckFirstTime("_manny.lua")
dofile("manny_gestures.lua")
dofile("ma_knock_on_door.lua")
dofile("ms.lua")
dofile("ma.lua")
dofile("mc.lua")
dofile("mn2.lua")
dofile("msb.lua")
dofile("mcc_thunder.lua")
manny.is_running = FALSE
manny.default_look_rate = 200
manny.has_hat = FALSE
manny.exhale_vol = 64
PROMPT_FOR_CD_A = "/sytx549/"
PROMPT_FOR_CD_B = "/sytx550/"
manny.use_default = function(arg1) -- line 29
    manny:play_chore(ms_use_obj, manny.base_costume)
    manny:wait_for_chore(ms_use_obj, manny.base_costume)
end
sets_by_location = { el_marrow = { "rf", "le", "co", "do", "mo", "ha", "hq", "al", "tu", "lo", "pk", "ga", "fe", "st", "os", "rp", "gs" }, LOL = { "lr" }, meadow = { "nl", "mf", "me", "ge", "hi" }, forest = { "sm", "sg", "na", "sp", "tr", "lb", "bd", "bv", "fc", "re", "ri" }, rubacava = { "cb", "cf", "cc", "ci", "cn", "ce", "cl", "bk", "bi", "be", "lm", "bb", "bp", "pc", "ev", "bw", "hb", "gt", "sl", "mg", "pi", "dd", "tw", "tb", "hh", "xb", "lx", "hl", "mx", "ts", "kh", "ks", "hk", "hp", "he", "de", "dh", "wc", "tx", "sd", "se", "si", "nt", "pf" }, ocean = { "lz", "il", "ei", "dp", "op", "su", "ps", "vi", "vo", "fo", "mn", "ea", "fh", "vd", "ar", "dr", "cy", "cw", "cv", "ew", "cu", "ac", "ck", "bu", "gh", "bl", "lu" }, snow_nuevo = { "tg", "mt", "bs", "td", "my", "mk", "hn", "jb", "nq", "lw", "sh", "te", "th", "zw", "at", "fp", "fi", "ly", "hf" } }
look_up_correct_costume = function(arg1) -- line 53
    local local1 = "suit"
    local local2
    if arg1 then
        if in(arg1.name, inv_sets) then
            PrintDebug("entering inventory - dont do squat!")
        else
            local2 = strsub(arg1.setFile, 1, 2)
            if in(local2, sets_by_location.el_marrow) then
                local1 = "suit"
            elseif in(local2, sets_by_location.LOL) then
                local1 = "reaper"
            elseif in(local2, sets_by_location.meadow) then
                local1 = "reaper"
            elseif in(local2, sets_by_location.forest) then
                local1 = "action"
            elseif in(local2, sets_by_location.rubacava) then
                if not in_year_four then
                    local1 = "cafe"
                else
                    local1 = "siberian"
                end
            elseif in(local2, sets_by_location.ocean) then
                local1 = "nautical"
            elseif in(local2, sets_by_location.snow_nuevo) then
                if not manny.thunder and not manny.fancy then
                    local1 = "siberian"
                else
                    local1 = "thunder"
                end
            end
            PrintDebug("Looking up appropriate costume state...'" .. local1 .. "'!\n")
            return local1
        end
    end
end
test_costume_lookup = function() -- line 100
    local local1 = 1
    while system.setTable[local1] do
        PrintDebug("Set: " .. system.setTable[local1].name .. "(" .. system.setTable[local1].setFile .. ")\n")
        PrintDebug("\tCostume: " .. look_up_correct_costume(system.setTable[local1]) .. "\n")
        local1 = local1 + 1
    end
end
get_cd_prompt_for_setfile = function(arg1) -- line 111
    local local1
    if in(arg1, inv_sets) then
        return nil
    else
        local1 = strsub(arg1, 1, 2)
        if in(local1, sets_by_location.el_marrow) then
            return PROMPT_FOR_CD_A
        elseif in(local1, sets_by_location.LOL) then
            return PROMPT_FOR_CD_A
        elseif in(local1, sets_by_location.meadow) then
            return PROMPT_FOR_CD_B
        elseif in(local1, sets_by_location.forest) then
            return PROMPT_FOR_CD_A
        elseif in(local1, sets_by_location.rubacava) then
            return PROMPT_FOR_CD_B
        elseif in(local1, sets_by_location.ocean) then
            return PROMPT_FOR_CD_A
        elseif in(local1, sets_by_location.snow_nuevo) then
            return PROMPT_FOR_CD_B
        end
    end
    return nil
end
manny.default = function(arg1, arg2) -- line 149
    local local1 = { lz, il, ei, op, dp }
    local local2 = { tg, bs, mt, td, my, mk }
    PrintDebug("Calling default with new_state = " .. tostring(arg2) .. "\n")
    PrintDebug("\t\t...and with manny.costume_state = " .. tostring(manny.costume_state) .. "\n")
    if arg2 then
        manny.costume_state = arg2
    end
    if not manny.costume_state then
        manny.costume_state = "suit"
    end
    stop_script(manny.idle_timer)
    stop_script(manny.idle)
    manny.current_idle_table = nil
    manny.current_idle_cos = nil
    local local3 = system.currentSet
    manny:free()
    if manny.costume_state == "siberian" and manny.thunder then
        manny.costume_state = "thunder"
    elseif manny.costume_state == "thunder" then
        manny.thunder = TRUE
    elseif manny.costume_state == "fancy" then
        manny.fancy = TRUE
        manny.thunder = TRUE
        manny.costume_state = "thunder"
    end
    manny.has_hat = FALSE
    if manny.costume_state == "suit" then
        inventory_disabled = FALSE
        if not manny.suit_idle_hCos then
            manny.suit_idle_hCos = "manny_idles.cos"
        end
        manny.base_costume = "ms.cos"
        manny.gesture_costume = "manny_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("suit.cmp")
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = manny.suit_idle_hCos
        manny.knock_costume = "ms_knock_on_door.cos"
        manny.ladder_costume = "ms_ladder_generic.cos"
    elseif manny.costume_state == "reaper" then
        if system.currentSet == lr then
            inventory_disabled = TRUE
        else
            inventory_disabled = FALSE
        end
        manny.base_costume = "md.cos"
        manny.gesture_costume = "md_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("suit.cmp")
        manny.current_idle_cos = nil
        manny.current_idle_table = nil
        manny.knock_costume = nil
        manny.ladder_costume = nil
    elseif manny.costume_state == "action" then
        manny.base_costume = "ma.cos"
        manny.gesture_costume = "action_manny_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("action.cmp")
        inventory_disabled = FALSE
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = "action_wait_idles.cos"
        manny.knock_costume = "ma_knock_on_door.cos"
        manny.ladder_costume = "ma_ladder_generic.cos"
    elseif manny.costume_state == "cafe" then
        manny.base_costume = "mc.cos"
        manny.gesture_costume = "mc_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("cafe.cmp")
        inventory_disabled = FALSE
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = "mc_wait_idles.cos"
        manny.knock_costume = "mc_knock_on_door.cos"
        manny.ladder_costume = "mc_ladder_generic.cos"
    elseif manny.costume_state == "nautical" then
        manny.base_costume = "mn2.cos"
        manny.gesture_costume = "mn_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("nautical.cmp")
        inventory_disabled = FALSE
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = "mn_wait_idles.cos"
        manny.knock_costume = "mn_knock_on_door.cos"
        manny.ladder_costume = "mn_ladder_generic.cos"
        if in(system.currentSet, local1) then
            manny:play_chore_looping(mn2_hat_on, "mn2.cos")
            manny.has_hat = TRUE
        else
            manny:play_chore(mn2_hat_off, "mn2.cos")
        end
    elseif manny.costume_state == "siberian" then
        manny.base_costume = "msb.cos"
        manny.gesture_costume = "msb_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("siberian.cmp")
        inventory_disabled = FALSE
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = "msb_wait_idles.cos"
        manny.knock_costume = "msb_knock_on_door.cos"
        manny.ladder_costume = "msb_ladder_generic.cos"
        if in(system.currentSet, local2) then
            manny:play_chore_looping(msb_hat_on, "msb.cos")
            manny.has_hat = TRUE
        else
            manny:play_chore(msb_hat_off, "msb.cos")
        end
    elseif manny.costume_state == "thunder" then
        if manny.fancy then
            manny.base_costume = "mcc_thunder.cos"
            manny.gesture_costume = "mcc_thunder_gestures.cos"
            manny:set_costume(manny.base_costume)
            manny:set_colormap("m_chow.cmp")
            inventory_disabled = FALSE
            manny.current_idle_table = manny.suit_idle_table
            manny.current_idle_cos = "mcc_thunder_wait_idles.cos"
            manny.knock_costume = "mcc_knock_on_door.cos"
            manny.ladder_costume = "mccthund_ladder_generic.cos"
        else
            manny.base_costume = "msb.cos"
            manny.gesture_costume = "msb_gestures.cos"
            manny:set_costume(manny.base_costume)
            manny:set_colormap("siberian.cmp")
            inventory_disabled = FALSE
            manny.current_idle_table = manny.suit_idle_table
            manny.current_idle_cos = "msb_wait_idles.cos"
            manny.knock_costume = "msb_knock_on_door.cos"
            manny.ladder_costume = "msb_ladder_generic.cos"
        end
    else
        inventory_disabled = FALSE
        if not manny.suit_idle_hCos then
            manny.suit_idle_hCos = "manny_idles.cos"
        end
        manny.base_costume = "ms.cos"
        manny.gesture_costume = "manny_gestures.cos"
        manny:set_costume(manny.base_costume)
        manny:set_colormap("suit.cmp")
        manny.current_idle_table = manny.suit_idle_table
        manny.current_idle_cos = manny.suit_idle_hCos
        manny.ladder_costume = "ms_ladder_generic.cos"
        manny.knock_costume = "ms_knock_on_door.cos"
    end
    WriteRegistryValue("GrimMannyState", manny.costume_state)
    manny.is_climbing = FALSE
    if manny.costume_state == "suit" then
        manny:set_walk_chore(ms_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
        manny:set_rest_chore(ms_rest)
        manny:set_mumble_chore(ms_mumble)
        manny:set_talk_chore(1, ms_stop_talk)
        manny:set_talk_chore(2, ms_a)
        manny:set_talk_chore(3, ms_c)
        manny:set_talk_chore(4, ms_e)
        manny:set_talk_chore(5, ms_f)
        manny:set_talk_chore(6, ms_l)
        manny:set_talk_chore(7, ms_m)
        manny:set_talk_chore(8, ms_o)
        manny:set_talk_chore(9, ms_t)
        manny:set_talk_chore(10, ms_u)
        manny:set_turn_rate(85)
        manny.talk_chore = ms_talk
        manny.stop_talk_chore = ms_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    elseif manny.costume_state == "reaper" then
        manny:set_walk_chore(md_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(md_swivel_lf, md_swivel_rt)
        manny:set_rest_chore(md_rest)
        manny:set_mumble_chore(md_mumble)
        manny:set_talk_chore(1, md_stop_talk)
        manny:set_talk_chore(2, md_a)
        manny:set_talk_chore(3, md_c)
        manny:set_talk_chore(4, md_e)
        manny:set_talk_chore(5, md_f)
        manny:set_talk_chore(6, md_l)
        manny:set_talk_chore(7, md_m)
        manny:set_talk_chore(8, md_o)
        manny:set_talk_chore(9, md_t)
        manny:set_talk_chore(10, md_u)
        manny:set_turn_rate(85)
        manny.running_chore = md_run
        manny.talk_chore = md_mumble
        manny.stop_talk_chore = md_stop_talk
        manny:set_head(3, 4, 5, 165, 23, 80)
    elseif manny.costume_state == "action" then
        manny:set_walk_chore(ma_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(ma_swivel_lf, ma_swivel_rt)
        manny:set_rest_chore(ma_rest)
        manny:set_mumble_chore(ma_mumble)
        manny:set_talk_chore(1, ma_stop_talk)
        manny:set_talk_chore(2, ma_a)
        manny:set_talk_chore(3, ma_c)
        manny:set_talk_chore(4, ma_e)
        manny:set_talk_chore(5, ma_f)
        manny:set_talk_chore(6, ma_l)
        manny:set_talk_chore(7, ma_m)
        manny:set_talk_chore(8, ma_o)
        manny:set_talk_chore(9, ma_t)
        manny:set_talk_chore(10, ma_u)
        manny:set_turn_rate(85)
        manny.talk_chore = ma_talk
        manny.stop_talk_chore = ma_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 13, 50)
    elseif manny.costume_state == "cafe" then
        manny:set_walk_chore(mc_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(mc_swivel_lf, ma_swivel_rt)
        manny:set_rest_chore(mc_rest)
        manny:set_mumble_chore(mc_mumble)
        manny:set_talk_chore(1, mc_stop_talk)
        manny:set_talk_chore(2, mc_a)
        manny:set_talk_chore(3, mc_c)
        manny:set_talk_chore(4, mc_e)
        manny:set_talk_chore(5, mc_f)
        manny:set_talk_chore(6, mc_l)
        manny:set_talk_chore(7, mc_m)
        manny:set_talk_chore(8, mc_o)
        manny:set_talk_chore(9, mc_t)
        manny:set_talk_chore(10, mc_u)
        manny:set_turn_rate(85)
        manny.talk_chore = mc_talk
        manny.stop_talk_chore = mc_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    elseif manny.costume_state == "nautical" then
        manny:set_walk_chore(ms_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
        manny:set_rest_chore(ms_rest)
        manny:set_mumble_chore(ms_mumble)
        manny:set_talk_chore(1, mn2_stop_talk)
        manny:set_talk_chore(2, mn2_a)
        manny:set_talk_chore(3, mn2_c)
        manny:set_talk_chore(4, mn2_e)
        manny:set_talk_chore(5, mn2_f)
        manny:set_talk_chore(6, mn2_l)
        manny:set_talk_chore(7, mm2_m)
        manny:set_talk_chore(8, mn2_o)
        manny:set_talk_chore(9, mn2_t)
        manny:set_talk_chore(10, mm2_u)
        manny:set_turn_rate(85)
        manny.talk_chore = ms_talk
        manny.stop_talk_chore = ms_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    elseif manny.costume_state == "siberian" then
        manny:set_walk_chore(msb_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(msb_swivel_lf, msb_swivel_rt)
        manny:set_rest_chore(msb_rest)
        manny:set_mumble_chore(msb_mumble)
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
        manny:set_turn_rate(85)
        manny.talk_chore = msb_talk
        manny.stop_talk_chore = msb_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    elseif manny.costume_state == "thunder" then
        manny:set_walk_chore(msb_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(msb_swivel_lf, msb_swivel_rt)
        manny:set_rest_chore(msb_rest)
        if not manny.fancy then
            manny:set_mumble_chore(msb_thunder_mumble)
            manny:set_talk_chore(1, msb_thunder_no_talk)
            manny:set_talk_chore(2, msb_thunder_a)
            manny:set_talk_chore(3, msb_thunder_c)
            manny:set_talk_chore(4, msb_thunder_e)
            manny:set_talk_chore(5, msb_thunder_f)
            manny:set_talk_chore(6, msb_thunder_l)
            manny:set_talk_chore(7, msb_thunder_m)
            manny:set_talk_chore(8, msb_thunder_o)
            manny:set_talk_chore(9, msb_thunder_t)
            manny:set_talk_chore(10, msb_thunder_u)
            manny.talk_chore = msb_thunder_mumble
            manny.stop_talk_chore = msb_thunder_no_talk
            manny:play_chore(msb_thunder_activate, manny.base_costume)
        else
            manny:set_mumble_chore(mcc_thunder_mumble)
            manny:set_talk_chore(1, mcc_thunder_no_talk)
            manny:set_talk_chore(2, mcc_thunder_a)
            manny:set_talk_chore(3, mcc_thunder_c)
            manny:set_talk_chore(4, mcc_thunder_e)
            manny:set_talk_chore(5, mcc_thunder_f)
            manny:set_talk_chore(6, mcc_thunder_l)
            manny:set_talk_chore(7, mcc_thunder_m)
            manny:set_talk_chore(8, mcc_thunder_o)
            manny:set_talk_chore(9, mcc_thunder_t)
            manny:set_talk_chore(10, mcc_thunder_u)
            manny.talk_chore = mcc_thunder_mumble
            manny.stop_talk_chore = mcc_thunder_no_talk
            manny:play_chore(mcc_thunder_activate_thunder, manny.base_costume)
        end
        manny:set_turn_rate(85)
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    else
        manny:set_walk_chore(ms_walk)
        manny:set_walk_rate(0.40000001)
        manny:set_turn_chores(ms_swivel_lf, ms_swivel_rt)
        manny:set_rest_chore(ms_rest)
        manny:set_mumble_chore(ms_mumble)
        manny:set_talk_chore(1, ms_stop_talk)
        manny:set_talk_chore(2, ms_a)
        manny:set_talk_chore(3, ms_c)
        manny:set_talk_chore(4, ms_e)
        manny:set_talk_chore(5, ms_f)
        manny:set_talk_chore(6, ms_l)
        manny:set_talk_chore(7, ms_m)
        manny:set_talk_chore(8, ms_o)
        manny:set_talk_chore(9, ms_t)
        manny:set_talk_chore(10, ms_u)
        manny:set_turn_rate(85)
        manny.talk_chore = ms_talk
        manny.stop_talk_chore = ms_stop_talk
        manny.running_chore = ms_run
        manny:set_head(3, 4, 5, 165, 28, 80)
    end
    manny.is_holding = nil
    manny.hold_chore = nil
    manny:set_talk_color(White)
    manny:follow_boxes()
    manny:set_visibility(TRUE)
    manny:set_time_scale(1)
    manny:set_look_rate(manny.default_look_rate)
    manny:scale(1)
    SetActorCollisionScale(manny.hActor, 0.34999999)
    manny:put_in_set(local3)
    if manny.current_idle_cos ~= nil then
        manny:push_costume(manny.current_idle_cos)
        start_script(manny.idle_timer, manny)
    else
        stop_script(manny.idle_timer)
        stop_script(manny.idle)
    end
    if manny.costume_state == "reaper" then
    end
    PrintDebug("Manny after default:\n")
    manny:print_costumes()
end
manny.set_walk_backwards = function(arg1, arg2) -- line 538
    if arg1.costume_state ~= "reaper" then
        if arg2 then
            arg1.is_backward = TRUE
            arg1:set_walk_chore(ms_back_off, arg1.base_costume)
            arg1:set_walk_rate(-MANNY_WALK_RATE)
        else
            arg1.is_backward = FALSE
            if not arg1.is_running then
                arg1:set_walk_chore(ms_walk, arg1.base_costume)
                arg1:set_walk_rate(MANNY_WALK_RATE)
            else
                arg1:set_walk_chore(arg1.running_chore, arg1.base_costume)
                arg1:set_walk_rate(MANNY_RUN_RATE)
            end
        end
    elseif arg1.costume_state == "reaper" then
        if arg2 then
            arg1.is_backward = TRUE
            arg1:set_walk_chore(md_back_off, "md.cos")
            arg1:set_walk_rate(-MANNY_WALK_RATE)
        else
            arg1.is_backward = FALSE
            if not arg1.is_running then
                arg1:set_walk_chore(md_walk, "md.cos")
                arg1:set_walk_rate(MANNY_WALK_RATE)
            else
                arg1:set_walk_chore(md_run, "md.cos")
                arg1:set_walk_rate(MANNY_RUN_RATE)
            end
        end
    end
end
manny.backup = function(arg1, arg2) -- line 572
    if not arg2 then
        arg2 = 1000
    end
    arg1.move_in_reverse = TRUE
    start_script(move_actor_backward, arg1.hActor)
    sleep_for(arg2)
    stop_script(move_actor_backward)
    arg1:set_walk_backwards(FALSE)
    arg1.move_in_reverse = FALSE
end
manny.set_run = function(arg1, arg2) -- line 583
    if arg2 then
        if not arg1.is_backward then
            arg1:set_walk_chore(manny.running_chore, manny.base_costume)
            arg1:set_walk_rate(MANNY_RUN_RATE)
            arg1:set_turn_rate(140)
            SetActorWalkDominate(arg1.hActor, nil)
            SetActorReflection(arg1.hActor, 80)
        end
        arg1.is_running = TRUE
    else
        SetActorReflection(arg1.hActor, 80)
        if not arg1.is_backward then
            arg1:set_walk_chore(ms_walk, manny.base_costume)
            arg1:set_walk_rate(MANNY_WALK_RATE)
            arg1:set_turn_rate(85)
            SetActorWalkDominate(arg1.hActor, 1)
        end
        arg1.is_running = FALSE
    end
end
manny.force_auto_run = function(arg1, arg2) -- line 605
    arg1.auto_run_msecs = 0
    if arg2 then
        arg1.auto_run = TRUE
        single_start_script(monitor_run)
    else
        arg1.auto_run = FALSE
    end
end
manny.start_open_door_anim = function(arg1, arg2) -- line 615
    local local1
    if manny.base_costume == "ms.cos" then
        local1 = "ma_open_door.cos"
    elseif manny.base_costume == "ma.cos" then
        local1 = "action_open_door.cos"
    elseif manny.base_costume == "mc.cos" then
        local1 = "mc_open_door.cos"
    elseif manny.base_costume == "msb.cos" then
        local1 = "msb_open_door.cos"
    elseif manny.base_costume == "mcc_thunder.cos" then
        local1 = "mcc_open_door.cos"
    else
        local1 = nil
    end
    if local1 then
        manny:push_costume(local1)
        if arg2 then
            manny:play_chore(ma_open_door_close_door, local1)
        else
            manny:play_chore(ma_open_door_open_door, local1)
        end
    else
        PrintDebug("WARNING - no open door costume corresponds to " .. manny.base_costume .. "\n")
    end
end
manny.finish_open_door_anim = function(arg1, arg2) -- line 644
    if arg2 then
        manny:wait_for_chore(ma_open_door_close_door)
    else
        manny:wait_for_chore(ma_open_door_open_door)
    end
    manny:pop_costume()
end
manny.knock_on_door_anim = function(arg1) -- line 653
    if manny.knock_costume then
        manny:push_costume(manny.knock_costume)
        manny:play_chore(ma_knock_on_door_knock, manny.knock_costume)
        manny:wait_for_chore(ma_knock_on_door_knock, manny.knock_costume)
        manny:pop_costume()
    else
        PrintDebug("WARNING - knock failed, no costume set")
    end
end
manny.start_climb_ladder = function(arg1, arg2) -- line 664
    inventory_disabled = TRUE
    if arg1.is_holding then
        arg1.is_holding:put_away()
    end
    arg1:ignore_boxes()
    arg1:push_costume(arg1.ladder_costume)
    arg1.is_climbing = TRUE
    arg1.ladder_obj = arg2
    arg1.climb_chore = ma_ladder_generic_climb2
    arg1.costume_marker_handler = arg1.ladder_marker_handler
end
manny.stop_climb_ladder = function(arg1) -- line 678
    inventory_disabled = FALSE
    stop_script(arg1.climb_up)
    stop_script(arg1.climb_down)
    stop_script(climb_actor_up)
    stop_script(climb_actor_down)
    manny:stop_chore(ma_ladder_generic_climb1)
    manny:stop_chore(ma_ladder_generic_climb2)
    manny:stop_chore(ma_ladder_generic_climb_down1)
    manny:stop_chore(ma_ladder_generic_climb_down2)
    arg1.costume_marker_handler = nil
    arg1.is_climbing = FALSE
    arg1.ladder_obj = nil
    arg1:pop_costume(arg1.ladder_costume)
    arg1:follow_boxes()
end
manny.generic_pickup = function(arg1, arg2) -- line 695
    local local1
    arg2:get()
    manny.is_holding = arg2
    if arg2.takeout_flag then
        start_script(arg2.takeout_flag, arg2)
    end
    if manny.costume_state == "suit" then
        local1 = "ms_activate_" .. arg2.string_name
    elseif manny.costume_state == "action" then
        local1 = "ma_activate_" .. arg2.string_name
    elseif manny.costume_state == "cafe" then
        local1 = "mc_activate_" .. arg2.string_name
    elseif manny.costume_state == "nautical" then
        local1 = "mn2_activate_" .. arg2.string_name
    elseif manny.costume_state == "siberian" then
        local1 = "msb_activate_" .. arg2.string_name
    elseif manny.costume_state == "thunder" then
        if manny.fancy then
            local1 = "mcc_thunder_activate_" .. arg2.string_name
        else
            local1 = "msb_activate_" .. arg2.string_name
        end
    elseif manny.costume_state == "reaper" then
        local1 = "md_activate_" .. arg2.string_name
    else
        PrintDebug("WARNING!  NO VALID ACTIVATE CHORE SET")
    end
    PrintDebug(local1 .. "\n")
    if local1 then
        manny:play_chore_looping(getglobal(local1), manny.base_costume)
        manny.hold_chore = getglobal(local1)
    end
    manny:play_chore_looping(ms_hold, manny.base_costume)
end
manny.pull_out_item = function(arg1, arg2) -- line 732
    shrinkBoxesEnabled = FALSE
    open_inventory(TRUE, TRUE, TRUE)
    manny.is_holding = arg2
    close_inventory()
    if GlobalShrinkEnabled then
        shrinkBoxesEnabled = TRUE
    end
end
manny.climb_up = function(arg1) -- line 743
    local local1
    local local2, local3, local4, local5
    local local6
    if arg1.climb_chore == ma_ladder_generic_climb1 or arg1.climb_chore == ma_ladder_generic_climb_down2 then
        arg1.climb_chore = ma_ladder_generic_climb2
        local4 = 467
    else
        arg1.climb_chore = ma_ladder_generic_climb1
        local4 = 400
    end
    arg1:play_chore(arg1.climb_chore)
    local3 = 0
    local5 = 0.13 / local4
    local1 = arg1:getpos()
    if arg1.ladder_obj then
        local6 = arg1.ladder_obj.maxz
    end
    if not local6 then
        local6 = 9999
    end
    while local3 < local4 and local1.z < local6 do
        local1 = arg1:getpos()
        local2 = local5 * system.frameTime
        local1.z = local1.z + local2
        if local1.z > local6 then
            local1.z = local6
        end
        arg1:setpos(local1.x, local1.y, local1.z)
        break_here()
        local3 = local3 + system.frameTime
    end
    if arg1.ladder_obj and local1.z >= local6 then
        start_script(arg1.ladder_obj.climbOut, arg1.ladder_obj, arg1.ladder_obj.top.box)
    end
end
manny.climb_down = function(arg1) -- line 785
    local local1
    local local2, local3, local4, local5
    local local6
    if arg1.climb_chore == ma_ladder_generic_climb_down1 or arg1.climb_chore == ma_ladder_generic_climb2 then
        arg1.climb_chore = ma_ladder_generic_climb_down2
        local4 = 467
    else
        arg1.climb_chore = ma_ladder_generic_climb_down1
        local4 = 400
    end
    PrintDebug(arg1.climb_chore)
    arg1:play_chore(arg1.climb_chore)
    local3 = 0
    local5 = 0.13 / local4
    local1 = arg1:getpos()
    if arg1.ladder_obj then
        local6 = arg1.ladder_obj.minz
    end
    if not local6 then
        local6 = -9999
    end
    while local3 < local4 and local1.z > local6 do
        local1 = arg1:getpos()
        local2 = local5 * system.frameTime
        local1.z = local1.z - local2
        if local1.z < local6 then
            local1.z = local6
        end
        arg1:setpos(local1.x, local1.y, local1.z)
        break_here()
        local3 = local3 + system.frameTime
    end
    if arg1.ladder_obj and local1.z <= local6 then
        start_script(arg1.ladder_obj.climbOut, arg1.ladder_obj, arg1.ladder_obj.base.box)
    end
end
manny.ladder_marker_handler = function(arg1, arg2) -- line 831
    local local1
    if in(system.currentSet:short_name(), Set.basic_reverb_sets) or in(system.currentSet:short_name(), Set.short_reverb_sets) then
        if arg2 == Actor.MARKER_LEFT_WALK then
            if rnd(5) then
                local1 = "fsmvbwl1"
            else
                local1 = "fsmvbwl2"
            end
        elseif arg2 == Actor.MARKER_RIGHT_WALK then
            if rnd(5) then
                local1 = "fsmvbwr1"
            else
                local1 = "fsmvbwr2"
            end
        end
    elseif arg2 == Actor.MARKER_LEFT_WALK then
        if rnd(5) then
            local1 = "fslad_l1"
        else
            local1 = "fslad_l2"
        end
    elseif arg2 == Actor.MARKER_RIGHT_WALK then
        if rnd(5) then
            local1 = "fslad_r1"
        else
            local1 = "fslad_r2"
        end
    end
    if local1 then
        arg1:play_footstep_sfx(local1 .. ".wav")
    end
end
manny.stop_chore = function(arg1, arg2, arg3) -- line 870
    Actor.stop_chore(arg1, arg2, arg3)
    if arg2 == nil or (arg2 == ms_rest and arg3 == manny.base_costume) then
        arg1:play_chore(ms_rest, manny.base_costume)
    end
end
manny.tilt_head_gesture = function(arg1, arg2) -- line 877
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_head_tilt, arg2)
end
manny.head_forward_gesture = function(arg1, arg2) -- line 881
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_head_forward, arg2)
end
manny.nod_head_gesture = function(arg1, arg2) -- line 885
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_head_nod, arg2)
end
manny.twist_head_gesture = function(arg1, arg2) -- line 889
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_head_twist, arg2)
end
manny.shrug_gesture = function(arg1, arg2) -- line 893
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_shrug, arg2)
end
manny.hand_gesture = function(arg1, arg2) -- line 897
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_hand_gesture, arg2)
end
manny.point_gesture = function(arg1, arg2) -- line 901
    start_script(arg1.start_gesture_chore, arg1, manny_gestures_pointing, arg2)
end
manny.start_gesture_chore = function(arg1, arg2, arg3) -- line 905
    if not arg3 then
        wait_for_script(arg1.play_gesture_chore)
    end
    start_script(arg1.play_gesture_chore, arg1, arg2)
end
manny.play_gesture_chore = function(arg1, arg2) -- line 912
    local local1
    if arg1.gesture_costume then
        if arg1:get_costume() ~= arg1.gesture_costume then
            PrintDebug("pushing gesture costume...\n")
            arg1:push_costume(arg1.gesture_costume)
            local1 = TRUE
        end
        arg1:play_chore(arg2, arg1.gesture_costume)
        arg1:wait_for_chore()
        if local1 and arg1:get_costume() == arg1.gesture_costume then
            arg1:pop_costume()
        end
    end
end
TIME_TO_IDLE = 10
manny.is_backward = FALSE
manny.idle_trigger = nil
manny.idle_timer_var = 0
manny.is_idling = FALSE
dofile("manny_idles.lua")
manny.suit_idle_table = Idle:create("manny_idles")
manny.suit_idle_table:add_state("scratch", { smoke1 = 1 })
manny.suit_idle_table:add_state("smoke1", { smoke_loop = 0.5, smoke_flick = 0.5 })
manny.suit_idle_table:add_state("smoke_loop", { smoke_flick = 0.5, smoke_loop = 0.5 })
manny.suit_idle_table:add_state("smoke_flick", { scratch = 0.5, smoke1 = 0.5 })
idle_buttonHandler = function(arg1, arg2, arg3) -- line 951
    PrintDebug("button handled by idle button handler")
    if arg1 == KEY1 and arg2 or (arg1 == KEY2 and arg2) or (arg1 == KEY3 and arg2) or (arg1 == KEY4 and arg2) or (arg1 == KEY5 and arg2) or (arg1 == KEY6 and arg2) or (arg1 == KEY7 and arg2) or (arg1 == KEY8 and arg2) or (arg1 == KEY9 and arg2) or control_map.PICK_UP[arg1] or control_map.USE[arg1] or control_map.CHANGE_GAZE[arg1] or control_map.INVENTORY[arg1] then
        start_script(idle_exitHandler, arg1, arg2, arg3)
    else
        PrintDebug("button handle passed to system")
        system.buttonHandler = idle_save_handler
        system.buttonHandler(arg1, arg2, arg3)
    end
end
idle_exitHandler = function(arg1, arg2, arg3) -- line 969
    PrintDebug("button handle passed to idle_exit handler")
    START_CUT_SCENE()
    while manny.is_idling do
        break_here()
    end
    END_CUT_SCENE()
    system.buttonHandler = idle_save_handler
    system.buttonHandler(arg1, arg2, arg3)
end
manny.idle_timer = function(arg1) -- line 984
    local local1
    start_script(manny.idle)
    while 1 do
        manny.stop_idle = FALSE
        repeat
            if manny.idles_allowed and (system.buttonHandler == SampleButtonHandler or system.buttonHandler == idle_buttonHandler) and not manny.is_climbing and find_script(move_actor) == nil and cutSceneLevel <= 0 and not manny:is_moving() and not manny:is_turning() and not manny:is_choring(nil, TRUE) and not manny:is_walking() and not manny.is_backward and manny.current_idle_cos then
                manny.idle_timer_var = manny.idle_timer_var + PerSecond(1)
                break_here()
            end
            break_here()
        until manny.idle_timer_var >= TIME_TO_IDLE or manny.stop_idle == TRUE or cutSceneLevel > 0
        if manny.idle_timer_var >= TIME_TO_IDLE then
            if manny.is_holding == nil then
                manny.idle_trigger = TRUE
            end
        end
        manny.idle_timer_var = 0
        break_here()
    end
end
manny.idle = function(arg1) -- line 1013
    local local1
    manny.last_idle_chore = nil
    while 1 do
        if manny.idle_trigger and manny.idles_allowed then
            manny.idle_trigger = FALSE
            table = manny.current_idle_table
            if not manny.is_idling then
                manny.is_idling = TRUE
            end
            if manny.is_holding and not manny.last_idle_chore then
                local1 = "manny_idles_smoke1"
            elseif manny.last_idle_chore then
                local1 = pick_from_weighted_table(manny.current_idle_table[manny.last_idle_chore])
            else
                local1 = "manny_idles_scratch"
            end
            manny.no_idle_head = TRUE
            manny:head_look_at(nil)
            manny:play_chore(getglobal(local1), manny.current_idle_cos)
            start_script(manny.idle_extras, manny, getglobal(local1))
            if not manny.stop_idle then
                manny.last_idle_chore = local1
            end
            while manny:is_choring(getglobal(local1), TRUE, manny.current_idle_cos) and not manny.stop_idle do
                break_here()
            end
            manny.no_idle_head = FALSE
        end
        if manny.stop_idle and manny.is_idling then
            stop_script(manny.idle_extras)
            manny:stop_chore(manny_idles_smoke1, manny.current_idle_cos)
            manny:stop_chore(manny_idles_smoke_loop, manny.current_idle_cos)
            if manny.costume_state == "thunder" and not manny.fancy then
                manny:stop_chore(msb_thunder_u, manny.base_costume)
                manny:play_chore(msb_thunder_no_talk, manny.base_costume)
            else
                manny:stop_chore(ms_u, manny.base_costume)
                manny:play_chore(ms_stop_talk, manny.base_costume)
            end
            manny.last_idle_chore = nil
            if local1 == "manny_idles_scratch" then
                manny:stop_chore(manny_idles_scratch)
            else
                manny:stop_chore(manny_idles_smoke1, manny.current_idle_cos)
                manny:stop_chore(manny_idles_smoke_loop, manny.current_idle_cos)
                if not manny:is_choring(manny_idles_smoke_flick, TRUE, manny.current_idle_cos) then
                    manny:play_chore(manny_idles_smoke_flick, manny.current_idle_cos)
                end
                manny:wait_for_chore(manny_idles_smoke_flick, manny.current_idle_cos)
                manny:stop_chore(manny_idles_smoke_flick, manny.current_idle_cos)
            end
            manny.is_idling = FALSE
        elseif not manny.stop_idle and local1 == "manny_idles_smoke_flick" and manny.is_idling then
            manny.is_idling = FALSE
            manny:stop_chore(manny_idles_smoke_flick, manny.current_idle_cos)
        end
        break_here()
    end
end
manny.idle_extras = function(arg1, arg2) -- line 1084
    local local1 = { "cigExM1.wav", "cigExM2.wav", "cigExM3.wav", "cigExM4.wav" }
    if manny.costume_state == "thunder" and not manny.fancy then
        if arg2 == manny_idles_smoke1 then
            sleep_for(2814)
            start_sfx(pick_one_of(local1), IM_LOW_PRIORITY, manny.exhale_vol)
            manny:play_chore_looping(msb_thunder_u, manny.base_costume)
            manny:wait_for_chore(arg2, manny.current_idle_cos)
            manny:stop_chore(msb_thunder_u, manny.base_costume)
            manny:play_chore(msb_thunder_no_talk, manny.base_costume)
        elseif arg2 == manny_idles_smoke_loop then
            sleep_for(1809)
            start_sfx(pick_one_of(local1), IM_LOW_PRIORITY, manny.exhale_vol)
            manny:play_chore_looping(msb_thunder_u, manny.base_costume)
            manny:wait_for_chore(arg2, manny.current_idle_cos)
            manny:stop_chore(msb_thunder_u, manny.base_costume)
            manny:play_chore(msb_thunder_no_talk, manny.base_costume)
        end
    elseif arg2 == manny_idles_smoke1 then
        sleep_for(2814)
        start_sfx(pick_one_of(local1), IM_LOW_PRIORITY, manny.exhale_vol)
        manny:play_chore_looping(ms_u, manny.base_costume)
        manny:wait_for_chore(arg2, manny.current_idle_cos)
        manny:stop_chore(ms_u, manny.base_costume)
        manny:play_chore(ms_stop_talk, manny.base_costume)
    elseif arg2 == manny_idles_smoke_loop then
        sleep_for(1809)
        start_sfx(pick_one_of(local1), IM_LOW_PRIORITY, manny.exhale_vol)
        manny:play_chore_looping(ms_u, manny.base_costume)
        manny:wait_for_chore(arg2, manny.current_idle_cos)
        manny:stop_chore(ms_u, manny.base_costume)
        manny:play_chore(ms_stop_talk, manny.base_costume)
    end
end
manny.examine_scythe = function(arg1) -- line 1124
    manny:say_line("/moma069/")
end
manny.use_scythe = function(arg1) -- line 1128
    local local1, local2
    if system.currentSet.use_scythe then
        system.currentSet:use_scythe()
    else
        START_CUT_SCENE()
        if manny.costume_state == "suit" then
            local2 = TRUE
            local1 = ms_swipe
        elseif manny.costume_state == "action" then
            local2 = FALSE
        elseif manny.costume_state == "cafe" then
            local2 = TRUE
            local1 = mc_scythe_swipe
        elseif manny.costume_state == "nautical" then
            local2 = FALSE
        elseif manny.costume_state == "siberian" then
            local2 = FALSE
        end
        if local2 then
            manny:stop_chore(ms_hold_scythe, manny.base_costume)
            manny:play_chore(local1, manny.base_costume)
            sleep_for(1000)
            start_sfx("scyChop.wav")
            manny:wait_for_chore()
            manny:play_chore_looping(ms_hold_scythe, manny.base_costume)
            manny:stop_chore(local1, manny.base_costume)
        end
        END_CUT_SCENE()
    end
end
manny.default_scythe_response = function(arg1, arg2) -- line 1162
    local local1
    if arg2 then
        local1 = trim_header(arg2.name)
        if local1 == "Meche" then
            manny:say_line("/moma127/")
        elseif in(local1, { "Glottis", "Aitor", "elevator demon", "repairman", "terry", "workers", "cave_gator" }) then
            system.default_response("demon reap")
        elseif in(local1, { "Raoul", "revolutionaries", "Membrillo", "Naranja", "beatniks", "Toto", "Velasco", "Thunder boys", "Nick", "Gambler", "Charlie", "Bogen", "clown", "Bowlsley", "Celso", "Eva", "Chepito", "Pugsy", "Bibi", "Olivia", "Domino", "Salvador", "couple", "Lupe", "miners" }) then
            system.default_response("reap")
        else
            manny:say_line("/moma070/")
        end
    else
        manny:say_line("/moma070/")
    end
end
manny.stop_takeout_chores = function(arg1) -- line 1182
    if manny.costume_state == "nautical" then
        manny:stop_chore(mn2_putback_big_new, "mn2.cos")
        manny:stop_chore(mn2_putback_new, "mn2.cos")
    else
        manny:stop_chore(ms_putback_big, manny.base_costume)
        manny:stop_chore(ms_putback_small, manny.base_costume)
    end
    manny:stop_chore(ms_takeout_get, manny.base_costume)
end
