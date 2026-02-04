
if CLIENT then return end

CUSTOM_NPC_KILLED_MESSAGE = "You failed to protect the vortigaunt from the antlion attacks!"

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_shotgun")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Player initial spawn
function hl2cPlayerInitialSpawn(ply)
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)

-- Initialize entities
function hl2cPreMapEdit()
	if GAMEMODE.CampaignMapVars.ExtractObtained then
		INFO_PLAYER_SPAWN = {Vector(-3100, -9476, -3097), 0}
		NEXT_MAP = "ep2_outland_05"
		GAMEMODE.XP_REWARD_ON_MAP_COMPLETION = 0
	else
		NEXT_MAP = "ep2_outland_03"
		TRIGGER_CHECKPOINT = {
			{Vector(-606, -9412, -712), Vector(-396, -9796, -524)}
		}
	end
end
hook.Add("PreMapEdit", "hl2cPreMapEdit", hl2cPreMapEdit)

-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("spawnitems_template")[1]:Remove()

	if GAMEMODE.CampaignMapVars.ExtractObtained then
		local vort = ents.Create("npc_vortigaunt")
		vort:SetPos(Vector(-3100, -9500, -3097))
		vort:SetName("vort")
		vort:Spawn()
	end
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

-- Initialize entities
function hl2cOnEntityCreated(ent)
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		if ent:GetName() == "vort" then
			ent.allowDIE = true
		end
	end)
end
hook.Add("OnEntityCreated", "hl2cOnEntityCreated", hl2cOnEntityCreated)

-- Initialize entities
function hl2cEntityTakeDamage(ent, dmginfo)
	if ent:IsNPC() and (ent:GetName() == "sheckley" or ent:GetName() == "griggs") then
		return true
	end
end
hook.Add("EntityTakeDamage", "hl2cEntityTakeDamage", hl2cEntityTakeDamage)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if !game.SinglePlayer() and ent:GetName() == "turret_arena_vcd_2" and string.lower(input) == "start" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(-3024, -9304, -894))
		end
		
		GAMEMODE:CreateSpawnPoint( Vector(-3024, -9304, -894), -90 )
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_pre_revive" and string.lower(input) == "start" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(-3106, -9474, -894))
			ply:SetEyeAngles(Angle(0, 0, 0))
		end
		
		GAMEMODE:CreateSpawnPoint(Vector(-3106, -9474, -894), 0)
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_vort_revive" and string.lower(input) == "start" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(-3024, -9476, -900))
			ply:SetEyeAngles(Angle(0, 0, 0))
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "lcs_vort_goodbye" and string.lower(input) == "start" then
		for _,ply in ipairs(player.GetLiving()) do
			if ply == activator then continue end

			ply:SetPos(Vector(-3106, -9474, -894))
			ply:SetEyeAngles(Angle(0, 0, 0))
		end
	end

	if !game.SinglePlayer() and ent:GetName() == "elevator_door_2_open_rl" and string.lower(input) == "start" then
		GAMEMODE:CreateSpawnPoint(Vector(-3106, -9474, 112), 180)
	end

	if GAMEMODE.EXMode then
		if ent:GetName() == "turret_arena_vcd_1" and input:lower() == "start" then
			timer.Simple(3.3, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Chapter B2")
			end)

			timer.Simple(5.4, function()
				if !IsValid(ent) then return end
				PrintMessage(3, "Prepare for unforseen consequences.")
			end)
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
