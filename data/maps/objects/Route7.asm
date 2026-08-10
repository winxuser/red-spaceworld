Route7_Object:
	db $00 ; border block

	def_warp_events
	warp_event 11,  9, ROUTE_7_GATE, 3
	warp_event 10,  9, ROUTE_7_GATE, 4

	def_bg_events
;	bg_event  3, 13, TEXT_ROUTE7_UNDERGROUND_PATH_SIGN

	def_object_events

	def_warps_to ROUTE_7
