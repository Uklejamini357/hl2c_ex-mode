NEXT_MAP = "d1_trainstation_01"

INFO_PLAYER_SPAWN = {Vector(1654, 2216, -64), 130}

function hl2cAcceptInput(ent, input, activator, caller, value)
	if !game.SinglePlayer() and ent:GetName() == "door_courtyard" and input:lower() == "close" then
		for _,ply in ipairs(player.GetLiving()) do
			-- if ply == activator then continue end
			ply:SetPos(Vector(1888, 4730, 2560))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end

		GAMEMODE:ReplaceSpawnPoint(Vector(1888, 4730, 2560), -90)
	end

	if !game.SinglePlayer() and ent:GetName() == "doors_monastery" and input:lower() == "close" then
		for _,ply in ipairs(player.GetLiving()) do
			-- if ply == activator then continue end
			ply:SetPos(Vector(1472, 3940, 2680))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end

		GAMEMODE:ReplaceSpawnPoint(Vector(1474, 2916, 2720), 90)
	end

	if !game.SinglePlayer() and ent:GetName() == "brush_rearwall_playerclip" and input:lower() == "enable" then
		for _,ply in ipairs(player.GetLiving()) do
			-- if ply == activator then continue end
			ply:SetPos(Vector(2044, 3014, 2688))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end

		GAMEMODE:ReplaceSpawnPoint(Vector(2044, 3014, 2688), -90)
	end

	if ent:GetName() == "command" and input:lower() == "command" and value:lower() == "disconnect" then
		for _,ply in ipairs(player.GetLiving()) do
			gamemode.Call("CompleteMap", ply)
		end

		GAMEMODE:ReplaceSpawnPoint(Vector(2044, 3014, 2688), -90)
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
