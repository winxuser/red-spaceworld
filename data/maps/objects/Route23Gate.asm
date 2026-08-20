Route23Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  8,  7, KANTO, 1
	warp_event  9,  7, KANTO, 1
	warp_event  0,  7, ROUTE_23, 1
	warp_event  1,  7, ROUTE_23, 1

	def_bg_events

	def_object_events

	def_warps_to ROUTE_23_GATE
