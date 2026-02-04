NEXT_MAP = "ep2_outland_09"

-- ALLOWED_VEHICLE = "Jalopy"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	-- ents.FindByName("new_game_items")[1]:Remove()

	-- local alyx = ents.Create("npc_alyx")
	-- alyx:SetName("alyx")
	-- alyx:SetKeyValue("GameEndAlly", "1")
	-- alyx:Give("weapon_alyxgun")
	-- alyx:SetPos(Vector(-12636, -12762, 444))
	-- alyx:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input, activator)
	if ent:GetName() == "relay_bust_engine" and input:lower() == "trigger" then
		activator:StartEngine(false)
		activator:EnableEngine(false)
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)


hook.Add("PlayerEnteredVehicle", "hl2cPlayerEnteredVehicle", function(ply, veh, role)
	if veh:GetClass() ~= "prop_vehicle_jeep" then return end
	local alyx = ents.FindByName("alyx")[1]
	if !alyx or ply:GetPos():Distance(alyx:GetPos()) >= 200 then return end
	alyx:Fire("EnterVehicleImmediately", veh:GetName())
end)