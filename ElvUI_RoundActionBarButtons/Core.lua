local E = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local AB = E.ActionBars
local AddOnName, Engine = ...

local RAB = E:NewModule(AddOnName)
_G[AddOnName] = Engine

function RAB:Initialize()
	EP:RegisterPlugin(AddOnName)

	hooksecurefunc(AB, 'PositionAndSizeBar', function(_, barName)
		local bar = AB['handledBars'][barName]
		if not bar then return end

		for i=1, NUM_ACTIONBAR_BUTTONS do
			local button = bar.buttons[i]

			if not button.mask then
				button.mask = button:CreateMaskTexture()
			end
			button.mask:SetAllPoints(button)
			button.mask:SetTexture([[Interface\CHARACTERFRAME\TempPortraitAlphaMask]], 'CLAMPTOBLACKADDITIVE', 'CLAMPTOBLACKADDITIVE')
			button.icon:AddMaskTexture(button.mask)
			button:SetBackdrop()
		end
	end)
	for i = 1, 10 do
		AB:PositionAndSizeBar('bar'..i)
	end
end

E.Libs.EP:HookInitialize(RAB, RAB.Initialize)
