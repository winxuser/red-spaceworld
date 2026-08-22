db DEX_JARANRA ; pokedex id

	db  75,  65,  115,  60,  95 ; hp, atk, def, spd, spc
	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 170 ; base exp

	INCBIN "gfx/pokemon/jaranra/front.pic", 0, 1 ; sprite dimensions
	dw JaranraPicFront, JaranraPicBack

	db CONSTRICT, BIND, ABSORB, VINE_WHIP ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	db BANK(JaranraPicFront)
