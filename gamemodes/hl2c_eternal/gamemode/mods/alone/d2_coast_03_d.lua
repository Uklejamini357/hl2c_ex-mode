NEXT_MAP = "d2_coast_04_d"

hook.Add("MapEdit", "jeep", function()
    if GAMEMODE.CampaignMapVars.GotJeep then
        ALLOWED_VEHICLE = "Jeep NoGun"
    end
end)
