CheckFirstTime("meche_idle_table.lua")
meche.idle_table = Idle:create("meche_sit")
idt = meche.idle_table
idt:add_state("purse_squeeze", { base = 0.15, purse_squeeze = 0.36, scoot_out = 0.1, look_around = 0.02, to_chin = 0, tap_fingers = 0.3, tilt_head_in = 0, look_down_in = 0.05, lean_fwd = 0, nod = 0, adj_skirt = 0.02 })
idt:add_state("scoot_out", { hold_out = 0.5, head_tap_in = 0.25, scoot_in = 0.25 })
idt:add_state("head_tap_in", { head_tap_loop = 1 })
idt:add_state("head_tap_loop", { head_tap_loop = 0.5, head_tap_out = 0.5 })
idt:add_state("scoot_in", { base = 0.1, purse_squeeze = 0.3, scoot_out = 0.1, look_around = 0.05, to_chin = 0, tap_fingers = 0.35, tilt_head_in = 0, look_down_in = 0.05, lean_fwd = 0, nod = 0, adj_skirt = 0.05 })
idt:add_state("base", { base = 0.2, purse_squeeze = 0.1, scoot_out = 0.05, look_around = 0.05, to_chin = 0, tap_fingers = 0.5, tilt_head_in = 0, look_down_in = 0.05, lean_fwd = 0, nod = 0, adj_skirt = 0.05 })
idt:add_state("to_chin", { chin_hold = 1, to_gesture_1 = 0, in_gesture_2 = 0, hand_down = 0 })
idt:add_state("chin_hold", { chin_hold = 1, to_gesture_1 = 0, in_gesture_2 = 1, hand_down = 1 })
idt:add_state("to_gesture_1", { gesture_1_hold = 1, out_gesture_1 = 1 })
idt:add_state("gesture_1_hold", { gesture_1_hold = 1, out_gesture_1 = 1 })
idt:add_state("out_gesture_1", { chin_hold = 0, to_gesture_1 = 1, in_gesture_2 = 1, hand_down = 1 })
idt:add_state("in_gesture_2", { gesture_2_hold = 1, out_gesture_2 = 1 })
idt:add_state("gesture_2_hold", { gesture_2_hold = 1, out_gesture_2 = 1 })
idt:add_state("hand_down", { base = 1, purse_squeeze = 1, scoot_out = 1, look_around = 1, to_chin = 0, tap_fingers = 1, tilt_head_in = 0, look_down_in = 1, lean_fwd = 0, nod = 0, adj_skirt = 0 })
idt:add_state("tap_fingers", { base = 0.28, purse_squeeze = 0.18, scoot_out = 0.05, look_around = 0.05, to_chin = 0, tap_fingers = 0.4, tilt_head_in = 0, look_down_in = 0.02, lean_fwd = 0, nod = 0, adj_skirt = 0.02 })
idt:add_state("tild_head_in", { tilt_head_hold = 0, tilt_head_out = 0 })
idt:add_state("tilt_head_hold", { tilt_head_hold = 1, tilt_head_out = 1 })
idt:add_state("tilt_head_out", { base = 1, purse_squeeze = 1, scoot_out = 1, look_around = 1, to_chin = 0, tap_fingers = 1, tilt_head_in = 0, look_down_in = 1, lean_fwd = 0, nod = 0, adj_skirt = 1 })
idt:add_state("look_down_in", { look_down_hold = 0.5, look_tilt_in = 0.5 })
idt:add_state("look_down_hold", { look_down_hold = 0.8, look_tilt_in = 0.2 })
idt:add_state("look_tilt_in", { look_tilt_hold = 0.8, look_to_base = 0.2 })
idt:add_state("look_tilt_hold", { look_tilt_hold = 0.7, look_to_base = 0.3 })
idt:add_state("look_to_base", { base = 1, purse_squeeze = 0, scoot_out = 0, look_around = 0, to_chin = 0, tap_fingers = 0, tilt_head_in = 0, look_down_in = 0, lean_fwd = 0, nod = 0, adj_skirt = 0 })
idt:add_state("lean_fwd", { lean_fwd_hold = 1, lean_rt = 1 })
idt:add_state("lean_fwd_hold", { lean_fwd_hold = 1, lean_rt = 1 })
idt:add_state("lean_rt", { lean_rt_hold = 0.9, lean_to_base = 0.1 })
idt:add_state("lean_rt_hold", { lean_rt_hold = 0.9, lean_to_base = 0.1 })
idt:add_state("lean_to_base", { base = 1, purse_squeeze = 0, scoot_out = 0, look_around = 0, to_chin = 0, tap_fingers = 0, tilt_head_in = 0, look_down_in = 0, lean_fwd = 0, nod = 0, adj_skirt = 0 })
idt:add_state("nod", { base = 1, purse_squeeze = 1, scoot_out = 1, look_around = 1, to_chin = 0, tap_fingers = 1, tilt_head_in = 0, look_down_in = 1, lean_fwd = 0, nod = 0, adj_skirt = 1 })
idt:add_state("adj_skirt", { base = 1, purse_squeeze = 0, scoot_out = 0, look_around = 0, to_chin = 0, tap_fingers = 0, tilt_head_in = 0, look_down_in = 0, lean_fwd = 0, nod = 0, adj_skirt = 0 })
idt:add_state("head_tap_out", { hold_out = 0.2, head_tap_in = 0, scoot_in = 0.8 })
idt:add_state("look_around", { base = 1, purse_squeeze = 0, scoot_out = 0, look_around = 0, to_chin = 0, tap_fingers = 0, tilt_head_in = 0, look_down_in = 0, lean_fwd = 0, nod = 0, adj_skirt = 0 })
idt:add_state("hold_out", { hold_out = 0.7, head_tap_in = 0.2, scoot_in = 0.1 })
idt:add_state("out_gesture_2", { chin_hold = 0, to_gesture_1 = 1, in_gesture_2 = 1, hand_down = 1 })
