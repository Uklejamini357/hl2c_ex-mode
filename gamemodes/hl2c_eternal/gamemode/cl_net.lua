
net.Receive("hl2c_updatestats", function(length)
    local ply = LocalPlayer()
    
    ply.Moneys = net.ReadInfNumber()
    ply.XP = net.ReadInfNumber()
    ply.Level = net.ReadInfNumber()
    ply.StatPoints = net.ReadInfNumber()
    ply.Prestige = net.ReadInfNumber()
    ply.PrestigePoints = net.ReadInfNumber()
    ply.Eternities = net.ReadInfNumber()
    ply.EternityPoints = net.ReadInfNumber()
    ply.Celestiality = net.ReadInfNumber()
    ply.CelestialityPoints = net.ReadInfNumber()
end)

net.Receive("UpdateSkills", function(length)
    local ply = LocalPlayer()
    if !ply:IsValid() then return end

    if !ply.Skills then ply.Skills = {} end
    table.Merge(ply.Skills, net.ReadTable() or {})
end)

net.Receive("hl2ce_updateperks", function(length)
    local ply = LocalPlayer()

    ply.UnlockedPerks = net.ReadTable()
end)

net.Receive("hl2ce_updateeternityupgrades", function(length)
    local ply = LocalPlayer()

    ply.EternityUpgradeValues = net.ReadTable()
end)

XPGained = InfNumber(0)
XPGainedTotal = InfNumber(0)
XPColor = 0

net.Receive("XPGain", function(length)
	local xp = net.ReadInfNumber()

	XPGained = xp
    XPGainedTotal = XPGainedTotal + xp
	if XPGained != 0 then XPColor = 300 end
end)

net.Receive("hl2ce_finishedmap", function(length)
	local tbl = net.ReadTable()


    gamemode.Call("OnMapCompleted")
    gamemode.Call("PostOnMapCompleted")
    -- chat.AddText("Map completed")
    -- for k,v in pairs(tbl) do
    --     chat.AddText(k, " ", v)
    -- end
end)

net.Receive("hl2ce_boss", function(len)
    GAMEMODE.EnemyBoss = net.ReadEntity()
end)

net.Receive("hl2ce_fail", function(len)
    local time = math.min(15, RESTART_MAP_TIME)

    local s1 = translate.Get("you_lost")
    local len = utf8.len(s1)
    local font = "hl2ce_font_big"
    local createtime = CurTime()

    surface.SetFont(font)
    local x,y = surface.GetTextSize(s1)

    local failtext = vgui.Create("DLabel")
    failtext:SetFont("hl2ce_font_big")
    failtext:SetTextColor(Color(255,0,0))
    failtext:SetSize(x, y)
    failtext:Center()
    failtext.Think = function(self)
        local str = utf8.sub(s1, 1, math.min(len, math.ceil((len*(CurTime()-createtime)/math.min(len/5, 1.5)))))
        if str == self:GetText() then return end
        self:SetText(str)
        surface.PlaySound("buttons/lightswitch2.wav")
    end

    failtext:AlphaTo(0, 1, time, function(_, self)
        self:Remove()
    end)

    local s2 = translate.Get(net.ReadString())
    local len = utf8.len(s2)
    local font = "hl2ce_font"
    local createtime = CurTime()

    surface.SetFont(font)
    local x,y = surface.GetTextSize(s2)

    local failtext = vgui.Create("DLabel")
    failtext:SetFont("hl2ce_font")
    failtext:SetTextColor(Color(220,100,100))
    failtext:SetSize(x, y)
    failtext:Center()
    failtext:CenterVertical(0.65)

    -- how can i optimize this? well...
    -- local 
    failtext.Think = function(self)
        if self.NoMoreUpdate then return end
        local str = utf8.sub(s2, 1, math.min(len, math.ceil((len*(CurTime()-createtime)/math.min(len/12, math.max((len/20)^0.9, 4.5), 10)))))
        if str == self:GetText() then return end
        self:SetText(str)
        surface.PlaySound("buttons/lightswitch2.wav")
        -- self.NoMoreUpdate = true
    end

    failtext:AlphaTo(0, 1, time, function(_, self)
        self:Remove()
    end)

    chat.AddText(Color(255,0,0), s1, " - ", Color(200,50,50), s2)
end)

net.Receive("hl2ce_playertimer", function(len)
    local time = net.ReadFloat()
    local pl = LocalPlayer()

    pl.startTime = time
end)


net.Receive("hl2ce_playerkilled", function(len)
    local sound = net.ReadBit()

    if sound == 1 then
        local pl = net.ReadEntity()
	
        if !GetConVar("hl2ce_cl_noplrdeathsound"):GetBool() then
            local model = string.lower(pl:GetModel())
            local sndid = GAMEMODE.DeathVoicelineModels[model] or "Male"
            if !sndid then return end

            local mdlsnds = GAMEMODE.DeathVoicelines[sndid]
            if !mdlsnds then return end

            local snd
            if isstring(mdlsnds) then
                snd = mdlsnds
            else
                snd = table.Random(mdlsnds)
            end

            pl:EmitSound(snd)
        end
    else
        chat.AddText("Killed by ", Color(255,0,0), language.GetPhrase(net.ReadString()))
    end
end)

