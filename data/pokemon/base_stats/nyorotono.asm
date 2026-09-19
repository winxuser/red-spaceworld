    db DEX_NYOROTONO ; pokedex id

	db  90,  75,  75,  70,  90
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 45 ; catch rate
	db 185 ; base exp

	INCBIN "gfx/pokemon/nyorotono/front.pic", 0, 1 ; sprite dimensions
	dw NyorotonoPicFront, NyorotonoPicBack

	db WATER_GUN, HYPNOSIS, DOUBLESLAP, BODY_SLAM ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   FISSURE,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    \
	     REST,         PSYWAVE,      SUBSTITUTE,   SURF,         STRENGTH
	; end

	db BANK(NyorotonoPicFront)
