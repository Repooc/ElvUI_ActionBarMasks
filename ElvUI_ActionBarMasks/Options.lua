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
	local shape = E.db.abm.general.shape or 'circle'
	return maskDB[shape].borders
end

local function actionSubGroup(info, ...)
	if info.type == 'color' then
		local t = E.db.abm[info[#info-2]][info[#info-1]][info[#info]]
		local r, g, b, a = ...
		if r then
			t.r, t.g, t.b, t.a = r, g, b, a
		else
			local d = P.abm[info[#info-2]][info[#info-1]][info[#info]]
			return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
		end
	else
		local value = ...
		if value ~= nil then
			E.db.abm[info[#info-2]][info[#info-1]][info[#info]] = value
		else
			return E.db.abm[info[#info-2]][info[#info-1]][info[#info]]
		end
	end
	ABM:UpdateOptions()
end

local function configTable()
	local abm = ACH:Group('|cFF16C3F2ActionBar|r Masks', nil, 6, 'tab', nil, nil, function() return not AB.Initialized end)
	E.Options.args.abm = abm

	local General = ACH:Group(L["Mask & Glow Options"], nil, 0, nil, function(info) return E.db.abm.general[info[#info]] end, function(info, value) E.db.abm.general[info[#info]] = value ABM:UpdateOptions() end)
	abm.args.general = General
	General.args.enable = ACH:Toggle(L["Enable"], nil, 0, nil, nil, nil, nil, function(info, value) E.db.abm.general[info[#info]] = value E.ShowPopup = true end, not AB.Initialized or false)
	General.args.spacer1 = ACH:Spacer(1, 'full')
	General.args.shape = ACH:Select(L["Mask Shape"], nil, 2, {circle = 'Circle', hexagon = 'Hexagon', pentagon = 'Pentagon', square = 'Square'}, nil, nil, nil, nil, nil, function() return not AB.Initialized or not E.db.abm.general.enable end)
	General.args.spacer2 = ACH:Spacer(3, 'full')

	local Border = ACH:Group(L["Border & Texture Options"], nil, 5, nil, function(info) return E.db.abm.general.border[info[#info]] end, function(info, value) E.db.abm.general.border[info[#info]] = value ABM:UpdateOptions() end, function() return not AB.Initialized or not E.db.abm.general.enable end)
	General.args.border = Border
	Border.inline = true
	Border.args.color = ACH:Color(L["Color"], desc, 1, true, nil, actionSubGroup, actionSubGroup)
	Border.args.style = ACH:Select(L["Style"], nil, 2, GetBorderValues, nil, 225, function() local _, border = ABM:GetValidBorder() return border end)

	local Shadow = ACH:Group(L["Shadow Options"], nil, 10, nil, actionSubGroup, actionSubGroup, function() return not AB.Initialized or not E.db.abm.general.enable end, function() return E.db.abm.general.shape ~= 'square' or E.db.abm.general.border.style == 'border100' end)
	General.args.shadow = Shadow
	Shadow.inline = true
	Shadow.args.enable = ACH:Toggle(L["Enable"], nil, 1)
	Shadow.args.color = ACH:Color(L["Color"], desc, 2, true)

	local Proc = ACH:Group(L["Spell Proc Glow"], nil, 15, nil, actionSubGroup, actionSubGroup, function() return not AB.Initialized or not E.db.abm.general.enable or not E.db.abm.general.proc.enable end, function() return E.db.abm.general.shape == 'square' end)
	General.args.proc = Proc
	Proc.inline = true
	Proc.args.enable = ACH:Toggle(L["Enable"], nil, 0, nil, nil, nil, nil, nil, function() return not AB.Initialized or not E.db.abm.general.enable end)
	Proc.args.pulse = ACH:Toggle(L["Pulse"], nil, 1)
	Proc.args.spin = ACH:Toggle(L["Spin"], nil, 2)
	Proc.args.spacer1 = ACH:Spacer(3, 'full')
	Proc.args.color = ACH:Color(L["Color"], desc, 4, true)
	Proc.args.style = ACH:Select(L["Style"], nil, 5, {pixel = 'Pixel', solid = 'Solid'})
	Proc.args.speed = ACH:Range(L["SPEED"], L["The lower the setting, the faster.  This value represents the time it takes to rotate 360 degrees."], 6, { min = 0.1, max = 30, softMin = 0.1, softMax = 20, step = 0.1 }, nil, nil, nil, disabled, hidden)

	local Help = ACH:Group(L["Help"], nil, 99, nil, nil, nil, false)
	abm.args.help = Help

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

	local Testers = ACH:Group(L["Help Testing Development Versions"], nil, 7)
	Help.args.testers = Testers
	Testers.inline = true
	Testers.args.string = ACH:Description(TESTER_STRING, 1, 'medium')

	local Donators = ACH:Group(L["Donators"], nil, 8)
	Help.args.donators = Donators
	Donators.inline = true
	Donators.args.string = ACH:Description(DONATOR_STRING, 1, 'medium')
end

tinsert(ABM.Configs, configTable)
