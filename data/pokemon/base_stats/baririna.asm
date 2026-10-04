    db DEX_BARIRINA ; pokedex id

	db  20,  25,  45,  60,  70
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 145 ; catch rate
	db 62 ; base exp

	INCBIN "gfx/pokemon/baririna/front.pic", 0, 1 ; sprite dimensions
	dw BaririnaPicFront, BaririnaPicBack

	db BARRIER, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         METRONOME,    REST,         PSYWAVE,      SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(BaririnaPicFront)
