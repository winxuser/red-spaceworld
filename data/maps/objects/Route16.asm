	object_const_def
	const_export ROUTE16_BIKER1
	const_export ROUTE16_BIKER2
	const_export ROUTE16_BIKER3
	const_export ROUTE16_BIKER4
	const_export ROUTE16_BIKER5
	const_export ROUTE16_BIKER6
	const_export ROUTE16_SNORLAX

Route16_Object:
	db $21 ; border block

	def_warp_events
	warp_event  8, 48, ROUTE_16_GATE, 3
	warp_event  9, 48, ROUTE_16_GATE, 4

	def_bg_events
	bg_event 27, 11, TEXT_ROUTE16_CYCLING_ROAD_SIGN
	bg_event  5, 17, TEXT_ROUTE16_SIGN

	def_object_events
	object_event 17, 12, SPRITE_BIKER, STAY, LEFT, TEXT_ROUTE16_BIKER1, OPP_BIKER, 5
	object_event 14, 13, SPRITE_BIKER, STAY, RIGHT, TEXT_ROUTE16_BIKER2, OPP_CUE_BALL, 1
	object_event 11, 12, SPRITE_BIKER, STAY, UP, TEXT_ROUTE16_BIKER3, OPP_CUE_BALL, 2
	object_event  9, 11, SPRITE_BIKER, STAY, LEFT, TEXT_ROUTE16_BIKER4, OPP_BIKER, 6
	object_event  6, 10, SPRITE_BIKER, STAY, RIGHT, TEXT_ROUTE16_BIKER5, OPP_CUE_BALL, 3
	object_event  3, 12, SPRITE_BIKER, STAY, RIGHT, TEXT_ROUTE16_BIKER6, OPP_BIKER, 7
	object_event 26, 10, SPRITE_SNORLAX, STAY, DOWN, TEXT_ROUTE16_SNORLAX

	def_warps_to ROUTE_16
