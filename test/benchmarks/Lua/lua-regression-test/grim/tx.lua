CheckFirstTime("tx.lua")
tx = Set:create("tx.set", "track base", { tx_strws = 0 })
tx.enter = function(arg1) -- line 18
    xb.bridge.extended = TRUE
end
tx.xb_door = Object:create(tx, "/txtx001/door", 3.6120999, 0.82800001, 0.40000001, { range = 0.60000002 })
tx.xb_door.use_pnt_x = 3.20103
tx.xb_door.use_pnt_y = 0.64020598
tx.xb_door.use_pnt_z = 0
tx.xb_door.use_rot_x = 0
tx.xb_door.use_rot_y = -55.054798
tx.xb_door.use_rot_z = 0
tx.xb_door.out_pnt_x = 3.41837
tx.xb_door.out_pnt_y = 0.79211003
tx.xb_door.out_pnt_z = 0
tx.xb_door.out_rot_x = 0
tx.xb_door.out_rot_y = -55.054798
tx.xb_door.out_rot_z = 0
tx.xb_box = tx.xb_door
tx.xb_door.walkOut = function(arg1) -- line 52
    xb:come_out_door(xb.tx_door)
end
tx.ts_door = Object:create(tx, "/txtx002/door", 1.0121, -0.071999997, 0.40000001, { range = 0.60000002 })
tx.ts_door.use_pnt_x = -0.192009
tx.ts_door.use_pnt_y = -0.32122499
tx.ts_door.use_pnt_z = 0.544182
tx.ts_door.use_rot_x = 0
tx.ts_door.use_rot_y = -261.61499
tx.ts_door.use_rot_z = 0
tx.ts_door.out_pnt_x = -0.36461401
tx.ts_door.out_pnt_y = -0.34440401
tx.ts_door.out_pnt_z = 0.61000001
tx.ts_door.out_rot_x = 0
tx.ts_door.out_rot_y = -261.61499
tx.ts_door.out_rot_z = 0
tx.ts_door:make_untouchable()
tx.ts_box = tx.ts_door
tx.ts_door.walkOut = function(arg1) -- line 75
    ts:come_out_door(ts.tx_door)
end
