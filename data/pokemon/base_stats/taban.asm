    db DEX_TABAN ; pokedex id

	db  50,  95, 180,  30,  85
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 60 ; catch rate
	db 110 ; base exp

	INCBIN "gfx/pokemon/taban/front.pic", 0, 1 ; sprite dimensions
	dw TabanPicFront, TabanPicBack

	db BITE, WITHDRAW, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   SURF
	; end

	db BANK(TabanPicFront)
