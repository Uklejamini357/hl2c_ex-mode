GM.AdminPhysgun = CreateConVar("hl2c_admin_physgun", ADMIN_PHYSGUN, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_admin_physgun", function(convar, old, new)
	GAMEMODE.AdminPhysgun = tobool(new)
end, "hl2c_admin_physgun")

GM.AdminNoclip = CreateConVar("hl2c_admin_noclip", ADMIN_NOCLIP, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_admin_noclip", function(convar, old, new)
	GAMEMODE.AdminNoclip = tobool(new)
end, "hl2c_admin_noclip")

GM.ForceGamerules = CreateConVar("hl2c_server_force_gamerules", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_force_gamerules", function(convar, old, new)
	GAMEMODE.ForceGamerules = tobool(new)
end, "hl2c_server_force_gamerules")

GM.CustomPMs = CreateConVar("hl2c_server_custom_playermodels", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_custom_playermodels", function(convar, old, new)
	GAMEMODE.CustomPMs = tobool(new)
end, "hl2c_server_custom_playermodels")

GM.CheckpointRespawn = CreateConVar("hl2c_server_checkpoint_respawn", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_checkpoint_respawn", function(convar, old, new)
	GAMEMODE.CheckpointRespawn = tobool(new)
end, "hl2c_server_checkpoint_respawn")

GM.DynamicSkillLevel = CreateConVar("hl2c_server_dynamic_skill_level", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_dynamic_skill_level", function(convar, old, new)
	GAMEMODE.DynamicSkillLevel = tobool(new)
end, "hl2c_server_dynamic_skill_level")

GM.LagCompensation = CreateConVar("hl2c_server_lag_compensation", 1, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_lag_compensation", function(convar, old, new)
	GAMEMODE.LagCompensation = tobool(new)
end, "hl2c_server_lag_compensation")

GM.PlayerRespawning = CreateConVar("hl2c_server_player_respawning", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_player_respawning", function(convar, old, new)
	GAMEMODE.PlayerRespawning = tobool(new)
end, "hl2c_server_player_respawning")

GM.JeepPassengerSeat = CreateConVar("hl2c_server_jeep_passenger_seat", 0, FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2c_server_jeep_passenger_seat", function(convar, old, new)
	GAMEMODE.JeepPassengerSeat = tobool(new)
end, "hl2c_server_jeep_passenger_seat")


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
end, "hl2ce_server_force_difficulty")

GM.SkillsDisabled = CreateConVar("hl2ce_server_skills_disabled", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE):GetBool()
cvars.AddChangeCallback("hl2ce_server_skills_disabled", function(convar, old, new)
	GAMEMODE.SkillsDisabled = tobool(new)
end, "hl2ce_server_skills_disabled")

GM.PlayerMedkitOnSpawn = CreateConVar("hl2ce_server_player_medkit", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Give medkits for players on spawn"):GetBool()
cvars.AddChangeCallback("hl2ce_server_player_medkit", function(convar, old, new)
	GAMEMODE.PlayerMedkitOnSpawn = tobool(new)
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

	callback()
end, "hl2ce_server_bhop_enable")

if GM.BHopEnabled then
	callback()
end

