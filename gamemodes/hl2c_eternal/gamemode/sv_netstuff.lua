-- Network strings
util.AddNetworkString("SetCheckpointPosition")
util.AddNetworkString("NextMap")
util.AddNetworkString("RestartMap")
util.AddNetworkString("hl2ce_updateplrmodel")

util.AddNetworkString("hl2ce_xpgain")
util.AddNetworkString("hl2ce_skills")
util.AddNetworkString("hl2ce_upgperk")

util.AddNetworkString("hl2c_playerready")
util.AddNetworkString("hl2ce_prestige")
util.AddNetworkString("hl2ce_firstprestige")
util.AddNetworkString("hl2ce_unlockperk")
util.AddNetworkString("hl2c_updatestats")
util.AddNetworkString("hl2ce_updateperks")
util.AddNetworkString("hl2ce_buyupgrade")
util.AddNetworkString("hl2ce_updateeternityupgrades")
util.AddNetworkString("hl2ce_finishedmap")
util.AddNetworkString("hl2ce_boss")
util.AddNetworkString("hl2ce_music")
util.AddNetworkString("hl2ce_fail")
util.AddNetworkString("hl2ce_map_event")
util.AddNetworkString("hl2ce_playerkilled")
util.AddNetworkString("hl2ce_playertimer")

util.AddNetworkString("hl2ce_admin_teleport")
util.AddNetworkString("hl2ce_admin_changemap")
util.AddNetworkString("hl2ce_admin_completemaptest")
util.AddNetworkString("hl2ce_admin_forcefailmap")


function GM:NetworkString_UpdateStats(ply)
    if ply:IsBot() then return end
    net.Start("hl2c_updatestats")
    net.WriteInfNumber(ply.Moneys)
    net.WriteInfNumber(ply.XP)
    net.WriteDouble(ply.Level)
    net.WriteDouble(ply.StatPoints)
    net.WriteDouble(ply.Prestige)
    net.WriteDouble(ply.PrestigePoints)
    net.WriteDouble(ply.Eternities)
    net.WriteDouble(ply.EternityPoints)
    net.WriteDouble(ply.Celestiality)
    net.WriteDouble(ply.CelestialityPoints)
    net.Send(ply)
end

function GM:NetworkString_UpdateSkills(ply)
    if ply:IsBot() then return end
    net.Start("hl2ce_skills")
    net.WriteTable(ply.Skills)
    net.Send(ply)
end

function GM:NetworkString_UpdatePerks(ply)
    if ply:IsBot() then return end
    net.Start("hl2ce_updateperks")
    net.WriteTable(ply.UnlockedPerks)
    net.Send(ply)
end

function GM:NetworkString_UpdateEternityUpgrades(ply)
    if ply:IsBot() then return end
    net.Start("hl2ce_updateeternityupgrades")
    net.WriteTable(ply.EternityUpgradeValues)
    net.Send(ply)
end

net.Receive("hl2c_updatestats", function(length, ply)
    local s1 = net.ReadString()
    if s1 == "reloadstats" then
        GAMEMODE:NetworkString_UpdateStats(ply)
        GAMEMODE:NetworkString_UpdateSkills(ply)
    	GAMEMODE:NetworkString_UpdatePerks(ply)
    end 
end)

net.Receive("hl2ce_upgperk", function(length, ply)
	local perk = net.ReadString()
    local count = net.ReadUInt(32)
    local sks = ply.Skills
    local skill = GAMEMODE.SkillsInfo[perk]

    local curpoints = ply.StatPoints
    local limit = ply:GetMaxSkillLevel(perk)

    count = infmath.ConvertInfNumberToNormalNumber(infmath.min(limit - sks[perk], curpoints))

    if infmath.ConvertInfNumberToNormalNumber(ply.StatPoints) < 1 then
        ply:PrintTranslatedMessage(HUD_PRINTTALK, "need_sp_skill")
		return false
	end

    if tonumber(sks[perk]) >= limit then
        ply:PrintTranslatedMessage(HUD_PRINTTALK, "skill_max_reached")
		return false
	end

    local old = sks[perk]
	sks[perk] = old + count
	ply.StatPoints = ply.StatPoints - count
    ply:PrintTranslatedMessage(HUD_PRINTTALK, "skill_increased_lvl", perk, count)

    if skill.OnApply then
        skill.OnApply(ply, old, sks[perk])
    end

    GAMEMODE:NetworkString_UpdateStats(ply)
    GAMEMODE:NetworkString_UpdateSkills(ply)
end)

net.Receive("hl2ce_unlockperk", function(len, ply)
    local name = net.ReadString()
    local perk = GAMEMODE.PerksData[name]
    if !perk then return end
    if ply.UnlockedPerks[name] then return end

    local cost = infmath.ConvertInfNumberToNormalNumber(perk.Cost)
    local prestigelvl = perk.PrestigeLevel
    local prestigereq = infmath.ConvertInfNumberToNormalNumber(perk.PrestigeReq)

    local prestigetype = prestigelvl == 3 and "Celestiality" or prestigelvl == 2 and "Eternities" or prestigelvl == 1 and "Prestige"
    local prestigetypepoints = (prestigelvl == 3 and "Celestiality" or prestigelvl == 2 and "Eternity" or prestigelvl == 1 and "Prestige").."Points"

    local plyprestige = infmath.ConvertInfNumberToNormalNumber(ply[prestigetypepoints])

    if infmath.ConvertInfNumberToNormalNumber(ply[prestigetype]) < prestigereq then
        ply:PrintTranslatedMessage(3, "perk_noprestige")
        return
    end

    if plyprestige < cost then
        ply:PrintTranslatedMessage(3, "perk_noprestige_points", prestigetype)
        return
    end
    ply[prestigetypepoints] = plyprestige - cost

    ply:PrintTranslatedMessage(3, "perk_unlocked", perk.Name)
    ply.UnlockedPerks[name] = true
    

    GAMEMODE:NetworkString_UpdateSkills(ply)
    GAMEMODE:NetworkString_UpdateStats(ply)
	GAMEMODE:NetworkString_UpdatePerks(ply)
end)

net.Receive("hl2ce_prestige", function(len, ply)
    local prestige = net.ReadString()

    if prestige == "prestige" then
        ply:GainPrestige()
    elseif prestige == "eternity" then
        ply:GainEternity()
    elseif prestige == "celestiality" then
        ply:GainCelestiality()
    end
end)

net.Receive("hl2ce_buyupgrade", function(len, ply)
    if not ply:HasEternityUnlocked() then return end
	local upg = net.ReadString()
	local buy = net.ReadString()

	local upgrade = GAMEMODE.UpgradesEternity[upg]
	if not upgrade then return end

    local old = ply.EternityUpgradeValues[upg]
    local function BuyUpgrade(ply, upg)
        local cost = ply:GetEternityUpgradeCost(upg)

		if ply.Moneys:log10() >= cost:log10() then
			ply.EternityUpgradeValues[upg] = ply.EternityUpgradeValues[upg] + 1
			ply.Moneys = ply.Moneys - cost
            return true
		end
        return false
    end

    if buy == "once" then
        local success = BuyUpgrade(ply, upg)
    elseif buy == "max" then
        for i=1,1e5 do
            local success = BuyUpgrade(ply, upg)
            if not success then
                break
            end
        end
    end

    if old != ply.EternityUpgradeValues[upg] then
        ply:PrintTranslatedMessage(3, "eupg_increased", old, ply.EternityUpgradeValues[upg])
    end

    GAMEMODE:NetworkString_UpdateEternityUpgrades(ply)
	
end)

net.Receive("hl2ce_admin_teleport", function(len, ply)
    if !ply:IsAdmin() then return end
    
    local str = net.ReadString()

    if str == "spawn" then
        if INFO_PLAYER_SPAWN then
            if !INFO_PLAYER_SPAWN[1] then return end

            local pos = INFO_PLAYER_SPAWN[1]
            ply:SetPos(pos)
            ply:SetEyeAngles(Angle(0, INFO_PLAYER_SPAWN[2], 0))
        elseif GAMEMODE.OriginalSpawnPointsPos and #GAMEMODE.OriginalSpawnPointsPos > 0 then
            local spawn = table.Random(GAMEMODE.OriginalSpawnPointsPos)
            if spawn[1] then
                ply:SetPos(spawn[1])
            end
            if spawn[2] then
                ply:SetEyeAngles(spawn[2])
            end
        else
            local ent = gamemode.Call("PlayerSelectSpawn", ply)
            if IsValid(ent) then
                ply:SetPos(ent:GetPos())
                ply:SetEyeAngles(ent:GetAngles())
            end
        end
    elseif str == "changelevel" then
        if TRIGGER_DELAYMAPLOAD then
            local pos = (TRIGGER_DELAYMAPLOAD[1] + TRIGGER_DELAYMAPLOAD[2]) / 2
            ply:SetPos(pos)
        else
            local ent = ents.FindByClass("trigger_delaymapload")[1]
            if IsValid(ent) then
                ply:SetPos(ent:GetPos())
                ply:SetEyeAngles(ent:GetAngles())
            end
        end
    elseif string.sub(str, 1, 10) == "checkpoint" then
        local num = tonumber(str:sub(12))
        if !TRIGGER_CHECKPOINT[num] then return end

        local pos = (TRIGGER_CHECKPOINT[num][1] + TRIGGER_CHECKPOINT[num][2]) / 2
        pos.z = math.min(TRIGGER_CHECKPOINT[num][1].z, TRIGGER_CHECKPOINT[num][2].z)
        ply:SetPos(pos)
    end
end)

net.Receive("hl2ce_admin_changemap", function(len, ply)
    if !ply:IsAdmin() then return end
    
    local str = net.ReadString()
    local map = net.ReadString() or ""

    for _,tbl in pairs(GAMEMODE.ChaptersList) do
        if tbl.ID == str then
            if map ~= "" then
                if table.HasValue(tbl.Maps, map) then
                    game.ConsoleCommand(string.format("changelevel %s\n", map))
                    print(string.format("%s is changing the map to %s (%s)!", ply:Nick(), map, tbl.Name))
                    PrintMessage(3, string.format("[ALERT] Map is being changed to %s (%s)!", map, tbl.Name))
                end

                return
            end

            game.ConsoleCommand(string.format("changelevel %s\n", tbl.Map))
            print(string.format("%s is changing the map to %s (%s)!", ply:Nick(), tbl.Map, tbl.Name))
            PrintMessage(3, string.format("[ALERT] Map is being changed to %s (%s)!", tbl.Map, tbl.Name))

            break
        end
    end
end)

net.Receive("hl2ce_admin_completemaptest", function(len, ply)
    if !ply:IsAdmin() then return end

    local GM = GAMEMODE
    GM.MapCompleteTest = true
    gamemode.Call("RestartMap", 0.01)
    gamemode.Call("CompleteMap", ply)
    timer.Remove("hl2c_next_map")
end)

net.Receive("hl2ce_admin_forcefailmap", function(len, ply)
    if !ply:IsAdmin() then return end

    gamemode.Call("FailMap", nil, net.ReadString())
end)
