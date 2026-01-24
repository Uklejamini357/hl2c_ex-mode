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

-- d - description
-- de - description, endless
-- All of this below: (TDL)
LANG.Defense = "防御"
LANG.Defense_d = "+0.8% 敌方子弹伤害抗性" -- (TDL)
LANG.Defense_de = "+2.5% 敌方子弹伤害抗性\n15级及以上：对所有伤害来源（枪械除外）的抗性提升2%。" -- (TDL)
LANG.Gunnery = "炮术"
LANG.Gunnery_d = "+1% 火器造成的伤害"
LANG.Gunnery_de = "+3% 火器造成的伤害\n15级及以上：该属性的每点数值还会使非枪械武器造成的伤害提升2.5%。"
LANG.Knowledge = "知识"
LANG.Knowledge_d = "+3% 经验值获取"
LANG.Knowledge_de = "+5% 经验值获取\n15级及以上：+2% 难度提升系数"
LANG.Medical = "医疗"
LANG.Medical_d = "+2% 急救包效果"
LANG.Medical_de = "+5% 急救包效果"
LANG.Surgeon = "外科医生"
LANG.Surgeon_d = "+2% 医疗包最大弹药量+2% 医疗包充能速度提升"
LANG.Surgeon_de = "+10% 医疗包最大弹药量+10% 医疗包充能速度提升"
LANG.Vitality = "活力"
LANG.Vitality_d = "+1生命值"
LANG.Vitality_de = "+5生命值"

LANG.inc_sk = "Increase %s by 1 point"
LANG.inc_sks = "Increase %s by %d points"

LANG.in_e_mode = "在无限模式中：" -- (TDL)
LANG.in_ne_mode = "非无限模式：" -- (TDL,I)

-- Gamemode, and Maps
LANG.x_completed_map = "%s 完成了地图。(%s) [%i of %i]"


-- All of this below, except english: (TDL)
LANG.difficulty = "难度："
LANG.you_lost = "你输了！"
LANG.all_players_died = "所有玩家均已阵亡！" -- (TDL,I)
LANG.lose_fzm = "Could not hold off the fast zombies!"
LANG.zms_released = "僵尸被释放了\n你太慢了！" -- (TDL,I)
LANG.lose_attempt1 = "你他妈的计划是什么？！想用捷径干掉蚁狮守卫？！\n不行！整个计划都害得你们团队失败了！\n你应该更清楚才对！" -- (TDL,I)
LANG.lose_attempt2 = "你真以为自己能轻松搞定这件事？！"
LANG.lose_attempt3 = "Kill the antlion guard the intended way!!"
LANG.lose_attempt4 = "You will not be able to progress if you keep killing the antlion guard unfairly"
LANG.lose_attempt5 = "ONE MORE TIME I SEE THIS. AND YOU WILL BE BANNED!!!"
LANG.wrong_pod_taken = "BRUHHHHHHHHHHH YOU TOOK THE WRONG POD WHAT IS WRONG WITH YOU?!"
LANG.you_softlocked = "你卡住了"
LANG.you_failed_to_escape = "You failed to escape the endless trap!\nYou had the chance, but you blew it!"
LANG.breen_escaped = "You let Dr. Breen escape!"
