db DEX_MONJA ; pokedex id

	db  45,  35,  65,  40,  50 ; hp, atk, def, spd, spc
	db GRASS, GRASS ; type
	db 255 ; catch rate
	db 65 ; base exp

	INCBIN "gfx/pokemon/monja/front.pic", 0, 1 ; sprite dimensions
	dw MonjaPicFront, MonjaPicBack

	db CONSTRICT, BIND, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	db BANK(MonjaPicFront)
