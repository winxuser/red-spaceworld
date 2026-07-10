	object_const_def
	const_export ROUTE1_YOUNGSTER1
	const_export ROUTE1_YOUNGSTER2

Route1_Object:
	db $00 ; border block

	def_warp_events
	warp_event  8, 8, SILENT_HILLS, 8
	warp_event  8, 9, SILENT_HILLS, 9


	def_bg_events
	bg_event 20,  8, TEXT_ROUTE1_SIGN

	def_object_events
	object_event 14,  8, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_ROUTE1_YOUNGSTER1
	object_event 17, 11, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE1_YOUNGSTER2

	def_warps_to ROUTE_1
