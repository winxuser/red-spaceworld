	object_const_def
	const_export ROUTE18_COOLTRAINER_M1
	const_export ROUTE18_COOLTRAINER_M2
	const_export ROUTE18_COOLTRAINER_M3

Route18_Object:
	db $29 ; border block

	def_warp_events
	warp_event 8,  5, ROUTE_18_GATE, 1
	warp_event 9,  5, ROUTE_18_GATE, 2

	def_bg_events
	bg_event 42,  7, TEXT_ROUTE18_SIGN
	bg_event 32,  5, TEXT_ROUTE18_CYCLING_ROAD_SIGN

	def_object_events
	object_event 36, 11, SPRITE_COOLTRAINER_M, STAY, RIGHT, TEXT_ROUTE18_COOLTRAINER_M1, OPP_BIRD_KEEPER, 8
	object_event 40, 15, SPRITE_COOLTRAINER_M, STAY, LEFT, TEXT_ROUTE18_COOLTRAINER_M2, OPP_BIRD_KEEPER, 9
	object_event 42, 13, SPRITE_COOLTRAINER_M, STAY, LEFT, TEXT_ROUTE18_COOLTRAINER_M3, OPP_BIRD_KEEPER, 10

	def_warps_to ROUTE_18
