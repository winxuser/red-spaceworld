	object_const_def


Route2House_Object:
	db $00 ; border block

	def_warp_events
	warp_event  3,  7, ROUTE_2, 2
	warp_event  4,  7, ROUTE_2, 2

	def_bg_events

	def_object_events

	def_warps_to ROUTE_2_HOUSE
