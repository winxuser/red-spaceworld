Route1P2_Object:
	db $00 ; border block

	def_warp_events
	warp_event  9,  5, REDS_HOUSE_2F, 1
	warp_event  8,  5, REDS_HOUSE_2F, 1

	def_bg_events

	def_object_events

	def_warps_to ROUTE_1_P2
