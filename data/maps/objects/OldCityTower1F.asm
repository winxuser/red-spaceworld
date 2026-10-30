	object_const_def
	const_export OLDCITYTOWER1F_RECEPTIONIST

OldCityTower1F_Object:
	db $00 ; border block

	def_warp_events
	warp_event 3, 7, OLD_CITY, 10
	warp_event 4, 7, OLD_CITY, 11
	warp_event 0, 1, OLD_CITY_TOWER_2F, 1

	def_bg_events

	def_object_events
	object_event  7,  6, SPRITE_LINK_RECEPTIONIST, STAY, LEFT, TEXT_OLDCITYTOWER1F_RECEPTIONIST

	def_warps_to OLD_CITY_TOWER_1F
