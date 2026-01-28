NEXT_MAP = "ep2_outland_10a"

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
		if ent:GetName() == "prelude_soldier_wav" and input:lower() == "playsound" then
			PrintMessage(3, "TARGET ONE!!!!")
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
