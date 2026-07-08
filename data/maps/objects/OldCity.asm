OldCity_Object:
	db $00 ; border block

	def_warp_events
	warp_event 18, 30, SILENT_HILL, 2
	warp_event 27, 28, OLD_CITY_POKECENTER_1F, 1
	def_bg_events

	def_object_events

	def_warps_to OLD_CITY
