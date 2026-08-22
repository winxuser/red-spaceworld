db DEX_MIKON ; pokedex id

	db  38,  41,  40,  65,  65 ; hp, atk, def, spd, spc
	db FIRE, FIRE ; type
	db 190 ; catch rate
	db 60 ; base exp

	INCBIN "gfx/pokemon/mikon/front.pic", 0, 1 ; sprite dimensions
	dw MikonPicFront, MikonPicBack

	db SCRATCH, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   REST,         SUBSTITUTE
	; end

	db BANK(MikonPicFront)
