
function hl2cPreMapEdit()
	-- if GAMEMODE.CampaignMapVars.ForceFieldDeactivated then
		-- INFO_PLAYER_SPAWN = {Vector(3151, 5233, 1552), 180}
		NEXT_MAP = "d2_coast_09_d"
	-- else
		INFO_PLAYER_SPAWN = {Vector(-6695, 6144, 1630), 0}
	-- 	NEXT_MAP = "d2_coast_08"
	-- end
end
hook.Add("PreMapEdit", "hl2cPreMapEdit", hl2cPreMapEdit)

hook.Add("MapEdit", "jeep", function()
    if GAMEMODE.CampaignMapVars.GotJeep then
        ALLOWED_VEHICLE = "Jeep NoGun"
    end
end)
