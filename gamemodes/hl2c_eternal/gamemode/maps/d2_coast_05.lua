INFO_PLAYER_SPAWN = {Vector(7824, -12136, 1856), 180}

TELEPORT_POSITIONS = {
    ["Checkpoint 1"] = Vector(-4358, -12522, 704),
    ["Crossbow"] = Vector(-3652, -4246, 1266),
}

NEXT_MAP = "d2_coast_07"

if CLIENT then return end

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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ALLOWED_VEHICLE = "Jeep"
	game.SetGlobalState("no_seagulls_on_jeep", GLOBAL_ON)

	ents.FindByName("player_spawn_items_maker")[1]:Remove()
	ents.FindByName("jeep_filter")[1]:Fire("AddOutput", "filterclass prop_vehicle_jeep_old")
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
    if !game.SinglePlayer() and ent:GetName() == "gas_station_patrol_spawner" and string.lower(input) == "forcespawn" then
		ALLOWED_VEHICLE = nil
        PrintMessage(HUD_PRINTTALK, "Vehicle spawning has been disabled.")

		for _, ply in ipairs(player.GetAll()) do
			if ply == activator then continue end
			if IsValid(ply.vehicle) or ply:InVehicle() then
				ply:ExitVehicle()
				ply:RemoveVehicle()
			end

			ply:SetVelocity(Vector(0, 0, 0))
			ply:SetPos(Vector(-4727, -4647, 1128))
			ply:SetEyeAngles(Angle(0, 90, 0))
		end
		GAMEMODE:CreateSpawnPoint(Vector(-4727, -4647, 1128), 90)
	end

    if !game.SinglePlayer() and ent:GetName() == "logic_gate_shutdown" and string.lower(input) == "trigger" then
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage(HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3).")
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
