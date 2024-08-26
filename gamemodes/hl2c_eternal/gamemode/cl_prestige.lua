local function FirstPrestige()
	local pl = LocalPlayer()
	local snd = CreateSound(pl, "music/hl2_song10.mp3")
	snd:PlayEx(1, 65)

	local textsize_x,textsize_y
	local ui = vgui.Create("DPanel")
	ui:SetPos(0,0)
	ui:SetSize(ScrW(),ScrH())
	ui:SetMouseInputEnabled(false)
	ui.Paint = function() end


	local text1 = vgui.Create("DLabel", ui)
	text1:SetFont("TargetIDSmall")
	text1:SetText("Ah a fellow player.")
	text1:SetAlpha(0)
	text1:AlphaTo(255, 3, 1.5)
	text1:SizeToContents()
	textsize_x,textsize_y = text1:GetSize()
	text1:SetPos(ScrW()/2 - textsize_x/2, 110)

	local text2 = vgui.Create("DLabel", ui)
	text2:SetFont("TargetIDSmall")
	text2:SetText("Congratulations on Prestiging.")
	text2:SetAlpha(0)
	text2:AlphaTo(255, 3, 2.5)
	text2:SizeToContents()
	textsize_x,textsize_y = text2:GetSize()
	text2:SetPos(ScrW()/2 - textsize_x/2, 190)

	local text3 = vgui.Create("DLabel", ui)
	text3:SetFont("TargetIDSmall")
	text3:SetText("You seem to start understanding the mechanics of this gamemode.")
	text3:SetAlpha(0)
	text3:AlphaTo(255, 3, 5)
	text3:SizeToContents()
	textsize_x,textsize_y = text3:GetSize()
	text3:SetPos(ScrW()/2 - textsize_x/2, 270)

	local text4 = vgui.Create("DLabel", ui)
	text4:SetFont("TargetIDSmall")
	text4:SetText(pl:Nick().."? That's a nice name.")
	text4:SetAlpha(0)
	text4:AlphaTo(255, 3, 8.5)
	text4:SizeToContents()
	textsize_x,textsize_y = text4:GetSize()
	text4:SetPos(ScrW()/2 - textsize_x/2, ScrH() / 1.5)

	local text5 = vgui.Create("DLabel", ui)
	text5:SetFont("TargetIDSmall")
	text5:SetText("Our name is...")
	text5:SetAlpha(0)
	text5:AlphaTo(255, 5, 12.5)
	text5:SizeToContents()
	textsize_x,textsize_y = text5:GetSize()
	text5:SetPos(ScrW()/2 - textsize_x/2, ScrH() / 1.5 + 60)

	local ct = CurTime()
	hook.Add("PreDrawHUD", "hl2ce_firstprestige", function()
		cam.Start2D()
		surface.SetDrawColor(255, 255, 255, 255-(CurTime() - ct)*10)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	end)
	timer.Simple(16, function()
		ui:Remove()
		hook.Remove("PreDrawHUD", "hl2ce_firstprestige")
		snd:Stop()

		chat.AddText("Gordon! We got no time to lose! We must keep on going!")
		chat.AddText(Color(0,255,0), "Perks unlocked.")
		chat.AddText(Color(0,255,0), "Each level up awards you with 2 skill points and skills max level increased to 35.")
	end)
end



net.Receive("hl2ce_firstprestige", function(len)
	local str = net.ReadString()

	if str == "prestige" then
		FirstPrestige()
	end
end)