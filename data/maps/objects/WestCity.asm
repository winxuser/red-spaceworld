WestCity_Object:
	db $00 ; border block

	def_warp_events
	warp_event 35, 15, ROUTE_2_GATE, 3
	warp_event 22,  5, WEST_GATE, 1
	warp_event 23,  5, WEST_GATE, 2

	def_bg_events

	def_object_events

	def_warps_to WEST_CITY
