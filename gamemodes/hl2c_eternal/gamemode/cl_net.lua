
net.Receive("hl2c_updatestats", function(length)
    local ply = LocalPlayer()
    
    ply.Moneys = net.ReadInfNumber()
    ply.XP = net.ReadInfNumber()
    ply.Level = net.ReadDouble()
    ply.StatPoints = net.ReadDouble()
    ply.Prestige = net.ReadDouble()
    ply.PrestigePoints = net.ReadDouble()
    ply.Eternities = net.ReadDouble()
    ply.EternityPoints = net.ReadDouble()
    ply.Celestiality = net.ReadDouble()
    ply.CelestialityPoints = net.ReadDouble()
end)

net.Receive("hl2ce_skills", function(length)
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

net.Receive("hl2ce_xpgain", function(length)
	local xp = net.ReadInfNumber()

	XPGained = xp
    XPGainedTotal = XPGainedTotal + xp
	if XPGained != 0 then XPColor = 300 end
end)

net.Receive("hl2ce_finishedmap", function(length)
	local xpgained = net.ReadInfNumber()
	local bonusxp = net.ReadInfNumber()
	local moneysgained = net.ReadInfNumber()


    gamemode.Call("OnMapCompleted")
    gamemode.Call("PostOnMapCompleted")

    local color_yellow = Color(255,255,190)
    chat.AddText(color_white, "Map summary:")
    chat.AddText(color_white, "XP Gained: ", color_yellow, tostring(xpgained), color_white, " (+", color_yellow, tostring(bonusxp), color_white, " bonus xp)")
    chat.AddText(color_white, "Moneys Gained: ", color_yellow, tostring(moneysgained))
    -- for k,v in pairs(tbl) do
    --     chat.AddText(k, " ", v)
    -- end
end)

net.Receive("hl2ce_boss", function(len)
    GAMEMODE.EnemyBoss = net.ReadEntity()
end)

net.Receive("hl2ce_fail", function(len)
    if GetConVar("hl2ce_cl_noshowlosetext"):GetBool() then return end

    gamemode.Call("OnMapFailed")
    local time = math.min(15, RESTART_MAP_TIME)

    local s1 = translate.Get("you_lost")
    local len = utf8.len(s1)
    local sub = len > 50 and utf8.sub or string.sub
    local font = "hl2ce_font_big"
    local createtime = CurTime()

    surface.SetFont(font)
    local x,y = surface.GetTextSize(s1)

    local failtext = vgui.Create("DLabel")
    GAMEMODE.UITextFailed1 = failtext
    failtext:SetFont("hl2ce_font_big")
    failtext:SetTextColor(Color(255,0,0))
    failtext:SetSize(x, y)
    failtext:Center()
    failtext.Think = function(self)
        local str = sub(s1, 1, math.min(len, math.ceil((len*(CurTime()-createtime)/math.min(len/5, 1.5)))))
        if str == self:GetText() then return end
        self:SetText(str)
        surface.PlaySound("buttons/lightswitch2.wav")
    end

    failtext:AlphaTo(0, 1, time, function(_, self)
        self:Remove()
    end)

    local s2 = translate.Get(net.ReadString())
    if s2 == "" then
        chat.AddText(Color(255,0,0), s1)
        return
    end

    local len = utf8.len(s2)
    local sub = len > 50 and utf8.sub or string.sub
    local font = "hl2ce_font"
    local createtime = CurTime()

    surface.SetFont(font)
    local x,y = surface.GetTextSize(s2)

    local failtext = vgui.Create("DLabel")
    GAMEMODE.UITextFailed2 = failtext
    failtext:SetFont("hl2ce_font")
    failtext:SetTextColor(Color(220,100,100))
    failtext:SetSize(x, y)
    failtext:Center()
    failtext:CenterVertical(0.65)

    -- how can i optimize this? well...
    -- local 
    failtext.Think = function(self)
        if self.NoMoreUpdate then return end
        local str = sub(s2, 1, math.min(len, math.ceil((len*(CurTime()-createtime)/math.min(len/12, math.max((len/20)^0.9, 4.5), 10)))))
        if str == self:GetText() then return end
        self:SetText(str)
        surface.PlaySound("buttons/lightswitch2.wav")
        -- self.NoMoreUpdate = true
    end

    failtext:AlphaTo(0, 1, time, function(_, self)
        self:Remove()
    end)


    chat.AddText(Color(255,0,0), s1, " - ", Color(200,50,50), s2)


    gamemode.Call("PostOnMapFailed")
end)

net.Receive("hl2ce_playertimer", function(len)
    local time = net.ReadFloat()
    local pl = LocalPlayer()

    pl.startTime = time
end)


net.Receive("hl2ce_playerkilled", function(len)
    local pl = net.ReadEntity()
    local attacker = net.ReadEntity()
    local me = LocalPlayer()

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

    
    if !GetConVar("hl2ce_cl_noplrdeathmsg"):GetBool() then
        local cl = net.ReadString()
        if cl == "trigger_hurt" then
            chat.AddText(
                Color(99, 121, 247), "[Hl2cE] ",
                pl == me and "" or pl,
                color_white, pl == me and "You died a " or " died a ",
                Color(255,0,0), "stupid death",
                color_white, "."
            )
        elseif pl == attacker then
            chat.AddText(
                Color(99, 121, 247), "[Hl2cE] ",
                pl == me and "" or pl,
                color_white, pl == me and "You died to " or " has died to ",
                Color(255,0,0), "suicide",
                color_white, "."
            )
        else
            chat.AddText(
                Color(99, 121, 247), "[Hl2cE] ",
                pl == me and "" or pl,
                color_white, pl == me and "You were killed by " or " was killed by ",
                Color(255,0,0), language.GetPhrase(cl),
                color_white, "."
            )
        end
    end
end)

net.Receive("hl2ce_revive", function(len)
    local typ = net.ReadUInt(4)
    if typ == REVIVE_SENDDEADPLAYERS then
        local plrs = net.ReadTable()

        GAMEMODE.DeadPlayersToRevive = plrs
    elseif typ == REVIVE_PLAYERSTARTREVIVE then
        local reviver = net.ReadEntity()
        local endtime = net.ReadFloat()

        GAMEMODE.BeingRevivedBy = reviver
        GAMEMODE.ReviveStartTime = CurTime()
        GAMEMODE.ReviveEndTime = endtime

        GAMEMODE.ReviveSound = CreateSound(LocalPlayer(), "items/medcharge4.wav")
        GAMEMODE.ReviveSound:PlayEx(0.2, 100)
    elseif typ == REVIVE_PLAYERSTOPREVIVE then
        local reviver = net.ReadEntity()
        
        GAMEMODE.BeingRevivedBy = nil
        GAMEMODE.ReviveStartTime = nil
        GAMEMODE.ReviveEndTime = nil

        if GAMEMODE.ReviveSound then
            GAMEMODE.ReviveSound:Stop()
        end
    elseif typ == REVIVE_PLAYERREVIVED then
        local reviver = net.ReadEntity()
        local pl = net.ReadEntity()
        local me = LocalPlayer()

        chat.AddText(
            Color(99, 121, 247), "[Hl2cE] ",
            pl == me and "" or pl,
            color_white, pl == me and "You were revived by " or " was revived by ",
            Color(0,255,0), reviver,
            color_white, "."
        )
    end
end)

local hl2ce_cl_nodmgnum = GetConVar("hl2ce_cl_nodmgnum")
net.Receive("hl2ce_dmgnum", function(len)
	local dmg = net.ReadDouble()
	local dmgtype = net.ReadUInt(32)
	local pos = net.ReadVector()
	local pl = net.ReadBool()

	if hl2ce_cl_nodmgnum:GetBool() then return end
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetMagnitude(dmg)
	effectdata:SetScale(0)
    GAMEMODE.LastDamageDealt = dmg
    GAMEMODE.LastDamageTypeDealt = dmgtype
	util.Effect("hl2ce_dmg", effectdata)
end)


net.Receive("hl2ce_vote", function(len)
    local typ = net.ReadUInt(4)

    if typ == HL2CE_NETVOTETYPE_STARTVOTE then
        local title = net.ReadString()
        local text = net.ReadString()
        local endtime = net.ReadFloat()
        local minVotes = net.ReadUInt(8)
        local options = net.ReadTable()

        GAMEMODE:OnVoteStart(title, text, endtime, minVotes, options)
    end
    -- local mostvoted[1
    -- local votecount,
end)
