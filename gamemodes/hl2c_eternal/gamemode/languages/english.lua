--[[
Translations!

Tags: (included at each endline)
TDL - Translated (DeepL)/翻译（DeepL）
T - Translated (Human)/翻译（人工） -- you don't need to include this tag
O - Outdated!/过时的！
I - May not be accurate/可能不准确

example:
LANG.test = "Test!" -- (T)
in case of multiple tags:
LANG.test = "Test!" -- (TDL,T,I)
]]

translate.AddLanguage("en", "English")

-- HUD
LANG.health = "Health:"
LANG.armor = "Armor:"

LANG.team = "TEAM"
LANG.dead = "Dead"


LANG.options = "Options"
LANG.pms = "Playermodels"
LANG.refreshstats = "Refresh Stats"
LANG.skills = "Skills"
LANG.prestige = "Prestige"
LANG.perks = "Perks"
LANG.upgrades = "Upgrades"

-- d - description
-- de - description, endless
LANG.Defense = "Defense"
LANG.Defense_d = "+0.8% Resistance to enemy bullet damage"
LANG.Defense_de = "+2.5% Resistance to enemy bullet damage\nLevel 15 and above: Increases resistance to all damage sources (except firearms) by 2.5%."
LANG.Gunnery = "Gunnery"
LANG.Gunnery_d = "+1% damage dealt by firearms"
LANG.Gunnery_de = "+3% damage dealt with firearms\nLevel 15 and above: Each point of this attribute also increases damage dealt by non-firearm weapons by 2.5%."
LANG.Knowledge = "Knowledge"
LANG.Knowledge_d = "+3% experience points gained"
LANG.Knowledge_de = "+5% experience points gained\nLevel 15 and above: +2% difficulty increase factor"
LANG.Medical = "Medical"
LANG.Medical_d = "+2% effectiveness to medkits"
LANG.Medical_de = "+5% effectiveness to medkits"
LANG.Surgeon = "Surgeon"
LANG.Surgeon_d = "+2% max ammo to medkits / +2% increased medkit recharge speed"
LANG.Surgeon_de = "+10% max ammo to medkits / +10% increased medkit recharge speed"
LANG.Vitality = "Vitality"
LANG.Vitality_d = "+1 health"
LANG.Vitality_de = "+5 health"

LANG.inc_sk = "Increase %s by 1 point"
LANG.inc_sks = "Increase %s by %d points"

LANG.in_e_mode = "In Endless mode:"
LANG.in_ne_mode = "In Non-Endless mode:"

LANG.cant_spawn_vehicle = "You may not spawn a vehicle at this time."
LANG.cant_spawn_vehicle_cooldown = "You've already spawned a vehicle! Try again in %d seconds!"
LANG.cant_spawn_vehicle_nearby_plrs = "There are players around you! Find an open space to spawn your vehicle."
LANG.cant_spawn_vehicle_no_space = "Insufficient space for spawning in a vehicle!"
LANG.cant_spawn_vehicle_airborne = "You can't spawn a vehicle while airborne!"
LANG.cant_remove_vehicle = "You may not remove your vehicle at this time."

LANG.gained_add_xp = "You were given additional %s XP for completing this map."
LANG.gained_moneys = "You have gained +%s moneys"

LANG.not_admin = "You are not an admin!"
LANG.not_dead = "You are not dead!"
LANG.mapchange_cantrespawn = "Map is currenlty being changed, you can't respawn at this time!"
LANG.cant_respawn = "You cannot respawn now. Sorry!"

-- Skills and Perks
LANG.skill_need_sp = "You need Skill Points to upgrade this skill!"
LANG.skill_max_reached = "You have reached the max amount of points for this skill!"
LANG.skill_increased_lvl = "Increased %s by %d point(s)!"

LANG.perk_noprestige = "Not enough %s"
LANG.perk_noprestige_points = "Not enough %s Points!"
LANG.perk_unlocked = "Perk Unlocked: %s"
LANG.eupg_increased = "Increased %s -> %s"


-- Gamemode, and Maps
LANG.game_completed = "Congratulations! You have completed %s!"
LANG.game_completed_xp = "You were awarded %s XP."

LANG.game_hl2 = "Half-Life 2"
LANG.game_hl2ep1 = LANG.game_hl2..": Episode One"
LANG.game_hl2ep2 = LANG.game_hl2..": Episode Two"

LANG.hardcore_on = "Hardcore mode enabled. Good luck..."
LANG.hardcore_off = "Hardcore mode disabled."

LANG.x_completed_map = "%s has completed the map. (%s) [%i of %i]"


LANG.difficulty = "Difficulty:"
LANG.you_lost = "You lost!"
LANG.all_players_died = "All players have died!"
LANG.lose_fzm = "Could not hold off the fast zombies!"
LANG.zms_released = "ZOMBIES ARE RELEASED\nYOU TOOK TOO LONG!"
LANG.lose_attempt1 = "The hell was your plan?! killing the antlion guard the easy way?!\nNo! This whole plan caused your team to fail!\nYou should know better!"
LANG.lose_attempt2 = "Do you really think you can handle this with ease?!"
LANG.lose_attempt3 = "Kill the antlion guard the intended way!!"
LANG.lose_attempt4 = "You will not be able to progress if you keep killing the antlion guard unfairly"
LANG.lose_attempt5 = "ONE MORE TIME I SEE THIS. AND YOU WILL BE BANNED!!!"
LANG.wrong_pod_taken = "BRUHHHHHHHHHHH YOU TOOK THE WRONG POD WHAT IS WRONG WITH YOU?!"
LANG.you_softlocked = "you softlocked yourself"
LANG.you_failed_to_escape = "You failed to escape the endless trap!\nYou had the chance, but you blew it!"
LANG.breen_escaped = "You let Dr. Breen escape!"

LANG.hardcore_intro1 = "Hi."
LANG.hardcore_intro2 = "Welcome to hardcore mode."
LANG.hardcore_intro3 = "Past this point you may not respawn anymore."
LANG.hardcore_intro4 = "If all players die, the run is over!"
LANG.hardcore_intro5 = "Good luck!"

LANG.hardcore_again = "Ah shit, here we go again."
LANG.hardcore_run = "This is your %s run."

