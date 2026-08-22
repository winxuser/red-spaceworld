    db DEX_BOBO ; pokedex id

	db 100,  50,  50,  70,  96
	;   hp   atk  def  spd  spc

	db FLYING, FLYING ; type
	db 90 ; catch rate
	db 162 ; base exp

	INCBIN "gfx/pokemon/bobo/front.pic", 0, 1 ; sprite dimensions
	dw BoboPicFront, BoboPicBack

	db TACKLE, GROWL, QUICK_ATTACK, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	db BANK(BoboPicFront)
