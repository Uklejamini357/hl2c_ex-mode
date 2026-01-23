NEXT_MAP = "ep1_c17_02"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_frag")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local hastriggered

-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "physbox_crank_a" and input:lower() == "use" and !GAMEMODE.MapVars.CrankBroken then
		GAMEMODE.MapVars.CrankBroken = true
		if GAMEMODE.EXMode then
			PrintMessage(3, "what the frick.") -- broken door
		end
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_freshair" and input:lower() == "start" then
			timer.Simple(2.5, function()
				PrintMessage(3, "Chapter A4")
			end)
			timer.Simple(5.3, function()
				PrintMessage(3, "The Impending doom")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
