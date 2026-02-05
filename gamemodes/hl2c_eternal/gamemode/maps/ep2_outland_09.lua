INFO_PLAYER_SPAWN = {Vector(1030, -9198, 72), 180}

NEXT_MAP = "ep2_outland_10"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	-- i guess not.
	-- ents.FindByName("new_game_items")[5]:SetKeyValue("Template03", "")

	-- local alyx = ents.Create("npc_alyx")
	-- alyx:SetName("alyx")
	-- alyx:SetKeyValue("GameEndAlly", "1")
	-- alyx:Give("weapon_alyxgun")
	-- alyx:SetPos(Vector(965, -9203, 72))
	-- alyx:SetAngles(Angle(0, 180, 0))
	-- alyx:Spawn()

	-- local npc_citizen_opengate = ents.Create("npc_citizen")
	-- npc_citizen_opengate:SetName("npc_citizen_opengate")
	-- npc_citizen_opengate:SetKeyValue("GameEndAlly", "1")
	-- npc_citizen_opengate:Give("weapon_ar2")
	-- npc_citizen_opengate:SetPos(Vector(893, -9162, 72))
	-- npc_citizen_opengate:SetAngles(Angle(0, 90, 0))
	-- npc_citizen_opengate:Spawn()
	-- npc_citizen_opengate:SetModel("models/humans/group03/male_08.mdl")
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if GAMEMODE.EXMode then
		if ent:GetName() == "lcs_welder_bottle" and input:lower() == "start" then
			PrintMessage(3, "HEY, I WAS DRINKING THAT!!")
		end

		if ent:GetName() == "lcs_trainyard_intro_2" and input:lower() == "resume" then
			timer.Simple(2.5, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter B5")
			end)
			timer.Simple(5.1, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "idk")
			end)
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "alyx_check_fail" and input:lower() == "display" then
		activator:Kill()
    end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
