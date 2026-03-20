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

translate.AddLanguage("zh-cn", "简体中文") -- Chinese (Simplified)

-- HUD
LANG.health = "健康:"
LANG.armor = "盔甲:"
LANG.time_spent = "所用时间：%s"

LANG.team = "TEAM"
LANG.dead = "Dead"


LANG.options = "设置"
LANG.pms = "玩家模型"
LANG.refreshstats = "刷新"
LANG.skills = "技能"
LANG.prestige = "转生"

-- I decided to name perks "高级技能"(advanced skills) because I didn't find any proper translation.
LANG.perks = "高级技能"
LANG.upgrades = "升级"

-- d - description
-- de - description, endless
-- All of this below: (TDL)
LANG.Defense = "防御"
LANG.Defense_d = "+0.8% 子弹伤害抗性"
LANG.Defense_de = "+2.5%子弹伤害抗性\n15级及以上：对所有伤害来源（枪械除外）的抗性提升2%。"
LANG.Gunnery = "枪械"
LANG.Gunnery_d = "+1% 枪械造成的伤害"
LANG.Gunnery_de = "+3% 枪械造成的伤害\n15级及以上：该属性的每点数值还会使非枪械武器造成的伤害提升2.5%。"
LANG.Knowledge = "知识"
LANG.Knowledge_d = "+3% 经验值获取"
LANG.Knowledge_de = "+5% 经验值获取\n15级及以上：+2% 难度提升系数"
LANG.Medical = "医疗"
LANG.Medical_d = "+2% 医疗包效果"
LANG.Medical_de = "+5% 医疗包效果"
LANG.Surgeon = "外科医生"
LANG.Surgeon_d = "+2% 医疗包最大弹药量+2% 医疗包充能速度提升"
LANG.Surgeon_de = "+10% 医疗包最大弹药量+10% 医疗包充能速度提升"
LANG.Vitality = "活力"
LANG.Vitality_d = "+1生命值"
LANG.Vitality_de = "+5生命值"

LANG.inc_sk = "%s 增加了一点"
LANG.inc_sks = "%s 增加了 %d 点"

LANG.in_e_mode = "在无尽模式中："
LANG.in_ne_mode = "非无尽模式："

LANG.cant_spawn_vehicle = "你现在还不能生成载具。"
LANG.cant_spawn_vehicle_cooldown = "你已经生成了一个载具！ 请在 %d 秒后再尝试。"
LANG.cant_spawn_vehicle_nearby_plrs = "你周围有玩家！找个空地。"
LANG.cant_spawn_vehicle_no_space = "没有足够的空间用来生成载具。"
LANG.cant_spawn_vehicle_airborne = "你不能在空中生成载具。"
LANG.cant_remove_vehicle = "你现在不能移除载具。"

LANG.gained_moneys = "你获得了 %s 金钱"

LANG.not_admin = "你不是管理员！"
LANG.not_dead = "你还活着！"
LANG.mapchange_cantrespawn = "正在更换地图，这时你不能重生！"
LANG.cant_respawn = "你无法重生！"

-- Skills and Perks
LANG.skill_need_sp = "你需要技能点来解锁这个技能！"
LANG.skill_max_reached = "此技能已达到最高上限！"
LANG.skill_increased_lvl = "%s 增加了 %d 点数！"

LANG.perk_noprestige = "不够的 %s"
LANG.perk_noprestige_points = "需要 %s 个点数!"

LANG.perk_unlocked = "高级技能解锁: %s"
LANG.eupg_increased = "增加 %s -> %s"

-- Gamemode, and Maps
LANG.game_completed = "恭喜！ 你通关了 %s！"
LANG.game_completed_xp = "你被奖励了 %s XP."

LANG.game_hl2 = "半条命2"
LANG.game_hl2ep1 = LANG.game_hl2..": 第一部曲"
LANG.game_hl2ep2 = LANG.game_hl2..": 第二部曲"

LANG.hardcore_on = "困难模式已开启，祝你好运。"
LANG.hardcore_off = "困难模式已关闭。"

LANG.restarting_in_x = "在 %s 中重新启动地图"
LANG.restarting_map = "重新加载地图！"
LANG.switching_map_in_x = "%s中的下一张地图"
LANG.switching_map = "切换地图！"
LANG.x_completed_map = "%s 完成了地图。(%s) [%i of %i]"

LANG.difficulty = "难度："
LANG.difficulty_eff = "效率:"
LANG.you_lost = "你输了！"
LANG.you_are_dead = "你死了！"
LANG.all_players_died = "所有玩家均已死亡！"
LANG.lose_fzm = "Could not hold off the fast zombies!"
LANG.zms_released = "僵尸被释放了\n你太慢了！" -- (TDL)
LANG.lose_attempt1 = "你有什么他妈的计划？？？想要用这种方式干掉蚁狮守卫？！\n不行！这么做，你们都失败了！\n你应该更清楚才对！"
LANG.lose_attempt2 = "你真以为自己能轻松搞定这件事？！"
LANG.lose_attempt3 = "请用正确的方式杀死蚁狮守卫！！"
LANG.lose_attempt4 = "如果你继续以这种不公平的方式杀掉蚁狮守卫，你是无法继续进行游戏的"
LANG.lose_attempt5 = "再让我看见一次，你就会被封禁！！！"
LANG.wrong_pod_taken = "你他妈上错了，你到底在干什么？！"
LANG.you_softlocked = "你卡住了"
LANG.you_failed_to_escape = "You failed to escape the endless trap!\nYou had the chance, but you blew it!"
LANG.breen_escaped = "你让布林博士逃离了！"

LANG.hardcore_intro1 = "你好。"
LANG.hardcore_intro2 = "欢迎来到困难模式"
LANG.hardcore_intro3 = "从现在开始你将无法重生。"
LANG.hardcore_intro4 = "如果所有人死亡了，一切就结束了！"
LANG.hardcore_intro5 = "祝你好运！"

LANG.hardcore_again = "狗屎，又来了。"
LANG.hardcore_run = "这是你的第%s次尝试."
