NEXT_MAP = "ep1_citadel_03"
GM.XpGainOnNPCKillMul = 0.35
GM.DifficultyGainOnNPCKillMul = 0.5

INFO_PLAYER_SPAWN = { Vector( 1896, 4320, 2498), 0 }

-- TRIGGER_CHECKPOINT = {
	-- { Vector( 364, 1764, -2730 ), Vector( 549, 1787, -2575 ) }
-- }

TRIGGER_DELAYMAPLOAD = { Vector( 5120, 4840, -6720 ), Vector( 5136, 4480, -6480) }

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_physcannon")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	game.SetGlobalState("super_phys_gun", GLOBAL_ON)

	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local allowfail

-- Accept input
function hl2cAcceptInput(ent, input)
	if ent == ents.FindByName("citadel_train_lift_glass")[1] and string.lower(input) == "break" then
		allowfail = true
		-- print("allowed fail map")
	end

	if ent == ents.FindByName("alyx")[1] and string.lower(input) == "sethealth" and allowfail and not changingLevel then
		gamemode.Call("FailMap", nil, "You let the lift break!")
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

-- prevent any players above from staying there
function hl2cPostOnMapCompleted()
	for _,pl in ipairs(player.GetLiving()) do
		if pl:GetPos().z > -6000 then
			pl:PrintMessage(3, "You died because you stayed in a place you shouldn't be in!")
			pl:Kill()
		end
	end
end
hook.Add("PostOnMapCompleted", "hl2cPostOnMapCompleted", hl2cPostOnMapCompleted)
