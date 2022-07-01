local E = unpack(ElvUI)
local ABM = E:GetModule('ElvUI_ActionBarMasks')
local S = E:GetModule('Skins')

local module = E:NewModule('ABM-Changelog', 'AceEvent-3.0', 'AceTimer-3.0')
local format, gsub, find = string.format, string.gsub, string.find

local ChangelogTBL = {
	'v1.15 6/30/2022',
		"• toc bump",
	' ',
	'v1.14 4/24/2022',
		"• Add Pentagon 2 shape",
		"• Fixed a weird border issue with Thin Border option disabled in ElvUI",
	' ',
	'v1.13 3/20/2022',
		"• Hotfix changelog error",
	' ',
	'v1.12 3/20/2022',
		"• Color url's posted in the changelog if any get posted (thanks mera)",
		"• some database conversion done... sorry if i typo'd something and you have to redo the settings...",
		"• changelog will not show if you are in combat upon logging in/reloading ui after an update but should show after combat has ended",
		'• New Shape Added - Octagon',
	' ',
	'v1.11 3/19/2022',
		'• Redid changelong frame',
	' ',
	'v1.10 3/19/2022',
		'• Hot fix migration script',
	' ',
	'v1.09 3/19/2022',
		'• |cffff0000WARNING:|r Database structure was reorganized.  Conversion should automatically happen but may not work 100% as intended :D',
		'• fix hotkey text hiding itself when altering the bar settings',
		'• added a square shape that is a bit more limited in regards to the proc settings as it just follows what elvui uses in General -> Cosmetics section',
		'• added basic shadow options for square masks',
		'• fixed count text strata',
	' ',
	'v1.08 3/12/2022',
		'• fix hotkey text not showing properly',
	' ',
	'v1.07 3/5/2022',
		'• fix trimming of icon on the actionbars/petbar',
	' ',
	'v1.06 3/5/2022',
		'• make the buttons match more to how elvui buttons appear with the "Show Empty Buttons" option enabled',
		'• trim stance bar icon when "Keep Size Ratio" is disabled',
		'• added a Help/Information panel',
		'• added speed option to adjust the speed of the spinning',
	' ',
	'v1.05 3/2/2022',
		'• fixed proc look when actionbar setting for keep aspect ratio was disabled and button width and height were not equal',
		'• add option to stop the proc from spinning',
		'• add stance bar to supported bar to mask',
	' ',
	'v1.04 3/1/2022',
		'• fixed missing image',
	' ',
	'v1.03 3/1/2022',
		'• Added Hexagon and Pentagon Shapes',
		'• Added Multiple borders for all shapes (mainly circle ones for now)',
		'• Added Options for border and border color as well as a replacement for a proc since the ElvUI square one doesnt exactly fit, may add option to use elvui\'s instead though if people want the square one back',
	' ',
	'v1.02 2/20/2022',
		'• Fixed messed up rename',
	' ',
	'v1.01 2/18/2022',
		'• Renamed project',
	' ',
	'v1.00 2/17/2022',
		'• Initial Release',
		-- "• ''",
}

local URL_PATTERNS = {
	'^(%a[%w+.-]+://%S+)',
	'%f[%S](%a[%w+.-]+://%S+)',
	'^(www%.[-%w_%%]+%.(%a%a+))',
	'%f[%S](www%.[-%w_%%]+%.(%a%a+))',
	'(%S+@[%w_.-%%]+%.(%a%a+))',
}

local function formatURL(url)
	url = '|cff'..'149bfd'..'|Hurl:'..url..'|h['..url..']|h|r ';
	return url
end

local function ModifiedLine(string)
	local newString = string
	for _, v in pairs(URL_PATTERNS) do
		if find(string, v) then
			newString = gsub(string, v, formatURL('%1'))
		end
	end
	return newString
end

local changelogLines = {}
local function GetNumLines()
   local index = 1
   for i = 1, #ChangelogTBL do
		local line = ModifiedLine(ChangelogTBL[i])
		changelogLines[index] = line

		index = index + 1
   end
   return index - 1
end

function module:CountDown()
	module.time = module.time - 1

	if module.time == 0 then
		module:CancelAllTimers()
		ABMChangelog.close:Enable()
		ABMChangelog.close:SetText(CLOSE)
	else
		ABMChangelog.close:Disable()
		ABMChangelog.close:SetText(CLOSE..format(' (%s)', module.time))
	end
end

function module:CreateChangelog()
	local Size = 500
	local frame = CreateFrame('Frame', 'ABMChangelog', E.UIParent)
	tinsert(_G.UISpecialFrames, 'ABMChangelog')
	frame:SetTemplate('Transparent')
	frame:Size(Size, Size)
	frame:Point('CENTER', 0, 0)
	frame:Hide()
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetResizable(true)
	frame:SetMinResize(350, 100)
	frame:SetScript('OnMouseDown', function(changelog, button)
		if button == 'LeftButton' and not changelog.isMoving then
			changelog:StartMoving()
			changelog.isMoving = true
		elseif button == 'RightButton' and not changelog.isSizing then
			changelog:StartSizing()
			changelog.isSizing = true
		end
	end)
	frame:SetScript('OnMouseUp', function(changelog, button)
		if button == 'LeftButton' and changelog.isMoving then
			changelog:StopMovingOrSizing()
			changelog.isMoving = false
		elseif button == 'RightButton' and changelog.isSizing then
			changelog:StopMovingOrSizing()
			changelog.isSizing = false
		end
	end)
	frame:SetScript('OnHide', function(changelog)
		if changelog.isMoving or changelog.isSizing then
			changelog:StopMovingOrSizing()
			changelog.isMoving = false
			changelog.isSizing = false
		end
	end)
	frame:SetFrameStrata('DIALOG')

	local header = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
	header:Point('TOPLEFT', frame, 0, 0)
	header:Point('TOPRIGHT', frame, 0, 0)
	header:Point('TOP')
	header:SetHeight(25)
	header:SetTemplate('Transparent')
	header.text = header:CreateFontString(nil, 'OVERLAY')
	header.text:FontTemplate(nil, 15, 'OUTLINE')
	header.text:SetHeight(header.text:GetStringHeight()+30)
	header.text:SetText(format('%s - Changelog |cff00c0fa%s|r', ABM.Title, ABM.Version))
	header.text:SetTextColor(1, 0.8, 0)
	header.text:Point('CENTER', header, 0, -1)

	local footer = CreateFrame('Frame', nil, frame)
	footer:Point('BOTTOMLEFT', frame, 0, 0)
	footer:Point('BOTTOMRIGHT', frame, 0, 0)
	footer:Point('BOTTOM')
	footer:SetHeight(30)
	footer:SetTemplate('Transparent')

	local close = CreateFrame('Button', nil, footer, 'UIPanelButtonTemplate, BackdropTemplate')
	close:Point('CENTER')
	close:SetText(CLOSE)
	close:Size(80, 20)
	close:SetScript('OnClick', function()
		_G.ABMDB['Version'] = ABM.Version
		frame:Hide()
	end)
	S:HandleButton(close)
	close:Disable()
	frame.close = close

	local scrollArea = CreateFrame('ScrollFrame', 'ABMChangelogScrollFrame', frame, 'UIPanelScrollFrameTemplate')
	scrollArea:Point('TOPLEFT', header, 'BOTTOMLEFT', 8, -3)
	scrollArea:Point('BOTTOMRIGHT', footer, 'TOPRIGHT', -25, 3)
	S:HandleScrollBar(_G.ABMChangelogScrollFrameScrollBar, nil, nil, 'Transparent')
	scrollArea:HookScript('OnVerticalScroll', function(scroll, offset)
		_G.ABMChangelogFrameEditBox:SetHitRectInsets(0, 0, offset, (_G.ABMChangelogFrameEditBox:GetHeight() - offset - scroll:GetHeight()))
	end)

	local editBox = CreateFrame('EditBox', 'ABMChangelogFrameEditBox', frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject('ChatFontNormal')
	editBox:SetTextColor(1, 0.8, 0)
	editBox:Width(scrollArea:GetWidth())
	editBox:Height(scrollArea:GetHeight())
	-- editBox:SetScript('OnEscapePressed', function() _G.ABMChangelog:Hide() end)
	scrollArea:SetScrollChild(editBox)
end

function module:ToggleChangeLog()
	local lineCt = GetNumLines(frame)
	local text = table.concat(changelogLines, ' \n', 1, lineCt)
	_G.ABMChangelogFrameEditBox:SetText(text)

	PlaySound(888)

	local fadeInfo = {}
	fadeInfo.mode = 'IN'
	fadeInfo.timeToFade = 0.5
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = 1
	E:UIFrameFade(ABMChangelog, fadeInfo)

	module.time = 6
	module:CancelAllTimers()
	module:CountDown()
	module:ScheduleRepeatingTimer('CountDown', 1)
end

function module:CheckVersion()
	if not InCombatLockdown() then
		if not ABMDB['Version'] or (ABMDB['Version'] and ABMDB['Version'] ~= ABM.Version) then
			module:ToggleChangeLog()
		end
	else
		module:RegisterEvent('PLAYER_REGEN_ENABLED', function(event)
			module:CheckVersion()
			module:UnregisterEvent(event)
		end)
	end

end

function module:Initialize()
	if not ABMChangelog then
		module:CreateChangelog()
	end
	module:RegisterEvent('PLAYER_REGEN_DISABLED', function()
		if ABMChangelog and not ABMChangelog:IsVisible() then return end
		module:RegisterEvent('PLAYER_REGEN_ENABLED', function(event) ABMChangelog:Show() module:UnregisterEvent(event) end)
		ABMChangelog:Hide()
	end)
	E:Delay(6, function() module:CheckVersion() end)
end

E:RegisterModule(module:GetName())
