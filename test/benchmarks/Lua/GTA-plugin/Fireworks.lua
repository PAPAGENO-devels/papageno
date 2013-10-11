------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-----------------------------   Skyburst coloured Fireworks    ----------------------------
-------------------------------    for GTAIV Alice-plugin,    ----------------------------
----------------                                                          ----------------
----------------                update version 22.12.2009                 ----------------
----------------                                                          ----------------
----------------                works with alice version 0.9              ----------------
----------------                                                          ----------------
----------------                                                          ----------------
----------------                for GTAIV 5.patch  1.0.0.4                 ----------------
----------------                                                          ----------------
----------------                                                          ----------------
----------------      made by ZAZ ### http://zazmahall.de/index.htm       ----------------
----------------                                                          ----------------
----------------      place the Skyburst rocket and fire up               ----------------
----------------      the sensational coloured Fireworks                  ----------------
----------------                                                          ----------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-------------------------------         CREDITS        -----------------------------------
----------------                                                          ----------------
----------------     Alice.asi by © Alexander Blade 2008 & Adhome         ----------------
----------------        http://alexander.sannybuilder.com                 ----------------
----------------                                                          ----------------
----------------      to GooD-NTS: http://openiv.com/                     ----------------
----------------      and Listener for xliveless                          ----------------
----------------      also credits to Seemann, Bart Waterduck,            ----------------
----------------      Patric W., spaceeinstein                            ----------------
----------------      and much thanks to Chamber, oinkoink, Ceedj         ----------------
----------------      and to Demarest                                     ----------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--->press R to place the fireworks rocket
--->
--->optional:hold C pressed after lift off to view from overhead cam
--->optional:press again R after lift off to blow up the fireworks rocket earlier








function splashrocket(PLAYER_CHAR)
local obstat = {}
local sccamcom = {} local sccam = {}  local counter = {}

local camkey = {} obstat = 0  counter = 0 camkey = 0

		
		local modlID = GET_HASH_KEY("cj_rpg_rocket")
		REQUEST_MODEL(modlID)
		while HAS_MODEL_LOADED(modlID) == 0 do Wait(100) end
		local objector = {}
		CREATE_OBJECT(modlID, itof(0.0), itof(0.0), itof(700.0), objector, 1)
		obstat = 1

		repeat
		Wait(10)
		until  (DOES_OBJECT_EXIST(objector.a) == 1)

		SET_OBJECT_INVINCIBLE(objector.a, 1)
        SET_OBJECT_ROTATION(objector.a, itof(90.0), 0, 0)
        
        local Xxs = {}  local Yps = {}  local Zet = {}
		GET_CHAR_COORDINATES(PLAYER_CHAR, Xxs, Yps, Zet)
        GET_OFFSET_FROM_CHAR_IN_WORLD_COORDS(PLAYER_CHAR, itof(0.0), itof(0.0), itof(0.0), Xxs, Yps, Zet)
        
		
		local Xx = {}  local Yp = {}  local Zz = {}
		GET_CHAR_COORDINATES(PLAYER_CHAR, Xx, Yp, Zz)
		GET_OFFSET_FROM_CHAR_IN_WORLD_COORDS(PLAYER_CHAR, itof(0.0), itof(0.0), itof(10.0), Xx, Yp, Zz)
		
		
		local x = {}  local y = {}  local z = {}
		GET_CHAR_COORDINATES(PLAYER_CHAR, x, y, z)
		GET_OFFSET_FROM_CHAR_IN_WORLD_COORDS(PLAYER_CHAR, itof(0.0), itof(1.6), itof(-0.5), x, y, z)
        CLEAR_AREA_OF_CARS(x.b, y.b, z.b, itof(3.0))
		SET_OBJECT_COORDINATES(objector.a, x.b, y.b, z.b)
        FREEZE_OBJECT_POSITION(objector.a, 1)


        PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING", "Attention", 2000, 1)
        Wait(2500)
        z.b = z.b - itof(0.4)
		counter = 10
		repeat
		TRIGGER_PTFX("break_sparks", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(0.5))
		counter = counter - 1
		local myvar = {}
		myvar = tostring(counter)
    	PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING", myvar, 50, 1)
		Wait(50)
		until counter == 0

		counter = 0

        PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING", "* lift * off *", 2000, 1)
		local zosh = {}
		zosh = GET_SOUND_ID()
        PLAY_SOUND_FROM_OBJECT(zosh, "CHOPPER_CHASE_FIRE", objector.a)

		z.b = z.b + itof(50)
		FREEZE_OBJECT_POSITION(objector.a, 0)

		repeat
        SLIDE_OBJECT(objector.a, x.b, y.b, z.b, itof(0.0), itof(0.0), itof(3.0), 0)
        TRIGGER_PTFX_ON_OBJ("muz_rocket", objector.a, itof(0.0), itof(-2.0), itof(0.0), itof(0.0), itof(0.0), itof(90.0), itof(2.0))
			if  (LOCATE_OBJECT_3D(objector.a, x.b, y.b, z.b, itof(2.0), itof(2.0), itof(2.0), 0) == 1) or (IsKeyPressed(82) == 1) then
            SET_OBJECT_VISIBLE(objector.a, 0)
			obstat = 0
            elseif counter == 30 then
            
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		            
            GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(0.0), itof(0.0), itof(0.0), x, y, z)
            SET_OBJECT_VISIBLE(objector.a, 0)
			ADD_EXPLOSION(x.b, y.b, z.b, 1, itof(5.50), 1, 0, itof(1.00))
			obstat = 0
            else
			counter = counter + 1
			end

        Wait(100)
		until  obstat == 0

		STOP_SOUND(zosh)
        RELEASE_SOUND_ID(zosh)
        
        if (IsKeyPressed(67) == 1) then
		BEGIN_CAM_COMMANDS(sccamcom)
        CREATE_CAM(14, sccam)
		ATTACH_CAM_TO_OBJECT(sccam.a, objector.a)
        SET_CAM_ATTACH_OFFSET(sccam.a, itof(0.0), itof(50.0), itof(0.0))
		POINT_CAM_AT_OBJECT(sccam.a, objector.a)
        SET_CAM_ACTIVE(sccam.a, 1)
        SET_CAM_PROPAGATE(sccam.a, 1)
		ACTIVATE_SCRIPTED_CAMS(1, 1)
        camkey = 1

        local Xxs = {}  local Yps = {}  local Zet = {}
        GET_OBJECT_COORDINATES(objector.a, Xxs, y, z)
        GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(0.0), itof(0.0), itof(-45.0), Xxs, Yps, Zet)

		local Xx = {}  local Yp = {}  local Zz = {}
		GET_OBJECT_COORDINATES(objector, Xx, Yp, Zz)

        GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(0.0), itof(0.0), itof(-45.0), Xx, Yp, Zz)
		end


        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
        
    	GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(1.0), itof(0.0), x, y, z)


        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
        Wait(10)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
		TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))


        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(5.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_red", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(-6.0), itof(6.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_orange", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(15.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b + itof(5.0)
        Yp.b = Yp.b - itof(5.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(0.0), itof(-10.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-5.0), itof(10.0), itof(10.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_yellow", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(5.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(5.0), itof(10.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(-5.0), itof(-10.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(10.0), itof(20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_red", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(-10.0), itof(-20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_yellow", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b + itof(2.0)
        Yp.b = Yp.b - itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(25.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_orange", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-25.0), itof(5.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_yellow", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(15.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(5.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_red", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(10.0), itof(20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b + itof(2.0)
        Yp.b = Yp.b - itof(5.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))

        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-5.0), itof(5.0), itof(25.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(5.0), itof(-5.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_yellow", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(2.0), itof(-25.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(10.0), itof(25.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_orange", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(-5.0), itof(-20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_purple", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(10.0), itof(20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b + itof(5.0)
        Yp.b = Yp.b - itof(5.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(0.0), itof(-15.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_red", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(5.0), itof(15.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_blue", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b + itof(2.0)
        Yp.b = Yp.b - itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(-5.0), itof(-20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_yellow", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(10.0), itof(10.0), itof(20.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-25.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_red", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(25.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_purple", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		Wait(100)
		Xx.b = Xx.b - itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(1.0), itof(1.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_green", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))
        Wait(10)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(-10.0), itof(5.0), itof(10.0), x, y, z)
        TRIGGER_PTFX("qub_lg_explode_purple", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(5.5))

		Wait(100)
		Xx.b = Xx.b + itof(2.0)
        Yp.b = Yp.b + itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
		Wait(100)
		Xx.b = Xx.b + itof(2.0)
        Yp.b = Yp.b - itof(2.0)
        TRIGGER_PTFX("break_sparks", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))

		Wait(1500)
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(0.0), itof(0.0), itof(0.0), x, y, z)
        TRIGGER_PTFX("qub_merge_orange", x.b, y.b, z.b, 0.00, 0.00, 0.00, itof(15.5))
		TRIGGER_PTFX("exp_trespass", Xxs.b, Yps.b, Zet.b, 0.00, 0.00, 0.00, itof(25.5))



        if camkey == 1 then
        local x = {}  local y = {}  local z = {}
        GET_OBJECT_COORDINATES(objector.a, x, y, z)
		GET_OFFSET_FROM_OBJECT_IN_WORLD_COORDS(objector.a, itof(0.0), itof(0.0), itof(-50.0), x, y, z)
		PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", x.b, y.b, z.b)
		else
        PLAY_SOUND_FROM_POSITION(-1, "BOMB_DA_BASS_2_EXPLOSION_BIG", Xxs.b, Yps.b, Zet.b)
		end


		Wait(1500)
        TRIGGER_PTFX("break_electrical", Xx.b, Yp.b, Zz.b, 0.00, 0.00, 0.00, itof(7.5))
		counter = 0
		PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING", "done by ZAZ and greets fly out to Alexander Blade", 5000, 1)

    	DELETE_OBJECT(objector)
        Wait(1500)
        if camkey == 1 then
        ACTIVATE_SCRIPTED_CAMS(0, 0)
		DESTROY_CAM(sccam)
		END_CAM_COMMANDS(sccamcom)
		SET_GAME_CAM_HEADING(0)
		SET_CAM_BEHIND_PED(PLAYER_CHAR)
        camkey = 0
		end
        Wait(1000)
end

function bombmove(PLAYER_CHAR)
	while (HAVE_ANIMS_LOADED("MISSBDB_2") == 0)
	do
	REQUEST_ANIMS("MISSBDB_2")
	Wait(100)
	end
    TASK_PLAY_ANIM_NON_INTERRUPTABLE(PLAYER_CHAR, "bomb_unarmed", "MISSBDB_2", itof(8.0), 0, 0, 0, 0, -1)
    PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING", "Skyburst coloured Firework Rocket", 2000, 1)
end

function main()
        Wait(1000)

	while true do

	 	if (IsKeyPressed(82) == 1) and (IsKeyPressed(84) == 1) then    --key_press R
	 	
	 		local p = {}
  			GET_PLAYER_CHAR(GET_PLAYER_ID(), p)
  			local PLAYER_CHAR = {}
  			PLAYER_CHAR = p.a

				if PLAYER_CHAR <= 0 then return end
        
		
		
		      if (IS_CHAR_IN_ANY_CAR(PLAYER_CHAR) == 0) then		
				bombmove(PLAYER_CHAR)
        		Wait(1000)
				splashrocket(PLAYER_CHAR)
		      end
		
		end
	Wait(10)
	end
end
-- start
main();