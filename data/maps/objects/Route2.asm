	object_const_def


Route2_Object:
	db $00 ; border block

	def_warp_events
	warp_event  6,  5, ROUTE_2_GATE, 1

	def_bg_events
	bg_event 24, 10, TEXT_ROUTE2_SIGN
	bg_event 14,  5, TEXT_ROUTE2_DIGLETTS_CAVE_SIGN

	def_object_events


	def_warps_to ROUTE_2
