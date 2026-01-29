-- I don't know why the fuck this map sometimes gets stuck in infinite loop

NEXT_MAP = "ep2_outland_01a"

RESET_PL_INFO = true

TRIGGER_CHECKPOINT = {
	{Vector(340, -864, -4), Vector(404, -714, 96)},
	{Vector(-3560, 1657, 144), Vector(-3768, 1744, 252)}
}

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cEntityTakeDamage(ent, dmginfo)
	if ent:IsNPC() and (ent:GetName() == "hunter.rooftop" or ent:GetName() == "hunter.hallway" or ent:GetName() == "hunter") then
		return true
	end
end
hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", hl2cEntityTakeDamage)


-- Accept input
function hl2cAcceptInput(ent, input, activator, caller, value)
    if !game.SinglePlayer() and string.lower(input) == "scriptplayerdeath" then -- Can break the sequences, again
        return true
    end

	if !game.SinglePlayer() and ent:GetClass() == "player_speedmod" and string.lower(input) == "modifyspeed" then
		for _, ply in ipairs(player.GetAll()) do
			ply:SetLaggedMovementValue(tonumber(value))
		end
		return true
	end

	if !game.SinglePlayer() and ent:GetName() == "clip_player_train" and input:lower() == "enable" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(54, 56, 240))
			ply:SetEyeAngles(Angle(0, 0, 0))
		end
		GAMEMODE:CreateSpawnPoint(Vector(334, 64, -60), 0)
	end

	if !game.SinglePlayer() and ent:GetName() == "relay.alyx.spawn" and input:lower() == "trigger" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(888, -194, -46))
			ply:SetEyeAngles(Angle(0, -30, 0))
		end
		GAMEMODE:CreateSpawnPoint(Vector(888, -194, -46), -30)
	end

	if ent:GetName() == "command_physcannon" and string.lower(input) == "command" then
		for _,ply in ipairs(player.GetLiving()) do
			ply:Give("weapon_physcannon")
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "mine_pit_clip_brush" and input:lower() == "enable" then
		return true
	end

	if ent:GetName() == "SS_cable_fix_begin" then
		if input:lower() == "cancelsequence" then
			local fixent = ents.FindByName("lcs_alyx_monitorsout")[1]

			timer.Simple(5, function()
				if !IsValid(fixent) then return end
				fixent:Fire("Resume")
			end)
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "relay_elev_fall" and input:lower() == "trigger" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end
			ply:Give("weapon_crowbar")

			ply:SetPos(Vector(-6286, 3810, -304))
			ply:SetEyeAngles(Angle(0, -90, 0))
		end

		GAMEMODE:ReplaceSpawnPoint(Vector(-6094, 3630, -1380), 180)
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "message_chapter_title1" and input:lower() == "showmessage" then
			timer.Simple(2, function()
				PrintMessage(3, "Chapter B1")
			end)

			timer.Simple(3.7, function()
				PrintMessage(3, "The story continues... sorry, I don't have a lot of chapter name ideas remaining")
			end)

			return true
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
