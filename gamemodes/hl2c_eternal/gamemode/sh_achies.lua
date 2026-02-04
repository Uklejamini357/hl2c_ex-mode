-- achievements table

GM.Achievements = {}

--[[
name - string or function(completed)
desc - string or function(completed)
tooltip
]]

local function RegisterAchie(id, name, desc, tbl)
	tbl = tbl or {}

	tbl.Name = name
	tbl.Desc = desc
	GM.Achievements[id] = tbl

	return tbl
end

RegisterAchie("welcome_to_c17", "Welcome to City 17.", "It's safer here. Or is it...", {Tooltip = "You never know when things start going crazy..."})
RegisterAchie("meet_alyx", "Overwatch Chaos", "Cause the combine overwatch to be after you.")
RegisterAchie("singularity_collapse", "Singularity Collapse", "Complete Half-Life 2 campaign")
RegisterAchie("citadel_destruction", "Citadel Destruction", "Complete HL2: Episode One")
RegisterAchie("the_end", "The End", "Complete HL2: Episode Two")

-- EX Mode
RegisterAchie("true_destruction", "True Destruction", "Complete HL2 in EX mode")
RegisterAchie("sanity", "Sanity", "Complete HL2 and its episodes in EX mode")
RegisterAchie("absolutely_impossible", "Absolutely Impossible", "Have HL2 and Episodes completions in Hardcore mode, each from the beginning!", {
	Tooltip = "Only counts if you stay alive!"
})

-- HyperEX Mode (soon!)

-- Endless
RegisterAchie("prestiged", "Prestiged", "Prestige for the first time.")
RegisterAchie("eternized", "Eternized", "Eternize for the first time.")
RegisterAchie("truly_hard", "Truly Hard", "Reach 10 K% difficulty")
