---- Player Database managing ----

local function OverrideOldVariables(tbl)
    for k, v in pairs(self.SkillsInfo) do
        if tbl["Stat"..k] then
            tbl.Skills[k] = tbl["Stat"..k]
        end
    end
end

function GM:LoadPlayer(ply)
    if ply:IsBot() then return end
    if not file.IsDir(self.VaultFolder.."/players/"..string.lower(string.gsub(ply:UniqueID(), ":", "_")), "DATA") then
        file.CreateDir(self.VaultFolder.."/players/"..string.lower(string.gsub(ply:UniqueID(), ":", "_")))
    end
    if file.Exists(self.VaultFolder.."/players/".. string.lower(string.gsub(ply:UniqueID(), ":", "_") .."/profile.txt"), "DATA") then
        local data = util.JSONToTable(file.Read(self.VaultFolder.."/players/".. string.lower(string.gsub(ply:UniqueID(), ":", "_") .."/profile.txt"), "DATA"))

        for variable, val in pairs(data) do
            local prev_val = ply[variable]
            local infnumber = isinfnumber(prev_val)
            val = tonumber(val) or val

            if istable(prev_val) and prev_val.mantissa and prev_val.exponent then
                val = InfNumber(val.mantissa or 1, val.exponent == "inf" and math.huge or val.exponent == "-inf" and -math.huge or val.exponent)
            elseif infnumber then
                val = InfNumber(val)
            elseif istable(val) and val.mantissa and val.exponent then
                val = infmath.ConvertInfNumberToNormalNumber(val)
            end

            ply[variable] = val
        end
    else
        print("Created a new profile for "..ply:Nick() .." (UniqueID: "..ply:UniqueID()..")")

        self:SavePlayer(ply)
    end
end

function GM:SavePlayer(ply)
    if ply:IsBot() then return end
    if (ply.LastSave or 0) >= CurTime() then return end
    if self.DisableDataSave then return end
    ply.LastSave = CurTime() + 5

	local Data = {}

    local function insertdata(key, value)
        if isinfnumber(value) then
            Data[key] = {
                mantissa = value.mantissa,
                exponent = value.exponent == math.huge and "inf" or value.exponent == math.huge and "-inf" or value.exponent
            }
            return
        end

        Data[key] = value
    end

	insertdata("XP", ply.XP)
	insertdata("Level", ply.Level)
	insertdata("StatPoints", ply.StatPoints)
	insertdata("Prestige", ply.Prestige)
	insertdata("PrestigePoints", ply.PrestigePoints)
	insertdata("Eternities", ply.Eternities)
	insertdata("EternityPoints", ply.EternityPoints)
	insertdata("Celestiality", ply.Celestiality)
	insertdata("CelestialityPoints", ply.CelestialityPoints)

	insertdata("XPUsedThisPrestige", ply.XPUsedThisPrestige)
	insertdata("Moneys", ply.Moneys)
    
	insertdata("UnlockedPerks", ply.UnlockedPerks)
	insertdata("Skills", ply.Skills)

    insertdata("HardcoreModeAttempts", ply.HardcoreModeAttempts)

    local savedata = util.TableToJSON(Data, true)

	print("✓ ".. ply:Nick() .." profile saved into database")
	file.Write(self.VaultFolder.."/players/"..string.lower(string.gsub(ply:UniqueID(), ":", "_") .."/profile.txt"), savedata)
end
