db DEX_AKUERIA ; pokedex id

	db  90,  75,  85,  80,  100
	;   hp   atk  def  spd  spc

	db WATER, WATER ; type
	db 45 ; catch rate
	db 208 ; base exp

	INCBIN "gfx/pokemon/akueria/front.pic", 0, 1 ; sprite dimensions
	dw AkueriaPicFront, AkueriaPicBack

	db TACKLE, TAIL_WHIP, BUBBLE, HYDRO_PUMP ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SKULL_BASH,   REST,         SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	db BANK(AkueriaPicFront)
