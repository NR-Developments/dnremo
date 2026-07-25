fx_version 'bodacious'
game 'gta5'

author 'NR-Developments'
description 'NP Emote System - Complete Emote & Animation Framework'
version '2.0.0'

-- Dependencies for proper resource loading order
dependencies {
	'npx',
	'focusmanager',
	'isPed',
	'np-sync',
	'np-cleanup',
}

-- Ensure all sub-resources are available
ensure npx
ensure focusmanager
ensure isPed
ensure np-sync
ensure np-cleanup
