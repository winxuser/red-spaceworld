	object_const_def
	const_export OLDCITYSCHOOL_BRUNETTE_GIRL
	const_export OLDCITYSCHOOL_COOLTRAINER_F

OldCitySchool_Object:
	db $00 ; border block

	def_warp_events
	warp_event  3, 15, OLD_CITY, 7
	warp_event  4, 15, OLD_CITY, 7

	def_bg_events

	def_object_events
	object_event  3,  5, SPRITE_BRUNETTE_GIRL, STAY, UP, TEXT_OLDCITYSCHOOL_BRUNETTE_GIRL
	object_event  4,  1, SPRITE_COOLTRAINER_F, STAY, DOWN, TEXT_OLDCITYSCHOOL_COOLTRAINER_F

	def_warps_to OLD_CITY_SCHOOL
