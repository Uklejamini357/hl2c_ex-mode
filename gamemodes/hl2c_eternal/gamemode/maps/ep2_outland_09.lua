INFO_PLAYER_SPAWN = {Vector(1030, -9198, 72), 180}

NEXT_MAP = "ep2_outland_10"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_welder_bottle" and input:lower() == "start" then
			PrintMessage(3, "HEY, I WAS DRINKING THAT!!")
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
