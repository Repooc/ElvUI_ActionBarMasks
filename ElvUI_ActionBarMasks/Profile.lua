local _, _, _, P, _ = unpack(ElvUI)

local defaults = {
	enable = false,
	border = {
		color = { r = 1, g = 1, b = 1, a = 1 },
		style = 'border98',
	},
	general = {
		shape = 'hexagon', -- Valid Values: circle, hexagon, pentagon
	},
	shadow = {
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	proc = {
		enable = true,
		style = 'pixel', -- Valid Values: solid, pixel
		color = { r = 1, g = 1, b = 0, a = 1 },
		reverse = false,
		speed = 10,
		pulse = true,
		spin = true,
	},
}

P.abm = {
	dbConverted = nil, -- use this to let DBConversions run once per profile
	global = CopyTable(defaults),
}
P.abm.global.enable = true
