-- wip lol

local function NewButton(pnl, text, func)
	local pnl = vgui.Create("DButton", pnl)
	pnl:SetText(text)
	pnl:SetFont("hl2ce_font")
	pnl:SizeToContents()
	pnl.DoClick = func
	pnl.Paint = function(self, w, h)
		if self:IsHovered() then
			surface.SetDrawColor(255, 255, 0, 155)
		else
			surface.SetDrawColor(0, 0, 0, 155)
		end
		surface.DrawRect(0, 0, w, h)
	end

	return pnl
end

local function InitializePanel(pnl, list)
	local b = NewButton(pnl, "Teleport to checkpoint...")
	list:AddItem(b)
	b.DoClick = function()
		pnl:MakeNewList(function(pnl, list)
			list:AddItem(NewButton(nil, "Spawn", function()
				net.Start("hl2ce_admin_teleport")
				net.WriteString("spawn")
				net.SendToServer()
			end))

			if TRIGGER_CHECKPOINT then
				for k,location in pairs(TRIGGER_CHECKPOINT) do
					list:AddItem(NewButton(nil, "Checkpoint #"..k, function()
						net.Start("hl2ce_admin_teleport")
						net.WriteString("checkpoint_"..k)
						net.SendToServer()
					end))
				end
			end

			if NEXT_MAP then
				list:AddItem(NewButton(nil, "End of map (to "..NEXT_MAP..")", function()
					net.Start("hl2ce_admin_teleport")
					net.WriteString("changelevel")
					net.SendToServer()
				end))
			end
		end)
	end

	local b = NewButton(pnl, "Changelevel to...")
	list:AddItem(b)
	b.DoClick = function()
		pnl:MakeNewList(function(pnl, list)
			for id,tbl in ipairs(GAMEMODE.ChaptersList) do
				local b = NewButton(nil, (tbl.Name or id).." ("..tbl.Map..")", function()
					net.Start("hl2ce_admin_changemap")
					net.WriteString(tbl.ID)
					net.SendToServer()
				end)

				if tbl.Maps then
					b:SetTextColor(Color(255,255,0))
					b.DoRightClick = function()
						pnl:MakeNewList(function(pnl, list)
							for id,map in ipairs(tbl.Maps) do
								list:AddItem(NewButton(nil, map, function()
									net.Start("hl2ce_admin_changemap")
									net.WriteString(tbl.ID)
									net.WriteString(map)
									net.SendToServer()
								end))
							end
						end)
					end
				end
				list:AddItem(b)
			end
		end)
	end

	local b = NewButton(pnl, "Force respawn")
	list:AddItem(b)
	b.DoClick = function()
		RunConsoleCommand("hl2ce_admin_respawn")
	end

	local b = NewButton(pnl, "Force Restart map")
	list:AddItem(b)
	b.DoClick = function()
		RunConsoleCommand("hl2ce_restart_map")
	end

	local b = NewButton(pnl, "Force Next map")
	list:AddItem(b)
	b.DoClick = function()
		RunConsoleCommand("hl2ce_next_map")
	end

	local b = NewButton(pnl, "Test map completion")
	b:SetTooltip("Restarts map afterwards")
	list:AddItem(b)
	b.DoClick = function()
		net.Start("hl2ce_admin_completemaptest")
		net.SendToServer()
	end

end

function GM:OpenAdminMenu()
	local pnl = vgui.Create("DFrame")
	self.AdminMenu = pnl24
	pnl:SetTitle("Admin panel")
	pnl:SetSize(ScrW(), ScrH())
	pnl.Think = function(this)
		if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
			timer.Simple(0, function()
				this:Remove()
			end)
			gui.HideGameUI()
		end
	end
	pnl.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 155)
		surface.DrawRect(0, 0, w, h)
	end
	pnl:MakePopup()
	pnl:SetKeyboardInputEnabled(false)
	pnl.MakeNewList = function(this, func)
		this.ListPnl:Clear()

		func(this, this.ListPnl)

		this.PrevFunc = this.LastFunc
		this.LastFunc = func

		local b = NewButton(pnl, "Go back", function()
			this.ListPnl:Clear()
			if this.PrevFunc then
				this.LastFunc = this.PrevFunc
				this.PrevFunc = nil
				this:MakeNewList(this.LastFunc)
				this.LastFunc = this.PrevFunc
				this.PrevFunc = nil

			else
				InitializePanel(pnl, pnl.ListPnl)
			end
		end)
		this.ListPnl:AddItem(b)
	end

	local list = vgui.Create("DPanelList", pnl)
	pnl.ListPnl = list
	list:SetSize(ScrW()*0.6, ScrH()*0.7)
	list:Center()
	list:EnableVerticalScrollbar()
	list.Paint = function(_, w, h)
		surface.SetDrawColor(0, 50, 100, 50)
		surface.DrawRect(0, 0, w, h)
	end

	local hint = vgui.Create("DLabel", pnl)
	hint:SetText("Hint: Use right-click on different-colored text to select more options!")
	hint:SetFont("hl2ce_font_small")
	hint:SetTextColor(color_white)
	hint:SizeToContents()
	hint:CenterVertical(0.08)
	hint:CenterHorizontal()

	InitializePanel(pnl, list)
end
