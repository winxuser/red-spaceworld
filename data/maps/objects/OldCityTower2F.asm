	object_const_def
	const_export OLDCITYTOWER2F_RIVAL
;	const_export POKEMONTOWER2F_CHANNELER

OldCityTower2F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  0,  1, OLD_CITY_TOWER_1F, 3
	warp_event  7,  7, OLD_CITY_TOWER_3F, 1

	def_bg_events

	def_object_events
	object_event 14,  5, SPRITE_BLUE, STAY, NONE, TEXT_OLDCITYTOWER2F_RIVAL
;	object_event  3,  7, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER2F_CHANNELER

	def_warps_to OLD_CITY_TOWER_2F
