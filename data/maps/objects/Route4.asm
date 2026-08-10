	object_const_def
	const_export ROUTE4_TM_WHIRLWIND

Route4_Object:
	db $00 ; border block

	def_warp_events
	warp_event 12, 48, WEST_GATE, 3
	warp_event 13, 48, WEST_GATE, 4

	def_bg_events
	bg_event 27,  7, TEXT_ROUTE4_SIGN

	def_object_events
	object_event 57,  3, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE4_TM_WHIRLWIND, TM_WHIRLWIND

	def_warps_to ROUTE_4
