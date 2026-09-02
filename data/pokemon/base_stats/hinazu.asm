db DEX_HINAZU ; pokedex id

	db  35,  70,  35,  65,  35
	;   hp  atk  def  spd  spc

	db NORMAL, FLYING ; type
	db 190 ; catch rate
	db 78 ; base exp

	INCBIN "gfx/pokemon/hinazu/front.pic", 0, 1 ; sprite dimensions
	dw HinazuPicFront, HinazuPicBack

	db PECK, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         SUBSTITUTE,   \
	     FLY
	; end

	db BANK(HinazuPicFront)
