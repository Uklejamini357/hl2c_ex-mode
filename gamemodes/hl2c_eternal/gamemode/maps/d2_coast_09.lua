ALLOWED_VEHICLE = "Jeep"

NEXT_MAP = "d2_coast_10"

if CLIENT then return end

if file.Exists("hl2c_eternal/d2_coast_08.txt", "DATA") then
	file.Delete("hl2c_eternal/d2_coast_08.txt")
end

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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	game.SetGlobalState("no_seagulls_on_jeep", GLOBAL_ON)

	ents.FindByName("global_newgame_template_ammo")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()
	ents.FindByName("wheel_filter")[1]:Fire("AddOutput", "filterclass prop_vehicle_jeep_old")

	ALLOWED_VEHICLE = "Jeep"
	COAST_SET_ALLOWED_VEHICLE = true
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and COAST_SET_ALLOWED_VEHICLE and ent:GetName() == "spawn_dropship" and string.lower(input) == "trigger" then
		ALLOWED_VEHICLE = nil
		PrintMessage(HUD_PRINTTALK, "Vehicle spawning has been disabled.")

		for _, ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end
			if !IsValid(ply.vehicle) then
				ply:SetVelocity(Vector(0, 0, 0))
				ply:SetPos(Vector(11128, 8820, -187))
				ply:SetEyeAngles(Angle(0, -175, 0))
			end
		end
		GAMEMODE:CreateSpawnPoint(Vector(11128, 8820, -187), -175)
	end

	if !game.SinglePlayer() and COAST_SET_ALLOWED_VEHICLE and ent:GetName() == "gate_door" and string.lower(input) == "open" then
		COAST_SET_ALLOWED_VEHICLE = false
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "song_zombietunnel" and input:lower() == "playsound" then
			timer.Simple(1.5, function()
				PrintMessage(3, "Chapter 8")
			end)

			timer.Simple(math.Rand(4,4.5), function()
				PrintMessage(3, "The epic battle against the combine and the antlions")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
