Route16Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  7, NEW_TYPE, 1
	warp_event  5,  7, NEW_TYPE, 2
	warp_event  4,  0, ROUTE_16, 1
	warp_event  5,  0, ROUTE_16, 2


	def_bg_events

	def_object_events


	def_warps_to ROUTE_16_GATE
