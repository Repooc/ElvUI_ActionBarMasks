local E = unpack(ElvUI)
local ABM = E:GetModule('ElvUI_ActionBarMasks')
local S = E:GetModule('Skins')

local module = E:NewModule('ABM-Changelog', 'AceEvent-3.0', 'AceTimer-3.0')
local format, gsub, find = string.format, string.gsub, string.find

local ChangelogTBL = {
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

local function ModifiedString(string)
	local newString = string
	for _, v in pairs(URL_PATTERNS) do
		if find(string, v) then
			newString = gsub(string, v, formatURL('%1'))
		end
	end
	return newString
end

local function GetChangeLogInfo(i)
	for line, info in pairs(ChangelogTBL) do
		if line == i then
			return info
		end
	end
end

function module:CreateChangelog()
	local frame = CreateFrame('Frame', 'ABM_Changelog', E.UIParent, 'BackdropTemplate')
	frame:Point('CENTER')
	frame:Size(700, 700)
	frame:SetTemplate('Transparent')
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag('LeftButton')
	frame:SetScript('OnDragStart', frame.StartMoving)
	frame:SetScript('OnDragStop', frame.StopMovingOrSizing)
	frame:SetClampedToScreen(true)

	local title = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
	title:Point('TOP', frame, 'TOP', 0, 0)
	title:Size(frame:GetWidth(), 22)
	title:SetTemplate('Transparent')

	title.text = title:CreateFontString(nil, 'OVERLAY')
	title.text:FontTemplate(nil, 15, 'OUTLINE')
	title.text:SetHeight(title.text:GetStringHeight()+30)
	title.text:SetText('')
	title.text:SetTextColor(1, 0.8, 0)
	title.text:Point('CENTER', title, 0, -1)
	title.text:SetText('ActionBar Masks - Changelog '..format('|cff00c0fa%s|r', ABM.Version))

	local close = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate, BackdropTemplate')
	close:Point('BOTTOM', frame, 'BOTTOM', 0, 10)
	close:SetText(CLOSE)
	close:Size(80, 20)
	close:SetScript('OnClick', function()
		_G.ABMDB['Version'] = ABM.Version
		frame:Hide()
	end)
	S:HandleButton(close)
	close:Disable()
	frame.close = close

	local content = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
	content:Point('TOPLEFT', title, 'BOTTOMLEFT', 0, 0)
	content:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 0, 0)
	content:EnableMouse(true)

	local offset = 4
	for i = 1, #ChangelogTBL do
		local button = CreateFrame('Frame', 'Button'..i, content)
		button:SetWidth(frame:GetWidth())
		button:Point('TOPLEFT', content, 'TOPLEFT', 5, -offset)
		if i <= #ChangelogTBL then
			local string, isURL = ModifiedString(GetChangeLogInfo(i))

			button.Text = button:CreateFontString(nil, 'OVERLAY')
			button.Text:FontTemplate(nil, 11, 'OUTLINE')
			button.Text:SetWordWrap(true)
			button.Text:SetJustifyH('LEFT')
			button.Text:SetHeight(button.Text:GetStringHeight()+30)
			button.Text:SetWidth(frame:GetWidth() - 20)
			button:EnableMouse(true)
			if button.Text then
				button.Text:SetText(button.Text)
			else
				button.Text:SetText('')
			end
			button.Text:SetTextColor(1, 0.8, 0)
			button:SetHeight(button.Text:GetHeight())

			button.Text.isURL = isURL
			button.Text:SetText(string)
			button.Text:Point('LEFT', 0, 0)
		end
		offset = offset + 16
	end
end

function module:CountDown()
	module.time = module.time - 1

	if module.time == 0 then
		module:CancelAllTimers()
		ABM_Changelog.close:Enable()
		ABM_Changelog.close:SetText(CLOSE)
	else
		ABM_Changelog.close:Disable()
		ABM_Changelog.close:SetText(CLOSE..format(' (%s)', module.time))
	end
end

function module:ToggleChangeLog()
	if not ABM_Changelog then
		module:CreateChangelog()
	end

	PlaySound(888)

	local fadeInfo = {}
	fadeInfo.mode = 'IN'
	fadeInfo.timeToFade = 0.5
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = 1
	E:UIFrameFade(ABM_Changelog, fadeInfo)

	module.time = 6
	module:CancelAllTimers()
	module:CountDown()
	module:ScheduleRepeatingTimer('CountDown', 1)
end

function module:CheckVersion()
	if not ABMDB['Version'] or (ABMDB['Version'] and ABMDB['Version'] ~= ABM.Version) then
		module:ToggleChangeLog()
	end
end

function module:Initialize()
	E:Delay(6, function() module:CheckVersion() end)
end

E:RegisterModule(module:GetName())
