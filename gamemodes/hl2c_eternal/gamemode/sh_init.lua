-- Include the required lua files
DeriveGamemode("sandbox")

include("break_infinity.lua")

include("sh_config.lua")
include("sh_cvars.lua")
include("sh_globals.lua")
include("sh_player.lua")
include("sh_ents.lua")
include("sh_pets.lua")


-- Create console variables to make these config vars easier to access
local hl2ce_server_force_difficulty = CreateConVar("hl2ce_server_force_difficulty", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Forced difficulty.")

-- General gamemode information
GM.Name = "Half-Life 2 Campaign: Eternal" -- alt name: Half-Life 2 Campaign: China Edition
GM.OriginalAuthor = "AMT (ported and improved by D4 the Perth Fox)"
GM.Author = "Uklejamini"
GM.Version = "0.inf^^^^inf" -- NOOOOO STOP!!!! (nah)
GM.DateVer = "30-06-2026"

-- even crazier things inbound... beware!


-- Constants
FRIENDLY_NPCS = {
	"npc_citizen",
	"monster_scientist",
	"monster_barney",
}

GODLIKE_NPCS = {
	"npc_alyx",
	"npc_barney",
	"npc_breen",
	"npc_dog",
	"npc_eli",
	"npc_fisherman",
	"npc_gman",
	"npc_kleiner",
	"npc_magnusson",
	"npc_monk",
	"npc_mossman",
	"npc_odessa",
	"npc_vortigaunt"
}

-- Create the teams that we are going to use throughout the game
function GM:CreateTeams()
	team.SetUp(TEAM_ALIVE, "ALIVE", Color(192, 192, 192))
	team.SetUp(TEAM_COMPLETED_MAP, "COMPLETED MAP", Color(255, 215, 0))
	team.SetUp(TEAM_DEAD, "DEAD", Color(128, 128, 128))
end

function GM:CalculateXPNeededForLevels(lvl)
	local xp = 0
	if lvl >= 100 then
		for i=lvl-100,lvl do
			xp = xp + self:GetReqXPCount(i)
		end
	else
		for i=1,infmath.ConvertInfNumberToNormalNumber(infmath.min(1e6, lvl)) do
			xp = xp + self:GetReqXPCount(i)
		end
	end

	return xp
end

function GM:GetReqXP(ply)
	return self:GetReqXPCount(ply.Level)
end

function GM:GetReqXPCount(lvl)
	local basexpreq = 152
	local addxpperlevel = 27
	local morelvlreq = 1.0715
	lvl_inf = lvl
	lvl = infmath.ConvertInfNumberToNormalNumber(lvl)

	local totalxpreq = InfNumber(basexpreq)
	totalxpreq = totalxpreq + ((lvl_inf * addxpperlevel) ^ morelvlreq)

	if lvl >= 100 then
		totalxpreq = totalxpreq * infmath.max(1 + (lvl_inf-100) * 0.05, 1)
	end
	if lvl >= 250 then
		totalxpreq = totalxpreq * infmath.max(1 + (lvl_inf-250) * 1.05^(1.05 + (lvl_inf-250)*0.05), 1)
	end
	if lvl >= 400 then
		totalxpreq = totalxpreq * infmath.max(InfNumber(1) + (lvl_inf-400) * (0.05+(lvl_inf-400)*0.01), 1)
	end
	if lvl >= 1000 then
		local l = lvl_inf-1000
		totalxpreq = totalxpreq * infmath.max(1, (1.0046+(l/1e5))^(l))
	end

	return infmath.Round(totalxpreq)
end

-- Called when a gravity gun is attempting to punt something
function GM:GravGunPunt(ply, ent) 
	if IsValid(ent) and ent:IsVehicle() and ent != ply.vehicle and IsValid(ent.creator) then
		return false
	end

	return true
end 


-- Called when a physgun tries to pick something up
function GM:PhysgunPickup(ply, ent)
	if string.find(ent:GetClass(), "trigger_") or ent:GetClass() == "player" then
		return false
	end

	return true
end

hook.Add("CanProperty", "Hl2ce_CanProperty", function(ply, property, ent)
	if not ply:IsAdmin() then return false end
end)

hook.Add("EntityEmitSound", "EXModeChanges", function(snd)
	if !GAMEMODE.EXMode then return end
	if snd.SoundName == "npc/attack_helicopter/aheli_weapon_fire_loop3.wav" then
		snd.Pitch = snd.Pitch * 0.65
		return true
	end
end)


-- Player input changes
function GM:StartCommand(ply, ucmd)
	-- if ucmd:KeyDown(IN_SPEED) and (ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetObserverMode() == OBS_MODE_ROAMING) then
	-- 	ucmd:RemoveKey(IN_SPEED)
	-- 	ply.m_InSpeedNoclip = true
	-- end

	if ucmd:KeyDown(IN_SPEED) and !ply:IsSuitEquipped() then
		ucmd:RemoveKey(IN_SPEED)
	end

	if (ucmd:KeyDown(IN_WALK) && IsValid(ply) && !ply:IsSuitEquipped()) then
		ucmd:RemoveKey(IN_WALK)
	end
end

function GM:SetupMove(ply, mv, ucmd)
end

function GM:Move(ply, mv)
	-- if ply.m_InSpeedNoclip then
	-- 	mv:SetVelocity(mv:GetVelocity()*3)
	-- end

	-- ply.m_InSpeedNoclip = nil
end


-- Players should never collide with each other or NPC's
function GM:ShouldCollide(entA, entB)
	if IsValid(entA) and IsValid(entB) then
		local classa,classb = entA:GetClass(),entB:GetClass()
		-- Prevent antlion guards from colliding each other
		if classa == classb or classa == "npc_antlion" and classb == "npc_antlionguard" or classa == "npc_antlionguard" and classb == "npc_antlion" then
			return false
		end

		-- Player and NPCs
		if (entA:IsPlayer() && (entB:IsPlayer() || entB:IsGodlikeNPC() or entB:IsFriendlyNPC())) || (entB:IsPlayer() && (entA:IsPlayer() || entA:IsGodlikeNPC() || entA:IsFriendlyNPC())) then
			return false
		end

		-- Passenger seating
		if (entA:IsPlayer() && entA:InVehicle() && entA:GetAllowWeaponsInVehicle() && entB:IsVehicle()) || (entB:IsPlayer() && entB:InVehicle() && entB:GetAllowWeaponsInVehicle() && entA:IsVehicle()) then
			return false
		end
	end

	if entA.DontCollide and entA.DontCollide == entB or entB.DontCollide and entB.DontCollide == entA then
		return false
	end
	
	return true
end


-- Called when a player is being attacked
function GM:PlayerShouldTakeDamage(ply, attacker)
	if ply:HasGodMode() then
		return false
	end

	if ply.invulnerableTime and ply.invulnerableTime > CurTime() then
		return false
	end

	if ply:Team() ~= TEAM_ALIVE then -- hmmm...
		return false
	end 

	if attacker:IsPlayer() and attacker ~= ply then
		return false
	end

	if attacker:IsVehicle() and IsValid(attacker:GetDriver()) and attacker:GetDriver():IsPlayer() then
		return false
	end

	if attacker:IsGodlikeNPC() or attacker:IsFriendlyNPC() then
		return false
	end

	return true
end

function GM:CanPlayerRespawn(pl)
	if OVERRIDE_PLAYER_RESPAWNING then return false end
	if self:HardcoreEnabled() then return false end

	return self.PlayerRespawning or FORCE_PLAYER_RESPAWNING
end

function GM:ShouldEnableHardcore()
	if NOENABLE_HARDCORE_MODE then return false end
	return self.EnableHardcoreMode
end

function GM:EnableHardcore(state, callhardcoreenaabled)
	if CLIENT then return end
	if state == self:HardcoreEnabled() then return end

	SetGlobalBool("hl2ce_hardcore", state)

	if callhardcoreenaabled then
		gamemode.Call("OnHardcoreEnabled", state)
	end
	return state
end

function GM:HardcoreEnabled()
	return GetGlobalBool("hl2ce_hardcore", false)
end


function GM:IsSpecialPerson(ply, image)
	if !IsValid(ply) then return end
	local img, tooltip
--i know this was copied from zombiesurvival gamemode but i was too lazy to make one by myself anyway
--you can add new special person table by yourself but you must keep the original ones and the new ones must be after steamid
	if ply:SteamID64() == "76561198274314803" then
		img = "icon16/award_star_gold_3.png"
		tooltip = "The Eternal"
	elseif ply:SteamID64() == "76561198058929932" then
		img = "icon16/medal_gold_3.png"
		tooltip = "Original Creator of Half-Life 2 Campaign"


	elseif ply:IsBot() then
		img = "icon16/plugin.png"
		tooltip = "BOT"
	elseif ply:IsSuperAdmin() then
		img = "icon16/shield_add.png"
		tooltip = "Super Admin"
	elseif ply:IsAdmin() then
		img = "icon16/shield.png"
		tooltip = "Admin"
	end

	if img then
		if CLIENT then
			image:SetImage(img)
			image:SetTooltip(tooltip)
		end
		return true
	end
	return false
end


-- Called after the player's think
function GM:PlayerPostThink(ply)
	-- Manage server data on the player
	if SERVER then
		if IsValid(ply) && ply:Alive() && (ply:Team() == TEAM_ALIVE) then
			-- Give them weapons they don't have
			for _, ply2 in ipairs(player.GetAll()) do
				if (ply != ply2) && ply2:Alive() && !ply:InVehicle() && !ply2:InVehicle() && IsValid(ply2:GetActiveWeapon()) && !ply:HasWeapon(ply2:GetActiveWeapon():GetClass()) && !table.HasValue(ply.givenWeapons, ply2:GetActiveWeapon():GetClass()) && (ply2:GetActiveWeapon():GetClass() != "weapon_physgun" and table.HasValue(WHITELISTED_WEAPONS, ply2:GetActiveWeapon():GetClass())) then
					ply:Give(ply2:GetActiveWeapon():GetClass())
					table.insert(ply.givenWeapons, ply2:GetActiveWeapon():GetClass())
				end
			end
		end
	end
end

function GM:PlayerSwitchWeapon(ply, old, new)
	if new:GetClass() == "weapon_rpg" then
		new:SetNextPrimaryFire(CurTime())
	end
end

-- why i'm using GlobalString instead of Float value:
-- Allows to be broadcasted to client with numbers like 2^128 (3.40e38) and above until 2^1024 (1.79e308) values
-- break infinity update: NOW UP TO 10^(1.79e308)!!!!!

function GM:SetDifficulty(val, noncvar)
	if CLIENT then return end
	local diffcvarvalue = tonumber(hl2ce_server_force_difficulty:GetString()) or 0

	if noncvar or diffcvarvalue <= 0 then
		local new = isinfnumber(val) and val:DefaultFormat() or ConvertStringToInfNumber(val):DefaultFormat()
		local new_infnumber = isinfnumber(val) and val or ConvertStringToInfNumber(val)

		SetGlobalString("hl2c_difficulty", new)
		gamemode.Call("OnDifficultyChanged", self.PreviousDifficulty, new_infnumber)
		self.PreviousDifficulty = new_infnumber
		self.PreviousDifficultyStr = GetGlobalString("hl2c_difficulty")
	end
end

-- Why 1e150 max difficulty? -- It might seem possible to go further.. But damage is only limited to 3.40e38. After that value it overflows to infinity. honestly, fuck it

GM.PreviousDifficulty = (GAMEMODE or GM).PreviousDifficulty or InfNumber(1)
GM.PreviousDifficultyStr = (GAMEMODE or GM).PreviousDifficultyStr or "1"

function GM:GetDifficulty(noncvar, noadditionalmul)
	local diffcvarvalue = hl2ce_server_force_difficulty:GetString()

	if not noncvar and ((tonumber(diffcvarvalue or 0) or 1) > 0) then
		return infmath.ConvertStringToInfNumber(diffcvarvalue)
	end

	local global_diff_str = GetGlobalString("hl2c_difficulty", 1)
	if self.PreviousDifficultyStr == global_diff_str then
		return self.PreviousDifficulty
	end

	local value = ConvertStringToInfNumber(global_diff_str)
	self.PreviousDifficultyStr = global_diff_str
	if not noadditionalmul and FORCE_DIFFICULTY then
		value = value * FORCE_DIFFICULTY
	end

	if CLIENT then
		gamemode.Call("OnDifficultyChanged", self.PreviousDifficulty, value)
	end
	self.PreviousDifficulty = value

	return value
end

-- most of them were taken from https://jtohs-joke-towers.fandom.com/wiki/Main_Difficulty_Chart
-- Some from ULTRAKILL.
local rgb = Color
function GM:GetDifficultyNameCol(diff)
	local d = isinfnumber(diff) and infmath.ConvertInfNumberToNormalNumber(diff) or diff
	local dlog10 = isinfnumber(diff) and diff:log10() or math.log10(diff)

	if d < 0 then -- section NULL: Blah
		if diff.exponent >= MAX_NUMBER then
			return "NEGATIVE INFINITY", HSVToColor(0, 0, (SysTime()*66)%1)
		elseif d < -MAX_NUMBER then
			return "Absolute Negativity", HSVToColor(0, 0, math.floor(SysTime()*math.pi)%2)
		else
			return "Negativity", HSVToColor(0, 0, math.floor(SysTime()*(1/math.pi))%2)
		end
	elseif d < 1 then -- section 0: EASY difficulties
		if d == 0 then
			return "Blessing", rgb(0, 232, 186)
		elseif d < 0.01 then
			return "Effortlessless", rgb(154, 245, 209)
		elseif d < 0.1 then
			return "Harmless", rgb(0, 255, 0)
		elseif d < 0.2 then
			return "Effortless", rgb(0, 110, 0)
		elseif d < 0.4 then
			return "Lenient", rgb(80, 255, 0) -- also known as Simple
		elseif d < 0.7 then
			return "Easy", rgb(112, 250, 0)
		elseif d < 0.9 then
			return "Calm", rgb(193, 252, 53)
		else
			return "Medium", rgb(138, 138, 17)
		end
	elseif d < 10 then -- section 1: Hard Difficulties (100+%)
		if d < 1.2 then -- add: veteran, master, legend here
			return "Normal", rgb(240, 240, 0) -- also known as STANDARD
		elseif d < 1.5 then
			return "Intermediate", rgb(255, 187, 0)
		elseif d < 1.75 then
			return "Extraordinary", rgb(255, 149, 0)
		elseif d < 2 then
			return "Hard", rgb(255, 128, 0)
		elseif d < 2.5 then
			return "Violent", rgb(255, 64, 0)
		elseif d < 3 then
			return "Tricky", rgb(255, 42, 0)
		elseif d < 3.5 then
			return "Difficult", rgb(250, 0, 0)
		elseif d < 4.5 then
			return "BRUTAL", rgb(210, 0, 0)
		elseif d < 5.5 then
			return "Menacing", rgb(255, 166, 166)
		elseif d < 6.5 then
			return "Maniacal", rgb(240, 240, 0)
		elseif d < 7.5 then
			return "Hectic", rgb(255, 252, 254)
		elseif d < 8.5 then
			return "Intense", rgb(252, 254, 255)
		else
			return "Hellish", rgb(252, 199, 255)
		end
	elseif d < 1e2 then -- section 2: Soul-crushing Difficulties (1K+%)
		if d < 15 then
			return "Remorseless", rgb(255, 173, 254)
		elseif d < 20 then
			return "Relentless", rgb(72, 0, 255)
		elseif d < 25 then
			return "Insane", rgb(0, 0, 255)
		elseif d < 30 then
			return "Madness", rgb(0, 119, 255)
		elseif d < 40 then
			return "Extreme", rgb(31, 139, 255)
		elseif d < 50 then
			return "Absurd", rgb(0, 221, 255)
		elseif d < 65 then
			return "Terrifying", rgb(0, 255, 255)
		elseif d < 80 then
			return "Horrifying", rgb(0, 184, 184)
		else
			return "Petrifying", rgb(0, 135, 135)
		end
	elseif d < 1e4 then -- section 3: Humanly-Impossible Difficulties (10K+%)
		if d < 150 then -- add: impossible here
			return "Catastrophic", rgb(0, 0, 0)
		elseif d < 250 then
			return "Dorcelessness", rgb(209, 0, 237):Lerp(rgb(115, 0, 140), 0.5 + math.sin(SysTime())/2)
		elseif d < 400 then
			return "Champion's Road", rgb(0, 145, 158):Lerp(rgb(158, 58, 77), 0.5 + math.sin(SysTime()*1.5)/2)
		elseif d < 600 then
			return "Horrific", rgb(109, 90, 219)
		elseif d < 1000 then
			return "Harrowing", rgb(227, 154, 206)
		elseif d < 2000 then
			return "Unreal", rgb(190, 176, 255)
		elseif d < 5000 then
			return "Treacherous", rgb(226, 212, 250)
		else
			return "Prodigious", rgb(119, 166, 191)
		end
	elseif d < math.huge then -- section 4: Hypothetically impossible Difficulties (1M+%)
		-- if d < 1.2 then
			return "ETERNALS MUST DIE", rgb(100, 240, 255)
		-- end
	elseif d >= math.huge then -- section ???: TRULY IMPOSSIBLE. (1.79e310% difficulty and ABOVE)
		return "TRULY IMPOSSIBLE", rgb(255, 0, 0)
	else
		return "", color_black
	end


	return "NULL", COLOR_WHITE
end

function GM:OnDifficultyChanged(old, new)
end

function GM:GetEffectiveDifficulty(ply)
	if !ply then return self:GetDifficulty() end

	local power = 1

	if ply:HasPerkActive("3_extremility") then
		power = power * 0.9
	end

	return self:GetDifficulty()^power
end

function GM:GetDifficultyText(diff)
	if !diff then diff = self:GetDifficulty() end

	return "Normal"
end

function FormatNumber(val, roundval)
	local log10_value = math.floor(isinfnumber(val) and val:log10() or math.log10(val))

	if isinfnumber(val) then
		if log10_value < 33 then
			val = infmath.ConvertInfNumberToNormalNumber(val)
		else
			return tostring(val)
		end
	end

	local txt
	local negative = val < 0 and "-" or ""
	roundval = roundval or 2
	val = math.abs(val)
	if val >= math.huge then return val end
	if val >= 1e33 then
		val = val / (10^log10_value)

		txt = math.floor(val*(10^roundval))/(10^roundval) .."e"..log10_value
	elseif val >= 1e30 then
		val = val / 1e30

		txt = math.floor(val*(10^roundval))/(10^roundval) .." No"
	elseif val >= 1e27 then
		val = val / 1e27

		txt = math.floor(val*(10^roundval))/(10^roundval) .." Oc"
	elseif val >= 1e24 then
		val = val / 1e24

		txt = math.floor(val*(10^roundval))/(10^roundval) .." Sp"
	elseif val >= 1e21 then
		val = val / 1e21

		txt = math.floor(val*(10^roundval))/(10^roundval) .." Sx"
	elseif val >= 1e18 then
		val = val / 1e18

		txt = math.floor(val*(10^roundval))/(10^roundval) .." Qt"
	elseif val >= 1e15 then
		val = val / 1e15

		txt = math.floor(val*(10^roundval))/(10^roundval) .." Qa"
	elseif val >= 1e12 then
		val = val / 1e12

		txt = math.floor(val*(10^roundval))/(10^roundval) .." T"
	elseif val >= 1e9 then
		val = val / 1e9

		txt = math.floor(val*(10^roundval))/(10^roundval) .." B"
	elseif val >= 1e6 then
		val = val / 1e6

		txt = math.floor(val*(10^roundval))/(10^roundval) .." M"
	elseif val >= 1e3 then
		val = val / 1e3

		txt = math.floor(val*(10^roundval))/(10^roundval) .." K"
	elseif val == 0 then txt = 0
	elseif val > -(10^-(roundval or 1)) and val < 10^-(roundval or 1) then
		val = val / (10^log10_value)

		txt = math.floor(val*(10^roundval))/(10^roundval) .."e-"..math.abs(log10_value)
	end

	if txt then return negative..txt end
	return negative..math.Round(val*(10^(roundval or 1)))/(10^(roundval or 1))
end

function GlitchedText(text, chance)
	local str = ""

	for i=1,#text do
		str=str..(math.Rand(0,100) < chance and utf8.char(math.random(32, 2048)) or text[i])
	end

	return str
end

function GM:GetCurrentBoss()
	return GetGlobalEntity("HL2CE.Boss", self.EnemyBoss or NULL)
end

function GM:SetCurrentBoss(ent)
	SetGlobalEntity("HL2CE.Boss", ent)
end

/*
function FormatNumber(value)
	if value == math.huge then return "Infinite" end
	if value >= 1e3 then
		value = value / 1e3
		return math.Round(value, 2).." K"
	end

	-- return string.format("%d.%02d", value, value/math.floor(math.log10(value)))
	return value
end
*/
