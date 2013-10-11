--anarchy.lua

--	ANARCHY
--	veaudaux@gmail.com

--	It's chaos in Liberty City. Citizens wreak havoc, attacking cops and eachother using anything they can find.
--	No one is safe. Not even you.

--	This ALICE script works similarly to the Riot cheats in the previous incarnations of GTA. It will arm nearby pedestrians and
--	set them to attack anything in their path.

--	INSTRUCTIONS:
--		Press END to enable or disable anarchy mode.

--Thanks to Alexander Blade for ALICE, the WaitForPlayerPoolCreation and WaitForValidPlayer functions, and his advice.
--Also, big thanks to zBobG at GTAForums.com for talking Lua and Alice with me, and ZAZ for trying out my creations.

PLAYER_ID, PLAYER_CHAR = 0
local playIndex = {}
local playrGrp = {}
GROUP_ID = 0

local AllKaos = {}
local AllBlips = {}
Kaos = 1
FoundLowest = 0
Lowest = 0
TotalCount = 0

function WaitForPlayerPoolCreation()
	while (IsPlayerPoolCreated() == 0) do
		Wait(2000)
	end
end

function WaitForValidPlayer()
	PLAYER_CHAR = 0
		repeat
			PLAYER_ID = _GET_PLAYER_ID()
				if (PLAYER_ID >= 0) then
					while true do
						if _IS_PLAYER_PLAYING(PLAYER_ID) == 0
						then Wait(1000)
						else break
						end
				end
			local p = {}
			_GET_PLAYER_CHAR(PLAYER_ID, p)
			PLAYER_CHAR = p.a
				if (PLAYER_CHAR <= 0) then
					Wait(1000)
				end
		end
		until (PLAYER_CHAR > 0)
end

function SetPlayIndex() -- Puts the Player Index into a var called "playIndex"
	PLAYER_ID = _GET_PLAYER_ID()
	playIndex = _CONVERT_INT_TO_PLAYERINDEX(PLAYER_ID)
end

function SetPlayGroup() -- Puts the Player's group ID into a var called "GROUP_ID"
	GET_PLAYER_GROUP(playIndex, playrGrp)
	GROUP_ID = playrGrp.a
end

function PickRandomWeapon() -- Essentially, picks a random number between 1 and 18.
	weapon = math.random(18)
	while true do
		if (weapon == 6) then -- 6 is "Rocket" - I don't know what that is, so we're not using it.
			weapon = math.random(18)
		elseif (weapon == 8) then -- 8 is an unassigned weapon. Try again!
			weapon = math.random(18)
		else
			return weapon
		end
	end
end

function DiscardPed(CharToRemove, BlipToRemove) -- this function will mark a ped as no longer needed
	MARK_CHAR_AS_NO_LONGER_NEEDED(CharToRemove)
	REMOVE_BLIP(BlipToRemove)
end

function main()
	WaitForPlayerPoolCreation()
	WaitForValidPlayer()
	SetPlayIndex()

	if PLAYER_CHAR <= 0 then return end

	local charDec = {}
	local combatDec = {}
	LOAD_CHAR_DECISION_MAKER(2, charDec)
	LOAD_COMBAT_DECISION_MAKER(9, combatDec)

	local gametime = {}
	GET_GAME_TIMER(gametime)
	SET_CHAR_HEALTH(PLAYER_CHAR, 200)
	ADD_ARMOUR_TO_CHAR(PLAYER_CHAR, 100)
	LastHeal = gametime.a

	math.randomseed( os.time() )

	while true do
		LivingTotal = 0 -- We need to count how many enemies there currently are, so we can slow down spawning the more there are
		Count = Lowest -- We also need to keep track of the lowest spot in the AllKaos table that still has a living enemy stored in it, and start checks in the future from that slot. Otherwise, the dead check takes WAY too long while it loops through hundreds of pointers for peds that got killed/despawned 20 minutes ago.
		while (Count < TotalCount) do
			AGSlot = Count + 1
			local DeadCheck = {}
			DeadCheck = AllKaos[AGSlot]
			intDeadCheck = DeadCheck.a
			if (DOES_CHAR_EXIST(intDeadCheck) == 1) then -- If the character exists
				if Kaos == 0 then -- if anarchy has been disabled
					DiscardPed(DeadCheck, AllBlips[AGSlot].a) -- get rid of them
				end

				if FoundLowest == 0 then -- and if we haven't already found an enemy this time around
					FoundLowest = 1
					Lowest = Count -- store the slot we're currently on as the slot to start future checks on
				end
				if (IS_CHAR_INJURED(intDeadCheck) == 1) then -- If this enemy is dead
					DiscardPed(DeadCheck, AllBlips[AGSlot].a) -- get rid of them
				else
					LivingTotal = LivingTotal + 1 -- if they're alive, count them in the living total
					local playx = {}  local playy = {}  local playz = {}
					local pedx = {}  local pedy = {}  local pedz = {}
					GET_CHAR_COORDINATES(PLAYER_CHAR, playx, playy, playz)
					GET_CHAR_COORDINATES(intDeadCheck, pedx, pedy, pedz)
					distance = VDIST(playx.b, playy.b, playz.b, pedx.b, pedy.b, pedz.b) -- this is to figure out how far away this enemy is from the player
					if (distance > 1120000000) then -- if they're further away than 1120000000 (that's a little under a mile)
						DiscardPed(DeadCheck, AllBlips[AGSlot].a) -- get rid of them
					end
				end
			end
			Count = Count + 1
		end

		FoundLowest = 0

		if Kaos == 1 then
			GET_GAME_TIMER(gametime) -- what time is it?
			TimeNow = gametime.a

			if (TimeNow - LastHeal > 60000) then -- 120000 = 1hr game time.
				SET_CHAR_HEALTH(PLAYER_CHAR, 200) -- Heal them
				ADD_ARMOUR_TO_CHAR(PLAYER_CHAR, 100) -- give them armor
				LastHeal = TimeNow -- set the time now as the time of the last freebie heal
				local currweap = {}
				GET_CURRENT_CHAR_WEAPON(PLAYER_CHAR, currweap)-- find out what weapon they're using
				PlayerWeapon = currweap.a
				ADD_AMMO_TO_CHAR(PLAYER_CHAR, PlayerWeapon, 200) -- give them a little ammo
				PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING","Health and Armor Restored.",5000,1)
			end

			if LivingTotal < 7 then
				local x = {}  local y = {}  local z = {}
				GET_CHAR_COORDINATES(PLAYER_CHAR, x, y, z) -- where you at?
				local car = {}
				GET_CAR_CHAR_IS_USING(PLAYER_CHAR, car) -- if the player's in a car
				if (car.a ~= 0) then
					spawnX = math.random(-10, 10) -- Then any peds we spawn, we want to be way out in front
					spawnY = math.random(30, 100) -- and not too much off to the sides.
					WaitTime = 0 -- we also don't want to wait long between spawns, because the player will likely be driving past existing spawns pretty quickly
				else -- if they're not in a car
					spawnX = math.random(-30, 30) -- spawn peds in a little wider area (30 is about minimap radar range on foot)
					spawnY = math.random(-30, -5) -- and between 5 and 30 units -behind- the player, so they don't see peds popping up.
					WaitTime = LivingTotal * 100 -- also, wait 1/10th of a second between every spawn for every living enemy. 10 enemies = 1 second between each spawn; 100 enemies = 10 seconds between each spawn (in theory, it's a little slower in the game engine, as it waits for models to load, etc)
				end

				GET_OFFSET_FROM_CHAR_IN_WORLD_COORDS(PLAYER_CHAR, f(spawnX), f(spawnY), 0, x, y, z) -- use spawnX and spawnY to generate coords for a spawned ped should we need one

				local c = {}
				BEGIN_CHAR_SEARCH_CRITERIA()
				END_CHAR_SEARCH_CRITERIA()
				GET_RANDOM_CHAR_IN_AREA_OFFSET_NO_SAVE(f(x.b - 15.0),f(y.b - 15.0),f(z.b - 15.0),f(30.0),f(30.0),f(30.0),c) -- before we resort to spawning though, we want to see if there's an existing ped in the area we can convert to an enemy

				if (DOES_CHAR_EXIST(c.a) == 0) then -- if we couldn't find anybody
					CREATE_RANDOM_CHAR(x.b, y.b, z.b, c) -- then make somebody as a last resort
					repeat
							Wait(100)
					until (DOES_CHAR_EXIST(c.a == 1)) -- wait on them to spawn
				else -- but if we DID find somebody
					SET_CHAR_AS_MISSION_CHAR(c.a, 1) -- set them as a mission char so we can assign flags to them (SET_CHAR_AS_MISSION_CHAR is essentially the opposite of MARK_CHAR_AS_NO_LONGER_NEEDED)
				end

				PissedPed = c.a

				if (DOES_CHAR_EXIST(PissedPed) == 1) then -- Just check one more time to make sure we've either found or spawned somebody. If we start passing the following commands to a non-existant pointer, we're gonna crash the game. That's bad.
					if (IS_CHAR_DEAD(PissedPed) == 0) then -- If they're not dead
						SET_CHAR_GRAVITY(PissedPed, 0) -- and turn off gravity for a second
						local HeightAbove = {}
						GET_CHAR_HEIGHT_ABOVE_GROUND(PissedPed, HeightAbove) -- find out how high they are off the ground
						FallDistance = z.b - HeightAbove.b -- subtract that from the height they were spawned at
						SET_CHAR_COORDINATES(PissedPed, x.b, y.b, f(FallDistance)) -- place them safely on the ground
						SET_CHAR_GRAVITY(PissedPed, 1) -- and turn gravity back on. Why do all this? Imagine the player is on a rooftop. We spawn a ped at the same height as the player. Unless they're lucky enough to be on the roof as well, they're going to be in midair, and possibly fall to their death. We don't want that. So we need to make sure every enemy ped is safely on the ground.
						if (IS_CHAR_ARMED(PissedPed) == 0) then -- and they don't already have a gun
							TotalCount = TotalCount + 1 -- we're about to make them into an enemy

							AllKaos[TotalCount] = c -- add them to the table

							boomstick = PickRandomWeapon() -- load a random weapon number
							GIVE_WEAPON_TO_CHAR(PissedPed,boomstick,30000,0) -- and then give that weapon to them
							SET_CHAR_RELATIONSHIP_GROUP(PissedPed, 23) -- add them to group 23
							local blip = {}
							SET_RELATIONSHIP(5, 0, 23) -- then make group 23 enemies (5) with the player (0)
							SET_RELATIONSHIP(5, 23, 0) -- make the player (0) enemies (5) with group 23
							SET_RELATIONSHIP(5, 1, 23) -- make CIVMALE enemies with group 23
							SET_RELATIONSHIP(5, 23, 1) -- make group 23 enemies with CIVMALE
							SET_RELATIONSHIP(5, 2, 23) -- CIVFEMALE enemies with group 23
							SET_RELATIONSHIP(5, 23, 2) -- group 23 enemies with CIVFEMALE
							-- I didn't make them enemies with cops, because as soon as they open fire, the cops will shoot at them, and the combat decision maker we're going to add will make them shoot back at anyone that shoots at them.
							ADD_BLIP_FOR_CHAR(PissedPed, blip) -- add a radar blip
							AllBlips[TotalCount] = blip
							SET_CHAR_IS_TARGET_PRIORITY(PissedPed, 1)
							ALLOW_TARGET_WHEN_INJURED(PissedPed, 1)
							SET_CHAR_DECISION_MAKER(PissedPed, charDec.a)
							SET_COMBAT_DECISION_MAKER(PissedPed, combatDec.a)
							SET_CHAR_AS_ENEMY(PissedPed, 1)
							TASK_SET_IGNORE_WEAPON_RANGE_FLAG(PissedPed, 1)
							SET_SENSE_RANGE(PissedPed, f(100.0))
							SET_CHAR_ACCURACY(PissedPed, 33)
							SET_PED_WONT_ATTACK_PLAYER_WITHOUT_WANTED_LEVEL(PissedPed, 0)
							TASK_COMBAT_HATED_TARGETS_AROUND_CHAR(PissedPed, f(50.0)) -- KILL! KILL! KILL!
							Wait(WaitTime)
						end
					end
				end
			end
		end

		if (IsKeyPressed(35) == 1) then -- this allows the user to turn anarchy on and off
			if Kaos == 1 then
				Kaos = 0
				PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING","Anarchy Disabled",5000,1)
			else
				Kaos = 1
				PRINT_STRING_WITH_LITERAL_STRING_NOW("STRING","Anarchy Enabled",5000,1)
			end
			Wait(3000)
		end

	end

end

main();
