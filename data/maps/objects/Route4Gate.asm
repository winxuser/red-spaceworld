WestGate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  7, WEST_CITY, 2
	warp_event  5,  7, WEST_CITY, 3
	warp_event  4,  0, ROUTE_4, 1
	warp_event  5,  0, ROUTE_4, 2

	def_bg_events

	def_object_events

	def_warps_to WEST_GATE
