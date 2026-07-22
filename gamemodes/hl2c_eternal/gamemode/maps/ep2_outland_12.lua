NEXT_MAP = "ep2_outland_12a"

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

-- Player spawns
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
	-- ents.FindByName("startitems_template")[1]:Remove() -- bugs starting cutscene, again.

	if IsValid(GAMEMODE.MagBombManager) then GAMEMODE.MagBombManager:Remove() end
	GAMEMODE.MagBombManager = ents.Create("lua_run")
	GAMEMODE.MagBombManager:SetName("magbomb_manager")
	-- GAMEMODE.MagBombManager:SetKeyValue("Code", [[ACTIVATOR.DontCollideWithOtherMagbombs = true ACTIVATOR:CollisionRulesChanged()]])
	GAMEMODE.MagBombManager:SetKeyValue("Code", [[ACTIVATOR:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)]])
	GAMEMODE.MagBombManager:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


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
	if ent:GetName() == "base_destroy_relay" and input:lower() == "trigger" then
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
