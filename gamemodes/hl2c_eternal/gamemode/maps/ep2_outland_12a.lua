NEXT_MAP = "d1_trainstation_01"

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 101

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
    if ent:GetName() == "credits" and string.lower(input) == "rolloutrocredits" then
        gamemode.Call("NextMap")
        gamemode.Call("OnCampaignCompleted")

		for _,ply in ipairs(player.GetAll()) do
			gamemode.Call("PlayerCompletedCampaign", ply)
		end

        gamemode.Call("PostOnCampaignCompleted")
    end

	if GAMEMODE.EXMode then
		if ent:GetName() == "relay.advisor.scene" and input:lower() == "trigger" then
			PrintMessage(3, "NOOOOOO!!!!")
		end

		if ent:GetName() == "fade_out_credits" and input:lower() == "fade" then
			-- PrintMessage(3, "Welcome to the end.")
		end

	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
