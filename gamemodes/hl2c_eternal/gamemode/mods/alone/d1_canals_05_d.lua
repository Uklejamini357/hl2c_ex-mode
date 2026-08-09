NEXT_MAP = "d1_canals_06_d"

hook.Add("PlayerEnteredVehicle", "hl2cPlayerEnteredVehicle", function(pl, ent)
    if ALLOWED_VEHICLE ~= "Airboat" then
        ALLOWED_VEHICLE = "Airboat"
		PrintMessage(HUD_PRINTTALK, "You're now allowed to spawn the Airboat (F3).")
    end
end)
