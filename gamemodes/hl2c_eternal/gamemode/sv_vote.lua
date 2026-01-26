GM.VoteSystem = {}
GM.VoteSystem.Voted = {}
GM.VoteSystem.Required = 0.55
GM.VoteSystem.Cooldown = 60


local DoRestartMapVote
local EvaluateVotes
local VoteComplete

function DoRestartMapVote(pl)
	local V = GAMEMODE.VoteSystem

	local last = V.LastVoted or 0
	if last + 120 > CurTime() then
		pl:PrintMessage(3, string.format("You cannot vote to restart the map yet. (Wait %d seconds)", last+120 - CurTime()))
		return
	end

	if not table.HasValue(V.Voted, pl) then
		table.insert(V.Voted, pl)

		local count = EvaluateVotes(pl)
		local reqcount = math.ceil(#player.GetHumans()*V.Required)

		PrintMessage(3, string.format("%s has voted to restart the map. (%d of %d)", pl:Nick(), count, reqcount))

		if count >= reqcount then
			VoteComplete()
		end
	end
end

function EvaluateVotes(pl)
	local V = GAMEMODE.VoteSystem
	for id,ply in pairs(V.Voted) do
		if !IsValid(ply) then
			V.Voted[id] = nil
			continue
		end
	end

	return table.Count(V.Voted)	
end

function VoteComplete()
	local V = GAMEMODE.VoteSystem

	V.Cooldown = CurTime() + 120
	table.Empty(V.Voted)
	V.LastVoted = CurTime()

	PrintMessage(3, "Restarting...")

	gamemode.Call("RestartMap", 0.01)
end

hook.Add("PlayerSay", "hl2ce_RestartMapVote", function(ply, text)
	if string.Explode(" ", text)[1] == "!voterestart" then
		DoRestartMapVote(ply)
		return ""
	end
end)
