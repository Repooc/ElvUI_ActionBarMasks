local E = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local LCG = E.Libs.CustomGlow
local AB = E.ActionBars
local LAB = E.Libs.LAB

local AddOnName, Engine = ...

local ABM = E:NewModule(AddOnName, 'AceHook-3.0')
_G[AddOnName] = Engine

ABM.Title = C_AddOns.GetAddOnMetadata('ElvUI_ActionBarMasks', 'Title')
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata

ABM.Configs = {}
_G.ABMDB = {}

local STANCE_SLOTS = _G.NUM_STANCE_SLOTS or 10
local ACTION_SLOTS = _G.NUM_PET_ACTION_SLOTS or 10
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
	diamond = {
		borders = {
			black3px = 'Black (3px)',
			black6px = 'Black (6px)',
			black8px = 'Black (8px)',
			black9px = 'Black (9px)',
			black10px = 'Black (10px)',
			white3px = 'White (3px)',
			white6px = 'White (6px)',
			white8px = 'White (8px)',
			white9px = 'White (9px)',
			white10px = 'White (10px)',
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
	octagon = {
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
	},
	pentagon2 = {
		borders = {
			border97 = 'White (Thin)',
			border98 = 'Black (Thin)',
			border99 = 'White',
			border100 = 'Black',
			border101 = 'Black (Super Thick)'
		},
	},
	square = {
		borders = {
			border98 = 'Sort of Glossy',
			border99 = 'Inner Glow',
			border100 = 'Outter Glow',
		},
	}
}

function ABM:ParseVersionString()
	local version = GetAddOnMetadata(AddOnName, 'Version')
	local prevVersion = GetAddOnMetadata(AddOnName, 'X-PreviousVersion')
	if strfind(version, 'project%-version') then
		return prevVersion, prevVersion..'-git', nil, true
	else
		local release, extra = strmatch(version, '^v?([%d.]+)(.*)')
		return tonumber(release), release..extra, extra ~= ''
	end
end

ABM.version, ABM.versionString, ABM.versionDev, ABM.versionGit = ABM:ParseVersionString()

function ABM:GetMasksTable()
	return DefaultMasks
end

function ABM:GetValidBorder()
	local db = E.db.abm.global
	local maskDB = ABM:GetMasksTable()
	local shape = maskDB[db.general.shape] and db.general.shape or 'circle'

	local border = db.border.style
	if not maskDB[shape].borders[border] then
		-- Get all border keys for the shape
		local borderKeys = {}
		for key in pairs(DefaultMasks[shape].borders) do
			tinsert(borderKeys, key)
		end
		border = borderKeys[random(#borderKeys)]
	end
	
	local path = texturePath..shape..'\\'..border

	return path, border, shape
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
	local path, border, shape = ABM:GetValidBorder()
	local db = E.db.abm.global
	local cooldown

	for button in pairs(AB.handledbuttons) do
		if button then
			cooldown = button.cooldown or _G[button:GetName()..'Cooldown']

			if button.mask then
				button.mask:SetTexture(texturePath..shape..'\\mask.tga', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
				button.mask:SetRotation(db.border.rotate)
			end
			if button.border then
				button.border:SetTexture(path)
				button.border:SetVertexColor(db.border.color.r, db.border.color.g, db.border.color.b, 1)
				button.border:SetRotation(db.border.rotate)
			end
			if button.shadow then
				-- button.shadow:SetTexture(texturePath..db.general.shape..'\\shadow.tga')
				button.shadow:SetTexture(texturePath..'square\\shadow.tga')
				button.shadow:SetVertexColor(db.shadow.color.r, db.shadow.color.g, db.shadow.color.b, 1)
				button.shadow:SetShown(db.shadow.enable and shape == 'square' and border ~= 'border100')
				button.shadow:SetRotation(db.border.rotate)
			end
			if cooldown and cooldown:GetDrawSwipe() then
				cooldown:SetSwipeTexture(texturePath..shape..'\\mask.tga')
			end
			if button.chargeCooldown then
				button.chargeCooldown:SetSwipeTexture(texturePath..shape..'\\mask.tga')
			end
			if button.procFrame then
				button.procFrame:SetSize(button:GetSize())

				button.procFrame.procRing:SetSize(button:GetSize())
				button.procFrame.procRing:SetTexture(texturePath..shape..'\\procRingWhite')
				button.procFrame.procRing:SetVertexColor(db.proc.color.r, db.proc.color.g, db.proc.color.b, 1)

				if button.procFrame.procMask then
					if db.proc.style == 'solid' then
						button.procFrame.procMask:SetTexture(texturePath..shape..'\\mask', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
					else
						button.procFrame.procMask:SetTexture(texturePath..'repooctest.tga', 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
					end
					button.procFrame.procRing:AddMaskTexture(button.procFrame.procMask)
				end
				if button.procFrame.spinner then
					button.procFrame.spinner:SetLooping('REPEAT') --maybe an option... idk yet
				end
				if button.procFrame.rotate then
					button.procFrame.rotate:SetDuration(db.proc.speed)
				end
				if button.procFrame.pulse then
					if db.proc.enable and db.proc.pulse and not button.procFrame.pulse:IsPlaying() then
						button.procFrame.pulse:Play()
					elseif not db.proc.enable or button.procFrame.pulse:IsPlaying() and not db.proc.pulse then
						button.procFrame.pulse:Stop()
					end
				end
				if button.procFrame.spinner then
					if db.proc.enable and db.proc.spin and not button.procFrame.spinner:IsPlaying() then
						button.procFrame.spinner:Play(db.proc.reverse)
					elseif not db.proc.enable or button.procFrame.spinner:IsPlaying() and not db.proc.spin then
						button.procFrame.spinner:Stop()
					end
				end
				if shape == 'square' then
					button.procFrame:Hide()
					button.procFrame.spinner:Stop()
					button.procFrame.pulse:Stop()
				elseif db.proc.enable and button.procActive then
					button.procFrame:Show()
				elseif not db.proc.enable or not button.procActive then
					button.procFrame:Hide()
				end
			end
			if button:GetParent() == _G.ElvUI_BarPet and _G[button:GetName()..'Shine'] then
				_G[button:GetName()..'Shine']:SetAlpha(shape == 'square' and 1 or 0)
			end

			if shape ~= 'square' then
				if button._PixelGlow then button._PixelGlow:Hide() end
				if button._ButtonGlow then button._ButtonGlow:Hide() end
				if button._AutoCastGlow then button._AutoCastGlow:Hide() end
			else
				if button.procActive then
					if button._PixelGlow then
						button._PixelGlow:ClearAllPoints()
						button._PixelGlow:Point('TOPLEFT', button, 'TOPLEFT', 5, -5)
						button._PixelGlow:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -5, 5)
						button._PixelGlow:Show()
					end
					if button._ButtonGlow then button._ButtonGlow:Show() end
					if button._AutoCastGlow then button._AutoCastGlow:Show() end
				end
			end

			if button.icon and button:GetParent() == _G.ElvUI_StanceBar then
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
		end
	end
end

local function SetupMask(button)
	if not button then return end

	local name = button:GetName()
	local normal = _G[name..'NormalTexture']

	if not button.rabHooked then
		if button.RightEdge then button.RightEdge:Hide() end
		if button.LeftEdge then button.LeftEdge:Hide() end
		if button.TopEdge then button.TopEdge:Hide() end
		if button.TopRightCorner then button.TopRightCorner:Hide() end
		if button.TopLeftCorner then button.TopLeftCorner:Hide() end
		if button.BottomRightCorner then button.BottomRightCorner:Hide() end
		if button.BottomLeftCorner then button.BottomLeftCorner:Hide() end
		if button.BottomEdge then button.BottomEdge:Hide() end
		if button.iborder then button.iborder:Hide() end
		if button.oborder then button.oborder:Hide() end
	end

	if not button.mask then
		button.mask = button:CreateMaskTexture(nil, 'BACKGROUND', nil, 4)
		button.mask:SetAllPoints(button)
	end

	if button.mask and not button.rabHooked then
		if button.SpellHighlightTexture then button.SpellHighlightTexture:AddMaskTexture(button.mask) end
		if button.checked then button.checked:AddMaskTexture(button.mask) end
		if button.hover then button.hover:AddMaskTexture(button.mask) end
		if button.icon then button.icon:AddMaskTexture(button.mask) end
		if button.pushed then button.pushed:AddMaskTexture(button.mask) end
		if button.Center then button.Center:AddMaskTexture(button.mask) end
		if normal then normal:AddMaskTexture(button.mask) end
	end

	--==============--
	--= Add Border =--
	--==============--
	if not button.border then
		button.border = button:CreateTexture(nil, 'OVERLAY', nil, 5)
		button.border:SetAllPoints(button)
	end

	--==============--
	--= Add Shadow =--
	--==============--
	if not button.shadow then
		button.shadow = button:CreateTexture(nil, 'BACKGROUND')
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
	end

	if not button.ABM_TextParent then
		button.ABM_TextParent = CreateFrame('Frame')
		button.ABM_TextParent:SetParent(button)
		button.ABM_TextParent:SetFrameLevel(10)
		button.ABM_TextParent:SetAllPoints()
		if button.HotKey then button.HotKey:SetParent(button.ABM_TextParent) end
		if button.Count then button.Count:SetParent(button.ABM_TextParent) end
	end

	--=================--
	--= Add Proc Ring =--
	--=================--
	if not button.procFrame.procRing then
		button.procFrame.procRing = button.procFrame:CreateTexture()
		button.procFrame.procRing:SetParent(button.procFrame)
		button.procFrame.procRing:SetAllPoints(button.procFrame)
		button.procFrame.procRing:SetDrawLayer('BORDER')
	end

	--================--
	--= Add ProcMask =--
	--================--
	if not button.procFrame.procMask then
		button.procFrame.procMask = button.procFrame:CreateMaskTexture()
		button.procFrame.procMask:SetParent(button.procFrame)
		button.procFrame.procMask:SetPoint('CENTER', button.procFrame.procRing)
		button.procFrame.procMask:SetSize(80, 80)
	end

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
		-- button.procFrame.rotate:SetSmoothing('OUT')
		-- button.procFrame.rotate:SetOrigin('CENTER', 0, 0)
	end

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
		button.procFrame.scaleOut:SetScaleFrom(0.98, 0.98)
		button.procFrame.scaleOut:SetScaleTo(1.05, 1.05)
	end

	button.rabHooked = true
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

	for i = 1, ACTION_SLOTS do
		button = _G['PetActionButton'..i]

		if _G[button:GetName()..'Shine'] then
			if E.db.abm.global.general.shape == 'square' then
				_G[button:GetName()..'Shine']:ClearAllPoints()
				_G[button:GetName()..'Shine']:Point('TOPLEFT', button, 'TOPLEFT', 5, -5)
				_G[button:GetName()..'Shine']:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -5, 5)
			end
		end
		SetupMask(button)
	end
end

function ABM:PositionAndSizeBarShapeShift()
	local button
	for i = 1, STANCE_SLOTS do
		button = _G['ElvUI_StanceBarButton'..i]
		if not button.rabHooked then _G[button:GetName()..'Shine']:SetAlpha(0) end
		SetupMask(button)
	end
end

local function ControlProc(button, autoCastEnabled)
	if not button or (button and not button.procFrame) then return end
	local db = E.db.abm.global
	button.procActive = autoCastEnabled

	if button._PixelGlow and button._PixelGlow:IsShown() then
		if db.general.shape == 'square' then
			button._PixelGlow:ClearAllPoints()
			button._PixelGlow:Point('TOPLEFT', button, 'TOPLEFT', 5, -5)
			button._PixelGlow:Point('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -5, 5)
		else
			button._PixelGlow:Hide()
		end
	end

	if button._ButtonGlow and button._ButtonGlow:IsShown() then
		if db.general.shape ~= 'square' then
			button._ButtonGlow:Hide()
		end
	end

	if button._AutoCastGlow and button._AutoCastGlow:IsShown() then
		if db.general.shape == 'square' then
			button._AutoCastGlow:ClearAllPoints()
			button._AutoCastGlow:Point('TOPLEFT', button.procFrame, 'TOPLEFT', 5, -5)
			button._AutoCastGlow:Point('BOTTOMRIGHT', button.procFrame, 'BOTTOMRIGHT', -5, 5)
		else
			button._AutoCastGlow:Hide()
		end
	end

	if db.proc.enable and db.general.shape ~= 'square' and button.procActive then
		button.procFrame:Show()
		if db.proc.spin then
			button.procFrame.spinner:Play(db.proc.reverse)
		end
		if db.proc.pulse then
			button.procFrame.pulse:Play()
		end
	else
		button.procFrame:Hide()
		button.procFrame.spinner:Stop()
		button.procFrame.pulse:Stop()
	end
end

function ABM:UpdatePet(event, unit)
	if (event == 'UNIT_FLAGS' or event == 'UNIT_PET') and unit ~= 'pet' then return end
	for i = 1, ACTION_SLOTS, 1 do
		local button = _G['PetActionButton'..i]
		local _, _, _, _, _, autoCastEnabled = GetPetActionInfo(i)
		ControlProc(button, autoCastEnabled)
	end
end

function ABM:SetupFlyoutButton(_, button)
	local parent = button:GetParent()
	if not button.mask and parent.isActionBar then
		SetupMask(button)
	end
end

function ABM:LAB_OnChargeCreated(parent, cooldown)
	if parent.mask then
		cooldown:SetSwipeTexture(texturePath..E.db.abm.global.general.shape..'\\mask.tga')
	end
end

function ABM:MultiCastFlyoutFrame_ToggleFlyout(_, frame)
	local needsRefresh
	for _, button in ipairs(frame.buttons) do
		if not button.mask then
			SetupMask(button)
			needsRefresh = true
		end
	end

	if needsRefresh then
		ABM:UpdateOptions()
	end
end

function ABM:Initialize()
	EP:RegisterPlugin(AddOnName, GetOptions, nil, ABM.versionString)
	if not AB.Initialized or not E.db.abm.global.enable then return end
	ABM:DBConversions()

	for button in next, AB.handledbuttons do
		SetupMask(button)
	end

	--for i = 1, 10 do
	--	ABM:PositionAndSizeBar('bar'..i)
	--end
	--if E.Retail then
	--	for i = 13, 15 do
	--		ABM:PositionAndSizeBar('bar'..i)
	--	end
	--end

	--ABM:PositionAndSizeBarPet()
	--ABM:PositionAndSizeBarShapeShift()
	ABM:UpdateOptions()

	--ABM:SecureHook((AB, 'PositionAndSizeBar', 'UpdateOptions')
	--ABM:SecureHook(AB, 'PositionAndSizeBarPet', 'UpdateOptions')
	--ABM:SecureHook(AB, 'PositionAndSizeBarShapeShift', 'UpdateOptions')

	ABM:SecureHook(E, 'UpdateDB', 'UpdateOptions')

	LAB.RegisterCallback(ABM, 'OnChargeCreated', ABM.LAB_OnChargeCreated)
	ABM:SecureHook(LCG, 'ShowOverlayGlow', function(button) ControlProc(button, true) end)
	ABM:SecureHook(LCG, 'HideOverlayGlow', function(button) ControlProc(button, false) end)

	ABM:SecureHook(AB, 'SetupFlyoutButton')
	ABM:SecureHook(AB, 'UpdatePet')

	if E.Wrath then
		ABM:SecureHook(AB, 'MultiCastFlyoutFrame_ToggleFlyout')
	end
end

E.Libs.EP:HookInitialize(ABM, ABM.Initialize)
