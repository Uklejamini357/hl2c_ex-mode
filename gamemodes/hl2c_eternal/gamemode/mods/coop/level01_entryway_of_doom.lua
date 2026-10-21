NEXT_MAP = "level02_tricks_and_traps"

if CLIENT then return end

hook.Add("AcceptInput", "coop", function(ent, input)
    if ent:GetName() == "musique01" and input:lower() == "playsound" then
        PrintMessage(3, "welcome to hell")
    end
end)
