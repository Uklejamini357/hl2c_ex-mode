-- NOT. EVEN. FINISHED.
-- This map is bugged. And btw don't try to kill strider early or you'll softlock the map.
if PLAY_EPISODE_2 then
    NEXT_MAP = "ep2_outland_01"
else
    NEXT_MAP = "d1_trainstation_01"
end

NEXT_MAP_PERCENT = 1
NEXT_MAP_INSTANT_PERCENT = 101

FORCE_RESTART_COUNT = 2

-- MAP_FORCE_CHANGELEVEL_ON_MAPRESTART = true

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
	ply:Give("weapon_crowbar")
	ply:Give("weapon_physcannon")
	ply:Give("weapon_pistol")
	ply:Give("weapon_357")
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
	ply:Give("weapon_shotgun")
	ply:Give("weapon_crossbow")
	ply:Give("weapon_frag")
	ply:Give("weapon_rpg")
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cPlayerInitialSpawn(ply)
end
hook.Add("PlayerInitialSpawn", "hl2cPlayerInitialSpawn", hl2cPlayerInitialSpawn)


-- Initialize entities
function hl2cMapEdit()
	-- ents.FindByName("global_newgame_entmaker")[1]:Remove() -- deleting this will not spawn in anything.
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

local completed
-- Accept input
function hl2cAcceptInput(ent, input)
    if ent:GetName() == "lcs_al_leavingOnTrain" and string.lower(input) == "start" then
        BroadcastLua([[surface.PlaySound("music/vlvx_song3.mp3")]]) -- Hl2 overcharged moment?
    end

    if ent:GetName() == "relay_deliver_strider" and input:lower() == "enablerefire" then
        net.Start("hl2ce_boss")
        net.WriteEntity(ents.FindByName("strider")[1])
        net.Broadcast()
    end

    if ent:GetName() == "credits" and string.lower(input) == "rolloutrocredits" then
        gamemode.Call("NextMap")
        gamemode.Call("OnCampaignCompleted")

        if not completed then
            completed = true
            for _,ply in ipairs(player.GetAll()) do
                gamemode.Call("PlayerCompletedCampaign", ply)
            end
        end

        gamemode.Call("PostOnCampaignCompleted")
    end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
