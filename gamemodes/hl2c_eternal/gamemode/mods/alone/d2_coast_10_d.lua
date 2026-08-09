INFO_PLAYER_SPAWN = {Vector(2087, -5411, 1375), 0}

NEXT_MAP = "d2_coast_11_d"

hook.Add("MapEdit", "jeep", function()
    if GAMEMODE.CampaignMapVars.GotJeep then
        ALLOWED_VEHICLE = "Jeep NoGun"
    end
end)
