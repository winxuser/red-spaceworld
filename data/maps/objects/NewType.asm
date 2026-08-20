NewType_Object:
	db $0 ; border block

	def_warp_events
	warp_event 18,  5, ROUTE_16_GATE, 1
	warp_event 19,  5, ROUTE_16_GATE, 2

	def_bg_events

	def_object_events

	def_warps_to NEW_TYPE
