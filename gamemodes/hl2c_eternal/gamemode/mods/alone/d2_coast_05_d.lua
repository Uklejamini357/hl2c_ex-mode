INFO_PLAYER_SPAWN = {Vector(7824, -12136, 1856), 180}

TELEPORT_POSITIONS = {
    ["Checkpoint 1"] = Vector(-4358, -12522, 704),
    ["Crossbow"] = Vector(-3652, -4246, 1266),
}

NEXT_MAP = "d2_coast_07_d"

hook.Add("MapEdit", "jeep", function()
    if GAMEMODE.CampaignMapVars.GotJeep then
        ALLOWED_VEHICLE = "Jeep NoGun"
    end
end)
