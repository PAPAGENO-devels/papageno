dofile("carla_cry.lua")
carla_says_turn = 0
carla_srch_mc = 1
carla_srch_shrg = 2
carla_sit = 3
carla_stand = 4
carla_walk = 5
carla_sit_hold = 6
carla_tilt_head = 7
carla_prop_to_sit = 8
carla_to_prop_head = 9
carla_prop_hold = 10
carla_hold_up = 11
carla_head_up = 12
carla_show_detector = 13
carla_hide_detector = 14
carla_detector_only = 15
carla_stand_hold = 16
carla.go_to_prop = function(arg1) -- line 36
    if find_script(carla.go_to_sit) then
        wait_for_script(carla.go_to_sit)
    end
    if carla.idle_state == "sit" then
        carla:head_look_at(nil)
        break_here()
        carla:stop_chore(carla_sit_hold, sl.search_cos)
        carla:play_chore(carla_to_prop_head, sl.search_cos)
        carla:wait_for_chore(carla_to_prop_head, sl.search_cos)
        carla:play_chore_looping(carla_prop_hold, sl.search_cos)
        carla.idle_state = "prop"
    end
end
carla.prop_tilt_head = function(arg1) -- line 52
    if find_script(carla.prop_end_tilt_head) then
        wait_for_script(carla.prop_end_tilt_head)
    end
    if find_script(carla.go_to_prop) then
        wait_for_script(carla.go_to_prop)
    end
    if carla.idle_state == "sit" then
        carla:go_to_prop()
    end
    if carla.idle_state == "prop" then
        carla:stop_chore(carla_prop_hold, sl.search_cos)
        carla:play_chore(carla_head_up, sl.search_cos)
        carla:wait_for_chore(carla_head_up, sl.search_cos)
        carla:play_chore_looping(carla_hold_up, sl.search_cos)
        carla.idle_state = "proptilt"
    end
end
carla.prop_end_tilt_head = function(arg1) -- line 72
    if find_script(carla.prop_tilt_head) then
        wait_for_script(carla.prop_tilt_head)
    end
    if carla.idle_state == "proptilt" then
        carla:stop_chore(carla_hold_up, sl.search_cos)
        carla:play_chore(carla_tilt_head, sl.search_cos)
        carla:wait_for_chore(carla_tilt_head, sl.search_cos)
        carla:play_chore_looping(carla_prop_hold, sl.search_cos)
        carla.idle_state = "prop"
    end
end
carla.go_to_sit = function(arg1) -- line 86
    if find_script(carla.prop_end_tilt_head) then
        wait_for_script(carla.prop_end_tilt_head)
    end
    if find_script(carla.go_to_prop) then
        wait_for_script(carla.go_to_prop)
    end
    if carla.idle_state == "proptilt" then
        carla:prop_end_tilt_head()
    end
    if carla.idle_state == "prop" then
        carla:stop_chore(carla_prop_hold, sl.search_cos)
        if not sl.carla_scorned then
            sl.detector.actor:show()
            carla:complete_chore(carla_hide_detector, sl.search_cos)
        else
            sl.detector.actor:hide()
            carla:play_chore(carla_hide_detector, sl.search_cos)
        end
        carla:play_chore(carla_prop_to_sit, sl.search_cos)
        carla:wait_for_chore(carla_prop_to_sit, sl.search_cos)
        carla:play_chore_looping(carla_sit_hold, sl.search_cos)
        carla.idle_state = "sit"
    end
    if carla.idle_state == "stand" then
        carla:stop_chore()
        carla:ignore_boxes()
        MakeSectorActive("carlawalk1", FALSE)
        carla:set_softimage_pos(9.1847, 0.1254, 7.5366)
        carla:setrot(0, 31.513, 0)
        carla:play_chore(carla_sit, sl.search_cos)
        carla:wait_for_chore(carla_sit, sl.search_cos)
        carla:play_chore_looping(carla_sit_hold, sl.search_cos)
        carla.idle_state = "sit"
    end
end
carla.stand_up = function(arg1) -- line 125
    if carla.idle_state ~= "sit" then
        carla:go_to_sit()
    end
    carla:stop_chore(carla_sit_hold, sl.search_cos)
    if not sl.carla_scorned then
        carla:complete_chore(carla_show_detector, sl.search_cos)
        sl.detector.actor:hide()
    else
        carla:play_chore(carla_hide_detector, sl.search_cos)
    end
    carla:set_softimage_pos(8.1365, 0.1254, 7.0952)
    carla:setrot(0, 174.137, 0)
    carla:play_chore(carla_stand, sl.search_cos)
    carla:wait_for_chore(carla_stand, sl.search_cos)
    carla:stop_chore(carla_stand, sl.search_cos)
    carla:play_chore(carla_stand_hold, sl.search_cos)
    carla.idle_state = "stand"
end
carla.set_up_mood_swings = function(arg1) -- line 151
    carla.mood = "casual"
    carla:play_chore_looping(carla_cry_casual_tap_loop, sl.cry_cos)
end
carla.mood_swing = function(arg1, arg2) -- line 156
    if find_script(carla.do_mood_swing) then
        wait_for_script(carla.do_mood_swing)
    end
    start_script(carla.do_mood_swing, carla, arg2)
end
carla.do_mood_swing = function(arg1, arg2) -- line 163
    local local1
    local1 = "to_" .. arg2
    carla[local1](carla)
end
carla.to_casual = function(arg1) -- line 170
    if carla.mood ~= "casual" then
        carla:to_emote()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_ehold_to_chold, sl.cry_cos)
        carla:wait_for_chore(carla_cry_ehold_to_chold, sl.cry_cos)
        carla:play_chore_looping(carla_cry_casual_tap_loop, sl.cry_cos)
        carla.mood = "casual"
    end
end
carla.to_emote = function(arg1) -- line 181
    if carla.mood ~= "emote" then
        if carla.mood == "angry" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_tension_release, sl.cry_cos)
            carla:wait_for_chore(carla_cry_tension_release, sl.cry_cos)
            carla.mood = "tense"
        end
        if carla.mood == "tense" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_rhold_to_ehold, sl.cry_cos)
            carla:wait_for_chore(carla_cry_rhold_to_ehold, sl.cry_cos)
            carla.mood = "emote"
        end
        if carla.mood == "wistful" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_wist_to_ehold, sl.cry_cos)
            carla:wait_for_chore(carla_cry_wist_to_ehold, sl.cry_cos)
            carla.mood = "emote"
        end
        if carla.mood == "sob" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_sob_to_sniffle, sl.cry_cos)
            carla:wait_for_chore(carla_cry_sob_to_sniffle, sl.cry_cos)
            carla.mood = "sniffle"
        end
        if carla.mood == "sniffle" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_sniffle_to_ehold, sl.cry_cos)
            carla:wait_for_chore(carla_cry_sniffle_to_ehold, sl.cry_cos)
            carla.mood = "emote"
        end
        if carla.mood == "stomp" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_stomp_to_ehold, sl.cry_cos)
            carla:wait_for_chore(carla_cry_stomp_to_ehold, sl.cry_cos)
            carla.mood = "emote"
        end
        if carla.mood == "casual" then
            carla:stop_looping_chores()
            carla:play_chore(carla_cry_to_emote_hold, sl.cry_cos)
            carla:wait_for_chore(carla_cry_to_emote_hold, sl.cry_cos)
        end
        carla:play_chore_looping(carla_cry_emote_hold, sl.cry_cos)
        carla.mood = "emote"
    end
end
carla.to_angry = function(arg1) -- line 231
    if carla.mood ~= "angry" then
        carla:to_emote()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_angry, sl.cry_cos)
        carla:wait_for_chore(carla_cry_angry, sl.cry_cos)
        carla:play_chore_looping(carla_cry_tension_hold, sl.cry_cos)
        carla.mood = "angry"
    end
end
carla.to_tense = function(arg1) -- line 242
    if carla.mood ~= "tense" then
        carla:to_angry()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_tension_release, sl.cry_cos)
        carla:wait_for_chore(carla_cry_tension_release, sl.cry_cos)
        carla:play_chore_looping(carla_cry_release_hold, sl.cry_cos)
        carla.mood = "tense"
    end
end
carla.to_bitter = function(arg1) -- line 253
    if carla.mood ~= "bitter" then
        carla:to_emote()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_to_bitter_loop, sl.cry_cos)
        carla:wait_for_chore(carla_cry_to_bitter_loop, sl.cry_cos)
        carla:play_chore_looping(carla_cry_bitter_loop, sl.cry_cos)
        carla.mood = "bitter"
    end
end
carla.to_stomp = function(arg1) -- line 264
    if carla.mood ~= "stomp" then
        carla:to_bitter()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_stomp, sl.cry_cos)
        carla:wait_for_chore(carla_cry_stomp, sl.cry_cos)
        carla:play_chore_looping(carla_cry_stomp_hold, sl.cry_cos)
        carla.mood = "stomp"
    end
end
carla.to_wistful = function(arg1) -- line 275
    if carla.mood ~= "wistful" then
        carla:to_emote()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_to_wistful_tap, sl.cry_cos)
        carla:wait_for_chore(carla_cry_to_wistful_tap, sl.cry_cos)
        carla:play_chore_looping(carla_cry_wistful_tap_loop, sl.cry_cos)
        carla.mood = "wistful"
    end
end
carla.to_cry = function(arg1) -- line 286
    if carla.mood ~= "cry" then
        carla:to_emote()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_to_cry, sl.cry_cos)
        carla:wait_for_chore(carla_cry_to_cry, sl.cry_cos)
        carla:play_chore_looping(carla_cry_cry_hold, sl.cry_cos)
        carla.mood = "cry"
    end
end
carla.to_sob = function(arg1) -- line 297
    if carla.mood ~= "sob" then
        carla:to_cry()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_sob_to, sl.cry_cos)
        carla:wait_for_chore(carla_cry_sob_to, sl.cry_cos)
        carla:play_chore_looping(carla_cry_sob_loop, sl.cry_cos)
        carla.mood = "sob"
    end
end
carla.to_sniffle = function(arg1) -- line 308
    if carla.mood ~= "sniffle" then
        carla:to_sob()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_sob_to_sniffle, sl.cry_cos)
        carla:wait_for_chore(carla_cry_sob_to_sniffle, sl.cry_cos)
        carla:play_chore_looping(carla_cry_sniffle_loop, sl.cry_cos)
        carla.mood = "sniffle"
    end
end
carla.to_detector = function(arg1) -- line 319
    if carla.mood ~= "detector" then
        carla:to_casual()
        carla:stop_looping_chores()
        carla:play_chore(carla_cry_hold_md_out, sl.cry_cos)
        carla:wait_for_chore(carla_cry_hold_md_out, sl.cry_cos)
        carla:play_chore_looping(carla_cry_shake_md_loop, sl.cry_cos)
        carla.mood = "detector"
    end
end
carla.stop_looping_chores = function(arg1) -- line 330
    carla:stop_looping_chore(carla_cry_emote_hold, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_release_hold, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_bitter_loop, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_stomp_hold, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_casual_tap_loop, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_wistful_tap_loop, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_tension_hold, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_cry_hold, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_sob_loop, sl.cry_cos)
    carla:stop_looping_chore(carla_cry_sniffle_loop, sl.cry_cos)
end
