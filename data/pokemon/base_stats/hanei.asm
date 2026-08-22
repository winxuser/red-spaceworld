db DEX_HANEI ; pokedex id

	db  35,  35,  40,  50,  55 ; hp, atk, def, spd, spc
	db GRASS, FLYING ; type
	db 255 ; catch rate
	db 74 ; base exp

	INCBIN "gfx/pokemon/hanei/front.pic", 0, 1 ; sprite dimensions
	dw HaneiPicFront, HaneiPicBack

	db TACKLE, ABSORB, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     REST,         SUBSTITUTE
	; end

	db BANK(HaneiPicFront)
