
function GM:MakeOptions()
	
	local Window = vgui.Create("DFrame")
	local wide,tall = math.min(ScrW(), 400), math.min(ScrH(), 440)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle("Options")
	Window:SetVisible(true)
	Window:SetDraggable(false)
	Window:SetDeleteOnClose(false)
	Window:MakePopup()

	local list = vgui.Create("DPanelList", Window)
	list:EnableVerticalScrollbar()
	list:EnableHorizontal(false)
	list:SetSize(wide - 24, tall - 20)
	list:SetPos(12, 24)
	list:SetPadding(8)
	list:SetSpacing(4)


	local function CreateCheck(name, cvar)
		local convar = GetConVar(cvar)
		local check = vgui.Create("DCheckBoxLabel", Window)
		check:SetText(name)
		check:SetTextColor(Color(190,255,220))
		check:SetConVar(cvar)
		check:SetToolTip(convar and convar:GetHelpText() or "")
		check:SizeToContents()
		list:AddItem(check)

		return check
	end

	CreateCheck("Enable first person death view", "hl2ce_cl_fpdeath")
	CreateCheck("Enable free view in first person death", "hl2ce_cl_fpdeath_freeview")
	CreateCheck("Enable classic HL2 first person death", "hl2ce_cl_fpdeath_classic")
	CreateCheck("Disable Tinnitus/Earringing", "hl2ce_cl_noearringing")
	CreateCheck("Don't show Difficulty on HUD", "hl2ce_cl_nohuddifficulty")
	CreateCheck("Shorten difficulty text display", "hl2ce_cl_nodifficultytext")
	CreateCheck("Disable difficulty change visuals", "hl2ce_cl_noshowdifficultychange")
	CreateCheck("Disable Custom HUD", "hl2ce_cl_nocustomhud")
	CreateCheck("Draw XP gain text", "hl2ce_cl_drawxpgaintext")
	CreateCheck("Disable player death sounds", "hl2ce_cl_noplrdeathsound")
	CreateCheck("Show time spent on map", "hl2ce_cl_showmaptimer")

	CreateCheck("Disable flashing lights", "hl2ce_cl_noepilepsy")
end
