ALLOWED_VEHICLE = "Airboat"

INFO_PLAYER_SPAWN = {Vector( 7512, -11398, -438 ), 0}

NEXT_MAP = "d1_canals_09_d"

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:EmitSound("@eateot/c2.mp3", 0, 100, 0.2)
end)
