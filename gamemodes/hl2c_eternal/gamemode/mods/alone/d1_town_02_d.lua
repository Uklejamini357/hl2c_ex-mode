function hl2cPreMapEdit()
	if GAMEMODE.CampaignMapVars.D1Town03Passed then
		INFO_PLAYER_SPAWN = {Vector(-3755, -28, -3366), 45}
		NEXT_MAP = "d1_town_02a_d"
	else
		INFO_PLAYER_SPAWN = nil
		NEXT_MAP = "d1_town_03_d"
	end
end
hook.Add("PreMapEdit", "hl2cPreMapEdit", hl2cPreMapEdit)
