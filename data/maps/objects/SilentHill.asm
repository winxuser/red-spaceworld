	object_const_def
	const_export SILENTHILL_OAK
	const_export SILENTHILL_GIRL
	const_export SILENTHILL_FISHER

SilentHill_Object:
	db $3b ; border block

	def_warp_events
	warp_event  5,  4, REDS_HOUSE_1F, 1
	warp_event  3, 12, NORTH_CITY, 1
	warp_event 14, 11, OAKS_LAB, 1
	warp_event 15, 11, OAKS_LAB, 2
	warp_event 13,  4, SILENT_HILL_POKECENTER, 1

	def_bg_events
	bg_event 10, 11, TEXT_SILENTHILL_OAKSLAB_SIGN
	bg_event  9,  6, TEXT_SILENTHILL_SIGN
	bg_event  8,  4, TEXT_SILENTHILL_PLAYERSHOUSE_SIGN
	bg_event  6, 12, TEXT_SILENTHILL_RIVALSHOUSE_SIGN

	def_object_events
	object_event  8,  8, SPRITE_OAK, STAY, NONE, TEXT_SILENTHILL_OAK
	object_event  6,  7, SPRITE_GIRL, STAY, ANY_DIR, TEXT_SILENTHILL_GIRL
	object_event 15,  7, SPRITE_FISHER, STAY, ANY_DIR, TEXT_SILENTHILL_FISHER

	def_warps_to SILENT_HILL
