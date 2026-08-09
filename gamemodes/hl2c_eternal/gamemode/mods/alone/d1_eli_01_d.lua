NEXT_MAP = "d1_eli_02_d"

TRIGGER_CHECKPOINT = {
	{Vector(364, 1764, -2730), Vector(549, 1787, -2575)}
}

TRIGGER_DELAYMAPLOAD = { Vector( -703, 989, -2688 ), Vector( -501, 1029, -2527 ) }

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:EmitSound("@eateot/f5.mp3", 0, 100, 0.2)
end)
