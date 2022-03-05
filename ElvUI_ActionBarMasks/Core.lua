local E = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local LCG = E.Libs.CustomGlow
local AB = E.ActionBars
local AddOnName, Engine = ...

local ABM = E:NewModule(AddOnName, 'AceHook-3.0')
_G[AddOnName] = Engine

ABM.Version = GetAddOnMetadata('ElvUI_ActionBarMasks', 'Version')
ABM.Configs = {}

local texturePath = 'Interface\\Addons\\ElvUI_ActionBarMasks\\Textures\\'

local DefaultMasks = {
	circle = {
		borders = {
			border1 = '|T'..texturePath..'circle\\border1:15:15:0:0:128:128:2:56:2:56|t Stone Thing (Loading Screen)',
			border2 = '|T'..texturePath..'circle\\border2:15:15:0:0:128:128:2:56:2:56|t Suramar Street',
			border3 = '|T'..texturePath..'circle\\border3:15:15:0:0:128:128:2:56:2:56|t Draenor Moon (WoD)',
			border4 = '|T'..texturePath..'circle\\border4:15:15:0:0:128:128:2:56:2:56|t Wood Texture',
			border5 = '|T'..texturePath..'circle\\border5:15:15:0:0:128:128:2:56:2:56|t Ulduar (Loading Screen)',
			border6 = '|T'..texturePath..'circle\\border6:15:15:0:0:128:128:2:56:2:56|t Throne of Thunder (Loading Screen)',
			border7 = '|T'..texturePath..'circle\\border7:15:15:0:0:128:128:2:56:2:56|t Well of Eternity (Loading Screen)',
			border8 = '|T'..texturePath..'circle\\border8:15:15:0:0:128:128:2:56:2:56|t Kyrian Ring',
			border9 = '|T'..texturePath..'circle\\border9:15:15:0:0:128:128:2:56:2:56|t Necrolord Ring',
			border10 = '|T'..texturePath..'circle\\border10:15:15:0:0:128:128:2:56:2:56|t Night Fae Ring',
			border11 = '|T'..texturePath..'circle\\border11:15:15:0:0:128:128:2:56:2:56|t Venthyr Ring',
			border97 = '|T'..texturePath..'circle\\border97:15:15:0:0:128:128:2:56:2:56|t White (Thin)',
			border98 = '|T'..texturePath..'circle\\border98:15:15:0:0:128:128:2:56:2:56|t Black (Thin)',
			border99 = '|T'..texturePath..'circle\\border99:15:15:0:0:128:128:2:56:2:56|t White',
			border100 = '|T'..texturePath..'circle\\border100:15:15:0:0:128:128:2:56:2:56|t Black',
			border101 = '|T'..texturePath..'circle\\border101:15:15:0:0:128:128:2:56:2:56|t Black (Super Thick)'
		},
	},
	hexagon = {
		borders = {
			border97 = 'White (Thin)',
			border98 = 'Black (Thin)',
			border99 = 'White',
			border100 = 'Black',
			border101 = 'Black (Super Thick)'
		},
	},
	pentagon = {
		borders = {
			border97 = 'White (Thin)',
			border98 = 'Black (Thin)',
			border99 = 'White',
			border100 = 'Black',
			border101 = 'Black (Super Thick)'
		},
	}
}

function ABM:GetMaskDB()
	return DefaultMasks
end

function ABM:GetValidBorder()
	local db = E.db.rab.general
	local maskDB = ABM:GetMaskDB()
	local border = maskDB[db.shape].borders[db.borderStyle] and db.borderStyle or 'border100'
	local path = texturePath..db.shape..'\\'..border

	return path, border
end

function ABM:Print(...)
	(E.db and _G[E.db.general.messageRedirect] or _G.DEFAULT_CHAT_FRAME):AddMessage(strjoin('', E.media.hexvaluecolor or '|cff00b3ff', 'ActionBar Masks:|r ', ...)) -- I put DEFAULT_CHAT_FRAME as a fail safe.
end

local function GetOptions()
	for _, func in pairs(ABM.Configs) do
		func()
	end
end

function ABM:UpdateOptions()
	local db = E.db.rab.general
	local cooldown
	local path = ABM:GetValidBorder()
	for button in pairs(AB.handledbuttons) do
		if button then
			cooldown = _G[button:GetName()..'Cooldown']

			if button.mask then
				button.mask:SetTexture(texturePath..db.shape..'\\mask.tga', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
			end
			if button.border then
				-- button.border:SetTexture(texturePath..db.shape..'\\'..db.borderStyle)
				button.border:SetTexture(path)
				button.border:SetVertexColor(db.borderColor.r, db.borderColor.g, db.borderColor.b, 1)
			end
			if button.shadow then
				button.shadow:SetTexture(texturePath..db.shape..'\\shadow.tga')
			end
			if cooldown:GetDrawSwipe() then
				cooldown:SetSwipeTexture(texturePath..db.shape..'\\mask.tga')
			end
			if button.procFrame then
				if button.procFrame.procRing then
					button.procFrame.procRing:SetTexture(texturePath..db.shape..'\\procRingWhite')
					button.procFrame.procRing:SetVertexColor(db.procColor.r, db.procColor.g, db.procColor.b, 1)
				end
				if button.procFrame.procMask then
					if db.procStyle == 'solid' then
						button.procFrame.procMask:SetTexture(texturePath..db.shape..'\\mask', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
					else
						button.procFrame.procMask:SetTexture(texturePath..'repooctest.tga', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
					end
					button.procFrame.procRing:AddMaskTexture(button.procFrame.procMask)
				end
				if button.procFrame.spinner then
					button.procFrame.spinner:SetLooping('REPEAT') --maybe an option... idk yet
				end
				if button.procFrame.rotate then
					button.procFrame.rotate:SetDuration(db.procSpeed)
					-- button.procFrame.rotate:SetDegrees(360)
					-- button.procFrame.rotate:SetDegrees(db.proc.reverse and -(360) or 360)
					-- button.procFrame.rotate:SetDegrees(db.procReverse and -(21600) or 21600)
				end
				if button.procFrame.pulse then
					if db.procEnable and  db.procPulse and not button.procFrame.pulse:IsPlaying() then
						button.procFrame.pulse:Play()
					elseif not db.procEnable or button.procFrame.pulse:IsPlaying() and not db.procPulse  then
						button.procFrame.pulse:Stop()
					end
				end
				if button.procFrame.pulse then
					if db.procEnable and db.procSpin and not button.procFrame.spinner:IsPlaying() then
						button.procFrame.spinner:Play(db.procReverse)
					elseif not db.procEnable or button.procFrame.spinner:IsPlaying() and not db.procSpin then
						button.procFrame.spinner:Stop()
					end
				end
			end
		end
	end
end

local function SetupMask(button)
	if not button then return end

	local name = button:GetName()
	local normal = _G[name..'NormalTexture']

	if not button.rabHooked then
		button.Center:Hide()
		button.RightEdge:Hide()
		button.LeftEdge:Hide()
		button.TopEdge:Hide()
		button.TopRightCorner:Hide()
		button.TopLeftCorner:Hide()
		button.BottomRightCorner:Hide()
		button.BottomLeftCorner:Hide()
		button.BottomEdge:Hide()
	end

	if not button.mask then
		button.mask = button:CreateMaskTexture(nil, 'Background', nil, 4)
		button.mask:SetAllPoints(button)
	end

	if button.mask and not button.rabHooked then
		if button.checked then button.checked:AddMaskTexture(button.mask) end
		if button.hover then button.hover:AddMaskTexture(button.mask) end
		if button.icon then button.icon:AddMaskTexture(button.mask) end
		if button.pushed then button.pushed:AddMaskTexture(button.mask) end
		if normal then normal:AddMaskTexture(button.mask) end
	end

	--==============--
	--= Add Border =--
	--==============--
	if not button.border then
		button.border = button:CreateTexture()
		button.border:SetAllPoints(button)
	end
	-- button.border:SetTexture(texturePath..db.shape..'\\'..db.borderStyle)

	--==============--
	--= Add Shadow =--
	--==============--
	if not button.shadow then
		button.shadow = button:CreateTexture()
		button.shadow:SetAllPoints(button)
	end

	--==================--
	--= Add Proc Frame =--
	--==================--
	if not button.procFrame then
		button.procFrame = CreateFrame('Frame')
		button.procFrame:SetParent(button)
		button.procFrame:SetPoint('Center', button)
		button.procFrame:Hide()
		if button.HotKey then button.HotKey:SetParent(button.procFrame) end
	end
	button.procFrame:SetSize(button:GetSize())

	--=================--
	--= Add Proc Ring =--
	--=================--
	if not button.procFrame.procRing then
		button.procFrame.procRing = button.procFrame:CreateTexture()
		button.procFrame.procRing:SetParent(button.procFrame)
		button.procFrame.procRing:SetAllPoints(button.procFrame)
		button.procFrame.procRing:SetDrawLayer('BORDER')
	end
	button.procFrame.procRing:SetSize(button:GetSize())

	--================--
	--= Add ProcMask =--
	--================--
	if not button.procFrame.procMask then
		button.procFrame.procMask = button.procFrame:CreateMaskTexture()
		button.procFrame.procMask:SetParent(button.procFrame)
		button.procFrame.procMask:SetPoint('CENTER', button.procFrame.procRing)
		button.procFrame.procMask:SetSize(80, 80)
	end
	--button.procFrame:AddMaskTexture(button.procFrame.procMask)

	--==========================--
	--= Add Spinner Anim Group =--
	--==========================--
	if not button.procFrame.spinner then
		button.procFrame.spinner = button.procFrame:CreateAnimationGroup()
	end

	--===================--
	--= Add Rotate Anim =--
	--===================--
	if not button.procFrame.rotate then
		button.procFrame.rotate = button.procFrame.spinner:CreateAnimation('Rotation')
		button.procFrame.rotate:SetOrder(1)
		button.procFrame.rotate:SetTarget(button.procFrame.procMask)
		button.procFrame.rotate:SetStartDelay(0)
		button.procFrame.rotate:SetDegrees(360)
	end
	--button.procFrame.rotate:SetSmoothing('OUT')
	--button.procFrame.rotate:SetOrigin('CENTER', 0, 0)

	--========================--
	--= Add Pulse Anim Group =--
	--========================--
	if not button.procFrame.pulse then
		button.procFrame.pulse = button.procFrame:CreateAnimationGroup()
		button.procFrame.pulse:SetLooping('BOUNCE')
	end

	--======================--
	--= Add Scale Out Anim =--
	--======================--
	if not button.procFrame.scaleOut then
		button.procFrame.scaleOut = button.procFrame.pulse:CreateAnimation('Scale')
		button.procFrame.scaleOut:SetOrder(1)
		button.procFrame.scaleOut:SetDuration(0.7)
		button.procFrame.scaleOut:SetStartDelay(0)
		button.procFrame.scaleOut:SetSmoothing('OUT')
		button.procFrame.scaleOut:SetFromScale(0.98, 0.98)
		button.procFrame.scaleOut:SetToScale(1.05, 1.05)
	end

	button.rabHooked = true

	-- Some Icon Texture Manipulation to try to make it look a bit better...
	if not button:GetParent() == 'ElvUI_StanceBar' or not button.icon then return end

	local left, right, top, bottom = unpack({-0.05, 1.05, -0.1, 1.1})
	local changeRatio = button.db and not button.db.keepSizeRatio
	if changeRatio then
		local width, height = button:GetSize()
		local ratio = width / height
		if ratio > 1 then
			local trimAmount = (1 - (1 / ratio)) / 2
			top = top + trimAmount
			bottom = bottom - trimAmount
		else
			local trimAmount = (1 - ratio) / 2
			left = left + trimAmount
			right = right - trimAmount
		end
	end

	-- always when masque is off, otherwise only when keepSizeRatio is off
	if not button.useMasque or changeRatio then
		button.icon:SetTexCoord(left, right, top, bottom)
	end
end

function ABM:PositionAndSizeBar(barName)
	local bar = AB['handledBars'][barName]
	if not bar then return end
	local button
	for i=1, NUM_ACTIONBAR_BUTTONS do
		button = bar.buttons[i]
		SetupMask(button)
	end
end

function ABM:PositionAndSizeBarPet()
	local button
	for i = 1, NUM_PET_ACTION_SLOTS do
		button = _G['PetActionButton'..i]
		if not button.rabHooked then _G[button:GetName()..'Shine']:SetAlpha(0) end
		SetupMask(button)
	end
end

function ABM:PositionAndSizeBarShapeShift()
	local button
	for i = 1, NUM_STANCE_SLOTS do
		button = _G['ElvUI_StanceBarButton'..i]
		if not button.rabHooked then _G[button:GetName()..'Shine']:SetAlpha(0) end
		SetupMask(button)
	end
end

local function ControlProc(button, autoCastEnabled)
	if not button or (button and not button.procFrame) then return end
	local db = E.db.rab.general

	if button._PixelGlow and button._PixelGlow:GetAlpha() > 0 then button._PixelGlow:SetAlpha(0) end
	if button._ButtonGlow and button._ButtonGlow:IsShown() then button._ButtonGlow:Hide() end
	if button._AutoCastGlow and button._AutoCastGlow:GetAlpha() > 0 then button._AutoCastGlow:SetAlpha(0) end

	if db.procEnable and autoCastEnabled then
		button.procFrame:Show()
		if db.procSpin then
			button.procFrame.spinner:Play(db.procReverse)
		end
		if db.procPulse then
			button.procFrame.pulse:Play()
		end
		button.procActive = true
	else
		button.procFrame:Hide()
		button.procFrame.spinner:Stop()
		button.procFrame.pulse:Stop()
		button.procActive = false
	end
end

function ABM:UpdatePet(event, unit)
	if (event == 'UNIT_FLAGS' or event == 'UNIT_PET') and unit ~= 'pet' then return end
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local button = _G['PetActionButton'..i]
		local _, _, _, _, _, autoCastEnabled = GetPetActionInfo(i)
		ControlProc(button, autoCastEnabled)
	end
end

function ABM:Initialize()
	EP:RegisterPlugin(AddOnName, GetOptions)
	if not AB.Initialized or not E.db.rab.general.enable then return end

	hooksecurefunc(E, 'UpdateDB', ABM.UpdateOptions)
	hooksecurefunc(AB, 'PositionAndSizeBar', ABM.PositionAndSizeBar)
	for i = 1, 10 do
		ABM:PositionAndSizeBar('bar'..i)
	end

	ABM:PositionAndSizeBarPet()
	hooksecurefunc(AB, 'PositionAndSizeBarPet', ABM.PositionAndSizeBarPet)

	ABM:PositionAndSizeBarShapeShift()
	hooksecurefunc(AB, 'PositionAndSizeBarShapeShift', ABM.PositionAndSizeBarShapeShift)

	ABM:UpdateOptions()

	hooksecurefunc(LCG, 'ShowOverlayGlow', function(button) ControlProc(button, true) end)
	hooksecurefunc(LCG, 'HideOverlayGlow', function(button) ControlProc(button, false) end)
	hooksecurefunc(AB, 'UpdatePet', ABM.UpdatePet)

	if not ABMDB then
		_G.ABMDB = {}
	end
end

E.Libs.EP:HookInitialize(ABM, ABM.Initialize)
