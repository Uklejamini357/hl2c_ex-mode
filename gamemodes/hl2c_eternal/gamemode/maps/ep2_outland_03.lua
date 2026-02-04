NEXT_MAP = "ep2_outland_04"

TRIGGER_CHECKPOINT = {
	{Vector(5168, -5184, -352), Vector(5056, -5096, -64)},
	{Vector(1432, -9504, -512), Vector(1600, -9408, -376)}
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
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

	ents.FindByName("spawnitems_template")[1]:Remove()

	local vort = ents.Create("npc_vortigaunt")
	vort:SetPos(Vector(-1301, -3885, -903))
	vort:SetKeyValue("GameEndAlly", "1")
	vort:SetName("vort")
	vort:Spawn()

end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if !game.SinglePlayer() and ent:GetName() == "bucket_tunnel_clip" and input:lower() == "enable" then
		return true
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
