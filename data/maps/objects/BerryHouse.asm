	object_const_def
	const_export BERRYHOUSE_MIKAN

BerryHouse_Object:
	db $00 ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_MIKAN, STAY, LEFT, TEXT_BERRYHOUSE_MIKAN

	def_warps_to BERRY_HOUSE
