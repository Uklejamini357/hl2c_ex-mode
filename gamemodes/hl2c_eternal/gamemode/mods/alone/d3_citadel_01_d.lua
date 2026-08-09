NEXT_MAP = "d3_citadel_02_d"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 1


hook.Add("PlayerSpawnReady", "hl2cePlayerInitialSpawn", function(ply)
	GAMEMODE.CampaignMapVars.SongStart = 0
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
	if ent:GetName() == "relay_crow_fly" and input:lower() == "trigger" then
		timer.Simple(2.5, function()
			if !IsValid(ent) then return end
			PrintMessage(3, GlitchedText("...", 12*math.pi))
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
	GAMEMODE.CampaignMapVars.SongStart = 0
	GAMEMODE.CampaignMapVars.SongStartAt = RealTime()

	ply:SendLua(string.format([[
		sound.PlayFile("sound/eateot/i1.mp3", "noblock mono noplay", function(s)
			s:SetVolume(0.3)
			s:SetTime(%s)
			s:Play()
			STATION = s		end)
	]], GAMEMODE.CampaignMapVars.SongStart))
	ply:SendLua([[chat.AddText(Color(255,0,0), "WARNING! ", Color(190,0,0), "AREA OF DEGENERATING REALITY.")]])
	ply:SendLua([[chat.AddText(Color(190,0,0), "USER'S STATE WILL CONTINOUSLY DETERIORATE.")]])
	ply:SendLua([[chat.AddText(Color(190,0,0), "EXCESSIVE EXPOSURE WILL LEAD TO DEATH.")]])

	timer.Create("removeHealth_"..ply:EntIndex(), 1, 0, function()
		if !IsValid(ply) then return end
		if !ply:Alive() then return end

		if ply:Armor() > 0 then
			ply:SetArmor(ply:Armor()-ply:GetMaxHealth()/100)
			return
		end

		ply:SetHealth(ply:Health()-ply:GetMaxHealth()/100)

		if ply:Health() < 0 then
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


