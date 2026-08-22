db DEX_AKUA ; pokedex id

	db  65,  60,  70,  65,  70
	;   hp   atk  def  spd  spc

	db WATER, WATER ; type
	db 45 ; catch rate
	db 142 ; base exp

	INCBIN "gfx/pokemon/akua/front.pic", 0, 1 ; sprite dimensions
	dw AkuaPicFront, AkuaPicBack

	db TACKLE, TAIL_WHIP, BUBBLE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         DIG,          \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	db BANK(AkuaPicFront)
