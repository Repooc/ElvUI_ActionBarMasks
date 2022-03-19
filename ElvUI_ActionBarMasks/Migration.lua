local E = unpack(ElvUI)
local ABM = E:GetModule('ElvUI_ActionBarMasks')

local function DBMigration()
	if E.db.rab ~= nil then
		-- General Settings
		if E.db.rab.general.enable ~= nil then
			E.db.abm.general.enable = E.db.rab.general.enable
		end
		if E.db.rab.general.shape ~= nil then
			E.db.abm.general.shape = E.db.rab.general.shape
		end

		-- Border Settings
		if E.db.rab.general.borderColor ~= nil then
			E.db.abm.general.border.color = E.db.rab.general.borderColor
		end
		if E.db.rab.general.borderStyle ~= nil then
			E.db.abm.general.border.style = E.db.rab.general.borderStyle
		end

		-- Shadow Settings
		if E.db.rab.general.shadowEnable ~= nil then
			E.db.abm.general.shadow.enable = E.db.rab.general.shadowEnable
		end
		if E.db.rab.general.shadowColor ~= nil then
			E.db.abm.general.shadow.color = E.db.rab.general.shadowColor
		end

		-- Proc Settings
		if E.db.rab.general.procEnable ~= nil then
			E.db.abm.general.proc.enable = E.db.rab.general.procEnable
		end
		if E.db.rab.general.procStyle ~= nil then
			E.db.abm.general.proc.style = E.db.rab.general.procStyle
		end
		if E.db.rab.general.procColor ~= nil then
			E.db.abm.general.proc.color = E.db.rab.general.procColor
		end
		if E.db.rab.general.procReverse ~= nil then
			E.db.abm.general.proc.reverse = E.db.rab.general.procReverse
		end
		if E.db.rab.general.procSpeed ~= nil then
			E.db.abm.general.proc.speed = E.db.rab.general.procSpeed
		end
		if E.db.rab.general.procPulse ~= nil then
			E.db.abm.general.proc.pulse = E.db.rab.general.procPulse
		end
		if E.db.rab.general.procSpin ~= nil then
			E.db.abm.general.proc.spin = E.db.rab.general.procSpin
		end

		-- Remove traces of old db
		E.db.rab = nil
	end
end

function ABM:DBConversions()
	-- release converts, only one call per version
	if E.db.abm.dbConverted ~= ABM.Version then
		E.db.abm.dbConverted = ABM.Version

		DBMigration() -- Version 1.08 -> 1.09
	end
end
