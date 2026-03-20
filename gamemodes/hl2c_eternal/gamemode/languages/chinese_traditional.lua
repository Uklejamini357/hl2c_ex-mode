--[[
Translations!

Tags: (included at each endline)
TDL - Translated (DeepL)/翻譯（DeepL）
T - Translated (Human)/翻譯（人工） -- you don't need to include this tag
O - Outdated!/過時的！
I - May not be accurate/可能不准確

example:
LANG.test = "Test!" -- (T)
in case of multiple tags:
LANG.test = "Test!" -- (TDL,T,I)
]]

translate.AddLanguage("zh-tw", "繁體中文") -- Chinese (Simplified)

-- HUD
LANG.health = "健康:"
LANG.armor = "盔甲:"
LANG.time_spent = "所用時間：%s"

LANG.team = "TEAM"
LANG.dead = "Dead"


LANG.options = "設置"
LANG.pms = "玩家模型"
LANG.refreshstats = "刷新"
LANG.skills = "技能"
LANG.prestige = "轉生"

-- I decided to name perks "高級技能"(advanced skills) because I didn't find any proper translation.
LANG.perks = "高級技能"
LANG.upgrades = "升級"

-- d - description
-- de - description, endless
-- All of this below: (TDL)
LANG.Defense = "防御"
LANG.Defense_d = "+0.8% 子彈傷害抗性"
LANG.Defense_de = "+2.5%子彈傷害抗性\n15級及以上：對所有傷害來源（槍械除外）的抗性提升2%。"
LANG.Gunnery = "槍械"
LANG.Gunnery_d = "+1% 槍械造成的傷害"
LANG.Gunnery_de = "+3% 槍械造成的傷害\n15級及以上：該屬性的每點數值還會使非槍械武器造成的傷害提升2.5%。"
LANG.Knowledge = "知識"
LANG.Knowledge_d = "+3% 經驗值獲取"
LANG.Knowledge_de = "+5% 經驗值獲取\n15級及以上：+2% 難度提升系數"
LANG.Medical = "醫療"
LANG.Medical_d = "+2% 醫療包效果"
LANG.Medical_de = "+5% 醫療包效果"
LANG.Surgeon = "外科醫生"
LANG.Surgeon_d = "+2% 醫療包最大彈藥量+2% 醫療包充能速度提升"
LANG.Surgeon_de = "+10% 醫療包最大彈藥量+10% 醫療包充能速度提升"
LANG.Vitality = "活力"
LANG.Vitality_d = "+1生命值"
LANG.Vitality_de = "+5生命值"

LANG.inc_sk = "%s 增加了一點"
LANG.inc_sks = "%s 增加了 %d 點"

LANG.in_e_mode = "在無盡模式中："
LANG.in_ne_mode = "非無盡模式："

LANG.cant_spawn_vehicle = "你現在還不能生成載具。"
LANG.cant_spawn_vehicle_cooldown = "你已經生成了一個載具！ 請在 %d 秒後再嘗試。"
LANG.cant_spawn_vehicle_nearby_plrs = "你周圍有玩家！找個空地。"
LANG.cant_spawn_vehicle_no_space = "沒有足夠的空間用來生成載具。"
LANG.cant_spawn_vehicle_airborne = "你不能在空中生成載具。"
LANG.cant_remove_vehicle = "你現在不能移除載具。"

LANG.gained_moneys = "你獲得了 %s 金錢"

LANG.not_admin = "你不是管理員！"
LANG.not_dead = "你還活著！"
LANG.mapchange_cantrespawn = "正在更換地圖，這時你不能重生！"
LANG.cant_respawn = "你無法重生！"

-- Skills and Perks
LANG.skill_need_sp = "你需要技能點來解鎖這個技能！"
LANG.skill_max_reached = "此技能已達到最高上限！"
LANG.skill_increased_lvl = "%s 增加了 %d 點數！"

LANG.perk_noprestige = "不夠的 %s"
LANG.perk_noprestige_points = "需要 %s 個點數!"

LANG.perk_unlocked = "高級技能解鎖: %s"
LANG.eupg_increased = "增加 %s -> %s"

-- Gamemode, and Maps
LANG.game_completed = "恭喜！ 你通關了 %s！"
LANG.game_completed_xp = "你被獎勵了 %s XP."

LANG.game_hl2 = "半條命2"
LANG.game_hl2ep1 = LANG.game_hl2..": 第一部曲"
LANG.game_hl2ep2 = LANG.game_hl2..": 第二部曲"

LANG.hardcore_on = "困難模式已開啟，祝你好運。"
LANG.hardcore_off = "困難模式已關閉。"

LANG.restarting_in_x = "在 %s 中重新啟動地圖"
LANG.restarting_map = "重新加載地圖！"
LANG.switching_map_in_x = "%s中的下一張地圖"
LANG.switching_map = "切換地圖！"
LANG.x_completed_map = "%s 完成了地圖。(%s) [%i of %i]"

LANG.difficulty = "難度："
LANG.difficulty_eff = "效率:"
LANG.you_lost = "你輸了！"
LANG.you_are_dead = "你死了！"
LANG.all_players_died = "所有玩家均已死亡！"
LANG.lose_fzm = "Could not hold off the fast zombies!"
LANG.zms_released = "僵屍被釋放了\n你太慢了！" -- (TDL)
LANG.lose_attempt1 = "你有什麼他媽的計劃？？？想要用這種方式干掉蟻獅守衛？！\n不行！這麼做，你們都失敗了！\n你應該更清楚才對！"
LANG.lose_attempt2 = "你真以為自己能輕松搞定這件事？！"
LANG.lose_attempt3 = "請用正確的方式殺死蟻獅守衛！！"
LANG.lose_attempt4 = "如果你繼續以這種不公平的方式殺掉蟻獅守衛，你是無法繼續進行游戲的"
LANG.lose_attempt5 = "再讓我看見一次，你就會被封禁！！！"
LANG.wrong_pod_taken = "你他媽上錯了，你到底在干什麼？！"
LANG.you_softlocked = "你卡住了"
LANG.you_failed_to_escape = "You failed to escape the endless trap!\nYou had the chance, but you blew it!"
LANG.breen_escaped = "你讓布林博士逃離了！"

LANG.hardcore_intro1 = "你好。"
LANG.hardcore_intro2 = "歡迎來到困難模式"
LANG.hardcore_intro3 = "從現在開始你將無法重生。"
LANG.hardcore_intro4 = "如果所有人死亡了，一切就結束了！"
LANG.hardcore_intro5 = "祝你好運！"

LANG.hardcore_again = "狗屎，又來了。"
LANG.hardcore_run = "這是你的第%s次嘗試."
