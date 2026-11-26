NEXT_MAP = "ep2_outland_12a"

GM:AddAdminMapFunction("Spawn strider 1", function(pl, op)
	ents.FindByName("strider_first_template")[1]:Fire("ForceSpawn")
	-- ents.FindByName("strider_west_hunter_maker")[1]:Fire("SpawnMultiple", op)
end)

GM:AddAdminMapFunction("Spawn strider 2", function(pl, op)
	ents.FindByName("strider_2_north_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_north_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 3", function(pl, op)
	ents.FindByName("strider_3_east_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_east_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 4", function(pl, op)
	ents.FindByName("strider_4_west_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_west_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 5", function(pl, op)
	ents.FindByName("strider_5_north_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_north_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 6", function(pl, op)
	ents.FindByName("strider_6_east_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_east_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 7", function(pl, op)
	ents.FindByName("strider_7_west_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_west_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 8", function(pl, op)
	ents.FindByName("strider_8_east_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_east_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 9", function(pl, op)
	ents.FindByName("strider_9_west_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_west_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 10", function(pl, op)
	ents.FindByName("strider_10_north_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_north_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 11", function(pl, op)
	ents.FindByName("strider_11_east_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_east_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 12", function(pl, op)
	ents.FindByName("strider_12_north_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_north_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

GM:AddAdminMapFunction("Spawn strider 13", function(pl, op)
	ents.FindByName("strider_13_west_maker")[1]:Fire("Spawn")
	ents.FindByName("strider_west_hunter_maker")[1]:Fire("SpawnMultiple", op)
end, {1,2,3})

if CLIENT then return end

-- This map is planned to take up to nearly an hour to beat, in EX mode... why though?
-- There will be 12 waves, with the following:
-- Wave 1: 1 Strider (Introduction wave)
-- Wave 2: 1 Strider, 2 hunters
-- Wave 3: 1 Strider, 3 hunters
-- Wave 4: 2 striders, 2 hunters
-- Wave 5: 1 gunship, 1 strider
-- Wave 6: 3 striders, 5 hunters
-- Wave 7: 4 striders, 2 hunters
-- Wave 8: 5 striders
-- Wave 9: 1 helicopter, 1 strider
-- Wave 10: 1 strider boss (Must damage them with 40 explosives, or attach 5 magnusson bombs and blow them up ALL AT ONCE!), 5 hunters 
-- Wave 11: 6 striders, 8 hunters (Each 2 hunters goes with a strider, until there are enough hunters spawned.)
-- Wave 12: 2 strider bosses

-- And the final 3, ridiculously difficult waves...
-- Wave 13: 10 striders, 15 hunters
-- Wave 14: 5 striders, 30 combine soldiers, 10 hunters. (The Combine soldiers are random, and always has 1 elite with them.)
-- Wave 15: 3 strider bosses, with 5 hunters for each srider...

-- In addition to the waves, there will be RPG crates near the base.
-- And to also include health/suit chargers near the base.
-- This is to make things a little bit easier, just in case.

-- Endless mode... will probably be a lot more complicated to do.



-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
	ply:Give("weapon_crowbar")
	ply:Give("weapon_pistol")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_357")
	ply:Give("weapon_frag")
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
	ply:Give("weapon_rpg")
	ply:Give("weapon_crossbow")
end
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)


hook.Add("OnEntityCreated", "hl2cOnEntityCreated", function(ent)
	if ent:GetClass() == "weapon_striderbuster" then
		ent:EnableCustomCollisions()
		ent:Input("AddOutput", nil, nil, "OnAttachToStrider magbomb_manager:RunCode::-1")
	end
end)

-- Initialize entities
function hl2cMapEdit()
	-- ents.FindByName("startitems_template")[1]:Remove() -- bugs out the starting cutscene, again.

	if IsValid(GAMEMODE.MagBombManager) then GAMEMODE.MagBombManager:Remove() end
	GAMEMODE.MagBombManager = ents.Create("lua_run")
	GAMEMODE.MagBombManager:SetName("magbomb_manager")
	-- GAMEMODE.MagBombManager:SetKeyValue("Code", [[ACTIVATOR.DontCollideWithOtherMagbombs = true ACTIVATOR:CollisionRulesChanged()]])
	GAMEMODE.MagBombManager:SetKeyValue("Code", [[ACTIVATOR:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)]])
	GAMEMODE.MagBombManager:Spawn()


	local tbl = {}
	table.Add(tbl, ents.FindByName("strider_2_north_maker"))
	table.Add(tbl, ents.FindByName("strider_3_east_maker"))
	table.Add(tbl, ents.FindByName("strider_4_west_maker"))
	table.Add(tbl, ents.FindByName("strider_5_north_maker"))
	table.Add(tbl, ents.FindByName("strider_6_east_maker"))
	table.Add(tbl, ents.FindByName("strider_7_west_maker"))
	table.Add(tbl, ents.FindByName("strider_8_east_maker"))
	table.Add(tbl, ents.FindByName("strider_9_west_maker"))
	table.Add(tbl, ents.FindByName("strider_10_north_maker"))
	table.Add(tbl, ents.FindByName("strider_11_east_maker"))
	table.Add(tbl, ents.FindByName("strider_12_north_maker"))
	table.Add(tbl, ents.FindByName("strider_13_west_maker"))

	for _,ent in ipairs(tbl) do
		ent:SetKeyValue("MaxLiveChildren", "100")
		ent:SetKeyValue("MaxNPCCount", "100")
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

hook.Add("OnEntityCreated", "hl2cOnEntityCreated", function(ent)
	if ent:GetClass() == "npc_strider" then
		GAMEMODE.MapVars.LastStrider = ent
	elseif ent:GetClass() == "npc_hunter" then
		local strider = GAMEMODE.MapVars.LastStrider
		if IsValid(strider) then
			-- if not strider.PrevName then
			-- 	strider.PrevName = strider:GetName()
			-- end

			-- strider:SetName("last_strider")
			ent:Fire("FollowStrider", nil, 0.2)

			-- timer.Simple(0.1, function()
			-- 	if !IsValid(strider) then return end
			-- 	strider:SetName(strider.PrevName)
			-- end)
		end
	end
end)

hook.Add("OnNPCKilled", "hl2cOnNPCKilled", function(ent)
	if ent:GetName() == "mirt" then
		ent:SetKeyValue("GameEndAlly", "1") -- at least this still works
	end
end)

-- hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", function(ent, dmginfo)
-- 	local class = ent:GetClass()
-- 	if class == "npc_strider" then
-- 		-- return true
-- 	end

-- 	local inflictor = dmginfo:GetInflictor()
-- 	if class == "weapon_striderbuster" and inflictor:GetClass() == "weapon_striderbuster" then
-- 		-- print("i am not destroying this mag bomb!")
-- 		return true
-- 	end
-- end)


-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "sawmill_briefing_approach_lcs" and input:lower() == "start" then
		-- PrintMessage(3, "Checkpoint has been activated.")
	elseif ent:GetName() == "base_destroy_relay" and input:lower() == "trigger" then
		if GAMEMODE.EXMode then
			gamemode.Call("FailMap", nil, [[It starts with one

One thing, I don't know why
It doesn't even matter how hard you try
Keep that in mind, I designed this rhyme to explain in due time
All I know time is a valuable thing
Watch it fly by as the pendulum swings
Watch it count down to the end of the day, the clock ticks life away

It's so unreal, didn't look out below
Watch the time go right out the window
Tryna hold on, d-didn't even know
I wasted it all just to watch you go

I kept everything inside
And even though I tried, it all fell apart
What it meant to me will eventually be a memory of a time when

I tried so hard and got so far
But in the end, it doesn't even matter
I had to fall to lose it all
But in the end, it doesn't even matter]])
		else
			gamemode.Call("FailMap", nil, "You let the striders destroy the rocket!")
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

GM:AddLoadoutCreatePrevent("startitems_template")
