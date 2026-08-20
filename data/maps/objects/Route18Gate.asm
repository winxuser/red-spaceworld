	object_const_def

Route18Gate_Object:
	db $a ; border block

	def_warp_events
	warp_event  4,  7, ROUTE_18, 1
	warp_event  5,  7, ROUTE_18, 2
	warp_event  4,  0, ROUTE_19, 3
	warp_event  5,  0, ROUTE_19, 4


	def_bg_events

	def_object_events

	def_warps_to ROUTE_18_GATE
