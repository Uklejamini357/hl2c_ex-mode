NEXT_MAP = "ep2_outland_06a"

TRIGGER_CHECKPOINT = {
	{Vector(1860, 972, -128), Vector(1920, 1140, 0)}
}

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_frag")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
	ents.FindByName("global_newgame_template_local_items")[1]:Remove()
	ents.FindByName("global_newgame_template_base_items")[1]:Remove()
	ents.FindByName("global_newgame_template_ammo")[1]:Remove()

	local alyx = ents.Create("npc_alyx")
	alyx:SetName("alyx")
	alyx:SetKeyValue("GameEndAlly", "1")
	alyx:Give("weapon_alyxgun")
	alyx:SetPos(Vector(-448, 112, 832))
	alyx:SetAngles(Angle(0, 90, 0))
	alyx:Spawn()

	local vort = ents.Create("npc_vortigaunt")
	vort:SetPos(Vector(-448, 86, 832))
	alyx:SetAngles(Angle(0, 90, 0))
	alyx:SetKeyValue("GameEndAlly", "1")
	vort:SetName("vort")
	vort:Spawn()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "clip_player_elevator" and input:lower() == "enable" then
		return true
	end

	-- relay_bridge_down, trigger -- bridge goes down
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
