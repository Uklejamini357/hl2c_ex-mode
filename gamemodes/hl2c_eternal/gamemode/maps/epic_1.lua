NEXT_MAP = "d1_trainstation_01"

-- INFO_PLAYER_SPAWN = {Vector(-232, 208, -24), 0}

-- Epic Hardmore map (Even more puzzling and hardcore than Jolly's Hardcore map, at most by +550% harder.)

if CLIENT then return end

hook.Add("PlayerSpawn", "hl2cPlayerSpawn", function(ply)
end)

hook.Add("PlayerReady", "hl2cPlayerReady", function(ply)
	timer.Simple(3, function()
		ply:PrintMessage(3, "Welcome to Epic Hardcore map.")
		ply:PrintMessage(3, "Well. You're not going to be able to beat it anyway.")
		ply:PrintMessage(3, "Later section is an absolute hell.")
	end)
end)

-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

-- Initialize entities
function hl2cDoPlayerDeath(pl, attacker, dmginfo)
	if attacker:GetClass() == "func_door" then
		PrintMessage(3, "ouch.")
	end
end
hook.Add("DoPlayerDeath", "hl2cDoPlayerDeath", hl2cDoPlayerDeath)

function hl2cAcceptInput(ent, input, activator, caller)
	if ent:GetName() == "start_text" and activator == NULL then
		for _,pl in player.Iterator() do
			-- ent:Fire("display", nil, nil, pl, activator)
		end

		return true
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
