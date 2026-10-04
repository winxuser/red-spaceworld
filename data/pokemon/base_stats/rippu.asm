    db DEX_RIPPU ; pokedex id

	db  45,  30,  15,  65,  85
	;   hp  atk  def  spd  spc

	db ICE, ICE ; type
	db 145 ; catch rate
	db 87 ; base exp

	INCBIN "gfx/pokemon/rippu/front.pic", 0, 1 ; sprite dimensions
	dw RippuPicFront, RippuPicBack

	db LICK, POUND, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     PSYCHIC_M,    RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         METRONOME,    REST,         PSYWAVE,      \
	     SUBSTITUTE
	; end

	db BANK(RippuPicFront)
