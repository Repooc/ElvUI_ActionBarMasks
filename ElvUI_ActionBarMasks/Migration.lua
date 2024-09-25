local E = unpack(ElvUI)
local ABM = E:GetModule('ElvUI_ActionBarMasks')

local function DBMigration()
	if E.db.rab ~= nil then
		-- General Settings
		if E.db.rab.general.enable ~= nil then
			E.db.abm.global.enable = E.db.rab.general.enable
		end
		if E.db.rab.general.shape ~= nil then
			E.db.abm.global.general.shape = E.db.rab.general.shape
		end

		-- Border Settings
		if E.db.rab.general.borderColor ~= nil then
			E.db.abm.global.border.color = E.db.rab.general.borderColor
		end
		if E.db.rab.general.borderStyle ~= nil then
			E.db.abm.global.border.style = E.db.rab.general.borderStyle
		end

		-- Shadow Settings
		if E.db.rab.general.shadowEnable ~= nil then
			E.db.abm.global.shadow.enable = E.db.rab.general.shadowEnable
		end
		if E.db.rab.general.shadowColor ~= nil then
			E.db.abm.global.shadow.color = E.db.rab.general.shadowColor
		end

		-- Proc Settings
		if E.db.rab.general.procEnable ~= nil then
			E.db.abm.global.proc.enable = E.db.rab.general.procEnable
		end
		if E.db.rab.general.procStyle ~= nil then
			E.db.abm.global.proc.style = E.db.rab.general.procStyle
		end
		if E.db.rab.general.procColor ~= nil then
			E.db.abm.global.proc.color = E.db.rab.general.procColor
		end
		if E.db.rab.general.procReverse ~= nil then
			E.db.abm.global.proc.reverse = E.db.rab.general.procReverse
		end
		if E.db.rab.general.procSpeed ~= nil then
			E.db.abm.global.proc.speed = E.db.rab.general.procSpeed
		end
		if E.db.rab.general.procPulse ~= nil then
			E.db.abm.global.proc.pulse = E.db.rab.general.procPulse
		end
		if E.db.rab.general.procSpin ~= nil then
			E.db.abm.global.proc.spin = E.db.rab.general.procSpin
		end

		-- Remove traces of old db
		E.db.rab = nil
	end
end

local function DBMigration2()
	if E.db.abm.general ~= nil then
		E:CopyTable(E.db.abm.global, E.db.abm.general)
		if E.db.abm.global.shape ~= nil then
			E.db.abm.global.general.shape = E.db.abm.global.shape
			E.db.abm.global.shape = nil
		end
		E.db.abm.general = nil
	end
end

function ABM:DBConversions()
	-- release converts, only one call per version
	if E.db.abm.dbConverted ~= ABM.version then
		E.db.abm.dbConverted = ABM.version

		DBMigration() -- Version 1.08 -> 1.09
		DBMigration2() -- Version 1.11 -> 1.12
	end
end
