	db DEX_HOHO ; pokedex id

	db  60,  30,  30,  50,  56
	;   hp   atk  def  spd  spc

	db FLYING, FLYING ; type
	db 255 ; catch rate
	db 56 ; base exp

	INCBIN "gfx/pokemon/hoho/front.pic", 0, 1 ; sprite dimensions
	dw HohoPicFront, HohoPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	db BANK(HohoPicFront)
