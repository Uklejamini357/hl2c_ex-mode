INFO_PLAYER_SPAWN = {Vector(-1137, 3475, 389), -90}

NEXT_MAP = "d2_prison_03"

if CLIENT then return end

-- Player initial spawn
function hl2cPlayerInitialSpawn(ply)
	ply:SendLua("table.insert(FRIENDLY_NPCS, \"npc_antlion\")")
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)


-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_pistol")
	ply:Give("weapon_smg1")
	ply:Give("weapon_357")
	ply:Give("weapon_frag")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_ar2")
	ply:Give("weapon_rpg")
	ply:Give("weapon_crossbow")
	ply:Give("weapon_bugbait")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


local times = 0
-- Initialize entities
function hl2cMapEdit()
	game.SetGlobalState("antlion_allied", GLOBAL_ON)

	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()

	table.insert(FRIENDLY_NPCS, "npc_antlion")

	times = 0
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cAcceptInput(ent, input, activator)
	if !GAMEMODE.EXMode then return end

	if ent:GetName() == "entrance_music" and input:lower() == "playsound" then
		timer.Simple(math.Rand(2,2.5), function()
			if !IsValid(ent) then return end
			PrintMessage(3, "Chapter 9")
		end)
		timer.Simple(math.Rand(4.5,5), function()
			if !IsValid(ent) then return end
			PrintMessage(3, "The Prison Hell")
		end)
	end

	if ent:GetName() == "hallway_logic_breakout" and input:lower() == "trigger" then
		local ent1 = ents.FindByName("hallway_breakspawn1")[1]
		local ent2 = ents.FindByName("hallway_breakspawn2")[1]
		local ent3 = ents.FindByName("hallway_breakspawn3")[1]


		for i=1,7 do
			timer.Simple(i*0.3, function()
				for i=1,3 do
					local npc = ents.Create("npc_headcrab_fast")
					npc:SetPos(i==1 and ent1:GetPos() or i==2 and ent2:GetPos() or ent3:GetPos())
					npc:Spawn()
				end
			end)
		end
	end

	if ent:GetName() == "overwatch_freeman_spotted" and input:lower() == "playsound" then
		times = times + 1

		if times >= 6 then
			local time = math.Rand(1, 1.7)

			for _,door in ipairs(ents.FindByName("double_doors")) do
				for i=1,5 do
					local explo = ents.Create("env_explosion")
					explo:SetPos(door:GetPos())
					explo:SetKeyValue("iMagnitude", 2000)
					explo:SetKeyValue("iRadiusOverride", 300)
					explo:Spawn()
					explo:Activate()
					explo:Fire("explode", 0, time)
				end
			end
					
			timer.Simple(time, function()
				if !IsValid(ent) then return end

				ent:Remove()
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

function hl2cEntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if attacker:GetClass() == "npc_turret_floor" then
		attacker.NextDamageMul = math.huge
	end
end
hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", hl2cEntityTakeDamage)
