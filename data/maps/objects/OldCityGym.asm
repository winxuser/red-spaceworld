	object_const_def
	const_export OLDCITYGYM_MIKON
	const_export OLDCITYGYM_COOLTRAINER_M
	const_export OLDCITYGYM_GYM_GUIDE

OldCityGym_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4, 17, OLD_CITY, 3
	warp_event  5, 17, OLD_CITY, 4

	def_bg_events

	def_object_events
	object_event  5,  1, SPRITE_BROCK, STAY, DOWN, TEXT_OLDCITYGYM_MIKON, OPP_BROCK, 1
	object_event  0, 10, SPRITE_COOLTRAINER_M, STAY, RIGHT, TEXT_OLDCITYGYM_COOLTRAINER_M, OPP_JR_TRAINER_M, 1
	object_event  7, 15, SPRITE_GYM_GUIDE, STAY, DOWN, TEXT_OLDCITYGYM_GYM_GUIDE

	def_warps_to OLD_CITY_GYM
