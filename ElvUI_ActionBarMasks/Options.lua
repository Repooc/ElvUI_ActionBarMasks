local E, L, _, P, _ = unpack(ElvUI)
local ABM = E:GetModule('ElvUI_ActionBarMasks')
local ABMCL = E:GetModule('ABM-Changelog')
local AB = E.ActionBars
local ACH = E.Libs.ACH

local DONATORS = {
	'None to be displayed at this time.',
}

local DEVELOPERS = {
	'|cff82B4ffEltreum|r',
}

local TESTERS = {
	'|cffeb9f24Tukui Community|r',
	'Linaori',
}

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end

sort(DONATORS, SortList)
sort(DEVELOPERS, SortList)
sort(TESTERS, SortList)

local DONATOR_STRING = table.concat(DONATORS, '|n')
local DEVELOPER_STRING = table.concat(DEVELOPERS, '|n')
local TESTER_STRING = table.concat(TESTERS, '|n')

local function GetBorderValues()
	local maskDB = ABM:GetMaskDB()
	local shape = E.db.rab.general.shape or 'circle'
	return maskDB[shape].borders
end

local function configTable()
	local rab = ACH:Group('|cFF16C3F2ActionBar|r Masks', nil, 6, 'tab', nil, nil, function() return not AB.Initialized end)
	E.Options.args.rab = rab

	local General = ACH:Group(L["Mask & Proc Settings"], nil, 0, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value ABM:UpdateOptions() end)
	rab.args.general = General
	General.args.enable = ACH:Toggle(L["Enable"], nil, 0, nil, nil, nil, nil, function(info, value) E.db.rab.general[info[#info]] = value E.ShowPopup = true end, not AB.Initialized or false)
	General.args.spacer1 = ACH:Spacer(1, 'full')
	General.args.shape = ACH:Select(L["Mask Shape"], nil, 2, {circle = 'Circle', hexagon = 'Hexagon', pentagon = 'Pentagon'}, nil, nil, nil, nil, function() return not AB.Initialized or not E.db.rab.general.enable end)
	General.args.spacer2 = ACH:Spacer(3, 'full')

	local Border = ACH:Group(L["Border Settings"], nil, 10, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value ABM:UpdateOptions() end, function() return not AB.Initialized or not E.db.rab.general.enable end)
	General.args.Border = Border
	Border.inline = true
	Border.args.borderColor = ACH:Color(L["Color"], desc, 1, true, width, function(info)
		local c = E.db.rab.general[info[#info]]
		local d = P.rab.general[info[#info]]
		return c.r, c.g, c.b, c.a, d.r, d.g, d.b, d.a
	end, function(info, r, g, b, a)
		local c = E.db.rab.general[info[#info]]
		c.r, c.g, c.b, c.a = r, g, b, a
		ABM:UpdateOptions()
	end)
	Border.args.borderStyle = ACH:Select(L["Style"], nil, 2, GetBorderValues, nil, nil, function() local _, border = ABM:GetValidBorder() return border end)

	local Proc = ACH:Group(L["Proc Settings"], nil, 15, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value ABM:UpdateOptions() end, function() return not AB.Initialized or not E.db.rab.general.enable or not E.db.rab.general.procEnable end)
	General.args.proc = Proc
	Proc.inline = true
	Proc.args.procEnable = ACH:Toggle(L["Enable"], nil, 0, nil, nil, nil, nil, nil, function() return not AB.Initialized or not E.db.rab.general.enable end)
	Proc.args.procPulse = ACH:Toggle(L["Pulse"], nil, 1)
	Proc.args.procSpin = ACH:Toggle(L["Spin"], nil, 2)
	Proc.args.procColor = ACH:Color(L["Color"], desc, 3, true, width, function(info)
		local c = E.db.rab.general[info[#info]]
		local d = P.rab.general[info[#info]]
		return c.r, c.g, c.b, c.a, d.r, d.g, d.b, d.a
	end, function(info, r, g, b, a)
		local c = E.db.rab.general[info[#info]]
		c.r, c.g, c.b, c.a = r, g, b, a
		ABM:UpdateOptions()
	end)
	Proc.args.procStyle = ACH:Select(L["Style"], nil, 4, {pixel = 'Pixel', solid = 'Solid'})

	local Help = ACH:Group(L["Help"], nil, 99, nil, nil, nil, false)
	rab.args.help = Help

	local Support = ACH:Group(L["Support"], nil, 1)
	Help.args.support = Support
	Support.inline = true
	Support.args.wago = ACH:Execute(L["Wago Page"], nil, 1, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://addons.wago.io/addons/elvui-actionbarmasks') end, nil, nil, 140)
	Support.args.curse = ACH:Execute(L["Curseforge Page"], nil, 1, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://www.curseforge.com/wow/addons/actionbar-masks-elvui-plugin') end, nil, nil, 140)
	Support.args.git = ACH:Execute(L["Ticket Tracker"], nil, 2, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://github.com/Repooc/ElvUI_ActionBarMasks/issues') end, nil, nil, 140)
	Support.args.discord = ACH:Execute(L["Discord"], nil, 3, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://discord.gg/') end, nil, nil, 140, nil, nil, true)

	local Download = ACH:Group(L["Download"], nil, 2)
	Help.args.download = Download
	Download.inline = true
	Download.args.development = ACH:Execute(L["Development Version"], L["Link to the latest development version."], 1, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://github.com/Repooc/ElvUI_ActionBarMasks/archive/refs/heads/main.zip') end, nil, nil, 140)
	Download.args.changelog = ACH:Execute(L["Changelog"], nil, 3, function() if ABM_Changelog and ABM_Changelog:IsShown() then ABM:Print('ActionBar Masks changelog is already being displayed.') else ABMCL:ToggleChangeLog() end end, nil, nil, 140)

	local Credits = ACH:Group(L["Credits"], nil, 5)
	Help.args.credits = Credits
	Credits.inline = true
	Credits.args.string = ACH:Description(E:TextGradient(L["ABM_CREDITS"], 0.27,0.72,0.86, 0.51,0.36,0.80, 0.69,0.28,0.94, 0.94,0.28,0.63, 1.00,0.51,0.00, 0.27,0.96,0.43), 1, 'medium')

	local Coding = ACH:Group(L["Textures/Coding"], nil, 6)
	Help.args.coding = Coding
	Coding.inline = true
	Coding.args.string = ACH:Description(DEVELOPER_STRING, 1, 'medium')

	local Testers = ACH:Group(L["Help Test Dev Versions"], nil, 7)
	Help.args.testers = Testers
	Testers.inline = true
	Testers.args.string = ACH:Description(TESTER_STRING, 1, 'medium')

	local Donators = ACH:Group(L["Donators"], nil, 8)
	Help.args.donators = Donators
	Donators.inline = true
	Donators.args.string = ACH:Description(DONATOR_STRING, 1, 'medium')
end

tinsert(ABM.Configs, configTable)
