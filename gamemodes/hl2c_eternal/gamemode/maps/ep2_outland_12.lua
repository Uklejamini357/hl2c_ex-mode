NEXT_MAP = "ep2_outland_12a"

if CLIENT then return end

-- Player spawns
function hl2cPlayerSpawn(ply)
end
hook.Add("PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn)


-- Initialize entities
function hl2cMapEdit()

	-- ents.FindByName("player_items_template")[1]:Remove()

	-- if !game.SinglePlayer() then ents.FindByName("boxcar_door_close")[1]:Remove(); end

end
hook.Add("MapEdit", "hl2cMapEdit", hl2cMapEdit)


-- Accept input
function hl2cAcceptInput(ent, input)
	if ent:GetName() == "base_destroy_relay" and input:lower() == "trigger" then
		if GAMEMODE.EXMode then
		gamemode.Call("FailMap", nil, [[It starts with one

One thing, I don't know why
It doesn't even matter how hard you try
Keep that in mind, I designed this rhyme to explain in due time
All I know time is a valuable thing
Watch it fly by as the pendulum swings
Watch it count down to the end of the day, the clock ticks life away

It's so unreal, didn't look out below
Watch the time go right out the window
Tryna hold on, d-didn't even know
I wasted it all just to watch you go

I kept everything inside
And even though I tried, it all fell apart
What it meant to me will eventually be a memory of a time when

I tried so hard and got so far
But in the end, it doesn't even matter
I had to fall to lose it all
But in the end, it doesn't even matter]])
	else
		gamemode.Call("FailMap", nil, "You let the striders destroy the rocket!")
		end
	end
end
hook.Add("AcceptInput", "hl2cAcceptInput", hl2cAcceptInput)
