	object_const_def


OldCityPokecenter2F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  0,  7, OLD_CITY_POKECENTER_1F, 3

	def_bg_events

	def_object_events

	def_warps_to OLD_CITY_POKECENTER_2F
