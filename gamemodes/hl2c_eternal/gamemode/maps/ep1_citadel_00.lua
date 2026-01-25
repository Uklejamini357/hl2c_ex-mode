NEXT_MAP = "ep1_citadel_01"
GM.XP_REWARD_ON_MAP_COMPLETION = 0

RESET_PL_INFO = true

TRIGGER_CHECKPOINT = {
	{ Vector( -8922, 5856, -144 ), Vector( -9106, 5744, 8 ) },
	{ Vector( -6720, 5572, -124 ), Vector( -6890, 5512, 0 ) },
	-- { Vector( 4318, 4288, -6344 ), Vector( 4064, 3936, -5944 ) }
}

-- MAP_FORCE_CHANGELEVEL_ON_MAPRESTART = true
-- FORCE_RESTART_COUNT = 0

if CLIENT then return end

local allowunlock

function hl2cPlayerSpawn(ply)
	ply:Freeze(not GAMEMODE.MapVars.ShouldNotFreezePlayer)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)

function hl2cPlayerPostThink(ply)
    if GAMEMODE.MapVars.ShouldNotFreezePlayer then return end
	ply:Freeze(true)
end
hook.Add("PlayerPostThink", "hl2cPlayerPostThink", hl2cPlayerPostThink)

function hl2cMapEdit()
    GAMEMODE.MapVars.ShouldNotFreezePlayer = false

    ents.FindByName("trigger_falldeath")[1]:Remove() -- can break script
end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)

function hl2cAcceptInput(ent, input, activator)
    if !game.SinglePlayer() and string.lower(input) == "scriptplayerdeath" then -- Can break the sequences
        return true
    end

    if ent:GetName() == "relay_givegravgun_1" and string.lower(input) == "trigger" then
        timer.Simple(1, function() -- maybe this will prevent alyx from constnatly repeating "TAKE DE GRAVITY GUN GORDON"
            for _,ply in ipairs(player.GetAll()) do
                ply:Give("weapon_physcannon")
            end
        end)
    end

    if ent:GetName() == "maker_template_gravgun" and string.lower(input) == "setparent" and not GAMEMODE.MapVars.ShouldNotFreezePlayer then
        GAMEMODE.MapVars.ShouldNotFreezePlayer = true

        for _,ply in ipairs(player.GetAll()) do
            ply:Freeze(false)
            ply:SetHealth(ply:GetMaxHealth()*0.47)
        end
    end

    if !game.SinglePlayer() and ent:GetName() == "ss_dog_gunship_down" and string.lower(input) == "beginsequence" then
        GAMEMODE.MapVars.GunshipDone = true

        for _,ply in ipairs(player.GetLiving()) do
            -- if activator == ply then continue end
            ply:SetPos(Vector(-7936, 5490, 32))
            ply:SetEyeAngles(Angle(0, -90, 0))
        end
    end

    if !game.SinglePlayer() and ent:GetName() == "lcs_al_vanride_end01" and string.lower(input) == "start" then
        for _,ply in ipairs(player.GetLiving()) do
            -- ply:ExitVehicle()
			GAMEMODE:ReplaceSpawnPoint(Vector(4624, 4116, -6342), -90 )
            if not ply:InVehicle() then
                ply:SetPos(Vector(4624, 4116, -6342))
                ply:SetEyeAngles(Angle(0, -90, 0))
            end
        end

        GAMEMODE:CreateSpawnPoint(Vector(4624, 4116, -6342), -90)

        local entity = ents.FindByName("van")[1]
        if entity and entity:IsValid() then
            entity:Fire("lock")
            -- entity:Fire("kill")
        end

        allowunlock = true
    end

    if !game.SinglePlayer() and string.lower(ent:GetName()) == "van" and string.lower(input) == "unlock" and allowunlock then
        for _,ply in ipairs(player.GetAll()) do
            if ply:InVehicle() then
                ply:ExitVehicle()
            end
        end
    end

    if GAMEMODE.EXMode then
        -- if ent:GetName() == "trigger_falldeath" then
        --     PrintMessage(3, "GORDON!!")
        --     print(input)
        -- end

        if ent:GetName() == "message_chapter_title1" and input:lower() == "showmessage" then
            timer.Simple(1.5, function()
                PrintMessage(3, "Chapter A1")
            end)
            timer.Simple(math.Rand(3, 3.5), function()
                PrintMessage(3, "Is this the end of the world?")
            end)
            timer.Simple(10, function()
                PrintMessage(3, "[Alert] While EX mode still has NPC variant on, it will not affect maps experience a lot. It's work in progress. Apologies!")
            end)
            return true
        end
    end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)

