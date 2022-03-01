local E, L, _, P, _ = unpack(ElvUI)
local RAB = E:GetModule('ElvUI_ActionBarMasks')
local AB = E.ActionBars
local ACH = E.Libs.ACH

local function GetBorderValues()
	local maskDB = RAB:GetMaskDB()
	local shape = E.db.rab.general.shape or 'circle'
	return maskDB[shape].borders
end

local function configTable()
	local rab = ACH:Group('|cFF16C3F2Actionbar|r Masks', nil, 6, 'tab', nil, nil, function() return not AB.Initialized end)
	E.Options.args.rab = rab

	local General = ACH:Group(L["Mask & Proc Settings"], nil, 0, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value RAB:UpdateOptions() end)
	rab.args.general = General
	General.args.enable = ACH:Toggle(L["Enable"], nil, 0, nil, nil, nil, nil, function(info, value) E.db.rab.general[info[#info]] = value E.ShowPopup = true end, not AB.Initialized or false)
	General.args.spacer1 = ACH:Spacer(1, 'full')
	General.args.shape = ACH:Select(L["Mask Shape"], nil, 2, {circle = 'Circle', hexagon = 'Hexagon', pentagon = 'Pentagon'}, nil, nil, nil, nil, function() return not AB.Initialized or not E.db.rab.general.enable end)
	General.args.spacer2 = ACH:Spacer(3, 'full')

	local Border = ACH:Group(L["Border Settings"], nil, 10, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value RAB:UpdateOptions() end, function() return not AB.Initialized or not E.db.rab.general.enable end)
	General.args.Border = Border
	Border.inline = true
	Border.args.borderColor = ACH:Color(L["Color"], desc, 1, true, width, function(info)
		local c = E.db.rab.general[info[#info]]
		local d = P.rab.general[info[#info]]
		return c.r, c.g, c.b, c.a, d.r, d.g, d.b, d.a
	end, function(info, r, g, b, a)
		local c = E.db.rab.general[info[#info]]
		c.r, c.g, c.b, c.a = r, g, b, a
		RAB:UpdateOptions()
	end)
	Border.args.borderStyle = ACH:Select(L["Style"], nil, 2, GetBorderValues, nil, nil, function() local _, border = RAB:GetValidBorder() return border end)

	local Proc = ACH:Group(L["Proc Settings"], nil, 15, nil, function(info) return E.db.rab.general[info[#info]] end, function(info, value) E.db.rab.general[info[#info]] = value RAB:UpdateOptions() end, function() return not AB.Initialized or not E.db.rab.general.enable or not E.db.rab.general.procEnable end)
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
		RAB:UpdateOptions()
	end)
	Proc.args.procStyle = ACH:Select(L["Style"], nil, 4, {pixel = 'Pixel', solid = 'Solid'})
end

tinsert(RAB.Configs, configTable)
