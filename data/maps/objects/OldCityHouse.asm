	object_const_def

OldCityHouse_Object:
	db $00 ; border block

	def_warp_events
	warp_event  3,  7, OLD_CITY, 12
	warp_event  4,  7, OLD_CITY, 12

	def_bg_events

	def_object_events

	def_warps_to OLD_CITY_HOUSE
