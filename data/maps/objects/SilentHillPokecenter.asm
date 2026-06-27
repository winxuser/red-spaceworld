	object_const_def
	const_export SILENTHILLPOKECENTER_NURSE
	const_export SILENTHILLPOKECENTER_LINK_RECEPTIONIST

SilentHillPokecenter_Object:
	db $00 ; border block

	def_warp_events
	warp_event  5,  7, SILENT_HILL, 5
	warp_event  6,  7, SILENT_HILL, 5

	def_bg_events

	def_object_events
	object_event  5,  1, SPRITE_NURSE, STAY, DOWN, TEXT_SILENTHILLPOKECENTER_NURSE
	object_event  9,  1, SPRITE_LINK_RECEPTIONIST, STAY, DOWN, TEXT_SILENTHILLPOKECENTER_LINK_RECEPTIONIST

	def_warps_to SILENT_HILL_POKECENTER
