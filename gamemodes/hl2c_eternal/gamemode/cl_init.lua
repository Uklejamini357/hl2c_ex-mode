-- Include the required lua files
include("sh_init.lua")
include("sh_translate.lua")
include("cl_calcview.lua")
include("cl_playermodels.lua")
include("cl_scoreboard.lua")
include("cl_viewmodel.lua")
include("cl_net.lua")
include("cl_options.lua")
include("cl_perksmenu.lua")
include("cl_prestige.lua")
include("cl_config.lua")
include("cl_upgradesmenu.lua")
include("cl_admin.lua")

local translate_Get = translate.Get
local translate_Format = translate.Format

local hl2ce_cl_noearringing = CreateClientConVar("hl2ce_cl_noearringing", 0, true, true, "Disables annoying tinnitus sound when taking damage from explosions", 0, 1)
local hl2ce_cl_nohuddifficulty = CreateClientConVar("hl2ce_cl_nohuddifficulty", 0, true, false, "Disables Difficulty text from HUD if not having CMenu Open", 0, 1)
local hl2ce_cl_nodifficultytext = CreateClientConVar("hl2ce_cl_nodifficultytext", 0, true, false, "Displays only the % on difficulty", 0, 1)
local hl2ce_cl_noshowdifficultychange = CreateClientConVar("hl2ce_cl_noshowdifficultychange", 0, true, false, "Displays when difficulty changed", 0, 1)
local hl2ce_cl_nocustomhud = CreateClientConVar("hl2ce_cl_nocustomhud", 0, true, false, "Disables the HL2 Health and Armor Bars", 0, 1)
local hl2ce_cl_drawxpgaintext = CreateClientConVar("hl2ce_cl_drawxpgaintext", 1, true, false, "Draw XP gain text", 0, 1)
local hl2ce_cl_noplrdeathsound = CreateClientConVar("hl2ce_cl_noplrdeathsound", 0, true, false, "Disable player death sounds.", 0, 1)
local hl2ce_cl_showmaptimer = CreateClientConVar("hl2ce_cl_showmaptimer", 0, true, false, "Show how much time you spent on this map.", 0, 1)
local hl2ce_cl_noepilepsy = CreateClientConVar("hl2ce_cl_noepilepsy", 1, true, false, "Greatly weakens violently flashing lights, or disables them.", 0, 1)
GM.NoEpilepsy = hl2ce_cl_noepilepsy:GetBool()
cvars.AddChangeCallback("hl2ce_cl_noepilepsy", function(cvar, old, new)
	GAMEMODE.NoEpilepsy = tobool(new)
end, "hl2ce_cl_noepilepsy")

-- Create data folders
if !file.IsDir(GM.VaultFolder, "DATA") then file.CreateDir(GM.VaultFolder) end
if !file.IsDir(GM.VaultFolder.."/client", "DATA") then file.CreateDir(GM.VaultFolder.."/client") end


-- Called by ShowScoreboard
function GM:CreateScoreboard()
	if scoreboard and scoreboard:IsValid() then
		scoreboard:Remove()
		scoreboard = nil
	end

	scoreboard = vgui.Create("scoreboard")
end

function GM:HUDDrawScoreBoard()
end

function EasyLabel(parent, text, font, textcolor)
	local dpanel = vgui.Create("DLabel", parent)
	if font then
		dpanel:SetFont(font or "DefaultFont")
	end
	dpanel:SetText(text)
	dpanel:SizeToContents()
	if textcolor then
		dpanel:SetTextColor(textcolor)
	end
	dpanel:SetKeyboardInputEnabled(false)
	dpanel:SetMouseInputEnabled(false)

	return dpanel
end

function EasyButton(parent, text, xpadding, ypadding)
	local dpanel = vgui.Create("DButton", parent)
	if textcolor then
		dpanel:SetFGColor(textcolor or color_white)
	end
	if text then
		dpanel:SetText(text)
	end
	dpanel:SizeToContents()

	if xpadding then
		dpanel:SetWide(dpanel:GetWide() + xpadding * 2)
	end

	if ypadding then
		dpanel:SetTall(dpanel:GetTall() + ypadding * 2)
	end

	return dpanel
end


GM.DifficultyDifference = GM.DifficultyDifference or 0
GM.DifficultyDifferenceTotal = GM.DifficultyDifferenceTotal or 0
GM.DifficultyDifferenceTimeChange = GM.DifficultyDifferenceTimeChange or 0
function GM:Think()
end

hook.Add("OnDifficultyChanged", "InfNumber.blah", function(old, new)
	local gm = GAMEMODE

	gm.DifficultyDifference = new - old
	if infmath.ConvertInfNumberToNormalNumber(gm.DifficultyDifference) ~= 0 then
		gm.DifficultyDifferenceTotal = gm.DifficultyDifferenceTotal + gm.DifficultyDifference
		gm.DifficultyDifferenceTimeChange = CurTime()
	end
	timer.Create("InfNumber.DifficultyTotal.Reset", 3, 1, function()
		gm.DifficultyDifferenceTotal = 0
	end)
end)

local bosshp = 0
-- Called every frame to draw the hud
function GM:HUDPaint()
	local pl = LocalPlayer()
	if !GetConVar("cl_drawhud"):GetBool() || (self.ShowScoreboard && IsValid(pl) && (pl:Team() != TEAM_DEAD)) then return end

	if !showNav then hook.Run("HUDDrawTargetID") end
	hook.Run("HUDDrawPickupHistory")

	local w = ScrW()
	local h = ScrH()
	centerX = w / 2
	centerY = h / 2

	-- Draw nav marker/point
	if showNav && checkpointPosition && (pl:Team() == TEAM_ALIVE) then
		local checkpointDistance = math.Round(pl:GetPos():Distance(checkpointPosition) / 39)
		local checkpointPositionScreen = checkpointPosition:ToScreen()
		surface.SetDrawColor(255, 255, 255, 255)
	
		if ( ( checkpointPositionScreen.x > 32 ) && ( checkpointPositionScreen.x < ( w - 43 ) ) && ( checkpointPositionScreen.y > 32 ) && ( checkpointPositionScreen.y < ( h - 38 ) ) ) then
			surface.SetTexture(surface.GetTextureID( "hl2c_nav_marker" ))
			surface.DrawTexturedRect( checkpointPositionScreen.x - 14, checkpointPositionScreen.y - 14, 28, 28 )
			draw.DrawText( tostring( checkpointDistance ).." m", "Roboto16", checkpointPositionScreen.x, checkpointPositionScreen.y + 15, Color( 255, 220, 0, 255 ), 1 )
		else
			local r = math.Round( centerX / 2 )
			local checkpointPositionRad = math.atan2( checkpointPositionScreen.y - centerY, checkpointPositionScreen.x - centerX )
			local checkpointPositionDeg = 0 - math.Round( math.deg( checkpointPositionRad ) )
			surface.SetTexture( surface.GetTextureID( "hl2c_nav_pointer" ) )
			surface.DrawTexturedRectRotated( math.cos( checkpointPositionRad ) * r + centerX, math.sin( checkpointPositionRad ) * r + centerY, 32, 32, checkpointPositionDeg + 90 )
		end
	end

	local colordifference
	if FORCE_DIFFICULTY and ContextMenu and ContextMenu:IsValid() then
		colordifference = FORCE_DIFFICULTY > 1 and Color(255, 755 - FORCE_DIFFICULTY*500, 0) or FORCE_DIFFICULTY < 1 and Color(FORCE_DIFFICULTY*1020-765, 255, 0) or Color(255, 255, 0)
		colordifference.a = 155
		draw.DrawText(Format("Map forced difficulty bonus: %s%%", FormatNumber(math.Round(FORCE_DIFFICULTY * 100, 2))), "TargetIDSmall", ScrW() / 2, ScrH() / 6 - 15, colordifference, TEXT_ALIGN_CENTER)
	end

	local diff_difference = infmath.ConvertInfNumberToNormalNumber(self.DifficultyDifference)
	local diff_difference_total = infmath.ConvertInfNumberToNormalNumber(self.DifficultyDifferenceTotal)

	if (ContextMenu and ContextMenu:IsValid()) or not hl2ce_cl_nohuddifficulty:GetBool() then
		colordifference = !hl2ce_cl_noshowdifficultychange:GetBool() and self.DifficultyDifferenceTimeChange + 3 >= CurTime() and (diff_difference < 0 and Color(255, 220-((self.DifficultyDifferenceTimeChange+3-CurTime())*110), 0) or Color(255-((self.DifficultyDifferenceTimeChange+3-CurTime())*255/2), 220, 0)) or Color(255, 220, 0)
		colordifference.a = 155

		local d = self:GetDifficulty() * 100
		local d_normal = infmath.ConvertInfNumberToNormalNumber(d)
		local s = Format(hl2ce_cl_nodifficultytext:GetBool() and "%s%%" or translate.Get("difficulty").." %s%%", FormatNumber(infmath.Round(d, 2)))
		surface.SetFont("TargetIDSmall")
		local len = surface.GetTextSize(s)
		local l = 0


		local c = d_normal >= 1e63 and HSVToColor(SysTime()*math.log10(d_normal)^1.15, 1, 1) or
			d_normal >= 1e33 and HSVToColor((math.log10(d_normal)-33)*(65*(math.log10(d_normal)-30)), 1, 1) or
			d_normal >= 1e6 and HSVToColor((math.log10(d_normal)-6)*(13+1/3), 1, 1) or
			colordifference

		c.a = colordifference.a
		if d >= InfNumber(math.huge) then
			-- I know it's unoptimal, but frick it
			local max = d.exponent == math.huge and 1e4 or math.log10(d:log10()+100)
			local max2 = d.exponent == math.huge and 1e4 or math.log10(d:log10())-2
			for i=1,utf8.len(s) do
				local r = math.Rand(0.5, 1)
				c = HSVToColor((SysTime()*(60+max*10) + (
					d:log10() > 6969 and -math.sin(l/5)*10*max2 or l/(3/math.max(1, (d:log10()-308)^0.8/100))
			))%360, d:log10() > 1e6 and 0.8+math.sin(SysTime()*0.6+l/5)/5 or 1,
			d:log10() > 1e9 and 0.8+math.sin(SysTime()+l/5)/5 or 1)

				local _ch = utf8.sub(s, i, i)
				draw.DrawText(_ch, "TargetIDSmall", ScrW() / 2 - len/2 + l, ScrH() / 6, c, TEXT_ALIGN_LEFT)
				l = l + surface.GetTextSize(_ch)
			end
		else
			draw.DrawText(s, "TargetIDSmall", ScrW() / 2 - len/2 + l, ScrH() / 6, c, TEXT_ALIGN_LEFT )
		end

		if (ContextMenu and ContextMenu:IsValid()) and self:GetEffectiveDifficulty(pl):log10() ~= (d/100):log10() then
			draw.DrawText(Format("(Effective: %s%%)", FormatNumber(self:GetEffectiveDifficulty(pl)*100)), "TargetIDSmall", ScrW() / 2, ScrH() / 6 - 15, c, TEXT_ALIGN_CENTER)
		end

		if !hl2ce_cl_noshowdifficultychange:GetBool() and self.DifficultyDifferenceTimeChange + 3 >= CurTime() and self.DifficultyDifference ~= 0 then
			colordifference.a = (self.DifficultyDifferenceTimeChange+3-CurTime())*155/3
			draw.DrawText(Format("%s%s%%", diff_difference < 0 and "-" or "+", FormatNumber(infmath.abs(infmath.Round(self.DifficultyDifference * 100, 2)))), "TargetIDSmall", ScrW() / 2, ScrH() / 6 + 15, colordifference, TEXT_ALIGN_CENTER )

			if self.DifficultyDifference ~= self.DifficultyDifferenceTotal and infmath.ConvertInfNumberToNormalNumber(self.DifficultyDifferenceTotal) ~= 0 then
				colordifference = self.DifficultyDifferenceTimeChange + 3 >= CurTime() and (diff_difference_total < 0 and Color(255, 220-((self.DifficultyDifferenceTimeChange+3-CurTime())*110), 0, colordifference.a) or Color(255-((self.DifficultyDifferenceTimeChange+3-CurTime())*255/2), 220, 0, colordifference.a)) or Color(255, 220, 0, colordifference.a)
				draw.DrawText(Format("%s%s%% total", diff_difference_total < 0 and "-" or "+", FormatNumber(infmath.abs(infmath.Round(self.DifficultyDifferenceTotal * 100, 2)))), "TargetIDSmall", ScrW() / 2, ScrH() / 6 + 30, colordifference, TEXT_ALIGN_CENTER )
			end
		end
	end
	if !ContextMenu or !ContextMenu:IsVisible() then
		if hl2ce_cl_showmaptimer:GetBool() then
			draw.DrawText(string.format("Time spent: %s", string.ToMinutesSeconds(CurTime() - (pl.startTime or 0))), "hl2ce_font_small", ScrW()/2, ScrH()*0.1, Color(255,255,100), TEXT_ALIGN_CENTER)
		end
	end

	if pl:Alive() and pl:IsSuitEquipped() and not hl2ce_cl_nocustomhud:GetBool() then
		local hp,ap = pl:Health(),pl:Armor()
		local mhp,map = pl:GetMaxHealth(), pl:GetMaxArmor()

		draw.DrawText(translate_Get("health")..string.format(" %s/%s (%d%%)", pl:Health(), pl:GetMaxHealth(), 100 * hp/mhp), "TargetIDSmall", 16, ScrH()-100, Color(255,155,155,255), TEXT_ALIGN_LEFT)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(15, ScrH() - 80, 200, 10)
		surface.SetDrawColor(205, 25, 25, 255)
		surface.DrawRect(16, ScrH() - 79, 198*math.Clamp(hp/mhp,0,1), 10)

		draw.DrawText(translate_Get("armor")..string.format(" %s/%s (%d%%)", pl:Armor(), pl:GetMaxArmor(), 100 * ap/map), "TargetIDSmall", 16, ScrH()-60, Color(155,155,255,255), TEXT_ALIGN_LEFT)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(15, ScrH() - 40, 200, 10)
		surface.SetDrawColor(25, 25, 205, 255)
		surface.DrawRect(16, ScrH() - 39, 198*math.Clamp(ap/map,0,1), 10)
	end


	local boss = GAMEMODE.EnemyBoss
	if boss and IsValid(boss) then
		local hp,mhp = boss:Health(),boss:GetMaxHealth()

		surface.SetDrawColor(255, 0, 0, 155)
		surface.DrawRect(ScrW()/2 - ScrW()/3.5, ScrH()*0.1, ScrW()/3.5*2 * math.min(1, bosshp/mhp), ScrH()*0.05)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(ScrW()/2 - ScrW()/3.5, ScrH()*0.1, ScrW()/3.5*2, ScrH()*0.05)

		draw.SimpleText(language.GetPhrase(boss:GetClass()), "TargetID", ScrW()/2, ScrH()*0.115, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if hp > 0 then
			draw.SimpleText(string.format("%s/%s", math.ceil(hp), math.ceil(mhp)), "TargetID", ScrW()/2, ScrH()*0.135, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("DEAD!", "TargetID", ScrW()/2, ScrH()*0.14, Color(255,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		bosshp = math.Approach(bosshp, hp, (hp-bosshp)*math.Round(FrameTime()*2, 3))
	end

	
	-- Are we going to the next map?
	if nextMapCountdownStart then
		local nextMapCountdownLeft = math.Round( nextMapCountdownStart + NEXT_MAP_TIME - CurTime() )
		draw.SimpleTextOutlined(nextMapCountdownLeft > 0 and "Next Map in "..tostring(nextMapCountdownLeft) or "Switching Maps!", "roboto32BlackItalic", centerX, h - h * 0.075, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0, 255 ) )
	end

	-- Are we restarting the map?
	if restartMapCountdownStart then
		local restartMapCountdownLeft = math.ceil( restartMapCountdownStart + RESTART_MAP_TIME - CurTime() )
		draw.SimpleTextOutlined(restartMapCountdownLeft > 0 and "Restarting Map in "..tostring(restartMapCountdownLeft) or "Restarting Map!", "roboto32BlackItalic", centerX, h - h * 0.075, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0, 255 ) )
	end

	-- On top of it all
	hook.Run("DrawDeathNotice", 0.85, 0.04)
end

function GM:HUDPaintBackground()
	local pl = LocalPlayer()

	if !self.PlayerDeadAlpha or pl:Alive() or pl:Health() > 0 or pl:GetObserverMode() ~= OBS_MODE_NONE then
		self.PlayerDeadAlpha = 0
	else
		self.PlayerDeadAlpha = math.min(120, self.PlayerDeadAlpha+300*FrameTime())
	end

	if self.PlayerDeadAlpha > 0 then
		surface.SetDrawColor(255, 0, 0, self.PlayerDeadAlpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end


function GM:PostDrawHUD()
	cam.Start2D()
	-- draw.SimpleText(self.Name.." "..self.Version, "TargetIDSmall", 5, 5, Color(255,255,192,25))
	if self:HardcoreEnabled() then
		draw.SimpleText("Hardcore enabled!", "TargetIDSmall", 5, 5, Color(255,0,0,150))
	end
	surface.SetDrawColor(0, 0, 0, 0)

	if hl2ce_cl_drawxpgaintext:GetBool() and XPColor > 0 then
		draw.SimpleText(tostring(infmath.Round(XPGained, 2)).." XP gained", "TargetID", ScrW() / 2 + 15, (ScrH() / 2) + 15, Color(255,255,255,XPColor), 0, 1 )
		if XPGainedTotal ~= XPGained then
			draw.SimpleText("("..tostring(infmath.Round(XPGainedTotal, 2)).." XP gained total)", "TargetIDSmall", ScrW() / 2 + 15, (ScrH() / 2) + 30, Color(255,255,205,XPColor), 0, 1 )
		end
	else
		XPGained = InfNumber(0)
		XPGainedTotal = InfNumber(0)
	end

	XPColor = math.max(0, XPColor - 90*FrameTime())
	cam.End2D()
end


-- Called every frame
function GM:HUDShouldDraw(name)
	local pl = LocalPlayer()
	if IsValid(pl) then
		if self.ShowScoreboard && (pl:Team() != TEAM_DEAD) then
			return false
		end
	
		local wep = pl:GetActiveWeapon()
		if IsValid(wep) && (wep.HUDShouldDraw != nil) then
			return wep.HUDShouldDraw( wep, name )
		end

		if !pl:Alive() and name == "CHudDamageIndicator" then
			return false
		end

		if (name == "CHudHealth" or name == "CHudBattery") and not hl2ce_cl_nocustomhud:GetBool() then
			return false
		end
	end

	return true
end


local function BetterScreenScale()
	return ScrH()/1080
end

local function CreateFont(id, size, tbl)
	tbl = tbl or {}
	tbl.size = size*BetterScreenScale()
	surface.CreateFont(id, tbl)
end
function GM:CreateFonts()
	CreateFont("Roboto16", 16, {weight = 700, antialias = true, additive = false, font = "Roboto Bold"})
	CreateFont("roboto32BlackItalic", 32, {weight = 900, antialias = true, additive = false, font = "Roboto Black Italic"})
	CreateFont("hl2ce_font_small", 20, {weight = 0, font = "Roboto Black"})
	CreateFont("hl2ce_font", 32, {weight = 700, font = "Roboto Black"})
	CreateFont("hl2ce_font_big", 48, {weight = 900, font = "Roboto Black"})
end

function GM:CreateScoreboardFonts(large)
	CreateFont("hl2ce_font_sb", large and 18 or 16, {weight = 700, font = "Roboto Black"})
	CreateFont("hl2ce_font_sb_small", large and 16 or 12, {weight = 500, font = "Roboto Black"})
end

function GM:OnScreenSizeChanged(oldw, oldh, neww, newh)
	self:CreateFonts()
	self:CreateScoreboardFonts(player.GetCount() < 10)
end

-- Called when we initialize
function GM:Initialize()

	-- Initial variables for client
	self.ShowScoreboard = false
	self.EXMode = self.EnableEXMode
	self.HyperEXMode = self.EnableHyperEXMode

	self.MapVars = {}
	self.MapVarsPersisting = {}
	if InitMapVars then
		InitMapVars(GAMEMODE.MapVars, GAMEMODE.MapVarsPersisting)
	end

	showNav = false
	scoreboard = nil

	-- Fonts we will need later
	-- surface.CreateFont( "Roboto16", { size = 16, weight = 400, antialias = true, additive = false, font = "Roboto" } )
	self:CreateFonts()
	self:CreateScoreboardFonts(player.GetCount() < 10)


	-- Language
	language.Add( "worldspawn", "World" )
	language.Add( "func_door_rotating", "Door" )
	language.Add( "func_door", "Door" )
	language.Add( "phys_magnet", "Magnet" )
	language.Add( "trigger_hurt", "Trigger Hurt" )
	language.Add( "entityflame", "Fire" )
	language.Add( "env_explosion", "Explosion" )
	language.Add( "env_fire", "Fire" )
	language.Add( "func_tracktrain", "Train" )
	language.Add( "npc_launcher", "Headcrab Pod" )
	language.Add( "func_tank", "Mounted Turret" )
	language.Add( "npc_helicopter", "Helicopter" )
	language.Add( "npc_bullseye", "Turret" )
	language.Add( "prop_vehicle_apc", "APC" )
	language.Add( "item_healthkit", "Health Kit" )
	language.Add( "item_healthvial", "Health Vial" )
	language.Add( "combine_mine", "Mine" )
	language.Add( "npc_grenade_frag", "Grenade" )
	language.Add( "npc_metropolice", "Civil Protection" )
	language.Add( "npc_combine_s", "Combine Soldier" )
	language.Add( "npc_strider", "Strider" )

	-- Run this command for a more HL2 style radiosity
	RunConsoleCommand( "r_radiosity", "4" )

end

function GM:InitPostEntity()
	local ply = LocalPlayer()

	if !file.Exists(self.VaultFolder.."/client/shown_help.txt", "DATA") then
		ShowHelp()
		file.Write(self.VaultFolder.."/client/shown_help.txt", "You've viewed the help menu in Half-Life 2 Campaign.")
	end

	net.Start("hl2c_playerready")
	net.SendToServer()
	self:PlayerReady()
end

function GM:PlayerReady()
	local ply = LocalPlayer()

	ply.XP = InfNumber(0)
	ply.Level = InfNumber(0)
	ply.StatPoints = InfNumber(0)
	ply.Prestige = InfNumber(0)
	ply.PrestigePoints = InfNumber(0)
	ply.Eternities = InfNumber(0)
	ply.EternityPoints = InfNumber(0)

	-- Endless
	ply.Celestiality = InfNumber(0)
	ply.CelestialityPoints = InfNumber(0)
	ply.Rebirths = InfNumber(0)
	ply.RebirthPoints = InfNumber(0)


	ply.Moneys = InfNumber(0)
	ply.Skills = {}


	ply.UnlockedPerks = {}
	ply.DisabledPerks = {}
	ply.EternityUpgradeValues = {}

	for upgrade,_ in pairs(self.UpgradesEternity) do
		ply.EternityUpgradeValues[upgrade] = 0
	end
end

function GM:SpawnMenuEnabled()
	return true
end

function GM:SpawnMenuOpen()
	return true
end

function GM:ContextMenuOpen()
	return true
end

-- Called when a bind is pressed
function GM:PlayerBindPress(ply, bind, down)
	if !GAMEMODE.AdminMode and bind == "+menu" and down then
		RunConsoleCommand("lastinv")
		return true
	end

	if bind == "gm_showhelp" then
		ShowHelp()
	elseif bind == "gm_showteam" then
		if ply:IsAdmin() and input.IsKeyDown(KEY_R) then
			self:OpenAdminMenu()
		else
			ShowTeam()
		end
	end

	return false
end


-- Called when a player sends a chat message
function GM:OnPlayerChat( ply, text, team, dead )
	local tab = {}
	if dead or (IsValid(ply) and ply:Team() == TEAM_DEAD) then
		table.insert(tab, Color(191, 30, 40))
		table.insert(tab, "*"..translate.Get("dead").."* ")
	end

	if team then
		table.insert(tab, Color(30, 160, 40))
		table.insert(tab, "("..translate.Get("team")..") ")
	end

/*
	if ply:SteamID64() == "76561198274314803" then
		table.insert(tab, Color(160,160,160))
		table.insert(tab, "[")
		table.insert(tab, Color(224,224,160))
		table.insert(tab, "Hl2c EX coder")
		table.insert(tab, Color(160,160,160))
		table.insert(tab, "] ")
	end
*/

	if IsValid(ply) then
		table.insert(tab, ply)
	else
		table.insert(tab, "Console")
	end

	table.insert(tab, Color(255, 255, 255))
	table.insert(tab, ": "..text)

	chat.AddText(unpack(tab))
	return true
end


-- Called when going to the next map
function NextMap(len)

	nextMapCountdownStart = net.ReadFloat()

end
net.Receive("NextMap", NextMap)


-- Called when restarting maps
function RestartMap(len)
	restartMapCountdownStart = net.ReadFloat()
	if restartMapCountdownStart == -1 then
		restartMapCountdownStart = nil

		-- when map restarts i guess
		gamemode.Call("OnMapRestart")

		GAMEMODE.EXMode = GAMEMODE.EnableEXMode
		GAMEMODE.HyperEXMode = GAMEMODE.EnableHyperEXMode

		GAMEMODE.MapVars = {}
		if GAMEMODE.MapVarsPersisting == nil then
			GAMEMODE.MapVarsPersisting = {}
		end
		if InitMapVars then
			InitMapVars(GAMEMODE.MapVars, GAMEMODE.MapVarsPersisting)
		end

		gamemode.Call("PostOnMapRestart")
	end

	if GetGlobalString("losemusic") then
		local sound = CreateSound(LocalPlayer(), GetGlobalString("losemusic", ""))
		sound:Play()
	end
end
net.Receive("RestartMap", RestartMap)

function GM:OnMapRestart()
end

function GM:PostOnMapRestart()
end

function GM:OnMapCompleted()
end

function GM:OnCampaignCompleted()
end

function GM:PostOnMapCompleted()
end

function GM:PostOnCampaignCompleted()
end


if file.Exists(GM.VaultFolder.."/gamemode/maps/"..game.GetMap()..".lua", "LUA") then
	include("maps/"..game.GetMap()..".lua")
end

-- Called by show help
function ShowHelp()
	local pl = LocalPlayer()

	local helpMenu = vgui.Create("DFrame")
	GAMEMODE.HelpMenu = helpMenu
	helpMenu:SetTitle("Welcome")
	helpMenu:SetDraggable(false)
	helpMenu:SetSize(ScrW(), ScrH())
	helpMenu.Paint = function(self,w,h)
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(0, 0, w, h)
	end
	helpMenu:Center()
	helpMenu:MakePopup()

	local list = vgui.Create("DPanelList", helpMenu) -- i ain't using other panels, despite this one being deprecated.
	list:SetSize(1000, 700)
	list:SetSpacing(12)
	list:Center()
	list.Paint = function() end
	list:EnableVerticalScrollbar()


	local text = vgui.Create("DLabel", list)
	text:SetText([[-= ABOUT THIS GAMEMODE =-
Welcome to Half-Life 2 Campaign Eternal!
This gamemode is based on Half-Life 2 Campaign made by Jai 'Choccy' Fox!
Expanded by Uklejamini]])
	text:SetTextColor(Color(255,255,255))
	text:SetContentAlignment(5)
	text:SizeToContents()
	text:SetWrap(true)
	list:AddItem(text)

	local text = vgui.Create("DLabel", list)
	text:SetText([[-= KEYBOARD SHORTCUTS =-
[F1] (Show Help) - Opens this menu.
[F2] (Show Team) - Toggles the navigation marker on your HUD.
[F3] (Spare 1) - Spawns a vehicle if allowed.
[F4] (Spare 2) - Removes a vehicle if you have one.]])
	text:SetTextColor(Color(255,255,155))
	text:SetContentAlignment(5)
	text:SizeToContents()
	text:SetWrap(true)
	list:AddItem(text)

	local text = vgui.Create("DLabel", list)
	text:SetText([[-= OTHER NOTES =-
Once you're dead you cannot respawn until the next map.]])
	text:SetTextColor(Color(155,155,255))
	text:SetContentAlignment(5)
	text:SizeToContents()
	text:SetWrap(true)
	list:AddItem(text)

	if GAMEMODE.EnableHardcoreMode then
		local text = vgui.Create("DLabel", list)
		text:SetText([[Hardcore Mode has been enabled. You only have one life per run! Play carefully...]])
		text:SetColor(Color(255,0,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[Hardcore Mode adds a new way of playing Half-Life 2 by restricting you to only having one life per run.
This is similar to Roguelite/Roguelike games and Hardcore minecraft!]])
		text:SetColor(Color(255,110,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[---- Rules of the run ----
If you die, you cannot respawn anymore even on upcoming maps!
If you fail the map, you must restart your run back at the first map.
If you have joined late, you cannot participate in this run anymore.
Dead players can still spectate.
Connecting players are given 30 seconds to load in order to catch up before the run is failable by the lack of alive players.]])
		text:SetColor(Color(255,170,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[As usual, this is in beta stage. Some things may not work correctly.]])
		text:SetColor(Color(255,140,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)
	end

	if GAMEMODE.EXMode then
		local text = vgui.Create("DLabel", list)
		text:SetText([[EX Mode has been enabled. Good luck.]])
		text:SetColor(Color(255,0,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText("What is EX Mode?")
		text:SetColor(Color(255,160,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[EX mode is a (not so) new mode added in Hl2c Eternal.
In this new mode, you should expect new map gimnicks, various npc variants, and more overall chaos.
Experience Half-Life 2 in a new, and twisted way!]])
		text:SetColor(Color(255,110,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)
	end

	if GAMEMODE.HyperEXMode then
		local text = vgui.Create("DLabel", list)
		text:SetText([[HyperEXMode engaged. WTF IS WRONG WITH YOU?!]])
		text:SetColor(Color(255,0,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[HyperEX mode is one of the sequels to the EX mode.
It's much more insane than the regular EX mode.]])
		text:SetColor(Color(255,110,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)

		local text = vgui.Create("DLabel", list)
		text:SetText([[OH MY GOD WE'RE DOOMED!!!!!!]])
		text:SetColor(Color(190,0,0))
		text:SetContentAlignment(5)
		text:SizeToContents()
		text:SetWrap(true)
		list:AddItem(text)
	end

	local adminbutton
	if pl:IsValid() and pl:IsAdmin() then
		adminbutton = vgui.Create("DButton", list)
	end

	if adminbutton and adminbutton:IsValid() then
		adminbutton:SetSize(120, 20)
		adminbutton:SetText("Admin Mode")
		adminbutton:SetTextColor(Color(0,0,255))
		adminbutton.DoClick = function()
			GAMEMODE.AdminMode = !GAMEMODE.AdminMode

			chat.AddText(GAMEMODE.AdminMode and "enabled" or "disabled")

			helpMenu:Remove()
		end
		adminbutton.Paint = function(self, width, height)
			surface.SetDrawColor(Color(0,0,155,100))
			surface.DrawRect(0, 0, width, height)
		end
		list:AddItem(adminbutton)
		adminbutton:Dock(BOTTOM)
		adminbutton:DockMargin(400, 0, 400, 0)
	end

end

function GM:ShowSkills()
	local pl = LocalPlayer()
	local skillsMenu = vgui.Create("DFrame")
	local skillsPanel = vgui.Create("DPanel", skillsMenu)
	local skillsText = vgui.Create("DLabel", skillsPanel)
	local skillsText2 = vgui.Create("DLabel", skillsPanel)
	local skillsText3 = vgui.Create("DLabel", skillsPanel)
	local skillsForm = vgui.Create("DPanelList", skillsPanel)

	skillsText:SetText("Unspent skill points: "..tostring(infmath.floor(pl.StatPoints)))
	skillsText:SetTextColor(color_black)
	skillsText:SetPos(5, 5)
	skillsText:SizeToContents()
	skillsText.Think = function(this)
		local txt = "Unspent skill points: "..tostring(infmath.floor(pl.StatPoints))
		if txt == this:GetText() then return end
		this:SetText(txt)
		this:SizeToContents()
	end

	skillsText2:SetText("Right click to spend a desired amount of SP on a skill")
	skillsText2:SetTextColor(color_black)
	skillsText2:SetPos(5, 20)
	skillsText2:SizeToContents()

	skillsText3:SetText("Click while holding SHIFT to spend all SP on desired skill")
	skillsText3:SetTextColor(color_black)
	skillsText3:SetPos(5, 35)
	skillsText3:SizeToContents()

	skillsMenu:SetSize(293, 263)

	skillsPanel:StretchToParent( 5, 28, 5, 5 )

	skillsMenu:SetTitle("Your skills")
	skillsMenu:Center()
	skillsMenu:MakePopup()
	skillsMenu.Think = function(this)
		if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
			timer.Simple(0, function()
				this:Remove()
			end)
			gui.HideGameUI()
		end
	end

	skillsForm:SetSize(278, 175)
	skillsForm:SetPos(5, 50)
	skillsForm:EnableVerticalScrollbar(true)
	skillsForm:SetSpacing(8) 
	skillsForm:SetName("")
	skillsForm.Paint = function() end

	local function DoStatsList()
		for k, v in SortedPairs(self.SkillsInfo) do
			local name = translate_Get(v.Name)
			local d = translate_Get(v.Description)
			local de = translate_Get(v.DescriptionEndless)

			local formatted = name.."\n\n"..translate_Get("in_ne_mode").."\n"..d..(de and "\n\n"..translate_Get("in_e_mode").."\n"..de or "")
			local LabelDefense = vgui.Create("DLabel")
			LabelDefense:SetPos(50, 50)
			LabelDefense:SetText(name..": "..tostring(pl.Skills[k]))
			LabelDefense:SetTextColor(color_black)
			LabelDefense:SetToolTip(formatted)
			LabelDefense:SizeToContents()
			LabelDefense.Think = function(this)
				local txt = name..": "..tostring(pl.Skills[k])
				if txt == this:GetText() then return end
				this:SetText(txt)
				this:SizeToContents()
			end
			skillsForm:AddItem(LabelDefense)

			local Button = vgui.Create("DButton")
			Button:SetPos(50, 100)
			Button:SetSize(15, 20)
			Button:SetTextColor(color_black)
			Button:SetText(translate_Format("inc_sk", name, 1))
			Button:SetToolTip(formatted)
			Button.DoClick = function(Button)
				net.Start("hl2ce_upgperk")
				net.WriteString(k)
				net.WriteUInt(input.IsShiftDown() and 1e6 or 1, 32)
				net.SendToServer()
			end
			Button.DoDoubleClick = Button.DoClick
			Button.DoRightClick = function()
				Derma_StringRequest("Enter desired SP to apply on a skill", "", 1, function(str)
					net.Start("hl2ce_upgperk")
					net.WriteString(k)
					net.WriteUInt(input.IsShiftDown() and 1e6 or 1, 32)
					net.SendToServer()
				end, nil, "Apply", "Cancel")
			end
			skillsForm:AddItem(Button)
		end
	end
	DoStatsList()
end


-- Called by client pressing -score
function GM:ScoreboardHide()
	self.ShowScoreboard = false

	if scoreboard and scoreboard:IsValid() then	
		scoreboard:SetVisible(false)
	end

	gui.EnableScreenClicker(false)
end


-- Called by client pressing +score
function GM:ScoreboardShow()
	if game.SinglePlayer() then return end

	self.ShowScoreboard = true

	if !scoreboard or !scoreboard:IsValid() then
		self:CreateScoreboard()
	end
	if scoreboard.CurPlayers ~= player.GetCount() then
		self:CreateScoreboardFonts(player.GetCount() < 10)
		scoreboard.CurPlayers = player.GetCount()
	end

	scoreboard:SetVisible(true)
	scoreboard:UpdateScoreboard(true)

	gui.EnableScreenClicker(true)
end

function GM:OnReloaded()
	timer.Simple(0, function()
		net.Start("hl2c_updatestats")
		net.WriteString("reloadstats")
		net.SendToServer()
	end)
end

-- Called when the player is drawn
function GM:PostPlayerDraw( ply )

	if ( showNav && IsValid( ply ) && ply:Alive() && ( ply:Team() == TEAM_ALIVE ) && ( ply != LocalPlayer() ) ) then
	
		local bonePosition = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) || 0 ) + Vector( 0, 0, 16 )
		cam.Start2D()
			draw.SimpleText( ply:Name().." ("..ply:Health().."%)", "TargetIDSmall", bonePosition:ToScreen().x, bonePosition:ToScreen().y, self:GetTeamColor( ply ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		cam.End2D()
	
	end

end


-- Called by ShowTeam
function ShowTeam()
	showNav = !showNav
end


-- Called by server
function SetCheckpointPosition( len )

	checkpointPosition = net.ReadVector()

end
net.Receive("SetCheckpointPosition", SetCheckpointPosition )


local function SpawnMenuOpen(self)
	if ( !hook.Call( "SpawnMenuOpen", self ) ) then return end

	if ( IsValid( g_SpawnMenu ) ) then
		g_SpawnMenu:Open()
		menubar.ParentTo( g_SpawnMenu )
	end

	hook.Call( "SpawnMenuOpened", self )

end

local function SpawnMenuClose(self)
	if ( IsValid( g_SpawnMenu ) ) then g_SpawnMenu:Close() end
	hook.Call( "SpawnMenuClosed", self )
end

local function ContextMenuOpen(self)
	if ( !hook.Call( "ContextMenuOpen", self ) ) then return end

	if ( IsValid( g_ContextMenu ) && !g_ContextMenu:IsVisible() ) then
		g_ContextMenu:Open()
		menubar.ParentTo( g_ContextMenu )
	end
	
	hook.Call( "ContextMenuOpened", self )
end

local function ContextMenuClose(self)
	if ( IsValid( g_ContextMenu ) ) then g_ContextMenu:Close() end
	hook.Call( "ContextMenuClosed", self )
end

function GM:OnSpawnMenuOpen()
	local pl = LocalPlayer()
	if self.AdminMode then
		SpawnMenuOpen(self)
	end
end

function GM:OnSpawnMenuClose()
	local pl = LocalPlayer()
	if self.AdminMode then
		SpawnMenuClose(self)
	end
end



function GM:OnContextMenuOpen()
	if self.AdminMode then
		ContextMenuOpen(self)
	else
		self:CMenu()
	end
end

function GM:OnContextMenuClose()
	
	if self.AdminMode then
		ContextMenuClose(self)
	elseif ContextMenu and ContextMenu:IsValid() then
		ContextMenu:Close()
	end
end


