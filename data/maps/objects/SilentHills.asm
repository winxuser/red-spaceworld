	object_const_def
	const_export SILENTHILLS_YOUNGSTER1
	const_export SILENTHILLS_YOUNGSTER2
	const_export SILENTHILLS_YOUNGSTER3
	const_export SILENTHILLS_YOUNGSTER4
	const_export SILENTHILLS_COOLTRAINER_F
	const_export SILENTHILLS_YOUNGSTER5

SilentHills_Object:
	db $08 ; border block

	def_warp_events
	warp_event  4,  0, ROUTE_1_P2, 3
	warp_event  5,  0, ROUTE_1_P2, 3
	warp_event  6,  0, ROUTE_1_P2, 3
	warp_event  7,  0, ROUTE_1_P2, 4
	warp_event  8,  0, ROUTE_1_P2, 4
	warp_event  9,  0, ROUTE_1_P2, 4
	warp_event 49, 28, ROUTE_1, 1
	warp_event 49, 29, ROUTE_1, 1
	warp_event 49, 30, ROUTE_1, 2
	warp_event 49, 31, ROUTE_1, 2

	def_bg_events
	bg_event 47, 28, TEXT_SILENTHILLS_TRAINER_TIPS1
	bg_event  9,  2, TEXT_SILENTHILLS_LEAVING_SIGN

	def_object_events
	object_event 16, 43, SPRITE_YOUNGSTER, STAY, NONE, TEXT_SILENTHILLS_YOUNGSTER1
	object_event 26, 26, SPRITE_YOUNGSTER, STAY, RIGHT, TEXT_SILENTHILLS_YOUNGSTER2, OPP_BUG_CATCHER, 1
	object_event 30,  7, SPRITE_YOUNGSTER, STAY, DOWN, TEXT_SILENTHILLS_YOUNGSTER3, OPP_BUG_CATCHER, 2
	object_event  7, 21, SPRITE_YOUNGSTER, STAY, LEFT, TEXT_SILENTHILLS_YOUNGSTER4, OPP_BUG_CATCHER, 3
	object_event 13, 17, SPRITE_YOUNGSTER, STAY, LEFT, TEXT_SILENTHILLS_YOUNGSTER5, OPP_BUG_CATCHER, 15


	def_warps_to SILENT_HILLS
