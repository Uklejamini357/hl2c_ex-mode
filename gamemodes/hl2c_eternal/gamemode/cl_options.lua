local function CreateLabel(parent, text, col)
	local label = vgui.Create("DLabel", parent)
	label:SetText(text)
	label:SetTextColor(col)
	label:Dock(TOP)
	label:DockMargin(1,1,1,1)

	return label
end

local function CreateCheck(parent, name, cvar)
	local convar = GetConVar(cvar)
	local check = vgui.Create("DCheckBoxLabel", parent)
	local col = Color(190,255,220)
	check:SetText(name)
	check:SetToolTip(convar and convar:GetHelpText() or "")
	if IsConCommandBlocked(cvar) then
		check:SetChecked(convar:GetBool())

		col:SetBrightness(0.8)
		check:SetToolTip((check:GetTooltip() == "" and "" or check:GetTooltip().."\n\n").."Note: This option can not be adjusted from this options menu.\nUse the console for "..cvar.." instead.")
	else
		check:SetConVar(cvar)
	end
	check:SetTextColor(col)
	check:Dock(TOP)
	check:DockMargin(1,1,1,1)

	return check
end

local function CreateDropdown(parent, name, cvar, tbl)
	local convar = GetConVar(cvar)

	local label = vgui.Create("DLabel", parent)
	label:SetText(name)
	label:SetTextColor(Color(190,255,220))
	label:Dock(TOP)
	label:DockMargin(1,1,1,1)

	local dropdown = vgui.Create("DComboBox", parent)
	local var = convar:GetString()
	local name = tbl[var]
	dropdown:SetText(var == "default" and "Default" or name or "???")
	dropdown.OnSelect = function(_, _, value)
		if value == "Default" then
			value = "default"
		elseif value == "Override current language" then
			value = "override"
		else
			for id,var in pairs(tbl) do
				if var == value then
					value = id
					break
				end
			end
		end

		RunConsoleCommand(cvar, value)
	end
	dropdown:Dock(TOP)
	dropdown:DockMargin(1,1,1,1)

	dropdown:AddChoice("Default")
	dropdown:AddChoice("Override current language")
	for id, var in pairs(tbl) do
		dropdown:AddChoice(var)
	end

	return label, dropdown
end


local function ShowClientsideOptions(parent)
	CreateCheck(parent, "Enable third person view", "hl2ce_cl_thirdperson")
	CreateCheck(parent, "Enable first person death view", "hl2ce_cl_fpdeath")
	CreateCheck(parent, "Enable free view in first person death", "hl2ce_cl_fpdeath_freeview")
	CreateCheck(parent, "Enable classic HL2 first person death", "hl2ce_cl_fpdeath_classic")
	CreateCheck(parent, "Disable Tinnitus/Earringing", "hl2ce_cl_noearringing")
	CreateCheck(parent, "Don't show Difficulty on HUD", "hl2ce_cl_nohuddifficulty")
	CreateCheck(parent, "Shorten difficulty text display", "hl2ce_cl_nodifficultytext")
	CreateCheck(parent, "Disable difficulty change visuals", "hl2ce_cl_noshowdifficultychange")
	CreateCheck(parent, "Disable Custom HUD", "hl2ce_cl_nocustomhud")
	CreateCheck(parent, "Disable HUD", "hl2ce_cl_nohud")
	CreateCheck(parent, "Disable Killfeed", "hl2ce_cl_nokillfeed")
	CreateCheck(parent, "Disable Damage numbers", "hl2ce_cl_nodmgnum")
	CreateCheck(parent, "Enable Quick info", "hud_quickinfo")
	CreateCheck(parent, "Draw XP gain text", "hl2ce_cl_drawxpgaintext")
	CreateCheck(parent, "Disable player death messages", "hl2ce_cl_noplrdeathmsg")
	CreateCheck(parent, "Disable player death sounds", "hl2ce_cl_noplrdeathsound")
	CreateCheck(parent, "Show time spent on map", "hl2ce_cl_showmaptimer")
	CreateCheck(parent, "Don't show lose screen", "hl2ce_cl_noshowlosetext")

	CreateCheck(parent, "Disable flashing lights", "hl2ce_cl_noepilepsy")

	CreateDropdown(parent, "Override current language", "hl2ce_cl_langaugeoverride", translate.Languages)
end

local function ShowServersideOptions(parent)
	CreateCheck(parent, "Enable players respawning on checkpoint", "hl2ce_server_checkpoint_respawn")
	CreateCheck(parent, "Enable Custom playermodels", "hl2ce_server_custom_playermodels")
	CreateCheck(parent, "Enable Dynamic skill level", "hl2ce_server_dynamic_skill_level")
	CreateCheck(parent, "Force HL2 gamerules", "hl2ce_server_force_gamerules")
	CreateCheck(parent, "Enable Jeep Passenger Seats", "hl2ce_server_jeep_passenger_seat")
	CreateCheck(parent, "Enable Lag Compensation", "hl2ce_server_lag_compensation")
	CreateCheck(parent, "Enable player respawning", "hl2ce_server_player_respawning")
	-- CreateCheck(parent, "hl2ce_server_player_respawntimer", "")

	CreateCheck(parent, "Enable Bunnyhopping", "hl2ce_server_bhop_enable")
	CreateCheck(parent, "Enable EX mode", "hl2ce_server_ex_mode_enabled")
	-- CreateCheck(parent, "hl2ce_server_force_difficulty", "")
	CreateCheck(parent, "Enable HARDCORE MODE (!)", "hl2ce_server_hardcore_mode_enabled")
	-- CreateCheck(parent, "hl2ce_server_npchpmul", "")
	CreateCheck(parent, "Enable players medkit", "hl2ce_server_player_medkit")
	CreateCheck(parent, "Disable players skills", "hl2ce_server_skills_disabled")

	-- CreateDropdown(parent, "", "", translate.Languages)
end

local settingsPresets = {
	["Singleplayer"] = {
		["hl2ce_cl_fpdeath"] = 1,
		["hl2ce_cl_fpdeath_freeview"] = 1,
		["hl2ce_cl_fpdeath_classic"] = 1,
		["hl2ce_cl_noearringing"] = 0,
		["hl2ce_cl_nohuddifficulty"] = 1,
		["hl2ce_cl_nocustomhud"] = 1,
		["hl2ce_cl_nohud"] = 0,
		["hl2ce_cl_nokillfeed"] = 1,
		["hl2ce_cl_nodmgnum"] = 1,
		["hud_quickinfo"] = 1,
		["hl2ce_cl_drawxpgaintext"] = 0,
		["hl2ce_cl_noplrdeathmsg"] = 1,
		["hl2ce_cl_showmaptimer"] = 0,
		["hl2ce_cl_noshowlosetext"] = 1,
	}
}

local cvarsToDefault = {
	"hl2ce_cl_noearringing",
	"hl2ce_cl_nohuddifficulty",
	"hl2ce_cl_nodifficultytext",
	"hl2ce_cl_noshowdifficultychange",
	"hl2ce_cl_nocustomhud",
	"hl2ce_cl_nohud",
	"hl2ce_cl_nokillfeed",
	"hl2ce_cl_nodmgnum",
	"hl2ce_cl_drawxpgaintext",
	"hl2ce_cl_noplrdeathmsg",
	"hl2ce_cl_noplrdeathsound",
	"hl2ce_cl_showmaptimer",
	"hl2ce_cl_noepilepsy",
	"hl2ce_cl_noshowlosetext",
}
local default = {}
for k,v in pairs(cvarsToDefault) do
	default[v] = GetConVar(v):GetDefault()
end

settingsPresets.Default = default

local function applyPreset(list, preset)
	if !preset or !settingsPresets[preset] then return end

	local prevcvars = {}
	local changedcvars = {}
	local failedchanges = {}
	for cvar,value in pairs(settingsPresets[preset]) do
		local cv = GetConVar(cvar)
		if cv then
			prevcvars[cvar] = cv:GetString()
		else
			continue
		end
		
		if cv:GetString() ~= tostring(value) then
			if !IsConCommandBlocked(cvar) then
				RunConsoleCommand(cvar, tostring(value))
			end
			changedcvars[cvar] = tostring(value)
		end
	end

	timer.Simple(0.2, function()
		for cvar,value in pairs(settingsPresets[preset]) do
			local cv = GetConVar(cvar)
			if changedcvars[cvar] and cv:GetString() ~= tostring(value) and prevcvars[cvar] ~= cv:GetString() then
				failedchanges[#failedchanges+1] = cvar
			end
		end

		if #failedchanges > 0 then
			chat.AddText(Color(255,240,0), "WARNING", color_white, ": Some settings failed to apply, check console for more details!!")
			for i=1,#failedchanges do
				local cvar = failedchanges[i]
				print(cvar, "is", prevcvars[cvar], "should have been", changedcvars[cvar], "!")
				if IsConCommandBlocked(cvar) then
					print("Use \""..cvar.." "..changedcvars[cvar].."\" in console instead to apply this setting!")
				end
			end
		end
	end)

	chat.AddText("Preset applied!")
end

function GM:MakeOptions()
	local pl = LocalPlayer()

	local Window = vgui.Create("DFrame")
	local wide,tall = math.min(ScrW(), 400), math.min(ScrH(), 440)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("Options")
	Window:SetVisible(true)
	-- Window:SetDraggable(false)
	-- Window:SetDeleteOnClose(true)
	Window:MakePopup()
	Window:SetKeyBoardInputEnabled(false)
	Window.OnRemove = function(self)
		hook.Remove("OnPauseMenuShow", self)
	end
	hook.Add("OnPauseMenuShow", Window, function()
		if Window and Window:IsValid() then
			Window:Remove()
			return false
		end
	end)


	local list = vgui.Create("DScrollPanel", Window)
	list:Dock(FILL)



	if game.SinglePlayer() then
		CreateLabel(list, "Clientside options", Color(255,220,120))
	end
	ShowClientsideOptions(list)
	if game.SinglePlayer() then
		CreateLabel(list, "Serverside options", Color(120,120,240))
		ShowServersideOptions(list)
	end

	local btn = vgui.Create("DButton", list)
	btn:SetText("Pick recommended settings (Presets)")
	btn:Dock(TOP)
	btn.DoClick = function()
		local d = DermaMenu(true, Window)
		for name in SortedPairs(settingsPresets) do
			d:AddOption(name, function() applyPreset(list, name) end)
		end
		d:AddOption("^ Placeholder presets only", function()
			chat.AddText("This one doesn't even do anything!!")
		end)
		d:Open()
	end
end
