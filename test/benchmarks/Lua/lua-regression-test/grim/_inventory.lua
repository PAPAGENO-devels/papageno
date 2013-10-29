Inventory = { unordered_inventory_table = { }, ordered_inventory_table = { }, index = 0, num_items = 0, wanted_item = { } }
NO_HOT_KEY = 999
Inventory.add_item_to_inventory = function(arg1, arg2) -- line 28
    if type(arg2) == "table" then
        if arg2.owner ~= system.currentActor then
            PutActorInSet(arg2.interest_actor.hActor, nil)
            arg2.owner = system.currentActor
            arg2.touchable = FALSE
            Inventory.unordered_inventory_table[arg2] = arg2
            Inventory.num_items = Inventory.num_items + 1
            Inventory.ordered_inventory_table[Inventory.num_items] = arg2
        else
            PrintDebug("Tried to pick up already-held item:" .. arg2.name .. "!\n")
        end
    else
        PrintDebug("Tried to pick up invalid item:" .. tostring(arg2) .. "!\n")
    end
end
Inventory.remove_item_from_inventory = function(arg1, arg2) -- line 70
    local local1 = 0
    if Inventory.unordered_inventory_table[arg2] then
        Inventory.unordered_inventory_table[arg2] = nil
        Inventory.num_items = Inventory.num_items - 1
        arg2.owner = IN_LIMBO
        while Inventory.ordered_inventory_table[local1] ~= arg2 do
            local1 = local1 + 1
        end
        if not Inventory.ordered_inventory_table[local1 + 1] then
            Inventory.ordered_inventory_table[local1] = nil
        else
            while Inventory.ordered_inventory_table[local1 + 1] do
                Inventory.ordered_inventory_table[local1] = Inventory.ordered_inventory_table[local1 + 1]
                local1 = local1 + 1
            end
            Inventory.ordered_inventory_table[local1] = nil
        end
        if system.currentActor.is_holding then
            system.currentActor.is_holding = nil
        end
    else
        PrintDebug("dropping items I dont have\n")
    end
end
remove_all_items = function() -- line 118
    Inventory.unordered_inventory_table = { }
    Inventory.num_items = 0
    Inventory.ordered_inventory_table = { }
end
Inventory.get_next_inventory_item = function(arg1) -- line 129
    local local1
    START_CUT_SCENE()
    while not local1 do
        Inventory.index = Inventory.index + 1
        if Inventory.index > Inventory.num_items then
            Inventory.index = 0
        end
        local1 = Inventory.ordered_inventory_table[Inventory.index]
        if local1 == mo.scythe and mo.scythe.owner ~= manny then
            local1 = nil
        end
    end
    Inventory.wanted_item = local1
    if not mannys_hands:is_choring() then
        reach_for_it()
    end
    END_CUT_SCENE()
end
Inventory.get_previous_inventory_item = function(arg1) -- line 157
    local local1
    START_CUT_SCENE()
    while not local1 do
        Inventory.index = Inventory.index - 1
        if Inventory.index < 0 then
            Inventory.index = Inventory.num_items
        end
        local1 = Inventory.ordered_inventory_table[Inventory.index]
        if local1 == mo.scythe and mo.scythe.owner ~= manny then
            local1 = nil
        end
    end
    Inventory.wanted_item = local1
    if not mannys_hands:is_choring() then
        reach_for_it()
    end
    END_CUT_SCENE()
end
reach_for_it = function() -- line 188
    local local1
    local local2
    if not system.currentActor.is_holding then
        local2 = TRUE
        if DEMO then
            local1 = demo_inv_emptyhand_in
        elseif manny.costume_state == "suit" then
            local1 = "inventory_empty_hand_in"
        elseif manny.costume_state == "action" then
            local1 = "action_inv_empty_hand_in"
        elseif manny.costume_state == "cafe" then
            local1 = "cafe_inv_empty_hand_in"
        elseif manny.costume_state == "nautical" then
            local1 = "mn_inv_empty_in"
        elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
            if manny.fancy then
                local1 = "mcc_inv_empty_hand_in"
            else
                local1 = "msb_inv_empty_in"
            end
        elseif manny.costume_state == "thunder" then
            local1 = "inventory_empty_hand_in"
        elseif manny.costume_state == "reaper" then
            local1 = "md_inv_empty_hand_in"
        else
            local1 = nil
            PrintDebug("WARNING: INVALID COSTUME STATE SET!")
        end
    elseif manny.costume_state == "suit" then
        if manny.is_holding == mo.one_card and mo.one_card.punched then
            local1 = "inventory_holycard_in"
        elseif manny.is_holding == pk.balloons.balloon1 or manny.is_holding == pk.balloons.balloon2 or manny.is_holding == pk.balloons.balloon3 or manny.is_holding == pk.balloons.balloon4 or manny.is_holding == pk.balloons.balloon5 then
            if manny.is_holding.chem == 1 then
                local1 = "inventory_full_balloon2_in"
            else
                local1 = "inventory_full_balloon_in"
            end
        else
            local1 = "inventory_" .. manny.is_holding.string_name .. "_in"
        end
    elseif manny.costume_state == "action" then
        local1 = "action_inv_" .. system.currentActor.is_holding.string_name .. "_in"
    elseif manny.costume_state == "cafe" then
        if manny.is_holding == hk.turkey_baster and hk.turkey_baster.full then
            local1 = "cafe_inv_full_baster_in"
        elseif manny.is_holding == hk.turkey_baster and not hk.turkey_baster.full then
            local1 = "cafe_inv_turkey_baster_in"
        else
            local1 = "cafe_inv_" .. system.currentActor.is_holding.string_name .. "_in"
        end
    elseif manny.costume_state == "nautical" then
        local1 = "mn_inv_" .. system.currentActor.is_holding.string_name .. "_in"
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            if manny.is_holding == th.grinder and th.grinder.has_bone then
                local1 = "mcc_inv_grinder_full_in"
            else
                local1 = "mcc_inv_" .. system.currentActor.is_holding.string_name .. "_in"
            end
        elseif manny.is_holding == th.grinder and th.grinder.has_bone then
            local1 = "msb_inv_grinder_full_in"
        elseif manny.is_holding == lm.bottle and not lm.bottle.full then
            local1 = "msb_inv_empty_bottle_in"
        else
            local1 = "msb_inv_" .. system.currentActor.is_holding.string_name .. "_in"
        end
    elseif manny.costume_state == "thunder" then
        local1 = "inventory_" .. system.currentActor.is_holding.string_name .. "_in"
    elseif manny.costume_state == "reaper" then
        if manny.is_holding == th.grinder and th.grinder.has_bone == FALSE then
            local1 = "md_inv_grinder_no_hand_in"
        else
            local1 = "md_inv_" .. system.currentActor.is_holding.string_name .. "_in"
        end
    else
        local1 = nil
        PrintDebug("WARNING: INVALID COSTUME STATE SET!")
    end
    PrintDebug(local1)
    if local1 then
        if not local2 then
            single_start_sfx("handIO.wav")
        end
        mannys_hands:play_chore(getglobal(local1))
        system.currentActor.is_holding = Inventory.wanted_item
        mannys_hands:wait_for_chore()
        pull_it_out()
    end
end
pull_it_out = function() -- line 292
    local local1
    local local2
    if not Inventory.wanted_item then
        local2 = TRUE
        if DEMO then
            local1 = demo_inv_empty_hand_out
        elseif manny.costume_state == "suit" then
            local1 = "inventory_empty_hand_out"
        elseif manny.costume_state == "action" then
            local1 = "action_inv_empty_hand_out"
        elseif manny.costume_state == "cafe" then
            local1 = "cafe_inv_empty_hand_out"
        elseif manny.costume_state == "nautical" then
            local1 = "mn_inv_empty_out"
        elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
            if manny.fancy then
                local1 = "mcc_inv_empty_hand_out"
            else
                local1 = "msb_inv_empty_out"
            end
        elseif manny.costume_state == "thunder" then
            local1 = "inventory_empty_hand_out"
        elseif manny.costume_state == "reaper" then
            local1 = "md_inv_empty_hand_out"
        else
            local1 = nil
            PrintDebug("WARNING: INVALID COSTUME STATE SET!")
        end
    elseif manny.costume_state == "suit" then
        if Inventory.wanted_item == mo.one_card and mo.one_card.punched then
            local1 = "inventory_holycard_out"
        elseif Inventory.wanted_item == pk.balloons.balloon1 or Inventory.wanted_item == pk.balloons.balloon2 or Inventory.wanted_item == pk.balloons.balloon3 or Inventory.wanted_item == pk.balloons.balloon4 or Inventory.wanted_item == pk.balloons.balloon5 then
            if Inventory.wanted_item.chem == 1 then
                local1 = "inventory_full_balloon2_out"
            else
                local1 = "inventory_full_balloon_out"
            end
        else
            local1 = "inventory_" .. Inventory.wanted_item.string_name .. "_out"
        end
    elseif manny.costume_state == "action" then
        local1 = "action_inv_" .. Inventory.wanted_item.string_name .. "_out"
    elseif manny.costume_state == "cafe" then
        if manny.is_holding == hk.turkey_baster and hk.turkey_baster.full then
            local1 = "cafe_inv_full_baster_out"
        elseif manny.is_holding == hk.turkey_baster and not hk.turkey_baster.full then
            local1 = "cafe_inv_turkey_baster_out"
        else
            local1 = "cafe_inv_" .. Inventory.wanted_item.string_name .. "_out"
        end
    elseif manny.costume_state == "nautical" then
        local1 = "mn_inv_" .. Inventory.wanted_item.string_name .. "_out"
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            if Inventory.wanted_item == th.grinder and th.grinder.has_bone then
                local1 = "mcc_inv_grinder_full_out"
            else
                local1 = "mcc_inv_" .. Inventory.wanted_item.string_name .. "_out"
            end
        elseif Inventory.wanted_item == th.grinder and th.grinder.has_bone then
            local1 = "msb_inv_grinder_full_out"
        elseif Inventory.wanted_item == lm.bottle and not lm.bottle.full then
            local1 = "msb_inv_empty_bottle_out"
        else
            local1 = "msb_inv_" .. Inventory.wanted_item.string_name .. "_out"
        end
    elseif manny.costume_state == "thunder" then
        local1 = "inventory_" .. Inventory.wanted_item.string_name .. "_out"
    elseif manny.costume_state == "reaper" then
        if Inventory.wanted_item == th.grinder and th.grinder.has_bone == FALSE then
            local1 = "md_inv_grinder_no_hand_out"
        else
            local1 = "md_inv_" .. Inventory.wanted_item.string_name .. "_out"
        end
    else
        local1 = nil
        PrintDebug("WARNING: INVALID COSTUME STATE SET!")
    end
    PrintDebug(local1)
    if local1 then
        if not local2 then
            single_start_sfx("handIO.wav")
        end
        mannys_hands:play_chore(getglobal(local1))
        if Inventory.wanted_item and Inventory.wanted_item.wav then
            single_start_sfx(Inventory.wanted_item.wav)
        end
        if Inventory.wanted_item == mo.scythe then
            start_sfx("scyaway.wav")
        end
        mannys_hands:wait_for_chore()
    end
    if Inventory.wanted_item ~= system.currentActor.is_holding then
        reach_for_it()
    end
end
look_at_item_in_hand = function(arg1) -- line 403
    local local1, local2, local3, local4, local5, local6
    local1, local2, local3 = GetActorNodeLocation(system.currentActor.hActor, 12)
    local4, local5, local6 = GetActorNodeLocation(system.currentActor.hActor, 3)
    local4 = local4 + (local1 - local4) * 5
    local5 = local5 + (local2 - local5) * 5
    local6 = local6 + (local3 - local6) * 5
    if arg1 then
        system.currentActor:head_look_at_point(local4, local5, local6)
    else
        START_CUT_SCENE()
        system.currentActor:head_look_at_point(local4, local5, local6)
        system.currentActor.is_holding:lookAt()
        system.currentActor:wait_for_message()
        system.currentActor:head_look_at(nil)
        END_CUT_SCENE()
    end
end
not_here_table = { "/gtcma16/", "/syma191/", "/syma210/", "/gtcma14/" }
put_away_held_item = function() -- line 435
    open_inventory(TRUE)
end
open_inventory = function(arg1, arg2, arg3) -- line 440
    local local1, local2
    local local3 = system.currentActor.is_holding
    if local3 ~= nil and not local3.can_put_away then
        if not local3:put_away() then
            return
        end
    end
    if system.currentSet == lr then
        reaper_toggle_scythe()
    elseif manny:find_sector_name("elev_trigger") or manny:find_sector_name("elev_open") or manny:find_sector_name("hl_door_trigger") or manny:find_sector_name("lo_door_trigger") or manny:find_sector_name("ga_door_trigger") or manny:find_sector_name("ha_door_trigger") or manny:find_sector_name("ev_trigger") or manny:find_sector_name("ha_ga_box") or manny:find_sector_name("ha_lo_box") and local3 == nil and not arg3 then
        manny:say_line(pick_one_of(not_here_table))
        if arg2 then
            return NO_HOT_KEY
        end
    elseif not inventory_disabled or arg3 then
        if system.currentSet.boxes_shrunk then
            UnShrinkBoxes()
            system.currentSet.boxes_shrunk = FALSE
        end
        SetActorInvClipNode(manny.hActor, 13)
        START_CUT_SCENE()
        if local3 then
            if not Inventory.unordered_inventory_table[system.currentActor.is_holding] then
                Inventory:add_item_to_inventory(system.currentActor.is_holding)
            end
            if local3.putback_flag then
                start_script(local3.putback_flag, local3)
            end
        end
        if local3 == mo.scythe then
            if cutSceneLevel <= 1 then
                set_override(skip_scythe, "putback")
            end
            manny.is_holding = nil
            if manny.costume_state == "reaper" then
                manny:set_rest_chore(nil)
                manny:stop_chore(md_hold_scythe, "md.cos")
                manny:play_chore(md_putback_scythe, "md.cos")
                manny:wait_for_chore()
                manny:stop_chore(md_putback_scythe, "md.cos")
                manny:set_rest_chore(md_rest, "md.cos")
            else
                manny:stop_chore(ms_hold_scythe, manny.base_costume)
                manny.has_scythe_cos = TRUE
                if manny.costume_state == "suit" then
                    manny:push_costume("ma_scythe.cos")
                elseif manny.costume_state == "action" then
                    manny:push_costume("action_scythe.cos")
                elseif manny.costume_state == "cafe" then
                    manny:push_costume("mc_scythe.cos")
                elseif manny.costume_state == "nautical" then
                    manny:push_costume("mn_scythe.cos")
                    if manny.has_hat then
                        manny:play_chore(mn_scythe_hat_on)
                    end
                elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
                    if manny.fancy then
                        manny:push_costume("mcc_scythe.cos")
                    else
                        manny:push_costume("msb_scythe.cos")
                    end
                end
                manny:play_chore(ma_scythe_putaway_scythe_get)
                manny:wait_for_chore(ma_scythe_putaway_scythe_get)
                manny:pop_costume()
                manny.has_scythe_cos = FALSE
            end
        elseif local3 == mo.cards then
            manny.is_holding = nil
            manny:stop_chore(ms_hold_deck, "ms.cos")
            manny:play_chore(ms_putback_deck, "ms.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(ms_putback_deck, "ms.cos")
        elseif local3 == mo.one_card then
            manny.is_holding = nil
            if mo.one_card.punched then
                manny:stop_chore(ms_activate_hole_card, "ms.cos")
            else
                manny:stop_chore(ms_hold_card, "ms.cos")
            end
            manny:play_chore(ms_putback_card, "ms.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(ms_putback_card, "ms.cos")
        elseif local3 == th.grinder then
            manny.is_holding = nil
            if manny.fancy and manny.costume_state ~= "reaper" then
                manny:stop_chore(msb_hold, manny.base_costume)
            end
            manny:play_chore(msb_putback_small, manny.base_costume)
            if manny.costume_state == "reaper" then
                sleep_for(200)
            end
            start_sfx("handIn.wav")
            manny:wait_for_chore(msb_putback_small, manny.base_costume)
            if manny.costume_state == "reaper" then
                if th.grinder.has_bone then
                    manny:stop_chore(md_activate_grinder_full, manny.base_costume)
                else
                    manny:stop_chore(md_activate_grinder_empty, manny.base_costume)
                end
            elseif manny.fancy then
                if th.grinder.has_bone then
                    manny:stop_chore(mcc_thunder_takeout_grinder_full, manny.base_costume)
                else
                    manny:stop_chore(mcc_thunder_takeout_grinder_empty, manny.base_costume)
                end
            elseif th.grinder.has_bone then
                manny:stop_chore(msb_activate_grinder_full, manny.base_costume)
            else
                manny:stop_chore(msb_activate_grinder_empty, manny.base_costume)
            end
        elseif local3 == mn.chisel then
            manny.is_holding = nil
            manny:stop_chore(mn2_hold_chisel, "mn2.cos")
            manny:play_chore(mn2_putaway_chisel, "mn2.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore()
            manny:stop_chore(mn2_putaway_chisel, "mn2.cos")
        elseif local3 == tg.note then
            manny.is_holding = nil
            if manny.fancy then
                manny:play_chore(mcc_thunder_putback_small, manny.base_costume)
                start_sfx("handIn.wav")
                manny:fade_out_chore(mcc_thunder_hold_note, "mcc_thunder.cos", 500)
                manny:wait_for_chore(mcc_thunder_putback_small, manny.base_costume)
                manny:stop_chore(mcc_thunder_hold_note, "mcc_thunder.cos")
            else
                manny:play_chore(msb_putback_small, manny.base_costume)
                start_sfx("handIn.wav")
                manny:stop_chore(msb_hold_note, "msb.cos")
                manny:play_chore(msb_activate_note, "msb.cos")
                manny:wait_for_chore(msb_putback_small, manny.base_costume)
                manny:stop_chore(msb_activate_note, "msb.cos")
            end
        elseif local3 == cc.jacket then
            manny.is_holding = nil
            manny:stop_chore(mc_hold_coat, "mc.cos")
            manny:play_chore_looping(mc_activate_jacket, "mc.cos")
            manny:play_chore(mc_putback_small, "mc.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(mc_putback_small, "mc.cos")
            manny:stop_chore(mc_activate_jacket, "mc.cos")
        elseif local3 == fi.gun and manny.costume_state == "reaper" then
            manny:play_chore_looping(md_activate_gun, "md.cos")
            manny:stop_chore(md_hold, "md.cos")
            manny:stop_chore(md_hold_gun, "md.cos")
            manny:play_chore(md_putback_small, "md.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(md_putback_small, "md.cos")
            manny:stop_chore(md_activate_gun, "md.cos")
            manny.is_holding = nil
        elseif local3 == hk.turkey_baster then
            manny:stop_chore(mc_hold, "mc.cos")
            manny:play_chore(mc_putback_small, "mc.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(mc_putback_small, "mc.cos")
            manny:stop_chore(mc_activate_turkey_baster, "mc.cos")
            manny:stop_chore(mc_activate_full_baster, "mc.cos")
            manny.is_holding = nil
        elseif local3 == lm.bottle then
            manny:stop_chore(msb_hold, "msb.cos")
            manny:play_chore(msb_putback_small, "msb.cos")
            start_sfx("handIn.wav")
            manny:wait_for_chore(msb_putback_small, "msb.cos")
            manny:stop_chore(msb_putback_small, "msb.cos")
            if local3.full then
                manny:stop_chore(msb_activate_bottle, "msb.cos")
            else
                manny:stop_chore(msb_activate_empty_bottle, "msb.cos")
            end
            manny.is_holding = nil
        else
            if local3 then
                manny:stop_chore(ms_hold, manny.base_costume)
                if local3.big then
                    if manny.costume_state == "nautical" then
                        local1 = mn2_putback_big_new
                    else
                        local1 = ms_putback_big
                    end
                elseif manny.costume_state == "nautical" then
                    local1 = mn2_putback_new
                else
                    local1 = ms_putback_small
                end
                manny.is_holding = nil
            else
                local1 = ms_takeout_get
            end
            manny:play_chore(local1, manny.base_costume)
            if manny.costume_state == "reaper" then
                sleep_for(200)
            elseif local1 == ms_takeout_get then
                sleep_for(200)
            end
            start_sfx("handIn.wav")
        end
        manny:wait_for_chore(local1, manny.base_costume)
        manny:stop_chore(manny.hold_chore, manny.base_costume)
        if local3 == me.ticket then
            manny:stop_chore(md_activate_ticket, "md.cos")
            manny:stop_chore(md_activate_tix_nowig, "md.cos")
        end
        if manny.costume_state == "thunder" and not manny.fancy then
            manny:play_chore(msb_thunder_no_talk, manny.base_costume)
        else
            manny:play_chore(ms_stop_talk, manny.base_costume)
        end
        if not arg2 then
            if arg1 then
                manny:stop_chore(local1, manny.base_costume)
                if manny.costume_state == "thunder" and not manny.fancy then
                    manny:play_chore(msb_thunder_no_talk, manny.base_costume)
                else
                    manny:play_chore(ms_stop_talk, manny.base_costume)
                end
                if manny.costume_state == "nautical" and manny.has_hat then
                    manny:play_chore_looping(mn2_hat_on, "mn2.cos")
                end
                manny:play_chore(ms_putback_done, manny.base_costume)
                manny:wait_for_chore(ms_putback_done, manny.base_costume)
                manny:stop_chore(ms_putback_done, manny.base_costume)
                if manny.costume_state == "thunder" and not manny.fancy then
                    manny:play_chore(msb_thunder_no_talk, manny.base_costume)
                else
                    manny:play_chore(ms_stop_talk, manny.base_costume)
                end
            else
                inventory_save_set = system.currentSet
                inventory_save_setup = system.currentSet:current_setup()
                inventory_save_pos = manny:getpos()
                inventory_save_handler = system.buttonHandler
                system.buttonHandler = suitInventoryButtonHandler
                Inventory:switch_to_set()
            end
        end
        END_CUT_SCENE()
        SetActorInvClipNode(manny.hActor, -1)
    end
end
close_inventory = function(arg1) -- line 719
    local local1 = system.currentActor.is_holding
    local local2, local3
    local local4, local5, local6
    local local7 = { }
    local local8 = { }
    local local9
    SetActorInvClipNode(manny.hActor, 13)
    stop_script(Inventory.get_next_inventory_item)
    stop_script(Inventory.get_previous_inventory_item)
    if system.currentSet == suit_inv or system.currentSet == action_inv or system.currentSet == cafe_inv or system.currentSet == nautical_inv or system.currentSet == siberian_inv or system.currentSet == death_inv or system.currentSet == charlie_inv then
        inCloseUpSet = TRUE
    else
        inCloseUpSet = FALSE
    end
    if arg1 then
        local1 = nil
        manny.is_holding = nil
        if cutSceneLevel then
            END_CUT_SCENE()
        end
    end
    START_CUT_SCENE()
    if inCloseUpSet then
        mannys_hands:wait_for_chore()
        Inventory:return_to_set()
        inventory_save_set:current_setup(inventory_save_setup)
        manny:setpos(inventory_save_pos)
        if inventory_save_handler then
            system.buttonHandler = inventory_save_handler
        else
            system.buttonHandler = SampleButtonHandler
        end
    end
    if local1 == mo.scythe and system.currentSet == si and not in_year_four then
        manny.is_holding = nil
        END_CUT_SCENE()
        start_script(si.takeout_scythe)
        return nil
    end
    if local1 == mo.scythe and in(system.currentSet.setFile, no_scythe_sets) then
        PrintDebug("cant remove scythe here!")
        manny:say_line(pick_one_of(not_here_table))
        manny.is_holding = nil
        manny:stop_takeout_chores()
        manny:play_chore(ms_takeout_empty, manny.base_costume)
        manny:wait_for_chore(ms_takeout_empty, manny.base_costume)
        manny:stop_chore(ms_takeout_empty, manny.base_costume)
        END_CUT_SCENE()
        return nil
    end
    if local1 and local1.wav then
        start_script(inv_sound_delay, local1.wav)
    end
    if not inventory_test_actor then
        inventory_test_actor = Actor:create(nil, nil, nil, "test")
    end
    if manny.costume_state == "suit" then
        local9 = ms_takeout_gethold
    elseif manny.costume_state == "action" then
        local9 = ma_takeout_gethold
    elseif manny.costume_state == "cafe" then
        local9 = mc_takeout_gethold
    elseif manny.costume_state == "nautical" then
        local9 = mn2_takeout_gethold
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            local9 = mcc_thunder_takeout_gethold
        else
            local9 = msb_takeout_gethold
        end
    end
    if local1 then
        if local1.shrink_radius and shrinkBoxesEnabled then
            local7 = manny:getpos()
            if system.currentSet.shrinkable then
                local4, local5, local6 = GetShrinkPos(local7.x, local7.y, local7.z, local1.shrink_radius)
                local8 = manny:getrot()
                if local1 == mo.scythe and in(system.currentSet.setFile, need_scythe_sets) then
                    if local7.x ~= local4 or local7.y ~= local5 or local7.z ~= local6 then
                        if not local4 then
                            local4, local5, local6 = GetShrinkPos(local7.x, local7.y, local7.z, system.currentSet.shrinkable)
                        end
                        inventory_test_actor:set_costume("x_spot.cos")
                        inventory_test_actor:follow_boxes()
                        inventory_test_actor:put_in_set(system.currentSet)
                        inventory_test_actor:set_visibility(FALSE)
                        inventory_test_actor:setpos(local4, local5, local6)
                        if inventory_test_actor:find_sector_type(HOT) then
                            inventory_test_actor:free()
                            manny.is_holding = nil
                            manny:say_line(pick_one_of(not_here_table))
                            manny:stop_takeout_chores()
                            manny:play_chore(ms_takeout_empty, manny.base_costume)
                            start_sfx("handOut.wav")
                            manny:wait_for_chore(ms_takeout_empty, manny.base_costume)
                            manny:stop_chore(ms_takeout_empty, manny.base_costume)
                            END_CUT_SCENE()
                            return nil
                        end
                        inventory_test_actor:free()
                        cameraman_disabled = FALSE
                        manny:play_chore_looping(local9, manny.base_costume)
                        manny:walkto(local4, local5, local6, local8.x, local8.y, local8.z)
                    end
                    if system.currentSet.shrinkable < local1.shrink_radius then
                        ShrinkBoxes(system.currentSet.shrinkable)
                    else
                        ShrinkBoxes(local1.shrink_radius)
                    end
                    system.currentSet.boxes_shrunk = TRUE
                elseif not local4 then
                    manny.is_holding = nil
                    manny:say_line(pick_one_of(not_here_table))
                    manny:stop_takeout_chores()
                    manny:play_chore(ms_takeout_empty, manny.base_costume)
                    start_sfx("handOut.wav")
                    manny:wait_for_chore(ms_takeout_empty, manny.base_costume)
                    manny:stop_chore(ms_takeout_empty, manny.base_costume)
                    END_CUT_SCENE()
                    return nil
                else
                    if local7.x ~= local4 or local7.y ~= local5 or local7.z ~= local6 then
                        cameraman_disabled = FALSE
                        inventory_test_actor:set_costume("x_spot.cos")
                        inventory_test_actor:follow_boxes()
                        inventory_test_actor:put_in_set(system.currentSet)
                        inventory_test_actor:set_visibility(FALSE)
                        inventory_test_actor:setpos(local4, local5, local6)
                        if inventory_test_actor:find_sector_type(HOT) then
                            inventory_test_actor:free()
                            manny.is_holding = nil
                            manny:say_line(pick_one_of(not_here_table))
                            manny:stop_takeout_chores()
                            manny:play_chore(ms_takeout_empty, manny.base_costume)
                            start_sfx("handOut.wav")
                            manny:wait_for_chore(ms_takeout_empty, manny.base_costume)
                            manny:stop_chore(ms_takeout_empty, manny.base_costume)
                            END_CUT_SCENE()
                            return nil
                        end
                        inventory_test_actor:free()
                        manny:play_chore_looping(local9, manny.base_costume)
                        manny:walkto(local4, local5, local6, local8.x, local8.y, local8.z)
                    end
                    if system.currentSet.shrinkable < local1.shrink_radius then
                        ShrinkBoxes(system.currentSet.shrinkable)
                    else
                        ShrinkBoxes(local1.shrink_radius)
                    end
                    system.currentSet.boxes_shrunk = TRUE
                end
            end
        end
    end
    manny:stop_chore(local9, manny.base_costume)
    manny:stop_takeout_chores()
    if local1 == mo.scythe then
        SetActorInvClipNode(manny.hActor, -1)
        if cutSceneLevel <= 1 then
            set_override(skip_scythe, "takeout")
        end
        if manny.costume_state == "reaper" then
            manny:set_rest_chore(nil)
            manny:play_chore(md_takeout_scythe_get, "md.cos")
            manny:wait_for_chore()
            manny:play_chore_looping(md_hold_scythe, "md.cos")
            manny:fade_out_chore(md_takeout_scythe_get, "md.cos", 500)
            manny:set_rest_chore(md_rest, "md.cos")
        else
            manny.has_scythe_cos = TRUE
            if manny.costume_state == "suit" then
                manny:push_costume("ma_scythe.cos")
            elseif manny.costume_state == "action" then
                manny:push_costume("action_scythe.cos")
            elseif manny.costume_state == "cafe" then
                manny:push_costume("mc_scythe.cos")
            elseif manny.costume_state == "nautical" then
                manny:push_costume("mn_scythe.cos")
                if manny.has_hat then
                    manny:play_chore(mn_scythe_hat_on)
                end
            elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
                if manny.fancy then
                    manny:push_costume("mcc_scythe.cos")
                else
                    manny:push_costume("msb_scythe.cos")
                end
            end
            manny:play_chore(ma_scythe_takeout_scythe)
            manny:wait_for_chore(ma_scythe_takeout_scythe)
            manny:pop_costume()
            manny.has_scythe_cos = FALSE
            manny.hold_chore = ms_hold_scythe
            manny:play_chore_looping(ms_hold_scythe, manny.base_costume)
            if manny.costume_state == "nautical" and manny.has_hat then
                manny:play_chore_looping(mn2_hat_on, "mn2.cos")
            end
        end
        manny.is_holding = mo.scythe
    elseif local1 == mo.cards then
        manny:play_chore(ms_takeout_deck, "ms.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(ms_takeout_deck, "ms.cos")
        manny:play_chore_looping(ms_hold_deck, "ms.cos")
        manny:stop_chore(ms_takeout_deck, "ms.cos")
        manny.hold_chore = nil
        manny.is_holding = mo.cards
    elseif local1 == mo.one_card then
        manny:play_chore(ms_takeout_card, "ms.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(ms_takeout_card, "ms.cos")
        manny:stop_chore(ms_takeout_card, "ms.cos")
        if mo.one_card.punched then
            manny:play_chore_looping(ms_activate_hole_card, "ms.cos")
        else
            manny:play_chore_looping(ms_hold_card, "ms.cos")
        end
        manny.hold_chore = nil
        manny.is_holding = mo.one_card
    elseif local1 == th.grinder then
        manny.is_holding = th.grinder
        if manny.costume_state == "reaper" then
            if th.grinder.has_bone then
                manny:play_chore(md_activate_grinder_full, manny.base_costume)
            else
                manny:play_chore(md_activate_grinder_empty, manny.base_costume)
            end
            manny:play_chore(msb_takeout_small, manny.base_costume)
            start_sfx("handOut.wav")
            manny:wait_for_chore(msb_takeout_small, manny.base_costume)
            manny:stop_chore(msb_takeout_small, manny.base_costume)
            manny:stop_chore(md_activate_grinder_full, "md.cos")
            manny:stop_chore(md_activate_grinder_empty, "md.cos")
            manny:play_chore_looping(md_hold_grinder, manny.base_costume)
            manny:play_chore_looping(md_hold, manny.base_costume)
            manny.hold_chore = md_hold_grinder
        elseif manny.fancy then
            if th.grinder.has_bone then
                manny:play_chore(mcc_thunder_takeout_grinder_full, manny.base_costume)
            else
                manny:play_chore(mcc_thunder_takeout_grinder_empty, manny.base_costume)
            end
            manny:play_chore(mcc_thunder_takeout_small, manny.base_costume)
            start_sfx("handOut.wav")
            manny:wait_for_chore(mcc_thunder_takeout_small, manny.base_costume)
            manny:stop_chore(mcc_thunder_takeout_small, manny.base_costume)
            manny:play_chore_looping(msb_hold, manny.base_costume)
            manny.hold_chore = nil
        else
            if th.grinder.has_bone then
                manny:play_chore_looping(msb_activate_grinder_full, manny.base_costume)
            else
                manny:play_chore_looping(msb_activate_grinder_empty, manny.base_costume)
            end
            manny:play_chore(msb_takeout_small, manny.base_costume)
            start_sfx("handOut.wav")
            manny:wait_for_chore(msb_takeout_small, manny.base_costume)
            manny:stop_chore(msb_takeout_small, manny.base_costume)
            manny:play_chore_looping(msb_hold, manny.base_costume)
            manny.hold_chore = nil
        end
    elseif local1 == mn.chisel then
        manny.is_holding = mn.chisel
        manny:play_chore(mn2_takeout_chisel, "mn2.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore()
        manny:stop_chore(mn2_takeout_chisel, "mn2.cos")
        manny:play_chore_looping(mn2_activate_chisel, "mn2.cos")
        manny.hold_chore = mn2_activate_chisel
    elseif local1 == tg.note then
        manny.is_holding = tg.note
        if manny.fancy then
            manny:play_chore(mcc_thunder_takeout_small, manny.base_costume)
            start_sfx("handOut.wav")
            manny:play_chore_looping(mcc_thunder_hold_note, "mcc_thunder.cos")
            manny:wait_for_chore(mcc_thunder_takeout_small, manny.base_costume)
            manny:stop_chore(mcc_thunder_takeout_small, manny.base_costume)
            manny.hold_chore = nil
        else
            manny:play_chore(msb_takeout_small, manny.base_costume)
            start_sfx("handOut.wav")
            manny:play_chore_looping(msb_hold_note, "msb.cos")
            manny:wait_for_chore(msb_takeout_small, manny.base_costume)
            manny:stop_chore(msb_takeout_small, manny.base_costume)
            manny.hold_chore = nil
        end
    elseif local1 == pk.balloons.balloon1 or local1 == pk.balloons.balloon2 or local1 == pk.balloons.balloon3 or local1 == pk.balloons.balloon4 or local1 == pk.balloons.balloon5 then
        manny.is_holdong = local1
        if local1.chem == 1 then
            manny:play_chore(ms_takeout_big, "ms.cos")
            start_sfx("handOut.wav")
            manny:play_chore_looping(ms_activate_full_balloon2, "ms.cos")
            manny:wait_for_chore(ms_takeout_big, "ms.cos")
            manny:stop_chore(ms_takeout_big, "ms.cos")
            manny.hold_chore = ms_activate_full_balloon2
        else
            manny:play_chore(ms_takeout_big, "ms.cos")
            start_sfx("handOut.wav")
            manny:play_chore_looping(ms_activate_full_balloon, "ms.cos")
            manny:wait_for_chore(ms_takeout_big, "ms.cos")
            manny:stop_chore(ms_takeout_big, "ms.cos")
            manny.hold_chore = ms_activate_full_balloon
        end
        manny:play_chore_looping(ms_hold, "ms.cos")
    elseif local1 == cc.jacket then
        manny:play_chore_looping(mc_activate_jacket, "mc.cos")
        manny:play_chore(mc_takeout_small, "mc.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(mc_takeout_small, "mc.cos")
        manny:stop_chore(mc_takeout_small, "mc.cos")
        manny:stop_chore(mc_activate_jacket, "mc.cos")
        manny.hold_chore = mc_hold_jacket
        manny:play_chore_looping(mc_hold_coat, "mc.cos")
        manny.is_holding = local1
    elseif local1 == fi.gun and manny.costume_state == "reaper" then
        manny:play_chore_looping(md_activate_gun, "md.cos")
        manny:play_chore(md_takeout_small, "md.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(md_takeout_small, "md.cos")
        manny:stop_chore(md_takeout_small, "md.cos")
        manny:stop_chore(md_activate_gun, "md.cos")
        manny:play_chore_looping(md_hold_gun, "md.cos")
        manny:play_chore_looping(md_hold, "md.cos")
        manny.is_holding = local1
    elseif local1 == hk.turkey_baster then
        if local1.full then
            manny:play_chore_looping(mc_activate_full_baster, "mc.cos")
            manny.hold_chore = nil
        else
            manny:play_chore_looping(mc_activate_turkey_baster, "mc.cos")
            manny.hold_chore = nil
        end
        manny:play_chore(mc_takeout_small, "mc.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(mc_takeout_small, "mc.cos")
        manny:stop_chore(mc_takeout_small, "mc.cos")
        manny:play_chore_looping(mc_hold, "mc.cos")
        manny.is_holding = local1
    elseif local1 == lm.bottle then
        manny.is_holding = local1
        if local1.full then
            manny:play_chore_looping(msb_activate_bottle, "msb.cos")
        else
            manny:play_chore_looping(msb_activate_empty_bottle, "msb.cos")
        end
        manny:play_chore(msb_takeout_small, "msb.cos")
        start_sfx("handOut.wav")
        manny:wait_for_chore(msb_takeout_small, "msb.cos")
        manny:stop_chore(msb_takeout_small, "msb.cos")
        manny:play_chore_looping(msb_hold, "msb.cos")
        manny.hold_chore = nil
    else
        if not local1 then
            local2 = ms_takeout_empty
        elseif local1.big then
            local2 = ms_takeout_big
        elseif manny.costume_state == "nautical" then
            local2 = mn2_takeout_new
        elseif manny.costume_state == "reaper" then
            local2 = md_takeout_small
        else
            local2 = ms_takeout_small
        end
        if local1 then
            if local1.takeout_flag then
                start_script(local1.takeout_flag, local1)
            end
            if manny.costume_state == "suit" then
                local3 = "ms_activate_" .. local1.string_name
            elseif manny.costume_state == "action" then
                local3 = "ma_activate_" .. local1.string_name
            elseif manny.costume_state == "cafe" then
                local3 = "mc_activate_" .. local1.string_name
            elseif manny.costume_state == "nautical" then
                local3 = "mn2_activate_" .. local1.string_name
            elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
                if manny.fancy then
                    local3 = "mcc_thunder_activate_" .. local1.string_name
                else
                    local3 = "msb_activate_" .. local1.string_name
                end
            elseif manny.costume_state == "reaper" then
                local3 = "md_activate_" .. local1.string_name
            else
                PrintDebug("WARNING!  NO VALID ACTIVATE CHORE SET!  COSTUME STATE = " .. manny.costume_state .. "\n")
            end
            if local3 then
                PrintDebug(local3 .. "\n")
                manny:play_chore_looping(getglobal(local3), manny.base_costume)
            end
        end
        if manny.costume_state == "thunder" and not manny.fancy then
            manny:play_chore(msb_thunder_no_talk, manny.base_costume)
        else
            manny:play_chore(ms_stop_talk, manny.base_costume)
        end
        manny:play_chore(local2, manny.base_costume)
        if local1 then
            PrintDebug(local1.name)
            start_sfx("handOut.wav")
        end
        manny:wait_for_chore(local2, manny.base_costume)
        manny:stop_chore(local2, manny.base_costume)
        if local1 then
            if local3 then
                manny.hold_chore = getglobal(local3)
            end
            manny:play_chore_looping(ms_hold, manny.base_costume)
        else
            manny.hold_chore = nil
        end
    end
    SetActorInvClipNode(manny.hActor, -1)
    END_CUT_SCENE()
    set_override(nil)
end
skip_scythe = function(arg1) -- line 1163
    kill_override(TRUE)
    system.lock_display()
    if manny.has_scythe_cos then
        manny:pop_costume()
    else
        manny:stop_chore(md_takeout_scythe_get, "md.cos")
        manny:stop_chore(md_putback_scythe, "md.cos")
        manny:set_rest_chore(md_rest, "md.cos")
    end
    if arg1 == "takeout" then
        manny.hold_chore = ms_hold_scythe
        manny:play_chore_looping(ms_hold_scythe, manny.base_costume)
        manny.is_holding = mo.scythe
    else
        manny.is_holding = nil
        manny:stop_chore(ms_hold_scythe, manny.base_costume)
    end
    break_here()
    system.unlock_display()
end
inventory_item_is_holdable = function(arg1) -- line 1186
    local local1
    local local2
    local1 = TRUE
    if arg1 == mo.scythe and in(system.currentSet.setFile, no_scythe_sets) then
        local1 = FALSE
    elseif arg1 == mo.scythe and system.currentSet == si then
        local1 = FALSE
    elseif system.currentSet == lr then
        if arg1 ~= mo.scythe then
            local1 = FALSE
        end
    elseif arg1 then
        if arg1.shrink_radius and shrinkBoxesEnabled then
            pos = manny:getpos()
            if system.currentSet.shrinkable then
                if system.currentSet.boxes_shrunk then
                    if manny.is_holding then
                        local2 = manny.is_holding.shrink_radius
                    end
                    UnShrinkBoxes()
                    system.currentSet.boxes_shrunk = FALSE
                end
                x, y, z = GetShrinkPos(pos.x, pos.y, pos.z, arg1.shrink_radius)
                rot = manny:getrot()
                if arg1 == mo.scythe and in(system.currentSet.setFile, need_scythe_sets) then
                    if pos.x ~= x or pos.y ~= y or pos.z ~= z then
                        local1 = FALSE
                    end
                elseif not x then
                    local1 = FALSE
                elseif pos.x ~= x or pos.y ~= y or pos.z ~= z then
                    local1 = FALSE
                end
                if local2 then
                    ShrinkBoxes(local2)
                    system.currentSet.boxes_shrunk = TRUE
                end
            end
        end
    else
        local1 = FALSE
    end
    return local1
end
hotkey_cycle_inventory_item = function(arg1) -- line 1240
    local local1, local2
    local local3, local4, local5, local6
    local3, local4 = next(Inventory.ordered_inventory_table, nil)
    while local3 do
        local4.cycle_tagged = FALSE
        local3, local4 = next(Inventory.ordered_inventory_table, local3)
    end
    local6 = system.currentActor.is_holding
    local5 = nil
    local3, local4 = next(Inventory.ordered_inventory_table, nil)
    while local3 and not local5 do
        if local4 == local6 then
            local5 = local3
        end
        local3, local4 = next(Inventory.ordered_inventory_table, local3)
    end
    local2 = TRUE
    while local2 do
        if not local5 then
            local5 = 1
        elseif not arg1 then
            local5 = local5 - 1
        else
            local5 = local5 + 1
        end
        local1 = Inventory.ordered_inventory_table[local5]
        if not local1 then
            if not arg1 then
                local5 = Inventory.num_items
            else
                local5 = 1
            end
            local1 = Inventory.ordered_inventory_table[local5]
        end
        if local1 then
            if local1 == local6 or local1.cycle_tagged then
                local2 = FALSE
                local1 = nil
            elseif inventory_item_is_holdable(local1) then
                local2 = FALSE
            end
        else
            local2 = FALSE
        end
        if local1 then
            local1.cycle_tagged = TRUE
        end
    end
    local3, local4 = next(Inventory.ordered_inventory_table, nil)
    while local3 do
        local4.cycle_tagged = FALSE
        local3, local4 = next(Inventory.ordered_inventory_table, local3)
    end
    return local1
end
inventory_hot_key_pressed = function(arg1) -- line 1320
    local local1 = system.currentActor.is_holding
    local local2
    if not inventory_disabled then
        if local1 ~= nil and not local1.can_put_away then
            if not local1:put_away() then
                return
            end
        end
        if arg1 == MINUSKEY then
            item = hotkey_cycle_inventory_item(FALSE)
        elseif arg1 == EQUALSKEY then
            item = hotkey_cycle_inventory_item(TRUE)
        elseif shiftKeyDown then
            if arg1 == KEY1 then
                item = Inventory.ordered_inventory_table[10]
            elseif arg1 == KEY2 then
                item = Inventory.ordered_inventory_table[11]
            elseif arg1 == KEY3 then
                item = Inventory.ordered_inventory_table[12]
            elseif arg1 == KEY4 then
                item = Inventory.ordered_inventory_table[13]
            elseif arg1 == KEY5 then
                item = Inventory.ordered_inventory_table[14]
            elseif arg1 == KEY6 then
                item = Inventory.ordered_inventory_table[15]
            elseif arg1 == KEY7 then
                item = Inventory.ordered_inventory_table[16]
            elseif arg1 == KEY8 then
                item = Inventory.ordered_inventory_table[17]
            elseif arg1 == KEY9 then
                item = Inventory.ordered_inventory_table[18]
            end
        elseif arg1 == KEY1 then
            item = Inventory.ordered_inventory_table[1]
        elseif arg1 == KEY2 then
            item = Inventory.ordered_inventory_table[2]
        elseif arg1 == KEY3 then
            item = Inventory.ordered_inventory_table[3]
        elseif arg1 == KEY4 then
            item = Inventory.ordered_inventory_table[4]
        elseif arg1 == KEY5 then
            item = Inventory.ordered_inventory_table[5]
        elseif arg1 == KEY6 then
            item = Inventory.ordered_inventory_table[6]
        elseif arg1 == KEY7 then
            item = Inventory.ordered_inventory_table[7]
        elseif arg1 == KEY8 then
            item = Inventory.ordered_inventory_table[8]
        elseif arg1 == KEY9 then
            item = Inventory.ordered_inventory_table[9]
        end
        if item ~= local1 then
            if item then
                if item == mo.scythe and mo.scythe.owner ~= manny then
                elseif system.current_set == at and item ~= sh.remote then
                    system.default_response("not now")
                else
                    if item.wav then
                        preload_sfx(item.wav)
                    end
                    if manny.dying then
                        dead_open_inventory()
                    else
                        local2 = open_inventory(TRUE, TRUE)
                        if local2 ~= NO_HOT_KEY then
                            manny.is_holding = item
                            start_script(close_inventory)
                        end
                    end
                end
            end
        end
    elseif system.currentSet == lr and arg1 == KEY1 or arg1 == MINUSKEY or arg1 == EQUALSKEY then
        reaper_toggle_scythe()
    else
        system.default_response("not now")
    end
end
dofile("inventory.lua")
dofile("action_inv.lua")
dofile("cafe_inv.lua")
dofile("mn_inv.lua")
dofile("msb_inv.lua")
dofile("md_inv.lua")
dofile("mcc_inv.lua")
dofile("mn_scythe.lua")
suit_inv = Set:create("suit_inv.set", "yr_1A_inv", { yr_1A_inv = 0 })
action_inv = Set:create("action_inv.set", "yr_1B_inv", { yr_1B_inv = 0 })
cafe_inv = Set:create("cafe_inv.set", "yr_2_inv", { yr_2_inv = 0 })
nautical_inv = Set:create("nautical_inv.set", "yr_3_inv", { yr_3_inv = 0 })
siberian_inv = Set:create("siberian_inv.set", "yr_4_inv", { yr_4_inv = 0 })
death_inv = Set:create("death_inv.set", "yr_4A_inv", { yr_4A_inv = 0 })
charlie_inv = Set:create("charlie_inv.set", "yr_4B_inv", { yr_4B_inv = 0 })
inv_sets = { suit_inv, action_inv, cafe_inv, nautical_inv, siberian_inv, death_inv, charlie_inv }
Inventory.set_up_actors = function(arg1, arg2) -- line 1441
    local local1
    local local2
    if DEMO then
        local1 = "demo_inv.cos"
    elseif manny.costume_state == "suit" then
        local1 = "inventory.cos"
    elseif manny.costume_state == "action" then
        local1 = "action_inv.cos"
    elseif manny.costume_state == "cafe" then
        local1 = "cafe_inv.cos"
    elseif manny.costume_state == "nautical" then
        local1 = "mn_inv.cos"
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            local1 = "mcc_inv.cos"
        else
            local1 = "msb_inv.cos"
        end
    elseif manny.costume_state == "reaper" then
        local1 = "md_inv.cos"
    end
    if not mannys_hands then
        mannys_hands = Actor:create(nil, nil, nil, "/sytx188/")
    end
    mannys_hands:set_costume(local1)
    mannys_hands:put_in_set(arg2)
    if manny.costume_state == "suit" then
        mannys_hands:moveto(0, 0, -0.050000001)
    elseif manny.costume_state == "reaper" then
        mannys_hands:setpos(0.0099999998, 0, -0.15000001)
    else
        mannys_hands:moveto(0, 0, 0)
    end
    mannys_hands:setrot(0, 180, 0)
    start_script(Inventory.get_next_inventory_item)
end
Inventory.switch_to_set = function(arg1) -- line 1483
    local local1
    local local2, local3
    if IsMoviePlaying() then
        StopMovie()
    else
        system.loopingMovie = nil
    end
    system:lock_display()
    system.lastSet = system.currentSet
    LockSet(system.currentSet.setFile)
    if manny.costume_state == "suit" then
        local1 = suit_inv
    elseif manny.costume_state == "action" then
        local1 = action_inv
    elseif manny.costume_state == "cafe" then
        local1 = cafe_inv
    elseif manny.costume_state == "nautical" then
        local1 = nautical_inv
    elseif manny.costume_state == "siberian" or manny.costume_state == "thunder" then
        if manny.fancy then
            local1 = charlie_inv
        else
            local1 = siberian_inv
        end
    elseif manny.costume_state == "reaper" then
        local1 = death_inv
    end
    local2, local3 = next(Inventory.unordered_inventory_table, nil)
    while local2 do
        if local3.wav then
            preload_sfx(local3.wav)
        end
        local2, local3 = next(Inventory.unordered_inventory_table, local2)
    end
    MakeCurrentSet(local1.setFile)
    Inventory:set_up_actors(local1)
    system.currentSet = local1
    if system.ambientLight then
        SetAmbientLight(system.ambientLight)
    end
    system:unlock_display()
end
Inventory.return_to_set = function(arg1) -- line 1536
    PrintDebug("leaving inventory")
    mannys_hands:free()
    system.currentSet = inventory_save_set
    UnLockSet(inventory_save_set.setFile)
    MakeCurrentSet(inventory_save_set.setFile)
    if system.loopingMovie and type(system.loopingMovie) == "table" then
        play_movie_looping(system.loopingMovie.name, system.loopingMovie.x, system.loopingMovie.y)
    end
    if system.currentSet == sh or system.currentSet == zw then
        sh:set_up_flowers()
    end
end
reaper_toggle_scythe = function() -- line 1556
    START_CUT_SCENE()
    if manny.is_holding then
        if cutSceneLevel <= 1 then
            set_override(skip_scythe, "putback")
        end
        manny:set_rest_chore(nil)
        manny:stop_chore(md_hold_scythe, "md.cos")
        manny:play_chore(md_putback_scythe, "md.cos")
        manny:wait_for_chore()
        manny:stop_chore(md_putback_scythe, "md.cos")
        manny:set_rest_chore(md_rest, "md.cos")
        manny.is_holding = nil
    else
        if cutSceneLevel <= 1 then
            set_override(skip_scythe, "takeout")
        end
        manny:set_rest_chore(nil)
        manny:play_chore(md_takeout_scythe_get, "md.cos")
        manny:wait_for_chore()
        manny:play_chore_looping(md_hold_scythe, "md.cos")
        manny:fade_out_chore(md_takeout_scythe_get, "md.cos", 500)
        manny:set_rest_chore(md_rest, "md.cos")
        manny.is_holding = mo.scythe
    end
    END_CUT_SCENE()
    set_override(nil)
end
display_held_item = function() -- line 1591
end
inInventorySet = function() -- line 1612
    if system.currentSet == suit_inv or system.currentSet == action_inv or system.currentSet == cafe_inv or system.currentSet == nautical_inv or system.currentSet == siberian_inv or system.currentSet == death_inv or system.currentSet == charlie_inv then
        return TRUE
    else
        return FALSE
    end
end
dead_open_inventory = function(arg1, arg2) -- line 1624
    local local1 = system.currentActor.is_holding
    START_CUT_SCENE()
    if local1 then
        manny.is_holding = nil
    end
    manny:play_chore(md_dying_putback, "md_dying.cos")
    manny:wait_for_chore(md_dying_putback, "md_dying.cos")
    manny:stop_chore(manny.hold_chore, manny.base_costume)
    manny:stop_chore(md_dying_putback, "md_dying.cos")
    manny:play_chore(ms_stop_talk, manny.base_costume)
    if not arg2 then
        if arg1 then
            manny:play_chore(md_dying_takeout, "md_dying.cos")
            manny:wait_for_chore(md_dying_takeout, "md_dying.cos")
            manny:play_chore(ms_stop_talk, manny.base_costume)
        else
            inventory_save_set = system.currentSet
            inventory_save_setup = system.currentSet:current_setup()
            inventory_save_pos = manny:getpos()
            inventory_save_handler = system.buttonHandler
            system.buttonHandler = suitInventoryButtonHandler
            Inventory:switch_to_set()
        end
    end
    END_CUT_SCENE()
end
dead_close_inventory = function(arg1) -- line 1657
    local local1 = system.currentActor.is_holding
    local local2
    stop_script(Inventory.get_next_inventory_item)
    stop_script(Inventory.get_previous_inventory_item)
    if cutSceneLevel then
        END_CUT_SCENE()
    end
    if arg1 then
        local1 = nil
        manny.is_holding = nil
    end
    START_CUT_SCENE()
    if system.currentSet == death_inv then
        mannys_hands:wait_for_chore()
        Inventory:return_to_set()
        inventory_save_set:current_setup(inventory_save_setup)
        manny:setpos(inventory_save_pos)
        system.buttonHandler = inventory_save_handler
    elseif local1 and local1.wav then
        single_start_sfx(local1.wav)
    end
    if local1 then
        if local1.takeout_flag then
            start_script(local1.takeout_flag, local1)
        end
        if local1 == th.grinder then
            local2 = "md_activate_grinder_empty"
        else
            local2 = "md_activate_" .. local1.string_name
        end
    end
    if local2 then
        manny.hold_chore = getglobal(local2)
        manny:play_chore_looping(manny.hold_chore, "md.cos")
    end
    manny:play_chore(ms_stop_talk, manny.base_costume)
    manny:play_chore(md_dying_takeout, "md_dying.cos")
    manny:wait_for_chore(md_dying_takeout, "md_dying.cos")
    END_CUT_SCENE()
end
inv_sound_delay = function(arg1) -- line 1709
    sleep_for(300)
    start_sfx(arg1)
end
