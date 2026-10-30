	object_const_def

OldCityTower5F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  5,  5, OLD_CITY_TOWER_4F, 2

	def_bg_events

	def_object_events

	def_warps_to OLD_CITY_TOWER_5F
