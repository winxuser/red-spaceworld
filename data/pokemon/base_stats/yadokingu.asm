    db DEX_YADOKINGU ; pokedex id

	db  95,  75,  80,  30, 100
	;   hp  atk  def  spd  spc

	db WATER, PSYCHIC_TYPE ; type
	db 70 ; catch rate
	db 164 ; base exp

	INCBIN "gfx/pokemon/yadokingu/front.pic", 0, 1 ; sprite dimensions
	dw YadokinguPicFront, YadokinguPicBack

	db TACKLE, WATER_GUN, CONFUSION, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   FISSURE,      \
	     DIG,          PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   REST,         PSYWAVE,      TRI_ATTACK,   \
	     SUBSTITUTE,   SURF,         STRENGTH
	; end

	db BANK(YadokinguPicFront)
