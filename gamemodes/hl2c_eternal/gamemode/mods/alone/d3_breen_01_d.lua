INFO_PLAYER_SPAWN = {Vector(-2489, -1292, 580), 90}



hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	GAMEMODE.CampaignMapVars.SongStart = GAMEMODE.CampaignMapVars.SongStart or 0
	GAMEMODE.CampaignMapVars.SongStartAt = RealTime()

	ply:SendLua(string.format([[
		sound.PlayFile("sound/eateot/i1.mp3", "noblock mono noplay", function(s)
			s:SetVolume(0.3)
			s:SetTime(%s)
			s:Play()
			STATION = s
		end)
	]], GAMEMODE.CampaignMapVars.SongStart))
end)


hook.Add("OnMapSwitch", "hl2ceSwitchMap", function()
	GAMEMODE.CampaignMapVars.SongStart = RealTime()+GAMEMODE.CampaignMapVars.SongStart-GAMEMODE.CampaignMapVars.SongStartAt
end)

hook.Add("AcceptInput", "hl2ceAcceptInput", function(ent, input)
	if ent:GetName() == "relay_portalfinalexplodeshake" and input:lower() == "trigger" then
		timer.Simple(1.5, function()
			BroadcastLua([[chat.AddText(Color(255,0,0), "Well...")]])
		end)
		timer.Simple(3.5, function()
			BroadcastLua([[chat.AddText(Color(180,0,0), "This wasn't worth it.")]])
		end)
		timer.Simple(6, function()
			BroadcastLua([[chat.AddText(Color(100,0,0), "Goodbye.")]])
		end)
	elseif ent:GetName() == "fade_end" and input:lower() == "fade" then
		BroadcastLua([[chat.AddText(Color(0,0,160), "The world will never see the light again.")]])
		timer.Simple(5, function()
			RunConsoleCommand("disconnect")
		end)
	end
end)


do return end

if CLIENT then
	hook.Add("HUDPaint", "degeneratingReality", function()
		local pl = LocalPlayer()
		draw.SimpleText("Health left: "..pl:Health()..(pl:Armor() > 0 and " (+"..pl:Armor()..")" or ""), "hl2ce_font_small", ScrW()/2, ScrH()/4, color_white:Lerp(Color(255,0,0), 1-pl:Health()/pl:GetMaxHealth()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end

hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	ply:SendLua([[chat.AddText(Color(48,48,96), "The end...")]])

	ply:EmitSound("@eateot/f5.mp3", 0, 65, 0.2)
	
	timer.Create("removeHealth_"..ply:EntIndex(), 1, 0, function()
		if !IsValid(ply) then return end
		if ply:Armor() > 0 then
			ply:SetArmor(ply:Armor()-1)
			return
		end

		ply:SetHealth(ply:Health()-1)

		if ply:Health() == 0 then
			local dmg = DamageInfo()
			dmg:SetDamage(0)
			dmg:SetDamageType(DMG_DISSOLVE)
			dmg:SetAttacker(ents.FindByClass("gmod_gamerules")[1])
			dmg:SetInflictor(ents.FindByClass("gmod_gamerules")[1])
			ply:TakeDamageInfo(dmg)

			if ply:Alive() then
				ply:Kill()
			end
		end
	end)
end)

hook.Add("OnMapSwitch", "hl2ceSwitchMap", function()
	GAMEMODE.CampaignMapVars.SongStart = RealTime()+GAMEMODE.CampaignMapVars.SongStart-GAMEMODE.CampaignMapVars.SongStartAt
end)
