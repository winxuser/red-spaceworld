OldCity_Object:
	db $00 ; border block

	def_warp_events
	warp_event 27, 28, OLD_CITY_POKECENTER_1F, 1
	warp_event  3, 26, OLD_CITY_MART, 1
	warp_event 26, 14, OLD_CITY_GYM, 1
	warp_event 27, 14, OLD_CITY_GYM, 2
	warp_event 18, 30, ROUTE_1_GATE_1F, 3
	warp_event 19, 30, ROUTE_1_GATE_1F, 4
	warp_event 22, 26, OLD_CITY_SCHOOL, 1
	warp_event  4, 14, OLD_CITY_MUSEUM, 1
	warp_event  5, 14, OLD_CITY_MUSEUM, 2
	warp_event 11, 17, OLD_CITY_TOWER_1F, 1
	warp_event 12, 17, OLD_CITY_TOWER_1F, 2
	warp_event 10, 26, OLD_CITY_HOUSE, 1
	warp_event  3, 31, OLD_CITY_KURTS_HOUSE, 1

	def_bg_events

	def_object_events

	def_warps_to OLD_CITY
