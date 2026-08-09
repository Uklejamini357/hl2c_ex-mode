NEXT_MAP = "d2_coast_03_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:EmitSound("@eateot/f7.mp3", 0, 100, 0.2)
end)

if SERVER then
	hook.Add("PlayerEnteredVehicle", "nil", function(pl)
		if ALLOWED_VEHICLE ~= "Jeep NoGun" then
			ALLOWED_VEHICLE = "Jeep NoGun"
			GAMEMODE.CampaignMapVars.GotJeep = true
			PrintMessage(HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3).")
		end
	end)
end
