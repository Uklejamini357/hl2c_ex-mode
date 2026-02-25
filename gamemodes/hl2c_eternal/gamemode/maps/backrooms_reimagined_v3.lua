NEXT_MAP = "backrooms_reimagined_v3"

TELEPORT_POSITIONS = {
    ["Level 5"] = Vector(-10630, 3624, 101),
    ["Level 7"] = Vector(-9751, -9629, 1108),
}

if CLIENT then return end

hook.Add("MapEdit", "hl2cMapEdit", function()
    RunConsoleCommand("gmod_suit", "0") -- no drowning shit
end)

