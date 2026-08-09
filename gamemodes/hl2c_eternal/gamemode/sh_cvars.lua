if CLIENT then
	CreateClientConVar("hl2ce_cl_noearringing", 0, true, true, "Disables annoying tinnitus sound when taking damage from explosions", 0, 1)
	CreateClientConVar("hl2ce_cl_nohuddifficulty", 0, true, false, "Disables Difficulty text from HUD if not having CMenu Open", 0, 1)
	CreateClientConVar("hl2ce_cl_nodifficultytext", 0, true, false, "Displays only the % on difficulty", 0, 1)
	CreateClientConVar("hl2ce_cl_noshowdifficultychange", 0, true, false, "Displays when difficulty changed", 0, 1)
	CreateClientConVar("hl2ce_cl_nocustomhud", 0, true, false, "Disables the HL2 Health and Armor Bars", 0, 1)
	CreateClientConVar("hl2ce_cl_nohud", 0, true, false, "Disables the HUD display entirely.", 0, 1)
	CreateClientConVar("hl2ce_cl_nokillfeed", 0, true, false, "Disables the Gmod's killfeed.", 0, 1)
	CreateClientConVar("hl2ce_cl_nodmgnum", 0, true, false, "Disables damage numbers.", 0, 1)
	CreateClientConVar("hl2ce_cl_drawxpgaintext", 1, true, false, "Draw XP gain text", 0, 1)
	CreateClientConVar("hl2ce_cl_noplrdeathmsg", 0, true, false, "Disable player death messages. (Recommended: 1 on singleplayer, 0 on multiplayer)", 0, 1)
	CreateClientConVar("hl2ce_cl_noplrdeathsound", 0, true, false, "Disable player death sounds.", 0, 1)
	CreateClientConVar("hl2ce_cl_showmaptimer", 0, true, false, "Show how much time you spent on this map.", 0, 1)
	local hl2ce_cl_noepilepsy = CreateClientConVar("hl2ce_cl_noepilepsy", 1, true, false, "Greatly weakens violently flashing lights, or disables them.", 0, 1)
	GM.NoEpilepsy = hl2ce_cl_noepilepsy:GetBool()
	cvars.AddChangeCallback("hl2ce_cl_noepilepsy", function(cvar, old, new)
		GAMEMODE.NoEpilepsy = tobool(new)
	end, "hl2ce_cl_noepilepsy")
	CreateClientConVar("hl2ce_cl_noshowlosetext", 0, true, false, "Don't show the lose screen.", 0, 1)
end


GM.AdminPhysgun = CreateConVar("hl2ce_admin_physgun", ADMIN_PHYSGUN, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_admin_physgun", function(convar, old, new)
	GAMEMODE.AdminPhysgun = tobool(new)
end, "hl2ce_admin_physgun")

GM.AdminNoclip = CreateConVar("hl2ce_admin_noclip", ADMIN_NOCLIP, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_admin_noclip", function(convar, old, new)
	GAMEMODE.AdminNoclip = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.AdminNoclip = %s]], GAMEMODE.AdminNoclip))
end, "hl2ce_admin_noclip")

GM.ForceGamerules = CreateConVar("hl2ce_server_force_gamerules", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_force_gamerules", function(convar, old, new)
	GAMEMODE.ForceGamerules = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.ForceGamerules = %s]], GAMEMODE.ForceGamerules))
end, "hl2ce_server_force_gamerules")

GM.CustomPMs = CreateConVar("hl2ce_server_custom_playermodels", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_custom_playermodels", function(convar, old, new)
	GAMEMODE.CustomPMs = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.CustomPMs = %s]], GAMEMODE.CustomPMs))
end, "hl2ce_server_custom_playermodels")

GM.CheckpointRespawn = CreateConVar("hl2ce_server_checkpoint_respawn", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_checkpoint_respawn", function(convar, old, new)
	GAMEMODE.CheckpointRespawn = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.CheckpointRespawn = %s]], GAMEMODE.CheckpointRespawn))
end, "hl2ce_server_checkpoint_respawn")

GM.DynamicSkillLevel = CreateConVar("hl2ce_server_dynamic_skill_level", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_dynamic_skill_level", function(convar, old, new)
	GAMEMODE.DynamicSkillLevel = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.DynamicSkillLevel = %s]], GAMEMODE.DynamicSkillLevel))
end, "hl2ce_server_dynamic_skill_level")

GM.LagCompensation = CreateConVar("hl2ce_server_lag_compensation", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_lag_compensation", function(convar, old, new)
	GAMEMODE.LagCompensation = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.LagCompensation = %s]], GAMEMODE.LagCompensation))
end, "hl2ce_server_lag_compensation")

GM.PlayerRespawning = CreateConVar("hl2ce_server_player_respawning", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_player_respawning", function(convar, old, new)
	GAMEMODE.PlayerRespawning = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.PlayerRespawning = %s]], GAMEMODE.PlayerRespawning))
end, "hl2ce_server_player_respawning")

GM.RespawnTimer = CreateConVar("hl2ce_server_player_respawntimer", 3, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetFloat()
cvars.AddChangeCallback("hl2ce_server_player_respawntimer", function(convar, old, new)
	GAMEMODE.RespawnTimer = tonumber(new)

	BroadcastLua(string.format([[GAMEMODE.RespawnTimer = %s]], GAMEMODE.RespawnTimer))
end, "hl2ce_server_player_respawntimer")

GM.JeepPassengerSeat = CreateConVar("hl2ce_server_jeep_passenger_seat", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_jeep_passenger_seat", function(convar, old, new)
	GAMEMODE.JeepPassengerSeat = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.JeepPassengerSeat = %s]], GAMEMODE.JeepPassengerSeat))
end, "hl2ce_server_jeep_passenger_seat")


local cvar = CreateConVar("hl2ce_server_ex_mode_enabled", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE)
GM.EnableEXMode = cvar:GetBool()
GM.EnableHyperEXMode = cvar:GetInt() >= 2
cvars.AddChangeCallback("hl2ce_server_ex_mode_enabled", function(convar, old, new)
	GAMEMODE.EnableEXMode = tobool(new)
	GAMEMODE.EnableHyperEXMode = (tonumber(new) or 0) >= 2

	BroadcastLua(string.format([[GAMEMODE.EnableEXMode = %s]], GAMEMODE.EnableEXMode))
	BroadcastLua(string.format([[GAMEMODE.EnableHyperEXMode = %s]], GAMEMODE.EnableHyperEXMode))
end, "hl2ce_server_ex_mode_enabled")

local cvar = CreateConVar("hl2ce_server_hardcore_mode_enabled", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE)
GM.EnableHardcoreMode = cvar:GetBool()
cvars.AddChangeCallback("hl2ce_server_hardcore_mode_enabled", function(convar, old, new)
	GAMEMODE.EnableHardcoreMode = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.EnableHardcoreMode = %s]], GAMEMODE.EnableHardcoreMode))

	GAMEMODE:EnableHardcore(gamemode.Call("ShouldEnableHardcore"), true)
end, "hl2ce_server_hardcore_mode_enabled")

GM.ForceDifficulty = CreateConVar("hl2ce_server_force_difficulty", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE):GetString()
cvars.AddChangeCallback("hl2ce_server_force_difficulty", function(convar, old, new)
	GAMEMODE.ForceDifficulty = new

	BroadcastLua(string.format([[GAMEMODE.ForceDifficulty = %s]], GAMEMODE.ForceDifficulty))
end, "hl2ce_server_force_difficulty")

GM.SkillsDisabled = CreateConVar("hl2ce_server_skills_disabled", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_skills_disabled", function(convar, old, new)
	GAMEMODE.SkillsDisabled = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.SkillsDisabled = %s]], GAMEMODE.SkillsDisabled))
end, "hl2ce_server_skills_disabled")

GM.PlayerMedkitOnSpawn = CreateConVar("hl2ce_server_player_medkit", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Give medkits for players on spawn"):GetBool()
cvars.AddChangeCallback("hl2ce_server_player_medkit", function(convar, old, new)
	GAMEMODE.PlayerMedkitOnSpawn = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.PlayerMedkitOnSpawn = %s]], GAMEMODE.PlayerMedkitOnSpawn))

	if SERVER then
		if GAMEMODE.PlayerMedkitOnSpawn then
			for _,pl in ipairs(player.GetLiving()) do
				if !pl:IsSuitEquipped() then continue end
				pl:Give("weapon_hl2ce_medkit")
			end
		else
			for _,pl in ipairs(player.GetLiving()) do
				pl:StripWeapon("weapon_hl2ce_medkit")
			end
		end
	end
end, "hl2ce_server_player_medkit")

local function callback()
	local jumped = {}
	local function bhop(enable)
		if enable then
			hook.Add("SetupMove", "hl2ce_bhop", function(ply, mv, ucmd)
				if ply:GetMoveType() ~= MOVETYPE_WALK or ply:WaterLevel() > 1 then return end
				local buttons = ucmd:GetButtons()
				local jumping = bit.band(buttons, IN_JUMP) ~= 0

				if jumping and !jumped[ply] and ply:OnGround() then
					if ply:Crouching() and bit.band(buttons, IN_DUCK) == 0 then
						buttons = buttons + IN_DUCK
					end
					jumped[ply] = true

				else
					if jumping and !ply:OnGround() then
						buttons = buttons - IN_JUMP
					end

					jumped[ply] = nil
				end
			
				mv:SetButtons(buttons)
			end)
		else
			hook.Remove("SetupMove", "hl2ce_bhop")
		end
	end

	local GM = GAMEMODE or GM
	bhop(tobool(GM.BHopEnabled))
end
GM.BHopEnabled = CreateConVar("hl2ce_server_bhop_enable", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable bhop... for fun!"):GetBool()
cvars.AddChangeCallback("hl2ce_server_bhop_enable", function(convar, old, new)
	GAMEMODE.BHopEnabled = tobool(new)

	BroadcastLua(string.format([[GAMEMODE.BHopEnabled = %s]], GAMEMODE.BHopEnabled))

	callback()
end, "hl2ce_server_bhop_enable")

if GM.BHopEnabled then
	callback()
end

GM.EnemyNPCHealthMul = CreateConVar("hl2ce_server_npchpmul", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetFloat()
cvars.AddChangeCallback("hl2ce_server_npchpmul", function(convar, old, new)
	GAMEMODE.EnemyNPCHealthMul = tonumber(new)

	BroadcastLua(string.format([[GAMEMODE.EnemyNPCHealthMul = %s]], GAMEMODE.EnemyNPCHealthMul))
end, "hl2ce_server_npchpmul")
