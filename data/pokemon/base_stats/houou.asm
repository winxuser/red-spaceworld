    db DEX_HOUOU ; pokedex id

	db 106, 130,  90,  90, 154
	;   hp  atk  def  spd  spc

	db FIRE, FLYING ; type
	db 3 ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/houou/front.pic", 0, 1 ; sprite dimensions
	dw HououPicFront, HououPicBack

	db GUST, QUICK_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   \
	     SWIFT,        REST,         SUBSTITUTE,   FLY,          FLASH
	; end

	db BANK(HououPicFront)
