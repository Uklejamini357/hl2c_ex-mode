function GM:LoadServerData()
    local filedir = "hl2c_eternal/server"
    local filedir2 = "hl2c_eternal/server/globaldata.txt"

    if not file.IsDir(filedir, "DATA") then file.CreateDir(filedir) end
    if not file.Exists(filedir2, "DATA") then return end

    local data = util.JSONToTable(file.Read(filedir2, "DATA"))
    for variable, val in pairs(data) do
        if variable == "Difficulty" then
            GAMEMODE:SetDifficulty(InfNumber(val.mantissa, val.exponent == "inf" and math.huge or val.exponent == "-inf" and -math.huge or val.exponent))
        end
    end
end

function GM:SaveServerData()
    if self.DisableDataSave then return end

    local Data = {}
    local function insertdata(key, value)
        if isinfnumber(value) then
            Data[key] = {
                isinfnumber = true,
                mantissa = value.mantissa,
                exponent = value.exponent == math.huge and "inf" or value.exponent == math.huge and "-inf" or value.exponent
            }
            return
        end

        Data[key] = value
    end

	insertdata("Difficulty", self:GetDifficulty(true, true))

    local filedir = "hl2c_eternal/server/globaldata.txt"
    local savedata = util.TableToJSON(Data, true)
	file.Write(filedir, savedata)
	print("Saved global server data to file: "..filedir)
end


function GM:LoadCampaignData()
    local filedir = "hl2c_eternal/server"
    local filedir2 = "hl2c_eternal/server/campaigndata.txt"

    if not file.IsDir(filedir, "DATA") then file.CreateDir(filedir) end
    if not file.Exists(filedir2, "DATA") then return end
    local data = util.JSONToTable(file.Read(filedir2, "DATA"))


    local load = {
        CampaignMapVars = function(v) self.CampaignMapVars = v end,
        HardcoreAlivePlayers = function(v) self.HardcoreAlivePlayers = v end,
        PrevMap = function(v) self.PrevMap = v end,
        NextMap = function(v) self.NextMap = v end
    }
    for variable, val in pairs(data) do
        if variable == "CampaignMapVars" then
            self.CampaignMapVars = val
        elseif variable == "AlivePlayers" then
            self.AlivePlayers = val
        end
    end
end

function GM:SaveCampaignData()
    local Data = {}
    local function insertdata(key, value)
        Data[key] = value
    end

	insertdata("CampaignMapVars", self.CampaignMapVars)
	insertdata("HardcoreAlivePlayers", self.HardcoreAlivePlayers)
	insertdata("PrevMap", self.PrevMap)
	insertdata("LastMap", self.LastMap)

    local filedir = "hl2c_eternal/server/globaldata.txt"
    local savedata = util.TableToJSON(Data, true)
	file.Write(filedir, savedata)
	print("Saved campaign data to file: "..filedir)
end

function GM:DeleteCampaignData()
    local filedir = "hl2c_eternal/server/globaldata.txt"
    if file.Exists(filedir) then
        file.Delete(filedir)
    end
end


