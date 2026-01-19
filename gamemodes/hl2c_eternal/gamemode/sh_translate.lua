-- Translation library by William Moodhe
-- Feel free to use this in your own addons.
-- See the languages folder to add your own languages.

--[[Copied from ZS because was too lazy to add one by myself, anyways it was edited a bit for file reduce]]

translate = {}
local translate = translate

local Languages = {}
local Translations = {}
local AddingLanguage
local DefaultLanguage = "en"
local CurrentLanguage = DefaultLanguage

if CLIENT then
	-- Need to make a new convar since gmod_language isn't sent to server.
	CreateClientConVar("gmod_language_rep", "en", false, true)

	timer.Create("checklanguagechange", 1, 0, function()
		CurrentLanguage = GetConVar("gmod_language"):GetString()
		if CurrentLanguage ~= GetConVar("gmod_language_rep"):GetString() then
			-- Let server know our language changed.
			RunConsoleCommand("gmod_language_rep", CurrentLanguage)
		end
	end)
end

local translate_GetLanguages
local translate_GetLanguageName
local translate_GetTranslations
local translate_AddLanguage
local translate_AddTranslation
local translate_Get
local translate_Format
local translate_ClientGet
local translate_ClientFormat
local plPrintMessage

function translate.GetLanguages()
	return Languages
end

function translate.GetLanguageName(short)
	return Languages[short]
end

function translate.GetTranslations(short)
	return Translations[short] or Translations[DefaultLanguage]
end

function translate.AddLanguage(short, long)
	Languages[short] = long
	Translations[short] = Translations[short] or {}
	AddingLanguage = short
end

function translate.AddTranslation(id, text)
	if not AddingLanguage or not Translations[AddingLanguage] then return end

	Translations[AddingLanguage][id] = text
end

local function returnDefault(id)
	return GAMEMODE.DebugTranslate and "@"..id.."@" or id
end

function translate.Get(id)
	if GAMEMODE.DebugNoTranslate then
		return returnDefault(id)
	end

	return translate_GetTranslations(CurrentLanguage)[id] or translate_GetTranslations(DefaultLanguage)[id] or returnDefault(id)
end

function translate.Format(id, ...)
	return string.format(translate_Get(id), ...)
end

if SERVER then
	function translate.ClientGet(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate_Get(...)
	end

	function translate.ClientFormat(pl, ...)
		CurrentLanguage = pl:GetInfo("gmod_language_rep")
		return translate_Format(...)
	end

	function PrintTranslatedMessage(printtype, str, ...)
		for _, pl in ipairs(player.GetAll()) do
			pl:PrintMessage(printtype, translate_ClientFormat(pl, str, ...))
		end
	end
end

if CLIENT then
	function translate.ClientGet(_, ...)
		return translate_Get(...)
	end
	function translate.ClientFormat(_, ...)
		return translate_Format(...)
	end
end

translate_GetLanguages = translate.GetLanguages
translate_GetLanguageName = translate.GetLanguageName
translate_GetTranslations = translate.GetTranslations
translate_AddLanguage = translate.AddLanguage
translate_AddTranslation = translate.AddTranslation
translate_Get = translate.Get
translate_Format = translate.Format
translate_ClientGet = translate.ClientGet
translate_ClientFormat = translate.ClientFormat


local function AddLanguages(late)
	local GM = GM or GAMEMODE
	for i, filename in pairs(file.Find(GM.FolderName.."/gamemode/"..(late and "late_languages" or "languages").."/*.lua", "LUA")) do
		LANG = {}
		AddCSLuaFile((late and "late_languages" or "languages").."/"..filename)
		include((late and "late_languages" or "languages").."/"..filename)
		for k, v in pairs(LANG) do
			translate_AddTranslation(k, v)
		end
		LANG = nil
	end
end

AddLanguages()

/* -- Not working due to ERROR
timer.Simple(0, function()
	AddLanguages(true)
end)
*/

local meta = FindMetaTable("Player")
if not meta then return end

plPrintMessage = meta.PrintMessage
function meta:PrintTranslatedMessage(hudprinttype, translateid, ...)
	if ... ~= nil then
		plPrintMessage(self, hudprinttype, translate.ClientFormat(self, translateid, ...))
	else
		plPrintMessage(self, hudprinttype, translate.ClientGet(self, translateid))
	end
end
