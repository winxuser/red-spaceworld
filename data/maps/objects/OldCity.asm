OldCity_Object:
	db $00 ; border block

	def_warp_events
	warp_event 27, 28, OLD_CITY_POKECENTER_1F, 1
	warp_event  3, 26, OLD_CITY_MART, 1
	warp_event 26, 14, OLD_CITY_GYM, 1
	warp_event 27, 14, OLD_CITY_GYM, 2
	warp_event 18, 30, ROUTE_1_GATE_1F, 3
	warp_event 19, 30, ROUTE_1_GATE_1F, 4
	def_bg_events

	def_object_events

	def_warps_to OLD_CITY
