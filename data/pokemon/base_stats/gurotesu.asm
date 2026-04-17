	db DEX_GUROTESU ; 182

	db  60,  65,  60,  30,  80,  50
	;   hp  atk  def  spd  sat  sdf

	db WATER, STEEL ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/gurotesu/front.pic", 0, 1 ; sprite dimensions
	dw GurotesuPicFront, GurotesuPicBack

	db TACKLE, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         DIG,          \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	db BANK(GurotesuPicFront)
