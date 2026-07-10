Route1Gate1F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  7, ROUTE_1_P2, 1
	warp_event  5,  7, ROUTE_1_P2, 2
	warp_event  4,  0, OLD_CITY, 5
	warp_event  5,  0, OLD_CITY, 6
	def_bg_events

	def_object_events

	def_warps_to ROUTE_1_GATE_1F
