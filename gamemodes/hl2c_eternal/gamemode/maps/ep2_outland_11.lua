NEXT_MAP = "ep2_outland_11a"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawnLoadout", "hl2ce_PlayerLoadout", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
    if GAMEMODE.EXMode then
        if ent:GetName() == "lcs_cit_alarm" and input:lower() == "start" then
            timer.Simple(1, function()
                PrintMessage(3, "Chapter B6")
            end)
        end

        if ent:GetName() == "lcs_gunschool" and input:lower() == "start" then
            timer.Simple(4, function()
                PrintMessage(3, "AR2... no... now, AR3 sure! plenty of times!")
            end)
        end
    end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
