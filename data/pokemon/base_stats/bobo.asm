	db DEX_BOBO ; pokedex id

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db FLYING, FLYING ; type
	db 120 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/bobo/front.pic", 0, 1 ; sprite dimensions
	dw BoboPicFront, BoboPicBack

	db TACKLE, GROWL, PECK, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	db BANK(BoboPicFront)
