NEXT_MAP = "d1_trainstation_01"

INFO_PLAYER_SPAWN = {Vector(-232, 208, -24), 0}

-- https://steamcommunity.com/sharedfiles/filedetails/?id=3094821852
-- by AnonymoScoot (https://www.moddb.com/mods/jollys-hardcore-mod/downloads/jollyhardcore)

if CLIENT then return end

hook.Add("PlayerSpawn", "hl2cPlayerSpawn", function(ply)
end)

hook.Add("PlayerReady", "hl2cPlayerReady", function(ply)
	timer.Simple(3, function()
		ply:PrintMessage(3, "This will probably one of the trickiest hard maps ever made.")
		ply:PrintMessage(3, "It will take you an insane amount of attempts to actually complete it.")
		ply:PrintMessage(3, "Good luck!")
		ply:PrintMessage(3, "Map by AnonymoScoot")
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
			ent:Fire("display", nil, nil, pl, activator)
		end

		return true
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
