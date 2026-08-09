NEXT_MAP = "d1_town_02_d"

TRIGGER_DELAYMAPLOAD = {Vector(-3801, -65, -3457), Vector(-3719, -7, -3335)}

hook.Add("CompleteMap", "hl2cCompleteMap", function(pl)
	GAMEMODE.CampaignMapVars.D1Town03Passed = true
end)
